/*****************************************************************
* Filename     :  EM78CTRLINS.H
* Author       :  yu.wei
* Company      :  ELAN
* VERSION      :  1.0
* Creat date   :  2009/2
* tool ver.    :  WicePlus II/eUIDE
* Description  :  instruction aggregate
*****************************************************************/
;------------------------------------------------------
EM78CtrlIns.H    EQU         EM78CtrlIns.H

;-------------------------------------------------------

;***********************************************************
;sbit operator
;***********************************************************
; reg.bit exchange
;========================================
COM MACRO REG,BIT
	IF        BIT == 0
		MOV        A,@0B00000001
		XOR        REG,A
	ELSEIF    BIT == 1
		MOV        A,@0B00000010
		XOR        REG,A
	ELSEIF    BIT == 2
		MOV        A,@0B00000100
		XOR        REG,A
	ELSEIF    BIT == 3
		MOV        A,@0B00001000
		XOR        REG,A
	ELSEIF    BIT == 4
		MOV        A,@0B00010000
		XOR        REG,A
	ELSEIF    BIT == 5
		MOV        A,@0B00100000
		XOR        REG,A
	ELSEIF    BIT == 6
		MOV        A,@0B01000000
		XOR        REG,A
	ELSEIF    BIT == 7
		MOV        A,@0B10000000
		XOR        REG,A
	ELSE
		MESSAGE    "BIT select ERROR"
	ENDIF
ENDM

;===============================================
; TO reg.bit1 = reg2.bit2
;================================================
MOVB MACRO REG1,BIT1,REG2,BIT2
	JBS       REG2,BIT2
	BC        REG1,BIT1
	JBC       REG2,BIT2
	BS        REG1,BIT1
ENDM

;===============================================
; TO reg1.bit1 = /reg2.bit2
;===============================================
MOVBCPL MACRO REG1,BIT1,REG2,BIT2
	JBS       REG2,BIT2
	BS        REG1,BIT1
	JBC       REG2,BIT2
	BC        REG1,BIT1
ENDM

;===============================================
; TO REG1=@DATA
;===============================================
MOV MACRO REG,@DATA
	MOV       A,@DATA
	MOV       REG,A
ENDM

;===============================================
; TO REG1=REG2
;===============================================
MOV MACRO REG1,REG2
	MOV       A,REG2
	MOV       REG1,A
ENDM



;***********************************************************
;条件分支结构类宏
;***********************************************************
;===============================================
;decrement reg and jump when not zero
;================================================
DJNZ MACRO REG,ADDRESS
	DJZ       REG
	JMP       ADDRESS
ENDM

;=====================================================
; INC reg and jump when not zero
;=====================================================
IJNZ MACRO REG,ADDRESS
	JZ        REG
	JMP       ADDRESS
ENDM

;=====================================================
; compare and jump
; if reg1 > reg2 jump to add1
; if reg1 < reg2 jump to add2
;=====================================================
CJLJG MACRO REG1,REG2,ADD1,ADD2
	MOV       A,REG2
	SUB       A,REG1
	JBS       0X03,0 ;R3==0X03
	JMP       ADD1
	JBS       0X03,2
	JMP       ADD2
ENDM

;=====================================================
; compare and jump if in range
; if @LITE1 <= REG <= @LITE2 jump to ADDR
;=====================================================
CJIN MACRO REG,@LITE1,@LITE2,ADDR
	MOV       A,REG
	ADD       A,@255-LITE2
	ADD       A,@LITE2-LITE1+1
	JBC       0X03,0
	JMP       ADDR
ENDM

;=====================================================
; COMPARE AND JUMP IF OUT RANGE
; if REG > @LITE2 or REG < @LITE1 jump to ADDR
;=====================================================
CJOUT MACRO REG,@LITE1,@LITE2,ADDR
	MOV       A,REG
	ADD       A,@255-LITE2
	ADD       A,@LITE2-LITE1+1
	JBS       0X03,0
	JMP       ADDR
ENDM

;=====================================================
; compare and jump if REG1 > REG2
;=====================================================
CJG       MACRO REG1,REG2,ADDRESS
	MOV       A,REG1
	SUB       A,REG2
	JBS       0X03,0
	JMP       ADDRESS
ENDM

;=====================================================
; compare and jump if REG1 >= REG2
;=====================================================
CJGE MACRO REG1,REG2,ADDRESS
	MOV       A,REG2
	SUB       A,REG1
	JBC       0X03,0
	JMP       ADDRESS
ENDM

;=====================================================
; compare and jump if REG1 < REG2
;=====================================================
CJL MACRO REG1,REG2,ADDRESS
	MOV       A,REG2
	SUB       A,REG1
	JBS       0X03,0
	JMP       ADDRESS
ENDM

;=====================================================
; compare and jump if REG1 <= REG2
;=====================================================
CJLE MACRO REG1,REG2,ADDRESS
	MOV       A,REG1
	SUB       A,REG2
	JBC       0X03,0
	JMP       ADDRESS
ENDM

;=====================================================
; compare and jump if REG1 = REG2
;=====================================================
CJE MACRO REG1,REG2,ADDRESS
	MOV       A,REG2
	SUB       A,REG1
	JBC       0X03,2
	JMP       ADDRESS
ENDM

;=====================================================
; compare and jump if REG1 = @DATA jmp to ADDRESS
;=====================================================
CJE MACRO REG,@DATA,ADDRESS
	MOV       A,REG
	SUB       A,@DATA
	JBC       0X03,2
	JMP       ADDRESS
ENDM

;=====================================================
; compare and jump if REG1=REG2=@DATA jmp to ADDRESS
;=====================================================
CJE MACRO REG1,REG2,@DATA,ADDRESS
	MOV       A,REG2
	SUB       A,REG1
	JBS       0X03,2
	JMP       $_CJE_DONE
	MOV       A,REG1
	SUB       A,@DATA
	JBC       0X03,2
	JMP       ADDRESS
$_CJE_DONE:
ENDM

;=====================================================
; compare and jump if REG1 <> REG2
;=====================================================
CJNE MACRO REG1,REG2,ADDRESS
	MOV       A,REG2
	SUB       A,REG1
	JBS       0X03,2
	JMP       ADDRESS
ENDM

;=====================================================
;compare and jump if REG = 0 JMP ADDRESS
;=====================================================
CJZ MACRO REG,ADDRESS
	MOV       REG,REG
	JBC       0X03,2
	JMP       ADDRESS
ENDM

;=====================================================
; compare and jump if REG <> 0
;=====================================================
CJNZ MACRO REG,ADDRESS
	MOV       REG,REG
	JBS       0X03,2
	JMP       ADDRESS
ENDM

;=====================================================
; compare and jump if REG.BIT = 0
;=====================================================
CJBC MACRO REG,BIT,ADDRESS
	JBS       REG,BIT
	JMP       ADDRESS
ENDM

;=====================================================
; compare and jump if REG.BIT = 1
;=====================================================
CJBS MACRO REG,BIT,ADDRESS
	JBC       REG,BIT
	JMP       ADDRESS
ENDM

;=====================================================
; compare and jump if REG.BIT = 0 JMP ADDRESS1
;                  if REG.BIT = 1 JMP ADDRESS2
;=====================================================
CJBCS MACRO REG,BIT,ADDRESS1,ADDRESS2
	JBC       REG,BIT
	JMP       ADDRESS1
	JBS       REG,BIT
	JMP       ADDRESS2
ENDM





;***********************************************************
;中断压栈与出栈类宏
;***********************************************************
;===============================================
; 压栈程序
; 说明:中断入口调用此程序,将ACC,R3压栈
; A      -> A_TEMP
; R4    -> RSR_TEMP
; STATUS -> STATUS_TEMP
;================================================
PUSH MACRO
	MOV                 A_TEMP,A       ;A_TEMP,A         ;SAVE A
	SWAP                A_TEMP         ;A_TEMP
	SWAPA               0X03           ;STATUS           ;SAVE STATUS(R3)
	MOV                 STATUS_TEMP,A  ;STATUS_TEMP,A
IFDEF EM78P510.H
	SWAPA               0X05           ;R5              ;SAVE R5(R5)
	MOV                 RSR_TEMP,A     ;RSR_TEMP,A
ELSE
	SWAPA               0X04           ;R4              ;SAVE R4(R4)
	MOV                 RSR_TEMP,A     ;RSR_TEMP,A
ENDIF
	CLR                 0X03           ;STATUS           ;SELECT PAGE0
ENDM

;---------------------------------------
POP MACRO
	SWAPA               STATUS_TEMP    ;STATUS_TEMP    ;R3
	MOV                 0X03,A         ;STATUS,A
IFDEF EM78P510.H
	SWAPA               RSR_TEMP       ;RSR_TEMP       ;R4
	MOV                 0X05,A         ;R4,A
ELSE
	SWAPA               RSR_TEMP       ;RSR_TEMP       ;R4
	MOV                 0X04,A         ;R4,A
ENDIF
	SWAPA               A_TEMP         ;A_TEMP
ENDM

;========================== EM78P520 =================================
PUSH MACRO A_Temp,STATUS_Temp,RSR_Temp,@BankSel,Ax_Temp,STATUSx_Temp,RSRx_Temp
	MOV                 A_TEMP,A       ;A_TEMP,A         ;SAVE A
	SWAP                A_TEMP         ;A_TEMP
	SWAPA               0X03           ;STATUS           ;SAVE STATUS(R3)
	MOV                 STATUS_TEMP,A  ;STATUS_TEMP,A
	SWAPA               0X05           ;R4              ;SAVE R4(R4)
	MOV                 RSR_TEMP,A     ;RSR_TEMP,A
	CLR                 0X03           ;STATUS           ;SELECT PAGE0

	BANK                @BankSel
	MOV                 A,A_TEMP
	MOV                 Ax_Temp,A
	MOV                 A,STATUS_Temp
	MOV                 STATUSx_Temp,A
	MOV                 A,RSR_Temp
	MOV                 RSRx_Temp,A
ENDM

;---------------------------------------
POP MACRO A_Temp,STATUS_Temp,RSR_Temp,@BankSel,Ax_Temp,STATUSx_Temp,RSRx_TEMP
	BANK                @BankSel
	MOV                 A,Ax_Temp
	MOV                 A_TEMP,A
	MOV                 A,STATUSx_Temp
	MOV                 STATUS_Temp,A
	MOV                 A,RSR_TEMP
	MOV                 RSRx_TEMP,A

	SWAPA               STATUS_TEMP    ;STATUS_TEMP    ;R3
	MOV                 0X03,A         ;STATUS,A
	SWAPA               RSR_TEMP       ;RSR_TEMP       ;R4
	MOV                 0X05,A         ;R4,A
	SWAPA               A_TEMP         ;A_TEMP
ENDM

;***********************************************************
;long jmp/long call
;***********************************************************
;===================================================
; select page
;===================================================
PAGE MACRO NUM
IFDEF     EM78P510.H
	ERROR
	MESSAGE "ERROR:THe EM78510 Not Support PAGE insruction but used LCALL or LJMP"
	MESSAGE "can not use the instrction PAGE"
ELSE
	IF        NUM == 0
              BC        0X03,7
              BC        0X03,6
              BC        0X03,5
	ELSEIF    NUM == 1
	          BC        0X03,7
	          BC        0X03,6
	          BS        0X03,5
	ELSEIF    NUM == 2
	          BC        0X03,7
	          BS        0X03,6
	          BC        0X03,5
	ELSEIF    NUM == 3
	          BC        0X03,7
	          BS        0X03,6
	          BS        0X03,5
	ELSEIF    NUM == 4
	          BS        0X03,7
	          BC        0X03,6
	          BC        0X03,5
	ELSEIF    NUM == 5
	          BS        0X03,7
	          BC        0X03,6
	          BS        0X03,5
	ELSEIF    NUM == 6
	          BS        0X03,7
	          BS        0X03,6
	          BC        0X03,5
	ELSEIF    NUM == 7
	          BS        0X03,7
	          BS        0X03,6
	          BS        0X03,5
	ELSE
	          MESSAGE "WARRING: don't have specify page"
	ENDIF
ENDIF

ENDM

;===================================================%
; roboticized call
;===================================================
FCALL MACRO ADDRESS
IFDEF     EM78P510.H
	ERROR
	MESSAGE "ERROR:THe EM78510 Not Support PAGE insruction but used LCALL or LJMP"
	MESSAGE "can not use the instrction FCALL"
ELSE
	IF        ADDRESS/0X400 == $/0X400
	          CALL      ADDRESS
	ELSE
	          PAGE      ADDRESS/0X400
	          CALL      ADDRESS%0X400
	          PAGE      $/0X400
	ENDIF
ENDIF
ENDM

;===================================================
; roboticized call
; input:NUM = page number,  ADDRESS =  code address
;===================================================
FCALL MACRO NUM,ADDRESS
IFDEF     EM78P510.H
	ERROR
	MESSAGE "ERROR:THe EM78510 Not Support PAGE insruction but used LCALL or LJMP"
	MESSAGE "can not use the instrction FCALL"
ELSE
	PAGE      NUM
	CALL      ADDRESS
	PAGE      $/0X400
ENDIF
ENDM

;===================================================
; roboticized jmp
;===================================================
FJMP MACRO ADDRESS
IFDEF     EM78P510.H
	ERROR
	MESSAGE "ERROR:THe EM78510 Not Support PAGE insruction but used LCALL or LJMP"
	MESSAGE "can not use the instrction FJMP"
ELSE
	IF        ADDRESS/0X400 == $/0X400
	          JMP       ADDRESS
	ELSE
	          PAGE      ADDRESS/0X400
	          JMP       ADDRESS%0X400
	ENDIF
ENDIF
ENDM

;===================================================
; roboticized jmp
; input:NUM = page number,  ADDRESS =  code address
;===================================================
FJMP MACRO NUM,ADDRESS
IFDEF     EM78P510.H
	ERROR
	MESSAGE "ERROR:THe EM78510 Not Support PAGE insruction but used LCALL or LJMP"
	MESSAGE "can not use the instrction FJMP"
ELSE
	PAGE      NUM
	JMP       ADDRESS
ENDIF
ENDM

;===================================================
; select bank
;===================================================
BANK MACRO @NUM
IFDEF EM78M611E.H
	IF        @NUM == 0
              BC        0X04,7
              BC        0X04,6
	ELSEIF    @NUM == 1
	          BC        0X04,7
	          BS        0X04,6
	ELSEIF    @NUM == 2
	          BS        0X04,7
	          BC        0X04,6
	ELSEIF    @NUM == 3
	          BS        0X04,7
	          BS        0X04,6
	ENDIF

ELSEIFDEF EM78M612.H
	IF        @NUM == 0
              BC        0X04,6
	ELSEIF    @NUM == 1
	          BS        0X04,6
	ENDIF
ELSE
	MESSAGE "the MCU defualt have 'bank' intruction"
ENDIF
ENDM



;*******************************************
; RAM clear function
; [ELSE]: default the MCU have four bank
; others: xx.h must be define in "xx.h"
;*******************************************
ClrRamBank MACRO
IFDEF EM78P520.H
 	CLR     0X05
	MOV     A,@0XD0
	MOV     0X04,A

	CLR     0X00
	INC     0X04
	MOV     A,0X04
	AND     A,@0X3F
	JBS     0X03,2
	JMP     $-5
	BC      0X04,6
	INC     0X05
	BS      0X04,5
	MOV     A,@0X07
	AND     0X05,A
	BS      0X04,6
	JBS     0X03,2
	JMP     $-13
	CLR		0X04
	BS      0X04,6

ELSEIFDEF EM78M611E.H
 	MOV     A,@0x10
	MOV     R4,A

	CLR     R0
	INC     R4
	JBC     R4,6
	BS      R4,5
	JBC     R4,7
	BS      R4,5
	JBS     R3,Z
	JMP     $-7
	CLR     R4

	MOV     A,@0X11
	MOV     RD,A
	CLR     RE
	MOV     A,@1
	MOV     RD,A
	MOV     A,@0X00
	MOV     RE,A
	MOV     RE,A
	MOV     RE,A
	MOV     RE,A
	MOV     RE,A
	MOV     RE,A
	MOV     RE,A
	MOV     RE,A
	BS      RC,5

ELSEIFDEF EM78P447.H
 	MOV     A,@0x10
	MOV     R4,A

	CLR     R0
	INC     R4
	JBC     R4,6
	BS      R4,5
	JBC     R4,7
	BS      R4,5
	JBS     R3,Z
	JMP     $-7
	CLR     R4

ELSEIFDEF EM78P468.H
	MOV     A,@0X10
	MOV     0X04,A

	CLR     0X00
	INC     0X04
	JBC     0X04,6
	BS      0X04,5
	JBC     0X04,7
	BS      0X04,5
	JBS     0X03,2
	JMP     $-7

ELSEIFDEF EM78P458.H
	MOV     A,@0X10
	MOV     R4,A

	CLR     R0
	INC     R4
	JBC     R4,6
	BS      R4,5
	JBS     R4,7
	JMP     $-5
	CLR     R4

ELSEIFDEF EM78P451.H
	MOV     A,@0X10
	MOV     R4,A

	CLR     R0
	INC     R4
	JBC     R4,6
	BS      R4,5
	JBC     R4,7
	BS      R4,5
	JBS     STATUS,Z
	JMP     $-7
	CLR		RSR

ELSEIFDEF EM78F651.H
	MOV		A,@0X10
	MOV		RSR,A

	CLR		R0
	INC		RSR
	JBC	 	RSR,6
	BS		RSR,5
	JBC		RSR,7
	BS		RSR,5
	JBS		Z
	JMP             $-7
	CLR		RSR

ELSEIFDEF EM78P153N.H
        MOV     A,@0X10
        MOV     RSR,A

        CLR     R0
        INC     RSR
        JBC     RSR,5
        JBS     RSR,4
        JMP     $-4
 

ELSE
	MOV     A,@0x10        ; clear all ram bank
	MOV     R4,A

	CLR     R0
	INC     R4
	JBC     R4,6
	BS      R4,5
	JBC     R4,7
	BS      R4,5
	JBS     R3,Z
	JMP     $-7
	CLR     R4
	MESSAGE "Clear all RAM bank"
ENDIF
ENDM

;*******************************************
; RAM clear function
; [ELSE]: default the MCU have four bank
; others: xx.h must be define in "xx.h"
;*******************************************
ClrCommRamBank MACRO
	MOV                 A, @0X10        ; 清RAM 初始地址
	MOV                 R4, A

	WDTC
	CLR                 R0
	INC                 R4
	MOV                 A,@0B00111111
	AND                 A,R4
	SUB                 A,@0X1F
	JBC                 R3,C
	JMP                 $-7
	CLR                 R4
ENDM

;********************************************************************
;********************************************************************
Clearbuffer MACRO
  ifdef EM78P520.H
	MOV                 A,@0B11100000   ; clear bank0 ram
	MOV                 R4,A
	BANK                0               ; R5=0

	WDTC
	CLR                 R0
	INC                 R4
	MOV                 A,@0B00111111
	AND                 A,R4
	XOR                 A,@0X3F
	JBS                 R3,Z
	JMP                 $-7
	CLR                 R0
	MOV                 A,@0B11000000
	MOV                 R4,A

  elseifdef EM78M611E.H
	MOV                 A,@0B00100000   ; clear bank0 ram
	MOV                 R4,A

	WDTC
	CLR                 R0
	INC                 R4
	MOV                 A,@0B00111111
	AND                 A,R4
	XOR                 A,@0X3F
	JBS                 R3,Z
	JMP                 $-7
	CLR                 R0
	CLR                 R4

  else
	MOV                 A,@0B00100000   ; clear bank0 ram
	MOV                 R4,A

	WDTC
	CLR                 R0
	INC                 R4
	MOV                 A,@0B00111111
	AND                 A,R4
	XOR                 A,@0X3F
	JBS                 R3,Z
	JMP                 $-7
	CLR                 R4
  endif
ENDM

