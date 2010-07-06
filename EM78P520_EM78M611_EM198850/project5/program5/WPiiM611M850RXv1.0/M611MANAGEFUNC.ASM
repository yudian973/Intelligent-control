;==================================================================
; Filename     :  EM78M611
; Author       :  yu.wei
; Company      :  ELAN
; VERSION      :  1.1
; CRYSTAL      :  6MHZ
; Creat date   :  2009/11/4
; tool ver.    :  eUIDE
; Description  :  modify for code conformity
;=========================================================================
M611ManageFunc.ASM    EQU    M611ManageFunc.ASM

include "M611USBDriver.ASM"
include "Keyscan.ASM"

ifndef EM78CtrlIns.H
include "EM78CtrlIns.H"
endif

ifndef M611rxP40.H
include "M611rxP40.H"
endif

ifndef XX93C46_For_EM78M611.ASM
include "XX93C46_For_EM78M611.ASM"
endif

;=========================================================================

	ORG                 0X1000	;PAGE 4
	MESSAGE "define 'M611ManageFunc.ASM' ROM address"
;********************************************************************************
; TX data to PC
;********************************************************************************
;===================================================================
;Function:      setting
;Input:         None
;Output:        None
;====================================================================
CommTypeScan_Func:
	CALL                PAGE4BANK1
	JBS                 ForceLinkModeFlag/16,ForceLinkModeFlag%16
	JMP                 KeyType_Scan

	MOV                 A,SystemTimeCNT
	SUB                 A,@200              ; 200*1ms = 200ms
	JBC                 STATUS,C
	JMP                 KeyType_Scan
	CLR                 SystemTimeCNT
	BS                  LED1_STATUS/16,LED1_STATUS%16

;===========================================================================
KeyType_Scan:
	CALL                ConnectKey_Scan
	JBS                 KeyScanFinishFlag/16,KeyScanFinishFlag%16
	JMP                 Keystoke_No_Press
	BC                  KeyScanFinishFlag/16,KeyScanFinishFlag%16

	MOV                 A,KEY_NUM
	XOR                 A,@00000010B
	JBC                 STATUS,Z
	JMP                 Click_Select

	MOV                 A,KEY_NUM
	XOR                 A,@00000011B
	JBC                 STATUS,Z
	JMP                 Lasting_Press_Select

	MOV                 A,KEY_NUM
	XOR                 A,@00000100B
	JBC                 STATUS,Z
	JMP                 Dblclick_Select

/*
	MOV                 A,KEY_NUM
	XOR                 A,@00000101B
	JBC                 STATUS,Z
	NOP

	MOV                 A,KEY_NUM
	XOR                 A,@00000110B
	JBC                 STATUS,Z
	NOP

	MOV                 A,KEY_NUM
	XOR                 A,@00000111B
	JBC                 STATUS,Z
	NOP
*/

	NOP
;===========================================================================


;**********************************************************************************
;*********************************************************************************
; force link check CHN_FLAG
;*********************************************************************************
Keystoke_No_Press:
	NOP
	JBC                 LinkModeFlag/16,LinkModeFlag%16
	JMP                 Cycle_Waiting_End
	CALL                PAGE4BANK1
	MOV                 A,CHN_FLAG
	XOR                 A,@00000001B             ; (1-8) Gamepads
	JBS                 STATUS,Z
	JMP                 Cycle_Waiting_End
Quit_Recognise_Scan:                             ; Exit ID scan
	BC                  LED1_STATUS/16,LED1_STATUS%16
	PAGE                0
	CALL                SearchLinkMode_Set
	PAGE                5
	CALL                Enter_StandbyII_Mode
	CALL                CHANGE_ADDRESS_VALUE
	PAGE                4
	CALL                PAGE4BANK1
	CLR                 CHN_FLAG

	;MOV                 A,@0X80      ; (test)P57 exchange when intrrupt
	;XOR                 PORT5,A

	NOP
	JMP                 Cycle_Waiting_End
	NOP

;**********************************************************************************
;*********************************************************************************
; FCC test mode frequency index
;*********************************************************************************
Click_Select:
	JBS                 FccTestModeFlag/16,FccTestModeFlag%16
	JMP                 Not_Fcc_TestMode
	INC                 FccFreqIndex
	MOV                 A,FccFreqIndex
	SUB                 A,@0X0F
	JBS                 STATUS,C
	CLR                 FccFreqIndex
	JMP                 KeyType_Scan
Not_Fcc_TestMode:
	CLR                 KEY_NUM
	JBS                 ForceLinkModeFlag/16,ForceLinkModeFlag%16
	JMP                 Cycle_Waiting_End
	JMP                 Quit_Recognise_Scan
	NOP



;**********************************************************************************
;*********************************************************************************
; Into FCC mode
;*********************************************************************************
Lasting_Press_Select:                                     	; Fcc Test
	;PAGE                0
	;CALL                NormalFccLinkMode_Set
	;PAGE                4
	BS                  FccTestModeFlag/16,FccTestModeFlag%16
	JMP                 Cycle_Waiting_End
	NOP


;**********************************************************************************
;*********************************************************************************
; Into force link mode
;*********************************************************************************
Dblclick_Select:                                            ; Into Forcelink Mode:
	WDTC
	BS                  LED1_STATUS/16,LED1_STATUS%16
	CALL                PAGE4BANK1
	MOV                 A,@RX_IDH_DEFAULT                   ; SYNC ,used default 0X0DB3
	MOV                 RX_IDH,A
	MOV                 A,@RX_IDL_DEFAULT
	MOV                 RX_IDL,A
	PAGE                5
	CALL                Enter_StandbyII_Mode
	CALL                CHANGE_ADDRESS_VALUE
	PAGE                0
	CALL                SearchForceLinkMode_Set
	CALL                Rand_ID_Function
	PAGE                4
	NOP
Write_EEprom_Task:                                          ; Write EEprom Task
	DISI
	NOP
	BS                  SPI_SS/16,SPI_SS%16                 ; Disable EM198810
	;mERAL                                                  ; Clear all
	mEWEN                                                   ; Enable
	MOV                 A,@0X00
	MOV                 DataAddressInEEPROM,A
	MOV                 A,@0X60
	MOV                 DataAddressInMCU,A
 	mWRITE              DataAddressInEEPROM,@0,DataAddressInMCU,@16
 	mEWDS                                                   ; disable
	BC                  AT93C46_CS/16,AT93C46_CS%16         ; Disable 93C46

	ENI
 	CALL                PAGE4BANK1
	CLR                 GeneralStatusFlag
	CLR                 CHN_FLAG
	CLR                 KEY_NUM
	CLR                 CommuStatusFlag
	BS                  SearchStatusFlag/16,SearchStatusFlag%16
	BS                  ForceLinkModeFlag/16,ForceLinkModeFlag%16    ;

	CALL                PAGE4BANK0
	BC                  AT93C46_CS/16,AT93C46_CS%16                  ; Disable 93C46
	BS                  SPI_SS/16,SPI_SS%16                          ; Disable EM198810
	JMP                 Cycle_Waiting_End
	NOP



;===================================================================
;
;===================================================================
Cycle_Waiting_End:
	CALL                PAGE4BANK1
	MOV                 A,SystemTimeCNT
	SUB                 A,@250              ; 200*1ms = 200ms
	JBS                 STATUS,C
	CLR                 SystemTimeCNT
	MOV                 A,CHN_FLAG
	MOV                 CHN_FLAG_TEMP,A

	CALL                PAGE4BANK1
	MOV                 A,RX_ComuLoseCNT
	SUB                 A,@RX_ComuLoseCNT_Default
	JBC                 STATUS,C                  ; t=RX_ComuLoseCNT_Default check one time
	JMP                 Communicating_CHN_FLAG
	CLR                 RX_ComuLoseCNT

	JBC                 CHN_FLAG,RX1
	JMP                 Communicating_CHN_FLAG
	;MOV                 A,@0X80      ; (test)P57 exchange when intrrupt
	;XOR                 PORT5,A
	PAGE                5
	CALL                RSSI_TEST_FUNCTION
	CALL                Enter_StandbyII_Mode
	PAGE                4
	NOP
  Communicating_CHN_FLAG:
	RET
	NOP

;=====================================================================
; BANK exchange function
;=====================================================================
PAGE4BANK0:
	BC                  0X04,7
	BC                  0X04,6
	RET
PAGE4BANK1:
	BC                  0X04,7
	BS                  0X04,6
	RET
PAGE4BANK2:
	BS                  0X04,7
	BC                  0X04,6
	RET
PAGE4BANK3:
	BS                  0X04,7
	BS                  0X04,6
	RET