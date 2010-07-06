;***********************************************************************;
; Tilte: Em78M611 spi FOR AT93C46 Function macro Code                  ;
; Description:���й����������߸����ܺ�                                  ;
;     1."mEWEN"  ����д/�����ݵĺꡣ                                    ;
;     2."mEWDS"  ��ֹд/�����ݵĺ� ��                                   ;
;     3."mWRITE" д�����ݵĺ꣬��������д����ֽڣ���д�����ݿ��Բ�ͬ   ;
;     4."mREAD"  �����ݵĺ꣬��������������ֽڡ�                       ;
;     5."mERASE" �������ݵĺ꣬���Բ�����������ֽڡ�                   ;
;     6."mERAL"  �����������ݵĺ꣬���е�ַ�����ݶ�Ϊ"FF"��             ;
;     7."mWRAL"  �����е�ַд��ͬ�����ݵĺꡣ                           ;
; Company: Elan Corp. Inc                                               ;
; Author:  yu.wei                                                     ;
; Date:    2009.3.20                                                    ;
; Version: v1.0                                                         ;
; ˵������ʹ�ô˿�ʱ��Ҫ�������ΪͨѶ�ڵĶ��塣                        ;
;***********************************************************************
;˵����
;    1. ����ʽ��д���������ݶ�Ϊ8bit;
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
XX93C46_For_EM78M611.ASM       EQU        XX93C46_For_EM78M611.ASM

ifndef XX93C46_For_EM78M611.H
include "XX93C46_For_EM78M611.H"
endif

ifndef EM78CtrlIns.H
include "EM78CtrlIns.H"
endif


		ORG     0X300
;***********************************************************************;
;Program name: mEWEN m,spi    m ���ݵ�λ����8BIT��16BIT��               ;
;Description:  ����д/����������ָ��д��                                ;
;Input:        ѡ���������� m==8��m==16  m��������λ��                  ;
;              �����spi����cs,sk,di,DOλ                               ;
;Output:       ʹ��д/��������                                          ;
;Variable Register:None                                                 ;
;Register Changed: STATUS,ACC ,r_acc1(0X21) , r_acc2(0X22)          ;
;***********************************************************************;
mEWEN   MACRO   
        FCALL    Start_Bit       ;load start bit
        MOV     A,@ewen         ;enable erase/write
        MOV     r_acc1,A
        ;
        MOV     A,@9
        ;
        FCALL    Rl_Comd         ;finish enable erase/write
        BC      AT93C46_CS/16,AT93C46_CS%16          ;load end bit
        BC      SPI_CLK/16,SPI_CLK%16
        BC      SPI_MOSI/16,SPI_MOSI%16
        ENDM
;
;***********************************************************************;
;Program name:  mEWDS m,spi    m ���ݵ�λ����8BIT��16BIT��              ;
;Description:   ��ֹд/����������ָ��д��                               ;
;Input:         ѡ���������� m==8��m==16  m��������λ����               ;
;               �����spi����cs,sk,di,DOλ                              ;
;Output:        ��ֹд/��������                                         ;
;Variable Register:None                                                 ;
;Register Changed: STATUS,ACC ,r_acc1(0X21) , r_acc2(0X22)          ;
;***********************************************************************;
mEWDS   MACRO     
        FCALL     Start_Bit       ;д����ʼλ
        MOV      A,@ewds         ;��ֹд�Ͳ�������
        MOV      r_acc1,A
        ;
        MOV      A,@9
        ;
        FCALL     Rl_Comd
        BC       AT93C46_CS/16,AT93C46_CS%16
        BC       SPI_CLK/16,SPI_CLK%16
        BC       SPI_MOSI/16,SPI_MOSI%16          ;���ʹ��д����ָ���д��
        ENDM
;
;***********************************************************************;
;Program name:  mWRITE m,DataAddressInEEPROM,k,DataAddressInMCU,spi                            ;
;Description:   ָ�����ݿ�д�뵽ָ����ַ                                ;
;Input:         m ѡ���������� m==8��16                                 ;
;               DataAddressInEEPROM  ����ΪҪд�����ݵ����λ��ַ(93C46�ĵ�ַ��      ;
;               k Ҫд�����ݵĵ�ַ����                                  ;
;               DataAddressInMCU  ����Ϊ������ݵ����λ��ַ��mCU�ĵ�ַ��         ;
;               spi  ѡ��PORT��Ϊͨ�ſڣ�Ҫ�����cs,sk,di,DO���λ      ;
;Output:        д��ָ�����ݿ鵽ָ����ַ��                              ;
;Variable Register:None                                                 ;
;Register Changed: STATUS,ACC ,
;                  r_acc1(0X21) ,
;                  r_acc2(0X22),         ;
;                  r_acc3(0X23)                                       ;
;***********************************************************************;
mWRITE  MACRO   DataAddressInEEPROM,@BankSel,DataAddressInMCU,@k
        BANK    @BankSel
        MOV     A,DataAddressInMCU    ;д�����ݴ�ŵ���͵�ַΪ0X24��mCU�ĵ�ַ��
        MOV     R4,A                   ;������ݵļ�ӵ�ַ
        MOV     A,@k
        MOV     r_acc3,A               ;д��93C46���ֽ���
$Write_Data:
        FCALL    Start_Bit             ;д����ʼλ
       ;
        BC      STATUS,C
        RRCA    DataAddressInEEPROM
        ;
        OR      A,@write
        MOV     r_acc1,A               ;�߶�λΪд�������λΪ��ַ
        MOV     A,@8                   ;��93C46дһ���ֽڣ�������
        FCALL    Rl_Comd               ;д��ָ�д����Ҫд�����ݵĵ�ַ
       ;
        BC      SPI_CLK/16,SPI_CLK%16
        JBS     DataAddressInEEPROM,0        ;д��8BITģʽʱ�ĵ�ַ���λ
        BC      SPI_MOSI/16,SPI_MOSI%16
        JBC     DataAddressInEEPROM,0
        BS      SPI_MOSI/16,SPI_MOSI%16
        JMP     $+1
        BS      SPI_CLK/16,SPI_CLK%16          ;����Ϊд��OP��ADDRESS
        ;
        INC     DataAddressInEEPROM
$Data_H_L:
        MOV     A,R0
        MOV     r_acc1,A      ;װ��Ҫд�������
        INC     R4
        MOV     A,@8
        FCALL    Rl_Comd         ;д��8BIT����
       ;
        JMP     $+1
       ;
        BC      AT93C46_CS/16,AT93C46_CS%16
        BC      SPI_CLK/16,SPI_CLK%16          ;����д�꣬д����λ
        ;BC      AT93C46_CS/16,AT93C46_CS%16
        BC      SPI_MOSI/16,SPI_MOSI%16
        JMP     $+1
        BS      SPI_CLK/16,SPI_CLK%16
        BS      AT93C46_CS/16,AT93C46_CS%16          ;��ɽ���λ��д��
        JBS     SPI_MISO/16,SPI_MISO%16
        JMP     $-1
        BC      AT93C46_CS/16,AT93C46_CS%16
        DJZ     r_acc3        ;���ֽ�д�����
        JMP     $Write_Data
        ENDM
;
;***********************************************************************;
;Program name:  mREAD m,DataAddressInEEPROM,k,DataAddressInMCU,spi                             ;
;Description:   ��ָ����ַ�飨93C46���������ݵ�ָ����ַ��(CPU)          ;
;Input:         m ѡ���������� m==8��16                                 ;
;               DataAddressInEEPROM  ����ΪҪ�������ݵ����λ��ַ(93C46�ĵ�ַ��      ;
;               k Ҫд�����ݵĵ�ַ����                                  ;
;               DataAddressInMCU  ����Ϊ������ݵ����λ��ַ��mCU�ĵ�ַ��         ;
;               spi  ѡ��PORT��Ϊͨ�ſڣ�Ҫ�����cs,sk,di,DO���λ      ;
;Output:        ָ����ַ����ָ�����ݿ�                                  ;
;Variable Register:None                                                 ;
;Register Changed: STATUS,ACC ,
;                  r_acc1(0X21) ,
;                  r_acc2(0X22),         ;
;                  r_acc3(0X23)                                       ;
;***********************************************************************;
mREAD   MACRO   DataAddressInEEPROM,@BankSel,DataAddressInMCU,@k
        MOV     A,DataAddressInMCU              ;д�����ݴ�ŵ���͵�ַ��mCU�ĵ�ַ��     ;
        MOV     R4,A
        BANK    @BankSel
        MOV     A,@k
        MOV     r_acc3,A
$Write_Data:
        FCALL    Start_Bit       ;д����ʼλ
       ;
        RRCA    DataAddressInEEPROM
        ;
        OR      A,@READ
        MOV     r_acc1,A      ;�߶�λΪд�������λΪ��ַ
        MOV     A,@8            ;��93C46дһ���ֽڣ�������
        FCALL    Rl_Comd         ;д��ָ�������Ҫд�����ݵĵ�ַ
       ;
        BC      SPI_CLK/16,SPI_CLK%16
        JBS     DataAddressInEEPROM,0        ;д��8BITģʽʱ�ĵ�ַ���λ
        BC      SPI_MOSI/16,SPI_MOSI%16
        JBC     DataAddressInEEPROM,0
        BS      SPI_MOSI/16,SPI_MOSI%16
        JMP     $+1
        BS      SPI_CLK/16,SPI_CLK%16
       ;
        INC     DataAddressInEEPROM          ;��ַ��1
        BC      SPI_MOSI/16,SPI_MOSI%16
        JMP     $+1
        BC      SPI_CLK/16,SPI_CLK%16
        JMP     $+1
        JMP     $+1
        BS      SPI_CLK/16,SPI_CLK%16

$Read_Data1:
        MOV     A,@8
        MOV     r_acc2,A
$Read_Data2:
        BC      SPI_CLK/16,SPI_CLK%16
        NOP
        NOP
        JBC     SPI_MISO/16,SPI_MISO%16
        BS      STATUS,C
        JBS     SPI_MISO/16,SPI_MISO%16
        BC      STATUS,C
        RLC     R0
        BS      SPI_CLK/16,SPI_CLK%16
        JMP     $+1
        DJZ     r_acc2
        JMP     $Read_Data2
        INC     R4
        ;
        NOP
        ;
        BC      AT93C46_CS/16,AT93C46_CS%16
        DJZ     r_acc3
        JMP     $Write_Data
        ENDM
;
;***********************************************************************;
;Program name:  mERASE m,DataAddressInEEPROM,k,spi                                   ;
;Description:   ��ָ����ַ���������                                    ;
;Input:         m ѡ���������� m==8��16                                 ;
;               DataAddressInEEPROM ����ΪҪ�������ݵ����λ��ַ(93C46�ĵ�ַ��       ;
;               k Ҫ�������ݵĵ�ַ����                                  ;
;               spi    ѡ��PORT��Ϊͨ�ſڣ�Ҫ�����cs,sk,di,DO���λ    ;
;Output:        ָ����ַ������ݱ�����                                  ;
;Variable Register:None                                                 ;
;Register Changed: STATUS,ACC ,
;                  r_acc1(0X21) ,
;                  r_acc2(0X22),         ;
;                  r_acc3(0X23)                                       ;
;***********************************************************************;
mERASE  MACRO    DataAddressInEEPROM,k
        MOV     A,@k
        MOV     r_acc3,A      ;д��93C46���ֽ���
$Write_Data:
        CALL    Start_Bit       ;д����ʼλ
       ;
        RRCA    DataAddressInEEPROM
       ;
        OR      A,@ERASE
        MOV     r_acc1,A      ;�߶�λΪд�������λΪ��ַ
        MOV     A,@8            ;��93C46дһ���ֽڣ�������
        CALL    Rl_Comd         ;д��ָ�д����Ҫд�����ݵĵ�ַ
        ;
        BC      SPI_CLK/16,SPI_CLK%16
        JBS     DataAddressInEEPROM,0        ;д��8BITģʽʱ�ĵ�ַ���λ
        BC      SPI_MOSI/16,SPI_MOSI%16
        JBC     DataAddressInEEPROM,0
        BS      SPI_MOSI/16,SPI_MOSI%16
        JMP     $+1
        BS      SPI_CLK/16,SPI_CLK%16          ;��������д��
        JMP     $+1
        JMP     $+1
       ;
        INC     DataAddressInEEPROM
        BC      AT93C46_CS/16,AT93C46_CS%16
        BC      SPI_CLK/16,SPI_CLK%16
        BC      SPI_MOSI/16,SPI_MOSI%16
        JMP     $+1
        BS      SPI_CLK/16,SPI_CLK%16
        BS      AT93C46_CS/16,AT93C46_CS%16
        JBS     SPI_MISO/16,SPI_MISO%16
        JMP     $-1
        BC      AT93C46_CS/16,AT93C46_CS%16
;
        DJZ     r_acc3
        JMP     $Write_Data
        ENDM
;
;***********************************************************************;
;Program name:  mERAL m,spi                                             ;
;Description:   �������е�ַ������                                      ;
;Input:         m ѡ���������� m==8��16                                 ;
;               spi  ѡ��PORT��Ϊͨ�ſڣ�Ҫ�����cs,sk,di,DO���λ      ;
;Output:        ���е�ַ�����ݱ���������Ϊ��FF"                         ;
;Variable Register:None                                                 ;
;Register Changed: STATUS,ACC ,r_acc1(0X21) , r_acc2(0X22)          ;
;***********************************************************************
mERAL   MACRO   
$Write_Data:
        FCALL   Start_Bit       ;д����ʼλ
        MOV     A,@ERAL
        MOV     r_acc1,A      ;�߶�λΪд�������λΪ��ַ
       ;
        MOV     A,@9
       ;
        FCALL    Rl_Comd
        BC      AT93C46_CS/16,AT93C46_CS%16
        BC      SPI_CLK/16,SPI_CLK%16
        BC      SPI_MOSI/16,SPI_MOSI%16
        JMP     $+1
        BS      SPI_CLK/16,SPI_CLK%16
        BS      AT93C46_CS/16,AT93C46_CS%16
        JBS     SPI_MISO/16,SPI_MISO%16
        JMP     $-1
        BC      AT93C46_CS/16,AT93C46_CS%16
        ENDM
;
;***********************************************************************;
;Program name:  mWRAL m,DataAddressInMCU,spi                                      ;
;Description:   һ��ָ������д�뵽���е�ַ                              ;
;Input:         m ѡ���������� m==8��16                                 ;
;               spi  ѡ��PORT��Ϊͨ�ſڣ�Ҫ�����cs,sk,di,DO���λ      ;
;               DataAddressInMCU  ����Ϊ������ݵ����λ��ַ��mCU�ĵ�ַ��         ;
;Output:        ���е�ַд��ͬһָ������                                ;
;Variable Register:None                                                 ;
;Register Changed: STATUS,ACC ,r_acc1(0X21) , r_acc2(0X22)          ;
;***********************************************************************;
mWRAL   MACRO   @DataAddressInMCU
        MOV     A,@DataAddressInMCU
        MOV     R4,A            ;������ݵļ�ӵ�ַ
        CALL    Start_Bit       ;д����ʼλ
        MOV     A,@WRAL
        MOV     r_acc1,A      ;�߶�λΪд�������λΪ��ַ
        ;
        MOV     A,@9
        ;
        CALL    Rl_Comd
$Data_H_L:
        MOV     A,R0
        MOV     r_acc1,A      ;װ��Ҫд�������
        INC     R4
        MOV     A,@8
        CALL    Rl_Comd         ;д��8BIT����
        ;
        NOP
        ;
        BC      SPI_CLK/16,SPI_CLK%16          ;����д�꣬д����λ
        BC      AT93C46_CS/16,AT93C46_CS%16
        BC      SPI_MOSI/16,SPI_MOSI%16
        JMP     $+1
        BS      SPI_CLK/16,SPI_CLK%16
        BS      AT93C46_CS/16,AT93C46_CS%16          ;��ɽ���λ��д��
        JBS     SPI_MISO/16,SPI_MISO%16
        JMP     $-1
        BC      AT93C46_CS/16,AT93C46_CS%16
        BC      SPI_CLK/16,SPI_CLK%16
        ENDM




;-------------------------------------------------------
Start_Bit:
		BANK    @0
        BC      AT93C46_CS/16,AT93C46_CS%16
        BC      SPI_CLK/16,SPI_CLK%16
        BC      SPI_MOSI/16,SPI_MOSI%16
        JMP     $+1
        JMP     $+1
        BS      AT93C46_CS/16,AT93C46_CS%16
        JMP     $+1
        JMP     $+1
        BS      SPI_MOSI/16,SPI_MOSI%16       ;PORT6,SPI_MOSI;
        JMP     $+1
        JMP     $+1
        BS      SPI_CLK/16,SPI_CLK%16
        RET

;--------------------------------------------------------
Rl_Comd:
	MOV     DataShiftCounter,A
	BANK    @0
Rl_Comd1:
	BC      SPI_CLK/16,SPI_CLK%16
	JMP     $+1
	bc      status,c
	RLC     r_acc1        ;Ҫд�������
	JBS     STATUS,C
	BC      SPI_MOSI/16,SPI_MOSI%16
	JBC     STATUS,C
	BS      SPI_MOSI/16,SPI_MOSI%16
	NOP
	NOP
	BS      SPI_CLK/16,SPI_CLK%16
	JMP     $+1
	DJZ     DataShiftCounter
	JMP     Rl_Comd1
	RET                   ;    return
