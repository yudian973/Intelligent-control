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
UARTTest.H    EQU    UARTTest.H

;-------------------------------------------------------------



;================== BANK 6 (COMS/G-Sensor interface)====================
;CMOS_PARAMETER                  EQU     0X20
;CMOS_STATUS                     EQU     0X21
;GS_PARAMETER                    EQU     0X22
;GS_STATUS                       EQU     0X23

;--------------------------------------------------------
CMOS_Preamble                   EQU     0X24
CMOS_Command                    EQU     0X25
CMOS_Length                     EQU     0X26
;CMOS_XPOINT_LOW                 EQU     0X27
;CMOS_YPOINT_LOW                 EQU     0X28
;CMOS_POINT_HIGH                 EQU     0X29
GS_Preamble                     EQU     0X2A
GS_Command                      EQU     0X2B
GS_Length                       EQU     0X2C
;GS_XPOINT_LOW                   EQU     0X2D
;GS_YPOINT_LOW                   EQU     0X2E
;GS_ZPOINT_LOW                   EQU     0X2F
;GS_POINT_HIGH                   EQU     0X30
;--------------------------------------------------------
GeneralStatusFlag1              EQU     0X31
	InitGSCMOSFlag              ==      GeneralStatusFlag1*16+0 ; 
	TimeDelay12ms               ==      GeneralStatusFlag1*16+1 ;
	

/*
CMOS_Preamble                   EQU     0XF0
CMOS_Command                    EQU     0X80
CMOS_Length                     EQU     0X03
CMOS_XPOINT_LOW                 EQU     0XFF
CMOS_YPOINT_LOW                 EQU     0XFF
CMOS_POINT_HIGH                 EQU     0X7F

GS_Preamble                     EQU     0XF0
GS_Command                      EQU     0X00
GS_Length                       EQU     0X04
GS_XPOINT_LOW                   EQU     0X17
GS_YPOINT_LOW                   EQU     0XD8
GS_ZPOINT_LOW                   EQU     0XCF
GS_POINT_HIGH                   EQU     0X0C
*/

;***********************************************************
;General RAM define
;***********************************************************
SPI_BUS				==		0X0A
F_GS_SS				==		2
F_CMOS_SS			==		3

GS_Margin			==		0X0A
CMOS_SIZE			==		0XFF
;***********************************************************
;寄存器定义 Bank5
;***********************************************************
CMOS_Addr			==		0X0A			;
CMOS_X1_H			==		0X20			;X1[9..8]
CMOS_X1_L			==		CMOS_X1_H+1		;X1[7..0]
CMOS_Y1_H			==		CMOS_X1_H+2		;Y1[9..8]
CMOS_Y1_L			==		CMOS_X1_H+3		;Y1[7..0]
CMOS_Size1			==		CMOS_X1_H+4		;Size1[3..0]
CMOS_X2_H			==		CMOS_X1_H+5		;X2[9..8]
CMOS_X2_L			==		CMOS_X1_H+6		;X2[7..0]
CMOS_Y2_H			==		CMOS_X1_H+7		;Y2[9..8]
CMOS_Y2_L			==		CMOS_X1_H+8		;Y2[7..0]
CMOS_Size2			==		CMOS_X1_H+9		;Size2[3..0] 0X29

CMOS_XH_Median		==		0X2A
CMOS_XL_Median		==		0X2B		;CMOS X axis 中心值
CMOS_YH_Median		==		0X2C
CMOS_YL_Median		==		0X2D		;CMOS Y axis 中心值
Minus_Value_H  		==		0X2E
Minus_Value_L  		==		0X2F		;差值暂存区
Y_Return_Value		==		0X30		;X axis compare return value
X_Return_Value		==		0X31		;Y axis compare return value

Receive_CMOS_Data	==		0X32
Receive_CMOS_Count	==		0X33
CMOS_Size_BAK		==		0X34

X1H					==		0X31
X1L					==		0X32
X2H					==		0X33
X2L					==		0X34

System_Flag			==		0X35
F_CMOS_First		==		0
;=====================================================================
;CMOS data handle buffer
;=====================================================================
CMOS_X1_H_1			==		0X36
CMOS_X1_L_1			==		CMOS_X1_H_1+1
CMOS_Y1_H_1			==		CMOS_X1_H_1+2
CMOS_Y1_L_1			==		CMOS_X1_H_1+3
CMOS_Size1_1		==		CMOS_X1_H_1+4
CMOS_X2_H_1			==		CMOS_X1_H_1+5
CMOS_X2_L_1			==		CMOS_X1_H_1+6
CMOS_Y2_H_1			==		CMOS_X1_H_1+7
CMOS_Y2_L_1			==		CMOS_X1_H_1+8
CMOS_Size2_1		==		CMOS_X1_H_1+9		;0X3F	

;***********************************************************
;寄存器定义 Bank6
;***********************************************************
CMOS_PARAMETER		==		0X20
CMOS_STATUS			==		0X21
	F_CMOS_Init		==		0
	F_CMOS_Sleep	==		1
	F_CMOS_Valid	==		2	
GS_PARAMETER		==		0X22
GS_STATUS			==		0X23
	F_GS_Init		==		0
	F_GS_Sleep		==		1
	F_GS_New		==		2

CMOS_XPOINT_LOW		==		0X27
CMOS_YPOINT_LOW		==		0X28
CMOS_POINT_HIGH		==		0X29

GS_XPOINT_LOW		==		0X2D
GS_YPOINT_LOW		==		0X2E
GS_ZPOINT_LOW		==		0X2F
GS_POINT_HIGH		==		0X30

Minus_High			==		0X32
Minus_Low			==		0X33
DATA_BAK			==		0X33
Cyc_Cnt				==		0X33
;--------------- GS data buffer ----------------------------
GS_Addr				==		0X02			;Gsensor Access Address
GS_X_High			==		0X34			;Gsensor X High Byte(8Bit)
GS_X_Low			==		GS_X_High+1		;0X35;Gsensor X Low Byte(2Bit)
GS_Y_High			==		GS_X_High+2		;0X36;Gsensor Y High Byte(8Bit)
GS_Y_Low			==		GS_X_High+3		;0X37;Gsensor Y Low Byte(2Bit)
GS_Z_High			==		GS_X_High+4		;0X38;Gsensor Z High Byte(8Bit)
GS_Z_Low			==		GS_X_High+5		;0X39;Gsensor Z Low Byte(2Bit)

;-----------------------------------------------------------
;GS data bak
;-----------------------------------------------------------
GS_X_High_BAK		==		0X3A
GS_X_Low_BAK		==		GS_X_High_BAK+1
GS_Y_High_BAK		==		GS_X_High_BAK+2
GS_Y_Low_BAK		==		GS_X_High_BAK+3
GS_Z_High_BAK		==		GS_X_High_BAK+4
GS_Z_Low_BAK		==		GS_X_High_BAK+5			;0X3F
;***********************************************************
;寄存器定义 Bank7
;***********************************************************
CMOS_X1_H_2			==		0X20
CMOS_X1_L_2			==		CMOS_X1_H_2+1
CMOS_Y1_H_2			==		CMOS_X1_H_2+2
CMOS_Y1_L_2			==		CMOS_X1_H_2+3
CMOS_Size1_2		==		CMOS_X1_H_2+4
CMOS_X2_H_2			==		CMOS_X1_H_2+5
CMOS_X2_L_2			==		CMOS_X1_H_2+6
CMOS_Y2_H_2			==		CMOS_X1_H_2+7
CMOS_Y2_L_2			==		CMOS_X1_H_2+8
CMOS_Size2_2		==		CMOS_X1_H_2+9		;0X29

CMOS_X1_H_3			==		0X2A
CMOS_X1_L_3			==		CMOS_X1_H_3+1
CMOS_Y1_H_3			==		CMOS_X1_H_3+2
CMOS_Y1_L_3			==		CMOS_X1_H_3+3
CMOS_Size1_3		==		CMOS_X1_H_3+4
CMOS_X2_H_3			==		CMOS_X1_H_3+5
CMOS_X2_L_3			==		CMOS_X1_H_3+6
CMOS_Y2_H_3			==		CMOS_X1_H_3+7
CMOS_Y2_L_3			==		CMOS_X1_H_3+8
CMOS_Size2_3		==		CMOS_X1_H_3+9		;0X33

CMOS_X1_H_4			==		0X34
CMOS_X1_L_4			==		CMOS_X1_H_4+1
CMOS_Y1_H_4			==		CMOS_X1_H_4+2
CMOS_Y1_L_4			==		CMOS_X1_H_4+3
CMOS_Size1_4		==		CMOS_X1_H_4+4
CMOS_X2_H_4			==		CMOS_X1_H_4+5
CMOS_X2_L_4			==		CMOS_X1_H_4+6
CMOS_Y2_H_4			==		CMOS_X1_H_4+7
CMOS_Y2_L_4			==		CMOS_X1_H_4+8
CMOS_Size2_4		==		CMOS_X1_H_4+9		;0X3D

Sum_High			==		0X3E
Sum_Low				==		0X3F

;===========================================================
;sum=A+B
;===========================================================
Sum_AB		MACRO	Sum_H,Sum_L,X1_H,X1_L,X2_H,X2_L
	CLR		Sum_L
	CLR		Sum_H
	MOV		A,X1_L
	ADD		A,X2_L
	JBC		R3,0
	INC		Sum_H
	MOV		Sum_L,A
	MOV		A,X1_H
	ADD		A,X2_H
	ADD		Sum_H,A
	ENDM
;===========================================================
;Minus Value=X1-X2
;===========================================================
Count_Minus_Value		MACRO		Minus_H,Minus_L,X1_H,X1_L,X2_H,X2_L
	CLR		Minus_L
	CLR		Minus_H
	MOV		A,X2_L
	SUB		A,X1_L
	MOV		Minus_L,A
	JBS		R3,0
	DEC		Minus_H
	MOV		A,X2_H
	SUB		A,X1_H
	ADD		Minus_H,A
	ENDM
;===========================================================
;shift left/right
;===========================================================
Shift_Left	MACRO	High_Byte,Low_Byte,@Cyc_Counter
	MOV		A,@Cyc_Counter
	MOV		Cyc_Cnt,A
$L_LOOP:
	BC		STATUS,C
	RLC		High_Byte
	RLC		Low_Byte
	DJZ		Cyc_Cnt
	JMP		$L_LOOP
	ENDM
;===========================================================
Shift_Right	MACRO	High_Byte,Low_Byte,@Cyc_Counter
	MOV		A,@Cyc_Counter
	MOV		Cyc_Cnt,A
$R_LOOP:
	BC		STATUS,C
	RRC		High_Byte
	RRC		Low_Byte
	DJZ		Cyc_Cnt
	JMP		$R_LOOP
	ENDM