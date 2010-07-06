;***********************************************************************;
; Tilte: iic 24c01 Function                ;

; Company: Elan Corp. Inc                                               ;
; Author:  yu.wei                                                     ;
; Date:    2009.4.20                                                    ;
; Version: v1.0                                                         ;
;***********************************************************************


;SYSTEM CLOCK 4MHz
;IO port define
    SDA    == 4
    SCL    == 3

    MSDA    == 0
    MSCL    == 1
    MCS    == 2
    MRST    == 5
    
;Register define
    TREG    == 0X10
    TCNT    == 0X11
    GCNT    == 0X12

    IICADDR    == 0X1E
    IICBUF    == 0X28
    IICDAT0    == 0X28
    IICDAT1    == 0X29
    IICDAT2    == 0X2A
    IICDAT3    == 0X2B
    IICDAT4    == 0X2C
    IICDAT5    == 0X2D
    IICDAT6    == 0X2E
    IICDAT7    == 0X2F
    
    INCLUDE "EM78P447S.H"
    
    ORG    0X000
    ADD    A,@0XFF
    ADD    A,@0XFF
    ADD    A,@0XFF
    ADD    A,@0XFF
    ADD    A,@0XFF

START:
    DISI
    ;SET P6 P7 PULL UP EN
    CONTR
    MOV    TREG,A
    BC    TREG,7
    MOV    A,TREG
    CONTW
    ;SET SCL SDA OUTPUT HIGH
    MOV    A,@0XFF
    MOV    TREG,A
    BC    TREG,SCL    ;SCL OUTPUT
    BC    TREG,SDA    ;SDA OUTPUT
    MOV    A,TREG
    IOW    IOC6
    BS    R6,SCL        ;SCL HIGH
    BS    R6,SDA        ;SDA HIGH

;********************************************************************
;读入的测试程序，读取2401的0x00～0x07地址内容
READ_2401:
    MOV    A,@0X00
    MOV    IICADDR,A
    CALL    IIC_R8BYT
    RET

;********************************************************************
;写入的测试程序，向2401的0x00～0x07地址写入0x00
WRITE_2401:
    MOV    A,@0X00
    MOV    IICADDR,A
    CLR    IICDAT
    CLR    IICDAT
    CLR    IICDAT
    CLR    IICDAT
    CLR    IICDAT
    CLR    IICDAT
    CLR    IICDAT
    CLR    IICDAT
    CALL    IIC_W8BYT
    RET

;********************************************************************
;与Microchip的2401接口程序
;********************************************************************
;IIC_W8BYT,向2401的指定地址写入8个字节数据
;地址由IICADDR指定，数据存在IICDAT0～IICDAT7
IIC_W8BYT:
    CALL    IIC_START
    MOV    A,@0XA0
    CALL    IIC_WBYT
    CALL    IIC_CACK
    JBC    R3,GP        ;IF GP=1 OPTION AGAIN
    JMP    IIC_W8BYT
    MOV    A,IICADDR
    CALL    IIC_WBYT
    CALL    IIC_CACK
    JBC    R3,GP        ;IF GP=1 OPTION AGAIN
    JMP    IIC_W8BYT
    ;WRITE 8 BYTES TO 24C01
    MOV    A,@IICBUF
    MOV    R4,A
    MOV    A,@8
    MOV    GCNT,A
IIC_W8BYT1:
    MOV    A,R0
    INC    R4
    CALL    IIC_WBYT
    CALL    IIC_CACK
    JBC    R3,GP        ;IF GP=1 OPTION AGAIN
    JMP    IIC_W8BYT
    DJZ    GCNT
    JMP    IIC_W8BYT1
    CALL    IIC_STOP
    RET

;********************************************************************
;IIC_W1BYT,向2401的指定地址写入1个字节数据
;地址由IICADDR指定，数据存在IICDAT0
IIC_W1BYT:
    CALL    IIC_START
    MOV    A,@0XA0
    CALL    IIC_WBYT
    CALL    IIC_CACK
    JBC    R3,GP        ;IF GP=1 OPTION AGAIN
    JMP    IIC_W1BYT
    MOV    A,IICADDR
    CALL    IIC_WBYT
    CALL    IIC_CACK
    JBC    R3,GP        ;IF GP=1 OPTION AGAIN
    JMP    IIC_W1BYT
    ;WRITE 1 BYTES TO 24C01
    MOV    A,@IICBUF
    MOV    A,IICDAT0
    CALL    IIC_WBYT
    CALL    IIC_CACK
    JBC    R3,GP        ;IF GP=1 OPTION AGAIN
    JMP    IIC_W1BYT1
    CALL    IIC_STOP
    RET

;********************************************************************
;IIC_R8BYT，从2401的指定地址（IICADDR）读入8个字节数据
IIC_R8BYT:
    CALL    IIC_START
    MOV    A,@0XA0
    CALL    IIC_WBYT
    CALL    IIC_CACK
    JBC    R3,GP        ;IF GP=1 OPTION AGAIN
    JMP    IIC_R8BYT
    MOV    A,IICADDR
    CALL    IIC_WBYT
    CALL    IIC_CACK
    JBC    R3,GP        ;IF GP=1 OPTION AGAIN
    JMP    IIC_R8BYT
    CALL    IIC_START
    MOV    A,@0XA1
    CALL    IIC_WBYT
    CALL    IIC_CACK
    JBC    R3,GP        ;IF GP=1 OPTION AGAIN
    JMP    IIC_R8BYT
    ;READ 8 BYTES FROM 24C01
    MOV    A,@IICBUF
    MOV    R4,A
    MOV    A,@7
    MOV    GCNT,A
IIC_R8BYT1:
    CALL    IIC_RBYT
    MOV    R0,A
    INC    R4
    CALL    IIC_SACK
    DJZ    GCNT
    JMP    IIC_R8BYT1
    CALL    IIC_RBYT
    MOV    R0,A
    CALL    IIC_SNACK
    CALL    IIC_STOP
    RET

;********************************************************************
;IIC_R1BYT,向2401的指定地址读出1个字节数据
;地址由IICADDR指定，数据存在IICDAT0
IIC_R1BYT:
    CALL    IIC_START
    MOV    A,@0XA0
    CALL    IIC_WBYT
    CALL    IIC_CACK
    JBC    R3,GP        ;IF GP=1 OPTION AGAIN
    JMP    IIC_R1BYT
    MOV    A,IICADDR
    CALL    IIC_WBYT
    CALL    IIC_CACK
    JBC    R3,GP        ;IF GP=1 OPTION AGAIN
    JMP    IIC_R1BYT
    CALL    IIC_START
    MOV    A,@0XA1
    CALL    IIC_WBYT
    CALL    IIC_CACK
    JBC    R3,GP        ;IF GP=1 OPTION AGAIN
    JMP    IIC_R1BYT
    ;READ 1 BYTES FROM 24C01
    CALL    IIC_RBYT
    MOV    IICDAT0,A
    CALL    IIC_SNACK
    CALL    IIC_STOP
    RET

;********************************************************************
;IIC_START
IIC_START:
    BS    R6,SCL        ;SCL=1
    BS    R6,SDA        ;SDA=1
    CALL    IIC_DELAY
    BC    R6,SDA        ;SDA=0
    CALL    IIC_DELAY
    RET
    
;********************************************************************
;IIC_STOP
IIC_STOP:
    BS    R6,SCL        ;SCL=1
    BC    R6,SDA        ;SDA=0
    CALL    IIC_DELAY
    BS    R6,SDA        ;SDA=1
    CALL    IIC_DELAY
    RET

;********************************************************************
;IIC_CACK IF ACK,FIIC=0
IIC_CACK:
    ;SET SDA INPUT
    IOR    IOC6
    MOV    TREG,A
    BS    TREG,SDA
    MOV    A,TREG
    IOW    IOC6
    BS    R6,SCL        ;SCL=1
    BC    R3,GP
    JBC    R6,SDA
    BS    R3,GP
    BC    R6,SCL        ;SCL=0
    ;SET SDA OUTPUT
    IOR    IOC6
    MOV    TREG,A
    BC    TREG,SDA
    MOV    A,TREG
    IOW    IOC6
    RET

;********************************************************************
;IIC_SACK
IIC_SACK:
    BC    R6,SDA        ;SDA=0
    NOP
    BS    R6,SCL        ;SCL=1
    CALL    IIC_DELAY
    BC    R6,SCL        ;SCL=0
    CALL    IIC_DELAY
    RET
    
;********************************************************************
;IIC_SNACK
IIC_SNACK:
    BS    R6,SDA        ;SDA=1
    NOP
    BS    R6,SCL        ;SCL=1
    CALL    IIC_DELAY
    BC    R6,SCL        ;SCL=0
    CALL    IIC_DELAY
    RET

;********************************************************************
;IIC_WBYT
IIC_WBYT:
    MOV    TREG,A
    MOV    A,@8
    MOV    TCNT,A
IIC_WBYT1:
    BC    R6,SCL        ;SCL=0
    JBC    TREG,7
    JMP    IIC_WBIT1
    JMP    IIC_WBIT0
IIC_WBIT1:
    BS    R6,SDA
    JMP    IIC_WBYT2
IIC_WBIT0:
    BC    R6,SDA        ;SDA=X
    JMP    IIC_WBYT2
IIC_WBYT2:
    RLC    TREG
    CALL    IIC_DELAY
    BS    R6,SCL        ;SCL=1
    CALL    IIC_DELAY
    DJZ    TCNT
    JMP    IIC_WBYT1
    BC    R6,SCL        ;SCL=0
    CALL    IIC_DELAY
    RET
    
;********************************************************************
;IIC_RBYT
IIC_RBYT:
    MOV    A,@8
    MOV    TCNT,A
    ;SET SDA INPUT
    IOR    IOC6
    OR    A,@0X10
    IOW    IOC6
IIC_RBYT1:
    BS    R6,SCL        ;SCL=1
    JBC    R6,SDA
    JMP    IIC_RBIT1
    JMP    IIC_RBIT0
IIC_RBIT1:
    BS    TREG,0
    JMP    IIC_RBYT2
IIC_RBIT0:
    BC    TREG,0        ;SDA=X
    JMP    IIC_RBYT2
IIC_RBYT2:
    RLC    TREG
    BC    R6,SCL        ;SCL=0
    CALL    IIC_DELAY
    DJZ    TCNT
    JMP    IIC_RBYT1
    ;STORE READ RESULT
    RRC    TREG
    MOV    A,TREG
    MOV    TCNT,A
    ;SET SDA OUTPUT
    IOR    IOC6
    AND    A,@0XEF
    IOW    IOC6
    ;RESTORE READ RESULT
    MOV    A,TCNT
    RET

;********************************************************************
;
IIC_DELAY:
    NOP
    NOP
    RET
    
    ORG    0XFFF
    JMP    START