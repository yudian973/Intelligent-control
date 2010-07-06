;***********************************************************************;
; Tilte: Em78x510x spi FOR AT93C46 Function macro Code                  ;
; Description:库中共包括以下七个功能宏                                  ;
;     1."mEWEN"  允许写/擦数据的宏。                                    ;
;     2."mEWDS"  禁止写/擦数据的宏 。                                   ;
;     3."mWRITE" 写如数据的宏，可以连续写多个字节，且写入数据可以不同   ;
;     4."mREAD"  读数据的宏，可以连续读多个字节。                       ;
;     5."mERASE" 擦除数据的宏，可以擦除多个连续字节。                   ;
;     6."mERAL"  擦除所有数据的宏，所有地址的内容都为"FF"。             ;
;     7."mWRAL"  把所有地址写入同以数据的宏。                           ;
; Company: Elan Corp. Inc                                               ;
; Author:  yu.wei                                                     ;
; Date:    2009.3.20                                                    ;
; Version: v1.0                                                         ;
; 说明：在使用此库时先要定义好作为通讯口的定义。                        ;
;***********************************************************************
;说明：
;    1. 本程式所写及读的数据都为8bit;
;------------------------------------------------------
; spi          Port Used For 93C46 Control.
; cs           Port Pin Tied To cs On 93C46.
; sk           Port Pin Tied To sk On 93C46.
; di           Port Pin Tied To di On 93C46.
; DO           Port Pin Tied To DO On 93C46.
; r_acc1     This Register Contains The 2 Bit 93C46
;              Command Is The High 2 Bit Positions And
;              memory Address In The Lower 6.
;--------------------------------------------------
;Instruction   SB    Op Code     Address               Data
;                               x8       x16       x8       x16
;    READ       1      10 	A6 - A0  A5 - A0
;    EWEN       1 	   00     11XXXXX  11XXXX
;    ERASE      1      11     A6 - A0  A5 - A0
;    WRITE      1 	   01 	A6 - A0  A5 - A0   D7 - D0  D15- D0
;    ERAL       1 	   00 	10XXXXX  10XXXX
;    WRAL       1 	   00 	01XXXXX  01XXXX    D7 - D0  D15- D0
;    EWDS       1 	   00 	00XXXXX  00XXXX
;=================================================================================

XX93C46_For_EM78P520.ASM       EQU        XX93C46_For_EM78P510.ASM
include "XX93C46_For_EM78P520.H"

ifndef EM78CtrlIns.H
include "EM78CtrlIns.H"
endif
;--------------------------------------------------

        ORG     0X1000
;***********************************************************************;
;Program name: mEWEN m,spi    m 数据的位数（8BIT或16BIT）               ;
;Description:  允许写/擦除操作的指令写入                                ;
;Input:        选择数据类型 m==8或m==16  m代表数据位数                  ;
;              定义好spi及其cs,sk,di,DO位                               ;
;Output:       使能写/擦除操作                                          ;
;Variable Register:None                                                 ;
;Register Changed: STATUS,ACC ,r_acc1(0X21) , r_acc2(0X22)          ;
;***********************************************************************;
mEWEN   MACRO
        LCALL   Start_Bit       ;load start bit
        MOV     A,@ewen         ;enable erase/write
        MOV     r_acc1,A
        ;
        MOV     A,@9
        ;
        LCALL    Rl_Comd         ;finish enable erase/write
        BC      AT93C46_CS/8,AT93C46_CS%8          ;load end bit
        BC      SPI_CLK/8,SPI_CLK%8
        BC      SPI_MOSI/8,SPI_MOSI%8
        ENDM
;
;***********************************************************************;
;Program name:  mEWDS m,spi    m 数据的位数（8BIT或16BIT）              ;
;Description:   禁止写/擦除操作的指令写入                               ;
;Input:         选择数据类型 m==8或m==16  m代表数据位数；               ;
;               定义好spi及其cs,sk,di,DO位                              ;
;Output:        禁止写/擦除操作                                         ;
;Variable Register:None                                                 ;
;Register Changed: STATUS,ACC ,r_acc1(0X21) , r_acc2(0X22)          ;
;***********************************************************************;
mEWDS   MACRO
        LCALL    Start_Bit       ;写入起始位
        MOV      A,@ewds         ;禁止写和擦除动作
        MOV      r_acc1,A
        ;
        MOV      A,@9
        ;
        LCALL    Rl_Comd
        BC       AT93C46_CS/8,AT93C46_CS%8
        BC       SPI_CLK/8,SPI_CLK%8
        BC       SPI_MOSI/8,SPI_MOSI%8          ;完成使能写操作指令的写入
        ENDM
;
;***********************************************************************;
;Program name:  mWRITE m,DataAddressInEEPROM,k,DataAddressInMCU,spi                            ;
;Description:   指定数据块写入到指定地址                                ;
;Input:         m 选择数据类型 m==8或16                                 ;
;               DataAddressInEEPROM  内容为要写入数据的最低位地址(93C46的地址）      ;
;               k 要写入数据的地址总数                                  ;
;               DataAddressInMCU  内容为存放数据的最低位地址（mCU的地址）         ;
;               spi  选择PORT作为通信口，要定义好cs,sk,di,DO相关位      ;
;Output:        写入指定数据块到指定地址块                              ;
;Variable Register:None                                                 ;
;Register Changed: STATUS,ACC ,
;                  r_acc1(0X21) ,
;                  r_acc2(0X22),         ;
;                  r_acc3(0X23)                                       ;
;***********************************************************************;
mWRITE  MACRO   DataAddressInEEPROM,@BankSel,DataAddressInMCU,@k
        BANK    @BankSel
        MOV     A,DataAddressInMCU    ;写入数据存放的最低地址为0X24（mCU的地址）
        MOV     R4,A                   ;存放数据的间接地址
        MOV     A,@k
        MOV     r_acc3,A               ;写入93C46的字节数
$Write_Data:
        LCALL    Start_Bit             ;写入起始位
       ;
        BC      STATUS,C
        RRCA    DataAddressInEEPROM
        ;
        OR      A,@write
        MOV     r_acc1,A               ;高二位为写命令，低六位为地址
        MOV     A,@8                   ;向93C46写一个字节，控制数
        LCALL    Rl_Comd               ;写入指令“写”和要写入数据的地址
       ;
        BC      SPI_CLK/8,SPI_CLK%8
        JBS     DataAddressInEEPROM,0        ;写入8BIT模式时的地址最低位
        BC      SPI_MOSI/8,SPI_MOSI%8
        JBC     DataAddressInEEPROM,0
        BS      SPI_MOSI/8,SPI_MOSI%8
        JMP     $+1
        BS      SPI_CLK/8,SPI_CLK%8          ;以上为写入OP和ADDRESS
        ;
        INC     DataAddressInEEPROM
$Data_H_L:
        MOV     A,R0
        MOV     r_acc1,A      ;装入要写入的数据
        INC     R4
        MOV     A,@8
        LCALL    Rl_Comd         ;写入8BIT数据
       ;
        JMP     $+1
       ;
        BC      AT93C46_CS/8,AT93C46_CS%8
        BC      SPI_CLK/8,SPI_CLK%8          ;数据写完，写结束位
        ;BC      AT93C46_CS/8,AT93C46_CS%8
        BC      SPI_MOSI/8,SPI_MOSI%8
        JMP     $+1
        BS      SPI_CLK/8,SPI_CLK%8
        BS      AT93C46_CS/8,AT93C46_CS%8          ;完成结束位的写入
        JBS     SPI_MISO/8,SPI_MISO%8
        JMP     $-1
        BC      AT93C46_CS/8,AT93C46_CS%8
        DJZ     r_acc3        ;多字节写入控制
        JMP     $Write_Data
        ENDM
;
;***********************************************************************;
;Program name:  mREAD m,DataAddressInEEPROM,k,DataAddressInMCU,spi                             ;
;Description:   从指定地址块（93C46）读出数据到指定地址块(CPU)          ;
;Input:         m 选择数据类型 m==8或16                                 ;
;               DataAddressInEEPROM  内容为要读出数据的最低位地址(93C46的地址）      ;
;               k 要写入数据的地址总数                                  ;
;               DataAddressInMCU  内容为存放数据的最低位地址（mCU的地址）         ;
;               spi  选择PORT作为通信口，要定义好cs,sk,di,DO相关位      ;
;Output:        指定地址读出指定数据块                                  ;
;Variable Register:None                                                 ;
;Register Changed: STATUS,ACC ,
;                  r_acc1(0X21) ,
;                  r_acc2(0X22),         ;
;                  r_acc3(0X23)                                       ;
;***********************************************************************;
mREAD   MACRO   DataAddressInEEPROM,@BankSel,DataAddressInMCU,@k
        BANK    @BankSel
        MOV     A,DataAddressInMCU              ;写入数据存放的最低地址（mCU的地址）     ;
        MOV     R4,A
        MOV     A,@k
        MOV     r_acc3,A
$Write_Data:
        LCALL    Start_Bit       ;写入起始位
       ;
        RRCA    DataAddressInEEPROM
        ;
        OR      A,@READ
        MOV     r_acc1,A      ;高二位为写命令，低六位为地址
        MOV     A,@8            ;向93C46写一个字节，控制数
        LCALL    Rl_Comd         ;写入指令“读”和要写入数据的地址
       ;
        BC      SPI_CLK/8,SPI_CLK%8
        JBS     DataAddressInEEPROM,0        ;写入8BIT模式时的地址最低位
        BC      SPI_MOSI/8,SPI_MOSI%8
        JBC     DataAddressInEEPROM,0
        BS      SPI_MOSI/8,SPI_MOSI%8
        JMP     $+1
        BS      SPI_CLK/8,SPI_CLK%8
       ;
        INC     DataAddressInEEPROM          ;地址加1
        BC      SPI_MOSI/8,SPI_MOSI%8
        JMP     $+1
        BC      SPI_CLK/8,SPI_CLK%8
        JMP     $+1
        JMP     $+1
        BS      SPI_CLK/8,SPI_CLK%8

$Read_Data1:
        MOV     A,@8
        MOV     r_acc2,A
$Read_Data2:
        BC      SPI_CLK/8,SPI_CLK%8
        NOP
        NOP
        JBC     SPI_MISO/8,SPI_MISO%8
        BS      STATUS,C
        JBS     SPI_MISO/8,SPI_MISO%8
        BC      STATUS,C
        RLC     R0
        BS      SPI_CLK/8,SPI_CLK%8
        JMP     $+1
        DJZ     r_acc2
        JMP     $Read_Data2
        INC     R4
        ;
        NOP
        ;
        BC      AT93C46_CS/8,AT93C46_CS%8
        DJZ     r_acc3
        JMP     $Write_Data
        ENDM
;
;***********************************************************************;
;Program name:  mERASE m,DataAddressInEEPROM,k,spi                                   ;
;Description:   从指定地址块擦除数据                                    ;
;Input:         m 选择数据类型 m==8或16                                 ;
;               DataAddressInEEPROM 内容为要擦除数据的最低位地址(93C46的地址）       ;
;               k 要擦除数据的地址总数                                  ;
;               spi    选择PORT作为通信口，要定义好cs,sk,di,DO相关位    ;
;Output:        指定地址块的数据被擦除                                  ;
;Variable Register:None                                                 ;
;Register Changed: STATUS,ACC ,
;                  r_acc1(0X21) ,
;                  r_acc2(0X22),         ;
;                  r_acc3(0X23)                                       ;
;***********************************************************************;
mERASE  MACRO    DataAddressInEEPROM,k
        MOV     A,@k
        MOV     r_acc3,A      ;写入93C46的字节数
$Write_Data:
        LCALL    Start_Bit       ;写入起始位
       ;
        RRCA    DataAddressInEEPROM
       ;
        OR      A,@ERASE
        MOV     r_acc1,A      ;高二位为写命令，低六位为地址
        MOV     A,@8            ;向93C46写一个字节，控制数
        LCALL    Rl_Comd         ;写入指令“写”和要写入数据的地址
        ;
        BC      SPI_CLK/8,SPI_CLK%8
        JBS     DataAddressInEEPROM,0        ;写入8BIT模式时的地址最低位
        BC      SPI_MOSI/8,SPI_MOSI%8
        JBC     DataAddressInEEPROM,0
        BS      SPI_MOSI/8,SPI_MOSI%8
        JMP     $+1
        BS      SPI_CLK/8,SPI_CLK%8          ;完成命令的写入
        JMP     $+1
        JMP     $+1
       ;
        INC     DataAddressInEEPROM
        BC      AT93C46_CS/8,AT93C46_CS%8
        BC      SPI_CLK/8,SPI_CLK%8
        BC      SPI_MOSI/8,SPI_MOSI%8
        JMP     $+1
        BS      SPI_CLK/8,SPI_CLK%8
        BS      AT93C46_CS/8,AT93C46_CS%8
        JBS     SPI_MISO/8,SPI_MISO%8
        JMP     $-1
        BC      AT93C46_CS/8,AT93C46_CS%8
;
        DJZ     r_acc3
        JMP     $Write_Data
        ENDM
;
;***********************************************************************;
;Program name:  mERAL m,spi                                             ;
;Description:   擦除所有地址的数据                                      ;
;Input:         m 选择数据类型 m==8或16                                 ;
;               spi  选择PORT作为通信口，要定义好cs,sk,di,DO相关位      ;
;Output:        所有地址的数据被擦除，变为“FF"                         ;
;Variable Register:None                                                 ;
;Register Changed: STATUS,ACC ,r_acc1(0X21) , r_acc2(0X22)          ;
;***********************************************************************
mERAL   MACRO
$Write_Data:
        LCALL   Start_Bit       ;写入起始位
        MOV     A,@ERAL
        MOV     r_acc1,A      ;高二位为写命令，低六位为地址
       ;
        MOV     A,@9
       ;
        LCALL    Rl_Comd
        BC      AT93C46_CS/8,AT93C46_CS%8
        BC      SPI_CLK/8,SPI_CLK%8
        BC      SPI_MOSI/8,SPI_MOSI%8
        JMP     $+1
        BS      SPI_CLK/8,SPI_CLK%8
        BS      AT93C46_CS/8,AT93C46_CS%8
        JBS     SPI_MISO/8,SPI_MISO%8
        JMP     $-1
        BC      AT93C46_CS/8,AT93C46_CS%8
        ENDM
;
;***********************************************************************;
;Program name:  mWRAL m,DataAddressInMCU,spi                                      ;
;Description:   一个指定数据写入到所有地址                              ;
;Input:         m 选择数据类型 m==8或16                                 ;
;               spi  选择PORT作为通信口，要定义好cs,sk,di,DO相关位      ;
;               DataAddressInMCU  内容为存放数据的最低位地址（mCU的地址）         ;
;Output:        所有地址写入同一指定数据                                ;
;Variable Register:None                                                 ;
;Register Changed: STATUS,ACC ,r_acc1(0X21) , r_acc2(0X22)          ;
;***********************************************************************;
mWRAL   MACRO   @DataAddressInMCU
        MOV     A,@DataAddressInMCU
        MOV     R4,A            ;存放数据的间接地址
        LCALL    Start_Bit       ;写入起始位
        MOV     A,@WRAL
        MOV     r_acc1,A      ;高二位为写命令，低六位为地址
        ;
        MOV     A,@9
        ;
        LCALL    Rl_Comd
$Data_H_L:
        MOV     A,R0
        MOV     r_acc1,A      ;装入要写入的数据
        INC     R4
        MOV     A,@8
        LCALL    Rl_Comd         ;写入8BIT数据
        ;
        NOP
        ;
        BC      SPI_CLK/8,SPI_CLK%8          ;数据写完，写结束位
        BC      AT93C46_CS/8,AT93C46_CS%8
        BC      SPI_MOSI/8,SPI_MOSI%8
        JMP     $+1
        BS      SPI_CLK/8,SPI_CLK%8
        BS      AT93C46_CS/8,AT93C46_CS%8          ;完成结束位的写入
        JBS     SPI_MISO/8,SPI_MISO%8
        JMP     $-1
        BC      AT93C46_CS/8,AT93C46_CS%8
        BC      SPI_CLK/8,SPI_CLK%8
        ENDM


;-------------------------------------------------------
Start_Bit:
		BANK    @0
        BC      AT93C46_CS/8,AT93C46_CS%8
        BC      SPI_CLK/8,SPI_CLK%8
        BC      SPI_MOSI/8,SPI_MOSI%8
        JMP     $+1
        JMP     $+1
        BS      AT93C46_CS/8,AT93C46_CS%8
        JMP     $+1
        JMP     $+1
        BS      SPI_MOSI/8,SPI_MOSI%8       ;PORT6,SPI_MOSI;
        JMP     $+1
        JMP     $+1
        BS      SPI_CLK/8,SPI_CLK%8
        RET

;--------------------------------------------------------
Rl_Comd:
	MOV     DataShiftCNT,A
	BANK    @0
Rl_Comd1:
	BC      SPI_CLK/8,SPI_CLK%8
	JMP     $+1
	bc      status,c
	RLC     r_acc1        ;要写入的数据
	JBS     STATUS,C
	BC      SPI_MOSI/8,SPI_MOSI%8
	JBC     STATUS,C
	BS      SPI_MOSI/8,SPI_MOSI%8
	NOP
	NOP
	BS      SPI_CLK/8,SPI_CLK%8
	JMP     $+1
	DJZ     DataShiftCNT
	JMP     Rl_Comd1
	RET                   ;    return

;=============== SPI Config for EM78P510====================
IO_93C46_INITIAL:
	BANK                0
	BS                  SPI_SS/8,SPI_SS%8          ; Disable EM198810
	BS                  CMOS_SS/8,CMOS_SS%8        ; Disable CMOS
	BS                  AT93C46_CS/8,AT93C46_CS%8   ; Enable 93C46

	BANK                2
	MOV                 A,SPIC
	BANK                4
	MOV                 SPIC_TEMP,A
	BANK                2
	CLR                 SPIC
	RET

IO_93C46_QUIT:
	BANK                0
	;BS                 SPI_SS/8,SPI_SS%8           ; Disable EM198810
	;BS                 CMOS_SS/8,CMOS_SS%8         ; Disable CMOS
	BC                  AT93C46_CS/8,AT93C46_CS%8   ; Disable 93C46

	BANK                4
	MOV                 A,SPIC_TEMP
	BANK                2
	MOV                 SPIC,A
	RET