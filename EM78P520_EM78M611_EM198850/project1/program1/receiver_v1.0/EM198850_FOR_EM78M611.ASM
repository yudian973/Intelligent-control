;==================================================================
;  Tilte:        EM78M198850 driver ;
;  NAME:         EM198810_FOR_EM78M611.ASM
;  Description:  The Definition of EM78M198810 for EM78611 Registers ;
;  Company:      Elan Electronic Corp. ;
;  Author:       YU.WEI ;
;  Date:         2009.09.28 ;
;  Version:      v1.0 ;
;  Tool:         wiceplus 2.7
;===================================================================

include	"EM198850_For_EM78M611.H"

	ORG                 0X1400    ;PAGE 5
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
	RETL                @29        ;freq:2431 ;@0X1D
	RETL                @4         ;freq:2406 ;@0X04
	RETL                @67        ;freq:2469 ;@0X43
	RETL                @32        ;freq:2434 ;@0X20

	RETL                @7         ;freq:2409 ;@0X07
	RETL                @65        ;freq:2467 ;@0X41
	RETL                @36        ;freq:2438 ;@0X24
	RETL                @10        ;freq:2412 ;@0X0A

	RETL                @62        ;freq:2464 ;@0X3E
	RETL                @38        ;freq:2440 ;@0X26
	RETL                @8         ;freq:2410 ;@0X08
	RETL                @59        ;freq:2461 ;@0X3B

	RETL                @45        ;freq:2447 ;@0X2D
	RETL                @12        ;freq:2414 ;@0X0C
	RETL                @76        ;freq:2478 ;@0X4C
	RETL                @40        ;freq:2442 ;@0X28

EM198850_RESET:
	CALL                PAGE5BANK1
	BC                  RESET_N/16,RESET_N%16
	MOV                 A,@3
	CALL                DELAY_X100US
	BS                  RESET_N/16,RESET_N%16
	MOV                 A,@10
	CALL                DELAY_X100US
	BC                  RFTestfailFlag/16,RFTestfailFlag%16
	CALL                INIT_FRAMEREG
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
	CALL                WRITE_SPI_REG
	NOP
	INC                 TABLE_INDEX
	JMP                 Set_FrameReg
  Set_Framereg_End:
	NOP
	RET
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
WRITE_SPI_REG:
	CALL                PAGE5BANK0
	BC                  SPI_SS/16,SPI_SS%16
	CALL                PAGE5BANK1
	MOV                 A,ADDR
	CALL                SIM_SPI_WRITE
	MOV                 A,VALUE
	CALL                SIM_SPI_WRITE
	BC                  SPI_CLK/16,SPI_CLK%16
	NOP
	BS                  SPI_SS/16,SPI_SS%16
	RET
READ_SPI_REG:
	CALL                PAGE5BANK1
	BC                  SPI_SS/16,SPI_SS%16
	MOV                 A,ADDR
	OR                  A,@0X80
	CALL                SIM_SPI_WRITE
	NOP
	CALL                SIM_SPI_READ
	MOV                 VALUE,A
	BC                  SPI_CLK/16,SPI_CLK%16
	NOP
	BS                  SPI_SS/16,SPI_SS%16
	RET
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
READ_FIFO_RAM:
	MOV                 A,@RX_BUF
	MOV                 RSR,A
	NOP
	NOP
	BC                  SPI_SS/16,SPI_SS%16
	MOV                 A,@0XFF
	CALL                SIM_SPI_WRITE
	NOP
	NOP
	MOV                 A,@PKT_LEN
	MOV                 DataByteLength,A
  Read_FIFO_Loop:
	CALL                SIM_SPI_READ
	MOV                 R0, A
	INC                 RSR
	DJZ                 DataByteLength
	JMP                 Read_FIFO_Loop
	NOP
	BS                  SPI_SS/16,SPI_SS%16
	RET
WRITE_FIFO_RAM:
	BC                  SPI_SS/16,SPI_SS%16
	MOV                 A,@0X7F
	CALL                SIM_SPI_WRITE
	NOP
	MOV                 A,@PKT_LEN
	MOV                 DataByteLength,A
	MOV                 A,@TX_BUF
	MOV                 RSR,A
 Write_FIFO_Loop:
	MOV                 A,R0
	CALL                SIM_SPI_WRITE
	NOP
	INC                 RSR
	DJZ                 DataByteLength
	JMP                 Write_FIFO_Loop
	BS                  SPI_SS/16,SPI_SS%16
	JBS                 PKT_FLAG/16,PKT_FLAG%16
	JMP                 $-1
	RET
RESET_RF_FIFO:
	CALL                PAGE5BANK1
	MOV                 A,@0X4D
	MOV                 ADDR,A
	MOV                 A,@0X01
	MOV                 VALUE,A
	CALL                WRITE_SPI_REG
	MOV                 A,@0X02
	CALL                DELAY_X100US
	RET
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
	MOV                 A,@0X5E
	if                  USED_PID_FUNCTION
		OR              A,@0X80
	endif
	MOV                 VALUE,A
	CALL                WRITE_SPI_REG
	RET
Enter_TX_Buffer_NACK:
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
	CALL                WRITE_SPI_REG
	RET
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
	MOV                 A,@0X5E
	if                  USED_PID_FUNCTION
		OR              A,@0X80
	endif
	MOV                 VALUE,A
	CALL                WRITE_SPI_REG
	RET
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
	MOV                 A,@0X56
	if                  USED_PID_FUNCTION
		OR              A,@0X80
	endif
	MOV                 VALUE,A
	CALL                WRITE_SPI_REG
	RET
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
	MOV                 A,@0X5D
	if                  USED_PID_FUNCTION
		OR              A,@0X80
	endif
	MOV                 VALUE,A
	CALL                WRITE_SPI_REG
	NOP
	RET
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
	MOV                 A,@0X55
	if                  USED_PID_FUNCTION
		OR              A,@0X80
	endif
	MOV                 VALUE,A
	CALL                WRITE_SPI_REG
	RET
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
	MOV                 A,@0X5D
	if                  USED_PID_FUNCTION
		OR              A,@0X80
	endif
	MOV                 VALUE,A
	CALL                WRITE_SPI_REG
	RET
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
	MOV                 A,@0X55
	if                  USED_PID_FUNCTION
		OR              A,@0X80
	endif
	MOV                 VALUE,A
	CALL                WRITE_SPI_REG
	RET
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
	CALL                WRITE_SPI_REG
	RET

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
	CALL                WRITE_SPI_REG
	RET
ENTER_IDLE_MODE:
	CALL                PAGE5BANK1
	MOV                 A,@0X00
	MOV                 ADDR,A
	MOV                 A,@0XC0
	MOV                 VALUE,A
	CALL                WRITE_SPI_REG
	MOV                 A,@0X01
	MOV                 ADDR,A
	MOV                 A,@0X8A
	MOV                 VALUE,A
	CALL                WRITE_SPI_REG
	CALL                PAGE5BANK0
	BC                  RESET_N/16,RESET_N%16
	CALL                PAGE5BANK1
	RET
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
RF_FREQ_SET:
	CALL                PAGE5BANK1
	MOV                 A,@0X02
	MOV                 ADDR,A
	MOV                 A,CH_NO
	CALL                CH_TABLE
	MOV                 VALUE,A
	CALL                WRITE_SPI_REG
	RET
Read_PKT_LOST_CNT:
	MOV                 A,@0X4F
	MOV                 ADDR,A
	CALL                READ_SPI_REG
	RET
CLR_PKT_LOST_CNT:
	MOV                 A,@0X4F
	MOV                 ADDR,A
	MOV                 A,@0X00
	MOV                 VALUE,A
	CALL                WRITE_SPI_REG
	RET
CHANGE_TO_INQ_VALUE:
	CALL                PAGE5BANK1
	MOV                 A,@0X41
	MOV                 ADDR,A
	MOV                 A,@0B10111111
	MOV                 VALUE,A
	CALL                WRITE_SPI_REG
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
	MOV                 A,RX_IDL
	AND                 A,@0B11110000
	MOV                 TX_ID,A
	INC                 TX_ID
	MOV                 A,@0X50
	MOV                 ADDR,A
	MOV                 A,TX_ID
	ADD                 A,@0
	MOV                 VALUE,A
	CALL                WRITE_SPI_REG

	MOV                 A,@0X52
	MOV                 ADDR,A
	MOV                 A,TX_ID
	ADD                 A,@1
	MOV                 VALUE,A
	CALL                WRITE_SPI_REG
	MOV                 A,@0X54
	MOV                 ADDR,A
	MOV                 A,TX_ID
	ADD                 A,@2
	MOV                 VALUE,A
	CALL                WRITE_SPI_REG
	MOV                 A,@0X55
	MOV                 ADDR,A
	MOV                 A,TX_ID
	ADD                 A,@3
	MOV                 VALUE,A
	CALL                WRITE_SPI_REG
	MOV                 A,@0X56
	MOV                 ADDR,A
	MOV                 A,TX_ID
	ADD                 A,@4
	MOV                 VALUE,A
	CALL                WRITE_SPI_REG
	MOV                 A,@0X57
	MOV                 ADDR,A
	MOV                 A,TX_ID
	ADD                 A,@5
	MOV                 VALUE,A
	CALL                WRITE_SPI_REG
	RET
DELAY_X100US:
	MOV                 TEMP1,A
  Delay_Loop:
	MOV                 A,@0X62      ;
	MOV                 TEMP2,A
  Waiting:
	DJZ                 TEMP2
	JMP                 Waiting
	DJZ                 TEMP1
	JMP                 Delay_Loop
	RET
TEST_INITIAL_RF:
  Analog_Reg_Test:
	MOV                 A,@0X07
	MOV                 ADDR,A
	MOV                 A,@0X58
	MOV                 VALUE,A
	CALL                WRITE_SPI_REG
	NOP
	MOV                 A,@0X0E
	MOV                 ADDR,A
	MOV                 A,@0X11
	MOV                 VALUE,A
	CALL                WRITE_SPI_REG
	NOP
	MOV                 A,@0X2E
	MOV                 ADDR,A
	MOV                 A,@0X23
	MOV                 VALUE,A
	CALL                WRITE_SPI_REG
	NOP
	MOV                 A,@0X0E
	MOV                 ADDR,A
	MOV                 A,@0X91
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
	JBC                 VALUE,0
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