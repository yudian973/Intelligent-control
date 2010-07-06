/*****************************************************************
* Filename     :  BMA020drvOnEM78P520.ASM
* Author       :  yu.wei
* Company      :  ELAN
* VERSION      :  1.0
* CRYSTAL      :  12MHZ
* Creat date   :  2009/8/20
* tool ver.    :  WicePlus 2.7
* Description  :  modify for code conformity
*****************************************************************/
;------------------------------------------------------------
BMA020drvOnEM78P520.ASM    EQU    BMA020drvOnEM78P520.ASM

include "BMA020drvOnEM78P520.H"
;-------------------------------------------------------------------



;===================== GS MODULE UART TEST =======================
/*
GS_FUNCTION:
	MOV                 A,@0XF0
	MOV                 GS_Preamble,A
	MOV                 A,@0X00
	MOV                 GS_Command,A
	MOV                 A,@0X04
	MOV                 GS_Length,A
	MOV                 A,@0X17
	MOV                 GS_XPOINT_LOW,A	
	MOV                 A,@0XD8
	MOV                 GS_YPOINT_LOW,A	
	MOV                 A,@0XCF
	MOV                 GS_ZPOINT_LOW,A	
	MOV                 A,@0X0C
	MOV                 GS_POINT_HIGH,A	
	RET
*/


	ORG			0X1C00
;***********************************************************
;G-Sensor Function Program
;input:	  GS_PARAMETER
;output:  GS_STATUS,GS_XPOINT_LOW,GS_YPOINT_LOW,
;		  GS_ZPOINT_LOW,GS_POINT_HIGH
;***********************************************************
GS_FUNCTION:
	BANK		4
	BS			PAIOCR,4
	BANK		5
	BS			PAPHCR,4
	BANK		0
	MOV			A,@00001100B
	OR			PORTA,A  
	BANK		2
	MOV			A,@00000000B						; Shift left, SDO delay time: 16clk,
	MOV			SPIS, A								; disable open-drain
	MOV 		A, @11001001B						;rising edge read data
	MOV 		SPIC, A
	BANK		6
	MOV			A,@11000000B
	OR			RSR,A
	JBC			GS_PARAMETER,0
	JMP			GS_Init
	JBC			GS_PARAMETER,2
	JMP			Get_GS_Data
	JBC			GS_PARAMETER,1
	JMP			GS_Enter_Sleep
	JMP			GS_WakeUP
EXIT_GS_FUNCTION:
	BANK		2
	MOV 		A, @01001010B						;falling edge read data
	MOV 		SPIC, A
	RET
;***********************************************************
;GS Initialize
;input:	  GS_PARAMETER
;output:  GS_STATUS
;***********************************************************	
GS_Init:
	BANK		6
	JBC			GS_STATUS,F_GS_Init
	JMP			GS_Init_Exit
	BANK		0
	BC			SPI_BUS, F_GS_SS
	BANK		6
	MOV			A, @0X0A							;address of sleep register is 0X0A 
	LCALL		SIM_SPI_WRITE
	LCALL		Delay_10us
	MOV			A, @0X02							;set reset bit=1,sleep bit=0	
	LCALL		SIM_SPI_WRITE
	BANK		0
	BS			SPI_BUS, F_GS_SS
	LCALL		Delay_10us
	BANK		0
	BC			SPI_BUS, F_GS_SS
	MOV			A, @0X15							;address of INT register is 0X15
	LCALL		SIM_SPI_WRITE
	LCALL		Delay_10us
	MOV			A, @11000000B						;set SPI4,Disable_adv_int
	LCALL		SIM_SPI_WRITE
	BANK		0
	BS			SPI_BUS, F_GS_SS
	LCALL		Delay_10us
	BANK		0
	BC			SPI_BUS, F_GS_SS
	MOV			A, @0X0B							;address of range & bandwidth register is 0X14
	LCALL		SIM_SPI_WRITE	
	LCALL		Delay_10us
	MOV			A,@01000000B
	LCALL		SIM_SPI_WRITE
	BANK		0
	BS			SPI_BUS, F_GS_SS
	LCALL		Delay_10us
	BANK		0
	BC			SPI_BUS, F_GS_SS
	MOV			A, @0X14							;address of range & bandwidth register is 0X14
	OR			A,@10000000B
	LCALL		SIM_SPI_WRITE
	LCALL		Delay_10us
	LCALL		SIM_SPI_READ
	BANK		0
	BS			SPI_BUS, F_GS_SS
	AND			A,@11100000B						
	OR			A,@00000000B						;rang=2g,bandwidth=25Hz
	BANK		6
	MOV			DATA_BAK,A
	BANK		0
	BC			SPI_BUS, F_GS_SS
	MOV			A, @0X14							;address of range & bandwidth register is 0X14
	LCALL		SIM_SPI_WRITE
	NOP
	NOP
	NOP
	NOP
	NOP
	MOV			A,DATA_BAK
	LCALL		SIM_SPI_WRITE
	;...
	BANK		0
	BS			SPI_BUS, F_GS_SS
	BANK		6
	BS			GS_STATUS,F_GS_Init
GS_Init_Exit:
	JMP			EXIT_GS_FUNCTION
;***********************************************************
;GS Enter Sleep
;input:	  GS_PARAMETER
;output:  GS_STATUS
;***********************************************************	
GS_Enter_Sleep:
	BANK		6
	JBC			GS_STATUS,F_GS_Sleep
	JMP			GS_Enter_Sleep_Exit
	BANK		0
	BC			SPI_BUS, F_GS_SS	
	MOV			A, @0X0A							;address of sleep register is 0X0A 
	LCALL		SIM_SPI_WRITE
	LCALL		Delay_10us
	MOV			A, @0X01							;set sleep bit=1	
	LCALL		SIM_SPI_WRITE
	BS			GS_STATUS,F_GS_Sleep
	BANK		0
	BS			SPI_BUS, F_GS_SS
GS_Enter_Sleep_Exit:
	JMP			EXIT_GS_FUNCTION
;***********************************************************
;GS Wake Up
;input:	  GS_PARAMETER
;output:  GS_STATUS
;***********************************************************	
GS_WakeUP:
	BANK		6
	JBS			GS_STATUS,F_GS_Sleep
	JMP			GS_WakeUp_Exit
	BANK		0
	BC			SPI_BUS, F_GS_SS
	MOV			A,@0X15							;address of wakeup register is 0X15 
	LCALL		SIM_SPI_WRITE
	LCALL		Delay_10us
	MOV			A,@11000001B
	LCALL		SIM_SPI_WRITE
	BC			GS_STATUS,F_GS_Sleep
	BANK		0
	BS			SPI_BUS, F_GS_SS
GS_WakeUp_Exit:
	JMP			EXIT_GS_FUNCTION
;***********************************************************
;Get GS Data
;input:	  GS_PARAMETER
;output:  GS_STATUS,GS_XPOINT_LOW,GS_YPOINT_LOW,
;		  GS_ZPOINT_LOW,GS_POINT_HIGH
;***********************************************************
Get_GS_Data:	
	BANK		0
	BC			SPI_BUS,F_GS_SS					;enable Gsensor SPI BUS
	MOV 		A, @GS_Addr
	OR 			A, @0X80
	LCALL 		SIM_SPI_WRITE
	LCALL		Delay_10us
	LCALL		SIM_SPI_READ
	MOV			GS_X_Low,A							;get gsensor X low byte
	LCALL		Delay_10us
	LCALL		SIM_SPI_READ
	MOV			GS_X_High,A							;get gsensor X high byte(2bit)
	LCALL		Delay_10us
	LCALL		SIM_SPI_READ
	MOV			GS_Y_Low,A							;get gsensor Y low byte			
	LCALL		Delay_10us
	LCALL		SIM_SPI_READ
	MOV			GS_Y_High,A							;get gsensor Y high byte(2bit)
	LCALL		Delay_10us
	LCALL		SIM_SPI_READ
	MOV			GS_Z_Low,A							;get gsensor Z low byte			
	LCALL		Delay_10us
	LCALL		SIM_SPI_READ
	MOV			GS_Z_High,A							;get gsensor Z high byte(2bit)
	LCALL		Delay_10us
	BANK		0
	BS			SPI_BUS,F_GS_SS						;disable gsensor SPI BUS
	BANK		6
	MOV			A,@0X06
	MOV			Cyc_Cnt,A
XR_LOOP:
	BC			STATUS,C
	RRC			GS_X_High
	RRC			GS_X_Low
	DJZ			Cyc_Cnt
	JMP			XR_LOOP
	MOV			A,GS_X_Low
	MOV			GS_XPOINT_LOW,A
	MOV			A,@0X06
	MOV			Cyc_Cnt,A
YR_LOOP:
	BC			STATUS,C
	RRC			GS_Y_High
	RRC			GS_Y_Low
	DJZ			Cyc_Cnt
	JMP			YR_LOOP
	MOV			A,GS_Y_Low
	MOV			GS_YPOINT_LOW,A
	MOV			A,@0X06
	MOV			Cyc_Cnt,A
ZR_LOOP:
	BC			STATUS,C
	RRC			GS_Z_High
	RRC			GS_Z_Low
	DJZ			Cyc_Cnt
	JMP			ZR_LOOP
	MOV			A,GS_Z_Low
	MOV			GS_ZPOINT_LOW,A
	CLR			GS_POINT_HIGH
	MOV			A,GS_Z_High
	OR			GS_POINT_HIGH,A
	SWAPA		GS_X_High
	OR			GS_POINT_HIGH,A
	BC			STATUS,C
	RLCA		GS_Y_High
	MOV			DATA_BAK,A
	RLCA		DATA_BAK
	OR			GS_POINT_HIGH,A
	NOP
;-----------------------------------------------------------
;Gsensor data switch to unsigned int(0000000000~1111111111)
;-----------------------------------------------------------
SWITCH_X_Data:
	MOV			A,@0X02
	SUB			A,GS_X_High
	JBS			STATUS,C
	JMP			X_Plus
	JMP			X_Minus
X_Plus:
	MOV			A,@0X02
	ADD			GS_X_High,A
	JMP			SWITCH_Y_Data
X_Minus:
	MOV			A,@0X02
	SUB			GS_X_High,A
SWITCH_Y_Data:
	MOV			A,@0X02
	SUB			A,GS_Y_High
	JBS			STATUS,C
	JMP			Y_Plus
	JMP			Y_Minus	
Y_Plus:
	MOV			A,@0X02
	ADD			GS_Y_High,A
	JMP			SWITCH_Z_Data	
Y_Minus:	
	MOV			A,@0X02
	SUB			GS_Y_High,A
SWITCH_Z_Data:
	MOV			A,@0X02
	SUB			A,GS_Z_High
	JBS			STATUS,C
	JMP			Z_Plus
	JMP			Z_Minus	
Z_Plus:
	MOV			A,@0X02
	ADD			GS_Z_High,A
	JMP			GS_Data_Compare	
Z_Minus:	
	MOV			A,@0X02
	SUB			GS_Y_High,A
;-----------------------------------------------------------
;FUNCTION:比较x/y/z轴前后两次变化的大小, 若差值大于					
;＃GS_Margin則置标志位，否则清相应标志位。		   					
;input:  GS_X_LOW,GS_Y_LOW,GS_Z_LOW,GS_POINT_HIGH		   					
;OUTPUT: F_GS_New								
;-----------------------------------------------------------
GS_Data_Compare:
	BC			GS_STATUS,F_GS_New
Judge_X_Axis:
	MOV			A,GS_X_Low_BAK
	SUB			A,GS_X_Low
	MOV			Minus_Low,A
	JBC			STATUS,C
	JMP			Compare_X_High
	DEC			GS_X_High
Compare_X_High:
	MOV			A,GS_X_High_BAK
	SUB			A,GS_X_High
	MOV			Minus_High,A
	JBC			STATUS,C
	JMP			Compare_X_Margin
	COM			Minus_Low
	COM			Minus_High
	MOV			A,@0X01
	ADD			Minus_Low,A
	JBC			STATUS,C
	INC			Minus_High
Compare_X_Margin:
	MOV			A,Minus_High
	JBS			STATUS,Z
	JMP			Set_New_Flag
	MOV			A,Minus_Low
	SUB			A,@GS_Margin
	JBS			STATUS,C
	JMP			Set_New_Flag
Judge_Y_Axis:
	MOV			A,GS_Y_Low_BAK
	SUB			A,GS_Y_Low
	MOV			Minus_Low,A
	JBC			STATUS,C
	JMP			Compare_Y_High
	DEC			GS_Y_High
Compare_Y_High:
	MOV			A,GS_Y_High_BAK
	SUB			A,GS_Y_High
	MOV			Minus_High,A
	JBC			STATUS,C
	JMP			Compare_Y_Margin
	COM			Minus_Low
	COM			Minus_High
	MOV			A,@0X01
	ADD			Minus_Low,A
	JBC			STATUS,C
	INC			Minus_High
Compare_Y_Margin:
	MOV			A,Minus_High
	JBS			STATUS,Z
	JMP			Set_New_Flag
	MOV			A,Minus_Low
	SUB			A,@GS_Margin
	JBS			STATUS,C
	JMP			Set_New_Flag
Judge_Z_Axis:
	MOV			A,GS_Z_Low_BAK
	SUB			A,GS_Z_Low
	MOV			Minus_Low,A
	JBC			STATUS,C
	JMP			Compare_Z_High
	DEC			GS_Z_High
Compare_Z_High:
	MOV			A,GS_Z_High_BAK
	SUB			A,GS_Z_High
	MOV			Minus_High,A
	JBC			STATUS,C
	JMP			Compare_Z_Margin
	COM			Minus_Low
	COM			Minus_High
	MOV			A,@0X01
	ADD			Minus_Low,A
	JBC			STATUS,C
	INC			Minus_High
Compare_Z_Margin:
	MOV			A,Minus_High
	JBS			STATUS,Z
	JMP			Set_New_Flag
	MOV			A,Minus_Low
	SUB			A,@GS_Margin
	JBS			STATUS,C
	JMP			Set_New_Flag
	JMP			BAK_Data_Updata
Set_New_Flag:
	BS			GS_STATUS,F_GS_New
BAK_Data_Updata:
	MOV			A,GS_X_High
	MOV			GS_X_High_BAK,A
	MOV			A,GS_X_Low
	MOV			GS_X_Low_BAK,A
	MOV			A,GS_Y_High
	MOV			GS_Y_High_BAK,A
	MOV			A,GS_Y_Low
	MOV			GS_Y_Low_BAK,A
	MOV			A,GS_Z_High
	MOV			GS_Z_High_BAK,A
	MOV			A,GS_Z_Low
	MOV			GS_Z_Low_BAK,A
Compare_End:
	JMP			EXIT_GS_FUNCTION	
;===========================================================