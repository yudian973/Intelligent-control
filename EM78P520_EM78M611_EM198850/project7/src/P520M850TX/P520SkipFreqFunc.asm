/*********************************************************************
* Filename     :  EM78P520P44TX.ASM
* Author       :  yu.wei
* Company      :  KEN YEAR
* VERSION      :  4.0
* CRYSTAL      :  8MHZ
* Creat date   :  2010.06.25
* tool Ver.    :  eUIDE 1.02.11
* Description  :  modify for 2.4G remote control in Intelligen Home
**********************************************************************/
P520SkipFreqFunc.asm    EQU    P520SkipFreqFunc.asm

include "P520SkipFreqFunc.h"

ifndef EM78CtrlIns.H
include "..\..\..\..\include\EM78xx\inc\EM78CtrlIns.H"
endif

ifndef keyscan.asm
include "keyscan.asm"
endif


;---------------------------------------------------------

	ORG                 0X400    ; PAGE 1
  if MassageDisplay == 1
	MESSAGE "define 'P520SkipFreqFun.ASM' ROM address"
  endif
;***************************************************************
; Search mode
;***************************************************************
Search_Equipment:
	WDTC
	BANK                0
	;MOV                 A,@0x07               ; N=125,P=256,f=8MHz ==> T=4ms
	;MOV                 TWTCR,A
	MOV                 A,@(256-125)           ; load initial value
	MOV                 TCC,A
	;LCALL               RF_FREQ_SET
	LCALL               RESET_RF_FIFO
	LCALL               Enter_StandbyII_Mode
	LCALL               ENTER_RX_BUFFER_ACK
	NOP

Search_Start_up:
	LCALL               RF_FREQ_SET

;------------------------------------------------------------------
Detected_Connect_Key:
	;LCALL               Enter_Sleep_Status
	;BANK                0
	;MOV                 A,@0x07                ; N=31,P=256,f=8MHz ==> T=1ms
	;MOV                 TWTCR,A
	;LCALL               ConnectKey_Scan
	
	JBS                 KeyScanFinishFlag/8,KeyScanFinishFlag%8
	JMP                 Keystoke_No_Press

	BANK                2
	MOV                 A,KEY_NUM
	XOR                 A,@00000010B
	JBC                 STATUS,Z
	JMP                 Click_Select                  ;Click Select

	MOV                 A,KEY_NUM
	XOR                 A,@00000011B
	JBC                 STATUS,Z
	JMP                 Lasting_Press_Select          ;Lasting_Press Select

	MOV                 A,KEY_NUM
	XOR                 A,@00000100B
	JBC                 STATUS,Z
	JMP                 Dblclick_Select               ;Dblclick Select

	BC                  KeyScanFinishFlag/8,KeyScanFinishFlag%8


;-------------------------------------------------------------------------
Keystoke_No_Press:
	BANK                0
Waiting_For_SearchData_Arrive:
	MOV                 A,ComuClock                  ; 8ms*ComuClock Interrupt ,
	SUB                 A,@3
	JBS                 STATUS,C
	JMP                 Search_Detect_Timeout        ; RX1  ; Timeout but have not received TX data
	JBS                 PKT_FLAG/8,PKT_FLAG%8	     ; 1:TX data receive finished  0:wating PKT pull high
	JMP                 Detected_Connect_Key
;-----------------------------------------------------------------------------------
	NOP
	;LCALL               LoseFrameLinkMode_Set
	BC                  SearchStatusFlag/8,SearchStatusFlag%8            ;set search mode
	BC                  NormalStatusFlag/8,NormalStatusFlag%8            ;Clear normal mode
	BS                  LoseFrameStatusFlag/8,LoseFrameStatusFlag%8      ;Clear LoseFreq mode

	BANK                0
	;MOV                 A,@0x07              ; N=31,P=256,f=8MHz ==> T=1ms
	;MOV                 TWTCR,A
	MOV                 A,@(256-32)           ; Reload TCC value
	MOV                 TCC,A
	MOV                 A,@0X20               ; (test)P85 exchange when intrrupt
	XOR                 PORT8,A

	CLR                 ComuClock
;-----------------------------------------------------------------------------------
	LCALL               READ_FIFO_RAM
	LCALL               RESET_RF_FIFO
	LCALL               Enter_StandbyI_Mode
	NOP

	NOP
	JBC                 ReadLengthError/8,ReadLengthError%8
	JMP                 Search_Detect_Timeout
	JBC                 ForceLinkModeFlag/8,ForceLinkModeFlag%8
	JMP                 ForceLink_Mode_Task
	CLR                 ComuCycleNum
	CLR                 ComuEndNum

;------------------- check sync imformation ---------------------
	BANK                1
	MOV                 A,RX_IDH
	BANK                0
	XOR                 RX_IDH_Buffer,A
	JBS                 STATUS,Z
	JMP                 Search_Start_up      ;RX_ID_ERROR
	BANK                1
	MOV                 A,RX_IDL
	BANK                0
	XOR                 RX_IDL_Buffer,A
	JBS                 STATUS,Z
	JMP                 Search_Start_up      ;RX_ID_ERROR
;---------------------------------------------------------------------------
	CLR                 TEMP2                 ;CHN_FLAG TEMP
	BANK                1
	MOV                 A,TX_ID               ;
	AND                 A,@0X0F
	MOV                 TEMP,A

	BS                  STATUS,C
	RLC                 TEMP2
	DJZ                 TEMP
	JMP                 $-2
	MOV                 A,TEMP2
	MOV                 CHN_FLAG,A            ;repeat used channel
	BANK                0
	MOV                 CHN_FLAG_Buffer,A

;------------------------------------------------------------------
  if MassageDisplay == 1
	MESSAGE             "TX_ID = (RX_IDL&0XF0)|N, {N=1,2,3,4...}"
  endif
SearchComu_Cycle_work:
	BANK                1
	CLR                 ComuCycleNum
	MOV                 A,TX_ID
	AND                 A,@0X0F
	MOV                 DataShiftCNT,A        ;decode ComuCycleNum by TX_ID
	DEC                 DataShiftCNT
	JBC                 STATUS,Z
	JMP                 ComuCycleNum_End
ComuCycleNum_Loop:
	MOV                 A,@SetComuTime
	ADD                 ComuCycleNum,A
	DJZ                 DataShiftCNT
	JMP                 ComuCycleNum_Loop
ComuCycleNum_End:
	NOP

	BANK                0
	MOV                 A,GamePadsSum_Buffer
	BANK                1
	MOV                 GamePadsSum,A         ; Save GamePadsSum
	MOV                 DataShiftCNT,A        ; End communicate cycle
ComuEndNum_Loop:
	MOV                 A,@SetComuTime
	ADD                 ComuEndNum,A
	DJZ                 DataShiftCNT
	JMP                 ComuEndNum_Loop
	DEC                 ComuEndNum

;-------------------------------------------------------------------------------
	MOV                 A,ComuClock           ; wait the communicate time arrive
	SUB                 A,ComuCycleNum
	JBC                 STATUS,C
	JMP                 $-3
;-------------------------------------------------------------------------------
	;MOV                 A,@16                ; Transmitter data ,SYNC HEAD = 7 byte
	;MOV                 Databytelength,A
	NOP
	BANK                1
	MOV                 A,PID_DATA
	BANK                0
	MOV                 PID_DATA_Buffer,A
	BANK                1
	MOV                 A,RX_IDH
	BANK                0
	MOV                 RX_IDH_Buffer,A
	BANK                1
	MOV                 A,RX_IDL
	BANK                0
	MOV                 RX_IDL_Buffer,A
	BANK                1
	MOV                 A,CHN_FLAG
	BANK                0
	MOV                 CHN_FLAG_Buffer,A
	BANK                1
	MOV                 A,GamePadsSum
	BANK                0
	MOV                 GamePadsSum_Buffer,A
	MOV                 A,CommuStatusFlag
	MOV                 CommuStatusFlag_Buffer,A
	BANK                1
	MOV                 A,CH_NO
	BANK                0
	MOV                 CH_NO_Buffer,A
	BANK                1
	MOV                 A,TX_ID
	BANK                0
	MOV                 TX_ID_Buffer,A

	BANK                0
	MOV                 A,@0X7F
	MOV                 DataA_Buffer,A
	MOV                 DataB_Buffer,A
	MOV                 DataC_Buffer,A
	MOV                 DataD_Buffer,A
	CLR                 DataE_Buffer
	CLR                 DataF_Buffer
	MOV                 A,@0X0F
	MOV                 DataG_Buffer,A

	LCALL               Enter_StandbyII_Mode
	LCALL               Enter_TX_Buffer_ACK
	LCALL               WRITE_FIFO_RAM
	;LCALL               RESET_RF_FIFO
	;LCALL               Enter_StandbyI_Mode

	NOP
	BANK                1
	JBC                 ForceLinkModeFlag/8,ForceLinkModeFlag%8
	JMP                 Write_EEprom_Task
	CLR                 LossframeCNT
;-------------------------------------------------------------------------------

	;LCALL               Key_Scan
;-------------------------------------------------
	;LCALL               NormalLinkMode_Set
	BC                  SearchStatusFlag/8,SearchStatusFlag%8            ;Clear search status
	BS                  NormalStatusFlag/8,NormalStatusFlag%8            ;set normal mode
	BC                  LoseFrameStatusFlag/8,LoseFrameStatusFlag%8      ;Clear LoseFreq mode
	BS                  LinkModeFlag/8,LinkModeFlag%8
	BC                  ForceLinkModeFlag/8,ForceLinkModeFlag%8
	BC                  FccTestModeFlag/8,FccTestModeFlag%8

;-------------------------------------------------------------------------------
	MOV                 A,ComuClock           ;wait the manage time arrive
	SUB                 A,ComuEndNum
	JBC                 STATUS,C
	JMP                 $-3
;-------------------------------------------------------------------------------
	CLR                 ComuClock
	NOP
	RET


ForceLink_Mode_Task:
	BANK                0
	CLR                 TEMP1                 ;TEMP COUNTER
	MOV                 A,CHN_FLAG_Buffer     ;READ CHN_FLAG From Buffer
	MOV                 TEMP,A
	BC                  STATUS,C
	RRC                 TEMP
	INC                 TEMP1
	JBC                 STATUS,C               ;CHN_FLAG: 00,01,03,07,0F,1F,3F,7F
	JMP                 $-3                    ;TX_ID   :  1  2  3  4  5  6  7  8
	MOV                 A,TEMP1
	BANK                1
	MOV                 TX_ID,A

	BANK                0
	MOV                 A,RX_IDH_Buffer        ;RX_IDH
	BANK                1
	MOV                 RX_IDH,A
	BANK                0
	MOV                 A,RX_IDL_Buffer
	BANK                1
	MOV                 RX_IDL,A
	AND                 A,@0XF0
	OR                  TX_ID,A                ; TX_ID = (RX_IDL & OXF0) | (TX_ID & 0X0F)
	JMP                 SearchComu_Cycle_work

Search_Detect_Timeout:
	;LCALL               SearchLinkMode_Set
	BS                  SearchStatusFlag/8,SearchStatusFlag%8            ;set search mode
	BC                  NormalStatusFlag/8,NormalStatusFlag%8            ;Clear normal mode
	BC                  LoseFrameStatusFlag/8,LoseFrameStatusFlag%8      ;Clear LoseFreq mode

	BANK                1
	INC                 CH_NO
	MOV                 A,CH_NO
	SUB                 A,@ChannelSum
	JBS                 STATUS,C
	CLR                 CH_NO
	CLR                 ComuClock
	NOP
	BANK                0

;---------------------------- LED Control --------------------------------
	JBS                 ForceLinkModeFlag/8,ForceLinkModeFlag%8
	JMP                 LED_NormalSearch
	JMP                 LED_ForcelinkSearch
LED_NormalSearch:
	BANK                2
	MOV                 A,LEDSystemTimeCNT
	SUB                 A,@LEDTwinklingFreq   ; Control key scan clock
	JBC                 STATUS,C
	JMP                 LED_End_Control
	CLR                 LEDSystemTimeCNT
	BANK                0
	MOV                 A,@0B00000010         ; P81 exchange when Timeout
	XOR                 PORT8,A
	JMP                 LED_End_Control
LED_ForcelinkSearch:
	BS                  LED1_STATUS/8,LED1_STATUS%8		;PORT81
  LED_End_Control:
	NOP
;--------------------------------------------------------------------------

	BANK                0
	BC                  ReadLengthError/8,ReadLengthError%8
	CLR                 Databytelength
	CLR                 RX_IDH_Buffer
	CLR                 RX_IDL_Buffer
	CLR                 CHN_FLAG_Buffer
	CLR                 GamePadsSum_Buffer
	CLR                 TX_ID_Buffer
	NOP
	NOP
	JMP                 Search_Start_up

;**********************************************************************************
;*********************************************************************************
; FCC test mode frequency index
;*********************************************************************************
Click_Select:
	BANK                2
	CLR                 KEY_NUM
	BC                  KeyScanFinishFlag/8,KeyScanFinishFlag%8
	JBS                 FccTestModeFlag/8,FccTestModeFlag%8
	JMP                 Keystoke_No_Press
	INC                 FccFreqIndex
	MOV                 A,FccFreqIndex
	SUB                 A,@0X0F
	JBS                 STATUS,C
	CLR                 FccFreqIndex
	JMP                 Keystoke_No_Press

;**********************************************************************************
;*********************************************************************************
; Into FCC mode
;*********************************************************************************
Lasting_Press_Select:
	BANK                2
	CLR                 KEY_NUM
	BC                  KeyScanFinishFlag/8,KeyScanFinishFlag%8
	;LCALL               FccSearchLinkMode_Set
	;BC                  LinkModeFlag/8,LinkModeFlag%8
	;BS                  ForceLinkModeFlag/8,ForceLinkModeFlag%8
	BC                  FccTestModeFlag/8,FccTestModeFlag%8
	NOP
	JMP                 Search_Start_up

;**********************************************************************************
;*********************************************************************************
; Into force link mode
;*********************************************************************************
Dblclick_Select:                                  ; Into Forcelink Mode:
	BANK                2
	CLR                 KEY_NUM
	BC                  KeyScanFinishFlag/8,KeyScanFinishFlag%8
	BANK                1
	LCALL               SearchForceLinkMode_Set
	BC                  LinkModeFlag/8,LinkModeFlag%8
	BS                  ForceLinkModeFlag/8,ForceLinkModeFlag%8
	BC                  FccTestModeFlag/8,FccTestModeFlag%8

	MOV                 A,@RX_IDH_DEFAULT         ; Address , default value 0X0DB3
	MOV                 RX_IDH,A
	MOV                 A,@RX_IDL_DEFAULT
	MOV                 RX_IDL,A
	LCALL               CHANGE_ADDRESS_VALUE
	NOP
	CLR                 ComuClock

	;BANK                0
	;MOV                 A,@0B00001000          ; (test)P83 exchange when intrrupt
	;XOR                 PORT8,A

	JMP                 Search_Equipment

;---------------------------------------------------------------
Write_EEprom_Task:
	NOP
	DISI
	NOP
	BANK                1
	MOV                 A,RX_IDH         ; Read ID
	BANK                0
	MOV                 RX_IDH_Buffer,A
	BANK                1
	MOV                 A,RX_IDL
	BANK                0
	MOV                 RX_IDL_Buffer,A
	BANK                1
	MOV                 A,GamePadsSum
	BANK                0
	MOV                 GamePadsSum_Buffer,A
	BANK                1
	MOV                 A,TX_ID
	BANK                0
	MOV                 TX_ID_Buffer,A
	NOP

	LCALL               IO_93C46_INITIAL
	NOP
	mEWEN                                      ; Enable
	MOV                 A,@0X00
	MOV                 DataAddressInEEPROM,A
	MOV                 A,@0X60
	MOV                 DataAddressInMCU,A
 	mWRITE              DataAddressInEEPROM,@0,DataAddressInMCU,@16
 	mEWDS                                      ; disable
 	NOP
 	LCALL               IO_93C46_QUIT
	LCALL               Enter_StandbyII_Mode
	LCALL               CHANGE_ADDRESS_VALUE
 	;BANK                0
	;MOV                 A,@0x07
	;MOV                 TWTCR,A
	NOP
	ENI
	CLR                 ComuClock
	CLR                 ComuCycleNum
	CLR                 ComuEndNum
	CLR                 CommuStatusFlag
	CLR                 GeneralStatusFlag1
	CLR                 GeneralStatusFlag2
	CLR                 CHN_FLAG
	;LCALL               SearchLinkMode_Set
	BS                  SearchStatusFlag/8,SearchStatusFlag%8            ;set search mode
	BC                  NormalStatusFlag/8,NormalStatusFlag%8            ;Clear normal mode
	BC                  LoseFrameStatusFlag/8,LoseFrameStatusFlag%8      ;Clear LoseFreq mode
	BS                  LinkModeFlag/8,LinkModeFlag%8
	BC                  ForceLinkModeFlag/8,ForceLinkModeFlag%8
	BC                  FccTestModeFlag/8,FccTestModeFlag%8
  if EEPROM_T_DEBUG & EEPROM_DEBUG & DebugDisplay == 1
	BANK                0
	MOV                 A,@0B00001000          ; (test)P83 exchange when intrrupt
	XOR                 PORT8,A
  endif
	BANK                0
	BS                  SPI_SS/8,SPI_SS%8           ; Disable EM198810
	BC                  AT93C46_CS/8,AT93C46_CS%8   ; Disable 93C46
	BS                  CMOS_SS/8,CMOS_SS%8         ; Disable CMOS
	WDTC
	;BANK                0
	;MOV                 A,@0x07               ; N=250,P=256,f=8MHz ==> T=8ms
	;MOV                 TWTCR,A
	MOV                 A,@(256-125)           ; load initial value
	MOV                 TCC,A
	;LCALL               RF_FREQ_SET
	LCALL               RESET_RF_FIFO
	LCALL               Enter_StandbyII_Mode
	LCALL               ENTER_RX_BUFFER_NACK
	JMP                 Search_Start_up
	NOP

;**********************************************************************************
;*************************************************************************
; Normal communicate
;*************************************************************************
	ORG                 0X800   ; PAGE 2
Normal_Communicate:
	WDTC
	CLR                 ComuClock
	BANK                1
	MOV                 A,CH_NO
	SUB                 A,@ChannelSum
	JBS                 STATUS,C
	CLR                 CH_NO
	LCALL               RF_FREQ_SET
	LCALL               RESET_RF_FIFO
	CALL                Sampling_Task

;-------------------------------------------------------------------------------
	MOV                 A,ComuClock           ; wait the communicate time arrive
	SUB                 A,@DelayTime
	JBC                 STATUS,C
	JMP                 $-3
;-------------------------------------------------------------------------------

	;LCALL               Enter_StandbyII_Mode
	LCALL               ENTER_RX_BUFFER_NACK
	BANK                0

Waiting_For_NormalData_arrive:
	MOV                 A,ComuClock                    ; "T=SetComuTime" a cycle ,
	SUB                 A,@(SetComuSyncTime-1)            ; CMD time, "T=SetComuTime"
	JBS                 STATUS,C                       ; Sync Timing no recive any data
	JMP                 LoseFrameStatus_Timeout        ; RX1  ; Timeout but have not received TX data
	JBS                 PKT_FLAG/8,PKT_FLAG%8	       ; 1:TX data receive finished  0:wating PKT pull high
	JMP                 Waiting_For_NormalData_arrive
;-----------------------------------------------------------------------------------
	BANK                0
	;MOV                 A,@0x07                       ; N=31,P=256,f=8MHz ==> T=1ms
	;MOV                 TWTCR,A
	MOV                 A,@(256-31)           ;Rload TCC value
	MOV                 TCC,A                  ;adjust time by PKT sync
	CLR                 ComuClock
  if COMMU_T_DEBUG & COMMU_DEBUG & DebugDisplay == 1
	MOV                 A,@0X20               ; (test)P85 exchange when intrrupt
	XOR                 PORT8,A
  endif
	LCALL               READ_FIFO_RAM
	LCALL               RESET_RF_FIFO
	LCALL               Enter_StandbyI_Mode
	JBC                 ReadLengthError/8,ReadLengthError%8
	JMP                 LoseFrameStatus_Timeout

;------------------- check sync imformation ---------------------
	BANK                1
	MOV                 A,RX_IDH
	BANK                0
	XOR                 RX_IDH_Buffer,A
	JBS                 STATUS,Z
	JMP                 LoseFrameStatus_Timeout         ;host computer ID error
	BANK                1
	MOV                 A,RX_IDL
	BANK                0
	XOR                 RX_IDL_Buffer,A
	JBS                 STATUS,Z
	JMP                 LoseFrameStatus_Timeout         ;host computer ID error
;------------------------------------------------------------------
	BANK                1
	;LCALL               NormalLinkMode_Set
	BC                  SearchStatusFlag/8,SearchStatusFlag%8            ;Clear search status
	BS                  NormalStatusFlag/8,NormalStatusFlag%8            ;set normal mode
	BC                  LoseFrameStatusFlag/8,LoseFrameStatusFlag%8      ;Clear LoseFreq mode
	BS                  LinkModeFlag/8,LinkModeFlag%8
	BC                  ForceLinkModeFlag/8,ForceLinkModeFlag%8
	BC                  FccTestModeFlag/8,FccTestModeFlag%8
	CLR                 LossframeCNT

	;RRCA                ComuEndNum
	;MOV                 TEMP,A
	;MOV                 A,ComuCycleNum
	;SUB                 A,TEMP
	;JBS                 STATUS,C
	;CALL                Sampling_Task
;-------------------------------------------------------------------------------
	MOV                 A,ComuClock           ; wait the communicate time arrive
	SUB                 A,ComuCycleNum
	JBC                 STATUS,C
	JMP                 $-3
;-------------------------------------------------------------------------------
	;RRCA                ComuEndNum
	;MOV                 TEMP,A
	;MOV                 A,ComuCycleNum
	;SUB                 A,TEMP
	;JBC                 STATUS,C
	;CALL               Sampling_Task

;------------------ sleep status judge --------------------------
NormalSleep_Status_Judge:
	BANK                2
	MOV                 A,DataA
	XOR                 A,DataB
	XOR                 A,DataC
	XOR                 A,DataD
	XOR                 A,DataE
	XOR                 A,DataF
	XOR                 A,DataG
	MOV                 TEMP,A
	XOR                 A,KeyCheckBakup
	JBS                 STATUS,Z
	JMP                 NormalSleep_Status_Judge_End1

	MOV                 A,SleepCNT
	SUB                 A,@SetSleepTime        ;
	JBC                 STATUS,C
	JMP                 NormalSleep_Status_Judge_End2
	BS                  IntoSleepFlag/8,IntoSleepFlag%8
	CLR                 SleepCNT
  if SLEEP_T_DEBUG & SLEEP_DEBUG & DebugDisplay == 1
	BANK                0
	MOV                 A,@0B00001000          ; (test)P83 exchange when intrrupt
	XOR                 PORT8,A
  endif
	;LCALL               SearchLinkMode_Set
	BS                  SearchStatusFlag/8,SearchStatusFlag%8            ;set search mode
	BC                  NormalStatusFlag/8,NormalStatusFlag%8            ;Clear normal mode
	BC                  LoseFrameStatusFlag/8,LoseFrameStatusFlag%8
	CLR                 ComuClock
	CLR                 CH_NO
	BANK                0
	BC                  AT93C46_CS/8,AT93C46_CS%8   ; Disable 93C46
	BS                  CMOS_SS/8,CMOS_SS%8         ; Disable CMOS
	LCALL               Enter_StandbyII_Mode
	NOP
	RET
  NormalSleep_Status_Judge_End1:
	CLR                 SleepCNT
  NormalSleep_Status_Judge_End2:
	MOV                 A,TEMP
	MOV                 KeyCheckBakup,A

;===================================================================
    ;MOV                 A,@14                         ;Transmitter data ,7 byte
    ;MOV                 Databytelength,A
    Clearbuffer
    BANK                1
    MOV                 A,RX_IDH                     ;sync header
    BANK                0
    MOV                 RX_IDH_Buffer,A
    BANK                1
    MOV                 A,RX_IDL
    BANK                0
    MOV                 RX_IDL_Buffer,A
    BANK                1
    MOV                 A,CHN_FLAG
    BANK                0
    MOV                 CHN_FLAG_Buffer,A
    BANK                1
    MOV                 A,GamepadsSum
    BANK                0
    MOV                 GamepadsSum_Buffer,A
    MOV                 A,CommuStatusFlag
    MOV                 CommuStatusFlag_Buffer,A
    BANK                1
    MOV                 A,CH_NO
    BANK                0
    MOV                 CH_NO_Buffer,A
    BANK                1
    MOV                 A,TX_ID
    BANK                0
    MOV                 TX_ID_Buffer,A

    BANK                2                            ;Data output
    MOV                 A,DataA
    BANK                0
    MOV                 DataA_Buffer,A
    BANK                2
    MOV                 A,DataB
    BANK                0
    MOV                 DataB_Buffer,A
    BANK                2
    MOV                 A,DataC
    BANK                0
    MOV                 DataC_Buffer,A
	BANK                2
    MOV                 A,DataD
    BANK                0
    MOV                 DataD_Buffer,A
    BANK                2
    MOV                 A,DataE
    BANK                0
    MOV                 DataE_Buffer,A
    BANK                2
    MOV                 A,DataF
    BANK                0
    MOV                 DataF_Buffer,A
    BANK                2
    MOV                 A,DataG
    BANK                0
    MOV                 DataG_Buffer,A

    BANK                5
    MOV                 A,CMOS_xAxisL
    BANK                0
    MOV                 CMOS_xAxisL_Buffer,A
    BANK                5
    MOV                 A,CMOS_yAxisL
    BANK                0
    MOV                 CMOS_yAxisL_Buffer,A
    BANK                5
    MOV                 A,CMOS_yxsAxisH
    BANK                0
    MOV                 CMOS_yxsAxisH_Buffer,A

	BANK                7
	MOV                 A,GS_xAxisL
	BANK                0
	MOV                 GS_xAxisL_Buffer,A            ; GS x Axis low byte
	BANK                7
	MOV                 A,GS_yAxisL
	BANK                0
	MOV                 GS_yAxisL_Buffer,A            ; GS y Axis low byte
	BANK                7
	MOV                 A,GS_zAxisL
	BANK                0
	MOV                 GS_zAxisL_Buffer,A            ; GS z Axis low byte
	BANK                7
	MOV                 A,GS_xyzAxisH
	BANK                0
	MOV                 GS_xyzAxisH_Buffer,A          ; GS xyz Axis low byte

	MOV                 A,@SetChecksumH
	MOV                 ChecksumH,A
	MOV                 A,@SetChecksumL
	MOV                 ChecksumL,A

	LCALL               Enter_StandbyII_Mode
	LCALL               Enter_TX_Buffer_ACK
	LCALL               Write_FIFO_RAM
	LCALL               RESET_RF_FIFO
	LCALL               Enter_StandbyII_Mode
	NOP

;--------------------------- Wating a cycle end --------------------------------------
	MOV                 A,ComuClock           ;wait the manage time arrive
	SUB                 A,ComuEndNum
	JBC                 STATUS,C
	JMP                 $-3
;--------------------------------------------------------------------------------------
	NOP
	NOP
	JMP                 Normal_Communicate    ; a cycle End

;============================================================================================
LoseFrameStatus_Timeout:
	CLR                 ComuClock
	MOV                 A,ComuEndNum
	SUB                 A,ComuClock                       ;2ms a cycle ,
	JBC                 STATUS,C
	JMP                 $-3
	NOP
LoseFrameStatus_RXID_Error:
	BANK                0
	BC                  ReadLengthError/8,ReadLengthError%8
	CLR                 Databytelength
	CLR                 RX_IDH_Buffer
	CLR                 RX_IDL_Buffer
	CLR                 CHN_FLAG_Buffer
	CLR                 GamePadsSum_Buffer
	CLR                 TX_ID_Buffer
	BANK                1
	;LCALL               LoseFrameLinkMode_Set
	BC                  SearchStatusFlag/8,SearchStatusFlag%8            ;set search mode
	BC                  NormalStatusFlag/8,NormalStatusFlag%8            ;Clear normal mode
	BS                  LoseFrameStatusFlag/8,LoseFrameStatusFlag%8
	MOV                 A,LossframeCNT                    ;LossframeCNT>1 stand for loss frequency
	SUB                 A,@LossframeSum
	JBS                 STATUS,C
	JMP                 LoseFreqStatus_Timeout
	INC                 LossframeCNT
	JMP                 Normal_Communicate

LoseFreqStatus_Timeout:
	;LCALL               SearchLinkMode_Set
	BS                  SearchStatusFlag/8,SearchStatusFlag%8            ;set search mode
	BC                  NormalStatusFlag/8,NormalStatusFlag%8            ;Clear normal mode
	BC                  LoseFrameStatusFlag/8,LoseFrameStatusFlag%8
	BANK                1
	CLR                 ComuClock
	CLR                 ComuCycleNum
	CLR                 ComuEndNum
	CLR                 LossframeCNT
	CLR                 CHN_FLAG
	RET                                       ; return to search status
	NOP

;==========================================================================
; data Sampling function
;==========================================================================
Sampling_Task:
	LCALL               Key_Scan              ; get key data

	NOP
	RET


