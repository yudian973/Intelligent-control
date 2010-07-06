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
M611rxP40M1v6V10.ASM    EQU    M611rxP40M1v6V10.ASM

include "D:\include\EM78xx\EM78M611.H"
include "D:\include\EM78xx\EM78CtrlIns.H"
include "D:\include\EM78xx\EM78Math.H"
include "config.h"
include "M611rxP40M1v6V10.H"
include "EM198850_For_EM78M611.ASM"
include "M611SkipFreqFun.ASM"
include "M611ManageFunc.ASM"
;include "XX24C04.ASM"
;include "FccTest.ASM"

ifndef XX93C46_For_EM78M611.ASM
include "XX93C46_For_EM78M611.ASM"
endif
	ORG                 0X0000
	JMP                 MCU_RESET
	ORG                 0X0001        
	PUSH                              
	CLR                 RSR
	JMP                 TCC_INT_STATE
	ORG                 0X0050
TCC_INT_STATE:
	NOP
	JBC                 ISR,EP0IF
	JMP                 USB_EP0_INT
	JBC                 ISR,USBRIF
	JMP                 USB_RESET_INT
	JBC                 ISR,TCCIF
	JMP                 RF_CYCLE_INT
	JBC                 ISR,USBSIF
	JMP                 USB_SUSPEND_INT
RF_CYCLE_INT:
	MOV                 A,@(256-47)  
	MOV                 TCC,A
	BC                  ISR,TCCIF
	INC                 ComuClock   
	INC                 SystemTimeCNT
	MOV                 A,@0X80      
	XOR                 PORT5,A
	JMP                 INT_RET
USB_EP0_INT:
	PAGE                4
	JMP                 READ_COMMAND 
USB_SUSPEND_INT:                     
	BC                  ISR,USBSIF
	JMP                 INT_RET
USB_RESET_INT:
	MOV                 A,@0X01
	MOV                 PROTOCOL_TEMP,A
	BC                  ISR,USBRIF
	JMP                 INT_RET
INT_RET:
	POP                              ;
	RETI
MCU_RESET:
	DISI
	MOV                 A,@200          
	PAGE                5
	CALL                DELAY_X100US
	PAGE                0
	NOP
	ClrRamBank
	NOP
	MOV                 A,@00110000B   
	IOW                 IOC7
	NOP
	MOV                 A,@00000100B
	IOW                 IOC9
	NOP
	MOV                 A,@00000000B
	IOW                 IOC8
	NOP
	MOV                 A,@00100000B   
	IOW                 IOC5
	NOP
	MOV                 A,@01100001B	
	IOW                 IOC6
	NOP
	MOV                 A,@11110011B	
	IOW                 IOCD
	NOP
	MOV                 A,@11010000B	
	IOW                 IOCE
	NOP
	MOV                 A,@00000001B	
	IOW                 IOCA
	NOP
	MOV                 A,@01101000B		
	CONTW				                    
	CLR                 TCC                 
	CLR                 ISR                
	MOV                 A,@00000011B
	IOW                 IMR                 
	NOP
	PAGE                5
	NOP
	CALL                EM198850_RESET        
	NOP
	PAGE                0
	BS                  SPI_SS/16,SPI_SS%16                 
	MOV                 A,@0X00
	MOV                 DataAddressInEEPROM,A
	MOV                 A,@0X60
	MOV                 DataAddressInMCU,A
	mREAD               DataAddressInEEPROM,@0,DataAddressInMCU,@16
	BC                  AT93C46_CS/16,AT93C46_CS%16           
	CALL                PAGE0BANK0                           
	MOV                 A,RX_IDH_Buffer
	CALL                PAGE0BANK1
	MOV                 RX_IDH,A
	CALL                PAGE0BANK0
	MOV                 A,RX_IDL_Buffer
	CALL                PAGE0BANK1
	MOV                 RX_IDL,A
	CALL                PAGE0BANK0
	MOV                 A,TX1_ID_Buffer
	CALL                PAGE0BANK1
	MOV                 TX1_ID,A
	CALL                PAGE0BANK0
	MOV                 A,TX2_ID_Buffer
	CALL                PAGE0BANK1
	MOV                 TX2_ID,A
	CALL                PAGE0BANK0
	MOV                 A,TX3_ID_Buffer
	CALL                PAGE0BANK1
	MOV                 TX3_ID,A
	CALL                PAGE0BANK0
	MOV                 A,TX4_ID_Buffer
	CALL                PAGE0BANK1
	MOV                 TX4_ID,A
	CALL                PAGE0BANK0
	MOV                 A,TX5_ID_Buffer
	CALL                PAGE0BANK1
	MOV                 TX5_ID,A

	CALL                PAGE0BANK0
	MOV                 A,TX6_ID_Buffer
	CALL                PAGE0BANK1
	MOV                 TX6_ID,A
	CALL                PAGE0BANK1
	MOV                 A,RX_IDH
	XOR                 A,RX_IDL
	JBS                 STATUS,Z
	JMP                 Run_Start
	MOV                 A,RX_IDL
	XOR                 A,@0XFF
	JBC                 STATUS,Z  
	BS                  EEpromWRStatusFlag/16,EEpromWRStatusFlag%16
Run_Start:
	JBC                 EEpromWRStatusFlag/16,EEpromWRStatusFlag%16
	CALL                Rand_ID_Function
	PAGE                5
	CALL                CHANGE_TO_INQ_VALUE
	CALL                RF_FREQ_SET	
	PAGE                0
	CALL                PAGE0BANK0
	NOP
	ENI
	CLR                 ComuClock
	CLR                 CommuStatusFlag
	CLR                 GeneralStatusFlag
	CLR                 CHN_FLAG
	CLR                 TEMP
	CALL                PAGE0BANK1
	BS                  KeyStatusFlag/16,KeyStatusFlag%16
	MOV                 A,@0XFF
	MOV                 KeystokeFlag_Befor,A
	MOV                 KeystokeTimeCNT,A
	BC                  LED1_STATUS/16,LED1_STATUS%16
	CALL                SearchLinkMode_Set
	BC                  PORT8,0
 	MOV                 A,@(256-47) 
	MOV                 TCC,A        
	CLR                 ComuClock
 	NOP
MAIN:
	WDTC
 	PAGE                0
	CALL                SYNC_COM_TX
	PAGE                1
 	CALL                RX1_FUNCTION
 	CALL                RX2_FUNCTION
 	CALL                RX3_FUNCTION
 	CALL                RX4_FUNCTION
 	PAGE                2
 	CALL                RX5_FUNCTION
 	CALL                RX6_FUNCTION
 	PAGE                0
	JMP                 MAIN
Rand_ID_Function:
	MOV                 A,@2
	MOV                 TEMP1,A
	MOV                 A,@0X60
	MOV                 TEMP2,A
	CALL                RAND_FUCTION 
	CALL                PAGE0BANK1
	MOV                 A,@0XF0      
	AND                 A,RX_IDL
	MOV                 TX1_ID,A
	MOV                 TX2_ID,A
	MOV                 TX3_ID,A
	MOV                 TX4_ID,A
	MOV                 TX5_ID,A
	MOV                 TX6_ID,A
	MOV                 A,@0X01
	ADD                 TX1_ID,A
	MOV                 A,@0X02
	ADD                 TX2_ID,A
	MOV                 A,@0X03
	ADD                 TX3_ID,A
	MOV                 A,@0X04
	ADD                 TX4_ID,A
	MOV                 A,@0X05
	ADD                 TX5_ID,A
	MOV                 A,@0X06
	ADD                 TX6_ID,A
	CALL                PAGE0BANK1  
	MOV                 A,RX_IDH
	CALL                PAGE0BANK0
	MOV                 RX_IDH_Buffer,A
	CALL                PAGE0BANK1
	MOV                 A,RX_IDL
	CALL                PAGE0BANK0
	MOV                 RX_IDL_Buffer,A
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
	RET
RAND_FUCTION:
	MOV                 TEMP,A
	MOV                 A,TEMP2
	ADD                 TEMP,A       

	CLR                 RSR
RAND_SEED_LOOP1:
	MOV                 A,R0
	ADD                 TEMP,A      
	CALL                ArithmeticIns
	INC                 RSR
	MOV                 A,RSR
	AND                 A,@0X40         
	XOR                 A,@0X40
	JBS                 STATUS,Z
	JMP                 RAND_SEED_LOOP1
	MOV                 A,R0
	ADD                 TEMP,A         
RAND_DATA_LOOP1:
	MOV                 A,TEMP2
	MOV                 RSR,A
	MOV                 A,TEMP
	MOV                 R0,A
	CALL                ArithmeticIns
	INC                 TEMP2
	DJZ                 TEMP1
	JMP                 RAND_DATA_LOOP1:
	NOP
	RET
ArithmeticIns:
	RLC         TEMP       
	RLC         TEMP
	RLC         TEMP
	INC         TEMP
	RRC         TEMP
	RRC         TEMP
	RRC         TEMP
	JBS         STATUS,C
	BC          TEMP,0
	JBC         STATUS,C
	BS          TEMP,0
	RET
	PAGE0BANK0:
		BC              0X04,7
		BC              0X04,6
	RET
	PAGE0BANK1:
		BC              0X04,7
		BS              0X04,6
	RET
	PAGE0BANK2:
		BS              0X04,7
		BC              0X04,6
	RET
	PAGE0BANK3:
		BS              0X04,7
		BS              0X04,6
	RET