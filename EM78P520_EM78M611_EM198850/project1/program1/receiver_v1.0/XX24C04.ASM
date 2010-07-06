;**********************************************************************;
; Tilte: Em78x447x I2C FOR AT24C01 Function macro Code                 ;
; Description:                                                         ;
;     1."mTDATA" 写入数据的宏，可以连续写多个字节                      ;
;     2."mRDATA" 读出数据的宏，可以连续读多个字节                      ;
; Company: Elan Corp. Inc                                              ;
; Author:  youfang.bao                                                 ;
; Date:    7/1/2004                                                    ;
; Version: v1.0                                                        ;
;**********************************************************************;

;======================================================================
include "XX24C04.H"


;**********************************************************************;
; 启动信号子程序
;
        IFNDEF  mro_tt1
        mro_tt1 EQU 1
BSTART:
        IOR     P6
        AND     A, @0b00111111  ; I2C_CLK,I2C_DAT处于输出状态
        IOW     P6
        BS      P6, I2C_DAT     ; I2C_CLK,I2C_DAT处于高电平状态
        NOP                     ; 空操作延时
        NOP
        BS      P6, I2C_CLK
        NOP
        NOP
        BC      P6, I2C_DAT     ; I2C_CLK高电平时，I2C_DAT下跳，I2C总线启动
        NOP
        NOP
        BC      P6, I2C_CLK
;
        RET
        ENDIF

;**********************************************************************;
; 发送停止信号子程序
;
        IFNDEF  mro_tt2
        mro_tt2 EQU 1
BSTOP:
        IOR     P6
        AND     A, @0b00111111  ; I2C_CLK,I2C_DAT处于输出状态
        IOW     P6
        BC      P6, I2C_DAT
        NOP
        NOP
        BS      P6, I2C_CLK
        NOP
        NOP
        BS      P6, I2C_DAT     ; I2C_CLK高电平时，I2C_DAT上跳，E2C总线停止
;
        RET
        ENDIF

;**********************************************************************;
;接收数据子程序，将接收数据放入I2C_RXBUF中
;
mI2C_RX MACRO
        IFNDEF  mro_tt3
        mro_tt3 EQU 1
;
        jmp	 mI2C_RX_End
I2C_RX:
        MOV     A, @8
        MOV     I2C_COUNT, A
        CLR     I2C_RXBUF       ; 接收数据寄存器I2C_RXBUF清零
        BC      R3, 0
;
        IOR     P6
        AND     A, @0b00111111
        OR      A, @0b10000000  ; I2C_CLK处于输出状态，I2C_DAT处于输入状态
        IOW     P6
;
        BS      P6, I2C_DAT     ; I2C_DAT拉高，为输入作准备
I2C_RX_LP:
        RLC     I2C_RXBUF       ; 依次移位处理
;
        BS      P6, I2C_CLK     ; I2C_CLK上跳，I2C传送数据
;
        JBC     P6, I2C_DAT
        BS      I2C_RXBUF, 0
        NOP
        NOP
;
        BC      P6, I2C_CLK     ; I2C_CLK恢复低电平
;
        DJZ     I2C_COUNT       ; 8 位结束否？
        JMP     I2C_RX_LP       ; 8 位未结束，继续
;
        RET
mI2C_RX_End:
;
        ENDIF
        ENDM
;**********************************************************************;
;发送数据子程序，将I2C_TXBUF中的数据发给I2C
;
mI2C_TX MACRO
        IFNDEF  mro_tt4
        mro_tt4 EQU 1
;
        jmp	 mI2C_TX_End
I2C_TX:
        MOV     A, @8           ; 一字节8位
        MOV     I2C_COUNT, A
;
        IOR     P6
        AND     A, @0b00111111  ; I2C_CLK、I2C_DAT处于输出状态
        IOW     P6
I2C_TX_LP:
        JBS     I2C_TXBUF, 7
        JMP     I2C_BIt0
        BS      P6, I2C_DAT
        JMP     I2C_CLK1
I2C_BIt0:
        BC      P6, I2C_DAT
I2C_CLK1:
        NOP
        BS      P6, I2C_CLK     ; CLK上跳，I2C开始传送数据
        NOP
        NOP
        NOP
        NOP
        BC      P6, I2C_CLK     ; CLK恢复低电平
;
        RLC     I2C_TXBUF
        DJZ     I2C_COUNT
        JMP     I2C_TX_LP
;
        BS      P6, I2C_DAT     ; 发发送应答信号     
        NOP
        NOP
        BS      P6, I2C_CLK
        NOP
        NOP
        NOP
        NOP
        BC      P6, I2C_CLK
;
        RET
mI2C_TX_End:
;
        ENDIF
        ENDM
;**********************************************************************;
; Program name:     mTData  m, Address, I2C_DATA0                      ;
; Description:      将24C01以某一地址开始的EEPROM中的内容读到以        ;
;                   I2C_DATA0开始的内存中去                            ;
; Input:            Address, 要写入到24C01数据的首地址                 ;
; Output:           I2C_DATA0, 存放要写入的数据的首地址                ;
; Register Changed: STATUS, I2C_TXBUF, I2C_RXBUF, I2C_COUNT, I2C_DATA0 ;
;**********************************************************************;
;将I2C_DATA0的内容写到24C01某一地址的EEPROM中去
;
mWBYTE  Macro   Address, I2C_DATA0
;
        mI2C_TX
;
        CALL    BSTART
;
        MOV     A, @0b10100000  ; 发送命令字节（10100000B）
        MOV     I2C_TXBUF, A
        CALL    I2C_TX
;
        MOV     A, @Address     ; 发送24C01首地址
        MOV     I2C_TXBUF, A
        CALL    I2C_TX
;
        MOV     A, I2C_DATA0
        MOV     I2C_TXBUF, A
        CALL    I2C_TX
;
        CALL    BSTOP
;
        ENDM
;**********************************************************************;
; Program name:     mRData  m, Address, I2C_DATA0                      ;
; Description:      将24C01以某一地址的EEPROM中的内容读到以,           ;
;                   I2C_DATA0内存中去                                  ;
; Input:            Address, 要从24C01读取的数据的首地址               ;
; Output:           I2C_DATA0, 存放在MCU内存的首地址                   ;
; Register Changed: STATUS, I2C_TXBUF, I2C_RXBUF, I2C_COUNT, I2C_DATA0 ;
;**********************************************************************;
;将24C01以某一地址的EEPROM中的内容读到I2C_DATA0内存中去
;
mRBYTE  Macro   Address, I2C_DATA0
;
        mI2C_TX
        mI2C_RX
;
        CALL    BSTART
;
        MOV     A, @0b10100000  ; 发送命令字节（10100000B）
        MOV     I2C_TXBUF, A
        CALL    I2C_TX
;
        MOV     A, @Address     ; 发送24C01首地址
        MOV     I2C_TXBUF, A
        CALL    I2C_TX
;
        CALL    BSTART
;
        MOV     A, @0b10100001  ; 接收命令字节（10100001B）
        MOV     I2C_TXBUF, A
        CALL    I2C_TX
        NOP
        NOP
        NOP
;
        CALL    I2C_RX
        MOV     A, I2C_RXBUF
        MOV     I2C_DATA0, A
;
        CALL    BSTOP
;
        ENDM
;
;**********************************************************************;
; Program name:     mTData  m, Address, I2C_DATA0                      ;
; Description:      将24C01以某一地址开始的EEPROM中的内容读到以        ;
;                   I2C_DATA0开始的内存中去                            ;
; Input:            m, 要写入数据的地址总数                            ;
;                   Address, 要写入到24C01数据的首地址                 ;
; Output:           I2C_DATA0, 存放要写入的数据的首地址                ;
; Register Changed: STATUS, I2C_TXBUF, I2C_RXBUF,                      ;
;                   I2C_COUNT, I2C_BYTES, I2C_DATA0                    ;
;**********************************************************************;
;将I2C_DATA0开始的内容写到24C01以某一地址开始的EEPROM中去
;
mWPAGE  Macro   m, Address, I2C_DATA0
;
        mI2C_TX
;
        CALL    BSTART          ; 发送启动信号
;
        MOV     A, @0b10100000  ; 发送命令字节（10100000B）
        MOV     I2C_TXBUF, A
        CALL    I2C_TX
;
        MOV     A, @Address     ; 发送24C01首地址
        MOV     I2C_TXBUF, A
        CALL    I2C_TX
;
        MOV     A, @m
        MOV     I2C_BYTES, A
        MOV     A, @I2C_DATA0   ; 定义对I2C_DATA0字节间接寻址
        MOV     R4, A
I2C_TLP:
        MOV     A, R0
        MOV     I2C_TXBUF, A
        CALL    I2C_TX
        INC     R4
        DJZ     I2C_BYTES
        JMP     I2C_TLP
;
        CALL    BSTOP           ; 发送停止信号
;
        ENDM
;**********************************************************************;
; Program name:     mRData  m, Address, I2C_DATA0                      ;
; Description:      将24C01以某一地址开始的EEPROM中的内容读到以        ;
;                   I2C_DATA0开始的内存中去                            ;
; Input:            m, 要读出数据的地址总数                            ;
;                   Address, 要从24C01读取的数据的首地址               ;
; Output:           I2C_DATA0, 存放在MCU内存的首地址                   ;
; Register Changed: STATUS, I2C_TXBUF, I2C_RXBUF,                      ;
;                   I2C_COUNT, I2C_BYTES, I2C_DATA0                    ;
;**********************************************************************;
;将24C01以某一地址开始的EEPROM中的内容读到以I2C_DATA0开始的内存中去
;
mRPAGE  Macro   m, Address, I2C_DATA0
;
        mI2C_TX
        mI2C_RX
		
        CALL    BSTART          ; 发送启动信号
;
        MOV     A, @0b10100000  ; 发送命令字节（10100000B）
        MOV     I2C_TXBUF, A
        CALL    I2C_TX
;
        MOV     A, @Address     ; 发送24C01首地址
        MOV     I2C_TXBUF, A
        CALL    I2C_TX
;
        CALL    BSTART          ; 发送启动信号
;
        MOV     A, @0b10100001  ; 接收命令字节（10100001B）
        MOV     I2C_TXBUF, A
        CALL    I2C_TX
;
        MOV     A, @m
        MOV     I2C_BYTES, A
        MOV     A, @I2C_DATA0   ; 定义对I2C_DATA0字节间接寻址
        MOV     R4, A
I2C_RLP:
        CALL    I2C_RX
;
        MOV     A, I2C_BYTES
        XOR     A, @1
        JBC     STATUS, Z
        JMP     I2C_RXBB
I2C_ACK:
        IOR     P6
        AND     A, @0b00111111  ; I2C_CLK,I2C_DAT处于输出状态
        IOW     P6
        BC      P6, I2C_DAT
        NOP                     ; 空操作延时
        NOP
        BS      P6, I2C_CLK
        NOP                     ; 空操作延时
        NOP
        NOP
        NOP
        BC      P6, I2C_CLK     ; I2C_CLK高电平时，I2C_DAT上跳，E2C总线停止
I2C_RXBB:
        MOV     A, I2C_RXBUF
        MOV     R0, A
        INC     R4
        DJZ     I2C_BYTES
        JMP     I2C_RLP
;
        CALL    BSTOP
;
        ENDM

