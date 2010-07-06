;==================================================================
; Filename     :  EM78M611
; Author       :  yu.wei
; Company      :  ELAN
; VERSION      :  4.0
; CRYSTAL      :  6MHZ
; Creat date   :  2009/11/4
; tool ver.    :  eUIDE
; Description  :  modify for code conformity,multi-1v2 CMOS project
;  Description: PAGE0(0X0000-0X03FF): EM78M611 initial / EEprom setting / SYNC_COM_TX
;               PAGE1(0X0400-0X07FF): RX1_FUNCTION / RX2_FUNCTION / RX3_FUNCTION / RX4_FUNCTION
;               PAGE2(0X0800-0X0BFF): RX5_FUNCTION / RX6_FUNCTION / RX7_FUNCTION / RX8_FUNCTION
;               PAGE3(0X0C00-0X0FFF): Communicate_USB_Function table
;               PAGE4(0X1000-0X13FF): Communicate_USB_Function Function
;               PAGE5(0X1400-0X17FF): RF initial function

;==================================================================
M611rxP40.H                     EQU     M611rxP40.H


;--------------------------- function config ----------------------------
TCC_T_DEBUG                     EQU     1


;----------------------------------------------------------------------
RX1                             EQU     0     ; CHN_FLAG[0]
RX2                             EQU     1     ; CHN_FLAG[1]
RX3                             EQU     2
RX4                             EQU     3
RX5                             EQU     4
RX6                             EQU     5     ; CHN_FLAG[5]


;==================================================================
TEMP                            EQU     0X10        ; used for rock-bottom RF initial
TEMP1                           EQU     0X11        ; used for rock-bottom RF initial
TEMP2                           EQU     0X12        ; used for rock-bottom RF initial
TEMP3                           EQU     0X13        ; used for rock-bottom RF initial
TEMP4                           EQU     0X14        ; used for rock-bottom RF initial
TEMP5                           EQU     0X15        ;
TEMP6                           EQU     0X16        ;

SystemTimeCNT                   EQU     0X17
TABLE_INDEX                     EQU     0x18        ; descriptor table's start position
DataShiftCounter                EQU     0X19        ; data counter
DataByteLength                  EQU     0X1A		; READ/WRITE DATA LENGTH
ComuClock                       EQU     0X1B        ; Communication clock

TRANSFER                        EQU     0X1C		     ;
	JudgeHandFlag1              ==      TRANSFER*8+0    ; judge which hand send to host,BYTE0
	JudgeHandFlag2              ==      TRANSFER*8+1    ; judge which hand send to host,BYTE1
	JudgeHandFlag3              ==      TRANSFER*8+2    ; judge which hand send to host,BYTE2
	SetupDataStageFlag          ==      TRANSFER*8+3    ; select HID table 1
	TableSelectFlag1            ==      TRANSFER*8+4    ; select HID table 1
	TableSelectFlag2            ==      TRANSFER*8+5    ; select HID table 2
	TableSelectFlag3            ==      TRANSFER*8+6    ; select HID table 3
	UsbEP0interruptflag         ==      TRANSFER*8+7

GeneralStatusFlag1              EQU     0X1D
	RFInitialFailFlag           ==      GeneralStatusFlag1*8+7 ;
	RFInitialOKFlag             ==      GeneralStatusFlag1*8+6
	RFTestFailFlag              ==      GeneralStatusFlag1*8+5
	ReadLengthError             ==      GeneralStatusFlag1*8+4
	USBReportFinishFlag         ==      GeneralStatusFlag1*8+3   ; DESCRIPTOR FINISH(1) OR NOT(USB)
	;FRAMER_CONFIG_ERROR         ==      GeneralStatusFlag1*8+1 ; Framer Compare Bit Error Flag
	;RECEIVE_ERROR               ==      GeneralStatusFlag1*8+1 ; Judge Receive Register 64 Error Flag
	ModeSelectFlag              ==      GeneralStatusFlag1*8+0 ;1:analog  0:digital(default 0)


GeneralStatusFlag2              EQU     0X1F
	KeyScanFinishFlag           ==      GeneralStatusFlag2*8+3
	KeyStatusFlag               ==      GeneralStatusFlag2*8+2
	KeyScanStatusFlag           ==      GeneralStatusFlag2*8+1
	KeyScanInitFlag             ==      GeneralStatusFlag2*8+0

CommuStatusFlag                 EQU     0X1E
	MotorStatusFlag             ==      CommuStatusFlag*8+7
	FccTestModeFlag             ==      CommuStatusFlag*8+6
	ForceLinkModeFlag           ==      CommuStatusFlag*8+5   ; force link flag
	LinkModeFlag                ==      CommuStatusFlag*8+4   ; link flag
	EEpromWRStatusFlag          ==      CommuStatusFlag*8+3
	LoseFrameStatusFlag         ==      CommuStatusFlag*8+2   ; lose frequency and search mode flag
	NormalStatusFlag            ==      CommuStatusFlag*8+1   ; Normal mode Flag
	SearchStatusFlag            ==      CommuStatusFlag*8+0   ; Search mode flag


;-----------------------------------------------------------------------
SPIWB                           EQU     TEMP     ; SPI WRITE BYTE VALUE
SPIRB                           EQU     TEMP
r_acc1                          EQU     TEMP1    ; TEMP1 - TEMP5 used for EEPROM
r_acc2                          EQU     TEMP2
r_acc3                          EQU     TEMP3
DataAddressInMCU                EQU     TEMP4    ; 93C46
DataAddressInEEPROM             EQU     TEMP5

CMD_SELECT                      EQU     TEMP3
A_TEMP                          EQU     TEMP4    ; TEMP4 - TEMP6 used for PUSH and POP
RSR_TEMP                        EQU     TEMP5
STATUS_TEMP                     EQU     TEMP6


;==============================I/O Port Define==========================
SPI_MISO                        ==      PORT6*8+0   ;0
RESET_N                         ==      PORT6*8+1	;1
SPI_CLK                         ==      PORT6*8+2   ;2
SPI_MOSI                        ==      PORT6*8+3   ;3
SPI_SS                          ==      PORT6*8+4   ;4
FIFO_FLAG                       ==      PORT6*8+5   ;5
PKT_FLAG                        ==      PORT6*8+6   ;6

IIC_SCL                         ==      Port5*8+4
IIC_SDA                         ==      Port5*8+5
AT93C46_CS                      ==      Port5*8+6 ;4  93c46 enable select

Keystoke                        ==      Port9*8+2
LED1_STATUS                     ==      PORT9*8+3 ;LED


;============================================== BANK 0 ============================================
; bank0 20-3f used for data exchange section[Data Buffer]
; such as read or write EEPROM and RF,it used for data buffer
; sync timing:             RX_IDH,RX_IDL,CHN_FLAG,CommuStatusFlag,DirectionCtrl,CH_NO,TX1_ID,TX2_ID,TX3_ID,TX4_ID,TX5_ID,TX6_ID
; responses answer timing: RX_IDH,RX_IDL,CHN_FLAG,CommuStatusFlag,DirectionCtrl,CH_NO,TXx_ID
; responses data timing:   RX_IDH,RX_IDL,CHN_FLAG,CommuStatusFlag,DirectionCtrl,CH_NO,TXx_ID,data1,data2......data16,data17(version NO.)

;------------------------- Header code --------------------------------
PID_DATA_Buffer                 EQU     0X20 ; PID DATA, not used
RX_IDH_Buffer                   EQU     0X21 ; Master IDH
RX_IDL_Buffer                   EQU     0X22 ; Master IDL
CHN_FLAG_Buffer                 EQU     0X23 ; Channel flag, gamepad status
GamePadsSum_Buffer              EQU     0X24 ; Communication trsmitter direction
CommuStatusFlag_Buffer          EQU     0X25
CH_NO_Buffer                    EQU     0X26 ; N_CHN= ((TotalGamepads<<4) & 0xF0)|(CH_NO & 0x0F)

;-------------------------- search and connect ---------------------------
TX1_ID_Buffer                   EQU     0X27 ;
TX2_ID_Buffer                   EQU     0X28 ;
TX3_ID_Buffer                   EQU     0X29 ;
TX4_ID_Buffer                   EQU     0X2A ;
TX5_ID_Buffer                   EQU     0X2B ;
TX6_ID_Buffer                   EQU     0X2C ;
;---------------------------- receive data ----------------------------
TX_ID_Buffer                    EQU     0X27 ; repeat package data
DataA_Buffer                    EQU     0X28 ; rocker, left-x(left-right) data
DataB_Buffer                    EQU     0X29 ; rocker, left-y(up-down) data
DataC_Buffer                    EQU     0X2A ; rocker, right-x(left-right) data
DataD_Buffer                    EQU     0X2B ; rocker, right-y(up-down) data
DataE_Buffer                    EQU     0X2C ; A,B,C,D,L1,R1,L2,R2
DataF_Buffer                    EQU     0X2D ; Select,start,LSW,RSW,MODE,MACRO,TEST1,TEST2
DataG_Buffer                    EQU     0X2E ; 000:00¡¯001:45¡¯010:90¡¯011:135¡¯100:180¡¯101:225¡¯110:270¡¯111:315¡¯

CMOS_xAxisL_Buffer              EQU     0X2F
CMOS_yAxisL_Buffer              EQU     0X30
CMOS_yxsAxisH_Buffer            EQU     0X31

GS_xAxisL_Buffer                EQU     0X32
GS_yAxisL_Buffer                EQU     0X33
GS_zAxisL_Buffer                EQU     0X34
GS_xyzAxisH_Buffer              EQU     0X35
;--------------------------- Transmitter data --------------------------
MOTOR_ID_Buffer                 EQU     0X27
	Motor6CtrlFlag              ==      MOTOR_ID_Buffer*8+5
	Motor5CtrlFlag              ==      MOTOR_ID_Buffer*8+4
	Motor4CtrlFlag              ==      MOTOR_ID_Buffer*8+3
	Motor3CtrlFlag              ==      MOTOR_ID_Buffer*8+2
	Motor2CtrlFlag              ==      MOTOR_ID_Buffer*8+1
	Motor1CtrlFlag              ==      MOTOR_ID_Buffer*8+0
MOTOR1_VibrInten_Buffer         EQU     0X28    ; Motor1 vibration Intensity byte
MOTOR2_VibrInten_Buffer         EQU     0X29    ; Motor2 vibration Intensity byte
MOTOR3_VibrInten_Buffer         EQU     0X2A    ; Motor3 vibration Intensity byte
MOTOR4_VibrInten_Buffer         EQU     0X2B    ; Motor4 vibration Intensity byte
MOTOR5_VibrInten_Buffer         EQU     0X2C    ; Motor5 vibration Intensity byte
MOTOR6_VibrInten_Buffer         EQU     0X2D    ; Motor6 vibration Intensity byte

;------------------------ checksum -------------------------------------
ChecksumH                       EQU     0X3E
ChecksumL                       EQU     0X3F

;-------------------------------------------------------------------------
;----------------------- used for USB Command ----------------------------
BYTE0                           EQU     0X20
BYTE1                           EQU     0X21
BYTE2                           EQU     0X22
BYTE3                           EQU     0X23
BYTE4                           EQU     0X24
BYTE5                           EQU     0X25
BYTE6                           EQU     0X26
BYTE7                           EQU     0X27

EP1_ReportID                    EQU     0X30
PROTOCOL_TEMP                   EQU     0X31 ; BYTE 2 , (0)Boot Protocol,(1)Report Protocol
IDLE_TEMP                       EQU     0X32 ; BYTE 3
PC_WANT0                        EQU     0X33 ; BYTE 6
PC_WANT1                        EQU     0X34 ; BYTE 7
DataMaxTable1                   EQU     0X35 ; descriptor table's data length (table 1)
DataMaxTable2                   EQU     0X36 ; descriptor table's data length (table 2)
DataMaxTable3                   EQU     0X37 ; descriptor table's data length (table 3)


;========================= BANK 1 ============================================
PID_DATA                        EQU     0X20
RX_IDH                          EQU     0X21    ; master ID
RX_IDL                          EQU     0X22
CHN_FLAG                        EQU     0X23    ; Channel flag, gamepad status
GamepadsSum                     EQU     0X24    ; gamepads sum
CH_NO                           EQU     0X25    ; Current frequency table index
TX_ID                           EQU     0X26    ;

TX1_ID                          EQU     0X27     ;
TX2_ID                          EQU     0X28     ;
TX3_ID                          EQU     0X29     ;
TX4_ID                          EQU     0X2A     ;
TX5_ID                          EQU     0X2B     ;
TX6_ID                          EQU     0X2C     ;


FccFreqIndex                    EQU     0X2F
;----------------------------------------------------------------------
ADDR                            EQU     0X30 ;OUTPUT DATA ADDRESS
VALUE                           EQU     0X31 ;OUTPUT DATA HIGH
MOTOR_ID                        EQU     0X32
CHN_FLAG_TEMP                   EQU     0X33
RF_RSSI                         EQU     0X34

;       Click                     Dblclick                    Lasting_Press
;________    _______...__________    ______    _______...___________         ____________
;        |__|                    |__|      |__|                     |_______|
;___________                         _________                               ____________
;           |_______..._____________|         |________...__________________|

KeystokeFlag_Befor              EQU     0X35
KeySystemTimeCNT                EQU     0X36 ;
KeystokeTimeCNT                 EQU     0X37
KEY_NUM                         EQU     0X38
RX_ComuLoseCNT                  EQU     0X39
RX1_LossframeCNT                EQU     0X3A
RX2_LossframeCNT                EQU     0X3B
RX3_LossframeCNT                EQU     0X3C
RX4_LossframeCNT                EQU     0X3D
RX5_LossframeCNT                EQU     0X3E
RX6_LossframeCNT                EQU     0X3F


;========================= BANK 2 ====================================
TX1_DATA1                       EQU     0X20
TX1_DATA2                       EQU     0X21
TX1_DATA3                       EQU     0X22
TX1_DATA4                       EQU     0X23
TX1_DATA5                       EQU     0X24
TX1_DATA6                       EQU     0X25
TX1_DATA7                       EQU     0X26
TX1_DATA8                       EQU     0X27

TX1_CMOS_xAxisH                 EQU     0X30
TX1_CMOS_xAxisL                 EQU     0X31
TX1_CMOS_yAxisH                 EQU     0X32
TX1_CMOS_yAxisL                 EQU     0X33
TX1_CMOS_yxsAxisH               EQU     0X34

TX1_GS_xAxisH                   EQU     0X35
TX1_GS_xAxisL                   EQU     0X36
TX1_GS_yAxisH                   EQU     0X37
TX1_GS_yAxisL                   EQU     0X38
TX1_GS_zAxisH                   EQU     0X39
TX1_GS_zAxisL                   EQU     0X3A
TX1_GS_xyzAxisH                 EQU     0X3B

MOTOR1_VibrInten                EQU     0X3C
MOTOR1_VibrDuraH                EQU     0X3D
MOTOR1_VibrDuraL                EQU     0X3E

;========================= BANK 3 ====================================
TX2_DATA1                       EQU     0X20
TX2_DATA2                       EQU     0X21
TX2_DATA3                       EQU     0X22
TX2_DATA4                       EQU     0X23
TX2_DATA5                       EQU     0X24
TX2_DATA6                       EQU     0X25
TX2_DATA7                       EQU     0X26
TX2_DATA8                       EQU     0X27

TX2_CMOS_xAxisH                 EQU     0X30
TX2_CMOS_xAxisL                 EQU     0X31
TX2_CMOS_yAxisH                 EQU     0X32
TX2_CMOS_yAxisL                 EQU     0X33
TX2_CMOS_yxsAxisH               EQU     0X34

TX2_GS_xAxisH                   EQU     0X35
TX2_GS_xAxisL                   EQU     0X36
TX2_GS_yAxisH                   EQU     0X37
TX2_GS_yAxisL                   EQU     0X38
TX2_GS_zAxisH                   EQU     0X39
TX2_GS_zAxisL                   EQU     0X3A
TX2_GS_xyzAxisH                 EQU     0X3B

MOTOR2_VibrInten                EQU     0X3C
MOTOR2_VibrDuraH                EQU     0X3D
MOTOR2_VibrDuraL                EQU     0X3E




