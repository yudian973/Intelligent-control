;***********************************************************
;General RAM define
;***********************************************************
SPI_SS				==		0X0A
F_GS_SS				==		2
F_CMOS_SS			==		3

GS_Margin			==		0X0A
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
X_Return_Value		==		0X30		;X axis compare return value
Y_Return_Value		==		0X31		;Y axis compare return value

Receive_CMOS_Data	==		0X32
Receive_CMOS_Count	==		0X33
CMOS_Size_BAK		==		0X34

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

DATA_BAK			==		0X35
Cyc_Cnt				==		0X35
;--------------- GS data buffer ----------------------------
GS_Addr				==		0x02			;Gsensor Access Address
GS_X_High			==		0x36			;Gsensor X High Byte(8Bit)
GS_X_Low			==		GS_X_High+1		;0x37;Gsensor X Low Byte(2Bit)
GS_Y_High			==		GS_X_High+2		;0x38;Gsensor Y High Byte(8Bit)
GS_Y_Low			==		GS_X_High+3		;0x39;Gsensor Y Low Byte(2Bit)
GS_Z_High			==		GS_X_High+4		;0x3A;Gsensor Z High Byte(8Bit)
GS_Z_Low			==		GS_X_High+5		;0x3B;Gsensor Z Low Byte(2Bit)

;-----------------------------------------------------------
;GS data bak
;-----------------------------------------------------------
GS_X_LOW_BAK		==		0x3C
GS_Y_LOW_BAK		==		GS_X_LOW_BAK+1			;0x3D
GS_Z_LOW_BAK		==		GS_X_LOW_BAK+2			;0x3E
GS_HIGH_BAK			==		GS_X_LOW_BAK+3			;0x3F
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
; ==================  Macro head routine   =================
;===========================================================
;compare data (比较的数在前，被比较的数在后)
;===========================================================
Compare_Data	MACRO	X1H,X1L,X2H,X2L
	JBC		X1H,7
	JMP		$Return_ZERO
	JBC		X2H,7
	JMP		$Return_ONE
	MOV		A,X2H
	SUB		A,X1H
	JBS		R3,0
	JMP		$Judge_High_Equal
	JMP		$Return_ZERO
$Judge_High_Equal:
	JBC		R3,2
	JMP		$Judge_Low_Byte
	JMP		$Return_ONE
$Judge_Low_Byte:
	MOV		A,X2H
	SUB		A,X1H
	JBS		R3,0
	JMP		$Judge_lOW_Equal
	JMP		$Return_ONE
$Judge_lOW_Equal:
	JBC		R3,2
	JMP		$Return_TWO
	JMP		$Return_ZERO
$Return_ZERO:
	MOV		A,@0x00						;X1<X2
	JMP		$Compare_Data_Return
$Return_ONE:
	MOV		A,@0x01						;X1>X2
	JMP		$Compare_Data_Return
$Return_TWO:
	MOV		A,@0x02						;X1=X2
$Compare_Data_Return:
	ENDM


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