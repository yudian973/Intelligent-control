;***********************************************************
;File Name: Module
;BODY: 		EM78P520N
;Data:		2009/08/18
;Version: 	1.0
;Author: 	zhaolin
;Company: 	ELAN
;***********************************************************
	ORG			0X1800
;===========================================================
;Subroutine
;===========================================================
;***********************************************************
;Delay 10us
;input:	  None
;output:  None
;***********************************************************
Delay_10us:
	BANK		6
	MOV			A,@0X1A
	MOV			Cyc_Cnt,A
Delay_Loop:
	DJZ			Cyc_Cnt
	JMP			Delay_Loop
	NOP
	RET
;***********************************************************
;Compare Data
;input:	  X1H,X1L,X2H,X2L
;output:  A
;***********************************************************
Compare_Data:
	MOV		A,X2H
	SUB		A,X1H
	JBC		R3,0
	JMP		Judge_High_Equal
	JMP		Return_ZERO
Judge_High_Equal:
	JBC		R3,2
	JMP		Judge_Low_Byte
	JMP		Return_ONE
Judge_Low_Byte:
	MOV		A,X2L
	SUB		A,X1L
	JBS		R3,0
	JMP		Judge_lOW_Equal
	JMP		Return_ONE
Judge_lOW_Equal:
	JBC		R3,2
	JMP		Return_TWO
	JMP		Return_ZERO
Return_ZERO:
	MOV		A,@0X00						;X1<X2
	JMP		Compare_Data_Return
Return_ONE:
	MOV		A,@0X01						;X1>X2
	JMP		Compare_Data_Return
Return_TWO:
	MOV		A,@0X02						;X1=X2
Compare_Data_Return:
	RET
;***********************************************************
;Function:   Write SPI communication
;SPI is ready data on rising edge and read data on falling edge
;Input:	   	TEMP(SPIWB)
;Output:	None
;***********************************************************
SIM_SPI_WRITE:
	DISI
	BANK    	2
	CLR     	SPIS
	CLR     	SPIR
	MOV     	SPIW, A         ; Write data to buffer
	NOP
	NOP
	BS      	SPIC, SSE       ; Start to shift data
	JBC     	SPIC, SSE       ; Wait to finish shift data
	JMP     	$-1
	MOV			A,SPIR
	BANK		6
	ENI
	RET

;***********************************************************
;Function:  Read SPI communication subroutine
;Input:	   	None
;Output:	SPIRB(TEMP)
;***********************************************************
SIM_SPI_READ:
	DISI
	BANK		2
	CLR     	SPIS
	CLR     	SPIR
	CLR			SPIW
	BS      	SPIC, SSE       ; Start to shift data
	JBC     	SPIC, SSE       ; Wait to finish shift data
	JMP     	$-1
	MOV    		A,SPIR
	BANK		6
	ENI
   	RET
;***********************************************************
;CMOS Function Program
;input:	  CMOS_PARAMETER
;output:  CMOS_STATUS,CMOS_XPOINT_LOW,
;		  CMOS_YPOINT_LOW,CMOS_POINT_HIGH
;***********************************************************
CMOS_FUNCTION:
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
	MOV			A,SPIC
	BANK		5
	MOV			SPIC_BAK,A							;Save SPI Config
	BANK		2
	MOV 		A, @11001100B						;rising edge read data
	MOV 		SPIC, A
	BANK		6
	MOV			A,@11000000B
	OR			RSR,A
	JBC			CMOS_PARAMETER,0
	JMP			CMOS_Init
	JBC			CMOS_PARAMETER,2
	JMP			Get_CMOS_Data
	JBC			CMOS_PARAMETER,1
	JMP			CMOS_Power_Down
	JMP			CMOS_WakeUP
EXIT_CMOS_FUNCTION:
	BANK		5
	MOV			A,SPIC_BAK							;Read SPI Config Bak
	BANK		2
	MOV 		SPIC, A
	RET
;***********************************************************
;CMOS Initialize
;input:	  CMOS_PARAMETER
;output:  CMOS_STATUS
;***********************************************************	
CMOS_Init:
	BANK		6
	JBC			CMOS_STATUS,F_CMOS_Init
	JMP			CMOS_Init_Exit
	BANK		0
	BC 			SPI_BUS,F_CMOS_SS
Set_Init:
	MOV 		A, @0X88
	CALL		SIM_SPI_WRITE
	XOR			A,@0XFF
	JBC			R3,2
	JMP			CMOS_Init_Exit
;	MOV			A,@0XFE					;Sensitivity 1
;	MOV			A,@0XB4					;Sensitivity 2
	MOV			A,@0X64					;Sensitivity 3
;	MOV			A,@0X36					;Sensitivity 4
;	MOV			A,@0X20					;Sensitivity 5
	CALL 		SIM_SPI_WRITE
	BS			CMOS_STATUS,F_CMOS_Init
	BANK		0
	BS  		SPI_BUS,F_CMOS_SS
CMOS_Init_Exit:
	JMP			EXIT_CMOS_FUNCTION
;***********************************************************
;CMOS Power Down
;input:	  CMOS_PARAMETER
;output:  CMOS_STATUS
;***********************************************************	
CMOS_Power_Down:
	BANK		6
	JBC			CMOS_STATUS,F_CMOS_Sleep
	JMP			CMOS_Sleep_Exit
	BANK		0
	BC 			SPI_BUS,F_CMOS_SS
Set_Power_Down:
	MOV 		A, @0XFF
	CALL		SIM_SPI_WRITE
	XOR			A,@0XFF
	JBC			R3,2
	JMP			CMOS_Sleep_Exit
	MOV 		A, @0X01
	CALL 		SIM_SPI_WRITE
	BS			CMOS_STATUS,F_CMOS_Sleep
	BANK		0
	BS  		SPI_BUS,F_CMOS_SS
CMOS_Sleep_Exit:
	JMP			EXIT_CMOS_FUNCTION
;***********************************************************
;CMOS Wake Up -- SS拉低5us
;input:	  CMOS_PARAMETER
;output:  CMOS_STATUS
;***********************************************************	
CMOS_WakeUP:
	BANK		6
	JBS			CMOS_STATUS,F_CMOS_Sleep
	JMP			CMOS_WakeUp_Exit
	BANK		0
	BS 			SPI_BUS,F_CMOS_SS
	BC 			SPI_BUS,F_CMOS_SS
	CALL		Delay_10us
	BANK		0
	BS 			SPI_BUS,F_CMOS_SS
CMOS_WakeUp_Exit:
	BANK		6
	BC			CMOS_STATUS,F_CMOS_Sleep
	JMP			EXIT_CMOS_FUNCTION 
;***********************************************************
;Get CMOS Data
;input:	  CMOS_PARAMETER
;output:  CMOS_STATUS,CMOS_XPOINT_LOW,
;		  CMOS_YPOINT_LOW,CMOS_POINT_HIGH
;***********************************************************	
Get_CMOS_Data:
;-----------------------------------------------------------
Read_CMOS_Data:
	BANK		0
	BC 			SPI_BUS,F_CMOS_SS
	CALL		Delay_10us
	NOP
Set_Read_Command:
	MOV			A, @0X37
	CALL		SIM_SPI_WRITE
	XOR			A,@0XFF
	JBC			R3,2
	JMP			Read_Exit
	CALL		Delay_10us
	CALL 		SIM_SPI_READ
	BANK		5
	MOV			CMOS_X1_L,A
	CALL		Delay_10us
	CALL 		SIM_SPI_READ
	BANK		5
	MOV			CMOS_Y1_L,A
	CALL		Delay_10us
	CALL 		SIM_SPI_READ
	BANK		5
	MOV			CMOS_Size1,A
	CALL		Delay_10us
	CALL 		SIM_SPI_READ
	BANK		5
	MOV			CMOS_X2_L,A
	CALL		Delay_10us
	CALL 		SIM_SPI_READ
	BANK		5
	MOV			CMOS_Y2_L,A
	CALL		Delay_10us
	CALL 		SIM_SPI_READ
	BANK		5
	MOV			CMOS_Size2,A
	MOV			A,@0X06
	MOV			Receive_CMOS_Count,A
Read_Receive_CMOS:	
	CALL		Delay_10us
	CALL 		SIM_SPI_READ
	BANK		5
	MOV			Receive_CMOS_Data,A
	DJZ			Receive_CMOS_Count
	JMP			Read_Receive_CMOS
	BANK		0
	BS 			SPI_BUS,F_CMOS_SS
	BANK		5
	SWAPA		CMOS_Size1
	AND			A,@0X0C
	MOV			CMOS_Size_BAK,A
	BC 			R3,0
	RRC			CMOS_Size_BAK
	RRCA		CMOS_Size_BAK
	MOV			CMOS_Y1_H,A
	SWAPA		CMOS_Size1
	AND			A,@0X03
	MOV			CMOS_X1_H,A
	MOV			A,@0X0F
	AND			CMOS_Size1,A
	
	SWAPA		CMOS_Size2
	AND			A,@0X0C
	MOV			CMOS_Size_BAK,A
	BC 			R3,0
	RRC			CMOS_Size_BAK
	RRCA		CMOS_Size_BAK
	MOV			CMOS_Y2_H,A
	SWAPA		CMOS_Size2
	AND			A,@0X03
	MOV			CMOS_X2_H,A
	MOV			A,@0X0F
	AND			CMOS_Size2,A
	JMP			CMOS_Data_Handle			
Read_Exit:
	BANK		0
	BS 			SPI_BUS,F_CMOS_SS
	BANK		6
	BC			CMOS_STATUS,F_CMOS_Valid
	JMP			EXIT_CMOS_FUNCTION
;-----------------------------------------------------------
CMOS_Data_Handle:
	MOV			A,CMOS_Size1
	NOP
	XOR			A,@CMOS_SIZE
	JBC			R3,2
	JMP			CMOS_Deal_End
TransData_To_RAM:
	JBC			System_Flag,F_CMOS_First
	JMP			Normal_Transmit
	MOV			A,CMOS_Size2
	XOR			A,@CMOS_SIZE
	JBC			R3,2
	JMP			CMOS_Deal_End
	BS			System_Flag,F_CMOS_First
	CALL		CMOS_Data_Order
;
	MOV			A,CMOS_X1_H
	MOV			CMOS_X1_H_1,A
	BANK		7
	MOV			CMOS_X1_H_2,A
	MOV			CMOS_X1_H_3,A
	MOV			CMOS_X1_H_4,A
	BANK		5
	MOV			A,CMOS_X1_L
	MOV			CMOS_X1_L_1,A
	BANK		7
	MOV			CMOS_X1_L_2,A
	MOV			CMOS_X1_L_3,A
	MOV			CMOS_X1_L_4,A
	BANK		5
	MOV			A,CMOS_Y1_H
	MOV			CMOS_Y1_H_1,A
	BANK		7
	MOV			CMOS_Y1_H_2,A
	MOV			CMOS_Y1_H_3,A
	MOV			CMOS_Y1_H_4,A
	BANK		5
	MOV			A,CMOS_Y1_L
	MOV			CMOS_Y1_L_1,A
	BANK		7
	MOV			CMOS_Y1_L_2,A
	MOV			CMOS_Y1_L_3,A
	MOV			CMOS_Y1_L_4,A
	BANK		5
	MOV			A,CMOS_Size1
	MOV			CMOS_Size1_1,A
	BANK		7
	MOV			CMOS_Size1_2,A
	MOV			CMOS_Size1_3,A
	MOV			CMOS_Size1_4,A
	BANK		5
	MOV			A,CMOS_X2_H
	MOV			CMOS_X2_H_1,A
	BANK		7
	MOV			CMOS_X2_H_2,A
	MOV			CMOS_X2_H_3,A
	MOV			CMOS_X2_H_4,A
	BANK		5
	MOV			A,CMOS_X2_L
	MOV			CMOS_X2_L_1,A
	BANK		7
	MOV			CMOS_X2_L_2,A
	MOV			CMOS_X2_L_3,A
	MOV			CMOS_X2_L_4,A
	BANK		5
	MOV			A,CMOS_Y2_H
	MOV			CMOS_Y2_H_1,A
	BANK		7
	MOV			CMOS_Y2_H_2,A
	MOV			CMOS_Y2_H_3,A
	MOV			CMOS_Y2_H_4,A
	BANK		5
	MOV			A,CMOS_Y2_L
	MOV			CMOS_Y2_L_1,A
	BANK		7
	MOV			CMOS_Y2_L_2,A
	MOV			CMOS_Y2_L_3,A
	MOV			CMOS_Y2_L_4,A
	BANK		5
	MOV			A,CMOS_Size2
	MOV			CMOS_Size2_1,A
	BANK		7
	MOV			CMOS_Size2_2,A
	MOV			CMOS_Size2_3,A
	MOV			CMOS_Size2_4,A
	JMP			Average_CMOS_Data
Normal_Transmit:
	NOP
	MOV			A,CMOS_Size2
	XOR			A,@CMOS_SIZE
	JBC			R3,2
	JMP			Unkown_Data_Deal
	JMP			Invoke_Data_Order
Unkown_Data_Deal:
	MOV			A,CMOS_Size2_1
	MOV			CMOS_Size2,A
	CALL		Sum_XY_Median
	JBC			CMOS_XH_Median,7
	JMP			Lose_Left_Ray
;-----------------------------------------------------------
;compare CMOS_X1 & CMOS_X_Median,Judge Lose Ray is Left or Right
	MOV			A,CMOS_X1_H
	MOV			X1H,A
	MOV			A,CMOS_X1_L
	MOV			X1L,A
	MOV			A,CMOS_XH_Median
	MOV			X2H,A
	MOV			A,CMOS_XL_Median
	MOV			X2L,A
	CALL		Compare_Data
;-----------------------------------------------------------
	SUB			A,@0X01
	JBS			R3,0
	JMP			Lose_Right_Ray
	JBS			R3,2
	JMP			Lose_Right_Ray
	JMP			Lose_Left_Ray
Lose_Left_Ray:
	MOV			A,CMOS_X1_L
    SUB			A,CMOS_X2_L
    ADD			CMOS_X1_L,A
    SUB			CMOS_X2_L,A
    MOV			A,CMOS_X1_H
    SUB			A,CMOS_X2_H
    ADD			CMOS_X1_H,A
    SUB			CMOS_X2_H,A

	MOV			A,CMOS_Y1_L
    SUB			A,CMOS_Y2_L
    ADD			CMOS_Y1_L,A
    SUB			CMOS_Y2_L,A
    MOV			A,CMOS_Y1_H
    SUB			A,CMOS_Y2_H
    ADD			CMOS_Y1_H,A
    SUB			CMOS_Y2_H,A
    
    MOV			A,CMOS_Size1
    SUB			A,CMOS_Size2
    ADD			CMOS_Size1,A
    NOP
    SUB			CMOS_Size2,A
    
;Count_Minus_Value	Minus_Value_H,Minus_Value_L,CMOS_X2_H,CMOS_X2_L,CMOS_X2_H_1,CMOS_X2_L_1

	CLR		Minus_Value_L
	CLR		Minus_Value_H
	MOV		A,CMOS_X2_L_1
	SUB		A,CMOS_X2_L
	MOV		Minus_Value_L,A
	JBS		R3,0
	DEC		Minus_Value_H
	MOV		A,CMOS_X2_H_1
	SUB		A,CMOS_X2_H
	ADD		Minus_Value_H,A

;Sum_AB		CMOS_X1_H,CMOS_X1_L,CMOS_X1_H_1,CMOS_X1_L_1,Minus_Value_H,Minus_Value_L

	CLR		CMOS_X1_L
	CLR		CMOS_X1_H
	MOV		A,CMOS_X1_L_1
	ADD		A,Minus_Value_L
	JBC		R3,0
	INC		CMOS_X1_H
	MOV		CMOS_X1_L,A
	MOV		A,CMOS_X1_H_1
	ADD		A,Minus_Value_H
	ADD		CMOS_X1_H,A

;Count_Minus_Value		Minus_Value_H,Minus_Value_L,CMOS_Y2_H,CMOS_Y2_L,CMOS_Y2_H_1,CMOS_Y2_L_1

	CLR		Minus_Value_L
	CLR		Minus_Value_H
	MOV		A,CMOS_Y2_L_1
	SUB		A,CMOS_Y2_L
	MOV		Minus_Value_L,A
	JBS		R3,0
	DEC		Minus_Value_H
	MOV		A,CMOS_Y2_H_1
	SUB		A,CMOS_Y2_H
	ADD		Minus_Value_H,A

;Sum_AB		CMOS_Y1_H,CMOS_Y1_L,CMOS_Y1_H_1,CMOS_Y1_L_1,Minus_Value_H,Minus_Value_L	

	CLR		CMOS_Y1_L
	CLR		CMOS_Y1_H
	MOV		A,CMOS_Y1_L_1
	ADD		A,Minus_Value_L
	JBC		R3,0
	INC		CMOS_Y1_H
	MOV		CMOS_Y1_L,A
	MOV		A,CMOS_Y1_H_1
	ADD		A,Minus_Value_H
	ADD		CMOS_Y1_H,A
	JMP			CMOS_Data_Trans
Lose_Right_Ray:

;Count_Minus_Value		Minus_Value_H,Minus_Value_L,CMOS_X1_H,CMOS_X1_L,CMOS_X1_H_1,CMOS_X1_L_1

	CLR		Minus_Value_L
	CLR		Minus_Value_H
	MOV		A,CMOS_X1_L_1
	SUB		A,CMOS_X1_L
	MOV		Minus_Value_L,A
	JBS		R3,0
	DEC		Minus_Value_H
	MOV		A,CMOS_X1_H_1
	SUB		A,CMOS_X1_H
	ADD		Minus_Value_H,A

;Sum_AB				CMOS_X2_H,CMOS_X2_L,CMOS_X2_H_1,CMOS_X2_L_1,Minus_Value_H,Minus_Value_L

	CLR		CMOS_X2_L
	CLR		CMOS_X2_H
	MOV		A,CMOS_X2_L_1
	ADD		A,Minus_Value_L
	JBC		R3,0
	INC		CMOS_X2_H
	MOV		CMOS_X2_L,A
	MOV		A,CMOS_X2_H_1
	ADD		A,Minus_Value_H
	ADD		CMOS_X2_H,A
	
;Count_Minus_Value	Minus_Value_H,Minus_Value_L,CMOS_Y1_H,CMOS_Y1_L,CMOS_Y1_H_1,CMOS_Y1_L_1

	CLR		Minus_Value_L
	CLR		Minus_Value_H
	MOV		A,CMOS_Y1_L_1
	SUB		A,CMOS_Y1_L
	MOV		Minus_Value_L,A
	JBS		R3,0
	DEC		Minus_Value_H
	MOV		A,CMOS_Y1_H_1
	SUB		A,CMOS_Y1_H
	ADD		Minus_Value_H,A

;Sum_AB				CMOS_Y2_H,CMOS_Y2_L,CMOS_Y2_H_1,CMOS_Y2_L_1,Minus_Value_H,Minus_Value_L

	CLR		CMOS_Y2_L
	CLR		CMOS_Y2_H
	MOV		A,Minus_Value_L
	ADD		A,CMOS_Y2_L_1
	JBC		R3,0
	INC		CMOS_Y2_H
	MOV		CMOS_Y2_L,A
	MOV		A,Minus_Value_H
	ADD		A,CMOS_Y2_H_1
	ADD		CMOS_Y2_H,A
	
	JMP			CMOS_Data_Trans

;-----------------------------------------------------------
Invoke_Data_Order:	
	CALL		CMOS_Data_Order
	JMP			CMOS_Data_Trans
;-----------------------------------------------------------	
CMOS_Data_Trans:
	BANK		7
	MOV			A,CMOS_X1_H_3
	MOV			CMOS_X1_H_4,A
	MOV			A,CMOS_X1_L_3
	MOV			CMOS_X1_L_4,A
	MOV			A,CMOS_Y1_H_3
	MOV			CMOS_Y1_H_4,A
	MOV			A,CMOS_Y1_L_3
	MOV			CMOS_Y1_L_4,A
	MOV			A,CMOS_Size1_3
	MOV			CMOS_Size1_4,A
	MOV			A,CMOS_X2_H_3
	MOV			CMOS_X2_H_4,A
	MOV			A,CMOS_X2_L_3
	MOV			CMOS_X2_L_4,A
	MOV			A,CMOS_Y2_H_3
	MOV			CMOS_Y2_H_4,A
	MOV			A,CMOS_Y2_L_3
	MOV			CMOS_Y2_L_4,A
	MOV			A,CMOS_Size2_3
	MOV			CMOS_Size2_4,A
	
	MOV			A,CMOS_X1_H_2
	MOV			CMOS_X1_H_3,A
	MOV			A,CMOS_X1_L_2
	MOV			CMOS_X1_L_3,A
	MOV			A,CMOS_Y1_H_2
	MOV			CMOS_Y1_H_3,A
	MOV			A,CMOS_Y1_L_2
	MOV			CMOS_Y1_L_3,A
	MOV			A,CMOS_Size1_2
	MOV			CMOS_Size1_3,A
	MOV			A,CMOS_X2_H_2
	MOV			CMOS_X2_H_3,A
	MOV			A,CMOS_X2_L_2
	MOV			CMOS_X2_L_3,A
	MOV			A,CMOS_Y2_H_2
	MOV			CMOS_Y2_H_3,A
	MOV			A,CMOS_Y2_L_2
	MOV			CMOS_Y2_L_3,A
	MOV			A,CMOS_Size2_2
	MOV			CMOS_Size2_3,A
	
	BANK		5
	MOV			A,CMOS_X1_H_1
	BANK		7
	MOV			CMOS_X1_H_2,A
	BANK		5
	MOV			A,CMOS_X1_L_1
	BANK		7
	MOV			CMOS_X1_L_2,A
	BANK		5
	MOV			A,CMOS_Y1_H_1
	BANK		7
	MOV			CMOS_Y1_H_2,A
	BANK		5
	MOV			A,CMOS_Y1_L_1
	BANK		7
	MOV			CMOS_Y1_L_2,A
	BANK		5
	MOV			A,CMOS_Size1_1
	BANK		7
	MOV			CMOS_Size1_2,A
	BANK		5
	MOV			A,CMOS_X2_H_1
	BANK		7
	MOV			CMOS_X2_H_2,A
	BANK		5
	MOV			A,CMOS_X2_L_1
	BANK		7
	MOV			CMOS_X2_L_2,A
	BANK		5
	MOV			A,CMOS_Y2_H_1
	BANK		7
	MOV			CMOS_Y2_H_2,A
	BANK		5
	MOV			A,CMOS_Y2_L_1
	BANK		7
	MOV			CMOS_Y2_L_2,A
	BANK		5
	MOV			A,CMOS_Size2_1
	BANK		7
	MOV			CMOS_Size2_2,A
	
	BANK		5
	MOV			A,CMOS_X1_H
	MOV			CMOS_X1_H_1,A
	MOV			A,CMOS_X1_L
	MOV			CMOS_X1_L_1,A
	MOV			A,CMOS_Y1_H
	MOV			CMOS_Y1_H_1,A
	MOV			A,CMOS_Y1_L
	MOV			CMOS_Y1_L_1,A
	MOV			A,CMOS_Size1
	MOV			CMOS_Size1_1,A
	MOV			A,CMOS_X2_H
	MOV			CMOS_X2_H_1,A
	MOV			A,CMOS_X2_L
	MOV			CMOS_X2_L_1,A
	MOV			A,CMOS_Y2_H
	MOV			CMOS_Y2_H_1,A
	MOV			A,CMOS_Y2_L
	MOV			CMOS_Y2_L_1,A
	MOV			A,CMOS_Size2
	MOV			CMOS_Size2_1,A
	JMP			Average_CMOS_Data
;===========================================================
Average_CMOS_Data:
	BC			STATUS,C
;2009/08/19  (X1*4+X2*4)/8=X1=X2
;---------------------- X Axis Data Deal -------------------
	BANK		6
	CLR			CMOS_XPOINT_LOW
	CLR			CMOS_YPOINT_LOW
	CLR			CMOS_POINT_HIGH
	BANK		7
	CLR			Sum_High
	CLR			Sum_Low
	MOV			A,CMOS_X1_L_3
	ADD			A,CMOS_X1_L_4
	MOV			Sum_Low,A
	JBC			R3,0
	INC			Sum_High
	MOV			A,CMOS_X1_H_3
	ADD			A,CMOS_X1_H_4
	ADD			Sum_High,A
	
	MOV			A,CMOS_X2_L_3
	ADD			A,CMOS_X2_L_4
	JBC			R3,0
	INC			Sum_High
	ADD			Sum_Low,A
	JBC			R3,0
	INC			Sum_High
	MOV			A,CMOS_X2_H_3
	ADD			A,CMOS_X2_H_4
	ADD			Sum_High,A
	
	MOV			A,CMOS_X1_L_2
	ADD			A,CMOS_X2_L_2
	JBC			R3,0
	INC			Sum_High
	ADD			Sum_Low,A
	JBC			R3,0
	INC			Sum_High
	MOV			A,CMOS_X1_H_2
	ADD			A,CMOS_X2_H_2
	ADD			Sum_High,A
	
	BANK		5
	MOV			A,CMOS_X1_L_1
	ADD			A,CMOS_X2_L_1
	BANK		7
	JBC			R3,0
	INC			Sum_High
	ADD			Sum_Low,A
	JBC			R3,0
	INC			Sum_High
	BANK		5
	MOV			A,CMOS_X1_H_1
	ADD			A,CMOS_X2_H_1
	BANK		7
	ADD			Sum_High,A
	JBC			Sum_High,7
	JMP			X_CLR_Result
	BC			R3,0
	RRC			Sum_High
	RRC			Sum_Low
	BC			R3,0
	RRC			Sum_High
	RRC			Sum_Low
	BC			R3,0
	RRC			Sum_High
	RRC			Sum_Low
	NOP
	MOV			A,@0X04
	SUB			A,Sum_High
	JBC			R3,0
	JMP			X_Reset_Result
	JMP			Average_XData_End
X_CLR_Result:
	CLR			Sum_High
	CLR			Sum_Low
	JMP			Average_XData_End
X_Reset_Result:
	MOV			A,@0XFF
	MOV			Sum_Low,A
	MOV			A,@0X03
	MOV			Sum_High,A
Average_XData_End:
	SWAPA		Sum_High
	BANK		6
	OR			CMOS_POINT_HIGH,A
	BANK		7
	MOV			A,Sum_Low
	BANK		6
	MOV			CMOS_XPOINT_LOW,A
;---------------------- Y Axis Data Deal -------------------
	BANK		7
	CLR			Sum_High
	CLR			Sum_Low
	MOV			A,CMOS_Y1_L_3
	ADD			A,CMOS_Y1_L_4
	MOV			Sum_Low,A
	JBC			R3,0
	INC			Sum_High
	MOV			A,CMOS_Y1_H_3
	ADD			A,CMOS_Y1_H_4
	ADD			Sum_High,A
	
	MOV			A,CMOS_Y2_L_3
	ADD			A,CMOS_Y2_L_4
	JBC			R3,0
	INC			Sum_High
	ADD			Sum_Low,A
	JBC			R3,0
	INC			Sum_High
	MOV			A,CMOS_Y2_H_3
	ADD			A,CMOS_Y2_H_4
	ADD			Sum_High,A
	
	MOV			A,CMOS_Y1_L_2
	ADD			A,CMOS_Y2_L_2
	JBC			R3,0
	INC			Sum_High
	ADD			Sum_Low,A
	JBC			R3,0
	INC			Sum_High
	MOV			A,CMOS_Y1_H_2
	ADD			A,CMOS_Y2_H_2
	ADD			Sum_High,A
	
	BANK		5
	MOV			A,CMOS_Y1_L_1
	ADD			A,CMOS_Y2_L_1
	BANK		7
	JBC			R3,0
	INC			Sum_High
	ADD			Sum_Low,A
	JBC			R3,0
	INC			Sum_High
	BANK		5
	MOV			A,CMOS_Y1_H_1
	ADD			A,CMOS_Y2_H_1
	BANK		7
	ADD			Sum_High,A
	JBC			Sum_High,7
	JMP			Y_CLR_Result
	BC			R3,0
	RRC			Sum_High
	RRC			Sum_Low
	BC			R3,0
	RRC			Sum_High
	RRC			Sum_Low
	BC			R3,0
	RRC			Sum_High
	RRC			Sum_Low
	NOP
	MOV			A,@0X03
	SUB			A,Sum_High
	JBC			R3,0
	JMP			Y_Reset_Result
	JMP			Average_YData_End
Y_CLR_Result:
	CLR			Sum_High
	CLR			Sum_Low
	JMP			Average_YData_End
Y_Reset_Result:
	MOV			A,@0XFF
	MOV			Sum_Low,A
	MOV			A,@0X02
	MOV			Sum_High,A
Average_YData_End:
	SWAP		Sum_High
	BC			R3,0
	RLC			Sum_High
	BC			R3,0
	RLCA		Sum_High
	BANK		6
	OR			CMOS_POINT_HIGH,A
	BANK		7
	MOV			A,Sum_Low
	BANK		6
	MOV			CMOS_YPOINT_LOW,A
;---------------------- Size Deal --------------------------
	BANK		7
	CLR			Sum_Low
	MOV			A,CMOS_Size1_2
	ADD			A,CMOS_Size2_2
	MOV			Sum_Low,A
	MOV			A,CMOS_Size1_3
	ADD			A,CMOS_Size2_3
	ADD			Sum_Low,A
	MOV			A,CMOS_Size1_4
	ADD			A,CMOS_Size2_4
	ADD			Sum_Low,A
	BANK		5
	MOV			A,CMOS_Size1_1
	ADD			A,CMOS_Size2_1
	BANK		7
	ADD			Sum_Low,A
	BC			R3,0
	RRC			Sum_Low
	BC			R3,0
	RRC			Sum_Low
	BC			R3,0
	RRC			Sum_Low
	MOV			A,Sum_Low
	BANK		6
	OR			CMOS_POINT_HIGH,A
CMOS_Deal_End:
	BS			CMOS_STATUS,F_CMOS_Valid
	JMP			EXIT_CMOS_FUNCTION
;-----------------------------------------------------------
; CMOS Data Order 
;比较X轴的数据，小->大，互换整个光点的数据
;-----------------------------------------------------------
CMOS_Data_Order:
;-----------------------------------------------------------
;compare CMOS_X1 & CMOS_X2,Judge IF require change
	MOV			A,CMOS_X1_H
	MOV			X1H,A
	MOV			A,CMOS_X1_L
	MOV			X1L,A
	MOV			A,CMOS_X2_H
	MOV			X2H,A
	MOV			A,CMOS_X2_L
	MOV			X2L,A
	CALL		Compare_Data
;-----------------------------------------------------------
	NOP
	SUB			A,@0X01
	JBS			R3,0
	JMP			Foregone_Y_Axis
	JBS			R3,2
	JMP			Data_Order_End
	JMP			Exchange_Ray_data
Foregone_Y_Axis:
;当X1=X2时,根据Y11,Y21的大小进行排序光点的数据
;-----------------------------------------------------------
;compare CMOS_Y11 & CMOS_Y21,Judge IF require taxis
	MOV			A,CMOS_Y1_H_1
	MOV			X1H,A
	MOV			A,CMOS_Y1_L_1
	MOV			X1L,A
	MOV			A,CMOS_Y2_H_1
	MOV			X2H,A
	MOV			A,CMOS_Y2_L_1
	MOV			X2L,A
	CALL		Compare_Data
;-----------------------------------------------------------
	NOP
	MOV			Y_Return_Value,A
;-----------------------------------------------------------
;compare CMOS_Y1 & CMOS_Y2,Judge IF require change
	MOV			A,CMOS_Y1_H
	MOV			X1H,A
	MOV			A,CMOS_Y1_L
	MOV			X1L,A
	MOV			A,CMOS_Y2_H
	MOV			X2H,A
	MOV			A,CMOS_Y2_L
	MOV			X2L,A
	CALL		Compare_Data
;-----------------------------------------------------------
	NOP
	SUB			A,@0X01
	JBS			R3,0
	JMP			Data_Order_End
	JBS			R3,2
	JMP			Current_Y_Axis_A
	JMP			Current_Y_Axis_B
Current_Y_Axis_A:
	MOV			A,Y_Return_Value
	SUB			A,@0X01
	JBS			R3,0
	JMP			Data_Order_End
	JBS			R3,2
	JMP			Data_Order_End
	JMP			Exchange_Ray_data
Current_Y_Axis_B:
	MOV			A,Y_Return_Value
	SUB			A,@0X01
	JBS			R3,0
	JMP			Data_Order_End
	JBS			R3,2
	JMP			Exchange_Ray_data
	JMP			Data_Order_End
Exchange_Ray_data:
	MOV			A,CMOS_X1_L
    SUB			A,CMOS_X2_L
    ADD			CMOS_X1_L,A
    SUB			CMOS_X2_L,A
    MOV			A,CMOS_X1_H
    SUB			A,CMOS_X2_H
    ADD			CMOS_X1_H,A
    SUB			CMOS_X2_H,A

	MOV			A,CMOS_Y1_L
    SUB			A,CMOS_Y2_L
    ADD			CMOS_Y1_L,A
    SUB			CMOS_Y2_L,A
    MOV			A,CMOS_Y1_H
    SUB			A,CMOS_Y2_H
    ADD			CMOS_Y1_H,A
    SUB			CMOS_Y2_H,A
    
    MOV			A,CMOS_Size1
    SUB			A,CMOS_Size2
    ADD			CMOS_Size1,A
    SUB			CMOS_Size2,A
    
    JMP			Data_Order_End	
Data_Order_End:
	RET
;---------------------- sum=(A+B)/2 ------------------------
Sum_XY_Median:
	CLR			CMOS_XL_Median
	CLR			CMOS_XH_Median
	MOV			A,CMOS_X1_L_1
	ADD			A,CMOS_X2_L_1
	MOV			CMOS_XL_Median,A
	JBC			R3,0
	INC			CMOS_XH_Median
	MOV			A,CMOS_X1_H_1
	ADD			A,CMOS_X2_H_1
	ADD			CMOS_XH_Median,A	
	
	CLR			CMOS_YL_Median
	CLR			CMOS_YH_Median
	MOV			A,CMOS_Y1_L_1
	ADD			A,CMOS_Y2_L_1
	MOV			CMOS_YL_Median,A
	JBC			R3,0
	INC			CMOS_YH_Median
	MOV			A,CMOS_Y1_H_1
	ADD			A,CMOS_Y2_H_1
	ADD			CMOS_YH_Median,A
	JBC			CMOS_XH_Median,7
	JMP			Reload_X_Median
	BC			R3,0
	RRC			CMOS_XH_Median
	RRC			CMOS_XL_Median
	JMP			Gain_Y_Median
Reload_X_Median:
	MOV			A,@0X0FF
	MOV			CMOS_XL_Median,A
	MOV			CMOS_XH_Median,A
Gain_Y_Median:
	JBC			CMOS_YH_Median,7
	JMP			Reload_Y_Median
	BC			R3,0
	RRC			CMOS_YH_Median
	RRC			CMOS_YL_Median
	JMP			Gain_Median_End
Reload_Y_Median:
	MOV			A,@0X0FF
	MOV			CMOS_YL_Median,A
	MOV			CMOS_YH_Median,A
Gain_Median_End:
	RET

;===========================================================
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
	MOV			A,SPIC
	BANK		5
	MOV			SPIC_BAK,A							;Save SPI Config
	BANK		2
	MOV 		A, @11001100B						;rising edge read data
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
	BANK		5
	MOV			A,SPIC_BAK							;Read SPI Config Bak
	BANK		2
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