;=============================================================================
;=============================================================================
; Filename      : KEYSCAN.ASM
; Author        : yu.wei
; Company       : ELAN
; VERSION       : 1.1
; CRYSTAL       : 8MHZ
; Creat date    : 2009/11/4
; tool ver.     : eUIDE
; descripition  : FOR_EM78P520,
;=============================================================================
;=============================================================================

;---------------------------------------------------
keyscan.asm             EQU       keyscan.asm
include "keyscan.H"

ifndef EM78CtrlIns.H
include "D:\include\EM78xx\EM78CtrlIns.H"
endif
;----------------------------------------------------
	ORG                 0x1100    ;PAGE 4
Key_Scan:
;=============================== I/O config ================================
	BANK                5
	MOV                 A,@00110111B
	MOV                 PBPHCR,A	    	;PB0 PB1 PB2 PB4 PB5 ENABLE PULL HIGH
 	MOV                 A,@11110000B
 	MOV                 P9PHCR,A		    ;SET PULL UP
 ;===========================================================================
 ;Setting LED Status
 ;===========================================================================
	BANK                2
	JBS                 DataF,MODE_13    ; 1:analog  0:digital(default 0),LED light
	JMP                 SET_VR_STATUS_0
	JMP                 SET_VR_STATUS_1
  SET_VR_STATUS_0:
	NOP
	BANK                0
	BC                  LED1_STATUS/16,LED1_STATUS%16		;PORT81
	JMP                 SET_VR_STATUS_END
  SET_VR_STATUS_1:
	NOP
	BANK                0
	BS                  LED1_STATUS/16,LED1_STATUS%16		;PORT81
	JMP                 SET_VR_STATUS_END
  SET_VR_STATUS_END:
	BANK                2
 	NOP

;================================================================================
;Keyscan Main
;================================================================================
	CALL                KeyPort_Check
	NOP
;--------------------- Judge mode status ------------------------
	JBC                 ModeSelFlag/16,ModeSelFlag%16
	JMP                 MODE_NOCHANGE
	JBS                 ModeSelBakupFlag/16,ModeSelBakupFlag%16
	JMP                 MODE_NOCHANGE
	NOP
	COM                 DataF,MODE_13
	NOP
  MODE_NOCHANGE:
	MOVB                KeyTempBakupFlag,MODE_13,KeyTempFlag,MODE_13
	BC                  ModeSelFlag/16,ModeSelFlag%16

;----------------deal with DataA/DataB/DataC/DataD/DataG-----------------
	NOP
	CALL                ADC_Rocker_KeyScan
	NOP
	;CALL                IO_Rocker_KeyScan
	NOP
	CALL                Rocker_KeyScan
	NOP
	CALL                Direction_KeyCheck

;-----------------------deal with DataE------------------------------------------
; bit7  bit6  bit5  bit4  bit3  bit2  bit1  bit0
; A_1   B_2   C_3   D_4   L1_5  R1_6  L2_7  R2_8
;--------------------------------------------------------------------------------
	CLR                 TEMP
	MOVB                TEMP,A_1,LINE2_KEY_INPUT_CACHE,_A
	MOVB                TEMP,B_2,LINE3_KEY_INPUT_CACHE,_B
	MOVB                TEMP,C_3,LINE4_KEY_INPUT_CACHE,_C
	MOVB                TEMP,D_4,LINE5_KEY_INPUT_CACHE,_D
	MOVB                TEMP,L1_5,LINE3_KEY_INPUT_CACHE,_L1
	MOVB                TEMP,R1_6,LINE4_KEY_INPUT_CACHE,_R1
	MOVB                TEMP,L2_7,LINE2_KEY_INPUT_CACHE,_L2
	MOVB                TEMP,R2_8,LINE3_KEY_INPUT_CACHE,_R2
	MOV                 A,TEMP
	OR                  DataE,A

;-----------------------deal with DataF------------------------------------------
; bit0      bit1      bit2     bit3     bit4     bit5      bit6      bit7
; Select_9  Start_10  LSW_11   RSW_12   MODE_13  MACRO_14  TEST1_15  TEST2_16
;--------------------------------------------------------------------------------
	;CLR                 DataF
	MOVB                DataF,SELECT_9,LINE4_KEY_INPUT_CACHE,_Select
	MOVB                DataF,Start_10,LINE5_KEY_INPUT_CACHE,_Start
	MOVB                DataF,LSW_11,LINE5_KEY_INPUT_CACHE,_LSW
	MOVB                DataF,RSW_12,LINE2_KEY_INPUT_CACHE,_RSW
	;MOVB                DataF,MODE_13,LINE3_KEY_INPUT_CACHE,_MODE
	MOVB                DataF,MACRO_14,LINE4_KEY_INPUT_CACHE,_MACRO
	MOVB                DataF,TEST1_15,LINE2_KEY_INPUT_CACHE,_TEST1
	MOVB                DataF,TEST2_16,LINE5_KEY_INPUT_CACHE,_TEST2

	NOP
	RET
	NOP

;===========================================================================
;Scan data form keyboard port
;===========================================================================
KeyPort_Check:
;LINE1:	read direct data from PortB to LINE1_KEY_INPUT
	BANK                0
	MOV                 A,PORTB		;PortB = 00110110
	BANK                2
	MOV                 LINE1_KEY_INPUT_CACHE,A
	COM                 LINE1_KEY_INPUT_CACHE
	MOV                 A,@0B00110110
	AND                 LINE1_KEY_INPUT_CACHE,A

;LINE2:	;SET P77=1 P76=1 P75=1 P74=0
	BANK                0
	MOV                 A,@11101000B
	MOV                 PORT7,A
	CALL                KEY_DELAY
	MOV                 A,PORT9
	BANK                2
	MOV                 LINE2_KEY_INPUT_CACHE,A
	COM                 LINE2_KEY_INPUT_CACHE
	MOV                 A,@0XF0
	AND                 LINE2_KEY_INPUT_CACHE,A

;LINE3:	;SET P77=1 P76=1 P75=0 P74=1
	BANK                0
	MOV                 A,@11011000B
	MOV                 PORT7,A
	CALL                KEY_DELAY
	MOV                 A,PORT9
	BANK                2
	MOV                 LINE3_KEY_INPUT_CACHE,A
	COM                 LINE3_KEY_INPUT_CACHE
	MOV                 A,@0XF0
	AND                 LINE3_KEY_INPUT_CACHE,A

;LINE4:	;SET P77=1 P76=0 P75=1 P74=1
	BANK                0
	MOV                 A,@10111000B
	MOV                 PORT7,A
	CALL                KEY_DELAY
	MOV                 A,PORT9
	BANK                2
	MOV                 LINE4_KEY_INPUT_CACHE,A
	COM                 LINE4_KEY_INPUT_CACHE
	MOV                 A,@0XF0
	AND                 LINE4_KEY_INPUT_CACHE,A

;LINE5:	;SET P77=0 P76=1 P75=1 P74=1
	BANK                0
	MOV                 A,@01111000B
	MOV                 PORT7,A
	CALL                KEY_DELAY
	MOV                 A,PORT9
	BANK                2
	MOV                 LINE5_KEY_INPUT_CACHE,A
	COM                 LINE5_KEY_INPUT_CACHE
	MOV                 A,@0XF0
	AND                 LINE5_KEY_INPUT_CACHE,A
	NOP

;----------------------------------------------------------------
	MOVB                KeyTempFlag,MODE_13,LINE3_KEY_INPUT_CACHE,_MODE  ;save MODE FLAG
	MOVB                KeyTempFlag,MACRO_14,LINE4_KEY_INPUT_CACHE,_MACRO ;save MACRO FLAG
	NOP
	RET
	NOP

;==============================================================================
;=======================Direction key board scan===============================
;==============================================================================
;------------------------deal with DataA/DataB---------------------------------
;DataA	left-right: left=0x00, right=0xff, no-left-right=0x7f
;DataB	up-down:    down=0x00, up=0xff,    no-left-right=0x7f
;DataG  000:00¡¯ 001:45¡¯ 010:90¡¯ 011:135¡¯ 100:180¡¯ 101:225¡¯ 110:270¡¯ 111:315¡¯
;------------------------------------------------------------------------------
Direction_KeyCheck:
	NOP
	JBS                 DataF,MODE_13
	JMP                 DealWith_Direction_Digital
	JMP                 DealWith_HatSwitch_Analog

DealWith_Direction_Digital:
LEFT_RIGHT_KEY:
	JBC                 LINE1_KEY_INPUT_CACHE,_RIGHT   ;judge right
	JMP                 JudgeRight
	JBC                 LINE1_KEY_INPUT_CACHE,_LEFT    ;judeg left
	JMP                 JudgeLeft
	JMP                 Left_Right_Finsh
  JudgeRight:
	MOV                 A,@0X00
	XOR                 A,DataA
	JBS                 STATUS,Z
	JMP                 JudgeRight_1
	JMP                 JudgeRight_2
  JudgeRight_1:
	MOV                 A,@0XFF
	JMP                 JudgeRight_End
  JudgeRight_2:
	MOV                 A,@0X7F
	JMP                 JudgeRight_End
  JudgeRight_End:
	MOV                 DataA,A
	JMP                 Left_Right_Finsh

  JudgeLeft:
	MOV                 A,@0XFF
	XOR                 A,DataA
	JBS                 STATUS,Z
	JMP                 JudgeLeft_1  ;Z=0,sameness
	JMP                 JudgeLeft_2  ;Z=1,reverse
  JudgeLeft_1:
	MOV                 A,@0X00
	JMP                 JudgeLeft_End
  JudgeLeft_2:
	MOV                 A,@0X7F
	JMP                 JudgeLeft_End
  JudgeLeft_End:
	MOV                 DataA,A
  Left_Right_Finsh:
	NOP
;--------------------------------------------------------------
UP_DOWN_KEY:
	JBC                 LINE1_KEY_INPUT_CACHE,_UP     ;judge up(0X00)
	JMP                 JudgeDown
	JBC                 LINE1_KEY_INPUT_CACHE,_DOWN   ;judeg down(0XFF)
	JMP                 JudgeUp
	JMP                 UP_DOWN_Finsh
  JudgeUp:
	MOV                 A,@0X00
	XOR                 A,DataB
	JBS                 STATUS,Z
	JMP                 JudgeUp_1
	JMP                 JudgeUp_2
  JudgeUp_1:
	MOV                 A,@0XFF
	JMP                 JudgeUp_End
  JudgeUp_2:
	MOV                 A,@0X7F
	JMP                 JudgeUp_End
  JudgeUp_End:
	MOV                 DataB,A
	JMP                 UP_DOWN_Finsh

  JudgeDown:
	MOV                 A,@0XFF
	XOR                 A,DataB
	JBS                 STATUS,Z
	JMP                 JudgeDown_1
	JMP                 JudgeDown_2
  JudgeDown_1:
	MOV                 A,@0X00
	JMP                 JudgeDown_End
  JudgeDown_2:
	MOV                 A,@0X7F
	JMP                 JudgeDown_End
  JudgeDown_End:
	MOV                 DataB,A
	JMP                 UP_DOWN_Finsh
  UP_DOWN_Finsh:
	NOP
	MOV                 A,@0X7F
	MOV                 DataC,A
	MOV                 DataD,A
  	MOV                 A,@0X0F
  	MOV                 DataG,A
	NOP
	RET
	NOP

;----------------------------------------------------
DealWith_HatSwitch_Analog:
	CLR                 DataE
	MOV                 A,LINE1_KEY_INPUT_CACHE
	XOR                 A,@0B00000000
	JBS                 STATUS,Z
	JMP                 DATAG_0
	MOV                 DataG,@0X0F          ;none
	JMP                 HAT_SWITCH_END
  DataG_0:
	MOV                 A,LINE1_KEY_INPUT_CACHE
	XOR                 A,@0B00100000
	JBS                 STATUS,Z
	JMP                 DataG_45
	MOV                 DataG,@0X00          ;0
	JMP                 HAT_SWITCH_END
  DataG_45:
	MOV                 A,LINE1_KEY_INPUT_CACHE
	XOR                 A,@0B00110000
	JBS                 STATUS,Z
	JMP                 DataG_90
	MOV                 DataG,@0X01          ;45
	JMP                 HAT_SWITCH_END
  DataG_90:
	MOV                 A,LINE1_KEY_INPUT_CACHE
	XOR                 A,@0B00010000
	JBS                 STATUS,Z
	JMP                 DataG_135
	MOV                 DataG,@0X02          ;90
	JMP                 HAT_SWITCH_END
  DataG_135:
	MOV                 A,LINE1_KEY_INPUT_CACHE
	XOR                 A,@0B00010100
	JBS                 STATUS,Z
	JMP                 DataG_180
	MOV                 DataG,@0X03          ;135
	JMP                 HAT_SWITCH_END
  DataG_180:
	MOV                 A,LINE1_KEY_INPUT_CACHE
	XOR                 A,@0B00000100
	JBS                 STATUS,Z
	JMP                 DataG_225
	MOV                 DataG,@0X04          ;180
	JMP                 HAT_SWITCH_END
  DataG_225:
	MOV                 A,LINE1_KEY_INPUT_CACHE
	XOR                 A,@0B00000110
	JBS                 STATUS,Z
	JMP                 DataG_270
	MOV                 DataG,@0X05          ;225
	JMP                 HAT_SWITCH_END
  DataG_270:
	MOV                 A,LINE1_KEY_INPUT_CACHE
	XOR                 A,@0B00000010
	JBS                 STATUS,Z
	JMP                 DataG_315
	MOV                 DataG,@0X06          ;270
	JMP                 HAT_SWITCH_END
  DataG_315:
	MOV                 A,LINE1_KEY_INPUT_CACHE
	XOR                 A,@0B00100010
	JBS                 STATUS,Z
	JMP                 HAT_SWITCH_END
	MOV                 DataG,@0X07          ;315
	JMP                 HAT_SWITCH_END

  HAT_SWITCH_END:
	NOP
	RET
	NOP

;===================================================================
; Delay function
;===================================================================
KEY_DELAY:
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	RET
	NOP


;============================================================================
;file name:     ADC 3D Rocker KeyScan
;INPUT PORT:
;OUTPUT PORT:   KEY_LEFT_X,KEY_LEFT_Y,KEY_RIGHT_X,KEY_RIGHT_Y
;TIME:          1050uS
;Descrition:    Use for check AD rocker data
;============================================================================
ADC_Rocker_KeyScan:
	NOP
	CALL                 SUB_RINIT
	CALL                 SUB_ADJ
	BANK                 3
	MOV                  A,@0X80             ;SELECT ADE0/P93.Rx
	OR                   ADCR, A
	CALL                 SUB_ADC
	MOV                  A, ADDH
	BANK                 2
	MOV                  KEY_RIGHT_X,A

	CALL                 SUB_RINIT
	CALL                 SUB_ADJ
	BANK                 3
	MOV                  A,@0X81             ;SELECT ADE1/P92.Ry
	OR                   ADCR, A
	CALL                 SUB_ADC
	MOV                  A, ADDH
	BANK                 2
	MOV                  KEY_RIGHT_Y,A
	COM                  KEY_RIGHT_Y

	CALL                 SUB_RINIT
	CALL                 SUB_ADJ
	BANK                 3
	MOV                  A,@0X82             ;SELECT ADE2/P91.Lx
	OR                   ADCR,A
	CALL                 SUB_ADC
	MOV                  A,ADDH
	BANK                 2
	MOV                  KEY_LEFT_X,A

	CALL                 SUB_RINIT
	CALL                 SUB_ADJ
	BANK                 3
	MOV                  A,@0X83             ;SELECT ADE3/P90.Ly
	OR                   ADCR, A
	CALL                 SUB_ADC
	MOV                  A,ADDH
	BANK                 2
	MOV                  KEY_LEFT_Y,A
	COM                  KEY_LEFT_Y
	NOP
	RET
	NOP

Rocker_KeyScan:
;======================== jugde rocker signal select ==========================
	JBS                 DataF,MODE_13       ;select digital or analog
	JMP                 DealWith_ADC_Digital
	JMP                 DealWith_ADC_Analog

  DealWith_ADC_Digital:
	CLR                 DataA
	MOV                 A,KEY_LEFT_X		;L-left_right
	MOV                 TEMP1,A
	CALL                AreaJudge_direction
	MOV                 DataA,A

	CLR                 DataB
	MOV                 A,KEY_LEFT_Y		;L-up_down
	MOV                 TEMP1,A
	CALL                AreaJudge_direction
	MOV                 DataB,A

	MOV                 A,@0X7F
	MOV                 DataC,A
	MOV                 DataD,A

	CLR                 DataE
	MOV                 A,KEY_RIGHT_X		;A,B,C,D,
	MOV                 TEMP2,A
	MOV                 A,KEY_RIGHT_Y
	MOV                 TEMP3,A
	CALL                AreaJudge_Button
	MOV                 A,TEMP
	MOV                 DataE,A
	JMP                 RockerCheakFinish

  DealWith_ADC_Analog:
	MOV                 A,KEY_LEFT_X		;L-left_right
	MOV                 DataA,A
	MOV                 A,KEY_LEFT_Y		;L-up_down
	MOV                 DataB,A
	MOV                 A,KEY_RIGHT_X		;R-left_right
	MOV                 DataC,A
	MOV                 A,KEY_RIGHT_Y		;R-up_down
	MOV                 DataD,A
	JMP                 RockerCheakFinish

  RockerCheakFinish:
	NOP
	RET
	NOP

;=============================jugde the direction=====================================
;Input:      TEMP1
;output:     A
;=====================================================================================
AreaJudge_direction:
	BANK                2
	MOV                 A,TEMP1     ;Store
	SUB                 A,@0XBF
	JBS                 R3,0        ;R3,bit0(C)
	JMP                 CheakTop_Left
	JMP                 CheakMiddle_Left
  CheakTop_Left:
	MOV                 A,@0XFF   ;up
	JMP                 CheakAreaFinish_Left
  CheakMiddle_Left:
	MOV                 A,TEMP1
	SUB                 A,@0X40
	JBC                 R3,0
	JMP                 CheakBottom_Left
	MOV                 A,@0X7F
	JMP                 CheakAreaFinish_Left
  CheakBottom_Left:
	MOV                 A,@0X00   ;down
	JMP                 CheakAreaFinish_Left
  CheakAreaFinish_Left:
	NOP
	NOP
	RET
	NOP

;============================jugde what button press============================
;input:     TEMP2,TEMP3
;output:    TEMP
;===============================================================================
AreaJudge_Button:
	BANK                2
	MOV                 A,TEMP2    ;KEY_RIGHT_Y
	SUB                 A,@0XD0
	JBS                 R3,C	     ;R3,bit0(C)
	JMP                 CheakTop_Right_y
	JMP                 CheakMiddle_Right_y

  CheakTop_Right_y:
	MOV                 A,@0XFF  ;up
	JMP                 CheakAreaFinish_Right_y
  CheakMiddle_Right_y:
	MOV                 A,TEMP2
	SUB                 A,@0X25
	JBS                 R3,C
	JMP                 CheakBottom_Right_y
	MOV                 A,@0X00  ;dwon
	JMP                 CheakAreaFinish_Right_y
  CheakBottom_Right_y:
	MOV                 A,@0X7F
	JMP                 CheakAreaFinish_Right_y
  CheakAreaFinish_Right_y:
	MOV                 TEMP2,A
	NOP
;---------------------------------------------------
	BANK                2
	MOV                 A,TEMP3    ;KEY_RIGHT_Y
	SUB                 A,@0XD0
	JBS                 R3,C       ;R3,bit0(C)
	JMP                 CheakTop_Right_x
	JMP                 CheakMiddle_Right_x
  CheakTop_Right_x:
	MOV                 A,@0XFF   ;right
	JMP                 CheakAreaFinish_Right_x
  CheakMiddle_Right_x:
	MOV                 A,TEMP3
	SUB                 A,@0X25
	JBS                 R3,0
	JMP                 CheakBottom_Right_x
	MOV                 A,@0X00   ;left
	JMP                 CheakAreaFinish_Right_x
  CheakBottom_Right_x:
	MOV                 A,@0X7F
	JMP                 CheakAreaFinish_Right_x
  CheakAreaFinish_Right_x:
	MOV                 TEMP3,A
	NOP

;-----------------------------------------------------
	CLR                 TEMP
	MOV                 A,TEMP2      ;left
	XOR                 A,@0X00
	JBC                 STATUS,Z
	BS                  TEMP,A_1

	MOV                 A,TEMP2      ;right
	XOR                 A,@0XFF
	JBC                 STATUS,Z
	BS                  TEMP,C_3

	MOV                 A,TEMP3      ;down
	XOR                 A,@0XFF
	JBC                 STATUS,Z
	BS                  TEMP,D_4

	MOV                 A,TEMP3      ;up
	XOR                 A,@0X00
	JBC                 STATUS,Z
	BS                  TEMP,B_2
	RET
	NOP

;-----------------------------------------------------------------
SUB_ADJ:
	BANK                3
	BS                  ADICH,CALI    ;ENABLE CALIBRATION
  ADCJUDGE_LOOP:
	BS                  ADCR,ADRUN
	JBC                 ADCR,ADRUN
	JMP                 $-1

	MOV                 A,ADDL
	AND                 A,@0X0F
	JBS                 R3,Z
	JMP                 ADCJUDGE_DONE
	MOV                 A,ADDH
	JBS                 R3,Z
	JMP                 ADCJUDGE_DONE
	MOV                 A,@0X10
	ADD                 ADDL,A
	JMP                 ADCJUDGE_LOOP
  ADCJUDGE_DONE:
	BC                  ADICH,CALI
	BANK                0
	RET

  SUB_RINIT:
 	BANK                5
 	MOV                 A,@00000000B
 	MOV                 P9PHCR,A      ;SET PULL LOW
	BANK                3
	MOV                 A,@0X0F
	MOV                 ADICL,A      ;SELECT ADE0~ ADE3 AS ANALOG INPUT
	CLR                 ADICH         ;VREFS==VDD
	MOV                 A,@0X60
	MOV                 ADCR,A       ;SELECT  AD0,SELECT ADCKR1/ADCKR0=1:0,ADP=1
	RET
  SUB_ADC:
	BANK                3
	BS                  ADCR,ADRUN
	JBC                 ADCR,ADRUN
	JMP                 $-1
	NOP
	RET
	NOP



;============================================================================
;file name:     IO 3D Rocker KeyScan
;INPUT PORT:
;OUTPUT PORT:   KEY_LEFT_X,KEY_LEFT_Y,KEY_RIGHT_X,KEY_RIGHT_Y
;TIME:
;Descrition:    Use for check AD rocker data
;============================================================================
IO_Rocker_KeyScan:
	NOP
	BS                  T2CR,T2EN          ; START
	;CALL                Discharge
	;CALL                SampingRefTiming
	CALL                Discharge
	CALL                SampingLyTiming    ; Ly
	NOP
	CALL                Discharge
	CALL                SampingLxTiming    ; Lx
	NOP
	CALL                Discharge
	CALL                SampingRyTiming    ; Ry
	NOP
	CALL                Discharge
	CALL                SampingRxTiming    ; Rx
	BC                  T2CR,T2EN          ; Disable
	NOP
	NOP
	RET
	NOP

;---------------------------------------------------------------
Discharge:
	BANK                4
	MOV                 A,@0B11111111
	MOV                 P9IOCR,A            ; P97-P94:Input; P93-P90:Input
	;BS                  P8IOCR,Reference    ; Input  P87
	;BC                  P8IOCR,Leakresis    ; Output P86
	MOV                 A,P8IOCR
	AND                 A,@0B00111111
	OR                  A,@0B10000000
	MOV                 P8IOCR,A            ;Set P87->Input,P86->Output
	BANK                0
	;BS                  PORT9,LeftYAxis
	;BS                  PORT9,LeftXAxis
	;BS                  PORT9,RightYAxis
	;BS                  PORT9,RightXAxis
	;BS                  PORT8,Reference    ; Set P87 Pull High
	BC                  PORT8,Leakresis     ; Set P86 Low

	BANK                2
	CLR                 IOcheckTimeCNT
	MOV                 A,IOcheckTimeCNT
	SUB                 A,@LeakresisTimeCNT
	JBC                 STATUS,C
	JMP                 $-3
	RET

;---------------------------------------------------------------
SampingRefTiming:
	BANK                4
	;MOV                 A,@0B11111111
	;MOV                 P9IOCR,A            ; P97-P94:Input; P93-P90:Input
	;BS                  P8IOCR,Leakresis    ; Input  P86
	;BC                  P8IOCR,Reference    ; Output P87
	MOV                 A,P8IOCR
	AND                 A,@0B00111111
	OR                  A,@0B01000000
	MOV                 P8IOCR,A             ;Set P87->Output,P86->Input
	BANK                0
	;BS                  PORT9,LeftYAxis
	;BS                  PORT9,LeftXAxis
	;BS                  PORT9,RightYAxis
	;BS                  PORT9,RightXAxis
	BS                  PORT8,Reference    ; Set P87 High
	;BS                  PORT8,Leakresis    ; Set P86

	BANK                2
	CLR                 IOcheckTimeCNT
	BANK                0
	JBS                 PORT8,Leakresis
	JMP                 $-1
	BANK                2
	MOV                 A,IOcheckTimeCNT
	MOV                 TEMP,A
	RET

;---------------------------------------------------------------
SampingLyTiming:
	BANK                4
	MOV                 A,@0B11111110
	MOV                 P9IOCR,A            ; P97-P94:Input; P93-P90:Input
	;BS                  P8IOCR,Leakresis    ; input
	;BS                  P8IOCR,Reference    ; output
	MOV                 A,P8IOCR
	AND                 A,@0B00111111
	OR                  A,@0B11000000
	MOV                 P8IOCR,A
	BANK                0
	BS                  PORT9,LeftYAxis    ; Set P90
	;BS                  PORT9,LeftXAxis
	;BS                  PORT9,RightYAxis
	;BS                  PORT9,RightXAxis
	;BC                  PORT8,Reference    ; Set P87
	;BS                  PORT8,Leakresis    ; Set P86

	BANK                2
	CLR                 IOcheckTimeCNT
	BANK                0
	JBS                 PORT8,Leakresis
	JMP                 $-1
	BANK                2
	MOV                 A,IOcheckTimeCNT
	MOV                 KEY_LEFT_Y,A        ; Left y Axis
	NOP
	NOP
	RET

;---------------------------------------------------------------
SampingLxTiming:
	BANK                4
	MOV                 A,@0B11111101
	MOV                 P9IOCR,A            ; P97-P94:Input; P93-P90:Input
	;BS                  P8IOCR,Leakresis    ; input
	;BS                  P8IOCR,Reference    ; output
	MOV                 A,P8IOCR
	AND                 A,@0B00111111
	OR                  A,@0B11000000
	MOV                 P8IOCR,A
	BANK                0
	;BS                  PORT9,LeftYAxis
	BS                  PORT9,LeftXAxis    ; Set P91
	;BS                  PORT9,RightYAxis
	;BS                  PORT9,RightXAxis
	;BC                  PORT8,Reference    ; Set P87
	;BS                  PORT8,Leakresis    ; Set P86

	BANK                2
	CLR                 IOcheckTimeCNT
	BANK                0
	JBS                 PORT8,Leakresis
	JMP                 $-1
	BANK                2
	MOV                 A,IOcheckTimeCNT
	MOV                 KEY_LEFT_X,A        ; Left x Axis
	NOP
	NOP
	RET

;---------------------------------------------------------------
SampingRyTiming:
	BANK                4
	MOV                 A,@0B11111011
	MOV                 P9IOCR,A            ; P97-P94:Input; P93-P90:Input
	;BS                  P8IOCR,Leakresis    ; input
	;BS                  P8IOCR,Reference    ; output
	MOV                 A,P8IOCR
	AND                 A,@0B00111111
	OR                  A,@0B11000000
	MOV                 P8IOCR,A
	BANK                0
	;BS                  PORT9,LeftYAxis
	;BS                  PORT9,LeftXAxis
	BS                  PORT9,RightYAxis
	;BS                  PORT9,RightXAxis
	;BC                  PORT8,Reference    ; Set P87
	;BS                  PORT8,Leakresis    ; Set P86

	BANK                2
	CLR                 IOcheckTimeCNT
	BANK                0
	JBS                 PORT8,Leakresis
	JMP                 $-1
	BANK                2
	MOV                 A,IOcheckTimeCNT
	MOV                 KEY_RIGHT_Y,A        ; right y Axis
	NOP
	NOP
	RET

;---------------------------------------------------------------
SampingRxTiming:
	BANK                4
	MOV                 A,@0B11110111
	MOV                 P9IOCR,A            ; P97-P94:Input; P93-P90:Input
	;BS                  P8IOCR,Leakresis    ; input
	;BS                  P8IOCR,Reference    ; output
	MOV                 A,P8IOCR
	AND                 A,@0B00111111
	OR                  A,@0B11000000
	MOV                 P8IOCR,A
	BANK                0
	;BS                  PORT9,LeftYAxis
	;BS                  PORT9,LeftXAxis
	;BS                  PORT9,RightYAxis
	BS                  PORT9,RightXAxis
	;BC                  PORT8,Reference    ; Set P87
	;BS                  PORT8,Leakresis    ; Set P86

	BANK                2
	CLR                 IOcheckTimeCNT
	BANK                0
	JBS                 PORT8,Leakresis
	JMP                 $-1
	BANK                2
	MOV                 A,IOcheckTimeCNT
	MOV                 KEY_RIGHT_X,A       ; right x Axis
	NOP
	NOP
	RET


;**********************************************************************************
;*********************************************************************************
; Connect Key Scan
; Input:
; output: KEY_NUM
;         KeyScanStatusFlag
; change: temp,KeystokeFlag_Befor(INITIAL)
;*********************************************************************************
ConnectKey_Scan:
;LINE4:	;SET P77=1 P76=0 P75=1 P74=1
	BANK                0
	MOV                 A,@10111000B
	MOV                 PORT7,A
	CALL                KEY_DELAY
	MOV                 A,PORT9                ;(Slect,Start,MODE,MACRO(Connect),x,x,x,x)
	BANK                2
	AND                 A,@00010000B           ;
	MOV                 TEMP,A
	MOV                 A,@00010000B           ; Bit4
	AND                 KeystokeFlag_Befor,A


;---------------------------------------------------------------------
  Falling_Edge_Judge:
	MOV                 A,TEMP
	XOR                 A,KeystokeFlag_Befor      ; bit 4, Check edge
	JBC                 STATUS,Z
	JMP                 Rising_Edge_Judge         ; no edge occur
	MOV                 A,TEMP                    ; Falling edge will change
	XOR                 A,@00000000B
	JBS                 STATUS,Z
	JMP                 Rising_Edge_Judge         ; no falling edge
	JBS                 KeyScanStatusFlag/16,KeyScanStatusFlag%16        ; scan the first falling edge
	BS                  KEY_NUM,0                            ; Will into key scan, Set leader bit
	CLR                 KeystokeTimeCNT                      ; press times ,recalculate
	BC                  KeyStatusFlag/16,KeyStatusFlag%16    ; key status, press(0) or release(1)
	BS                  KeyScanStatusFlag/16,KeyScanStatusFlag%16	     ; into scan key status
	JMP                 Edge_Judge_End

;--------------------------------------------------------------------
  Rising_Edge_Judge:
	MOV                 A,TEMP
	XOR                 A,KeystokeFlag_Befor      ; bit 4, Check edge
	JBC                 STATUS,Z
	JMP                 Edge_Judge_End
	MOV                 A,TEMP                    ; rising edge will change
	XOR                 A,@00010000B
	JBS                 STATUS,Z
	JMP                 Edge_Judge_End
	NOP
	CALL                KeyStatus_Low_Scan        ; rising edge ,check low level time
	CLR                 KeystokeTimeCNT           ; press times ,recalculate
	BS                  KeyStatusFlag/16,KeyStatusFlag%16
  Edge_Judge_End:
	MOV                 A,TEMP                    ; save currently press key status used for next judge
	MOV                 KeystokeFlag_Befor,A

;------------------------------------------------------------------------------
  KeystokeScan_End:                                                ; a cycle scan end
	JBS                 KeyScanStatusFlag/16,KeyScanStatusFlag%16
	CLR                 KEY_NUM
	JBC                 KEY_NUM,7                                  ; Count overflow
	CLR                 KEY_NUM
	BC                  System16msFlag/16,System16msFlag%16

	MOV                 A,KeystokeTimeCNT
	SUB                 A,@KeyPressTime                            ; KeyPressTime*16ms=3600ms(ComuTime=56ms)
	JBC                 STATUS,C
	INC                 KeystokeTimeCNT                            ; press times ,recalculate

	MOV                 A,KeystokeTimeCNT
	SUB                 A,@KeyScanTime                                      ; 60*16ms=960ms(ComuTime=56ms)
	JBC                 STATUS,C                                   ; Scan finish edge
	RET
	BC                  KeyScanStatusFlag/16,KeyScanStatusFlag%16  ; more than 60*16ms=960ms ,EXIT scan status
	BS                  KeyScanFinishFlag/16,KeyScanFinishFlag%16
	RET

;=========================================================================
KeyStatus_Low_Scan:     ; rising edge ,check low level time
	MOV                 A,KeystokeTimeCNT
	SUB                 A,@CrossingTime                      ;30*16ms=400ms(ComuTime=56ms)
	JBC                 STATUS,C                   ;
	JMP                 KeyScan_Short_Press	       ;less than 400ms
	JMP                 KeyScan_Lasting_Press      ;more than 400ms
  KeyScan_Short_Press:
	BC                  STATUS,C
	RLC                 KEY_NUM
	RET
  KeyScan_Lasting_Press:
	BS                  STATUS,C
	RLC                 KEY_NUM
	RET

