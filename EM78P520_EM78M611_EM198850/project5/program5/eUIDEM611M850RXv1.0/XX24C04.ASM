;**********************************************************************;
; Tilte: Em78x447x I2C FOR AT24C01 Function macro Code                 ;
; Description:                                                         ;
;     1."mTDATA" д�����ݵĺ꣬��������д����ֽ�                      ;
;     2."mRDATA" �������ݵĺ꣬��������������ֽ�                      ;
; Company: Elan Corp. Inc                                              ;
; Author:  youfang.bao                                                 ;
; Date:    7/1/2004                                                    ;
; Version: v1.0                                                        ;
;**********************************************************************;

;======================================================================
include "XX24C04.H"


;**********************************************************************;
; �����ź��ӳ���
;
        IFNDEF  mro_tt1
        mro_tt1 EQU 1
BSTART:
        IOR     P6
        AND     A, @0b00111111  ; I2C_CLK,I2C_DAT�������״̬
        IOW     P6
        BS      P6, I2C_DAT     ; I2C_CLK,I2C_DAT���ڸߵ�ƽ״̬
        NOP                     ; �ղ�����ʱ
        NOP
        BS      P6, I2C_CLK
        NOP
        NOP
        BC      P6, I2C_DAT     ; I2C_CLK�ߵ�ƽʱ��I2C_DAT������I2C��������
        NOP
        NOP
        BC      P6, I2C_CLK
;
        RET
        ENDIF

;**********************************************************************;
; ����ֹͣ�ź��ӳ���
;
        IFNDEF  mro_tt2
        mro_tt2 EQU 1
BSTOP:
        IOR     P6
        AND     A, @0b00111111  ; I2C_CLK,I2C_DAT�������״̬
        IOW     P6
        BC      P6, I2C_DAT
        NOP
        NOP
        BS      P6, I2C_CLK
        NOP
        NOP
        BS      P6, I2C_DAT     ; I2C_CLK�ߵ�ƽʱ��I2C_DAT������E2C����ֹͣ
;
        RET
        ENDIF

;**********************************************************************;
;���������ӳ��򣬽��������ݷ���I2C_RXBUF��
;
mI2C_RX MACRO
        IFNDEF  mro_tt3
        mro_tt3 EQU 1
;
        jmp	 mI2C_RX_End
I2C_RX:
        MOV     A, @8
        MOV     I2C_COUNT, A
        CLR     I2C_RXBUF       ; �������ݼĴ���I2C_RXBUF����
        BC      R3, 0
;
        IOR     P6
        AND     A, @0b00111111
        OR      A, @0b10000000  ; I2C_CLK�������״̬��I2C_DAT��������״̬
        IOW     P6
;
        BS      P6, I2C_DAT     ; I2C_DAT���ߣ�Ϊ������׼��
I2C_RX_LP:
        RLC     I2C_RXBUF       ; ������λ����
;
        BS      P6, I2C_CLK     ; I2C_CLK������I2C��������
;
        JBC     P6, I2C_DAT
        BS      I2C_RXBUF, 0
        NOP
        NOP
;
        BC      P6, I2C_CLK     ; I2C_CLK�ָ��͵�ƽ
;
        DJZ     I2C_COUNT       ; 8 λ������
        JMP     I2C_RX_LP       ; 8 λδ����������
;
        RET
mI2C_RX_End:
;
        ENDIF
        ENDM
;**********************************************************************;
;���������ӳ��򣬽�I2C_TXBUF�е����ݷ���I2C
;
mI2C_TX MACRO
        IFNDEF  mro_tt4
        mro_tt4 EQU 1
;
        jmp	 mI2C_TX_End
I2C_TX:
        MOV     A, @8           ; һ�ֽ�8λ
        MOV     I2C_COUNT, A
;
        IOR     P6
        AND     A, @0b00111111  ; I2C_CLK��I2C_DAT�������״̬
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
        BS      P6, I2C_CLK     ; CLK������I2C��ʼ��������
        NOP
        NOP
        NOP
        NOP
        BC      P6, I2C_CLK     ; CLK�ָ��͵�ƽ
;
        RLC     I2C_TXBUF
        DJZ     I2C_COUNT
        JMP     I2C_TX_LP
;
        BS      P6, I2C_DAT     ; ������Ӧ���ź�     
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
; Description:      ��24C01��ĳһ��ַ��ʼ��EEPROM�е����ݶ�����        ;
;                   I2C_DATA0��ʼ���ڴ���ȥ                            ;
; Input:            Address, Ҫд�뵽24C01���ݵ��׵�ַ                 ;
; Output:           I2C_DATA0, ���Ҫд������ݵ��׵�ַ                ;
; Register Changed: STATUS, I2C_TXBUF, I2C_RXBUF, I2C_COUNT, I2C_DATA0 ;
;**********************************************************************;
;��I2C_DATA0������д��24C01ĳһ��ַ��EEPROM��ȥ
;
mWBYTE  Macro   Address, I2C_DATA0
;
        mI2C_TX
;
        CALL    BSTART
;
        MOV     A, @0b10100000  ; ���������ֽڣ�10100000B��
        MOV     I2C_TXBUF, A
        CALL    I2C_TX
;
        MOV     A, @Address     ; ����24C01�׵�ַ
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
; Description:      ��24C01��ĳһ��ַ��EEPROM�е����ݶ�����,           ;
;                   I2C_DATA0�ڴ���ȥ                                  ;
; Input:            Address, Ҫ��24C01��ȡ�����ݵ��׵�ַ               ;
; Output:           I2C_DATA0, �����MCU�ڴ���׵�ַ                   ;
; Register Changed: STATUS, I2C_TXBUF, I2C_RXBUF, I2C_COUNT, I2C_DATA0 ;
;**********************************************************************;
;��24C01��ĳһ��ַ��EEPROM�е����ݶ���I2C_DATA0�ڴ���ȥ
;
mRBYTE  Macro   Address, I2C_DATA0
;
        mI2C_TX
        mI2C_RX
;
        CALL    BSTART
;
        MOV     A, @0b10100000  ; ���������ֽڣ�10100000B��
        MOV     I2C_TXBUF, A
        CALL    I2C_TX
;
        MOV     A, @Address     ; ����24C01�׵�ַ
        MOV     I2C_TXBUF, A
        CALL    I2C_TX
;
        CALL    BSTART
;
        MOV     A, @0b10100001  ; ���������ֽڣ�10100001B��
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
; Description:      ��24C01��ĳһ��ַ��ʼ��EEPROM�е����ݶ�����        ;
;                   I2C_DATA0��ʼ���ڴ���ȥ                            ;
; Input:            m, Ҫд�����ݵĵ�ַ����                            ;
;                   Address, Ҫд�뵽24C01���ݵ��׵�ַ                 ;
; Output:           I2C_DATA0, ���Ҫд������ݵ��׵�ַ                ;
; Register Changed: STATUS, I2C_TXBUF, I2C_RXBUF,                      ;
;                   I2C_COUNT, I2C_BYTES, I2C_DATA0                    ;
;**********************************************************************;
;��I2C_DATA0��ʼ������д��24C01��ĳһ��ַ��ʼ��EEPROM��ȥ
;
mWPAGE  Macro   m, Address, I2C_DATA0
;
        mI2C_TX
;
        CALL    BSTART          ; ���������ź�
;
        MOV     A, @0b10100000  ; ���������ֽڣ�10100000B��
        MOV     I2C_TXBUF, A
        CALL    I2C_TX
;
        MOV     A, @Address     ; ����24C01�׵�ַ
        MOV     I2C_TXBUF, A
        CALL    I2C_TX
;
        MOV     A, @m
        MOV     I2C_BYTES, A
        MOV     A, @I2C_DATA0   ; �����I2C_DATA0�ֽڼ��Ѱַ
        MOV     R4, A
I2C_TLP:
        MOV     A, R0
        MOV     I2C_TXBUF, A
        CALL    I2C_TX
        INC     R4
        DJZ     I2C_BYTES
        JMP     I2C_TLP
;
        CALL    BSTOP           ; ����ֹͣ�ź�
;
        ENDM
;**********************************************************************;
; Program name:     mRData  m, Address, I2C_DATA0                      ;
; Description:      ��24C01��ĳһ��ַ��ʼ��EEPROM�е����ݶ�����        ;
;                   I2C_DATA0��ʼ���ڴ���ȥ                            ;
; Input:            m, Ҫ�������ݵĵ�ַ����                            ;
;                   Address, Ҫ��24C01��ȡ�����ݵ��׵�ַ               ;
; Output:           I2C_DATA0, �����MCU�ڴ���׵�ַ                   ;
; Register Changed: STATUS, I2C_TXBUF, I2C_RXBUF,                      ;
;                   I2C_COUNT, I2C_BYTES, I2C_DATA0                    ;
;**********************************************************************;
;��24C01��ĳһ��ַ��ʼ��EEPROM�е����ݶ�����I2C_DATA0��ʼ���ڴ���ȥ
;
mRPAGE  Macro   m, Address, I2C_DATA0
;
        mI2C_TX
        mI2C_RX
		
        CALL    BSTART          ; ���������ź�
;
        MOV     A, @0b10100000  ; ���������ֽڣ�10100000B��
        MOV     I2C_TXBUF, A
        CALL    I2C_TX
;
        MOV     A, @Address     ; ����24C01�׵�ַ
        MOV     I2C_TXBUF, A
        CALL    I2C_TX
;
        CALL    BSTART          ; ���������ź�
;
        MOV     A, @0b10100001  ; ���������ֽڣ�10100001B��
        MOV     I2C_TXBUF, A
        CALL    I2C_TX
;
        MOV     A, @m
        MOV     I2C_BYTES, A
        MOV     A, @I2C_DATA0   ; �����I2C_DATA0�ֽڼ��Ѱַ
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
        AND     A, @0b00111111  ; I2C_CLK,I2C_DAT�������״̬
        IOW     P6
        BC      P6, I2C_DAT
        NOP                     ; �ղ�����ʱ
        NOP
        BS      P6, I2C_CLK
        NOP                     ; �ղ�����ʱ
        NOP
        NOP
        NOP
        BC      P6, I2C_CLK     ; I2C_CLK�ߵ�ƽʱ��I2C_DAT������E2C����ֹͣ
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
