/*****************************************************************
* Filename     :  EM78P520_32PIN44PIN_TX.ASM
* Author       :  yu.wei
* Company      :  ELAN
* VERSION      :  1.0
* CRYSTAL      :  8MHZ
* Creat date   :  2009/9/11
* tool ver.    :  WicePlus 2.7
* Description  :  modify for code conformity
*****************************************************************/
;-----------------------------------------------------------------
include "D:\include\EM78xx\EM78P510.H"
include "D:\include\EM78xx\EM78Math.H"
include "D:\include\EM78xx\EM78CtrlIns.H"
include "config.h"
include "P520txP32P44V10.H"
include "EM198850_For_EM78P520.ASM"
include "P520SkipFreqFun.ASM"
include "XX93C46_For_EM78P520.ASM"
;include "FccTest.asm"

;-----------------------------------------------------------------



;--------------------------MAIN PROGRAM---------------------------
	ORG                 0X00
	JMP                 INITIAL
	ORG                 0X03
	JMP                 TCC_INT
	ORG                 0X06
	JMP                 EXTERNAL_INT
	ORG                 0X09
	JMP                 WDT_INT
	ORG                 0X0C
	JMP                 TIMER1_INT
	ORG                 0X0F
	JMP                 TIMER2_INT
	ORG                 0X12
	JMP                 AD_INT
	ORG                 0X15
	JMP                 UART_INT
	ORG                 0X18
	JMP                 SPI_INT
	ORG                 0X1B
	JMP                 LVD_INT


	ORG                 0X100
;========================= TCC Interrupt Service ==================================
TCC_INT:
	PUSH
	BANK                0
	BC                  ISR,TCIF               
	JBC                 SearchStatusFlag/16,SearchStatusFlag%16
	JMP                 Search_Status_Mode
	JBC                 LoseFrameStatusFlag/16,LoseFrameStatusFlag%16
	JMP                 LoseFrame_Status_Mode
	JBC                 NormalStatusFlag/16,NormalStatusFlag%16
	JMP                 Normal_Status_Mode
	JMP                 TCC_INT_END
;---------------------------------------------------------------------------
	Normal_Status_Mode:
		MOV             A,@0x04               
		MOV             TWTCR,A
		MOV             A,@(255-124)          
		MOV             TCC,A
		JMP             TCC_INT_END
;-------------------------------------------------------------------
	Search_Status_Mode:
		MOV             A,@0x07                
		MOV             TWTCR,A
		MOV             A,@(255-124)           
		MOV             TCC,A
		BANK            2
		INC             KeySystemTimeCNT
		MOV             A,KeySystemTimeCNT
		SUB             A,@1                   
		JBC             STATUS,C
		JMP             TCC_INT_END
		BS              System16msFlag/16,System16msFlag%16
		CLR             KeySystemTimeCNT
		BANK            0
		MOV             A,@0X40               
		XOR             PORT8,A
		JMP             TCC_INT_END
;-------------------------------------------------------------------
	LoseFrame_Status_Mode:
		MOV             A,@0x04               
		MOV             TWTCR,A
		MOV             A,@(255-124)           
		MOV             TCC,A
		JMP             TCC_INT_END
TCC_INT_END:
	BANK                0
	MOV                 A,@0X80               
	XOR                 PORT8,A
	INC                 ComuClock
	POP
	RETI

EXTERNAL_INT:
WDT_INT:
AD_INT:
TIMER1_INT:
	RETI
TIMER2_INT:
UART_INT:
SPI_INT:
LVD_INT:
	RETI
INITIAL:
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	DISI
	NOP
	NOP
	NOP
	DISI
	NOP
	NOP
	NOP
	DISI
	NOP
	ClrCommRamBank
	NOP
	ClrRamBank
	NOP
	CALL                IO_INITIAL
	NOP
	BANK                0
	BC                  AT93C46_CS/16,AT93C46_CS%16     
	BS                  SPI_SS/16,SPI_SS%16             

	LCALL               EM198850_RESET
	NOP
	NOP


	LCALL               IO_93C46_INITIAL   
	BANK                0
	BC                  AT93C46_CS/16,AT93C46_CS%16    
	BS                  SPI_SS/16,SPI_SS%16            
	MOV                 A,@0X00
	MOV                 DataAddressInEEPROM,A
	MOV                 A,@0X60
	MOV                 DataAddressInMCU,A
	mREAD               DataAddressInEEPROM,@0,DataAddressInMCU,@16
	;mEWDS
	LCALL               IO_93C46_QUIT      


	BANK                0
	MOV                 A,RX_IDH_Buffer   
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
	BANK                0
	BC                  AT93C46_CS/16,AT93C46_CS%16      
	BS                  SPI_SS/16,SPI_SS%16               


	BANK                1
	MOV                 A,@0XFF           
	XOR                 A,RX_IDH
	JBC                 STATUS,Z
	JMP                 Used_Default_Sync
	MOV                 A,@0XFF
	XOR                 A,RX_IDL
	JBC                 STATUS,Z
	JMP                 Used_Default_Sync
	JMP                 Start_Up
Used_Default_Sync:
	MOV                 A,@0X80             
	MOV                 RX_IDH,A
	MOV                 A,@0X16
	MOV                 RX_IDL,A
Start_Up:
	LCALL               CHANGE_TO_INQ_VALUE
	CLR                 CH_NO
	LCALL               RF_FREQ_SET

	ENI
	BANK                0
	CLR                 ComuClock
	CLR                 ComuCycleNum
	CLR                 ComuEndNum
	BS                  LED1_STATUS/16,LED1_STATUS%16		   
	BC                  AT93C46_CS/16,AT93C46_CS%16             
	BS                  SPI_SS/16,SPI_SS%16                    

	CLR                 CommuStatusFlag
	CLR                 GeneralStatusFlag1
	CLR                 GeneralStatusFlag2
	CLR                 CHN_FLAG
	BANK                2
	MOV                 A,@0XFF
	MOV                 KeystokeFlag_Befor,A
	MOV                 KeystokeTimeCNT,A
	CALL                SearchLinkMode_Set
	NOP


;=============================================================================
MAIN:

	LCALL               Search_Equipment
	NOP
	BC                  LED1_STATUS/16,LED1_STATUS%16
	NOP
	LCALL               Normal_Communicate
	NOP
	NOP
	JMP                 MAIN
IO_INITIAL:
	BANK                0
	MOV                 A,@0x07              
	MOV                 TWTCR,A
	MOV                 A,@(255-124)         
	MOV                 TCC,A
	MOV                 A,@0X01
	MOV                 IMR, A        	
	CLR                 ISR            
	CLR                 PORTA          
	MOV                 A,@0x01
	BANK                1
	CLR                 EISR            	
	CLR                 EIMR            	
	BANK                4		       
	MOV                 A,@00010000B	
	MOV                 PAIOCR,A     
	MOV                 A,@00010000B   
	MOV                 PAPHCR,A
	MOV                 A,@00110111B	
	MOV                 PBIOCR,A       
	BANK                5
	MOV                 A,@00110111B
	MOV                 PBPHCR,A	    	
	BANK                0
	CLR                 PORTA          
	CLR                 PORTB           
	BANK                2
	MOV                 A,@00000000B   
	MOV                 SPIS, A         
	MOV                 A,@11001000B  
	MOV                 SPIC,A        
 	BANK                4
 	MOV                 A,@11111111B
 	MOV                 IOC9,A          
 	MOV                 A,@00000000B
 	MOV                 IOC7,A         
 	MOV                 A,@00000000B
 	MOV                 IOC8,A         
 	BANK                5
 	MOV                 A,@11110000B
 	MOV                 P9PHCR,A		
 	BANK                6
 	CLR                 PBODCR
 	BANK                1
 	MOV                 A,@00000000B	
 	AND                 LCDSCR0, A
 	AND                 LCDSCR1, A
 	AND                 LCDSCR2, A
	BANK                0
	CLR                 PORT7          
	CLR                 PORT8          
	CLR                 PORT9           
	BC                  AT93C46_CS/16,AT93C46_CS%16  
	BS                  SPI_SS/16,SPI_SS%16           
	RET
SearchLinkMode_Set:         ;0X11
	BS                  SearchStatusFlag/16,SearchStatusFlag%16            ;set search mode
	BC                  NormalStatusFlag/16,NormalStatusFlag%16            ;Clear normal mode
	BC                  LoseFrameStatusFlag/16,LoseFrameStatusFlag%16      ;Clear LoseFreq mode
	BC                  EEpromWRStatusFlag/16,EEpromWRStatusFlag%16
	BS                  LinkModeFlag/16,LinkModeFlag%16
	BC                  ForceLinkModeFlag/16,ForceLinkModeFlag%16
	BC                  FccTestModeFlag/16,FccTestModeFlag%16
	RET

SearchForceLinkMode_Set:    ;0X25
	BS                  SearchStatusFlag/16,SearchStatusFlag%16            ;set search mode
	BC                  NormalStatusFlag/16,NormalStatusFlag%16            ;Clear normal mode
	BS                  LoseFrameStatusFlag/16,LoseFrameStatusFlag%16      ;Clear LoseFreq mode
	BC                  EEpromWRStatusFlag/16,EEpromWRStatusFlag%16
	BC                  LinkModeFlag/16,LinkModeFlag%16
	BS                  ForceLinkModeFlag/16,ForceLinkModeFlag%16
	BC                  FccTestModeFlag/16,FccTestModeFlag%16
	RET

NormalLinkMode_Set:         ;0X12
	BC                  SearchStatusFlag/16,SearchStatusFlag%16            ;Clear search status
	BS                  NormalStatusFlag/16,NormalStatusFlag%16            ;set normal mode
	BC                  LoseFrameStatusFlag/16,LoseFrameStatusFlag%16      ;Clear LoseFreq mode
	BC                  EEpromWRStatusFlag/16,EEpromWRStatusFlag%16
	BS                  LinkModeFlag/16,LinkModeFlag%16
	BC                  ForceLinkModeFlag/16,ForceLinkModeFlag%16
	BC                  FccTestModeFlag/16,FccTestModeFlag%16
	RET

LoseFrameLinkMode_Set:      ;0X16
	BC                  SearchStatusFlag/16,SearchStatusFlag%16            ;Clear search status
	BS                  NormalStatusFlag/16,NormalStatusFlag%16            ;set normal mode
	BS                  LoseFrameStatusFlag/16,LoseFrameStatusFlag%16      ;Clear LoseFreq mode
	BC                  EEpromWRStatusFlag/16,EEpromWRStatusFlag%16
	BS                  LinkModeFlag/16,LinkModeFlag%16
	BC                  ForceLinkModeFlag/16,ForceLinkModeFlag%16
	BC                  FccTestModeFlag/16,FccTestModeFlag%16
	RET

LoseFrameForceLinkMode_Set: ;0X25
	BS                  SearchStatusFlag/16,SearchStatusFlag%16            ;Clear search status
	BC                  NormalStatusFlag/16,NormalStatusFlag%16            ;set normal mode
	BS                  LoseFrameStatusFlag/16,LoseFrameStatusFlag%16      ;Clear LoseFreq mode
	BC                  EEpromWRStatusFlag/16,EEpromWRStatusFlag%16
	BC                  LinkModeFlag/16,LinkModeFlag%16
	BS                  ForceLinkModeFlag/16,ForceLinkModeFlag%16
	BC                  FccTestModeFlag/16,FccTestModeFlag%16
	RET

FccSearchLinkMode_Set:      ;0X41
	BS                  SearchStatusFlag/16,SearchStatusFlag%16            ;set search mode
	BC                  NormalStatusFlag/16,NormalStatusFlag%16            ;Clear normal mode
	BC                  LoseFrameStatusFlag/16,LoseFrameStatusFlag%16      ;Clear LoseFreq mode
	BC                  EEpromWRStatusFlag/16,EEpromWRStatusFlag%16
	BC                  LinkModeFlag/16,LinkModeFlag%16
	BC                  ForceLinkModeFlag/16,ForceLinkModeFlag%16
	BS                  FccTestModeFlag/16,FccTestModeFlag%16
	RET