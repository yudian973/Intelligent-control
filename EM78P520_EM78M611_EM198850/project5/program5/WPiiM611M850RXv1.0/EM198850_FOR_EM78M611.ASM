;==================================================================
; Filename     :  EM78M611
; Author       :  yu.wei
; Company      :  ELAN
; VERSION      :  1.1
; CRYSTAL      :  6MHZ
; Creat date   :  2009/11/4
; tool ver.    :  eUIDE
; Description  :  modify for code conformity
;===================================================================

include	"EM198850_For_EM78M611.H"

	ORG                 0X1400    ;PAGE 5
	MESSAGE "define 'EM198850_For_EM78M611.ASM' ROM address"
;**************************************************
;LOOKUP TABLE
;Famer Register initial value(Reg48~57)
;**************************************************
FRAME_TABLE:
	ADD                 PC,A
	RETL                @0X4E		;1		01---16M
	RETL                @0X02		;2		10---24M

	RETL                @0X4D		;3		RESET FIFO
	RETL                @0X01		;4

	RETL                @0X42		;5		24M/1MBPS
	RETL                @0X98		;6

	RETL                @0X43		;7
	RETL                @0XC8 		;8		;8		;default:C4  Set sync word length£¬CRC count

	RETL                @0X44		;9		PKT_LEN
	RETL                @PKT_LEN	;10		24 DATA

	RETL                @0X45		;11		PKTCNT
	RETL                @0X10		;12		1 packet

	RETL                @0X46		;13		BIT3~5	TX AMPLIFIER DELAY 10+5X
	RETL                @0X09		;14		BIT0~2	PLL DELAY 120+20X

	RETL                @0X47		;15		BIT4~7  RETRY CNT
	RETL                @0X01		;16		BIT0~3	Slot TIME UNIT 10US

	RETL                @0X48		;17		Slot
	RETL                @0X01		;18

	RETL                @0X49		;19		ACKTOSLOT
	RETL                @0X14 		;20     default: 0X8A

	RETL                @0X4A		;21		RSSITH
	RETL                @0X27		;22

	RETL                @0X4B		;23		RF_RSSI
	RETL                @0X00		;24

	RETL                @0X4C		;25		TD_PLL	IN UNIT 10US
	RETL                @0X06		;26

	RETL                @0X50		;27		TXADDR
	RETL                @TXADDRL	;28

	RETL                @0X51		;29		TX ADDR
	RETL                @TXADDRH	;30

	RETL                @0X52		;31		RX	ADDR1
	RETL                @0X22		;32

	RETL                @0X53		;33		RX	ADDR2
	RETL                @0X33		;34

	RETL                @0X54		;35		RX	ADDR3
	RETL                @0X44		;36

	RETL                @0X55		;37		RX	ADDR4
	RETL                @0X55		;38

	RETL                @0X56		;39		RX	ADDR5
	RETL                @0X66		;40

	RETL                @0X57		;41		RX	ADDR6
	RETL                @0X77		;42

	RETL                @0X58		;43
	RETL                @0X08		;44

;-----------------------------------------------------------
	RETL                @0X00		;45
	RETL                @0XE5		;46

	RETL                @0X01		;47
	RETL                @0X84		;48

	RETL                @0X02		;49
	RETL                @0X00		;50		CHANNEL

	RETL                @0X03		;51
	RETL                @0XC6		;52

	RETL                @0X04		;53
	RETL                @0X00		;54

	RETL                @0X05		;55
	RETL                @0X40		;56

	RETL                @0X06		;57
	RETL                @0X5D		;58

	RETL                @0X07		;59
	RETL                @0X18		;60

	RETL                @0X08		;61
	RETL                @0X40		;62

	RETL                @0X09		;63
	RETL                @0X18		;64

	RETL                @0X0A		;65
	RETL                @0X47		;66

	RETL                @0X0B		;67
	RETL                @0X0B		;68

	RETL                @0X0C		;69
	RETL                @0XE0		;70

	RETL                @0X0D		;71
	RETL                @0X4F		;72

	RETL                @0X0E		;73
	RETL                @0X11		;74

	RETL                @0X0F		;75
	RETL                @0X1C		;76

	RETL                @0X20		;77
	RETL                @0XAD		;78

	RETL                @0X21		;79
	RETL                @0X64		;80

	RETL                @0X22		;81
	RETL                @0X00		;82

	RETL                @0X23		;83
	RETL                @0XC3		;84

	RETL                @0X24		;85
	RETL                @0XBD		;86

	RETL                @0X25		;87
	RETL                @0XA2		;88

	RETL                @0X26		;89
	RETL                @0X1A		;90

	RETL                @0X27		;91
	RETL                @0X09		;92

	RETL                @0X28		;93
	RETL                @0X00		;94

	RETL                @0X29		;95
	RETL                @0XB8		;96

	RETL                @0X2A		;97
	RETL                @0X71		;98

	RETL                @0X2B		;99
	RETL                @0X06		;100

	RETL                @0X2C		;101
	RETL                @0X80		;102

	RETL                @0X2D		;103
	RETL                @0X1A		;104

	RETL                @0X2E		;105
	RETL                @0X09;03		;106

	RETL                @0X2F		;107
	RETL                @0X64		;108

	RETL                @0X30		;109
	RETL                @0XC0		;110

	RETL                @0X31		;111
	RETL                @0X00		;112

	RETL                @0X32		;113
	RETL                @0X40		;114

	RETL                @0X33		;115
	RETL                @0X3B		;116

	RETL                @0X00		;117
	RETL                @0XA7		;118

	RETL                @0X32		;119
	RETL                @0X4A		;120

	RETL                @0X00		;121
	RETL                @0XE5		;122

	RETL                @0X0E		;123
	RETL                @0X91		;124

	RETL                @0X40		;125
	RETL                @0X51		;126

	RETL                @0X41		;127
	RETL                @0XBF		;128

	RETL                @0X0C		;129
	RETL                @0XC0		;130

	RETL                @0X02		;131
	RETL                @0X80		;132

	RETL                @0X04		;133
	RETL                @0X4A		;134

	RETL                @0X05		;135
	RETL                @0XDA		;136

	RETL                @0X06		;137
	RETL                @0XFA		;138

	RETL                @0XFF

;===========================================================
RF_TABLE:			;LENGTH 30
	ADD                 PC,A
	RETL                @0X4E
	RETL                @0X02

	RETL                @0X43
	RETL                @0XC8

	RETL                @0X44
	RETL                @PKT_LEN

	RETL                @0X45
	RETL                @0X10

	RETL                @0X48
	RETL                @0X01

	RETL                @0X4C
 	RETL                @0X06

	RETL                @0X50
	RETL                @TXADDRL

	RETL                @0X51
	RETL                @TXADDRH

	RETL                @0X52
	RETL                @0X22

	RETL                @0X53
	RETL                @0X33

	RETL                @0X54
	RETL                @0X44

	RETL                @0X55
	RETL                @0X55

	RETL                @0X56
	RETL                @0X66

	RETL                @0X57
	RETL                @0X77

	RETL                @0X58
	RETL                @0X08

	RETL                @0XFF

;===========================================================
CH_TABLE:
	ADD                 PC,A
	;1
	RETL                @20        ;00,Freq:0x14
	RETL                @38        ;01,Freq:0x26
	RETL                @56        ;02,Freq:0x38
	RETL                @79        ;03,Freq:0x4F

	;2
	RETL                @4         ;04,Freq:0x04
	RETL                @23        ;05,Freq:0x17
	RETL                @42        ;06,Freq:0x2A
	RETL                @61        ;07,Freq:0x3D

	;3
	RETL                @7         ;08,Freq:0x07
	RETL                @27        ;09,Freq:0x1B
	RETL                @47        ;10,Freq:0x2F
	RETL                @62        ;11,Freq:0x3E

	;4
	RETL                @10        ;12,Freq:0x02
	RETL                @31        ;13,Freq:0x1F
	RETL                @52        ;14,Freq:0x34
	RETL                @63        ;15,Freq:0x3F

	;5
	RETL                @13        ;16,Freq:0x0D
	RETL                @35        ;17,Freq:0x23
	RETL                @57        ;18,Freq:0x39
	RETL                @64        ;19,Freq:0x40

	;6
	RETL                @16        ;20,Freq:0x10
	RETL                @39        ;21,Freq:0x27
	RETL                @43        ;22,Freq:0x2B
	RETL                @65        ;23,Freq:0x41

	;7
	RETL                @19        ;24,Freq:0x13
	RETL                @24        ;25,Freq:0x18
	RETL                @48        ;26,Freq:0x30
	RETL                @66        ;27,Freq:0x42

	;8
	RETL                @22        ;28,Freq:0x16
	RETL                @28        ;29,Freq:0x1C
	RETL                @53        ;30,Freq:0x35
	RETL                @67        ;31,Freq:0x43

	;9
	RETL                @6         ;32,Freq:0x06
	RETL                @32        ;33,Freq:0x20
	RETL                @58        ;34,Freq:0x3A
	RETL                @68        ;35,Freq:0x44

	;10
	RETL                @9         ;36,Freq:0x09
	RETL                @36        ;37,Freq:0x24
	RETL                @44        ;38,Freq:0x2C
	RETL                @69        ;39,Freq:0x45

	;11
	RETL                @12        ;40,Freq:0x0C
	RETL                @40        ;41,Freq:0x28
	RETL                @49        ;42,Freq:0x31
	RETL                @70        ;43,Freq:0x46

	;12
	RETL                @15        ;44,Freq:0x0F
	RETL                @25        ;45,Freq:0x19
	RETL                @54        ;46,Freq:0x36
	RETL                @71        ;47,Freq:0x36

	;13
	RETL                @18        ;48,Freq:0x12
	RETL                @29        ;49,Freq:0x1D
	RETL                @59        ;50,Freq:0x3B
	RETL                @72        ;51,Freq:0x48

	;14
	RETL                @21        ;52,Freq:0x15
	RETL                @33        ;53,Freq:0x21
	RETL                @45        ;54,Freq:0x2D
	RETL                @73        ;55,Freq:0x49

	;15
	RETL                @5         ;56,Freq:0x05
	RETL                @37        ;57,Freq:0x25
	RETL                @50        ;58,Freq:0x32
	RETL                @74        ;59,Freq:0x4A

	;16
	RETL                @8         ;60,Freq:0x08
	RETL                @41        ;61,Freq:0x29
	RETL                @55        ;62,Freq:0x37
	RETL                @75        ;63,Freq:0x4B

	;17
	RETL                @11        ;64,Freq:0x03
	RETL                @26        ;65,Freq:0x1A
	RETL                @60        ;66,Freq:0x3C
	RETL                @76        ;67,Freq:0x4C

	;18
	RETL                @14        ;68,Freq:0x0E
	RETL                @30        ;69,Freq:0x1E
	RETL                @46        ;70,Freq:0x2E
	RETL                @77        ;71,Freq:0x4D

	;19
	RETL                @17        ;72,Freq:0x11
	RETL                @34        ;73,Freq:0x22
	RETL                @51        ;74,Freq:0x33
	RETL                @78        ;75,Freq:0x4E


;===========================================================
; RF Initialize SubRoutine
;===========================================================
EM198850_RESET:
	CALL                PAGE5BANK1
	BC                  RESET_N/16,RESET_N%16
	MOV                 A,@30                         ; wating 3ms
	CALL                DELAY_X100US
	BS                  RESET_N/16,RESET_N%16          ; RESET=1
	MOV                 A,@100                          ; wating 10ms
	CALL                DELAY_X100US

	BC                  RFTestfailFlag/16,RFTestfailFlag%16
	CALL                INIT_FRAMEREG                  ; load	FRAMER TABLE send
	MOV                 A,@5
	CALL                DELAY_X100US
	NOP
	CALL                INIT_RSSI_CALIBRATION
	NOP
	CALL                TEST_INITIAL_RF
	NOP
	JBC                 RFTestfailFlag/16,RFTestfailFlag%16
	JMP                 EM198850_RESET

	CALL                Enter_StandbyII_Mode
	BS                  RFInitialOKflag/16,RFInitialOKflag%16

	RET

;===============================================
INIT_FRAMEREG:
	CALL                PAGE5BANK1
	CLR                 TABLE_INDEX
  Set_FrameReg:
	MOV                 A,TABLE_INDEX
	CALL                FRAME_TABLE
	MOV                 ADDR,A
	XOR                 A,@0XFF
	JBC                 STATUS,Z
	JMP                 Set_Framereg_End
	INC                 TABLE_INDEX
	MOV                 A,TABLE_INDEX
	CALL                FRAME_TABLE
	NOP
	MOV                 VALUE,A
	CALL                WRITE_SPI_REG				;send SPI data to EM198810
	NOP
	INC                 TABLE_INDEX
	JMP                 Set_FrameReg
  Set_Framereg_End:
	NOP
	RET

;=================================================
INIT_RSSI_CALIBRATION:
	CALL                PAGE5BANK1
	MOV                 A,@0X05
	MOV                 DataByteLength,A
	CLR                 RF_RSSI
  Repeat_Read_RSSI:
	MOV                 A,@0X4B
	MOV                 ADDR,A
	CALL                READ_SPI_REG
	NOP
	MOV                 A,RF_RSSI
	SUB                 A,VALUE
	JBS                 STATUS,C
	JMP                 $+3
	MOV                 A,VALUE
	MOV                 RF_RSSI,A
	DJZ                 DataByteLength
	JMP                 Repeat_Read_RSSI

	MOV                 A,@0X04
	SUB                 RF_RSSI,A
	MOV                 A,RF_RSSI
	MOV                 VALUE,A
	MOV                 A,@0X4A
	MOV                 ADDR,A
	CALL                WRITE_SPI_REG
	NOP
	MOV                 A,@0X05
	MOV                 ADDR,A
	MOV                 A,@0X40
	MOV                 VALUE,A
	CALL                WRITE_SPI_REG
	NOP
	MOV                 A,@0X02
	MOV                 ADDR,A
	MOV                 A,@0X00
	MOV                 VALUE,A
	CALL                WRITE_SPI_REG
	NOP
	MOV                 A,@0X0C
	MOV                 ADDR,A
	MOV                 A,@0XE0
	MOV                 VALUE,A
	CALL                WRITE_SPI_REG
	NOP
	RET

;===========================================================
; RF Initialize End
;===========================================================
;===============================================
; Function: Write SPI Register
; Input:    ADDR,VALUE
; Output:   None
;===============================================
WRITE_SPI_REG:
	BC                  SPI_SS/16,SPI_SS%16				;	/SS	=0
	CALL                PAGE5BANK1
	MOV                 A,ADDR
	CALL                SIM_SPI_WRITE
	MOV                 A,VALUE
	CALL                SIM_SPI_WRITE
	BC                  SPI_CLK/16,SPI_CLK%16
	NOP
	BS                  SPI_SS/16,SPI_SS%16			;	/SS	=1
	RET

;===============================================
; Function: Read SPI Register
; Input:   SPIWB
; Output:  SPIRB
;===============================================
READ_SPI_REG:
	CALL                PAGE5BANK1
	BC                  SPI_SS/16,SPI_SS%16			;	/SS	=0
	MOV                 A,ADDR
	OR                  A,@0X80
	CALL                SIM_SPI_WRITE
	NOP
	CALL                SIM_SPI_READ
	MOV                 VALUE,A
	BC                  SPI_CLK/16,SPI_CLK%16
	NOP
	BS                  SPI_SS/16,SPI_SS%16			;	/SS	=0
	RET

;===============================================
; Function: Write SPI communication subroutine rising edge
; Input:    ACC
; Output:   None
;===============================================
SIM_SPI_WRITE:
	MOV                 SPIWB,A
	MOV                 A,@8
	MOV                 DataShiftCounter,A
  WRITE_SPI_1:
	BC                  SPI_CLK/16,SPI_CLK%16
	RLC                 SPIWB
	JBC                 STATUS,C
	JMP                 SET_SPI_MOSI
	BC                  SPI_MOSI/16,SPI_MOSI%16
	JMP                 WRITE_SPI_COUNT_DEC
  SET_SPI_MOSI:
	BS                  SPI_MOSI/16,SPI_MOSI%16
  WRITE_SPI_COUNT_DEC:
	BS                  SPI_CLK/16,SPI_CLK%16
	NOP
	DJZ                 DataShiftCounter
	JMP                 WRITE_SPI_1
	BC                  SPI_CLK/16,SPI_CLK%16
	NOP
	BC                  SPI_MOSI/16,SPI_MOSI%16
	RET

;===============================================
; Function: Read SPI communication subroutine rising edge
; Input:    None
; Output:   SPI Data
;===============================================
SIM_SPI_READ:
	CLR                 SPIRB
	MOV                 A,@8
	MOV                 DataShiftCounter,A
  READ_SPI_1:
	BC                  SPI_CLK/16,SPI_CLK%16
	NOP
	NOP
	NOP
	BS                  SPI_CLK/16,SPI_CLK%16
	JBS                 SPI_MISO/16,SPI_MISO%16
	JMP                 CLR_STATUS_C
	BS                  STATUS,C
	JMP                 READ_SPI_MISO
  CLR_STATUS_C:
	BC                  STATUS,C
  READ_SPI_MISO:
	RLC                 SPIRB
	DJZ                 DataShiftCounter
	JMP                 READ_SPI_1
	BC                  SPI_CLK/16,SPI_CLK%16
	MOV                 A,SPIRB
	RET


;***********************************************************
; Function: Read FIFO RAM
; Input:    None
; Output:   RX_BUF	,Receive_Error
;***********************************************************
READ_FIFO_RAM:
	MOV                 A,@RX_BUF					;READ DATA START Address
	MOV                 RSR,A
	NOP
	NOP
	BC                  SPI_SS/16,SPI_SS%16				;/SS=0
	MOV                 A,@0XFF						;0X7F||0X80 FIFO ADDRESS
	CALL                SIM_SPI_WRITE
	NOP
	NOP
	MOV                 A,@PKT_LEN
	MOV                 DataByteLength,A
  Read_FIFO_Loop:
	CALL                SIM_SPI_READ	 					;Packet & Device	ID
	MOV                 R0, A
	INC                 RSR
	DJZ                 DataByteLength
	JMP                 Read_FIFO_Loop
	NOP
	BS                  SPI_SS/16,SPI_SS%16				;/SS=1
	RET


;***********************************************************
; Function: Write FIFO RAM
; Input:    None
; Output:   RX_Buf	,Receive_Error%16
;***********************************************************
WRITE_FIFO_RAM:
	BC                  SPI_SS/16,SPI_SS%16    ;/SS=1
	MOV                 A,@0X7F         ;reg0X7F
	CALL                SIM_SPI_WRITE   ;use I/O as	SPI	pro
	NOP
	MOV                 A,@PKT_LEN
	MOV                 DataByteLength,A
	MOV                 A,@TX_BUF       ;Write DATA START Address
	MOV                 RSR,A
 Write_FIFO_Loop:
	MOV                 A,R0
	CALL                SIM_SPI_WRITE   ;use I/O as	SPI	pro
	NOP
	INC                 RSR
	DJZ                 DataByteLength
	JMP                 Write_FIFO_Loop
	BS                  SPI_SS/16,SPI_SS%16    ;/SS=1
	JBS                 PKT_FLAG/16,PKT_FLAG%16
	JMP                 $-1
	RET


;===============================================
; Function: Reset RF FIFO
; Input:    None
; Output:   None
;===============================================
RESET_RF_FIFO:
	CALL                PAGE5BANK1
	MOV                 A,@0X4D
	MOV                 ADDR,A					;ADDR=0X4D
	MOV                 A,@0X01
	MOV                 VALUE,A
	CALL                WRITE_SPI_REG				;send SPI data to EM198810
	;MOV                 A,@12
	;CALL                DELAY_X10US
	MESSAGE "Make sure that anything take-over or send out in 120us "
	RET


;***********************************************************
; Function: Enter TX Buffered ACK
; Input:    None
; Output:   None
;***********************************************************
ENTER_TX_BUFFER_ACK:
	CALL                PAGE5BANK1
	MOV                 A,@0X00
	MOV                 ADDR,A
	MOV                 A,@0XE5
	MOV                 VALUE,A
	CALL                WRITE_SPI_REG
	MOV                 A,@0X01
	MOV                 ADDR,A
	MOV                 A,@0X84
	MOV                 VALUE,A
	CALL                WRITE_SPI_REG
	MOV                 A,@0X41
	MOV                 ADDR,A
	MOV                 A,@0XBF
	MOV                 VALUE,A
	CALL                WRITE_SPI_REG
	MOV                 A,@0X40
	MOV                 ADDR,A
	MOV                 A,@0X56
	if                  USED_PID_FUNCTION
		OR              A,@0X80
	endif
	MOV                 VALUE,A
	CALL                WRITE_SPI_REG				;send SPI data to EM198810
	RET


;***********************************************************
; Function: Enter TX Buffered NACK
; Input:    None
; Output:   None
;***********************************************************
ENTER_TX_BUFFER_NACK:
	CALL                PAGE5BANK1
	MOV                 A,@0X00
	MOV                 ADDR,A
	MOV                 A,@0XE5
	MOV                 VALUE,A
	CALL                WRITE_SPI_REG
	MOV                 A,@0X01
	MOV                 ADDR,A
	MOV                 A,@0X84
	MOV                 VALUE,A
	CALL                WRITE_SPI_REG
	MOV                 A,@0X41
	MOV                 ADDR,A
	MOV                 A,@0XBF
	MOV                 VALUE,A
	CALL                WRITE_SPI_REG
	MOV                 A,@0X40
	MOV                 ADDR,A
	MOV                 A,@0X52
	if                  USED_PID_FUNCTION
		OR              A,@0X80
	endif
	MOV                 VALUE,A
	CALL                WRITE_SPI_REG				;send SPI data to EM198810
	RET


;***********************************************************
; Function: Enter TX Direct ACK
; Input:    None
; Output:   None
;***********************************************************
Enter_TX_Direct_ACK:
	CALL                PAGE5BANK1
	MOV                 A,@0X00
	MOV                 ADDR,A
	MOV                 A,@0X85
	MOV                 VALUE,A
	CALL                WRITE_SPI_REG
	MOV                 A,@0X01
	MOV                 ADDR,A
	MOV                 A,@0X84
	MOV                 VALUE,A
	CALL                WRITE_SPI_REG
	MOV                 A,@0X41
	MOV                 ADDR,A
	MOV                 A,@0XBF
	MOV                 VALUE,A
	CALL                WRITE_SPI_REG
	MOV                 A,@0X40
	MOV                 ADDR,A
	MOV                 A,@0X56
	if                  USED_PID_FUNCTION
		OR              A,@0X80
	endif
	MOV                 VALUE,A
	CALL                WRITE_SPI_REG				;send SPI data to EM198810
	RET


;***********************************************************
; Function: Enter TX Direct NACK
; Input:    None
; Output:   None
;***********************************************************
Enter_TX_Direct_NACK:
	CALL                PAGE5BANK1
	MOV                 A,@0X00
	MOV                 ADDR,A
	MOV                 A,@0X85
	MOV                 VALUE,A
	CALL                WRITE_SPI_REG
	MOV                 A,@0X01
	MOV                 ADDR,A
	MOV                 A,@0X84
	MOV                 VALUE,A
	CALL                WRITE_SPI_REG
	MOV                 A,@0X41
	MOV                 ADDR,A
	MOV                 A,@0XBF
	MOV                 VALUE,A
	CALL                WRITE_SPI_REG
	MOV                 A,@0X40
	MOV                 ADDR,A
	MOV                 A,@0X52
	if                  USED_PID_FUNCTION
		OR              A,@0X80
	endif
	MOV                 VALUE,A
	CALL                WRITE_SPI_REG				;send SPI data to EM198810
	RET


;***********************************************************
; Function: Enter RX Buffered ACK
; Input:    None
; Output:   None
;***********************************************************
Enter_RX_Buffer_ACK:
	CALL                PAGE5BANK1
	MOV                 A,@0X00
	MOV                 ADDR,A
	MOV                 A,@0XE5
	MOV                 VALUE,A
	CALL                WRITE_SPI_REG
	MOV                 A,@0X01
	MOV                 ADDR,A
	MOV                 A,@0X84
	MOV                 VALUE,A
	CALL                WRITE_SPI_REG
	MOV                 A,@0X41
	MOV                 ADDR,A
	MOV                 A,@0XBF
	MOV                 VALUE,A
	CALL                WRITE_SPI_REG
	MOV                 A,@0X40
	MOV                 ADDR,A
	MOV                 A,@0X59
	if                  USED_PID_FUNCTION
		OR              A,@0X80
	endif
	MOV                 VALUE,A
	CALL                WRITE_SPI_REG				;send SPI data to EM198810
	NOP
	RET


;**********************************************************
; Function: Enter RX Buffered NACK
; Input:    None
; Output:   None
;***********************************************************
Enter_RX_Buffer_NACK:
	CALL                PAGE5BANK1
	MOV                 A,@0X00
	MOV                 ADDR,A
	MOV                 A,@0XE5
	MOV                 VALUE,A
	CALL                WRITE_SPI_REG
	MOV                 A,@0X01
	MOV                 ADDR,A
	MOV                 A,@0X84
	MOV                 VALUE,A
	CALL                WRITE_SPI_REG
	MOV                 A,@0X41
	MOV                 ADDR,A
	MOV                 A,@0XBF
	MOV                 VALUE,A
	CALL                WRITE_SPI_REG
	MOV                 A,@0X40
	MOV                 ADDR,A
	MOV                 A,@0X51
	if                  USED_PID_FUNCTION
		OR              A,@0X80
	endif
	MOV                 VALUE,A
	CALL                WRITE_SPI_REG				;send SPI data to EM198810
	RET


;***********************************************************
; Function: Enter RX Direct ACK
; Input:    None
; Output:   None
;***********************************************************
Enter_RX_Direct_ACK:
	CALL                PAGE5BANK1
	MOV                 A,@0X00
	MOV                 ADDR,A
	MOV                 A,@0X85
	MOV                 VALUE,A
	CALL                WRITE_SPI_REG
	MOV                 A,@0X01
	MOV                 ADDR,A
	MOV                 A,@0X84
	MOV                 VALUE,A
	CALL                WRITE_SPI_REG
	MOV                 A,@0X41
	MOV                 ADDR,A
	MOV                 A,@0XBF
	MOV                 VALUE,A
	CALL                WRITE_SPI_REG
	MOV                 A,@0X40
	MOV                 ADDR,A
	MOV                 A,@0X59
	if                  USED_PID_FUNCTION
		OR              A,@0X80
	endif
	MOV                 VALUE,A
	CALL                WRITE_SPI_REG				;send SPI data to EM198810
	RET


;**********************************************************
; Function: Enter RX Direct NACK
; Input:    None
; Output:   None
;***********************************************************
Enter_RX_Direct_NACK:
	CALL                PAGE5BANK1
	MOV                 A,@0X00
	MOV                 ADDR,A
	MOV                 A,@0X85
	MOV                 VALUE,A
	CALL                WRITE_SPI_REG
	MOV                 A,@0X01
	MOV                 ADDR,A
	MOV                 A,@0X84
	MOV                 VALUE,A
	CALL                WRITE_SPI_REG
	MOV                 A,@0X41
	MOV                 ADDR,A
	MOV                 A,@0XBF
	MOV                 VALUE,A
	CALL                WRITE_SPI_REG
	MOV                 A,@0X40
	MOV                 ADDR,A
	MOV                 A,@0X51
	if                  USED_PID_FUNCTION
		OR              A,@0X80
	endif
	MOV                 VALUE,A
	CALL                WRITE_SPI_REG				;send SPI data to EM198810
	RET


;***********************************************************
; Function: Enter StandbyI Mode
; Input:    None
; Output:   None
; description:
;***********************************************************
Enter_StandbyI_Mode:
	CALL                PAGE5BANK1
	MOV                 A,@0X00
	MOV                 ADDR,A
	MOV                 A,@0X65
	MOV                 VALUE,A
	CALL                WRITE_SPI_REG
	MOV                 A,@0X01
	MOV                 ADDR,A
	MOV                 A,@0X8C
	MOV                 VALUE,A
	CALL                WRITE_SPI_REG
	MOV                 A,@0X40
	MOV                 ADDR,A
	MOV                 A,@0X50
	if USED_PID_FUNCTION
		OR              A,@0X80
	endif
	MOV                 VALUE,A
	CALL                WRITE_SPI_REG				;send SPI data to EM198810
	RET


;***********************************************************
; Function: Enter StandbyII Mode
; Input:    None
; Output:   None
; description: auto enter
;***********************************************************
Enter_StandbyII_Mode:
	CALL                PAGE5BANK1
	MOV                 A,@0X00
	MOV                 ADDR,A
	MOV                 A,@0XE5
	MOV                 VALUE,A
	CALL                WRITE_SPI_REG
	MOV                 A,@0X01
	MOV                 ADDR,A
	MOV                 A,@0X84
	MOV                 VALUE,A
	CALL                WRITE_SPI_REG
	MOV                 A,@0X41
	MOV                 ADDR,A
	MOV                 A,@0XBF
	MOV                 VALUE,A
	CALL                WRITE_SPI_REG
	MOV                 A,@0X40
	MOV                 ADDR,A
	MOV                 A,@0X52
	if                  USED_PID_FUNCTION
		OR              A,@0X80
	endif
	MOV                 VALUE,A
	CALL                WRITE_SPI_REG				;send SPI data to EM198810
	RET


;===============================================
; Function: Enter Idle Mode
; Input:    None
; Output:   None
;===============================================
ENTER_IDLE_MODE:
	CALL                PAGE5BANK1
	MOV                 A,@0X00
	MOV                 ADDR,A
	MOV                 A,@0XC0
	MOV                 VALUE,A
	CALL                WRITE_SPI_REG				;send SPI data to EM198810
	MOV                 A,@0X01
	MOV                 ADDR,A
	MOV                 A,@0X8A
	MOV                 VALUE,A
	CALL                WRITE_SPI_REG
	CALL                PAGE5BANK0
	BC                  RESET_N/16,RESET_N%16
	CALL                PAGE5BANK1
	RET


;===============================================
; Function: RF Enter Sleep Mode
; Input:    ADDR,VALUE
; Output:   None
;===============================================
ENTER_RF_SLEEP:
	CALL                PAGE5BANK1
	MOV                 A,@0X00
	MOV                 ADDR,A
	MOV                 A,@0XE5
	MOV                 VALUE,A
	CALL                WRITE_SPI_REG
	NOP
	CALL                PAGE5BANK0
	BC                  RESET_N/16,RESET_N%16
	CALL                PAGE5BANK1
	RET


;===============================================
; Function: RF Wake Up
; Input:    None
; Output:   None
;===============================================
RF_WAKEUP:
	BS                  RESET_N/16,RESET_N%16
	MOV                 A,@0X00
	MOV                 ADDR,A
	MOV                 A, @0XE5
	MOV                 VALUE,A
	CALL                WRITE_SPI_REG
	MOV                 A,@0X0F
	CALL                DELAY_X100US
	RET


;===============================================
; Function: RF Channel Frequency Set
; Input:    TABLE_INDEX
; Output:   None
;===============================================
RF_FREQ_SET:
	CALL                PAGE5BANK1
	MOV                 A,@0X02
	MOV                 ADDR,A
	MOV                 A,CH_NO
	CALL                CH_TABLE
	MOV                 VALUE,A
	CALL                WRITE_SPI_REG
	RET


;===============================================
; Function: Read PKT Lost Count
; Input:    None
; Output:   PKT_Lost_Count
;===============================================
READ_PKTLOSTCNT:
	MOV                 A,@0X4F
	MOV                 ADDR,A
	CALL                READ_SPI_REG
	RET


;===============================================
; Function: Clr PKT Lost Count
; Input:    Zero
; Output:   None
;===============================================
CLR_PKTLOSTCNT:
	MOV                 A,@0X4F
	MOV                 ADDR,A
	MOV                 A,@0X00
	MOV                 VALUE,A
	CALL                WRITE_SPI_REG
	RET

;===============================================
; Function: Address change function
; Input:    RX_IDH,RX_IDL
; Output:   None
;===============================================
CHANGE_ADDRESS_VALUE:
	CALL                PAGE5BANK1
	MOV                 A,@0X51
	MOV                 ADDR,A
	MOV                 A,RX_IDH
	MOV                 VALUE,A
	CALL                WRITE_SPI_REG

	MOV                 A,@0X53
	MOV                 ADDR,A
	MOV                 A,RX_IDH
	MOV                 VALUE,A
	CALL                WRITE_SPI_REG

	MOV                 A,@0X50
	MOV                 ADDR,A
	MOV                 A,RX_IDL
	MOV                 VALUE,A
	CALL                WRITE_SPI_REG
/*
	MOV                 A,@0X52
	MOV                 ADDR,A
	MOV                 A,RX_IDL
	AND                 A,@0B11110000
	MOV                 VALUE,A
	INC                 VALUE         ; TX_ID1=(RX_IDL&0XF0)|0X01
	INC                 VALUE         ; TX_ID2=(RX_IDL&0XF0)|0X02
	CALL                WRITE_SPI_REG

	MOV                 A,@0X54
	MOV                 ADDR,A
	INC                 VALUE         ; TX_ID3=(RX_IDL&0XF0)|0X03
	CALL                WRITE_SPI_REG

	MOV                 A,@0X55
	MOV                 ADDR,A
	INC                 VALUE         ; TX_ID4=(RX_IDL&0XF0)|0X04
	CALL                WRITE_SPI_REG

	MOV                 A,@0X56
	MOV                 ADDR,A
	INC                 VALUE         ; TX_ID5=(RX_IDL&0XF0)|0X05
	CALL                WRITE_SPI_REG

	MOV                 A,@0X57
	MOV                 ADDR,A
	INC                 VALUE         ; TX_ID6=(RX_IDL&0XF0)|0X06
	CALL                WRITE_SPI_REG
*/	
	NOP
	RET
	NOP


;***********************************************************
; Function: RF RSSI Check the channel if is clean
; Input:    None
; Output:   None
;***********************************************************
RSSI_TEST_FUNCTION:        ; RF_RSSI_CHECK:
	CALL                Enter_RX_Buffer_NACK
	MOV                 A,@4
	MOV                 TEMP1,A
	CLR                 TEMP2

	;MOV                 A,@0X80      ; (test)P57 exchange when intrrupt
	;XOR                 PORT5,A
 
  Scan_Clean_Channel:
	CALL                PAGE5BANK1
	MOV                 A,@0X4B
	MOV                 ADDR,A
	CALL                READ_SPI_REG
	MOV                 A,VALUE
	ADD                 TEMP2,A
	DJZ                 TEMP1
	JMP                 Scan_Clean_Channel
	
	RRC                 TEMP2
	RRCA                TEMP2
	SUB                 A,@NoiseStrobe
	JBS                 STATUS,C
	JMP                 Exit_RSSI_Check

	CALL                PAGE5BANK1
	INC                 CH_NO
	MOV                 A,CH_NO
	SUB                 A,@ChannelSum
	JBS                 STATUS,C
	CLR                 CH_NO
	CALL                RF_FREQ_SET
	MOV                 A,@5
	CALL                DELAY_X100US
	NOP
	;MOV                 A,@0X80      ; (test)P57 exchange when intrrupt
	;XOR                 PORT5,A

	JMP                 Scan_Clean_Channel
  Exit_RSSI_Check:
	NOP
	RET
	NOP

;===============================================
; Function: Delay 20us
; Input:    None
; Output:   None
;===============================================
DELAY_X10US:
	MOV                 TEMP1,A
  Delay_Loop_X10US:
	MOV                 A,@8      ;
	MOV                 TEMP2,A
  Waiting_X10US:
	DJZ                 TEMP2
	JMP                 Waiting_X10US
	DJZ                 TEMP1
	JMP                 Delay_Loop_X10US
	RET
	NOP


;===============================================
; Function: Delay 100us
; Input:    None
; Output:   None
; CRYSTAL	   :  6MHZ
;===============================================
DELAY_X100US:
	MOV                 TEMP1,A
  Delay_Loop_X100US:
	MOV                 A,@100      ;
	MOV                 TEMP2,A
  Waiting_X100US:
	DJZ                 TEMP2
	JMP                 Waiting_X100US
	DJZ                 TEMP1
	JMP                 Delay_Loop_X100US
	RET


;===============================================
;test RF Register, if read==write test pass
;===============================================
TEST_INITIAL_RF:
  Analog_Reg_Test:
	MOV                 A,@0X07
	MOV                 ADDR,A
	MOV                 A,@0X58						;R7[6]=1
	MOV                 VALUE,A
	CALL                WRITE_SPI_REG
	NOP
	MOV                 A,@0X0E
	MOV                 ADDR,A
	MOV                 A,@0X11						;RE[7]=0
	MOV                 VALUE,A
	CALL                WRITE_SPI_REG
	NOP
	MOV                 A,@0X2E
	MOV                 ADDR,A
	MOV                 A,@0X23						;R2E[5]=1
	MOV                 VALUE,A
	CALL                WRITE_SPI_REG
	NOP
	MOV                 A,@0X0E
	MOV                 ADDR,A
	MOV                 A,@0X91						;RE[7]=1
	MOV                 VALUE,A
	CALL                WRITE_SPI_REG
	NOP
	CALL                Enter_RX_Buffer_ACK
	NOP
	MOV                 A,@8
	CALL                DELAY_X100US
	NOP
	MOV                 A,@0X4B
	MOV                 ADDR,A
	CALL                READ_SPI_REG
	NOP
	JBC                 VALUE,0					;R4B[0]:LD=1,Analog Reg Initial is OK
	JMP                 Digit_Reg_Test
	BS                  RFTestfailFlag/16,RFTestfailFlag%16
	JMP                 RF_TEST_RET
  Digit_Reg_Test:
	CLR                 TABLE_INDEX
  Check_Digit_Reg:
	MOV                 A,TABLE_INDEX
	CALL                RF_TABLE
	NOP
	MOV                 ADDR,A
	XOR                 A, @0XFF
	JBC                 STATUS,Z
	JMP                 RF_TEST_RET
	CALL                READ_SPI_REG
	NOP
	INC                 TABLE_INDEX
	MOV                 A,TABLE_INDEX
	CALL                RF_TABLE
	NOP
	XOR                 A,VALUE
	JBC                 STATUS,Z
	JMP                 RF_TABLE_INC
	BS                  RFTestfailFlag/16,RFTestfailFlag%16
	JMP                 RF_TEST_RET
  RF_TABLE_INC:
	INC                 TABLE_INDEX
	JMP                 Check_Digit_Reg
  RF_TEST_RET:
	RET


;=====================================================================
; BANK exchange function
;=====================================================================
PAGE5BANK0:
	BC        0X04,7
	BC        0X04,6
  RET
PAGE5BANK1:
	BC        0X04,7
	BS        0X04,6
  RET
PAGE5BANK2:
	BS        0X04,7
	BC        0X04,6
  RET
PAGE5BANK3:
	BS        0X04,7
	BS        0X04,6
  RET