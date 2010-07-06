/*****************************************************************
* Filename     :  EM78P520_32PIN44PIN_TX.ASM
* Author       :  yu.wei
* Company      :  ELAN
* VERSION      :  1.0
* CRYSTAL	   :  8MHZ
* Creat date   :  2009/9/11
* tool ver.    :  WicePlus 2.7
* Description  :  modify for code conformity
*****************************************************************/

;==========================================================================================
P510PIN32TXv17.H                EQU     P510PIN32TXv17.H



;============================================================================================
TEMP                            EQU     0X10
TEMP1                           EQU     0X11
TEMP2                           EQU     0X12
TEMP3                           EQU     0X13
TEMP4                           EQU     0X14
TEMP5                           EQU     0X15
TEMP6                           EQU     0X16

ComuClock                       EQU     0X17  
ComuCycleNum                    EQU     0X18  
ComuEndNum                      EQU     0X19  
Databytelength                  EQU     0X1A  
DataShiftCounter                EQU     0X1B  
CommonCounter                   EQU     0X1C  

GeneralStatusFlag1              EQU     0X1D
	RFInitialFailFlag           ==      GeneralStatusFlag1*16+7 ; 
	RFInitialOKFlag             ==      GeneralStatusFlag1*16+6
	RFTestFailFlag              ==      GeneralStatusFlag1*16+5

GeneralStatusFlag2              EQU     0X1E
	System16msFlag              ==      GeneralStatusFlag2*16+7
	System250msFlag             ==      GeneralStatusFlag2*16+6
	KeyScanFinishFlag           ==      GeneralStatusFlag2*16+5
	KeyStatusFlag               ==      GeneralStatusFlag2*16+4
	KeyScanStatusFlag           ==      GeneralStatusFlag2*16+3
	ReadLengthError             ==      GeneralStatusFlag2*16+2

CommuStatusFlag                 EQU     0X1F
	DescriptorFinishFlag        ==      CommuStatusFlag*16+7   
	FccTestModeFlag             ==      CommuStatusFlag*16+6
	ForceLinkModeFlag           ==      CommuStatusFlag*16+5   
	LinkModeFlag                ==      CommuStatusFlag*16+4  
	EEpromWRStatusFlag          ==      CommuStatusFlag*16+3
	LoseFrameStatusFlag         ==      CommuStatusFlag*16+2   
	NormalStatusFlag            ==      CommuStatusFlag*16+1   
	SearchStatusFlag            ==      CommuStatusFlag*16+0  

r_acc1                          EQU     TEMP1
r_acc2                          EQU     TEMP2
r_acc3                          EQU     TEMP3
DataAddressInMCU                EQU     TEMP4        
DataAddressInEEPROM             EQU     TEMP5
A_TEMP                          EQU     TEMP4  
RSR_TEMP                        EQU     TEMP5
STATUS_TEMP                     EQU     TEMP6
FccFreqIndex                    EQU     ComuEndNum    

SPI_SS                      ==      PortA*16+7 ;0  
SPI_CLK                     ==      PortA*16+6 ;1
SPI_MOSI                    ==      PortA*16+5 ;2
SPI_MISO                    ==      PortA*16+4 ;3
RESET_N                     ==      PortA*16+3 ;3
FIFO_FLAG                   ==      PortA*16+2 ;1
PKT_FLAG                    ==      PortB*16+0 ;0
AT93C46_CS                  ==      Port7*16+3 ;4  
LED1_STATUS                 ==      PORT8*16+1 ;LED
LED2_STATUS                 ==      PORT8*16+2 ;LED

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


PID_DATA                EQU     0X20
RX_IDH                  EQU     0X21   
RX_IDL                  EQU     0X22
CHN_FLAG                EQU     0X23   
;CommuStatusFlag
DirectionCtrl           EQU     0X25    
N_CHN                   EQU     0X26    
TX_ID                   EQU     0X26     ;
TX1_ID                  EQU     0X27     ;
TX2_ID                  EQU     0X28     ;
TX3_ID                  EQU     0X29     ;
TX4_ID                  EQU     0X2A     ;
TX5_ID                  EQU     0X2B     ;
TX6_ID                  EQU     0X2C     ;

;----------------------------------------------------------------------
ADDR                    EQU     0X30 
VALUE                   EQU     0X31 
CH_NO                   EQU     0X32
LossframeCNT            EQU     0X33
TABLE_INDEX             EQU     0x34  
RF_RSSI                 EQU     0X35
DataA                   EQU     0X24 
DataB                   EQU     0X25 
DataC                   EQU     0X26 
DataD                   EQU     0X27 
DataE                   EQU     0x20 
DataF                   EQU     0x21 
DataG                   EQU     0X22 
DataH                   EQU     0X23
KEY_LEFT_X              EQU     0X28 
KEY_LEFT_Y              EQU     0X29 
KEY_RIGHT_X             EQU     0X2A 
KEY_RIGHT_Y             EQU     0X2B 
KeySystemTimeCNT        EQU     0x2E  
KeystokeFlag_Befor      EQU     0X2F   
KeystokeTimeCNT         EQU     0X30
KEY_NUM                 EQU     0X31                                          
F_MODE                  EQU     0X32 
F_MODE_BEFOR            EQU     0X33 
F_TEMP                  EQU     0X34 
F_TEMP_BEFOR            EQU     0X35
LINE1_KEY_INPUT         EQU     0X36 
LINE2_KEY_INPUT         EQU     0X37 
LINE3_KEY_INPUT         EQU     0X38 
LINE4_KEY_INPUT         EQU     0X39 
LINE5_KEY_INPUT         EQU     0X3A 
LINE1_KEY_INPUT_CACHE   EQU     0X3B 
LINE2_KEY_INPUT_CACHE   EQU     0X3C 
LINE3_KEY_INPUT_CACHE   EQU     0X3D 
LINE4_KEY_INPUT_CACHE   EQU     0X3E 
LINE5_KEY_INPUT_CACHE   EQU     0X3F 