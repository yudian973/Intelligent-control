;==================================================================
;  Tilte:       EM78M198810 include file		;
;  NAME:        EM198810_FOR_EM78M611.ASM
;  Description:
;  Company:     Elan Electronic Corp.		;
;  Author:      YU.WEI				;
;  Date:        2009.02.26			;
;  Version:     v1.0				;
;  Tool:        wiceplus 2.7
;=========================================================================
M611SKIPFREQFUN.ASM    EQU    M611SKIPFREQFUN.ASM

ifndef M611rxP40M1v6V10.H
include "M611rxP40M1v6V10.H"
endif

ifndef EM78CtrlIns.H
include "EM78CtrlIns.H"
endif
	ORG                 0X200    ;PAGE 0
SYNC_COM_TX:
	NOP
	WDTC
	PAGE                5
	CALL                Enter_StandbyII_Mode
	CALL                RF_FREQ_SET
	PAGE                4
 	CALL                Communicate_USB_Function
 	PAGE                0
	MOV                 A,ComuClock
	SUB                 A,@5
	JBC                 STATUS,C
	JMP                 $-3
	CALL                PAGE0BANK0
	MOV                 A,@0X00
	MOV                 PID_DATA_Buffer,A

	CALL                PAGE0BANK1
	MOV                 A,RX_IDH
	CALL                PAGE0BANK0
	MOV                 RX_IDH_Buffer,A

	CALL                PAGE0BANK1
	MOV                 A,RX_IDL
	CALL                PAGE0BANK0
	MOV                 RX_IDL_Buffer,A

	CALL                PAGE0BANK1
	MOV                 A,CHN_FLAG
	CALL                PAGE0BANK0
	MOV                 CHN_FLAG_Buffer,A

	MOV                 A,CommuStatusFlag
	MOV                 CommuStatusFlag_Buffer,A

	CALL                PAGE0BANK1
	MOV                 A,DirectionCtrl
	CALL                PAGE0BANK0
	MOV                 DirectionCtrl_Buffer,A

	CALL                PAGE0BANK1
	MOV                 A,@TotalGamepads
	MOV                 N_CHN,A
	SWAP                N_CHN
	MOV                 A,CH_NO
	OR                  N_CHN,A
	MOV                 A,N_CHN
	CALL                PAGE0BANK0
	MOV                 N_CHN_Buffer,A
	MOV                 A,CommuStatusFlag
	MOV                 CommuStatusFlag_Buffer,A
	CALL                PAGE0BANK1
	MOV                 A,DirectionCtrl
	CALL                PAGE0BANK0
	MOV                 DirectionCtrl_Buffer,A
	CALL                PAGE0BANK1
	MOV                 A,TX1_ID
	CALL                PAGE0BANK0
	MOV                 TX1_ID_Buffer,A
	CALL                PAGE0BANK1
	MOV                 A,TX2_ID
	CALL                PAGE0BANK0
	MOV                 TX2_ID_Buffer,A
	CALL                PAGE0BANK1
	MOV                 A,TX3_ID
	CALL                PAGE0BANK0
	MOV                 TX3_ID_Buffer,A
	CALL                PAGE0BANK1
	MOV                 A,TX4_ID
	CALL                PAGE0BANK0
	MOV                 TX4_ID_Buffer,A
	CALL                PAGE0BANK1
	MOV                 A,TX5_ID
	CALL                PAGE0BANK0
	MOV                 TX5_ID_Buffer,A
	CALL                PAGE0BANK1
	MOV                 A,TX6_ID
	CALL                PAGE0BANK0
	MOV                 TX6_ID_Buffer,A
	CALL                PAGE0BANK0
	MOV                 A,GS_XPoint_LOW_Buffer
	CALL                PAGE0BANK1
	MOV                 GS_XPoint_LOW,A
	CALL                PAGE0BANK0
	MOV                 A,GS_YPoint_LOW_Buffer
	CALL                PAGE0BANK1
	MOV                 GS_YPoint_LOW,A
	CALL                PAGE0BANK0
	MOV                 A,GS_ZPoint_LOW_Buffer
	CALL                PAGE0BANK1
	MOV                 GS_ZPoint_LOW,A
	CALL                PAGE0BANK0
	MOV                 A,GS_Point_HIGH_Buffer
	CALL                PAGE0BANK1
	MOV                 GS_Point_HIGH,A
	CALL                PAGE0BANK0
	MOV                 A,CMOS_XPoint_LOW_Buffer
	CALL                PAGE0BANK1
	MOV                 CMOS_XPoint_LOW,A
	CALL                PAGE0BANK0
	MOV                 A,CMOS_YPoint_LOW_Buffer
	CALL                PAGE0BANK1
	MOV                 CMOS_YPoint_LOW,A
	CALL                PAGE0BANK0
	MOV                 A,CMOS_Point_HIGH_Buffer
	CALL                PAGE0BANK1
	MOV                 CMOS_Point_HIGH,A
	PAGE                5
	CALL                Enter_TX_Buffer_NACK
	CALL                Reset_RF_FIFO
	CALL                Write_FIFO_RAM
	PAGE                0
	MOV                 A,@(256-47)
	MOV                 TCC,A
	MOV                 A,@0X80
	XOR                 PORT5,A
	CLR                 ComuClock
	NOP
	RET
SearchLinkMode_Set:
	BS                  SearchStatusFlag/16,SearchStatusFlag%16            ;set search mode
	BC                  NormalStatusFlag/16,NormalStatusFlag%16            ;Clear normal mode
	BC                  EEpromWRStatusFlag/16,EEpromWRStatusFlag%16
	BS                  LinkModeFlag/16,LinkModeFlag%16
	BC                  ForceLinkModeFlag/16,ForceLinkModeFlag%16
	BC                  FccTestModeFlag/16,FccTestModeFlag%16
	RET
NormalLinkMode_Set:
	BC                  SearchStatusFlag/16,SearchStatusFlag%16            ;set search mode
	BS                  NormalStatusFlag/16,NormalStatusFlag%16            ;Clear normal mode
	BC                  EEpromWRStatusFlag/16,EEpromWRStatusFlag%16
	BS                  LinkModeFlag/16,LinkModeFlag%16
	BC                  ForceLinkModeFlag/16,ForceLinkModeFlag%16
	BC                  FccTestModeFlag/16,FccTestModeFlag%16
	RET
SearchForceLinkMode_Set:
	BS                  SearchStatusFlag/16,SearchStatusFlag%16            ;set search mode
	BC                  NormalStatusFlag/16,NormalStatusFlag%16            ;Clear normal mode
	BC                  EEpromWRStatusFlag/16,EEpromWRStatusFlag%16
	BC                  LinkModeFlag/16,LinkModeFlag%16
	BS                  ForceLinkModeFlag/16,ForceLinkModeFlag%16
	BC                  FccTestModeFlag/16,FccTestModeFlag%16
	RET
NormalFccLinkMode_Set:
	BC                  SearchStatusFlag/16,SearchStatusFlag%16            ;set search mode
	BS                  NormalStatusFlag/16,NormalStatusFlag%16            ;Clear normal mode
	BC                  EEpromWRStatusFlag/16,EEpromWRStatusFlag%16
	BC                  LinkModeFlag/16,LinkModeFlag%16
	BC                  ForceLinkModeFlag/16,ForceLinkModeFlag%16
	BS                  FccTestModeFlag/16,FccTestModeFlag%16
	RET
	ORG                 0X400    ;PAGE 1
RX1_FUNCTION:
	WDTC
	PAGE                5
	CALL                Enter_StandbyII_Mode
	CALL                RESET_RF_FIFO
	CALL                ENTER_RX_BUFFER_ACK
	PAGE                1
  RX1_DETECT_LOOP:
	MOV                 A,ComuClock
	SUB                 A,@7
	JBS                 STATUS,C
	JMP                 Rx1_Detect_Timeout
	JBS                 PKT_FLAG/16,PKT_FLAG%16
	JMP                 RX1_DETECT_LOOP
	NOP
	PAGE                5
	CALL                READ_FIFO_RAM
	CALL                Enter_StandbyII_Mode
	PAGE                1
	CALL                PAGE1BANK1
	MOV                 A,RX_IDH
	CALL                PAGE1BANK0
	XOR                 RX_IDH_Buffer,A
	JBS                 STATUS,Z
	JMP                 LoseFrameStatus_RxTxID1_Error
	CALL                PAGE1BANK1
	MOV                 A,RX_IDL
	CALL                PAGE1BANK0
	XOR                 RX_IDL_Buffer,A
	JBS                 STATUS,Z
	JMP                 LoseFrameStatus_RxTxID1_Error
	CALL                PAGE1BANK1
	MOV                 A,TX1_ID
	CALL                PAGE1BANK0
	XOR                 TX_ID_Buffer,A
	JBS                 STATUS,Z
	JMP                 LoseFrameStatus_RxTxID1_Error
	CALL                PAGE1BANK0
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
	CALL                PAGE1BANK1
	BS                  CHN_FLAG,0
	JBS                 ForceLinkModeFlag/16,ForceLinkModeFlag%16
	JMP                 EP1_REPORT_RX1
	JBC                 CHN_FLAG_TEMP,0
	JMP                 Clear_RX1_LossframeCNT
	BC                  LED1_STATUS/16,LED1_STATUS%16
	CLR                 SystemTimeCNT
	JMP                 Clear_RX1_LossframeCNT
  Rx1_Detect_Timeout:
	CALL                PAGE1BANK1
	JBS                 CHN_FLAG,0
	JMP                 Clear_RX1_LossframeCNT
	MOV                 A,RX1_LossframeCNT
	SUB                 A,@3
	JBC                 STATUS,C
	JMP                 Increase_RX1_LossframeCNT
	JBC                 ForceLinkModeFlag/16,ForceLinkModeFlag%16
	JMP                 Clear_RX1_LossframeCNT
	BC                  CHN_FLAG,0
	JMP                 Clear_RX1_LossframeCNT
  LoseFrameStatus_RxTxID1_Error:
	CALL                PAGE1BANK1
	JBS                 CHN_FLAG,0
	JMP                 Clear_RX1_LossframeCNT
	MOV                 A,RX1_LossframeCNT                                   ; 5 times lossframe
	SUB                 A,@5
	JBC                 STATUS,C
	JMP                 Increase_RX1_LossframeCNT
	JBC                 ForceLinkModeFlag/16,ForceLinkModeFlag%16
	JMP                 Clear_RX1_LossframeCNT
	BC                  CHN_FLAG,0
	JMP                 Clear_RX1_LossframeCNT
  RX1_Report_Default:
	CALL                PAGE1BANK1
	CLR                 TX1_DATA1
	CLR                 TX1_DATA2
	MOV                 A,@0X7F
	MOV                 TX1_DATA3,A
	MOV                 TX1_DATA4,A
	MOV                 TX1_DATA5,A
	MOV                 TX1_DATA6,A
	CLR                 TX1_DATA7
	CLR                 TX1_DATA8
	PAGE                4
	CALL                EP1_Report_1st
	PAGE                1
	RET
  Increase_RX1_LossframeCNT:
	INC                 RX1_LossframeCNT
	JMP                 RX1_Over_Judge
  EP1_REPORT_RX1:
	PAGE                4
	CALL                EP1_Report_1st
	PAGE                1
  Clear_RX1_LossframeCNT:
	CLR                 RX1_LossframeCNT
  RX1_Over_Judge:
	MOV                 A,ComuClock
	SUB                 A,@7
	JBC                 STATUS,C
	JMP                 $-3
	BS                  SPI_SS/16,SPI_SS%16
	NOP
	RET
RX2_FUNCTION:
	WDTC
	PAGE                5
	CALL                Enter_StandbyII_Mode
	CALL                RESET_RF_FIFO
	CALL                ENTER_RX_BUFFER_ACK
	PAGE                1
  RX2_DETECT_LOOP:
	MOV                 A,ComuClock
	SUB                 A,@15
	JBS                 STATUS,C
	JMP                 RX2_Detect_Timeout
	JBS                 PKT_FLAG/16,PKT_FLAG%16
	JMP                 RX2_DETECT_LOOP
	NOP
	PAGE                5
	CALL                READ_FIFO_RAM
	CALL                Enter_StandbyII_Mode
	PAGE                1
	CALL                PAGE1BANK1
	MOV                 A,RX_IDH
	CALL                PAGE1BANK0
	XOR                 RX_IDH_Buffer,A
	JBS                 STATUS,Z
	JMP                 LoseFrameStatus_RxTxID2_Error
	CALL                PAGE1BANK1
	MOV                 A,RX_IDL
	CALL                PAGE1BANK0
	XOR                 RX_IDL_Buffer,A
	JBS                 STATUS,Z
	JMP                 LoseFrameStatus_RxTxID2_Error
	CALL                PAGE1BANK1
	MOV                 A,TX_ID
	CALL                PAGE1BANK0
	XOR                 TX_ID_Buffer,A
	JBS                 STATUS,Z
	JMP                 LoseFrameStatus_RxTxID2_Error
	CALL                PAGE1BANK0
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
	CALL                PAGE1BANK1
	BS                  CHN_FLAG,1
	JBS                 ForceLinkModeFlag/16,ForceLinkModeFlag%16
	JMP                 EP1_REPORT_RX2
	JBC                 CHN_FLAG_TEMP,1
	JMP                 Clear_RX2_LossframeCNT
	BC                  LED1_STATUS/16,LED1_STATUS%16
	CLR                 SystemTimeCNT
  RX2_Detect_Timeout:
	CALL                PAGE1BANK1
	JBS                 CHN_FLAG,1
	JMP                 Clear_RX2_LossframeCNT
	MOV                 A,RX2_LossframeCNT
	SUB                 A,@3
	JBC                 STATUS,C
	JMP                 Increase_RX2_LossframeCNT
	JBC                 ForceLinkModeFlag/16,ForceLinkModeFlag%16
	JMP                 Clear_RX2_LossframeCNT
	BC                  CHN_FLAG,1
	JMP                 Clear_RX2_LossframeCNT
  LoseFrameStatus_RxTxID2_Error:
	CALL                PAGE1BANK1
	JBS                 CHN_FLAG,1
	JMP                 Clear_RX2_LossframeCNT
	MOV                 A,RX2_LossframeCNT                                   ; 5 times lossframe
	SUB                 A,@5
	JBC                 STATUS,C
	JMP                 Increase_RX2_LossframeCNT
	JBC                 ForceLinkModeFlag/16,ForceLinkModeFlag%16
	JMP                 Clear_RX2_LossframeCNT
	BC                  CHN_FLAG,1
	JMP                 Clear_RX2_LossframeCNT
  Increase_RX2_LossframeCNT:
	INC                 RX2_LossframeCNT
	JMP                 RX2_Over_Judge
  EP1_REPORT_RX2:
	PAGE                4
	CALL                EP1_Report_2nd
	PAGE                1
  Clear_RX2_LossframeCNT:
	CLR                 RX2_LossframeCNT
  RX2_Over_Judge:
	MOV                 A,ComuClock
	SUB                 A,@15
	JBC                 STATUS,C
	JMP                 $-3
	BS                  SPI_SS/16,SPI_SS%16          ;
	NOP
	RET
RX3_FUNCTION:
	PAGE                5
	CALL                Enter_StandbyII_Mode
	CALL                RESET_RF_FIFO
	CALL                ENTER_RX_BUFFER_ACK
	PAGE                1
  RX3_DETECT_LOOP:
	MOV                 A,ComuClock
	SUB                 A,@23
	JBS                 STATUS,C
	JMP                 RX3_Detect_Timeout
	JBS                 PKT_FLAG/16,PKT_FLAG%16
	JMP                 RX3_DETECT_LOOP
	NOP
	PAGE                5
	CALL                READ_FIFO_RAM
	CALL                Enter_StandbyII_Mode
	PAGE                1

	CALL                PAGE1BANK1
	MOV                 A,RX_IDH
	CALL                PAGE1BANK0
	XOR                 RX_IDH_Buffer,A
	JBS                 STATUS,Z
	JMP                 LoseFrameStatus_RxTxID3_Error
	CALL                PAGE1BANK1
	MOV                 A,RX_IDL
	CALL                PAGE1BANK0
	XOR                 RX_IDL_Buffer,A
	JBS                 STATUS,Z
	JMP                 LoseFrameStatus_RxTxID3_Error
	CALL                PAGE1BANK1
	MOV                 A,TX3_ID
	CALL                PAGE1BANK0
	XOR                 TX_ID_Buffer,A
	JBS                 STATUS,Z
	JMP                 LoseFrameStatus_RxTxID3_Error
	CALL                PAGE1BANK0
	MOV                 A,DataA_Buffer
	CALL                PAGE1BANK2
	MOV                 TX3_DATA1,A
	CALL                PAGE1BANK0
	MOV                 A,DataB_Buffer
	CALL                PAGE1BANK2
	MOV                 TX3_DATA2,A
	CALL                PAGE1BANK0
	MOV                 A,DataC_Buffer
	CALL                PAGE1BANK2
	MOV                 TX3_DATA3,A
	CALL                PAGE1BANK0
	MOV                 A,DataD_Buffer
	CALL                PAGE1BANK2
	MOV                 TX3_DATA4,A
	CALL                PAGE1BANK0
	MOV                 A,DataE_Buffer
	CALL                PAGE1BANK2
	MOV                 TX3_DATA5,A
	CALL                PAGE1BANK0
	MOV                 A,DataF_Buffer
	CALL                PAGE1BANK2
	MOV                 TX3_DATA6,A
	CALL                PAGE1BANK0
	MOV                 A,DataG_Buffer
	CALL                PAGE1BANK2
	MOV                 TX3_DATA7,A
	CALL                PAGE1BANK1
	BS                  CHN_FLAG,2
	JBS                 ForceLinkModeFlag/16,ForceLinkModeFlag%16
	JMP                 EP1_REPORT_RX3
	JBC                 CHN_FLAG_TEMP,2
	JMP                 Clear_RX3_LossframeCNT
	BC                  LED1_STATUS/16,LED1_STATUS%16             ;
	CLR                 SystemTimeCNT
	JMP                 Clear_RX3_LossframeCNT
  RX3_Detect_Timeout:
	CALL                PAGE1BANK1
	JBS                 CHN_FLAG,2
	JMP                 Clear_RX3_LossframeCNT
	MOV                 A,RX3_LossframeCNT
	SUB                 A,@3
	JBC                 STATUS,C
	JMP                 Increase_RX3_LossframeCNT
	JBC                 ForceLinkModeFlag/16,ForceLinkModeFlag%16
	JMP                 Clear_RX3_LossframeCNT
	BC                  CHN_FLAG,2
	JMP                 Clear_RX3_LossframeCNT
  LoseFrameStatus_RxTxID3_Error:
	CALL                PAGE1BANK1
	JBS                 CHN_FLAG,2
	JMP                 Clear_RX3_LossframeCNT
	MOV                 A,RX3_LossframeCNT                                   ; 5 times lossframe
	SUB                 A,@5
	JBC                 STATUS,C
	JMP                 Increase_RX3_LossframeCNT
	JBC                 ForceLinkModeFlag/16,ForceLinkModeFlag%16
	JMP                 Clear_RX3_LossframeCNT
	BC                  CHN_FLAG,2
	JMP                 Clear_RX3_LossframeCNT
  Increase_RX3_LossframeCNT:
	INC                 RX3_LossframeCNT
	JMP                 RX3_Over_Judge
  EP1_REPORT_RX3:
	PAGE                4
	CALL                EP1_Report_3rd
	PAGE                1
  Clear_RX3_LossframeCNT:
	CLR                 RX3_LossframeCNT
  RX3_Over_Judge:
	MOV                 A,ComuClock
	SUB                 A,@23
	JBC                 STATUS,C
	JMP                 $-3
	BS                  SPI_SS/16,SPI_SS%16
	NOP
	RET
RX4_FUNCTION:
	PAGE                5
	CALL                Enter_StandbyII_Mode
	CALL                RESET_RF_FIFO
	CALL                ENTER_RX_BUFFER_ACK
	PAGE                1
  RX4_DETECT_LOOP:
	MOV                 A,ComuClock
	SUB                 A,@31
	JBS                 STATUS,C
	JMP                 RX4_Detect_Timeout
	JBS                 PKT_FLAG/16,PKT_FLAG%16
	JMP                 RX4_DETECT_LOOP
	NOP
	PAGE                5
	CALL                READ_FIFO_RAM
	CALL                Enter_StandbyII_Mode
	PAGE                1
	CALL                PAGE1BANK1
	MOV                 A,RX_IDH
	CALL                PAGE1BANK0
	XOR                 RX_IDH_Buffer,A
	JBS                 STATUS,Z
	JMP                 LoseFrameStatus_RxTxID4_Error
	CALL                PAGE1BANK1
	MOV                 A,RX_IDL
	CALL                PAGE1BANK0
	XOR                 RX_IDL_Buffer,A
	JBS                 STATUS,Z
	JMP                 LoseFrameStatus_RxTxID4_Error
	CALL                PAGE1BANK1
	MOV                 A,TX4_ID
	CALL                PAGE1BANK0
	XOR                 TX_ID_Buffer,A
	JBS                 STATUS,Z
	JMP                 LoseFrameStatus_RxTxID4_Error
	CALL                PAGE1BANK0
	MOV                 A,DataA_Buffer
	CALL                PAGE1BANK2
	MOV                 TX4_DATA1,A
	CALL                PAGE1BANK0
	MOV                 A,DataB_Buffer
	CALL                PAGE1BANK2
	MOV                 TX4_DATA2,A
	CALL                PAGE1BANK0
	MOV                 A,DataC_Buffer
	CALL                PAGE1BANK2
	MOV                 TX4_DATA3,A
	CALL                PAGE1BANK0
	MOV                 A,DataD_Buffer
	CALL                PAGE1BANK2
	MOV                 TX4_DATA4,A
	CALL                PAGE1BANK0
	MOV                 A,DataE_Buffer
	CALL                PAGE1BANK2
	MOV                 TX4_DATA5,A
	CALL                PAGE1BANK0
	MOV                 A,DataF_Buffer
	CALL                PAGE1BANK2
	MOV                 TX4_DATA6,A
	CALL                PAGE1BANK0
	MOV                 A,DataG_Buffer
	CALL                PAGE1BANK2
	MOV                 TX4_DATA7,A
	CALL                PAGE1BANK1
	BS                  CHN_FLAG,3
	JBS                 ForceLinkModeFlag/16,ForceLinkModeFlag%16
	JMP                 EP1_REPORT_RX4
	JBC                 CHN_FLAG_TEMP,3
	JMP                 Clear_RX4_LossframeCNT
	BC                  LED1_STATUS/16,LED1_STATUS%16
	CLR                 SystemTimeCNT
	JMP                 Clear_RX4_LossframeCNT
  RX4_Detect_Timeout:
	CALL                PAGE1BANK1
	JBS                 CHN_FLAG,3
	JMP                 Clear_RX4_LossframeCNT
	MOV                 A,RX4_LossframeCNT
	SUB                 A,@3
	JBC                 STATUS,C
	JMP                 Increase_RX4_LossframeCNT
	JBC                 ForceLinkModeFlag/16,ForceLinkModeFlag%16
	JMP                 Clear_RX4_LossframeCNT
	BC                  CHN_FLAG,3
	JMP                 Clear_RX4_LossframeCNT
  LoseFrameStatus_RxTxID4_Error:
	CALL                PAGE1BANK1
	JBS                 CHN_FLAG,3
	JMP                 Clear_RX4_LossframeCNT
	MOV                 A,RX4_LossframeCNT                                   ; 5 times lossframe
	SUB                 A,@5
	JBC                 STATUS,C
	JMP                 Increase_RX4_LossframeCNT
	JBC                 ForceLinkModeFlag/16,ForceLinkModeFlag%16
	JMP                 Clear_RX4_LossframeCNT
	BC                  CHN_FLAG,3
	JMP                 Clear_RX4_LossframeCNT
  Increase_RX4_LossframeCNT:
	INC                 RX4_LossframeCNT
	JMP                 RX4_Over_Judge
  EP1_REPORT_RX4:
	PAGE                4
	CALL                EP1_Report_4th
	PAGE                1
  Clear_RX4_LossframeCNT:
	CLR                 RX4_LossframeCNT
  RX4_Over_Judge:
	MOV                 A,ComuClock
	SUB                 A,@31
	JBC                 STATUS,C
	JMP                 $-3
	BS                  SPI_SS/16,SPI_SS%16
	NOP
	RET
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
	ORG                 0X800   ;PAGE 2
RX5_FUNCTION:
	PAGE                5
	CALL                Enter_StandbyII_Mode
	CALL                RESET_RF_FIFO
	CALL                ENTER_RX_BUFFER_ACK
	PAGE                2
  RX5_DETECT_LOOP:
	MOV                 A,ComuClock
	SUB                 A,@39
	JBS                 STATUS,C
	JMP                 RX5_Detect_Timeout
	JBS                 PKT_FLAG/16,PKT_FLAG%16
	JMP                 RX5_DETECT_LOOP
	NOP
	PAGE                5
	CALL                READ_FIFO_RAM
	CALL                Enter_StandbyII_Mode
	PAGE                2
	CALL                PAGE2BANK1
	MOV                 A,RX_IDH
	CALL                PAGE2BANK0
	XOR                 RX_IDH_Buffer,A
	JBS                 STATUS,Z
	JMP                 LoseFrameStatus_RxTxID5_Error
	CALL                PAGE2BANK1
	MOV                 A,RX_IDL
	CALL                PAGE2BANK0
	XOR                 RX_IDL_Buffer,A
	JBS                 STATUS,Z
	JMP                 LoseFrameStatus_RxTxID5_Error
	CALL                PAGE2BANK1
	MOV                 A,TX5_ID
	CALL                PAGE2BANK0
	XOR                 TX_ID_Buffer,A
	JBS                 STATUS,Z
	JMP                 LoseFrameStatus_RxTxID5_Error
	CALL                PAGE2BANK0
	MOV                 A,DataA_Buffer
	CALL                PAGE2BANK3
	MOV                 TX5_DATA1,A
	CALL                PAGE2BANK0
	MOV                 A,DataB_Buffer
	CALL                PAGE2BANK3
	MOV                 TX5_DATA2,A
	CALL                PAGE2BANK0
	MOV                 A,DataC_Buffer
	CALL                PAGE2BANK3
	MOV                 TX5_DATA3,A
	CALL                PAGE2BANK0
	MOV                 A,DataD_Buffer
	CALL                PAGE2BANK3
	MOV                TX5_DATA4,A
	CALL                PAGE2BANK0
	MOV                 A,DataE_Buffer
	CALL                PAGE2BANK3
	MOV                 TX5_DATA5,A
	CALL                PAGE2BANK0
	MOV                 A,DataF_Buffer
	CALL                PAGE2BANK3
	MOV                 TX5_DATA6,A
	CALL                PAGE2BANK0
	MOV                 A,DataG_Buffer
	CALL                PAGE2BANK3
	MOV                 TX5_DATA7,A
	CALL                PAGE2BANK1
	BS                  CHN_FLAG,4
	JBS                 ForceLinkModeFlag/16,ForceLinkModeFlag%16
	JMP                 EP1_REPORT_RX5
	JBC                 CHN_FLAG_TEMP,4
	JMP                 Clear_RX5_LossframeCNT
	BC                  LED1_STATUS/16,LED1_STATUS%16
	CLR                 SystemTimeCNT
	JMP                 Clear_RX5_LossframeCNT
  RX5_Detect_Timeout:
	CALL                PAGE2BANK1
	JBS                 CHN_FLAG,4
	JMP                 Clear_RX5_LossframeCNT
	MOV                 A,RX5_LossframeCNT
	SUB                 A,@3
	JBC                 STATUS,C
	JMP                 Increase_RX5_LossframeCNT
	JBC                 ForceLinkModeFlag/16,ForceLinkModeFlag%16
	JMP                 Clear_RX5_LossframeCNT
	BC                  CHN_FLAG,4
	JMP                 Clear_RX5_LossframeCNT
  LoseFrameStatus_RxTxID5_Error:
	CALL                PAGE2BANK1
	JBS                 CHN_FLAG,4
	JMP                 Clear_RX5_LossframeCNT
	MOV                 A,RX5_LossframeCNT                                   ; 5 times lossframe
	SUB                 A,@5
	JBC                 STATUS,C
	JMP                 Increase_RX5_LossframeCNT
	JBC                 ForceLinkModeFlag/16,ForceLinkModeFlag%16
	JMP                 Clear_RX5_LossframeCNT
	BC                  CHN_FLAG,4
	JMP                 Clear_RX5_LossframeCNT
  Increase_RX5_LossframeCNT:
	INC                 RX5_LossframeCNT
	JMP                 RX5_Over_Judge
  EP1_REPORT_RX5:
	PAGE                4
	CALL                EP1_Report_5th
	PAGE                2
  Clear_RX5_LossframeCNT:
	CLR                 RX5_LossframeCNT
  RX5_Over_Judge:
	MOV                 A,ComuClock
	SUB                 A,@39
	JBC                 STATUS,C
	JMP                 $-3
	BS                  SPI_SS/16,SPI_SS%16
	NOP
	RET
RX6_FUNCTION:
	PAGE                5
	CALL                Enter_StandbyII_Mode
	CALL                RESET_RF_FIFO
	CALL                ENTER_RX_BUFFER_ACK
	PAGE                2
  RX6_DETECT_LOOP:
	MOV                 A,ComuClock
	SUB                 A,@47
	JBS                 STATUS,C
	JMP                 RX6_Detect_Timeout
	JBS                 PKT_FLAG/16,PKT_FLAG%16
	JMP                 RX6_DETECT_LOOP
	NOP
	PAGE                5
	CALL                READ_FIFO_RAM
	CALL                Enter_StandbyII_Mode
	PAGE                2
	CALL                PAGE2BANK1
	MOV                 A,RX_IDH
	CALL                PAGE2BANK0
	XOR                 RX_IDH_Buffer,A
	JBS                 STATUS,Z
	JMP                 LoseFrameStatus_RxTxID6_Error
	CALL                PAGE2BANK1
	MOV                 A,RX_IDL
	CALL                PAGE2BANK0
	XOR                 RX_IDL_Buffer,A
	JBS                 STATUS,Z
	JMP                 LoseFrameStatus_RxTxID6_Error
	CALL                PAGE2BANK1
	MOV                 A,TX6_ID
	CALL                PAGE2BANK0
	XOR                 TX_ID_Buffer,A
	JBS                 STATUS,Z
	JMP                 LoseFrameStatus_RxTxID6_Error
	CALL                PAGE2BANK0
	MOV                 A,DataA_Buffer
	CALL                PAGE2BANK3
	MOV                 TX6_DATA1,A
	CALL                PAGE2BANK0
	MOV                 A,DataB_Buffer
	CALL                PAGE2BANK3
	MOV                 TX6_DATA2,A
	CALL                PAGE2BANK0
	MOV                 A,DataC_Buffer
	CALL                PAGE2BANK3
	MOV                 TX6_DATA3,A
	CALL                PAGE2BANK0
	MOV                 A,DataD_Buffer
	CALL                PAGE2BANK3
	MOV                 TX6_DATA4,A
	CALL                PAGE2BANK0
	MOV                 A,DataE_Buffer
	CALL                PAGE2BANK3
	MOV                 TX6_DATA5,A
	CALL                PAGE2BANK0
	MOV                 A,DataF_Buffer
	CALL                PAGE2BANK3
	MOV                 TX6_DATA6,A
	CALL                PAGE2BANK0
	MOV                 A,DataG_Buffer
	CALL                PAGE2BANK3
	MOV                 TX6_DATA7,A
	CALL                PAGE2BANK1
	BS                  CHN_FLAG,5
	JBS                 ForceLinkModeFlag/16,ForceLinkModeFlag%16
	JMP                 EP1_REPORT_RX6
	JBC                 CHN_FLAG_TEMP,5
	JMP                 Clear_RX6_LossframeCNT
	BC                  LED1_STATUS/16,LED1_STATUS%16
	CLR                 SystemTimeCNT
	JMP                 Clear_RX6_LossframeCNT
  RX6_Detect_Timeout:
	CALL                PAGE2BANK1
	JBS                 CHN_FLAG,5
	JMP                 Clear_RX6_LossframeCNT
	MOV                 A,RX6_LossframeCNT
	SUB                 A,@3
	JBC                 STATUS,C
	JMP                 Increase_RX6_LossframeCNT
	JBC                 ForceLinkModeFlag/16,ForceLinkModeFlag%16
	JMP                 Clear_RX6_LossframeCNT
	BC                  CHN_FLAG,5
	JMP                 Clear_RX6_LossframeCNT
  LoseFrameStatus_RxTxID6_Error:
	CALL                PAGE2BANK1
	JBS                 CHN_FLAG,5
	JMP                 Clear_RX6_LossframeCNT
	MOV                 A,RX6_LossframeCNT                                   ; 5 times lossframe
	SUB                 A,@5
	JBC                 STATUS,C
	JMP                 Increase_RX6_LossframeCNT
	JBC                 ForceLinkModeFlag/16,ForceLinkModeFlag%16
	JMP                 Clear_RX6_LossframeCNT
	BC                  CHN_FLAG,5
	JMP                 Clear_RX6_LossframeCNT
  Increase_RX6_LossframeCNT:
	INC                 RX6_LossframeCNT
	JMP                 RX6_Over_Judge
  EP1_REPORT_RX6:
	PAGE                4
	CALL                EP1_Report_6th
	PAGE                2
  Clear_RX6_LossframeCNT:
	CLR                 RX6_LossframeCNT
  RX6_Over_Judge:
	MOV                 A,ComuClock
	SUB                 A,@47
	JBC                 STATUS,C
	JMP                 $-3
	BS                  SPI_SS/16,SPI_SS%16
	CLR                 ComuClock
	NOP
	RET
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