;==================================================================
; Filename     :  EM78M611
; Author       :  yu.wei
; Company      :  ELAN
; VERSION      :  1.1
; CRYSTAL      :  8MHZ
; Creat date   :  2009/11/4
; tool ver.    :  eUIDE
; Description  :  modify for code conformity
;  Description: PAGE0(0X0000-0X03FF): EM78M611 initial / EEprom setting / SYNC_COM_TX
;               PAGE1(0X0400-0X07FF): RX1_FUNCTION / RX2_FUNCTION / RX3_FUNCTION / RX4_FUNCTION
;               PAGE2(0X0800-0X0BFF): RX5_FUNCTION / RX6_FUNCTION / RX7_FUNCTION / RX8_FUNCTION
;               PAGE3(0X0C00-0X0FFF): Communicate_USB_Function table
;               PAGE4(0X1000-0X13FF): Communicate_USB_Function Function
;               PAGE5(0X1400-0X17FF): RF initial function

;==================================================================
M611rxP40M1v6V10.H              EQU     M611rxP40M1v6V10.H


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
	JudgeHandFlag1              ==      TRANSFER*16+0    ; judge which hand send to host,BYTE0
	JudgeHandFlag2              ==      TRANSFER*16+1    ; judge which hand send to host,BYTE1
	JudgeHandFlag3              ==      TRANSFER*16+2    ; judge which hand send to host,BYTE2
	SetupDataStageFlag          ==      TRANSFER*16+3    ; select HID table 1
	TableSelectFlag1            ==      TRANSFER*16+4    ; select HID table 1
	TableSelectFlag2            ==      TRANSFER*16+5    ; select HID table 2
	TableSelectFlag3            ==      TRANSFER*16+6    ; select HID table 3
	UsbEP0interruptflag         ==      TRANSFER*16+7	

GeneralStatusFlag1              EQU     0X1D
	RFInitialFailFlag           ==      GeneralStatusFlag1*16+7 ; 
	RFInitialOKFlag             ==      GeneralStatusFlag1*16+6
	RFTestFailFlag              ==      GeneralStatusFlag1*16+5
	ModeSelectFlag              ==      GeneralStatusFlag1*16+0 ;1:analog  0:digital(default 0)


GeneralStatusFlag               EQU     0X1F
	ReadLengthError             ==      GeneralStatusFlag*16+7
	KeyScanStatusFlag           ==      GeneralStatusFlag*16+6	
	KeyStatusFlag               ==      GeneralStatusFlag*16+5	
	KeyScanFinishFlag           ==      GeneralStatusFlag*16+4
	
	FRAMER_CONFIG_ERROR         ==      GeneralStatusFlag*16+0 ; Framer Compare Bit Error Flag
	RECEIVE_ERROR               ==      GeneralStatusFlag*16+0 ; Judge Receive Register 64 Error Flag

CommuStatusFlag                 EQU     0X1E
;SearchStatusFlag,NormalStatusFlag,LoseFreqStatusFlag,LoseFrameStatusFlag is used for working status
;LinkModeFlag,ForceLinkModeFlag,FccTestModeFlag is used for check master ID and FCC test
	DescriptorFinishFlag        ==      CommuStatusFlag*16+7   ; DESCRIPTOR FINISH(1) OR NOT(USB)
	FccTestModeFlag             ==      CommuStatusFlag*16+6
	ForceLinkModeFlag           ==      CommuStatusFlag*16+5   ; force link flag
	LinkModeFlag                ==      CommuStatusFlag*16+4   ; link flag
	EEpromWRStatusFlag          ==      CommuStatusFlag*16+3
	LoseFrameStatusFlag         ==      CommuStatusFlag*16+2   ; lose frequency and search mode flag
	NormalStatusFlag            ==      CommuStatusFlag*16+1   ; Normal mode Flag
	SearchStatusFlag            ==      CommuStatusFlag*16+0   ; Search mode flag


;-----------------------------------------------------------------------
SPIWB                           EQU     TEMP     ; SPI WRITE BYTE VALUE
SPIRB                           EQU     TEMP
r_acc1                          EQU     TEMP1    ; TEMP1 - TEMP5 used for eeprom
r_acc2                          EQU     TEMP2
r_acc3                          EQU     TEMP3
DataAddressInMCU                EQU     TEMP4    ; 93C46
DataAddressInEEPROM             EQU     TEMP5

CMD_SELECT                      EQU     TEMP3
A_TEMP                          EQU     TEMP4    ; TEMP4 - TEMP6 used for PUSH and POP
RSR_TEMP                        EQU     TEMP5
STATUS_TEMP                     EQU     TEMP6


;==============================I/O Port Define==========================
SPI_MISO                        ==      PORT6*16+0   ;0
RESET_N                         ==      PORT6*16+1	;1
SPI_CLK                         ==      PORT6*16+2   ;2
SPI_MOSI                        ==      PORT6*16+3   ;3
SPI_SS                          ==      PORT6*16+4   ;4
FIFO_FLAG                       ==      PORT6*16+5   ;5
PKT_FLAG                        ==      PORT6*16+6   ;6

IIC_SCL                         ==      Port5*16+4
IIC_Sda                         ==      Port5*16+5
AT93C46_CS                      ==      Port5*16+6 ;4  93c46 enable select

Keystoke                        ==      Port9*16+2
LED1_STATUS                     ==      PORT9*16+3 ;LED


;============================================== BANK 0 ============================================
; bank0 20-3f used for data exchange section[Data Buffer]
; such as read or write EEPROM and RF,it used for data buffer
; sync timing:             RX_IDH,RX_IDL,CHN_FLAG,CommuStatusFlag,DirectionCtrl,CH_NO,TX1_ID,TX2_ID,TX3_ID,TX4_ID,TX5_ID,TX6_ID
; responses answer timing: RX_IDH,RX_IDL,CHN_FLAG,CommuStatusFlag,DirectionCtrl,CH_NO,TXx_ID
; responses data timing:   RX_IDH,RX_IDL,CHN_FLAG,CommuStatusFlag,DirectionCtrl,CH_NO,TXx_ID,data1,data2......data16,data17(version NO.)

;------------------------ used for RF communicate --------------------
PID_DATA_Buffer         EQU     0X20    ; PID DATARX_IDH_Buffer           EQU     0X20    ; master ID
RX_IDH_Buffer           EQU     0X21    ; master ID
RX_IDL_Buffer           EQU     0X22
CHN_FLAG_Buffer         EQU     0X23    ; Channel flag, gamepad status
CommuStatusFlag_Buffer  EQU     0X24
DirectionCtrl_Buffer    EQU     0X25    ; Communication trsmitter direction
N_CHN_Buffer            EQU     0X26    ; N_CHN= ((TotalGamepads<<4) & 0xF0)|(CH_NO & 0x0F)
TX_ID_Buffer            EQU     0X26    ; repeat package data

TX1_ID_Buffer           EQU     0X27     ;
TX2_ID_Buffer           EQU     0X28     ;
TX3_ID_Buffer           EQU     0X29     ;
TX4_ID_Buffer           EQU     0X2A     ;
TX5_ID_Buffer           EQU     0X2B     ;
TX6_ID_Buffer           EQU     0X2C     ;

;--------------------------------------------------------
DataA_Buffer            EQU     0X27 ;rocker, left-x(left-right) data
DataB_Buffer            EQU     0X28 ;rocker, left-y(up-down) data
DataC_Buffer            EQU     0X29 ;rocker, right-x(left-right) data
DataD_Buffer            EQU     0X2A ;rocker, right-y(up-down) data
DataE_Buffer            EQU     0X2B ;A,B,C,D,L1,R1,L2,R2
DataF_Buffer            EQU     0X2C ;Select,start,LSW,RSW,MODE,MACRO,TEST1,TEST2
DataG_Buffer            EQU     0X2D ;000:45¡¯ 001:90¡¯ 010:135¡¯ 011:180¡¯ 100:225¡¯ 101:270¡¯ 110:315¡¯

;--------------------------------------------------------
GS_XPoint_LOW_Buffer    EQU     0X30
GS_YPoint_LOW_Buffer    EQU     0X31
GS_ZPoint_LOW_Buffer    EQU     0X32
GS_Point_HIGH_Buffer    EQU     0X33
CMOS_XPoint_LOW_Buffer  EQU     0X34
CMOS_YPoint_LOW_Buffer  EQU     0X35
CMOS_Point_HIGH_Buffer  EQU     0X36

GS_XPoint_LOW           EQU     0X39
GS_YPoint_LOW           EQU     0X3A
GS_ZPoint_LOW           EQU     0X3B
GS_Point_HIGH           EQU     0X3C
CMOS_XPoint_LOW         EQU     0X3D
CMOS_YPoint_LOW         EQU     0X3E
CMOS_Point_HIGH         EQU     0X3F

;----------------------- used for USB Command ----------------------------
BYTE0                   EQU     0X20
BYTE1                   EQU     0X21
BYTE2                   EQU     0X22
BYTE3                   EQU     0X23
BYTE4                   EQU     0X24
BYTE5                   EQU     0X25
BYTE6                   EQU     0X26
BYTE7                   EQU     0X27


PROTOCOL_TEMP           EQU     0X39                ; BYTE 2 , (0)Boot Protocol,(1)Report Protocol
IDLE_TEMP               EQU     0X3A                ; BYTE 3
PC_WANT0                EQU     0X3B                ; BYTE 6
PC_WANT1                EQU     0X3C                ; BYTE 7

DataMaxTable1           EQU     0X3D                ; descriptor table's data length (table 1)
DataMaxTable2           EQU     0X3E                ; descriptor table's data length (table 2)
DataMaxTable3           EQU     0X3F                ; descriptor table's data length (table 3)

;============================================== BANK 1 ============================================
PID_DATA                EQU     0X20    ; PID DATA
RX_IDH                  EQU     0X21    ; master ID
RX_IDL                  EQU     0X22
CHN_FLAG                EQU     0X23    ; Channel flag, gamepad status
DirectionCtrl           EQU     0X24    ; Communication trsmitter direction
N_CHN                   EQU     0X25    ; N_CHN= ((TotalGamepads<<4) & 0xF0)|(CH_NO & 0x0F)
TX_ID                   EQU     0X26     ;
TX1_ID                  EQU     0X27     ;
TX2_ID                  EQU     0X28     ;
TX3_ID                  EQU     0X29     ;
TX4_ID                  EQU     0X2A     ;
TX5_ID                  EQU     0X2B     ;
TX6_ID                  EQU     0X2C     ;


CHN_FLAG_TEMP           EQU     0X2E
FccFreqIndex            EQU     0X2F
;----------------------------------------------------------------------
ADDR                    EQU     0X30 ;OUTPUT DATA ADDRESS
VALUE                   EQU     0X31 ;OUTPUT DATA HIGH
CH_NO                   EQU     0X33

RF_RSSI                 EQU     0X34
KeystokeFlag_Befor      EQU     0X35 ;       Click                     Dblclick                    Lasting_Press
KeystokeTimeCNT         EQU     0X36
                                     ;________    _______.__________    ______    _______.___________         ____________
                                     ;        |__|                  |__|      |__|                   |_______|
KEY_NUM                 EQU     0X37
                                     ;___________                       _________                             ____________
                                     ;           |_______._____________|         |________.__________________|
RX1_LossframeCNT        EQU     0X38
RX2_LossframeCNT        EQU     0X39
RX3_LossframeCNT        EQU     0X3A
RX4_LossframeCNT        EQU     0X3B
RX5_LossframeCNT        EQU     0X3C
RX6_LossframeCNT        EQU     0X3D



;============================================== BANK 2 ============================================
TX1_DATA1               EQU     0X20
TX1_DATA2               EQU     0X21
TX1_DATA3               EQU     0X22
TX1_DATA4               EQU     0X23
TX1_DATA5               EQU     0X24
TX1_DATA6               EQU     0X25
TX1_DATA7               EQU     0X26
TX1_DATA8               EQU     0X27
;------------------------------------------------------------
TX2_DATA1               EQU     0X28    ; sensor x-axis
TX2_Data2               EQU     0X29
TX2_DATA3               EQU     0X2A    ; sensor y-axis
TX2_DATA4               EQU     0X2B
TX2_DATA5               EQU     0X2C    ; sensor z-axis
TX2_DATA6               EQU     0X2D
TX2_DATA7               EQU     0X2E
TX2_DATA8               EQU     0X2F
;------------------------------------------------------------
TX3_DATA1               EQU     0X30
TX3_DATA2               EQU     0X31
TX3_DATA3               EQU     0X32
TX3_DATA4               EQU     0X33
TX3_DATA5               EQU     0X34
TX3_DATA6               EQU     0X35
TX3_DATA7               EQU     0X36
TX3_DATA8               EQU     0X37
;------------------------------------------------------------
TX4_DATA1               EQU     0X38    ; sensor x-axis
TX4_DATA2               EQU     0X39
TX4_DATA3               EQU     0X3A    ; sensor y-axis
TX4_DATA4               EQU     0X3B
TX4_DATA5               EQU     0X3C    ; sensor z-axis
TX4_DATA6               EQU     0X3D
TX4_DATA7               EQU     0X3E
TX4_DATA8               EQU     0X3F

;============================================== BANK 3 ============================================
TX5_DATA1               EQU     0X20
TX5_DATA2               EQU     0X21
TX5_DATA3               EQU     0X22
TX5_DATA4               EQU     0X23
TX5_DATA5               EQU     0X24
TX5_DATA6               EQU     0X25
TX5_DATA7               EQU     0X26
TX5_DATA8               EQU     0X27
;------------------------------------------------------------
TX6_DATA1               EQU     0X28    ; sensor x-axis
TX6_DATA2               EQU     0X29
TX6_DATA3               EQU     0X2A    ; sensor y-axis
TX6_DATA4               EQU     0X2B
TX6_DATA5               EQU     0X2C    ; sensor z-axis   ;flash byte 1
TX6_DATA6               EQU     0X2D                      ;flash byte 2
TX6_DATA7               EQU     0X2E                      ;flash byte 3
TX6_DATA8               EQU     0X2F                      ;flash byte 4
;--------------------------------------------------------
TX7_DATA1               EQU     0X30
TX7_DATA2               EQU     0X31
TX7_DATA3               EQU     0X32
TX7_DATA4               EQU     0X33
TX7_DATA5               EQU	    0X34
TX7_DATA6               EQU     0X35
TX7_DATA7               EQU     0X26
TX7_DATA8               EQU     0X37
;------------------------------------------------------------
TX8_DATA1               EQU     0X38    ; sensor x-axis
TX8_DATA2               EQU     0X39
TX8_DATA3               EQU     0X3A    ; sensor y-axis
TX8_DATA4               EQU     0X3B
TX8_DATA5               EQU	    0X3C    ; sensor z-axis
TX8_DATA6               EQU     0X3D
TX8_DATA7               EQU     0X2E
TX8_DATA8               EQU     0X3F
