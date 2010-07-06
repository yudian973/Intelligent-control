;==================================================================
; Filename     :  EM78M611
; Author       :  yu.wei
; Company      :  ELAN
; VERSION      :  4.0
; CRYSTAL      :  6MHZ
; Creat date   :  2009/11/4
; tool ver.    :  eUIDE
; Description  :  modify for code conformity,multi-1v2 CMOS project
;=========================================================================
M611SkipFreqFunc.ASM    EQU    M611SkipFreqFunc.ASM

include "M611SkipFreqFunc.h"
include "M611ManageFunc.ASM"

ifndef M611rxP40.H
include "M611rxP40.H"
endif

ifndef EM78CtrlIns.H
include "EM78CtrlIns.H"
endif

;=========================================================================



	ORG                 0X200    ;PAGE 0
  if MassageDisplay == 1
	MESSAGE "define 'M611SKIPFREQFUN.ASM' ROM address"
  endif
;=======================================================================
; Sync    Communication function
; input:  none
; output: none
;=======================================================================
SYNC_COM_TX:
	CLR                 ComuClock
	WDTC
	PAGE                5
	CALL                Reset_RF_FIFO
	CALL                Enter_StandbyII_Mode
	CALL                RF_FREQ_SET
	PAGE                4
 	CALL                CommTypeScan_Func
 	PAGE                0
 	NOP
	Clearbuffer
;-----------------------------------------------------------------
	MOV                 A,ComuClock                  ; ComuClock == 6 will continue
	SUB                 A,@0
	JBC                 STATUS,C
	JMP                 $-3
;-----------------------------------------------------------------
	CALL                PAGE0BANK0
	MOV                 A,@0X00
	MOV                 PID_DATA_Buffer,A            ;PID_DATA
	CALL                PAGE0BANK1
	MOV                 A,RX_IDH
	CALL                PAGE0BANK0
	MOV                 RX_IDH_Buffer,A              ;RX_IDH
	CALL                PAGE0BANK1
	MOV                 A,RX_IDL
	CALL                PAGE0BANK0
	MOV                 RX_IDL_Buffer,A              ;RX_IDL
	CALL                PAGE0BANK1
	MOV                 A,CHN_FLAG
	CALL                PAGE0BANK0
	MOV                 CHN_FLAG_Buffer,A            ;CHN_FLAG
	CALL                PAGE0BANK1
	MOV                 A,@GamePadsSum_Default
	CALL                PAGE0BANK0
	MOV                 GamePadsSum_Buffer,A         ;GamePadsSum

	MOV                 A,CommuStatusFlag
	MOV                 CommuStatusFlag_Buffer,A     ;CommuStatusFlag
	CALL                PAGE0BANK1
	MOV                 A,CH_NO
	CALL                PAGE0BANK0
	MOV                 CH_NO_Buffer,A               ;CH_NO

	JBC                 ForceLinkModeFlag/8,ForceLinkModeFlag%8
	JMP                 Loading_Forcelink_Data
	JMP                 Loading_Communication_Data
  Loading_Forcelink_Data:
	CALL                PAGE0BANK1
	MOV                 A,TX1_ID                     ;TX1_ID
	CALL                PAGE0BANK0
	MOV                 TX1_ID_Buffer,A
	CALL                PAGE0BANK1
	MOV                 A,TX2_ID                     ;TX2_ID
	CALL                PAGE0BANK0
	MOV                 TX2_ID_Buffer,A
	JMP                 Loading_Data_End
  Loading_Communication_Data:
	CALL                PAGE0BANK1
	MOV                 A,MOTOR_ID
	CALL                PAGE0BANK0
	MOV                 MOTOR_ID_Buffer,A
	CALL                PAGE0BANK2
	MOV                 A,MOTOR1_VibrInten
	CALL                PAGE0BANK0
	MOV                 MOTOR1_VibrInten_Buffer,A
	CALL                PAGE0BANK3
	MOV                 A,MOTOR2_VibrInten
	CALL                PAGE0BANK0
	MOV                 MOTOR2_VibrInten_Buffer,A
  Loading_Data_End:
	MOV                 A,@SetChecksumH
	MOV                 ChecksumH,A
	MOV                 A,@SetChecksumL
	MOV                 ChecksumL,A
	NOP

;-------------------------------------------------------------------
	MOV                 A,@7
	PAGE                5
	CALL                DELAY_X100US
	CALL                Enter_TX_Buffer_NACK
	CALL                Write_FIFO_RAM
	PAGE                0
;---------------------------------------------------------------------------------
	MOV                 A,@(256-47)               ; N=47,P=64,f=4MHz ==> T=1ms
	MOV                 TCC,A                     ; TCC reload by PKT pull high
  if COMMU_T_DEBUG & COMMU_DEBUG & DebugDisplay == 1
	MOV                 A,@0X80                   ; (test)P57 exchange when intrrupt
	XOR                 PORT5,A
  endif
	CLR                 ComuClock                 ; ComuClock = 0
;-----------------------------------------------------------------------------------
	NOP
	RET
	NOP

;*****************************************************************
;Function:    Mode select
;Input:
;Output:      None
;desciption:  set timing and select mode
;*****************************************************************
SearchLinkMode_Set: ;0x11
	BS                  SearchStatusFlag/8,SearchStatusFlag%8            ;set search mode
	BC                  NormalStatusFlag/8,NormalStatusFlag%8            ;Clear normal mode
	BC                  EEpromWRStatusFlag/8,EEpromWRStatusFlag%8
	BS                  LinkModeFlag/8,LinkModeFlag%8
	BC                  ForceLinkModeFlag/8,ForceLinkModeFlag%8
	BC                  FccTestModeFlag/8,FccTestModeFlag%8
	RET
NormalLinkMode_Set: ;0x12
	BC                  SearchStatusFlag/8,SearchStatusFlag%8            ;set search mode
	BS                  NormalStatusFlag/8,NormalStatusFlag%8            ;Clear normal mode
	BC                  EEpromWRStatusFlag/8,EEpromWRStatusFlag%8
	BS                  LinkModeFlag/8,LinkModeFlag%8
	BC                  ForceLinkModeFlag/8,ForceLinkModeFlag%8
	BC                  FccTestModeFlag/8,FccTestModeFlag%8
	RET
SearchForceLinkMode_Set: ;0x21
	BS                  SearchStatusFlag/8,SearchStatusFlag%8            ;set search mode
	BC                  NormalStatusFlag/8,NormalStatusFlag%8            ;Clear normal mode
	BC                  EEpromWRStatusFlag/8,EEpromWRStatusFlag%8
	BC                  LinkModeFlag/8,LinkModeFlag%8
	BS                  ForceLinkModeFlag/8,ForceLinkModeFlag%8
	BC                  FccTestModeFlag/8,FccTestModeFlag%8
	RET
NormalFccLinkMode_Set: ;0x42
	BC                  SearchStatusFlag/8,SearchStatusFlag%8            ;set search mode
	BS                  NormalStatusFlag/8,NormalStatusFlag%8            ;Clear normal mode
	BC                  EEpromWRStatusFlag/8,EEpromWRStatusFlag%8
	BC                  LinkModeFlag/8,LinkModeFlag%8
	BC                  ForceLinkModeFlag/8,ForceLinkModeFlag%8
	BS                  FccTestModeFlag/8,FccTestModeFlag%8
	RET



;***************************************************************************
; gamepad skip frequency RX1-RX4
;***************************************************************************
	ORG                 0X400    ;PAGE 1
;========================================================================
;=========================================================================
;Function:  setting
;Input:
;Output:    None
;=========================================================================
RX1_FUNCTION:
	WDTC
	PAGE                5
	CALL                RESET_RF_FIFO
	CALL                Enter_StandbyII_Mode
	CALL                ENTER_RX_BUFFER_ACK
	PAGE                1

  RX1_DETECT_LOOP:
	MOV                 A,ComuClock                  ;ComuClock == 4 will continue
	SUB                 A,@3
	JBS                 STATUS,C
	JMP                 RX1_Detect_Timeout           ; RX1,Timeout but have not received TX data
	JBS                 PKT_FLAG/8,PKT_FLAG%8	     ; 1:TX data receive finished  0:wating PKT pull high
	JMP                 RX1_DETECT_LOOP
	NOP
	Clearbuffer
	PAGE                5
	CALL                READ_FIFO_RAM
	CALL                Enter_StandbyII_Mode
	PAGE                1

;------------------- check sync imformation ---------------------
	CALL                PAGE1BANK1
	MOV                 A,RX_IDH
	CALL                PAGE1BANK0
	XOR                 RX_IDH_Buffer,A
	JBS                 STATUS,Z
	JMP                 LoseFrameStatus_RxTxID1_Error  ; RX_IDH ERROR
	CALL                PAGE1BANK1
	MOV                 A,RX_IDL
	CALL                PAGE1BANK0
	XOR                 RX_IDL_Buffer,A
	JBS                 STATUS,Z
	JMP                 LoseFrameStatus_RxTxID1_Error  ; RX_IDL ERROR
	CALL                PAGE1BANK1
	MOV                 A,TX1_ID
	CALL                PAGE1BANK0
	XOR                 TX_ID_Buffer,A
	JBS                 STATUS,Z
	JMP                 LoseFrameStatus_RxTxID1_Error  ; TX_ID ERROR
	NOP

;---------------------------------------------------------------
	CALL                PAGE1BANK0                       ; Save data from buffer to local
	MOV                 A,DataA_Buffer
	CALL                PAGE1BANK2
	MOV                 TX1_DATA1,A
	CALL                PAGE1BANK0
	MOV                 A,DataB_Buffer
	CALL                PAGE1BANK2
	MOV                 TX1_DATA2,A
	CALL                PAGE1BANK0
	MOV                 A,DataC_Buffer
	CALL                PAGE1BANK2
	MOV                 TX1_DATA3,A
	CALL                PAGE1BANK0
	MOV                 A,DataD_Buffer
	CALL                PAGE1BANK2
	MOV                 TX1_DATA4,A
	CALL                PAGE1BANK0
	MOV                 A,DataE_Buffer
	CALL                PAGE1BANK2
	MOV                 TX1_DATA5,A
	CALL                PAGE1BANK0
	MOV                 A,DataF_Buffer
	CALL                PAGE1BANK2
	MOV                 TX1_DATA6,A
	CALL                PAGE1BANK0
	MOV                 A,DataG_Buffer
	CALL                PAGE1BANK2
	MOV                 TX1_DATA7,A

	CALL                PAGE1BANK0
	MOV                 A,CMOS_xAxisL_Buffer
	CALL                PAGE1BANK2
	MOV                 TX1_CMOS_xAxisL,A          ; CMOS x Axis low byte
	CALL                PAGE1BANK0
	MOV                 A,CMOS_yAxisL_Buffer
	CALL                PAGE1BANK2
	MOV                 TX1_CMOS_yAxisL,A          ; CMOS y Axis low byte
	CALL                PAGE1BANK0
	MOV                 A,CMOS_yxsAxisH_Buffer
	CALL                PAGE1BANK2
	MOV                 TX1_CMOS_yxsAxisH,A        ; CMOS point size low byte

	CALL                PAGE1BANK0
	MOV                 A,GS_xAxisL_Buffer
	CALL                PAGE1BANK2
	MOV                 TX1_GS_xAxisL,A            ; GS x Axis low byte
	CALL                PAGE1BANK0
	MOV                 A,GS_yAxisL_Buffer
	CALL                PAGE1BANK2
	MOV                 TX1_GS_yAxisL,A            ; GS y Axis low byte
	CALL                PAGE1BANK0
	MOV                 A,GS_zAxisL_Buffer
	CALL                PAGE1BANK2
	MOV                 TX1_GS_zAxisL,A            ; GS z Axis low byte
	CALL                PAGE1BANK0
	MOV                 A,GS_xyzAxisH_Buffer
	CALL                PAGE1BANK2
	MOV                 TX1_GS_xyzAxisH,A          ; GS z Axis high byte

	CALL                PAGE1BANK1
	BS                  CHN_FLAG,RX1
	JBS                 ForceLinkModeFlag/8,ForceLinkModeFlag%8
	JMP                 EP1_REPORT_RX1
	JBC                 CHN_FLAG_TEMP,RX1             ; CHN_FLAG rising edge
	JMP                 Clear_RX1_LossframeCNT
	BC                  LED1_STATUS/8,LED1_STATUS%8   ;
	CLR                 SystemTimeCNT
	JMP                 Clear_RX1_LossframeCNT
	NOP

;-------------------------------------------------------------------------
  Rx1_Detect_Timeout:
	NOP
	CALL                PAGE1BANK1
	JBS                 CHN_FLAG,RX1                              ; Lossframe Status
	JMP                 Clear_RX1_LossframeCNT                    ; if not SearchStatus,it must be in NormalStatus
	MOV                 A,RX1_LossframeCNT                        ; result = constant - variable
	SUB                 A,@RX1_LossframeSum                       ;   | result > 0   c=1  variable less than constant
	JBC                 STATUS,C	                              ;   | result < 0   c=0  variable more than constant
	JMP                 Increase_RX1_LossframeCNT
	JBS                 ForceLinkModeFlag/8,ForceLinkModeFlag%8
	BC                  CHN_FLAG,RX1
	JMP                 Clear_RX1_LossframeCNT
	NOP
;-----------------------------------------------------------------------------
  LoseFrameStatus_RxTxID1_Error:
	NOP
	CALL                PAGE1BANK1
	JBS                 CHN_FLAG,RX1
	JMP                 Clear_RX1_LossframeCNT
	MOV                 A,RX1_LossframeCNT                       ; RX1_LossframeSum times lossframe
	SUB                 A,@RX1_LossframeSum
	JBC                 STATUS,C
	JMP                 Increase_RX1_LossframeCNT
	JBS                 ForceLinkModeFlag/8,ForceLinkModeFlag%8
	BC                  CHN_FLAG,RX1
	JMP                 Clear_RX1_LossframeCNT
	NOP

;--------------------------------------------------------------------------------
  Increase_RX1_LossframeCNT:
	NOP
	INC                 RX1_LossframeCNT
	MOV                 A,@RX1
	MOV                 EP1_ReportID,A
	PAGE                4
	CALL                EP1_Report_Default
	PAGE                1
	JMP                 RX1_Over_Judge
	NOP
  EP1_REPORT_RX1:
	PAGE                4
	CALL                EP1_Report_1st
	PAGE                1
  Clear_RX1_LossframeCNT:
	CLR                 RX1_LossframeCNT
  RX1_Over_Judge:
	MOV                 A,ComuClock                  ; ComuClock == 4 will continue
	SUB                 A,@3
	JBC                 STATUS,C
	JMP                 $-3
	BS                  SPI_SS/8,SPI_SS%8          ; Dissable RF
	NOP
	RET
	NOP



;========================================================================
;=========================================================================
;Function:  setting
;Input:     LossFrameCNTCNT,LossFreqCNT,DataBaseAddress
;Output:    None
;=========================================================================
RX2_FUNCTION:
	WDTC
	PAGE                5
	CALL                RESET_RF_FIFO
	CALL                Enter_StandbyII_Mode
	CALL                ENTER_RX_BUFFER_ACK
	PAGE                1

  RX2_DETECT_LOOP:
	MOV                 A,ComuClock                  ;ComuClock == 4 will continue
	SUB                 A,@7
	JBS                 STATUS,C
	JMP                 RX2_Detect_Timeout           ; RX2,Timeout but have not received TX data
	JBS                 PKT_FLAG/8,PKT_FLAG%8	     ; 1:TX data receive finished  0:wating PKT pull high
	JMP                 RX2_DETECT_LOOP
	NOP
	Clearbuffer
	PAGE                5
	CALL                READ_FIFO_RAM
	CALL                Enter_StandbyII_Mode
	PAGE                1

;------------------- check sync imformation ---------------------
	CALL                PAGE1BANK1
	MOV                 A,RX_IDH
	CALL                PAGE1BANK0
	XOR                 RX_IDH_Buffer,A
	JBS                 STATUS,Z
	JMP                 LoseFrameStatus_RxTxID2_Error  ; RX_IDH ERROR
	CALL                PAGE1BANK1
	MOV                 A,RX_IDL
	CALL                PAGE1BANK0
	XOR                 RX_IDL_Buffer,A
	JBS                 STATUS,Z
	JMP                 LoseFrameStatus_RxTxID2_Error  ; RX_IDL ERROR
	CALL                PAGE1BANK1
	MOV                 A,TX2_ID
	CALL                PAGE1BANK0
	XOR                 TX_ID_Buffer,A
	JBS                 STATUS,Z
	JMP                 LoseFrameStatus_RxTxID2_Error  ; TX_ID ERROR
	NOP

;---------------------------------------------------------------
	CALL                PAGE1BANK0                       ; Save data from buffer to local
	MOV                 A,DataA_Buffer
	CALL                PAGE1BANK2
	MOV                 TX2_DATA1,A
	CALL                PAGE1BANK0
	MOV                 A,DataB_Buffer
	CALL                PAGE1BANK2
	MOV                 TX2_DATA2,A
	CALL                PAGE1BANK0
	MOV                 A,DataC_Buffer
	CALL                PAGE1BANK2
	MOV                 TX2_DATA3,A
	CALL                PAGE1BANK0
	MOV                 A,DataD_Buffer
	CALL                PAGE1BANK2
	MOV                 TX2_DATA4,A
	CALL                PAGE1BANK0
	MOV                 A,DataE_Buffer
	CALL                PAGE1BANK2
	MOV                 TX2_DATA5,A
	CALL                PAGE1BANK0
	MOV                 A,DataF_Buffer
	CALL                PAGE1BANK2
	MOV                 TX2_DATA6,A
	CALL                PAGE1BANK0
	MOV                 A,DataG_Buffer
	CALL                PAGE1BANK2
	MOV                 TX2_DATA7,A

	CALL                PAGE1BANK0
	MOV                 A,CMOS_xAxisL_Buffer
	CALL                PAGE1BANK2
	MOV                 TX2_CMOS_xAxisL,A          ; CMOS x Axis low byte
	CALL                PAGE1BANK0
	MOV                 A,CMOS_yAxisL_Buffer
	CALL                PAGE1BANK2
	MOV                 TX2_CMOS_yAxisL,A          ; CMOS y Axis low byte
	CALL                PAGE1BANK0
	MOV                 A,CMOS_yxsAxisH_Buffer
	CALL                PAGE1BANK2
	MOV                 TX2_CMOS_yxsAxisH,A        ; CMOS point size low byte

	CALL                PAGE1BANK0
	MOV                 A,GS_xAxisL_Buffer
	CALL                PAGE1BANK2
	MOV                 TX2_GS_xAxisL,A            ; GS x Axis low byte
	CALL                PAGE1BANK0
	MOV                 A,GS_yAxisL_Buffer
	CALL                PAGE1BANK2
	MOV                 TX2_GS_yAxisL,A            ; GS y Axis low byte
	CALL                PAGE1BANK0
	MOV                 A,GS_zAxisL_Buffer
	CALL                PAGE1BANK2
	MOV                 TX2_GS_zAxisL,A            ; GS z Axis low byte
	CALL                PAGE1BANK0
	MOV                 A,GS_xyzAxisH_Buffer
	CALL                PAGE1BANK2
	MOV                 TX2_GS_xyzAxisH,A          ; GS z Axis high byte

	CALL                PAGE1BANK1
	BS                  CHN_FLAG,RX2
	JBS                 ForceLinkModeFlag/8,ForceLinkModeFlag%8
	JMP                 EP1_REPORT_RX2
	JBC                 CHN_FLAG_TEMP,RX2             ; CHN_FLAG rising edge
	JMP                 Clear_RX2_LossframeCNT
	BC                  LED1_STATUS/8,LED1_STATUS%8   ;
	CLR                 SystemTimeCNT
	JMP                 Clear_RX2_LossframeCNT
	NOP

;-------------------------------------------------------------------------
  RX2_Detect_Timeout:
	NOP
	CALL                PAGE1BANK1
	JBS                 CHN_FLAG,RX2                              ; Lossframe Status
	JMP                 Clear_RX2_LossframeCNT                    ; if not SearchStatus,it must be in NormalStatus
	MOV                 A,RX2_LossframeCNT                        ; result = constant - variable
	SUB                 A,@RX2_LossframeSum                       ;   | result > 0   c=1  variable less than constant
	JBC                 STATUS,C	                              ;   | result < 0   c=0  variable more than constant
	JMP                 Increase_RX2_LossframeCNT
	JBS                 ForceLinkModeFlag/8,ForceLinkModeFlag%8
	BC                  CHN_FLAG,RX2
	JMP                 Clear_RX2_LossframeCNT
	NOP
;-----------------------------------------------------------------------------
  LoseFrameStatus_RxTxID2_Error:
	NOP
	CALL                PAGE1BANK1
	JBS                 CHN_FLAG,RX2
	JMP                 Clear_RX2_LossframeCNT
	MOV                 A,RX2_LossframeCNT                       ; RX2_LossframeSum times lossframe
	SUB                 A,@RX2_LossframeSum
	JBC                 STATUS,C
	JMP                 Increase_RX2_LossframeCNT
	JBS                 ForceLinkModeFlag/8,ForceLinkModeFlag%8
	BC                  CHN_FLAG,RX2
	JMP                 Clear_RX2_LossframeCNT
	NOP

;--------------------------------------------------------------------------------
  Increase_RX2_LossframeCNT:
	NOP
	INC                 RX2_LossframeCNT
	MOV                 A,@RX2
	MOV                 EP1_ReportID,A
	PAGE                4
	CALL                EP1_Report_Default
	PAGE                1
	JMP                 RX2_Over_Judge
	NOP
  EP1_REPORT_RX2:
	PAGE                4
	CALL                EP1_Report_2nd
	PAGE                1
  Clear_RX2_LossframeCNT:
	CLR                 RX2_LossframeCNT
  RX2_Over_Judge:
	MOV                 A,ComuClock                  ; ComuClock == 4 will continue
	SUB                 A,@7
	JBC                 STATUS,C
	JMP                 $-3
	BS                  SPI_SS/8,SPI_SS%8          ; Dissable RF
	NOP
	RET
	NOP




;========================================================================
;=========================================================================
;Function:  setting
;Input:     LossFrameCNTCNT,LossFreqCNT,DataBaseAddress
;Output:    None
;=========================================================================
RX3_FUNCTION:

	RET


;========================================================================
;=========================================================================
;Function:  setting
;Input:     LossFrameCNTCNT,LossFreqCNT,DataBaseAddress
;Output:    None
;=========================================================================
RX4_FUNCTION:

	RET

;=====================================================================
; BANK exchange function
;=====================================================================
	PAGE1BANK0:
		BC              0X04,7
		BC              0X04,6
	RET
	PAGE1BANK1:
		BC              0X04,7
		BS              0X04,6
	RET
	PAGE1BANK2:
		BS              0X04,7
		BC              0X04,6
	RET
	PAGE1BANK3:
		BS              0X04,7
		BS              0X04,6
	RET



;***************************************************************************
; gamepad skip frequency RX5-RX8
;***************************************************************************
	ORG                 0X800   ;PAGE 2
;========================================================================
;=========================================================================
;Function:  setting
;Input:     LossFrameCNTCNT,LossFreqCNT,DataBaseAddress
;Output:    None
;=========================================================================
RX5_FUNCTION:

	RET




;========================================================================
;=========================================================================
;Function:  setting
;Input:     LossFrameCNTCNT,LossFreqCNT,DataBaseAddress
;Output:    None
;=========================================================================
RX6_FUNCTION:

	RET



;=====================================================================
; BANK exchange function
;=====================================================================
	PAGE2BANK0:
		BC              0X04,7
		BC              0X04,6
	RET
	PAGE2BANK1:
		BC              0X04,7
		BS              0X04,6
	RET
	PAGE2BANK2:
		BS              0X04,7
		BC              0X04,6
	RET
	PAGE2BANK3:
		BS              0X04,7
		BS              0X04,6
	RET