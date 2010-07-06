;==================================================================
;  Tilte:       EM78M198810 include file		;
;  NAME:        EM198810_FOR_EM78M611.ASM
;  Description: The Definition of EM78M198810 for EM78612 Registers ;
;  Company:     Elan Electronic Corp.		;
;  Author:      YU.WEI				;
;  Date:        2009.02.26			;
;  Version:     v1.0				;
;  Tool:        wiceplus 2.7
;=========================================================================
M611ManageFunc.ASM    EQU    M611ManageFunc.ASM

include "M611USBDriver.ASM"
include "Keyscan.ASM"

ifndef EM78CtrlIns.H
include "EM78CtrlIns.H"
endif

ifndef M611rxP40M1v6V10.H
include "M611rxP40M1v6V10.H"
endif

ifndef XX93C46_For_EM78M611.ASM
include "XX93C46_For_EM78M611.ASM"
endif

;=========================================================================

	ORG                 0X1000	;PAGE 4
Communicate_Usb_Function:
	CALL                PAGE4BANK1
	JBS                 ForceLinkModeFlag/16,ForceLinkModeFlag%16
	JMP                 KeyType_Scan
	MOV                 A,SystemTimeCNT
	SUB                 A,@200              ; 200*1ms = 200ms
	JBC                 STATUS,C
	JMP                 KeyType_Scan
	CLR                 SystemTimeCNT
	BS                  LED1_STATUS/16,LED1_STATUS%16
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
	NOP
Keystoke_No_Press:
	NOP
	JBC                 LinkModeFlag/16,LinkModeFlag%16
	JMP                 Cycle_Waiting_End
	CALL                PAGE4BANK1
	MOV                 A,CHN_FLAG
	XOR                 A,@00111111B
	JBS                 STATUS,Z
	JMP                 Cycle_Waiting_End
Quit_Recognise_Scan:
	PAGE                0
	CALL                SearchLinkMode_Set
	PAGE                5
	CALL                CHANGE_TO_INQ_VALUE
	PAGE                4
	CALL                PAGE4BANK1
	CLR                 CHN_FLAG
	JMP                 Cycle_Waiting_End
	NOP
Click_Select:
	BC                  LED1_STATUS/16,LED1_STATUS%16
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
Lasting_Press_Select:
	BS                  FccTestModeFlag/16,FccTestModeFlag%16
	JMP                 Cycle_Waiting_End
	NOP
Dblclick_Select:
	WDTC
	BS                  LED1_STATUS/16,LED1_STATUS%16
	CALL                PAGE4BANK1
	MOV                 A,@0X0D
	MOV                 RX_IDH,A
	MOV                 A,@0XB3
	MOV                 RX_IDL,A
	PAGE                5
	CALL                CHANGE_TO_INQ_VALUE
	PAGE                0
	CALL                SearchForceLinkMode_Set
	CALL                Rand_ID_Function
	PAGE                4
	NOP
Write_EEprom_Task:
	DISI
	NOP
	BS                  SPI_SS/16,SPI_SS%16

	mEWEN
	MOV                 A,@0X00
	MOV                 DataAddressInEEPROM,A
	MOV                 A,@0X60
	MOV                 DataAddressInMCU,A
 	mWRITE              DataAddressInEEPROM,@0,DataAddressInMCU,@24
 	mEWDS
	ENI
 	CALL                PAGE4BANK1
	CLR                 GeneralStatusFlag
	CLR                 CHN_FLAG
	CLR                 KEY_NUM
	CLR                 CommuStatusFlag
	BS                  SearchStatusFlag/16,SearchStatusFlag%16
	BS                  ForceLinkModeFlag/16,ForceLinkModeFlag%16    ;
	CALL                PAGE4BANK0
	JMP                 Cycle_Waiting_End
	NOP
Cycle_Waiting_End:
	CALL                PAGE4BANK1
	INC                 CH_NO
	PAGE                3
	CALL                RF_FREQ_SET
	PAGE                5
	MOV                 A,CH_NO
	SUB                 A,@15
	JBS                 STATUS,C
	CLR                 CH_NO
	MOV                 A,SystemTimeCNT
	SUB                 A,@250              
	JBS                 STATUS,C
	CLR                 SystemTimeCNT
	MOV                 A,CHN_FLAG
	MOV                 CHN_FLAG_TEMP,A
	RET
	NOP
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