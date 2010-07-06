/*****************************************************************
* Filename     :  EM78P520_32PIN44PIN_TX.ASM
* Author       :  yu.wei
* Company      :  ELAN
* VERSION      :  1.0
* CRYSTAL      :  8MHZ
* Creat date   :  2009/9/22
* tool ver.    :  WicePlus 2.7
* Description  :  modify for code conformity
*****************************************************************/
ifndef keyscan.ASM
include "keyscan.ASM"
endif
;---------------------------------------------------------

	ORG                 0X400    
Search_Equipment:
	BANK                0
	MOV                 A,@0x07                
	MOV                 TWTCR,A
	MOV                 A,@(255-124)         
	MOV                 TCC,A
	LCALL               Enter_StandbyII_Mode
	LCALL               RESET_RF_FIFO
	LCALL               ENTER_RX_BUFFER_NACK
	NOP
Detected_Connect_Key:
	BANK                0
	MOV                 A,@0x07                
	MOV                 TWTCR,A
	JBC                 System16msFlag/16,System16msFlag%16
	LCALL               ConnectKey_Scan
	JBS                 KeyScanFinishFlag/16,KeyScanFinishFlag%16
	JMP                 Keystoke_No_Press
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

	BC                  KeyScanFinishFlag/16,KeyScanFinishFlag%16
;-------------------------------------------------------------------------
Keystoke_No_Press:
	BANK                0
	BC                  SPI_SS/16,SPI_SS%16          
Waiting_For_SearchData_Arrive:
	MOV                 A,ComuClock                  
	XOR                 A,@112
	JBC                 STATUS,Z
	JMP                 Search_Detect_Timeout       
	JBS                 PKT_FLAG/16,PKT_FLAG%16	     
	JMP                 Detected_Connect_Key
	BANK                0
	MOV                 A,@0x04                      
	MOV                 TWTCR,A
	MOV                 A,@(255-124)                 
	MOV                 TCC,A
	MOV                 A,@0X80                      
	XOR                 PORT8,A

	LCALL               Enter_StandbyII_Mode
	JBS                 ForceLinkModeFlag/16,ForceLinkModeFlag%16
	LCALL               LoseFrameLinkMode_Set
	JBC                 ForceLinkModeFlag/16,ForceLinkModeFlag%16
	LCALL               LoseFrameForceLinkMode_Set
	CLR                 ComuClock
	LCALL               READ_FIFO_RAM
	NOP
	JBC                 ReadLengthError/16,ReadLengthError%16
	JMP                 Search_Detect_Timeout
	JBC                 ForceLinkModeFlag/16,ForceLinkModeFlag%16
	JMP                 ForceLink_Mode_Task
	CLR                 ComuCycleNum
	CLR                 ComuEndNum
	BANK                1
	MOV                 A,RX_IDH
	BANK                0
	XOR                 RX_IDH_Buffer,A
	JBS                 STATUS,Z
	JMP                 Search_Equipment      
	BANK                1
	MOV                 A,RX_IDL
	BANK                0
	XOR                 RX_IDL_Buffer,A
	JBS                 STATUS,Z
	JMP                 Search_Equipment     
	CLR                 TEMP2                
	BANK                1
	MOV                 A,TX_ID               
	AND                 A,@0X0F
	MOV                 TEMP,A
	BS                  STATUS,C
	RLC                 TEMP2
	DJZ                 TEMP
	JMP                 $-2
	MOV                 A,TEMP2
	MOV                 CHN_FLAG,A           
	BANK                0
	MOV                 CHN_FLAG_Buffer,A
SearchComu_Cycle_work:
	BANK                1
	CLR                 ComuCycleNum
	MOV                 A,TX_ID
	AND                 A,@0X0F
	MOV                 DataShiftCounter,A        
	MOV                 DataShiftCounter,DataShiftCounter
	JBS                 STATUS,Z
	JMP                 ComuCycleNum_End
ComuCycleNum_Loop:
	MOV                 A,@ComuTime
	ADD                 ComuCycleNum,A
	DJZ                 DataShiftCounter
	JMP                 ComuCycleNum_Loop
ComuCycleNum_End:
	NOP
	BANK                0
	SWAPA               N_CHN_Buffer         
	AND                 A,@0X0F
	MOV                 DataShiftCounter,A         
ComuEndNum_Loop:
	MOV                 A,@ComuTime
	ADD                 ComuEndNum,A
	DJZ                 DataShiftCounter
	JMP                 ComuEndNum_Loop
	INC                 ComuCycleNum
	MOV                 A,ComuClock           
	XOR                 A,ComuCycleNum
	JBS                 STATUS,Z
	JMP                 $-3
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
 	LCALL               RESET_RF_FIFO	
	LCALL               Enter_TX_Buffer_ACK    
	LCALL               WRITE_FIFO_RAM
	LCALL               Enter_StandbyII_Mode

	BANK                1
	JBC                 ForceLinkModeFlag/16,ForceLinkModeFlag%16
	JMP                 Write_EEprom_Task
	CLR                 LossframeCNT
	LCALL               Key_Scan
	LCALL              	NormalLinkMode_Set
	MOV                 A,ComuClock           
	XOR                 A,ComuEndNum
	JBS                 STATUS,Z
	JMP                 $-3
	NOP
	RET

ForceLink_Mode_Task:
	BANK                0
	CLR                 TEMP1                 
	MOV                 A,CHN_FLAG_Buffer     
	MOV                 TEMP,A
	BC                  STATUS,C
	RRC                 TEMP
	INC                 TEMP1
	JBC                 STATUS,C               
	JMP                 $-3                    
	MOV                 A,TEMP1

	BANK                1
	MOV                 TX_ID,A
    BANK                0
	MOV                 A,RX_IDH_Buffer      
	BANK                1
	MOV                 RX_IDH,A
	BANK                0
	MOV                 A,RX_IDL_Buffer
	BANK                1
	MOV                 RX_IDL,A
	AND                 A,@0XF0
	OR                  TX_ID,A                
	JMP                 SearchComu_Cycle_work
Search_Detect_Timeout:
	BS                  SearchStatusFlag/16,SearchStatusFlag%16            ;set search mode
	BC                  NormalStatusFlag/16,NormalStatusFlag%16            ;Clear normal mode
	BC                  LoseFrameStatusFlag/16,LoseFrameStatusFlag%16      ;Clear LoseFreq mode
	BANK                1
	MOV                 A,@16
	XOR                 A,CH_NO
	JBC                 STATUS,Z
	CLR                 CH_NO
	CLR                 ComuClock
	LCALL               RF_FREQ_SET
	INC                 CH_NO
	NOP
	BANK                0
	JBS                 ForceLinkModeFlag/16,ForceLinkModeFlag%16
	JMP                 LED_NormalSearch
	JMP                 LED_ForcelinkSearch
LED_NormalSearch:
	MOV                 A,@00000010B     
	XOR                 PORT8,A
	JMP                 LED_End_Control
LED_ForcelinkSearch:
	BS                  LED1_STATUS/16,LED1_STATUS%16		
LED_End_Control:
	NOP
	BC                  ReadLengthError/16,ReadLengthError%16
	CLR                 Databytelength
	CLR                 RX_IDH_Buffer
	CLR                 RX_IDL_Buffer
	CLR                 CHN_FLAG_Buffer
	CLR                 N_CHN_Buffer
	CLR                 TX_ID_Buffer
	LCALL               Enter_StandbyII_Mode
	LCALL               RESET_RF_FIFO		        
	LCALL               ENTER_RX_BUFFER_NACK
	NOP
	JMP                 Detected_Connect_Key
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

Lasting_Press_Select:
	LCALL               FccSearchLinkMode_Set
	BS                  FccTestModeFlag/16,FccTestModeFlag%16
	NOP
	JMP                 Detected_Connect_Key
Dblclick_Select:                                  ; Into Forcelink Mode:
	BANK                1
	LCALL               SearchForceLinkMode_Set
	MOV                 A,@0X0D                   ; SYNC ,used default 0X0DB3
	MOV                 RX_IDH,A
	MOV                 A,@0XB3
	MOV                 RX_IDL,A
	LCALL               CHANGE_TO_INQ_VALUE
	JMP                 Keystoke_No_Press
Write_EEprom_Task:
	DISI
	NOP
	BANK                0
	MOV                 A,RX_IDH_Buffer               ; Read ID
	BANK                1
	MOV                 RX_IDH,A
	BANK                0
	MOV                 A,RX_IDL_Buffer
	BANK                1
	MOV                 RX_IDL,A
	BANK                0
	MOV                 A,TX_ID_Buffer
	BANK                1
	MOV                 TX_ID,A

	LCALL               IO_93C46_INITIAL
	mEWEN                                      ; Enable
	NOP
	MOV                 A,@0X00
	MOV                 DataAddressInEEPROM,A
	MOV                 A,@0X60
	MOV                 DataAddressInMCU,A
 	mWRITE              DataAddressInEEPROM,@0,DataAddressInMCU,@24
 	mEWDS                                      ; disable
 	LCALL               IO_93C46_QUIT
 	BANK                0
	MOV                 A,@0x07
	MOV                 TWTCR,A
	LCALL               CHANGE_TO_INQ_VALUE
	ENI
	CLR                 ComuClock
	CLR                 ComuCycleNum
	CLR                 ComuEndNum
	CLR                 CommuStatusFlag
	CLR                 GeneralStatusFlag1
	CLR                 GeneralStatusFlag2
	CLR                 CHN_FLAG
	LCALL               SearchLinkMode_Set
	BANK                0
	BC                  AT93C46_CS/16,AT93C46_CS%16              ; Disable 93C46
	BS                  SPI_SS/16,SPI_SS%16                      ; Disable EM198810
	JMP                 Detected_Connect_Key
	ORG                 0X800   ; PAGE 2
Normal_Communicate:
Lossframe_Communicate:
	BANK                1
	INC                 CH_NO
	LCALL               RF_FREQ_SET
	MOV                 A,CH_NO
	XOR                 A,@16
	JBC                 STATUS,Z
	CLR                 CH_NO
	LCALL               Enter_StandbyII_Mode
	LCALL               RESET_RF_FIFO
	LCALL               ENTER_RX_BUFFER_NACK
	CLR                 ComuClock
	BANK                0
Waiting_For_NormalData_arrive:
	MOV                 A,ComuClock                    
	XOR                 A,@ComuTime                  
	JBC                 STATUS,Z                      
	JMP                 LoseFrameStatus_Timeout        
	JBS                 PKT_FLAG/16,PKT_FLAG%16	    
	JMP                 Waiting_For_NormalData_arrive
	BANK                0
	MOV                 A,@0x04                
	MOV                 TWTCR,A
	MOV                 A,@(255-124)          
	MOV                 TCC,A                  
	CLR                 ComuClock
	MOV                 A,@0X80              
	XOR                 PORT8,A

	LCALL               READ_FIFO_RAM
	LCALL               Enter_StandbyII_Mode	
	JBC                 ReadLengthError/16,ReadLengthError%16
	JMP                 LoseFrameStatus_Timeout
	BANK                1
	MOV                 A,RX_IDH
	BANK                0
	XOR                 RX_IDH_Buffer,A
	JBS                 STATUS,Z
	JMP                 LoseFrameStatus_Timeout         
	BANK                1
	MOV                 A,RX_IDL
	BANK                0
	XOR                 RX_IDL_Buffer,A
	JBS                 STATUS,Z
	JMP                 LoseFrameStatus_Timeout         
	BANK                1
	LCALL               NormalLinkMode_Set
	CLR                 LossframeCNT
	MOV                 A,ComuClock           
	XOR                 A,ComuCycleNum
	JBS                 STATUS,Z
	JMP                 $-3
    MOV                 A,@14                        
    MOV                 Databytelength,A
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

	LCALL               Enter_TX_Buffer_ACK
	LCALL               Reset_RF_FIFO
	LCALL               Write_FIFO_RAM
	LCALL               Key_Scan              
	MOV                 A,ComuClock                       
	XOR                 A,ComuEndNum
	JBS                 STATUS,Z
	JMP                 $-3
	NOP
	JMP                 Normal_Communicate    ; a cycle End
LoseFrameStatus_Timeout:
	LCALL               Enter_StandbyII_Mode
	MOV                 A,ComuEndNum
	XOR                 A,ComuClock                       ;2ms a cycle ,
	JBS                 STATUS,Z
	JMP                 $-4
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
	LCALL               LoseFrameLinkMode_Set
	MOV                 A,LossframeCNT                    ;LossframeCNT>10 stand for loss frequency
	SUB                 A,@5
	JBS                 STATUS,C
	JMP                 LoseFreqStatus_Timeout
	INC                 LossframeCNT
	JMP                 Lossframe_Communicate

LoseFreqStatus_Timeout:
	LCALL               SearchLinkMode_Set
	BANK                1
	CLR                 ComuClock
	CLR                 ComuCycleNum
	CLR                 ComuEndNum
	CLR                 LossframeCNT
	CLR                 CHN_FLAG
	RET                                               


