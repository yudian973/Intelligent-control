;**********************************************************************;
; Title:        EM78Math Macros Define                                 ;
; Description:  The Maths for EM78x447xxx                              ;
; Company:      Elan Corp.Inc                                          ;
; Author:       Shenzhen 8Bit Tean                                     ;
; Date:         5/26/2004                                              ;
; Version:      1.0                                                    ;
;**********************************************************************

;**********************************************************************;
; Title:       1 Byte Binary Code Transform BCD Code                   ;
; Description: Hundred Bigit Of Bcd Cade Storage In  Low Bigit  Of     ;
;              reg_acc3,Entries Bigit Of Bcd Cade Storage In High      ;
;              Bigit Of reg_acc2, Binary Data Storage In reg_acc1      ;
; Arithmetic:  BCD==100*a+10*b+c                                       ;
; Input:       reg_acc1                                                ;
; Output:      reg_acc3, reg_acc2                                      ;
; Variable Register:None                                               ;
; Register Changed: R3, 0 ;ACC                                         ;
;**********************************************************************;



;---------------------------------------------------------------------


;
mBinToBcd1 MACRO reg_acc1, reg_acc3, reg_acc2
;
        CLR     reg_acc2        ;clear BCD data register
        CLR     reg_acc3
        MOV     A, reg_acc1
$Bin_Bcd1:
        ADD     A, @156         ;subtract 100 from binary that is transform
        JBS     STATUS, C       ;borrow bigit?
        JMP     $Bin_Bcd2       ;borrow bigit jump to Bin_Bcd2
        INC     reg_acc3        ;if don't borrow bigit then hundred bigit adding 1
        JMP     $Bin_Bcd1       ;backing out
$Bin_Bcd2:
        ADD     A, @100         ;有借位，则加回被减去的数100
        MOV     reg_acc1, A
$Bin_Bcd3:
        ADD     A, @246         ;余下的被减数再减10
        JBS     STATUS, C       ;有借位吗？
        JMP     $Bin_Bcd4       ;有借位，则跳出
        INC     reg_acc2        ;无借位，则BCD码的十位寄存器加1
        JMP     $Bin_Bcd3
$Bin_Bcd4:
        ADD     A, @10          ;有借位，则加回被减去的数10
        SWAP    reg_acc2        ;将BCD码的十位存到reg_acc2的高半字节
        ADD     reg_acc2, A     ;将BCD码的个位存到reg_acc2的低半字节
        ENDM
;
;**********************************************************************;
; Title:       2 Byte Binary Code Transform BCD Code                   ;
; Description: Highest Bigit Of Bcd Storage In Low Byte Of reg_acc5,   ;
;              Lowest Bigit Of Bcd Storage In Low Byte Of reg_acc3,    ;
;              High Bigit Of Binary Storage In reg_acc1,               ;
;              Low Bigit Of Binart Storage In reg_acc2,                ;
; Input:       reg_acc1, reg_acc2                                      ;
; Output:      reg_acc3, reg_acc4, reg_acc5                            ;
; Variable Register:reg_acc, reg_accd                                  ;
; Register Changed: R3, 0; ACC                                         ;
; Status:      1                                                       ;
;**********************************************************************;
;
mBinToBcd2 MACRO reg_acc2, reg_acc1, reg_acc5, reg_acc4, reg_acc3
;
        MOV     A, @16          ;设定移位字节长度(其值=byte*8)
        MOV     reg_acc, A
        CLR     reg_acc5        ;清BCD码寄存器
        CLR     reg_acc4
        CLR     reg_acc3
        BC      STATUS, C       ;清R3标志位C
$Bin_Bcd1:
        RLC     reg_acc1        ;左移被转换的字节的最低位寄存器
        RLC     reg_acc2        ;左移被转换的字节的最高位寄存器
        RLC     reg_acc3        ;左移BCD码的最低位寄存器
        RLC     reg_acc4
        RLC     reg_acc5        ;左移BCD码的最高位寄存器
        DJZ     reg_acc         ;移位完成了吗？
        JMP     $Bin_Bcd2       ;未完，进行BCD码调整
        JMP     $Bin_Bcd3       ;移位完，跳出
$Bin_Bcd2:
        MOV     A, reg_acc3     ;对reg_acc3进行BCD码调整
        CALL    $bcdadj         ;调BCD码调整子程序
        MOV     reg_acc3, A     ;
        MOV     A, reg_acc4     ;对reg_acc4进行BCD码调整
        CALL    $BCDADJ
        MOV     reg_acc4, A
        MOV     A, reg_acc5     ;对reg_acc5进行BCD码调整
        CALL    $BCDADJ
        MOV     reg_acc5, A
        JMP     $Bin_Bcd1       ;返回，继续进行移位处理
;-------BCD Code Adjust Subprogram---------------
$BCDADJ:
        ADD     A, @51
        MOV     reg_accd, A
        JBS     reg_accd, 3
        ADD     A, @253
        JBS     reg_accd, 7
        ADD     A, @208
        RET
$Bin_Bcd3:
        ENDM
;
;**********************************************************************;
; Title:      3 Byte Binary Code Transform Bcd Code                    ;
; Description:reg_acc7的高半字节存放BCD码的最高位，                    ;
;             reg_acc4的低半字节存放BCD码的最低位,                     ;
;             reg_acc3存放被转换字节的最高位，                         ;
;             reg_acc1存放被转换字节的最低位。                         ;
; Input:      reg_acc1, reg_acc2, reg_acc3                             ;
; Output:     reg_acc4, reg_acc5, reg_acc6, reg_acc7                   ;
; Variable Register:reg_acc, reg_accd                                  ;
; Register Changed: R3, 0;ACC                                          ;
; stack:      1                                                        ;
;**********************************************************************;
;
mBinToBcd3 MACRO reg_acc3, reg_acc2, reg_acc1, reg_acc7, reg_acc6, reg_acc5, reg_acc4
;
        MOV     A, @24          ;设定移位字节长度（其值=byte*8)
        MOV     reg_acc, A
        CLR     reg_acc4
        CLR     reg_acc5
        CLR     reg_acc6
        CLR     reg_acc7
        BC      STATUS, C       ;清R3标志位C
$Bin_Bcd1:
        RLC     reg_acc1        ;左移被转换字节数的最低位寄存器
        RLC     reg_acc2
        RLC     reg_acc3        ;左移被转换字节数的最高位寄存器
        RLC     reg_acc4        ;左移BCD码的最低位寄存器
        RLC     reg_acc5
        RLC     reg_acc6
        RLC     reg_acc7        ;左移BCD码的最高位寄存器
        DJZ     reg_acc         ;移位完成了吗？
        JMP     $Bin_Bcd2       ;未完，进行BCD码调整
        JMP     $Bin_Bcd3       ;移位完，跳出
$Bin_Bcd2:
        MOV     A, reg_acc4     ;对reg_acc4进行BCD码调整
        CALL    $BCDADJ         ;调BCD码调整子程序
        MOV     reg_acc4, A
        MOV     A, reg_acc5     ;对reg_acc5进行BCD码调整
        CALL    $BCDADJ
        MOV     reg_acc5, A
        MOV     A, reg_acc6     ;对reg_acc6进行BCD码调整
        CALL    $BCDADJ
        MOV     reg_acc6, A
        MOV     A, reg_acc7     ;对reg_acc7进行BCD码调整
        CALL    $BCDADJ
        MOV     reg_acc7, A
        JMP     $Bin_Bcd1       ;移位未完，返回，继续进行移位处理
;-------BCD Code Adjust Subprogram---------------
$BCDADJ:
        ADD     A, @51
        MOV     reg_accd, A
        JBS     reg_accd, 3
        ADD     A, @253
        JBS     reg_accd, 7
        ADD     A, @208
        RET
$Bin_Bcd3:
        ENDM
;
;**********************************************************************;
; Title:      4 Byte Binary Code Transform Bcd Code                    ;
; Description:reg_acc9的高半字节存放BCD码的最高位，                    ;
;             reg_acc5的低半字节存放BCD码的最低位，                    ;
;             reg_acc4存放被转换字节的最高位，                         ;
;             reg_acc1存放被转换字节的最低位?                          ;
; Arithmetic:                                                          ;
; Input:      reg_acc1, reg_acc2, reg_acc3, reg_acc4                   ;
; Output:     reg_acc5, reg_acc6, reg_acc7, reg_acc8, reg_acc9         ;
; Variable Register:reg_acc, reg_accd                                  ;
; Register Changed: R3, 0; ACC                                         ;
; stack:      1                                                        ;
;**********************************************************************;
;
mBinToBcd4 MACRO reg_acc4, reg_acc3, reg_acc2, reg_acc1, reg_acc9, reg_acc8, reg_acc7, reg_acc6, reg_acc5
;
        MOV     A,  @32         ;设定移位字节长度(其值=byte*8)
        MOV     reg_acc, A
        CLR     reg_acc5        ;清BCD码寄存器
        CLR     reg_acc6
        CLR     reg_acc7
        CLR     reg_acc8
        CLR     reg_acc9
        BC      STATUS, C       ;清R3标志位C
$Bin_Bcd1:
        RLC     reg_acc1        ;左移被转换字节数的最低位寄存器
        RLC     reg_acc2
        RLC     reg_acc3
        RLC     reg_acc4        ;左移被转换字节数的最高位寄存器
        RLC     reg_acc5
        RLC     reg_acc6        ;左移BCD码的最低位寄存器
        RLC     reg_acc7
        RLC     reg_acc8
        RLC     reg_acc9        ;左移BCD码的最高位寄存器
        DJZ     reg_acc         ;移位完成了吗？
        JMP     $Bin_Bcd2       ;未完，进行BCD码调整
        JMP     $Bin_Bcd3       ;移位完，跳出
$Bin_Bcd2:
        MOV     A, reg_acc5     ;对reg_acc5进行BCD码调整
        CALL    $BCDADJ         ;调BCD码调整子程序
        MOV     reg_acc5, A
        MOV     A, reg_acc6     ;对reg_acc6进行BCD码调整
        CALL    $BCDADJ
        MOV     reg_acc6, A
        MOV     A, reg_acc7     ;对reg_acc7进行BCD码调整
        CALL    $BCDADJ
        MOV     reg_acc7, A
        MOV     A, reg_acc8     ;对reg_acc8进行BCD码调整
        CALL    $BCDADJ
        MOV     reg_acc8, A
        MOV     A, reg_acc9     ;对reg_acc9进行BCD码调整
        CALL    $BCDADJ
        MOV     reg_acc9, A
        JMP     $Bin_Bcd1       ;移位未完成，返回，继续进行移位处理
;-------BCD Code Adjust Subprogram---------------
$BCDADJ:
        ADD     A, @51
        MOV     reg_accd, A
        JBS     reg_accd, 3
        ADD     A, @253
        JBS     reg_accd, 7
        ADD     A, @208
        RET
$Bin_Bcd3:
        ENDM
;**********************************************************************;
; Title:      5 Byte Binary Code Transform Bcd Code                    ;
; Description:reg_accc的低半字节存放BCD的最高位，                      ;
;             reg_acc6的低半字节存放BCD的最低位，                      ;
;             reg_acc5存放被转换字节的最高位，                         ;
;             reg_acc1存放被转换字节的最低位。                         ;
; Input:      reg_acc1, reg_acc2, reg_acc3, reg_acc4, reg_acc5,        ;
; Output:     reg_acc6, reg_acc7, reg_acc8, reg_acc9, reg_acca,        ;
;             reg_accb, reg_accc                                       ;
; Variable Register:reg_acc, reg_accd                                  ;
; Register Changed: R3, 0;ACC                                          ;
; Stack:      1                                                        ;
;**********************************************************************;
;
mBinToBcd5 MACRO reg_acc5, reg_acc4, reg_acc3, reg_acc2, reg_acc1
;
        MOV     A,  @40         ;设定移位字节长度(其值=byte*8)
        MOV     reg_acc, A
        CLR     reg_acc6        ;清BCD码寄存器
        CLR     reg_acc7
        CLR     reg_acc8
        CLR     reg_acc9
        CLR     reg_acca
        CLR     reg_accb
        CLR     reg_accc
        BC      STATUS, C       ;清R3标志位C
$Bin_Bcd1:
        RLC     reg_acc1
        RLC     reg_acc2
        RLC     reg_acc3        ;左移被转换字节的最低位寄存器
        RLC     reg_acc4        ;
        RLC     reg_acc5        ;左移被转换字节的最高位寄存器
;
        RLC     reg_acc6        ;左移BCD码寄存器的最低位
        RLC     reg_acc7
        RLC     reg_acc8
        RLC     reg_acc9
        RLC     reg_acca
        RLC     reg_accb
        RLC     reg_accc        ;左移BCD码寄存器的最高位
        DJZ     reg_acc         ;移位完成了吗？
        JMP     $Bin_Bcd2       ;未完，进行BCD码调整
        JMP     $Bin_Bcd3       ;移位完，跳出
$Bin_Bcd2:
        MOV     A, reg_acc6     ;对reg_acc6进行BCD码调整
        CALL    $BCDADJ         ;调BCD码调整子程序
        MOV     reg_acc6, A
        MOV     A, reg_acc7     ;对reg_acc7进行BCD码调整
        CALL    $BCDADJ
        MOV     reg_acc7, A
        MOV     A, reg_acc8     ;对reg_acc8进行BCD码调整
        CALL    $BCDADJ
        MOV     reg_acc8, A
        MOV     A, reg_acc9     ;对reg_acc9进行BCD码调整
        CALL    $BCDADJ
        MOV     reg_acc9, A
        MOV     A, reg_acca     ;对reg_acca进行BCD码调整
        CALL    $BCDADJ
        MOV     reg_acca, A
        MOV     A, reg_accb     ;对reg_accb进行BCD码调整
        CALL    $BCDADJ
        MOV     reg_accb, A
        MOV     A, reg_accc     ;对reg_accc进行BCD码调整
        CALL    $BCDADJ
        MOV     reg_accc, A
        JMP     $Bin_Bcd1       ;未移完，返回，继续进行移位处理
;
;-------BCD Code Adjust Subprogram---------------
$BCDADJ:
        ADD     A, @51
        MOV     reg_accd, A
        JBS     reg_accd, 3
        ADD     A, @253
        JBS     reg_accd, 7
        ADD     A, @208
        RET
$Bin_Bcd3:
        ENDM
;
;**********************************************************************;
; Title:      1 Byte Bcd Code Transform 1 Byte Binary Code             ;
; Input:      reg_acc1(BCD code)                                       ;
; Output:     reg_acc2(Binary Code)                                    ;
; Register Changed: STATUS, C;ACC                                      ;
;**********************************************************************;
;
mBcdToBin1 MACRO reg_acc1, reg_acc2
;
        CLR     reg_acc2
        SWAPA   reg_acc1        ;将reg_acc1的高半字节送到A的低半字节
        AND     A, @0X0F        ;屏蔽reg_acc1, 0-3bit.
        MOV     reg_acc2, A
        BC      STATUS, C
        RLC     reg_acc2        ;reg_acc2*10
        RLC     reg_acc2
        ADD     reg_acc2, A
        RLC     reg_acc2
        MOV     A, reg_acc1
        AND     A, @0X0F        ;屏蔽reg_acc1, 4-7bit
        ADD     reg_acc2, A     ;bcd code的十位数乘10后加bcd code的个位数
        ENDM
;
;**********************************************************************;
; Title:     2 Byte Bcd Code Transform 2 Byte Binary Code              ;
; Input:     reg_acc1, reg_acc2;reg_acc2:High Bigit Of Bcd Code;       ;
;            reg_acc1:Low Bigit Of Bcd Code.                           ;
; Output:    reg_acc3, reg_acc4;reg_acc4:High Byte Binary Code;        ;
;            reg_acc3:Low Byte Of Binary Code.                         ;
; Register Changed: STATUS, C; ACC                                     ;
; Stack:     1                                                         ;
;**********************************************************************;
;
mBcdToBin2 MACRO reg_acc2, reg_acc1, reg_acc4, reg_acc3
;
        CLR     reg_acc3        ;clear binary code register
        CLR     reg_acc4
        MOV     A, @16          ;移位的次数（reg_acc==byte*8)
        Mov     reg_acc, A
$Bcd_Bin1:
        BC      STATUS, C
        RRC     reg_acc2        ;将BCD数和BINARY数一起右移，从高移到低
        RRC     reg_acc1
        RRC     reg_acc4
        RRC     reg_acc3
        MOV     A, reg_acc1     ;对BCD数进行BCD调整
        CALL    $Binadj
        MOV     reg_acc1, A
        MOV     A, reg_acc2
        CALL    $Binadj
        MOV     reg_acc2, A
        DJZ     reg_acc
        JMP     $Bcd_Bin1
        JMP     $Bcd_Bin2
$Binadj:
        MOV     reg_accd, A
        JBC     reg_accd, 3
        ADD     A, @253
        JBC     reg_accd, 7
        ADD     A, @208
        RET
$Bcd_Bin2:
        ENDM
;
;**********************************************************************;
; Title:    3 Byte Bcd Code Transform 3 Byte Binary Code               ;
; Input:    reg_acc1,reg_acc2,reg_acc3;reg_acc3:High Bigit Of Bcd Code;;
;           reg_acc1:Low Bigit Of Bcd Code.                            ;
; Output:   reg_acc4,reg_acc5,reg_acc6;reg_acc6:High Byte Binary Code; ;
;           reg_acc4:Low Byte Of Binary Code.                          ;
; Register Changed: STATUS, C; ACC                                     ;
; Stack:     1                                                         ;
;**********************************************************************;
;
mBcdToBin3 MACRO reg_acc3, reg_acc2, reg_acc1, reg_acc6, reg_acc5, reg_acc4
;
        CLR     reg_acc4
        CLR     reg_acc5
        CLR     reg_acc6
        MOV     A, @24          ;移位的次数（reg_acc==BYTE*8)
        MOV     reg_acc, A
$Bcd_Bin1:
        BC      STATUS, C
        RRC     reg_acc3
        RRC     reg_acc2
        RRC     reg_acc1
        RRC     reg_acc6
        RRC     reg_acc5
        RRC     reg_acc4
        MOV     A, reg_acc1
        CALL    $Binadj
        MOV     reg_acc1, A
        MOV     A, reg_acc2
        CALL    $Binadj
        MOV     reg_acc2, A
        MOV     A, reg_acc3
        CALL    $Binadj
        MOV     reg_acc3, A
        DJZ     reg_acc
        JMP     $Bcd_Bin1
        JMP     $Bcd_Bin2
$Binadj:
        MOV     reg_accd, A
        JBC     reg_accd, 3
        ADD     A, @253
        JBC     reg_accd, 7
        ADD     A, @208
        RET
$Bcd_Bin2:
        ENDM
;
;**********************************************************************;
; Title:     4 Byte Bcd Code Transform 4 Byte Binary Code              ;
; Input:     reg_acc1, reg_acc2, reg_acc3, reg_acc4;reg_acc4:High Bigit;
;            Of Bcd Code;reg_acc1:Low Bigit Of Bcd Code.               ;
; Output:    reg_acc5, reg_acc6, reg_acc7, reg_acc8;reg_acc8:High Byte ;
;            Binary Code;reg_acc5:Low Byte Of Binary Code.             ;
; Register Changed: STATUS, C;ACC                                      ;
; Stack:     1                                                         ;
;**********************************************************************;
;
mBcdToBin4 MACRO reg_acc4, reg_acc3, reg_acc2, reg_acc1, reg_acc8, reg_acc7, reg_acc6, reg_acc5
;
        CLR     reg_acc5
        CLR     reg_acc6
        CLR     reg_acc7
        CLR     reg_acc8
        MOV     A, @32          ;移位的次数（reg_acc==BYTE*8)
        MOV     reg_acc, A
$Bcd_Bin1:
        BC      STATUS, C
        RRC     reg_acc4
        RRC     reg_acc3
        RRC     reg_acc2
        RRC     reg_acc1
        RRC     reg_acc8
        RRC     reg_acc7
        RRC     reg_acc6
        RRC     reg_acc5
        MOV     A, reg_acc1
        CALL    $Binadj
        MOV     reg_acc1, A
        MOV     A, reg_acc2
        CALL    $Binadj
        MOV     reg_acc2, A
        MOV     A, reg_acc3
        CALL    $Binadj
        MOV     reg_acc3, A
        MOV     A, reg_acc4
        CALL    $Binadj
        MOV     reg_acc4, A
        DJZ     reg_acc
        JMP     $Bcd_Bin1
        JMP     $Bcd_Bin2
$Binadj:
        MOV     reg_accd, A
        JBC     reg_accd, 3
        ADD     A, @253
        JBC     reg_accd, 7
        ADD     A, @208
        RET
$Bcd_Bin2:
        ENDM
;
;**********************************************************************;
; Title:     5 Byte Bcd Code Transform 5 Byte Binary Code              ;
; Input:     reg_acc1, reg_acc2, reg_acc3, reg_acc4, reg_acc5;         ;
;            reg_acc5:High Bigit Of Bcd Code;reg_acc1:lOw Bigit Of     ;
;            Bcd Code.                                                 ;
; Output:    reg_acc6, reg_acc7, reg_acc8, reg_acc9, reg_acca;         ;
;            reg_acca:High Byte Of Binary Code;reg_acc6:Low Byte       ;
;            Of Binary Code.                                           ;
; Register Changed: STATUS, C; ACC                                     ;
; Stack:     1                                                         ;
;**********************************************************************;
;
mBcdToBin5 MACRO  reg_acc5, reg_acc4, reg_acc3, reg_acc2, reg_acc1
;
        CLR     reg_acc6
        CLR     reg_acc7
        CLR     reg_acc8
        CLR     reg_acc9
        CLR     reg_acca
        MOV     A, @40          ;移位的次数（reg_acc==BYTE*8)
        MOV     reg_acc, A
$Bcd_Bin1:
        BC      STATUS, C
        RRC     reg_acc5
        RRC     reg_acc4
        RRC     reg_acc3
        RRC     reg_acc2
        RRC     reg_acc1
        RRC     reg_acca
        RRC     reg_acc9
        RRC     reg_acc8
        RRC     reg_acc7
        RRC     reg_acc6
        MOV     A, reg_acc1
        CALL    $Binadj
        MOV     reg_acc1, A
        MOV     A, reg_acc2
        CALL    $Binadj
        MOV     reg_acc2, A
        MOV     A, reg_acc3
        CALL    $Binadj
        MOV     reg_acc3, A
        MOV     A, reg_acc4
        CALL    $Binadj
        MOV     reg_acc4, A
        MOV     A, reg_acc5
        CALL    $Binadj
        MOV     reg_acc5, A
        DJZ     reg_acc
        JMP     $Bcd_Bin1
        JMP     $Bcd_Bin2
$Binadj:
        MOV     reg_accd, A
        JBC     reg_accd, 3
        ADD     A, @253
        JBC     reg_accd, 7
        ADD     A, @208
        RET
$Bcd_Bin2:
        ENDM


;*****************************************************************
;Function:    Subtration
;Input:       reg_acc2, reg_acc1, reg_acc3
;Output:      reg_acc2, reg_acc1
;description: reg_acc2/reg_acc1 is the reslut;
;             reg_acc3 is a symbol:
;             0X00 Mean reslut is plus
;             0X01 Mean reslut is negative
;*****************************************************************
mSubtration2_1 MACRO reg_acc2, reg_acc1, reg_acc3
        BC      STATUS,C
        MOV     A,reg_acc3
        SUB     reg_acc1,A
        JBC     STATUS,C
        JMP     Subtration_End  
        CLR     reg_acc3
        MOV     A,@0X01
        SUB     A,reg_acc2
        JBC     STATUS,C
        DEC     reg_acc2
        JBC     STATUS,C
        INC     reg_acc3        
Subtration_End:
        ENDM

;**********************************************************************;
; Title:        Division 8 bits /8 bits -> 8 bit --8 bits              ;
; Description:  reg_acc1/reg_acc2->reg_acc1 --reg_acc2                 ;
; Input:        Dividend reg_acc1        Divisor    reg_acc2           ;
; Output:       Result   reg_acc1        Remainder  reg_acc2           ;
; Variable Register:None                                               ;
; Register Changed: STATUS, ACC, reg_acc(address 0x20)                 ;
;**********************************************************************;
mDIV1_1 MACRO reg_acc1, reg_acc2
;
        MOV     A, @8           ;Recurrence Cortrol Data
        MOV     reg_acc, A
        CLRA                    ;Check Divisor Is Zero
        OR      A, reg_acc2     ;Divisor load into A register
        JBC     STATUS, 2
        JMP     $_Div_Out       ;Divisor Is Zero, A=0，Exit Peration.
        CLR     reg_acc2        ;Divisor Is Not Zero, Begin Peration，Then A=1
$_Div_Sub:
        RLC     reg_acc1        ;Dividend Left Shift 1Bit
        RLC     reg_acc2
        BS      reg_acc1, 0     ;Before Check Dividend > Divisor,  Quotient Low Set 1.
        SUB     reg_acc2, a
        JBC     STATUS, C
        JMP     $_Div_Cnt       ;Dividend > Divisor
        BC      reg_acc1, 0     ;Dividend < Divisor, Quotient low bit clear 0.
        ADD     reg_acc2, A     ;Revert Dividend
$_Div_Cnt:
        DJZ     reg_acc         ;If Finish Shift, Set A=1 Exit
        JMP     $_Div_Sub
        MOV     A, @1           ;Finish Peration ,  A Register Return 1
$_Div_Out:
        ENDM
;
;**********************************************************************;
; Title:        Division 16 bits /8 bits -> 16 bit --8 bits            ;
; Description:  (reg_acc2,reg_acc1)/reg_acc3                           ;
;               ->(reg_acc2,reg_acc1)--reg_acc3                        ;
; Input:        Dividend reg_acc2,reg_acc1       Divisor    reg_acc3   ;
; Output:       Result   reg_acc2,reg_acc1       Remainder  reg_acc3   ;
; Variable Register:None                                               ;
; Register Changed: STATUS, ACC, reg_acc(address 0x20)                 ;
;**********************************************************************;
;
mDIV2_1 MACRO reg_acc2, reg_acc1, reg_acc3
;
        MOV     A, @16          ;Recurrence Cortrol Data
        MOV     reg_acc, A
        CLRA                    ;Check Divisor Is Zero
        OR      A, reg_acc3     ;Divisor load into A register
        JBC     STATUS, Z
        JMP     $_Div_Out       ;Divisor Is Zero, A=0，Exit Peration.
        CLR     reg_acc3        ;Divisor Is Not Zero, Begin Peration，Then A=1
$_Div_Sub:
        RLC     reg_acc1        ;Dividend Left Shift 1Bit
        RLC     reg_acc2
        RLC     reg_acc3
        BS      reg_acc1, 0     ;Before Check Dividend > Divisor,  Quotient Low Set 1.
        JBS     STATUS, C
        JMP     $_Div_S_0
        SUB     reg_acc3, A
        JMP     $_Div_Cnt
$_Div_S_0:
        SUB     reg_acc3, A
        JBC     STATUS, C
        JMP     $_Div_Cnt
        BC      reg_acc1, 0
        ADD     reg_acc3, A
$_Div_Cnt:
        DJZ     reg_acc         ;If Finish Shift, Set A=1 Exit
        JMP     $_Div_Sub
        MOV     A, @1           ;Finish Peration ,  A Register Return 1
$_Div_Out:
        ENDM
;
;**********************************************************************;
; Title:        Division 16 bits /16 bits -> 16 bit --16 bits          ;
; Description:  (reg_acc2, reg_acc1)/(reg_acc4, reg_acc3)              ;
;               ->(reg_acc2, reg_acc1)--(reg_acc4, reg_acc3)           ;
; Input:        Dividend reg_acc2,reg_acc1 Divisor   reg_acc4,reg_acc3 ;
; Output:       Result   reg_acc2,reg_acc1 Remainder reg_acc4,reg_acc3 ;
; Variable Register:None                                               ;
; Register Changed: STATUS, ACC, reg_acc(address 0x20)                 ;
;                   , reg_acc5(0x025), reg_acc6(0x26)                  ;
;**********************************************************************;
;
mDIV2_2 MACRO reg_acc2, reg_acc1, reg_acc4, reg_acc3
;
        CLRA
        OR      A, reg_acc3     ;Check Divisor Is Zero
        OR      A, reg_acc4
        JBC     STATUS, Z
        JMP     $_Div_Out       ;Divisor Is Zero, A=0，Exit Peration.
        MOV     A, @16          ;Recurrence Cortrol Data
        MOV     reg_acc, A
        CLR     reg_acc5        ;Divisor Is Not Zero, Begin Peration，Then A=1
        CLR     reg_acc6
$_Div_Sub:
        BC      STATUS, C       ;Clear c Flag
        RLC     reg_acc1        ;Dividend Left Shift 1Bit
        RLC     reg_acc2
        RLC     reg_acc5
        RLC     reg_acc6
        MOV     A, reg_acc4     ;Check If Dividend > Divisor
        SUB     A, reg_acc6     ;Check High Word  Equal
        JBS     STATUS, Z
        JMP     $_Div_Set
        MOV     A, reg_acc3     ;High Word Equal Then Check  Low Word
        SUB     A, reg_acc5
$_Div_Set:
        JBS     STATUS, C
        JMP     $_Div_S_0       ;Dividend < Divisor, Quotient Add 0.
        BS      reg_acc1, 0     ;Dividend > Divisor, Quotient Add 1.
        MOV     A, reg_acc3     ;Dividend-Divisor, From Low Word To High Word.
        SUB     reg_acc5, A     ;Save Diviso
        JBS     STATUS, C
        DEC     reg_acc6        ;If Low Word < High Word, Next High Word Sub 1.
        MOV     A, reg_acc4
        SUB     reg_acc6, A
$_Div_S_0:
        DJZ     reg_acc         ;If Finish Shift, Set A=1 Exit
        JMP     $_Div_Sub
        MOV     A, reg_acc6     ;Save Result Into User's Register.
        MOV     reg_acc4, A
        MOV     A, reg_acc5
        MOV     reg_acc3, A
        MOV     A, @1           ;Finish Peration ,  A Register Return 1
$_Div_Out:
        ENDM
;
;**********************************************************************;
; Title:        Division 24 bits /8 bits -> 24 bit --8 bits            ;
; Description:  (reg_acc3, reg_acc2, reg_acc1)/reg_acc4                ;
;               ->(reg_acc3, reg_acc2, reg_acc1) --reg_acc4            ;
; Input:        Dividend reg_acc3,reg_acc2,reg_acc1 Divisor   reg_acc4 ;
; Output:       Result   reg_acc3,reg_acc2,reg_acc1 Remainder reg_acc4 ;
; Variable Register:None                                               ;
; Register Changed: STATUS, ACC, reg_acc(address 0x20)                 ;
;**********************************************************************;
;
mDIV3_1 MACRO reg_acc3, reg_acc2, reg_acc1, reg_acc4
;
        MOV     A, @24          ;Recurrence Cortrol Data
        MOV     reg_acc, A
        CLRA                    ;Check Divisor Is Zero
        OR      A, reg_acc4     ;Divisor load into A register
        JBC     STATUS, Z
        JMP     $_Div_Out       ;Divisor Is Zero, A=0，Exit Peration.
        CLR     reg_acc4        ;Divisor Is Not Zero, Begin Peration，Then A=1
$_Div_Sub:
        RLC     reg_acc1        ;Dividend Left Shift 1Bit
        RLC     reg_acc2
        RLC     reg_acc3
        RLC     reg_acc4
        BS      reg_acc1, 0     ;Before Check Dividend > Divisor,  Quotient Low Set 1.
        JBS     STATUS, C
        JMP     $_Div_S_0       ;C Flag Is 0, Check Dividend > Divisor
        SUB     reg_acc4, A     ;C Flag Is 1, Quotient Low Bit Set 1
        JMP     $_Div_Cnt
$_Div_S_0:
        SUB     reg_acc4, A
        JBC     STATUS, C
        JMP     $_Div_Cnt       ;Dividend > Divisor
        BC      reg_acc1, 0     ;Dividend < Divisor, Quotient low bit clear 0.
        ADD     reg_acc4, A     ;Revert Dividend
$_Div_Cnt:
        DJZ     reg_acc         ;If Finish Shift, Set A=1 Exit
        JMP     $_Div_Sub
        MOV     A, @1           ;Finish Peration ,  A Register Return 1
$_Div_Out:
        ENDM
;
;**********************************************************************;
; Title:        Division 24 bits /16 bits -> 24 bit --16 bits          ;
; Description:  (reg_acc3, reg_acc2, reg_acc1)/(reg_acc5, reg_acc4)    ;
;               ->(reg_acc3, reg_acc2, reg_acc1) --(reg_acc5, reg_acc4);
; Input:        Dividend  reg_acc3 reg_acc2 reg_acc1                   ;
;               Divisor   reg_acc5, reg_acc4                           ;
; Output:       Result    reg_acc3 reg_acc2 reg_acc1                   ;
;               Remainder reg_acc5, reg_acc4                           ;
; Variable Register: None                                              ;
; Register Changed: STATUS, ACC, reg_acc(address 0x20), reg_acc6(0x26) ;
;                   , reg_acc7(0x27)                                   ;
;**********************************************************************;
;
mDIV3_2 MACRO reg_acc3, reg_acc2, reg_acc1, reg_acc5, reg_acc4
;
        CLRA
        OR      A, reg_acc4     ;Check Divisor Is Zero
        OR      A, reg_acc5
        JBC     STATUS, Z
        JMP     $_Div_Out       ;If Divisor Is Zero, A=0，Exit Peration.
        MOV     A, @24          ;Recurrence Cortrol Data
        MOV     reg_acc, A      ;Divisor Is Not Zero, Begin Peration，Then A=1.
        CLR     reg_acc6        ;clear Remainder register
        CLR     reg_acc7
$_Div_Sub:
        BC      STATUS, C       ;Clear c Flag
        RLC     reg_acc1        ;Dividend Left Shift 1Bit
        RLC     reg_acc2
        RLC     reg_acc3
        RLC     reg_acc6
        RLC     reg_acc7
        JBC     STATUS, C
        JMP     $_Div_Set_1     ;C Flag Is 1, Quotient Low Bit Set 1
        MOV     A, reg_acc5     ;Check If Dividend > Divisor
        SUB     A, reg_acc7     ;Check High Word  Equal
        JBS     STATUS, Z
        JMP     $_Div_Set
        MOV     A, reg_acc4     ;High Word Equal Then Check  Low Word
        SUB     A, reg_acc6
$_Div_Set:
        JBS     STATUS, C
        JMP     $_Div_S_0       ;Dividend < Divisor, Quotient Add 0.
$_Div_Set_1:
        BS      reg_acc1, 0     ;Dividend > Divisor, Quotient Add 1.
        MOV     A, reg_acc4     ;Dividend-Divisor, From Low Word To High Word.
        SUB     reg_acc6, A     ;Save Diviso
        JBS     STATUS, C
        DEC     reg_acc7        ;If Low Word < High Word, Next High Word Sub 1.
        MOV     A, reg_acc5
        SUB     reg_acc7, A
$_Div_S_0:
        DJZ     reg_acc         ;If Finish Shift, SetA=1 Exit
        JMP     $_Div_Sub
        MOV     A, reg_acc7     ;Save Result Into User's Register.
        MOV     reg_acc5, A
        MOV     A, reg_acc6
        MOV     reg_acc4, A
        MOV     A, @1           ;Finish Peration ,  A Register Return 1
$_Div_Out:
        ENDM
;
;**********************************************************************;
; Title:        Division 24 bits /24 bits -> 24 bit --24 bits          ;
; Description:  (reg_acc3,reg_acc2,reg_acc1)/                          ;
;               (reg_acc6,reg_acc5,reg_acc4)                           ;
;               ->(reg_acc3,reg_acc2,reg_acc1)                         ;
;               --(reg_acc6,reg_acc5,reg_acc4)                         ;
; Input:        Dividend  reg_acc3 reg_acc2 reg_acc1                   ;
;               Divisor   reg_acc6 reg_acc5, reg_acc4                  ;
; Output:       Result    reg_acc3 reg_acc2 reg_acc1                   ;
;               Remainder reg_acc6, reg_acc5, reg_acc4                 ;
; Variable Register:None                                               ;
; Register Changed: STATUS, ACC, reg_acc(address 0x20), reg_acc7(x027) ;
;                   , reg_acc8(0x28),  reg_acc9(0x29)                  ;
;**********************************************************************;
;
mDIV3_3 MACRO reg_acc3, reg_acc2, reg_acc1, reg_acc6, reg_acc5, reg_acc4
;
        CLRA
        OR      A, reg_acc4     ;Check Divisor Is Zero
        OR      A, reg_acc5
        OR      A, reg_acc6
        JBC     STATUS, Z
        JMP     $_Div_Out       ;If Divisor Is Zero, A=0，Exit Peration.
        MOV     A, @24          ;Recurrence Cortrol Data
        MOV     reg_acc, A      ;Divisor Is Not Zero, Begin Peration，Then A=1.
        CLR     reg_acc7        ;clear Remainder register
        CLR     reg_acc8
        CLR     reg_acc9
$_Div_Sub:
        BC      STATUS, C       ;Clear c Flag
        RLC     reg_acc1        ;Dividend Left Shift 1Bit
        RLC     reg_acc2
        RLC     reg_acc3
        RLC     reg_acc7
        RLC     reg_acc8
        RLC     reg_acc9
        MOV     A, reg_acc6     ;Check If Dividend > Divisor
        SUB     A, reg_acc9     ;Check High Word  Equal
        JBS     STATUS, Z
        JMP     $_Div_Set
        MOV     A, reg_acc5     ;High Word Equal Then Check  Low Word
        SUB     A, reg_acc8
        JBS     STATUS, Z
        JMP     $_Div_Set
        MOV     A, reg_acc4
        SUB     A, reg_acc7
$_Div_Set:
        JBS     STATUS, C
        JMP     $_Div_S_0       ;If Dividend < Divisor, Quotient Add 0.
        BS      reg_acc1, 0     ;If Dividend > Divisor, Quotient Add 1.
        MOV     A, reg_acc4     ;Dividend-Divisor, From Low Word To High Word.
        SUB     reg_acc7, A     ;Save Diviso
        JBS     STATUS, C
        DEC     reg_acc8        ;If Low Word < High Word, Next High Word Sub 1.
        MOV     A, reg_acc5
        SUB     reg_acc8, A
        JBS     STATUS, C
        DEC     reg_acc9
        MOV     A, reg_acc6
        SUB     reg_acc9, A
$_Div_S_0:
        DJZ     reg_acc         ;If Finish Shift, Set A=1 Exit
        JMP     $_Div_Sub
        MOV     A, reg_acc9     ;Save Result Into User's Register.
        MOV     reg_acc6, A
        MOV     A, reg_acc8
        MOV     reg_acc5, A
        MOV     A, reg_acc7
        MOV     reg_acc4, A
        MOV     A, @1           ;Finish Peration ,  A Register Return 1
$_Div_Out:
        ENDM
;
;**********************************************************************;
; Title:        Division 32 bits /8 bits -> 32 bit --8 bits            ;
; Description:  (reg_acc4, reg_acc3, reg_acc2, reg_acc1)/reg_acc5      ;
;               ->(reg_acc4, reg_acc3, reg_acc2, reg_acc1) --reg_acc5  ;
; Input:        Dividend  reg_acc4 reg_acc3 reg_acc2 reg_acc1          ;
;               Divisor   reg_acc5                                     ;
; Output:       Result    reg_acc4 reg_acc3 reg_acc2 reg_acc1          ;
;               Remainder reg_acc5                                     ;
; Variable Register:None                                               ;
; Register Changed: STATUS, ACC, reg_acc(address 0x20)                 ;
;**********************************************************************;
;
mDIV4_1 MACRO reg_acc4, reg_acc3, reg_acc2, reg_acc1, reg_acc5
;
        MOV     A, @32          ;Recurrence Cortrol Data
        MOV     reg_acc, A
        CLRA                    ;Check Divisor Is Zero
        OR      A, reg_acc5     ;Divisor load into A register
        JBC     STATUS, Z
        JMP     $_Div_Out       ;Divisor Is Zero, A=0，Exit Peration.
        CLR     reg_acc5        ;Divisor Is Not Zero, Begin Peration，Then A=1.
$_Div_Sub:
        RLC     reg_acc1        ;Dividend Left Shift 1Bit
        RLC     reg_acc2
        RLC     reg_acc3
        RLC     reg_acc4
        RLC     reg_acc5
        BS      reg_acc1, 0     ;Before Check Dividend > Divisor,  Quotient Low Bit _Div_Set 1.
        JBS     STATUS, C
        JMP     $_Div_S_0       ;C Flag Is 0, Check Dividend > Divisor
        SUB     reg_acc5, A     ;C Flag Is 1, Quotient Low Bit Set 1
        JMP     $_Div_Cnt
$_Div_S_0:
        SUB     reg_acc5, A
        JBC     STATUS, C
        JMP     $_Div_Cnt       ;Dividend > Divisor
        BC      reg_acc1, 0     ;Dividend < Divisor, Quotient low bit clear 0.
        ADD     reg_acc5, A     ;Revert Dividend
$_Div_Cnt:
        DJZ     reg_acc         ;If Finish Shift, Set A=1 Exit
        JMP     $_Div_Sub
        MOV     A, @1           ;Finish Peration ,  A Register Return 1
$_Div_Out:
        ENDM
;
;**********************************************************************;
; Title:        Division 32 bits /16 bits -> 32 bit --16 bits          ;
; Description:  (reg_acc4, reg_acc3, reg_acc2, reg_acc1)/              ;
;               (reg_acc6, reg_acc5)                                   ;
;               ->(reg_acc4, reg_acc3, reg_acc2, reg_acc1)             ;
;               --(reg_acc6, reg_acc5)                                 ;
; Input:        Dividend  reg_acc4 reg_acc3 reg_acc2 reg_acc1          ;
;               Divisor   reg_acc6 reg_acc5                            ;
; Output:       Result    reg_acc4, reg_acc3 reg_acc2 reg_acc1         ;
;               Remainder reg_acc6, reg_acc5                           ;
; Variable Register:None                                               ;
; Register Changed: STATUS, ACC, reg_acc(address 0x20), reg_acc7(x027) ;
;                   , reg_acc8(0x28)                                   ;
;**********************************************************************;
;
mDIV4_2 MACRO reg_acc4, reg_acc3, reg_acc2, reg_acc1, reg_acc6, reg_acc5
;
        CLRA
        OR      A, reg_acc6     ;Check Divisor Is Zero
        OR      A, reg_acc5
        JBC     STATUS, Z
        JMP     $_Div_Out       ;If Divisor Is Zero, A=0，Exit Peration.
        MOV     A, @32          ;Recurrence Cortrol Data
        MOV     reg_acc, A      ;Divisor Is Not Zero, Begin Peration，Then A=1.
        CLR     reg_acc7        ;clear Remainder register
        CLR     reg_acc8
$_Div_Sub:
        BC      STATUS, C       ;Clear c Flag
        RLC     reg_acc1        ;Dividend Left Shift 1Bit
        RLC     reg_acc2
        RLC     reg_acc3
        RLC     reg_acc4
        RLC     reg_acc7
        RLC     reg_acc8
        JBC     STATUS, C
        JMP     $_Div_Set_1     ;C Flag Is 1, Quotient Low Bit Set 1
        MOV     A, reg_acc6     ;Check If Dividend > Divisor
        SUB     A, reg_acc8     ;Check High Word  Equal
        JBS     STATUS, Z
        JMP     $_Div_Set
        MOV     A, reg_acc5     ;if High Word Equal Then Check  Low Word
        SUB     A, reg_acc7
$_Div_Set:
        JBS     STATUS, C
        JMP     $_Div_S_0       ;If Dividend < Divisor, Quotient Add 0.
$_Div_Set_1:
        BS      reg_acc1, 0     ;If Dividend > Divisor, Quotient Add 1.
        MOV     A, reg_acc5     ;Dividend-Divisor, From Low Word To High Word.
        SUB     reg_acc7, A     ;Save Divisor
        JBS     STATUS, C
        DEC     reg_acc8        ;If Low Word < High Word, Next High Word Sub 1.
        MOV     A, reg_acc6
        SUB     reg_acc8, A
$_Div_S_0:
        DJZ     reg_acc         ;If Finish Shift, Set A=1 Exit
        JMP     $_Div_Sub
        MOV     A, reg_acc8     ;Save Result Into User's Register.
        MOV     reg_acc6, A
        MOV     A, reg_acc7
        MOV     reg_acc5, A
        MOV     A, @1           ;Finish Peration ,  A Register Return 1
$_Div_Out:
        ENDM
;
;**********************************************************************;
; Title:        Division 32 bits /24 bits -> 32 bit --24 bits          ;
; Description:  (reg_acc4, reg_acc3, reg_acc2, reg_acc1)/              ;
;               (reg_acc7, reg_acc6, reg_acc5)                         ;
;               ->(reg_acc4, reg_acc3, reg_acc2, reg_acc1)             ;
;               --(reg_acc7, reg_acc6, reg_acc5)                       ;
; Input:        Dividend  reg_acc4 reg_acc3 reg_acc2 reg_acc1          ;
;               Divisor   reg_acc7 reg_acc6 reg_acc5                   ;
; Output:       Result    reg_acc4, reg_acc3 reg_acc2 reg_acc1         ;
;               Remainder reg_acc7 reg_acc6, reg_acc5                  ;
; Variable Register:None                                               ;
; Register Changed: STATUS, ACC, reg_acc(address 0x20), reg_acc8(x028) ;
;                   , reg_acc9(0x29) , reg_acca(0x2a)                  ;
;**********************************************************************;
;
mDIV4_3 MACRO reg_acc4, reg_acc3, reg_acc2, reg_acc1, reg_acc7, reg_acc6, reg_acc5
;
        CLRA
        OR      A, reg_acc7     ;Check Divisor Is Zero
        OR      A, reg_acc6
        OR      A, reg_acc5
        JBC     STATUS, Z
        JMP     $_Div_Out       ;If Divisor Is Zero, A=0，Exit Peration.
        MOV     A, @32          ;Recurrence Cortrol Data
        MOV     reg_acc, A      ;Divisor Is Not Zero, Begin Peration，Then A=1.
        CLR     reg_acc8        ;clear Remainder register
        CLR     reg_acc9
        CLR     reg_acca
$_Div_Sub:
        BC      STATUS, 0       ;Clear c Flag
        RLC     reg_acc1        ;Dividend Left Shift 1Bit
        RLC     reg_acc2
        RLC     reg_acc3
        RLC     reg_acc4
        RLC     reg_acc8
        RLC     reg_acc9
        RLC     reg_acca
        JBC     STATUS, C       ;C Flag Is 1, Quotient Low Bit Set 1
        JMP     $_Div_Set_1
        MOV     A, reg_acc7     ;Check If Dividend > Divisor
        SUB     A, reg_acca     ;Check High Word  Equal
        JBS     STATUS, Z
        JMP     $_Div_Set
        MOV     A, reg_acc6     ;if High Word Equal Then Check  Low Word
        SUB     A, reg_acc9
        JBS     STATUS, Z
        JMP     $_Div_Set
        MOV     A, reg_acc5
        SUB     A, reg_acc8
$_Div_Set:
        JBS     STATUS, C
        JMP     $_Div_S_0       ;If Dividend < Divisor, Quotient Add 0.
$_Div_Set_1:
        BS      reg_acc1, 0     ;If Dividend > Divisor, Quotient Add 1.
        MOV     A, reg_acc5     ;Dividend-Divisor, From Low Word To High Word.
        SUB     reg_acc8, A     ;Save Divisor
        JBS     STATUS, C
        DEC     reg_acc9        ;If Low Word < High Word, Next High Word Sub 1.
        MOV     A, reg_acc6
        SUB     reg_acc9, A
        JBS     STATUS, C
        DEC     reg_acca
        MOV     A, reg_acc7
        SUB     reg_acca, A
$_Div_S_0:
        DJZ     reg_acc         ;If Finish Shift, Set A=1 Exit
        JMP     $_Div_Sub
        MOV     A, reg_acca     ;Save Result Into User's Register.
        MOV     reg_acc7, A
        MOV     A, reg_acc9
        MOV     reg_acc6, A
        MOV     A, reg_acc8
        MOV     reg_acc5, A
        MOV     A, @1           ;Finish Peration, A Register Return 1
$_Div_Out:
        ENDM
;
;**********************************************************************;
; Title:        Division 32 bits /32 bits -> 32 bit --32 bits          ;
; Description:  (reg_acc4, reg_acc3, reg_acc2, reg_acc1)/              ;
;               (reg_acc8, reg_acc7, reg_acc6, reg_acc5)               ;
;               ->(reg_acc4, reg_acc3, reg_acc2, reg_acc1)             ;
;               --(reg_acc8, reg_acc7, reg_acc6, reg_acc5)             ;
; Input:        Dividend  reg_acc4 reg_acc3 reg_acc2 reg_acc1          ;
;               Divisor   reg_acc8 reg_acc7 reg_acc6 reg_acc5          ;
; Output:       Result    reg_acc4 reg_acc3 reg_acc2 reg_acc1          ;
;               Remainder reg_acc8 reg_acc7 reg_acc6, reg_acc5         ;
; Variable Register:None                                               ;
; Register Changed: STATUS, ACC, reg_acc(address 0x20), reg_acc9(x029) ;
;                   , reg_acca(0x2a) , reg_accb(0x2b) , reg_accc(0x2c) ;
;**********************************************************************;
;
mDIV4_4 MACRO reg_acc4, reg_acc3, reg_acc2, reg_acc1, reg_acc8, reg_acc7, reg_acc6, reg_acc5
;
        CLRA
        OR      A, reg_acc8     ;Check Divisor Is Zero
        OR      A, reg_acc7
        OR      A, reg_acc6
        OR      A, reg_acc5
        JBC     STATUS, Z
        JMP     $_Div_Out       ;If Divisor Is Zero, A=0，Exit Peration.
        MOV     A, @32          ;Recurrence Cortrol Data
        MOV     reg_acc, A      ;Divisor Is Not Zero, Begin Peration，Then A=1.
        CLR     reg_acc9        ;clear Remainder register
        CLR     reg_acca
        CLR     reg_accb
        CLR     reg_accc
$_Div_Sub:
        BC      STATUS, C       ;Clear c Flag
        RLC     reg_acc1        ;Dividend Left Shift 1Bit
        RLC     reg_acc2
        RLC     reg_acc3
        RLC     reg_acc4
        RLC     reg_acc9
        RLC     reg_acca
        RLC     reg_accb
        RLC     reg_accc
        MOV     A, reg_acc8     ;Check If Dividend > Divisor
        SUB     A, reg_accc     ;Check High Word  Equal
        JBS     STATUS, Z
        JMP     $_Div_Set
        MOV     A, reg_acc7     ;if High Word Equal Then Check  Low Word
        SUB     A, reg_accb
        JBS     STATUS, Z
        JMP     $_Div_Set
        MOV     A, reg_acc6
        SUB     A, reg_acca
        JBS     STATUS, Z
        JMP     $_Div_Set
        MOV     A, reg_acc5
        SUB     A, reg_acc9
$_Div_Set:
        JBS     STATUS, C
        JMP     $_Div_S_0       ;If Dividend < Divisor, Quotient Add 0.
        BS      reg_acc1, 0     ;If Dividend > Divisor, Quotient Add 1.
        MOV     A, reg_acc5     ;Dividend-Divisor, From Low Word To High Word.
        SUB     reg_acc9, A     ;Save Divisor
        JBS     STATUS, C
        DEC     reg_acca        ;If Low Word < High Word, Next High Word Sub 1.
        MOV     A, reg_acc6
        SUB     reg_acca, A
        JBS     STATUS, C
        DEC     reg_accb
        MOV     A, reg_acc7
        SUB     reg_accb, A
        JBS     STATUS, C
        DEC     reg_accc
        MOV     A, reg_acc8
        SUB     reg_accc, A
$_Div_S_0:
        DJZ     reg_acc         ;If Finish Shift, Set A=1 Exit
        JMP     $_Div_Sub
        MOV     A, reg_accc     ;Save Result Into User's Register.
        MOV     reg_acc8, A
        MOV     A, reg_accb
        MOV     reg_acc7, A
        MOV     A, reg_acca
        MOV     reg_acc6, A
        MOV     A, reg_acc9
        MOV     reg_acc5, A
        MOV     A, @1           ;Finish Peration ,  A Register Return 1
$_Div_Out:
        ENDM
;
;**********************************************************************;
; Title:          (1 byte) * (1 byte) operation                        ;
; Description:    reg_acc2 * reg_acc1 = (reg_acc2, reg_acc1)           ;
; Input:          reg_acc1, reg_acc2                                   ;
; Output:         reg_acc1, reg_acc2                                   ;
; Register change:reg_acc                                              ;
;**********************************************************************;
;
mMUL1_1 MACRO   reg_acc2, reg_acc1
;
        MOV     A, @8
        MOV     reg_acc, A
        MOV     A, reg_acc2
        CLR     reg_acc2
$Mul11_Loop:
        BC      STATUS, C
        JBC     reg_acc1, 0
        ADD     reg_acc2, A
        RRC     reg_acc2
        RRC     reg_acc1
;
        DJZ     reg_acc
        JMP     $Mul11_Loop
        ENDM
;
;**********************************************************************;
; Title:          (1 byte) * (2 bytes) operation                       ;
; Description:    reg_acc3 * (reg_acc2, reg_acc1)                      ;
;                 = (reg_acc3, reg_acc2, reg_acc1)                     ;
; Input:          reg_acc1, reg_acc2, reg_acc3                         ;
; Output:         reg_acc1, reg_acc2, reg_acc3                         ;
; Register change:reg_acc                                              ;
;**********************************************************************;
;
mMUL1_2 MACRO   reg_acc3, reg_acc2, reg_acc1
;
        MOV     A, @16
        MOV     reg_acc, A
        MOV     A, reg_acc3
        CLR     reg_acc3
$Mul12_Loop:
        BC      STATUS, C
        JBC     reg_acc1, 0
        ADD     reg_acc3, A
        RRC     reg_acc3
        RRC     reg_acc2
        RRC     reg_acc1
;
        DJZ     reg_acc
        JMP     $Mul12_Loop
        ENDM
;
;**********************************************************************;
; Title:          (1 byte) * (3 bytes) operation                       ;
; Description:    reg_acc4 * (reg_acc3, reg_acc2, reg_acc1)            ;
;                 = (reg_acc4, reg_acc3, reg_acc2, reg_acc1)           ;
; Input:          reg_acc1, reg_acc2, reg_acc3, reg_acc4               ;
; Output:         reg_acc1, reg_acc2, reg_acc3, reg_acc4               ;
; Register change:reg_acc                                              ;
;**********************************************************************;
;
mMUL1_3 MACRO   reg_acc4, reg_acc3, reg_acc2, reg_acc1
;
        MOV     A, @24
        MOV     reg_acc, A
        MOV     A, reg_acc4
        CLR     reg_acc4
$Mul13_Loop:
        BC      STATUS, C
        JBC     reg_acc1, 0
        ADD     reg_acc4, A
        RRC     reg_acc4
        RRC     reg_acc3
        RRC     reg_acc2
        RRC     reg_acc1
;
        DJZ     reg_acc
        JMP     $Mul13_Loop
        ENDM
;
;**********************************************************************;
; Title:          (1 byte) * (4 bytes) operation                       ;
; Description:    reg_acc5 * (reg_acc4, reg_acc3, reg_acc2, reg_acc1)  ;
;                 = (reg_acc5, reg_acc4, reg_acc3, reg_acc2, reg_acc1) ;
; Input:          reg_acc1, reg_acc2, reg_acc3, reg_acc4, reg_acc5     ;
; Output:         reg_acc1, reg_acc2, reg_acc3, reg_acc4, reg_acc5     ;
; Register change:reg_acc                                              ;
;**********************************************************************;
;
mMUL1_4  MACRO   reg_acc5, reg_acc4, reg_acc3, reg_acc2, reg_acc1
;
        MOV     A, @32
        MOV     reg_acc, A
        MOV     A, reg_acc5
        CLR     reg_acc5
$Mul14_Loop:
        BC      STATUS, C
        JBC     reg_acc1, 0
        ADD     reg_acc5, A
        RRC     reg_acc5
        RRC     reg_acc4
        RRC     reg_acc3
        RRC     reg_acc2
        RRC     reg_acc1
;
        DJZ     reg_acc
        JMP     $Mul14_Loop
        ENDM
;
;**********************************************************************;
; Title:          (2 bytes) * (2 bytes) operation                      ;
; Description:    (reg_acc4, reg_acc3) * (reg_acc2, reg_acc1)          ;
;                 = (reg_acc4, reg_acc3, reg_acc2, reg_acc1)           ;
; Input:          reg_acc1, reg_acc2, reg_acc3, reg_acc4               ;
; Output:         reg_acc1, reg_acc2, reg_acc3, reg_acc4               ;
; Register change:reg_acc, reg_acc5, reg_acc6                          ;
;**********************************************************************;
;
mMUL2_2 MACRO   reg_acc4, reg_acc3, reg_acc2, reg_acc1
;
        MOV     A, @16
        MOV     reg_acc, A
        MOV     A, reg_acc4
        MOV     reg_acc6, A
        MOV     A, reg_acc3
        MOV     reg_acc5, A
        CLR     reg_acc3
        CLR     reg_acc4
$Mul22_Loop:
        BC      STATUS, C
        JBS     reg_acc1, 0
        JMP     $Mul22_Rs
        MOV     A, reg_acc5
        ADD     reg_acc3, A
;--------------------------------------
        MOV     A, reg_acc4
        JBC     STATUS, C
        ADD     A, @1
        RLC     reg_acc
        ADD     A, reg_acc6
        MOV     reg_acc4, A
        JBC     STATUS, C
        BS      reg_acc, 0
        RRC     reg_acc
$Mul22_Rs:
        RRC     reg_acc4
        RRC     reg_acc3
        RRC     reg_acc2
        RRC     reg_acc1
;
        BC      reg_acc, 7
        DJZ     reg_acc
        JMP     $Mul22_Loop
        ENDM
;
;**********************************************************************;
; Title:          (2 bytes) * (3 bytes) operation                      ;
; Description:    (reg_acc5, reg_acc4) * (reg_acc3, reg_acc2, reg_acc1);
;                 = (reg_acc5, reg_acc4, reg_acc3, reg_acc2, reg_acc1) ;
; Input:          reg_acc1, reg_acc2, reg_acc3, reg_acc4, reg_acc5     ;
; Output:         reg_acc1, reg_acc2, reg_acc3, reg_acc4, reg_acc5     ;
; Register change:reg_acc, reg_acc6, reg_acc7                          ;
;**********************************************************************;
;
mMUL2_3 MACRO   reg_acc5, reg_acc4, reg_acc3, reg_acc2, reg_acc1
;
        MOV     A, @24
        MOV     reg_acc, A
        MOV     A, reg_acc5
        MOV     reg_acc7, A
        MOV     A, reg_acc4
        MOV     reg_acc6, A
        CLR     reg_acc4
        CLR     reg_acc5
$Mul23_Loop:
        BC      STATUS, C
        JBS     reg_acc1, 0
        JMP     $Mul23_Rs
        MOV     A, reg_acc6
        ADD     reg_acc4, A
;--------------------------------------
        MOV     A, reg_acc5
        JBC     STATUS, C
        ADD     A, @1
        RLC     reg_acc
        ADD     A, reg_acc7
        MOV     reg_acc5, A
        JBC     STATUS, C
        BS      reg_acc, 0
        RRC     reg_acc
$Mul23_Rs:
        RRC     reg_acc5
        RRC     reg_acc4
        RRC     reg_acc3
        RRC     reg_acc2
        RRC     reg_acc1
;
        BC      reg_acc, 7
        DJZ     reg_acc
        JMP     $Mul23_Loop
        ENDM
;
;**********************************************************************;
; Title:          (2 bytes) * (4 bytes) operation                      ;
; Description:    (reg_acc6, reg_acc5) * (reg_acc4, reg_acc3, reg_acc2 ;
;                 , reg_acc1) = (reg_acc6, reg_acc5, reg_acc4, reg_acc3;
;                 , reg_acc2, reg_acc1)                                ;
; Input:          reg_acc1, reg_acc2, reg_acc3, reg_acc4, reg_acc5,    ;
;                 reg_acc6                                             ;
; Output:         reg_acc1, reg_acc2, reg_acc3, reg_acc4, reg_acc5,    ;
;                 reg_acc6                                             ;
; Register change:reg_acc, reg_acc7, reg_acc8                          ;
;**********************************************************************;
;
mMUL2_4 MACRO   reg_acc6, reg_acc5, reg_acc4, reg_acc3, reg_acc2, reg_acc1
;
        MOV     A, @32
        MOV     reg_acc, A
        MOV     A, reg_acc6
        MOV     reg_acc8, A
        MOV     A, reg_acc5
        MOV     reg_acc7, A
        CLR     reg_acc5
        CLR     reg_acc6
$Mul24_Loop:
        BC      STATUS, C
        JBS     reg_acc1, 0
        JMP     $Mul24_Rs
        MOV     A, reg_acc7
        ADD     reg_acc5, A
;--------------------------------------
        MOV     A, reg_acc6
        JBC     STATUS, C
        ADD     A, @1
        RLC     reg_acc
        ADD     A, reg_acc8
        MOV     reg_acc6, A
        JBC     STATUS, C
        BS      reg_acc, 0
        RRC     reg_acc
$Mul24_Rs:
        RRC     reg_acc6
        RRC     reg_acc5
        RRC     reg_acc4
        RRC     reg_acc3
        RRC     reg_acc2
        RRC     reg_acc1
;
        BC      reg_acc, 7
        DJZ     reg_acc
        JMP     $Mul24_Loop
        ENDM
;
;**********************************************************************;
; Title:          (3 bytes) * (3 bytes) operation                      ;
; Description:    (reg_acc6, reg_acc5, reg_acc4) * (reg_acc3, reg_acc2 ;
;                 , reg_acc1) = (reg_acc6, reg_acc5, reg_acc4, reg_acc3;
;                 , reg_acc2, reg_acc1)                                ;
; Input:          reg_acc1, reg_acc2, reg_acc3, reg_acc4, reg_acc5     ;
;                 , reg_acc6                                           ;
; Output:         reg_acc1, reg_acc2, reg_acc3, reg_acc4, reg_acc5     ;
;                 , reg_acc6                                           ;
; Register change:reg_acc, reg_acc7, reg_acc8, reg_acc9                ;
;**********************************************************************;
;
mMUL3_3 MACRO   reg_acc6, reg_acc5, reg_acc4, reg_acc3, reg_acc2, reg_acc1
;
        MOV     A, @24
        MOV     reg_acc, A
        MOV     A, reg_acc4
        MOV     reg_acc7, A
        MOV     A, reg_acc5
        MOV     reg_acc8, A
        MOV     A, reg_acc6
        MOV     reg_acc9, A
        CLR     reg_acc4
        CLR     reg_acc5
        CLR     reg_acc6
$Mul33_Loop:
        BC      STATUS, C
        JBS     reg_acc1, 0
        JMP     $Mul33_Rs
        MOV     A, reg_acc7
        ADD     reg_acc4, A
;--------------------------------------
        MOV     A, reg_acc5
        JBC     STATUS, C
        ADD     A, @1
        RLC     reg_acc
        ADD     A, reg_acc8
        MOV     reg_acc5, A
        JBC     STATUS, C
        BS      reg_acc, 0
        RRC     reg_acc
;--------------------------------------
        MOV     A, reg_acc6
        JBC     STATUS, C
        ADD     A, @1
        RLC     reg_acc
        ADD     A, reg_acc9
        MOV     reg_acc6, A
        JBC     STATUS, C
        BS      reg_acc, 0
        RRC     reg_acc
$Mul33_Rs:
        RRC     reg_acc6
        RRC     reg_acc5
        RRC     reg_acc4
        RRC     reg_acc3
        RRC     reg_acc2
        RRC     reg_acc1
;
        BC      reg_acc, 7
        DJZ     reg_acc
        JMP     $Mul33_Loop
        ENDM
;
;**********************************************************************;
; Title:          (3 bytes) * (4 bytes) operation                      ;
; Description:    (reg_acc7, reg_acc6, reg_acc5) * (reg_acc4, reg_acc3 ;
;                 , reg_acc2, reg_acc1) = (reg_acc7, reg_acc6, reg_acc5;
;                 , reg_acc4, reg_acc3, reg_acc2, reg_acc1)            ;
; Input:          reg_acc1, reg_acc2, reg_acc3, reg_acc4, reg_acc5     ;
;                 , reg_acc6, reg_acc7                                 ;
; Output:         reg_acc1, reg_acc2, reg_acc3, reg_acc4, reg_acc5     ;
;                 , reg_acc6, reg_acc7                                 ;
; Register change:reg_acc, reg_acc8, reg_acc9, reg_acca                ;
;**********************************************************************;
;
mMUL3_4 MACRO   reg_acc7, reg_acc6, reg_acc5, reg_acc4, reg_acc3, reg_acc2, reg_acc1
;
        MOV     A, @32
        MOV     reg_acc, A
        MOV     A, reg_acc5
        MOV     reg_acc8, A
        MOV     A, reg_acc6
        MOV     reg_acc9, A
        MOV     A, reg_acc7
        MOV     reg_acca, A
        CLR     reg_acc5
        CLR     reg_acc6
        CLR     reg_acc7
$Mul34_Loop:
        BC      STATUS, C
        JBS     reg_acc1, 0
        JMP     $Mul34_Rs
        MOV     A, reg_acc8
        ADD     reg_acc5, A
;--------------------------------------
        MOV     A, reg_acc6
        JBC     STATUS, C
        ADD     A, @1
        RLC     reg_acc
        ADD     A, reg_acc9
        MOV     reg_acc6, A
        JBC     STATUS, C
        BS      reg_acc, 0
        RRC     reg_acc
;--------------------------------------
        MOV     A, reg_acc7
        JBC     STATUS, C
        ADD     A, @1
        RLC     reg_acc
        ADD     A, reg_acca
        MOV     reg_acc7, A
        JBC     STATUS, C
        BS      reg_acc, 0
        RRC     reg_acc
$Mul34_Rs:
        RRC     reg_acc7
        RRC     reg_acc6
        RRC     reg_acc5
        RRC     reg_acc4
        RRC     reg_acc3
        RRC     reg_acc2
        RRC     reg_acc1
;
        BC      reg_acc, 7
        DJZ     reg_acc
        JMP     $Mul34_Loop
        ENDM
;
;**********************************************************************;
; Title:          (4 bytes) * (4 bytes) operation                      ;
; Description:    (reg_acc8, reg_acc7, reg_acc6, reg_acc5) *           ;
;                 (reg_acc4, reg_acc3, reg_acc2, reg_acc1)             ;
;                 = (reg_acc8, reg_acc7, reg_acc6, reg_acc5, reg_acc4  ;
;                 , reg_acc3, reg_acc2, reg_acc1)                      ;
; Input:          reg_acc1, reg_acc2, reg_acc3, reg_acc4,              ;
;                 reg_acc5, reg_acc6, reg_acc7, reg_acc8               ;
; Output:         reg_acc1, reg_acc2, reg_acc3, reg_acc4,              ;
;                 reg_acc5, reg_acc6, reg_acc7, reg_acc8               ;
; Register change:reg_acc, reg_acc9, reg_acca, reg_accb, reg_accc      ;
;**********************************************************************;
;
mMUL4_4 MACRO   reg_acc8, reg_acc7, reg_acc6, reg_acc5, reg_acc4, reg_acc3, reg_acc2, reg_acc1
;
        MOV     A, @32
        MOV     reg_acc, A
        MOV     A, reg_acc5
        MOV     reg_acc9, A
        MOV     A, reg_acc6
        MOV     reg_acca, A
        MOV     A, reg_acc7
        MOV     reg_accb, A
        MOV     A, reg_acc8
        MOV     reg_accc, A
        CLR     reg_acc5
        CLR     reg_acc6
        CLR     reg_acc7
        CLR     reg_acc8
$Mul44_Loop:
        BC      STATUS, C
        JBS     reg_acc1, 0
        JMP     $Mul44_Rs
        MOV     A, reg_acc9
        ADD     reg_acc5, A
;--------------------------------------
        MOV     A, reg_acc6
        JBC     STATUS, C
        ADD     A, @1
        RLC     reg_acc
        ADD     A, reg_acca
        MOV     reg_acc6, A
        JBC     STATUS, C
        BS      reg_acc, 0
        RRC     reg_acc
;--------------------------------------
        MOV     A, reg_acc7
        JBC     STATUS, C
        ADD     A, @1
        RLC     reg_acc
        ADD     A, reg_accb
        MOV     reg_acc7, A
        JBC     STATUS, C
        BS      reg_acc, 0
        RRC     reg_acc
;--------------------------------------
        MOV     A, reg_acc8
        JBC     STATUS, C
        ADD     A, @1
        RLC     reg_acc
        ADD     A, reg_accc
        MOV     reg_acc8, A
        JBC     STATUS, C
        BS      reg_acc, 0
        RRC     reg_acc
$Mul44_Rs:
        RRC     reg_acc8
        RRC     reg_acc7
        RRC     reg_acc6
        RRC     reg_acc5
        RRC     reg_acc4
        RRC     reg_acc3
        RRC     reg_acc2
        RRC     reg_acc1
;
        BC      reg_acc, 7
        DJZ     reg_acc
        JMP     $Mul44_Loop
        ENDM



;*****************************************************************
;Function:    generat random data
;Input:       @banksel,@address,@length
;Output:      rang by address which is the lowest address
;description: used common register temp,temp1,temp2 for operation
;             rand address must be in the same bank
;             TEMP:  Operate Data TEMP
;             TEMP1:
;             TEMP2:
;*****************************************************************
RAND_FUCTION MACRO @BankSel,Address,@length
	MOV         TEMP,A
	BANK        @BankSel
	MOV         A,Address
	ADD         TEMP,A        ; save latest data as current seed

	CLR         RSR
$_RAND_SEED_LOOP1:
	MOV         A,R0
	ADD         TEMP,A        ; seed

	RLC         TEMP          ; x*y+1 MOD z
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

	INC         RSR
	MOV         A,RSR
	AND         A,@0X40         ; adding form 0x00 to bank 0
	XOR         A,@0X40
	JBS         STATUS,Z
	JMP         $_RAND_SEED_LOOP1
	MOV         A,R0
	ADD         TEMP,A          ;next seed

	MOV         A,@length
	MOV         TEMP1,A
	MOV         A,@Address
	MOV         TEMP2,A
	MOV         RSR,A
	BANK        @BankSel
	MOV         A,RSR
	MOV         TEMP2,A       ; save address base
	MESSAGE     "adding form 0x00 to bank 0"

$_RAND_DATA_LOOP1:
	MOV         A,TEMP2
	MOV         RSR,A
	MOV         A,TEMP
	MOV         R0,A

	RLC         TEMP          ; X*Y+1 MOD Z
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

	INC         TEMP2
	DJZ         TEMP1
	JMP         $_RAND_DATA_LOOP1:
	NOP

ENDM
