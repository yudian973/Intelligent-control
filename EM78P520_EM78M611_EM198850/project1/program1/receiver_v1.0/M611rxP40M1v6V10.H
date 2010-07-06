;==================================================================
;  Tilte:       EM78M198810 include file		;
;  NAME:        RF_EM78M612_RECEIVE.H
;  Description: 
;  Company:     Elan Electronic Corp.		;
;  Author:      YU.WEI				;
;  Date:        2009.02.26			;
;  Version:     v1.0				;
;  Tool:        wiceplus 2.7

;==================================================================
M611rxP40M1v6V10.H              EQU     M611rxP40M1v6V10.H


;==================================================================
TEMP                            EQU     0X10       
TEMP1                           EQU     0X11        
TEMP2                           EQU     0X12        
TEMP3                           EQU     0X13       
TEMP4                           EQU     0X14       
TEMP5                           EQU     0X15        ;
TEMP6                           EQU     0X16        ;
SystemTimeCNT                   EQU     0X17
TABLE_INDEX                     EQU     0x18       
DataShiftCounter                EQU     0X19        
DataByteLength                  EQU     0X1A		
ComuClock                       EQU     0X1B        
TRANSFER                        EQU     0X1C		     ;
	JudgeHandFlag1              ==      TRANSFER*16+0    
	JudgeHandFlag2              ==      TRANSFER*16+1   
	JudgeHandFlag3              ==      TRANSFER*16+2   
	SetupDataStageFlag          ==      TRANSFER*16+3   
	TableSelectFlag1            ==      TRANSFER*16+4    
	TableSelectFlag2            ==      TRANSFER*16+5   
	TableSelectFlag3            ==      TRANSFER*16+6    
GeneralStatusFlag1              EQU     0X1D
	RFInitialFailFlag           ==      GeneralStatusFlag1*16+7 ; 
	RFInitialOKFlag             ==      GeneralStatusFlag1*16+6
	RFTestFailFlag              ==      GeneralStatusFlag1*16+5
GeneralStatusFlag               EQU     0X1F
	ReadLengthError             ==      GeneralStatusFlag*16+7
	KeyScanStatusFlag           ==      GeneralStatusFlag*16+6	
	KeyStatusFlag               ==      GeneralStatusFlag*16+5	
	KeyScanFinishFlag           ==      GeneralStatusFlag*16+4
	UsbEP0interruptflag         ==      GeneralStatusFlag*16+1	
	FRAMER_CONFIG_ERROR         ==      GeneralStatusFlag*16+0 ;
	RECEIVE_ERROR               ==      GeneralStatusFlag*16+0 
CommuStatusFlag                 EQU     0X1E
	DescriptorFinishFlag        ==      CommuStatusFlag*16+7   
	FccTestModeFlag             ==      CommuStatusFlag*16+6
	ForceLinkModeFlag           ==      CommuStatusFlag*16+5  
	LinkModeFlag                ==      CommuStatusFlag*16+4   ;
	EEpromWRStatusFlag          ==      CommuStatusFlag*16+3
	LoseFrameStatusFlag         ==      CommuStatusFlag*16+2   ;
	NormalStatusFlag            ==      CommuStatusFlag*16+1   ;
	SearchStatusFlag            ==      CommuStatusFlag*16+0   
SPIWB                           EQU     TEMP     
SPIRB                           EQU     TEMP
r_acc1                          EQU     TEMP1    
r_acc2                          EQU     TEMP2
r_acc3                          EQU     TEMP3
DataAddressInMCU                EQU     TEMP4    
DataAddressInEEPROM             EQU     TEMP5
CMD_SELECT                      EQU     TEMP3
A_TEMP                          EQU     TEMP4    
RSR_TEMP                        EQU     TEMP5
STATUS_TEMP                     EQU     TEMP6
SPI_MISO                        ==      PORT6*16+0  
RESET_N                         ==      PORT6*16+1	
SPI_CLK                         ==      PORT6*16+2   ;2
SPI_MOSI                        ==      PORT6*16+3   ;3
SPI_SS                          ==      PORT6*16+4   ;4
FIFO_FLAG                       ==      PORT6*16+5   ;5
PKT_FLAG                        ==      PORT6*16+6   ;6
IIC_SCL                         ==      Port5*16+4
IIC_Sda                         ==      Port5*16+5
AT93C46_CS                      ==      Port5*16+6 ;
Keystoke                        ==      Port9*16+2
LED1_STATUS                     ==      PORT9*16+3 
PID_DATA_Buffer         EQU     0X20    
RX_IDH_Buffer           EQU     0X21    
RX_IDL_Buffer           EQU     0X22
CHN_FLAG_Buffer         EQU     0X23    
CommuStatusFlag_Buffer  EQU     0X24
DirectionCtrl_Buffer    EQU     0X25    
N_CHN_Buffer            EQU     0X26   
TX_ID_Buffer            EQU     0X26    

TX1_ID_Buffer           EQU     0X27     ;
TX2_ID_Buffer           EQU     0X28     ;
TX3_ID_Buffer           EQU     0X29     ;
TX4_ID_Buffer           EQU     0X2A     ;
TX5_ID_Buffer           EQU     0X2B     ;
TX6_ID_Buffer           EQU     0X2C     ;
DataA_Buffer            EQU     0X27 
DataB_Buffer            EQU     0X28 
DataC_Buffer            EQU     0X29 
DataD_Buffer            EQU     0X2A 
DataE_Buffer            EQU     0X2B 
DataF_Buffer            EQU     0X2C 
DataG_Buffer            EQU     0X2D 
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
BYTE0                   EQU     0X20
BYTE1                   EQU     0X21
BYTE2                   EQU     0X22
BYTE3                   EQU     0X23
BYTE4                   EQU     0X24
BYTE5                   EQU     0X25
BYTE6                   EQU     0X26
BYTE7                   EQU     0X27
PROTOCOL_TEMP           EQU     0X39               
IDLE_TEMP               EQU     0X3A               
PC_WANT0                EQU     0X3B                
PC_WANT1                EQU     0X3C              
DataMaxTable1           EQU     0X3D               
DataMaxTable2           EQU     0X3E               
DataMaxTable3           EQU     0X3F               
PID_DATA                EQU     0X20    
RX_IDH                  EQU     0X21    
RX_IDL                  EQU     0X22
CHN_FLAG                EQU     0X23   
DirectionCtrl           EQU     0X24   
N_CHN                   EQU     0X25    
TX_ID                   EQU     0X26     ;
TX1_ID                  EQU     0X27     ;
TX2_ID                  EQU     0X28     ;
TX3_ID                  EQU     0X29     ;
TX4_ID                  EQU     0X2A     ;
TX5_ID                  EQU     0X2B     ;
TX6_ID                  EQU     0X2C     ;
CHN_FLAG_TEMP           EQU     0X2E
FccFreqIndex            EQU     0X2F
ADDR                    EQU     0X30
VALUE                   EQU     0X31 
CH_NO                   EQU     0X33
RF_RSSI                 EQU     0X34
KeystokeFlag_Befor      EQU     0X35 
KeystokeTimeCNT         EQU     0X36                                     
KEY_NUM                 EQU     0X37
RX1_LossframeCNT        EQU     0X38
RX2_LossframeCNT        EQU     0X39
RX3_LossframeCNT        EQU     0X3A
RX4_LossframeCNT        EQU     0X3B
RX5_LossframeCNT        EQU     0X3C
RX6_LossframeCNT        EQU     0X3D
TX1_DATA1               EQU     0X20
TX1_DATA2               EQU     0X21
TX1_DATA3               EQU     0X22
TX1_DATA4               EQU     0X23
TX1_DATA5               EQU     0X24
TX1_DATA6               EQU     0X25
TX1_DATA7               EQU     0X26
TX1_DATA8               EQU     0X27
TX2_DATA1               EQU     0X28  
TX2_Data2               EQU     0X29
TX2_DATA3               EQU     0X2A   
TX2_DATA4               EQU     0X2B
TX2_DATA5               EQU     0X2C   
TX2_DATA6               EQU     0X2D
TX2_DATA7               EQU     0X2E
TX2_DATA8               EQU     0X2F
TX3_DATA1               EQU     0X30
TX3_DATA2               EQU     0X31
TX3_DATA3               EQU     0X32
TX3_DATA4               EQU     0X33
TX3_DATA5               EQU     0X34
TX3_DATA6               EQU     0X35
TX3_DATA7               EQU     0X36
TX3_DATA8               EQU     0X37
TX4_DATA1               EQU     0X38    
TX4_DATA2               EQU     0X39
TX4_DATA3               EQU     0X3A    
TX4_DATA4               EQU     0X3B
TX4_DATA5               EQU     0X3C   
TX4_DATA6               EQU     0X3D
TX4_DATA7               EQU     0X3E
TX4_DATA8               EQU     0X3F
TX5_DATA1               EQU     0X20
TX5_DATA2               EQU     0X21
TX5_DATA3               EQU     0X22
TX5_DATA4               EQU     0X23
TX5_DATA5               EQU     0X24
TX5_DATA6               EQU     0X25
TX5_DATA7               EQU     0X26
TX5_DATA8               EQU     0X27
TX6_DATA1               EQU     0X28   
TX6_DATA2               EQU     0X29
TX6_DATA3               EQU     0X2A   
TX6_DATA4               EQU     0X2B
TX6_DATA5               EQU     0X2C   
TX6_DATA6               EQU     0X2D                  
TX6_DATA7               EQU     0X2E                     
TX6_DATA8               EQU     0X2F                    
TX7_DATA1               EQU     0X30
TX7_DATA2               EQU     0X31
TX7_DATA3               EQU     0X32
TX7_DATA4               EQU     0X33
TX7_DATA5               EQU	    0X34
TX7_DATA6               EQU     0X35
TX7_DATA7               EQU     0X26
TX7_DATA8               EQU     0X37
TX8_DATA1               EQU     0X38    
TX8_DATA2               EQU     0X39
TX8_DATA3               EQU     0X3A   
TX8_DATA4               EQU     0X3B
TX8_DATA5               EQU	    0X3C    
TX8_DATA6               EQU     0X3D
TX8_DATA7               EQU     0X2E
TX8_DATA8               EQU     0X3F
