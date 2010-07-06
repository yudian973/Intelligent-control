/*****************************************************************
* Filename     :  EM78P520_32PIN44PIN_TX.ASM
* Author       :  yu.wei
* Company      :  ELAN
* VERSION      :  1.1
* CRYSTAL      :  8MHZ
* Creat date   :  2009/11/4
* tool ver.    :  WicePlus 2.7/eUIDE
* Description  :  modify for code conformity
*****************************************************************/
P520SkipFreqFunc.ASM    EQU    P520SkipFreqFunc.ASM

ifndef EM78CtrlIns.H
include "D:\include\EM78xx\EM78CtrlIns.H"
endif

ifndef keyscan.asm
include "keyscan.asm"
endif

;---------------------------------------------------------



	ORG                 0X400    ; PAGE 1
	MESSAGE "define 'P520SkipFreqFun.ASM' ROM address"
;***************************************************************
; Search mode
;***************************************************************
Search_Equipment:
	WDTC
	BANK                0
	;MOV                 A,@0x07               ; N=250,P=256,f=8MHz ==> T=8ms
	;MOV                 TWTCR,A
	MOV                 A,@(256-250)           ; load initial value
	MOV                 TCC,A
	LCALL               RF_FREQ_SET
	LCALL               RESET_RF_FIFO
	LCALL               Enter_StandbyII_Mode
	LCALL               ENTER_RX_BUFFER_NACK
	NOP

Detected_Connect_Key:
;=========================== SLEEP ==============================
SearchSleep_Status_Judge:
	JBS                 IntoSleepFlag/16,IntoSleepFlag%16
	JMP                 SearchSleep_Status_Judge_End
Wakeup_status_judeg:
	DISI
	LCALL               RF_SLEEP
	LCALL               MCU_EnterSleep_Set
	BANK                0
	BC                  LED1_STATUS/16,LED1_STATUS%16
	ENI
	NOP
	SLEP                                                 ; enter Sleep mode
	NOP
	LCALL               MCU_WakeUp_Set
;-------------------- initial --------------------------------------
	BANK                0
	BC                  AT93C46_CS/16,AT93C46_CS%16      ; Disable 93C46
	BS                  SPI_SS/16,SPI_SS%16              ; Disable EM198810
;-------------------------------------------------------------
	;CALL                SearchLinkMode_Set
	BS                  SearchStatusFlag/16,SearchStatusFlag%16            ;set search mode
	BC                  NormalStatusFlag/16,NormalStatusFlag%16            ;Clear normal mode
	BC                  LoseFrameStatusFlag/16,LoseFrameStatusFlag%16      ;Clear LoseFreq mode
	BS                  LinkModeFlag/16,LinkModeFlag%16
	BC                  ForceLinkModeFlag/16,ForceLinkModeFlag%16
	BC                  FccTestModeFlag/16,FccTestModeFlag%16
;-------------------------------------------------------------
	LCALL               EM198850_RESET
	LCALL               RESET_RF_FIFO
	LCALL               CHANGE_ADDRESS_VALUE
	LCALL               ENTER_RX_BUFFER_NACK
	NOP
SearchSleep_Status_Judge_End:
	BC                  IntoSleepFlag/16,IntoSleepFlag%16
;======================================================================

	;BANK                0
	;MOV                 A,@0x07                ; N=31,P=256,f=8MHz ==> T=1ms
	;MOV                 TWTCR,A

	LCALL               ConnectKey_Scan
	JBS                 KeyScanFinishFlag/16,KeyScanFinishFlag%16
	JMP                 Keystoke_No_Press

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

	BC                  KeyScanFinishFlag/16,KeyScanFinishFlag%16
;-------------------------------------------------------------------------
Keystoke_No_Press:
	BANK                0
Waiting_For_SearchData_Arrive:
	MOV                 A,ComuClock                  ; 8ms Interrupt ,8ms*1=8ms
	SUB                 A,@0                         ; (ComuSyncTime-1)
	JBS                 STATUS,C
	JMP                 Search_Detect_Timeout        ; RX1  ; Timeout but have not received TX data
	JBS                 PKT_FLAG/16,PKT_FLAG%16	     ; 1:TX data receive finished  0:wating PKT pull high
	JMP                 Detected_Connect_Key
;-----------------------------------------------------------------------------------
	NOP
	;LCALL               LoseFrameLinkMode_Set
	BC                  SearchStatusFlag/16,SearchStatusFlag%16            ;set search mode
	BC                  NormalStatusFlag/16,NormalStatusFlag%16            ;Clear normal mode
	BS                  LoseFrameStatusFlag/16,LoseFrameStatusFlag%16      ;Clear LoseFreq mode

	BANK                0
	;MOV                 A,@0x07              ; N=31,P=256,f=8MHz ==> T=1ms
	;MOV                 TWTCR,A
	MOV                 A,@(256-32)           ; Rload TCC value
	MOV                 TCC,A
	MOV                 A,@0X20               ; (test)P85 exchange when intrrupt
	XOR                 PORT8,A

	CLR                 ComuClock
	LCALL               Enter_StandbyII_Mode
	NOP
	NOP
;-----------------------------------------------------------------------------------
	LCALL               READ_FIFO_RAM
	LCALL               RESET_RF_FIFO
	NOP
	NOP
	JBC                 ReadLengthError/16,ReadLengthError%16
	JMP                 Search_Detect_Timeout
	JBC                 ForceLinkModeFlag/16,ForceLinkModeFlag%16
	JMP                 ForceLink_Mode_Task
	CLR                 ComuCycleNum
	CLR                 ComuEndNum

;------------------- check sync imformation ---------------------
	BANK                1
	MOV                 A,RX_IDH
	BANK                0
	XOR                 RX_IDH_Buffer,A
	JBS                 STATUS,Z
	JMP                 Search_Equipment      ;RX_ID_ERROR
	BANK                1
	MOV                 A,RX_IDL
	BANK                0
	XOR                 RX_IDL_Buffer,A
	JBS                 STATUS,Z
	JMP                 Search_Equipment      ;RX_ID_ERROR
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
	MESSAGE             "TX_ID = (RX_IDL&0XF0)|N, {N=1,2,3,4...}"
SearchComu_Cycle_work:
	BANK                1
	CLR                 ComuCycleNum
	MOV                 A,TX_ID
	AND                 A,@0X0F
	MOV                 DataShiftCounter,A        ;decode ComuCycleNum by TX_ID
	DEC                 DataShiftCounter
	JBC                 STATUS,Z
	JMP                 ComuCycleNum_End
ComuCycleNum_Loop:
	MOV                 A,@ComuTime
	ADD                 ComuCycleNum,A
	DJZ                 DataShiftCounter
	JMP                 ComuCycleNum_Loop
ComuCycleNum_End:
	NOP

	BANK                0
	SWAPA               N_CHN_Buffer          ;decode ComuEndNum  by N_CHN
	AND                 A,@0X0F
	MOV                 DataShiftCounter,A          ;End communicate cycle
ComuEndNum_Loop:
	MOV                 A,@ComuTime
	ADD                 ComuEndNum,A
	DJZ                 DataShiftCounter
	JMP                 ComuEndNum_Loop
	DEC                 ComuEndNum

;-------------------------------------------------------------------------------
	MOV                 A,ComuClock           ; wait the communicate time arrive
	SUB                 A,ComuCycleNum
	JBC                 STATUS,C
	JMP                 $-3
;-------------------------------------------------------------------------------
    ;MOV                 A,@16                 ; Transmitter data ,SYNC HEAD = 7 byte
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
    MOV                 A,CommuStatusFlag
    MOV                 CommuStatusFlag_Buffer,A
    BANK                1
    MOV                 A,DirectionCtrl
    BANK                0
    MOV                 DirectionCtrl_Buffer,A
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

	LCALL               Enter_TX_Buffer_ACK
	LCALL               WRITE_FIFO_RAM
	LCALL               Enter_StandbyI_Mode

	NOP
	BANK                1
	JBC                 ForceLinkModeFlag/16,ForceLinkModeFlag%16
	JMP                 Write_EEprom_Task
	CLR                 LossframeCNT
;-------------------------------------------------------------------------------

	;LCALL               Key_Scan
;-------------------------------------------------
	;LCALL               NormalLinkMode_Set
	BC                  SearchStatusFlag/16,SearchStatusFlag%16            ;Clear search status
	BS                  NormalStatusFlag/16,NormalStatusFlag%16            ;set normal mode
	BC                  LoseFrameStatusFlag/16,LoseFrameStatusFlag%16      ;Clear LoseFreq mode
	BS                  LinkModeFlag/16,LinkModeFlag%16
	BC                  ForceLinkModeFlag/16,ForceLinkModeFlag%16
	BC                  FccTestModeFlag/16,FccTestModeFlag%16

;-------------------------------------------------------------------------------
	MOV                 A,ComuClock           ;wait the manage time arrive
	SUB                 A,ComuEndNum
	JBC                 STATUS,C
	JMP                 $-3
;-------------------------------------------------------------------------------
	NOP
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
	BS                  SearchStatusFlag/16,SearchStatusFlag%16            ;set search mode
	BC                  NormalStatusFlag/16,NormalStatusFlag%16            ;Clear normal mode
	BC                  LoseFrameStatusFlag/16,LoseFrameStatusFlag%16      ;Clear LoseFreq mode

	BANK                1
	INC                 CH_NO
	MOV                 A,CH_NO
	SUB                 A,@ChannelSum
	JBS                 STATUS,C
	CLR                 CH_NO
	CLR                 ComuClock
	LCALL               RF_FREQ_SET
	;BANK                0
	;MOV                 A,@0B00100000          ; (test)P85 exchange when intrrupt
	;XOR                 PORT8,A
	NOP
	BANK                0

;---------------------------- LED Control --------------------------------
	JBS                 ForceLinkModeFlag/16,ForceLinkModeFlag%16
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
	BS                  LED1_STATUS/16,LED1_STATUS%16		;PORT81
  LED_End_Control:
	NOP
;--------------------------------------------------------------------------

	BC                  ReadLengthError/16,ReadLengthError%16
	CLR                 Databytelength
	CLR                 RX_IDH_Buffer
	CLR                 RX_IDL_Buffer
	CLR                 CHN_FLAG_Buffer
	CLR                 N_CHN_Buffer
	CLR                 TX_ID_Buffer
	LCALL               Enter_StandbyII_Mode
	LCALL               RESET_RF_FIFO		         ; REGISTER=82  INITIAL=0X80 CLEAR TX POINT
	LCALL               ENTER_RX_BUFFER_NACK
	NOP
	NOP
	JMP                 Detected_Connect_Key




;**********************************************************************************
;*********************************************************************************
; FCC test mode frequency index
;*********************************************************************************
Click_Select:
	NOP
	JBS                 FccTestModeFlag/16,FccTestModeFlag%16
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
	NOP
	;LCALL               FccSearchLinkMode_Set
	;BC                  LinkModeFlag/16,LinkModeFlag%16
	;BS                  ForceLinkModeFlag/16,ForceLinkModeFlag%16
	BC                  FccTestModeFlag/16,FccTestModeFlag%16
	NOP
	JMP                 Detected_Connect_Key


;**********************************************************************************
;*********************************************************************************
; Into force link mode
;*********************************************************************************
Dblclick_Select:                                  ; Into Forcelink Mode:
	NOP
	BANK                1
	;LCALL               SearchForceLinkMode_Set
	BC                  LinkModeFlag/16,LinkModeFlag%16
	BS                  ForceLinkModeFlag/16,ForceLinkModeFlag%16
	BC                  FccTestModeFlag/16,FccTestModeFlag%16

	MOV                 A,@RX_IDH_DEFAULT         ; Address , default value 0X0DB3
	MOV                 RX_IDH,A
	MOV                 A,@RX_IDL_DEFAULT
	MOV                 RX_IDL,A
	LCALL               CHANGE_ADDRESS_VALUE
	NOP
	JMP                 Keystoke_No_Press

;---------------------------------------------------------------
Write_EEprom_Task:
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
	MOV                 A,TX_ID
	BANK                0
	MOV                 TX_ID_Buffer,A
	BANK                1
	MOV                 A,N_CHN
	BANK                0
	MOV                 N_CHN_Buffer,A
	NOP

	LCALL               IO_93C46_INITIAL
	mEWEN                                      ; Enable
	NOP
	MOV                 A,@0X00
	MOV                 DataAddressInEEPROM,A
	MOV                 A,@0X60
	MOV                 DataAddressInMCU,A
 	mWRITE              DataAddressInEEPROM,@0,DataAddressInMCU,@16
 	mEWDS                                      ; disable
 	LCALL               IO_93C46_QUIT
 	NOP
 	;BANK                0
	;MOV                 A,@0x07
	;MOV                 TWTCR,A
	LCALL               CHANGE_ADDRESS_VALUE
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
	BS                  SearchStatusFlag/16,SearchStatusFlag%16            ;set search mode
	BC                  NormalStatusFlag/16,NormalStatusFlag%16            ;Clear normal mode
	BC                  LoseFrameStatusFlag/16,LoseFrameStatusFlag%16      ;Clear LoseFreq mode
	BS                  LinkModeFlag/16,LinkModeFlag%16
	BC                  ForceLinkModeFlag/16,ForceLinkModeFlag%16
	BC                  FccTestModeFlag/16,FccTestModeFlag%16

	BANK                0
	BC                  AT93C46_CS/16,AT93C46_CS%16    ; Disable 93C46
	BS                  SPI_SS/16,SPI_SS%16            ; Disable EM198810
	JMP                 Detected_Connect_Key
	NOP



;**********************************************************************************
;*************************************************************************
; Normal communicate
;*************************************************************************
	ORG                 0X800   ; PAGE 2
Normal_Communicate:
Lossframe_Communicate:
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
	LCALL               Enter_StandbyII_Mode
	LCALL               ENTER_RX_BUFFER_NACK
	BANK                0

Waiting_For_NormalData_arrive:
	MOV                 A,ComuClock                    ; "T=ComuTime" a cycle ,
	SUB                 A,@(ComuSyncTime-1)            ; CMD time, "T=ComuTime"
	JBS                 STATUS,C                       ; Sync Timing no recive any data
	JMP                 LoseFrameStatus_Timeout        ; RX1  ; Timeout but have not received TX data
	JBS                 PKT_FLAG/16,PKT_FLAG%16	       ; 1:TX data receive finished  0:wating PKT pull high
	JMP                 Waiting_For_NormalData_arrive
;-----------------------------------------------------------------------------------
	BANK                0
	;MOV                 A,@0x07                ; N=31,P=256,f=8MHz ==> T=1ms
	;MOV                 TWTCR,A
	MOV                 A,@(256-31)           ;Rload TCC value
	MOV                 TCC,A                  ;adjust time by PKT sync
	CLR                 ComuClock
	MOV                 A,@0X20               ; (test)P85 exchange when intrrupt
	XOR                 PORT8,A

	LCALL               READ_FIFO_RAM
	LCALL               Enter_StandbyI_Mode
	JBC                 ReadLengthError/16,ReadLengthError%16
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
	BC                  SearchStatusFlag/16,SearchStatusFlag%16            ;Clear search status
	BS                  NormalStatusFlag/16,NormalStatusFlag%16            ;set normal mode
	BC                  LoseFrameStatusFlag/16,LoseFrameStatusFlag%16      ;Clear LoseFreq mode
	BS                  LinkModeFlag/16,LinkModeFlag%16
	BC                  ForceLinkModeFlag/16,ForceLinkModeFlag%16
	BC                  FccTestModeFlag/16,FccTestModeFlag%16
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
	XOR                 A,@0X7F
	JBS                 STATUS,Z
	JMP                 NormalSleep_Status_Judge_End1
	MOV                 A,DataB
	XOR                 A,@0X7F
	JBS                 STATUS,Z
	JMP                 NormalSleep_Status_Judge_End1
	;MOV                 A,DataC
	;XOR                 A,@0X7F
	;JBS                 STATUS,Z
	;JMP                 NormalSleep_Status_Judge_End1
	;MOV                 A,DataD
	;XOR                 A,@0X7F
	;JBS                 STATUS,Z
	;JMP                 NormalSleep_Status_Judge_End1
	MOV                 A,DataE
	XOR                 A,@0X00
	JBS                 STATUS,Z
	JMP                 NormalSleep_Status_Judge_End1
	;MOV                 A,DataF
	;XOR                 A,@0X7F
	;JBS                 STATUS,Z
	;JMP                 NormalSleep_Status_Judge_End1
	MOV                 A,DataG
	XOR                 A,@0X0F
	JBS                 STATUS,Z
	JMP                 NormalSleep_Status_Judge_End1

	JBS                 IntoSleepFlag/16,IntoSleepFlag%16
	JMP                 NormalSleep_Status_Judge_End2
	;LCALL               SearchLinkMode_Set
	BS                  SearchStatusFlag/16,SearchStatusFlag%16            ;set search mode
	BC                  NormalStatusFlag/16,NormalStatusFlag%16            ;Clear normal mode
	BC                  LoseFrameStatusFlag/16,LoseFrameStatusFlag%16
	CLR                 ComuClock
	CLR                 CH_NO
	RET
NormalSleep_Status_Judge_End1:
	CLR                 SleepCNT
NormalSleep_Status_Judge_End2:
	NOP

;===================================================================
    MOV                 A,@14                         ;Transmitter data ,7 byte
    MOV                 Databytelength,A
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

    MOV                 A,CommuStatusFlag
    MOV                 CommuStatusFlag_Buffer,A

    BANK                1
    MOV                 A,DirectionCtrl
    BANK                0
    MOV                 DirectionCtrl_Buffer,A

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

	LCALL               Enter_StandbyII_Mode
	LCALL               Enter_TX_Buffer_ACK
	LCALL               Write_FIFO_RAM
	LCALL               Enter_StandbyI_Mode
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
	BC                  ReadLengthError/16,ReadLengthError%16
	CLR                 Databytelength
	CLR                 RX_IDH_Buffer
	CLR                 RX_IDL_Buffer
	CLR                 CHN_FLAG_Buffer
	CLR                 N_CHN_Buffer
	CLR                 TX_ID_Buffer
	BANK                1
	;LCALL               LoseFrameLinkMode_Set
	BC                  SearchStatusFlag/16,SearchStatusFlag%16            ;set search mode
	BC                  NormalStatusFlag/16,NormalStatusFlag%16            ;Clear normal mode
	BS                  LoseFrameStatusFlag/16,LoseFrameStatusFlag%16
	MOV                 A,LossframeCNT                    ;LossframeCNT>1 stand for loss frequency
	SUB                 A,@LossframeSum
	JBS                 STATUS,C
	JMP                 LoseFreqStatus_Timeout
	INC                 LossframeCNT
	JMP                 Lossframe_Communicate

LoseFreqStatus_Timeout:
	;LCALL               SearchLinkMode_Set
	BS                  SearchStatusFlag/16,SearchStatusFlag%16            ;set search mode
	BC                  NormalStatusFlag/16,NormalStatusFlag%16            ;Clear normal mode
	BC                  LoseFrameStatusFlag/16,LoseFrameStatusFlag%16
	BANK                1
	CLR                 ComuClock
	CLR                 ComuCycleNum
	CLR                 ComuEndNum
	CLR                 LossframeCNT
	CLR                 CHN_FLAG
	RET                                                ;return to search status
	NOP

;==========================================================================
; data Sampling function
;==========================================================================
Sampling_Task:
	LCALL                Key_Scan              ;get key data
	;LCALL               CmosSensor_Function
	;LCALL               GS_Sensor
	NOP
	RET
;==========================================================================




