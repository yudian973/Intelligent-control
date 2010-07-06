;=============================================================================
;=============================================================================
; Filename      : KEYSCAN.ASM
; Author        : yu.wei
; Company       : ELAN
; VERSION       : v1.2
;               : v1.3 modify for touch roker 2010-5-12 15:38:51
; CRYSTAL       : 8MHZ
; Creat date    : 2009/12/3
; tool ver.     : WicePlus 2.7/eUIDE v1.01.01
; descripition  : For EM78P520,used for airui
;=============================================================================
;=============================================================================

;---------------------------------------------------
keyscan.asm             EQU       keyscan.asm
include "keyscan.H"

ifndef EM78CtrlIns.H
include "D:\include\EM78xx\EM78CtrlIns.H"
endif

ifndef EM78Math.H
include "D:\include\EM78xx\EM78Math.H"
endif


;----------------------------------------------------

	ORG                 0x10B0    ;PAGE 4
	MESSAGE "define 'keyscan.asm' ROM address"
Key_Scan:
	BANK                2
	JBC                 KeyScanInitFlag/8,KeyScanInitFlag%8
	JMP                 Key_Scan_startup
	NOP
	NOP
	BS                  KeyScanInitFlag/8,KeyScanInitFlag%8

;========================== Iinitial setting ================================
  if RokerSampingType == 0
	BANK                4
	MOV                 A,@00000000B
	MOV                 IOC7,A        ; Set Output
	MOV                 A,@11111111B
	MOV                 IOC9,A        ; P97-P94:Input; P93-P90:Input(Default IO)
	MOV                 A,@00001111B    ; PB0 PB1 PB2 PB3 As Input
	MOV                 PBIOCR,A       	;
	BANK                5
	MOV                 A,@11110000B
	MOV                 P9PHCR,A      ; Set Pull Up, P93-P90 disable pull high
	MOV                 A,@00001111B
	MOV                 PBPHCR,A      ; PB0 PB1 PB2 PB4 Enable Pull High
	CALL                SUB_RINIT
	CALL                SUB_ADJ

  elseif RokerSampingType == 1
	BANK                4
	MOV                 A,@00000000B
	MOV                 IOC7,A        ; Set Output
	MOV                 A,@11110000B
	MOV                 IOC9,A         ; P97-P94:Input; P93-P90:Output(Default IO)
	MOV                 A,@00001111B   ; PB0 PB1 PB2 PB3 As Input
	MOV                 PBIOCR,A       ;
	BANK                5
	MOV                 A,@11110000B
	MOV                 P9PHCR,A      ; Set Pull Up, P93-P90 disable pull high
	MOV                 A,@00001111B
	MOV                 PBPHCR,A      ; PB0 PB1 PB2 PB4 Enable Pull High
	CALL                Pre_Discharge
	CALL                SampingRefTiming

  elseif RokerSampingType == 2
	BANK                4
	MOV                 A,@00000000B
	MOV                 IOC7,A        ; Set Output
	MOV                 A,@11110000B
	MOV                 IOC9,A        ; P97-P94:Input; P93-P90:Output(Default IO)
	MOV                 A,@00010100B
	MOV                 PAIOCR,A
	MOV                 A,@00001111B    ; PB0 PB1 PB2 PB3 As Input
	MOV                 PBIOCR,A       	;
	BANK                5
	MOV                 A,@11110000B
	MOV                 P9PHCR,A      ; Set Pull Up, P93-P90 disable pull high
	MOV                 A,@00010100B
	MOV                 PAPHCR,A
	MOV                 A,@00001111B
	MOV                 PBPHCR,A      ; PB0 PB1 PB2 PB4 Enable Pull High
	BANK                2
	MOV                 A,@00000000B   ; Shift left, SDO delay time: 16clk,
	MOV                 SPIS, A        ; disable open-drain
	MOV                 A,@11001100B   ; Data shift out rising edge, is on hold during low
	MOV                 SPIC,A         ; Enable SPI mode, after data output SDO remain low

	CALL                TPModule_Ini

  endif
	NOP
;============================================================================

Key_Scan_startup:
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
	BC                  LED1_STATUS/8,LED1_STATUS%8		;PORT81
	JMP                 SET_VR_STATUS_END
  SET_VR_STATUS_1:
	NOP
	BANK                0
	BS                  LED1_STATUS/8,LED1_STATUS%8		;PORT81
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
	JBC                 ModeSelFlag/8,ModeSelFlag%8
	JMP                 MODE_NOCHANGE
	JBS                 ModeSelBakupFlag/8,ModeSelBakupFlag%8
	JMP                 MODE_NOCHANGE
	NOP
	COM                 DataF,MODE_13
	NOP
  MODE_NOCHANGE:
	MOVB                KeyTempBakupFlag,MODE_13,KeyTempFlag,MODE_13
	BC                  ModeSelFlag/8,ModeSelFlag%8

;---------------- Deal with DataA/DataB/DataC/DataD/DataG-----------------
  if RokerSampingType == 0
	CALL                ADC_Rocker_KeyScan
  elseif RokerSampingType == 1
	CALL                IO_Rocker_KeyScan
  elseif RokerSampingType == 2
	CALL                TP_Rocker_KeyScan

  if TP_T_DEBUG == 1
	;BANK                0
	;MOV                 A,@0B00001000          ; (test)P83 exchange when intrrupt
	;XOR                 PORT8,A
  endif

  endif

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
	RET


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
	MOV                 A,@_Directions
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

;----------------------------------------------------------------
	MOVB                KeyTempFlag,MODE_13,LINE3_KEY_INPUT_CACHE,_MODE  ;save MODE FLAG
	MOVB                KeyTempFlag,MACRO_14,LINE4_KEY_INPUT_CACHE,_MACRO ;save MACRO FLAG
	NOP
	RET


;==============================================================================
;=======================Direction key board scan===============================
;==============================================================================
;------------------------deal with DataA/DataB---------------------------------
;DataA	left-right: left=0x00, right=0xff, no-left-right=0x7f
;DataB	up-down:    down=0x00, up=0xff,    no-left-right=0x7f
;DataG  000:00¡¯ 001:45¡¯ 010:90¡¯ 011:135¡¯ 100:180¡¯ 101:225¡¯ 110:270¡¯ 111:315¡¯
;------------------------------------------------------------------------------
Direction_KeyCheck:
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

;===================================================================
; jugde rocker signal select
;===================================================================
Rocker_KeyScan:
	BANK                2
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
	RET


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


;****************************************************************
  if RokerSampingType == 0
;****************************************************************
;============================================================================
;file name:     ADC 3D Rocker KeyScan
;INPUT PORT:
;OUTPUT PORT:   KEY_LEFT_X,KEY_LEFT_Y,KEY_RIGHT_X,KEY_RIGHT_Y
;TIME:          1050uS
;Descrition:    Use for check AD rocker data
;============================================================================
ADC_Rocker_KeyScan:
	BANK                 3
	BS                   ADCR,ADP
	CLR                  ADDH
	MOV                  A,ADCR
	AND                  A,@0B11110000
	OR                   A,@0B00000000
	MOV                  ADCR,A              ;Select ADE0/P93.Rx
	CALL                 SUB_ADC
	MOV                  A,ADDH
	BANK                 2
	MOV                  KEY_RIGHT_X,A

	BANK                 3
	CLR                  ADDH
	MOV                  A,ADCR
	AND                  A,@0B11110000
	OR                   A,@0B00000001
	MOV                  ADCR,A              ;Select ADE1/P92.Ry
	MOV                  A,@5
	LCALL                DELAY_X10US
	CALL                 SUB_ADC
	MOV                  A,ADDH
	BANK                 2
	MOV                  KEY_RIGHT_Y,A
	;COM                  KEY_RIGHT_Y

	BANK                 3
	CLR                  ADDH
	MOV                  A,ADCR
	AND                  A,@0B11110000
	OR                   A,@0B00000010
	MOV                  ADCR,A              ;Select ADE2/P91.Lx
	MOV                  A,@5
	LCALL                DELAY_X10US
	CALL                 SUB_ADC
	MOV                  A,ADDH
	BANK                 2
	MOV                  KEY_LEFT_X,A

	BANK                 3
	CLR                  ADDH
	MOV                  A,ADCR
	AND                  A,@0B11110000
	OR                   A,@0B00000011
	MOV                  ADCR,A              ;Select ADE3/P90.Ly
	MOV                  A,@5
	LCALL                DELAY_X10US
	CALL                 SUB_ADC
	MOV                  A,ADDH
	BANK                 2
	MOV                  KEY_LEFT_Y,A
	;COM                  KEY_LEFT_Y
	BANK                 3
	BC                   ADCR,ADP

	;bank                 2
	;mov                  a,@0x7f
	;mov                  key_right_x,a
	;mov                  key_right_y,a
	;mov                  key_left_x,a
	;mov                  key_left_y,a

	NOP
	RET



;===================================================================
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
	RET

;===================================================================
SUB_RINIT:
	BANK                3
	MOV                 A,@0X0F
	MOV                 ADICL,A      ;SELECT ADE0~ ADE3 AS ANALOG INPUT
	CLR                 ADICH         ;VREFS==VDD
	MOV                 A,@0B01100000
	MOV                 ADCR,A       ;SELECT  AD0,SELECT ADCKR1/ADCKR0=1:0,ADP=1
	RET

;===================================================================
SUB_ADC:
	BANK                3
	BS                  ADCR,ADRUN
	JBC                 ADCR,ADRUN
	JMP                 $-1
	NOP
	RET


;****************************************************************
  elseif RokerSampingType == 1
;****************************************************************
;============================================================================
;file name:     IO 2D Rocker KeyScan
;INPUT PORT:
;OUTPUT PORT:   KEY_LEFT_X,KEY_LEFT_Y,KEY_RIGHT_X,KEY_RIGHT_Y
;TIME:
;Descrition:    Use for check AD rocker data
;============================================================================
IO_Rocker_KeyScan:
	CALL                Pre_Discharge
	CALL                SampingRefTiming   ; Ref
	CALL                Pre_Discharge
	CALL                SampingLxTiming    ; Lx
	CALL                Pre_Discharge
	CALL                SampingLyTiming    ; Ly
	CALL                Pre_Discharge
	CALL                SampingRxTiming    ; Rx
	CALL                Pre_Discharge
	CALL                SampingRyTiming    ; Ry
	CALL                Back_Discharge

	BANK                2
	MOV                 A,KEY_LEFT_X
	CALL                Conversion_Data
	MOV                 KEY_LEFT_X,A        ; Left x Axis
	MOV                 A,KEY_LEFT_Y
	CALL                Conversion_Data
	MOV                 KEY_LEFT_Y,A        ; Left y Axis
	MOV                 A,KEY_RIGHT_X
	CALL                Conversion_Data
	MOV                 KEY_RIGHT_X,A       ; right x Axis
	MOV                 A,KEY_RIGHT_Y
	CALL                Conversion_Data
	MOV                 KEY_RIGHT_Y,A       ; right y Axis

	NOP
	NOP
	RET

;---------------------------------------------------------------
Pre_Discharge:
	BANK                4
	MOV                 A,@0B11111111
	MOV                 P9IOCR,A             ; P97-P94:Input; P93-P90:Input
	;BS                  P8IOCR,Leakresis     ; Input P86
	;BS                  P8IOCR,Reference     ; Input P87
	MOV                 A,P8IOCR
	AND                 A,@0B00111111
	OR                  A,@0B11000000
	MOV                 P8IOCR,A             ; Set P87->Input,P86->Input

	MOV                 A,@0B11110000
	MOV                 P9IOCR,A             ; P97-P94:Input; P93-P90:Output
	BC                  P8IOCR,Leakresis     ; Output P86
	BC                  P8IOCR,Reference     ; Output P87
	;MOV                 A,P8IOCR
	;AND                 A,@0B00111111
	;OR                  A,@0B00000000
	;MOV                 P8IOCR,A            ; Set P87->Output,P86->Output
	BANK                0
	CLR                 PORT9
	;BC                  PORT9,LeftYAxis
	;BC                  PORT9,LeftXAxis
	;BC                  PORT9,RightYAxis
	;BC                  PORT9,RightXAxis
	BC                  PORT8,Leakresis     ; Set P86 Low
	BC                  PORT8,Reference     ; Set P87 Low

	CLR                 IMR                ; Disable Timier1/TCC
;  if IOtoADC_T_DEBUG ==1
;	MOV                 A,@0B00001000          ; (test)P83 exchange when intrrupt
;	XOR                 PORT8,A
;  endif
	BANK                2
	BS                  T2CR,T2EN          ; START
	CLR                 IOcheckTimeCNT
	MOV                 A,IOcheckTimeCNT
	SUB                 A,@LeakresisTimeCNT
	JBC                 STATUS,C
	JMP                 $-3
	BC                  T2CR,T2EN          ; Disable
	BANK                0
;  if IOtoADC_T_DEBUG ==1
;	MOV                 A,@0B00001000          ; (test)P83 exchange when intrrupt
;	XOR                 PORT8,A
;  endif
	MOV                 A,@0B10000001
	MOV                 IMR,A             ; Enable Timier1/TCC
	RET

Back_Discharge:
	BANK                4
	MOV                 A,@0B11111111
	MOV                 P9IOCR,A             ; P97-P94:Input; P93-P90:Input
	;BS                  P8IOCR,Leakresis     ; Input P86
	;BS                  P8IOCR,Reference     ; Input P87
	MOV                 A,P8IOCR
	AND                 A,@0B00111111
	OR                  A,@0B11000000
	MOV                 P8IOCR,A            ; Set P87->Input,P86->Input

	MOV                 A,@0B11110000
	MOV                 P9IOCR,A             ; P97-P94:Input; P93-P90:Output
	BC                  P8IOCR,Leakresis     ; Output P86
	BC                  P8IOCR,Reference     ; Output P87
	;MOV                 A,P8IOCR
	;AND                 A,@0B00111111
	;OR                  A,@0B10000000
	;MOV                 P8IOCR,A            ; Set P87->Input,P86->Output
	BANK                0
	CLR                 PORT9
	;BC                  PORT9,LeftYAxis
	;BC                  PORT9,LeftXAxis
	;BC                  PORT9,RightYAxis
	;BC                  PORT9,RightXAxis
	BC                  PORT8,Leakresis     ; Set P86 Low
	BC                  PORT8,Reference     ; Set P87 Low
	RET

;---------------------------------------------------------------
SampingRefTiming:
	BANK                4
	MOV                 A,@0B11111111
	MOV                 P9IOCR,A            ; P97-P94:Input; P93-P90:Input
	BS                  P8IOCR,Leakresis    ; Input  P86
	BC                  P8IOCR,Reference    ; Output P87
	;MOV                 A,P8IOCR
	;AND                 A,@0B00111111
	;OR                  A,@0B01000000
	;MOV                 P8IOCR,A           ; Set P87->Output,P86->Input
	BANK                0
	;BS                  PORT9,LeftYAxis
	;BS                  PORT9,LeftXAxis
	;BS                  PORT9,RightYAxis
	;BS                  PORT9,RightXAxis
	;BS                  PORT8,Leakresis    ; Set P86
	BS                  PORT8,Reference     ; Set P87 High

	CLR                 IMR                ; Disable Timier1/TCC
;  if IOtoADC_T_DEBUG ==1
;	MOV                 A,@0B00001000          ; (test)P83 exchange when intrrupt
;	XOR                 PORT8,A
;  endif
	BANK                2
	;MOV                 A,@IOCheckRate     ; N=, Auto reload
	;MOV                 T2PD,A
	BS                  T2CR,T2EN          ; START
	CLR                 IOcheckTimeCNT
	BANK                0
	JBS                 PORT8,Leakresis
	JMP                 $-1
	;MOV                 A,@0B10000001
	;MOV                 IMR,A             ; Enable Timier1/TCC
;  if IOtoADC_T_DEBUG ==1
;	MOV                 A,@0B00001000          ; (test)P83 exchange when intrrupt
;	XOR                 PORT8,A
;  endif
	BANK                2
	BC                  T2CR,T2EN          ; Disable
	MOV                 A,IOcheckTimeCNT
	MOV                 IOcheckRefValue,A
	BANK                0
	MOV                 A,@0B10000001
	MOV                 IMR,A             ; Enable Timier1/TCC
	RET


;---------------------------------------------------------------
SampingLxTiming:
	BANK                4
	MOV                 A,@0B11111101
	MOV                 P9IOCR,A            ; P97-P92:Input; P91:output; P90:Input
	BS                  P8IOCR,Leakresis    ; input
	BS                  P8IOCR,Reference    ; input
	;MOV                 A,P8IOCR
	;AND                 A,@0B00111111
	;OR                  A,@0B11000000
	;MOV                 P8IOCR,A
	BANK                0
	;BS                  PORT9,LeftYAxis
	BS                  PORT9,LeftXAxis     ; Set P91 HIGH
	;BS                  PORT9,RightYAxis
	;BS                  PORT9,RightXAxis
	;BS                  PORT8,Reference    ; Set P87
	;BS                  PORT8,Leakresis    ; Set P86

	CLR                 IMR                ; Disable Timier1/TCC
;  if IOtoADC_T_DEBUG ==1
;	MOV                 A,@0B00001000          ; (test)P83 exchange when intrrupt
;	XOR                 PORT8,A
;  endif
	BANK                2
	;MOV                 A,@IOCheckRate     ; N=, Auto reload
	;MOV                 T2PD,A
	BS                  T2CR,T2EN          ; START
	CLR                 IOcheckTimeCNT
	BANK                0
	JBS                 PORT8,Leakresis
	JMP                 $-1
	;MOV                 A,@0B10000001
	;MOV                 IMR,A             ; Enable Timier1/TCC
;  if IOtoADC_T_DEBUG ==1
;	MOV                 A,@0B00001000          ; (test)P83 exchange when intrrupt
;	XOR                 PORT8,A
;  endif
	BANK                2
	BC                  T2CR,T2EN           ; Disable
	MOV                 A,IOcheckTimeCNT
	MOV                 KEY_LEFT_X,A
	BANK                0
	MOV                 A,@0B10000001
	MOV                 IMR,A             ; Enable Timier1/TCC
	RET

;---------------------------------------------------------------
SampingLyTiming:
	BANK                4
	MOV                 A,@0B11111110
	MOV                 P9IOCR,A            ; P97-P91:Input; P90:output
	BS                  P8IOCR,Leakresis    ; input P86
	BS                  P8IOCR,Reference    ; input P87
	;MOV                 A,P8IOCR
	;AND                 A,@0B00111111
	;OR                  A,@0B11000000
	;MOV                 P8IOCR,A
	BANK                0
	BS                  PORT9,LeftYAxis     ; Set P90 HIGH
	;BS                  PORT9,LeftXAxis
	;BS                  PORT9,RightYAxis
	;BS                  PORT9,RightXAxis
	;BS                  PORT8,Reference    ; Set P87
	;BS                  PORT8,Leakresis    ; Set P86

	CLR                 IMR                ; Disable Timier1/TCC
;  if IOtoADC_T_DEBUG ==1
;	MOV                 A,@0B00001000          ; (test)P83 exchange when intrrupt
;	XOR                 PORT8,A
;  endif
	BANK                2
	;MOV                 A,@IOCheckRate     ; N=, Auto reload
	;MOV                 T2PD,A
	BS                  T2CR,T2EN          ; START
	CLR                 IOcheckTimeCNT
	BANK                0
	JBS                 PORT8,Leakresis
	JMP                 $-1
	;MOV                 A,@0B10000001
	;MOV                 IMR,A             ; Enable Timier1/TCC
;  if IOtoADC_T_DEBUG ==1
;	MOV                 A,@0B00001000          ; (test)P83 exchange when intrrupt
;	XOR                 PORT8,A
;  endif
	BANK                2
	BC                  T2CR,T2EN           ; Disable
	MOV                 A,IOcheckTimeCNT
	MOV                 KEY_LEFT_Y,A
	BANK                0
	MOV                 A,@0B10000001
	MOV                 IMR,A             ; Enable Timier1/TCC
	RET

;---------------------------------------------------------------
SampingRxTiming:
	BANK                4
	MOV                 A,@0B11110111
	MOV                 P9IOCR,A            ; P97-P94:Input; P93:output; P92-P90:Input
	BS                  P8IOCR,Leakresis    ; input
	BS                  P8IOCR,Reference    ; input
	;MOV                 A,P8IOCR
	;AND                 A,@0B00111111
	;OR                  A,@0B11000000
	;MOV                 P8IOCR,A
	BANK                0
	;BS                  PORT9,LeftYAxis
	;BS                  PORT9,LeftXAxis
	;BS                  PORT9,RightYAxis
	BS                  PORT9,RightXAxis    ; Set P93 HIGH
	;BS                  PORT8,Reference    ; Set P87
	;BS                  PORT8,Leakresis    ; Set P86

	CLR                 IMR                ; Disable Timier1/TCC
;  if IOtoADC_T_DEBUG ==1
;	MOV                 A,@0B00001000          ; (test)P83 exchange when intrrupt
;	XOR                 PORT8,A
;  endif
	BANK                2
	;MOV                 A,@IOCheckRate     ; N=, Auto reload
	;MOV                 T2PD,A
	BS                  T2CR,T2EN          ; START
	CLR                 IOcheckTimeCNT
	BANK                0
	JBS                 PORT8,Leakresis
	JMP                 $-1
	;MOV                 A,@0B10000001
	;MOV                 IMR,A             ; Enable Timier1/TCC
;  if IOtoADC_T_DEBUG ==1
;	MOV                 A,@0B00001000          ; (test)P83 exchange when intrrupt
;	XOR                 PORT8,A
;  endif
	BANK                2
	BC                  T2CR,T2EN           ; Disable
	MOV                 A,IOcheckTimeCNT
	MOV                 KEY_RIGHT_X,A
	BANK                0
	MOV                 A,@0B10000001
	MOV                 IMR,A             ; Enable Timier1/TCC
	RET

;---------------------------------------------------------------
SampingRyTiming:
	BANK                4
	MOV                 A,@0B11111011
	MOV                 P9IOCR,A            ; P97-P93:Input; P92:output; P91-P90:Input
	BS                  P8IOCR,Leakresis    ; input
	BS                  P8IOCR,Reference    ; input
	;MOV                 A,P8IOCR
	;AND                 A,@0B00111111
	;OR                  A,@0B11000000
	;MOV                 P8IOCR,A
	BANK                0
	;BS                  PORT9,LeftYAxis
	;BS                  PORT9,LeftXAxis
	BS                  PORT9,RightYAxis    ; Set P92 HIGH
	;BS                  PORT9,RightXAxis
	;BS                  PORT8,Reference    ; Set P87
	;BS                  PORT8,Leakresis    ; Set P86

	CLR                 IMR                ; Disable Timier1/TCC
;  if IOtoADC_T_DEBUG ==1
;	MOV                 A,@0B00001000          ; (test)P83 exchange when intrrupt
;	XOR                 PORT8,A
;  endif
	BANK                2
	;MOV                 A,@IOCheckRate     ; N=, Auto reload
	;MOV                 T2PD,A
	BS                  T2CR,T2EN          ; START
	CLR                 IOcheckTimeCNT
	BANK                0
	JBS                 PORT8,Leakresis
	JMP                 $-1
	;MOV                 A,@0B10000001
	;MOV                 IMR,A             ; Enable Timier1/TCC
  ;if IOtoADC_T_DEBUG ==1
	;MOV                 A,@0B00001000          ; (test)P83 exchange when intrrupt
	;XOR                 PORT8,A
  ;endif
	BANK                2
	BC                  T2CR,T2EN          ; START
	MOV                 A,IOcheckTimeCNT
	MOV                 KEY_RIGHT_Y,A
	;COM                 KEY_RIGHT_Y
	BANK                0
	MOV                 A,@0B10000001
	MOV                 IMR,A             ; Enable Timier1/TCC
	NOP
	RET

;=======================================================================
; input:        ACC
; output:       ACC
; registor:     TEMP, TEMP1, TEMP2
; descripition: Operate io data change to anylize data. Kr=0x80(2^7)
;=======================================================================
Conversion_Data:
	CLR                 TEMP1
	CLR                 TEMP2
  if Kr == 5
	MOV                 TEMP2,A
	BC                  STATUS,C
	RRC                 TEMP2
	RRC                 TEMP1
	MOV                 A,IOcheckRefValue
	MOV                 TEMP,A
  elseif Kr == 10
	MOV                 TEMP2,A
	;BC                  STATUS,C
	;RRC                 TEMP2
	;RRC                 TEMP1
	MOV                 A,IOcheckRefValue
	MOV                 TEMP,A
  endif

	mDIV2_1             TEMP2,TEMP1,TEMP
	MOV                 A,TEMP1
	NOP
	RET



;****************************************************************
  elseif RokerSampingType == 2
;****************************************************************
;===========================================================
;file name:     Touch Module 2D Rocker KeyScan
;INPUT PORT:
;OUTPUT PORT:   KEY_LEFT_X,KEY_LEFT_Y,KEY_RIGHT_X,KEY_RIGHT_Y
;TIME:
;Descrition:    Use for check AD rocker data
;===========================================================
TP_Rocker_KeyScan:
	BANK                0
	JBC                 TP_SPI_TPREQB/8,TP_SPI_TPREQB%8
	RET
	MOV                 A,@0X60
	MOV                 R4,A
  TP_READ_SPI_LOOP:
	BANK                0
	NOP
	NOP
	NOP
	NOP
	;BS                  TP_SPI_SS/8,TP_SPI_SS%8
	JBC                 TP_SPI_TPREQB/8,TP_SPI_TPREQB%8
	JMP                 $-1               ; Waitting for moment
	CALL                READ_SPI_REG
	BANK                0
	;BC                  TP_SPI_SS/8,TP_SPI_SS%8
	MOV                 A,R4
	AND                 A,@0B00001111
	SUB                 A,@11
	JBC                 STATUS,C
	JMP                 TP_READ_SPI_LOOP
	;BS                  TP_SPI_SS/8,TP_SPI_SS%8
	CALL                Makeup_TPData
	NOP
	NOP
	RET

;===============================================
; Function: Read SPI Register
; Input:    R4(Database)
; Output:   SPIRB
; description: 4 byte a packet
;===============================================
READ_SPI_REG:
	MOV                 A,@4              ;
	MOV                 Databytelength,A  ;Power-On Synchronizes 4Byte(0X55)
  READ_SIP_LOOP:
	BANK                0
	MOV                 A,@5
	LCALL               DELAY_X10US     ; Wait for TP module deal with

	BANK                2
	CLR                 SPIS
	CLR                 SPIR
	CLR                 SPIW            ; Write data to buffer
	BS                  SPIC, SSE       ; Start to shift data
	NOP
	JBC                 SPIC, SSE       ; Wait to finish shift data
	JMP                 $-2
	MOV                 A,SPIR
	BANK                0
	MOV                 R0,A
	INC                 R4
	DJZ                 Databytelength
	JMP                 READ_SIP_LOOP

	MOV                 A,@5
	LCALL               DELAY_X10US
	NOP
	RET


;===============================================
; Function: TP module initial
; Input:    none
; Output:
;===============================================
TPModule_Ini:
	BANK                0
	;MOV                 A,@0B00001000          ; (test)P83 exchange when intrrupt
	;XOR                 PORT8,A
	MOV                 A,@3
	LCALL               DELAY_X20MS
	;MOV                 A,@0B00001000          ; (test)P83 exchange when intrrupt
	;XOR                 PORT8,A
	BS                  TP_SPI_SS/8,TP_SPI_SS%8  ; TP module sleeclt
	MOV                 A,@1
	LCALL               DELAY_X10US
	JBC                 TP_SPI_TPREQB/8,TP_SPI_TPREQB%8
	JMP                 $-1
	MOV                 A,@0X60
	MOV                 R4,A
	CALL                READ_SPI_REG
	CALL                Reload_Default_TPData
	MOV                 A,@3
	LCALL               DELAY_X20MS
	NOP
	NOP
	RET

;---------------------------------------------------------------
Reload_Default_TPData:
	BANK                2
	MOV                 A,@0X7F
	MOV                 KEY_LEFT_X,A
	MOV                 KEY_LEFT_Y,A
	MOV                 KEY_RIGHT_X,A
	MOV                 KEY_RIGHT_Y,A
	RET

;===============================================
; Function: TP module Data make up to range
; Input:    none
; Output:
;===============================================
Makeup_TPData:
	BANK                0
	MOV                 A,TPPacket1Byte1
	XOR                 A,@0X56
	JBS                 STATUS,Z
	RET
	MOV                 A,TPPacket2Byte1
	XOR                 A,@0X57
	JBS                 STATUS,Z
	RET
	MOV                 A,TPPacket3Byte1
	XOR                 A,@0X59
	JBS                 STATUS,Z
	RET

  TPdata_Lxy:
	JBS                 TPPacket1Byte2,0      ;P1FS
	JMP                 TPdata_ReloadDef_Lxy
	JMP                 TPdata_Reload_Lxy
  TPdata_ReloadDef_Lxy:
	BANK                2
	MOV                 A,@0X7F
	MOV                 KEY_LEFT_X,A
	MOV                 KEY_LEFT_Y,A
	JMP                 TPdata_Rxy
  TPdata_Reload_Lxy:
	MOV                 A,TPPacket2Byte2
	BANK                2
	MOV                 KEY_LEFT_X,A
	BANK                0
	COMA                TPPacket2Byte3
	BANK                2
	MOV                 KEY_LEFT_Y,A

  TPdata_Rxy:
	BANK                0
	JBS                 TPPacket1Byte2,4      ;P2FS
	JMP                 TPdata_ReloadDef_Rxy
	JMP                 TPdata_Reload_Rxy
  TPdata_ReloadDef_Rxy:
	BANK                2
	MOV                 A,@0X7F
	MOV                 KEY_RIGHT_X,A
	MOV                 KEY_RIGHT_Y,A
	RET
  TPdata_Reload_Rxy:
	MOV                 A,TPPacket3Byte2
	BANK                2
	MOV                 KEY_RIGHT_X,A
	BANK                0
	COMA                TPPacket3Byte3
	BANK                2
	MOV                 KEY_RIGHT_Y,A
	NOP
	NOP
	RET

  endif