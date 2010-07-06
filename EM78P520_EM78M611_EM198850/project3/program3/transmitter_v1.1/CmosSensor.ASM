/*****************************************************************
* Filename     :  CmosSensorMM0200.ASM
* Author       :  yu.wei
* Company      :  ELAN
* VERSION      :  1.0
* CRYSTAL      :  8MHZ
* Creat date   :  2009/11/9
* tool ver.    :  WicePlus 2.7/eUIDE
* Description  :  modify for code conformity
*****************************************************************/
;---------------------------------------------------------------
CmosSensorMM0200.ASM        EQU       CmosSensorMM0200.ASM

include "CmosSensor.H"
include "D:\include\lib\Arithmetic\KalmanFilter.ASM"

ifndef EM78CtrlIns.H
include "D:\include\EM78xx\EM78CtrlIns.H"
endif

;---------------------------------------------------------------

;******************************************************************
if     CmosSensorTypeSelect == 1
;******************************************************************
; Cmos Sensor MM0200BA
;******************************************************************
CmosSensor_Function:

	RET


;******************************************************************
elseif CmosSensorTypeSelect == 2
;******************************************************************
; Cmos Sensor MM0200FA
;******************************************************************
CmosSensor_Function:

	RET


;******************************************************************
elseif CmosSensorTypeSelect == 3
;******************************************************************
; Cmos Sensor MM0200CA
;******************************************************************
CmosSensor_Function:

	RET


;******************************************************************
else
;******************************************************************
; Cmos Sensor MM0200DA(Default) Driver
;******************************************************************
;==========================================================================
;input:       CMOS_PARAMETER[0:init; 1:sleep; 2:get data]
;output:      CMOS_STATUS,
;             CMOS_XPOINT_LOW,
;             CMOS_YPOINT_LOW,
;             CMOS_POINT_HIGH,
;Description: CMOS Function Program
;==========================================================================
CmosSensor_Function:
	BANK                4
	BS                  PAIOCR,4
	BANK                5
	BS                  PAPHCR,4
	BANK                0
	BS                  SPI_SS/16,SPI_SS%16           ; Disable EM198810
	BC                  AT93C46_CS/16,AT93C46_CS%16   ; Disable 93C46
	BC                  CMOS_SS/16,CMOS_SS%16         ; Enable CMOS

	BANK                2
	MOV                 A,SPIS
	BANK                4
	MOV                 SPIS_TEMP,A
	BANK                2
	MOV                 A,@00000000B  ; Shift left, SDO delay time: 16clk,
	MOV                 SPIS,A       ; disable open-drain

	BANK                2
	MOV                 A,SPIC
	BANK                4
	MOV                 SPIC_TEMP,A
	BANK                2
	MOV                 A,@11001100B  ; Rising edge read data
	MOV                 SPIC,A

	BANK                5
	MOV                 A,@11000000B
	OR                  RSR,A
	JBC                 CMOS_PARAMETER,2
	JMP                 Get_CMOS_Data
	JBC                 CMOS_PARAMETER,0
	JMP                 CMOS_Init
	JBC                 CMOS_PARAMETER,1
	JMP                 CMOS_Power_Down
	JMP                 CMOS_WakeUP
  EXIT_CMOS_FUNCTION:
	BANK                4
	MOV                 A,SPIC_TEMP  ;falling edge read data
	BANK                2
	MOV                 SPIC,A
	NOP
	NOP
	RET
	NOP

;==========================================================================
;input:       CMOS_PARAMETER
;output:      CMOS_STATUS
;Description: CMOS Initialize
;==========================================================================
CMOS_Init:
	BANK                5
	JBC                 CMOSInitFlag/16,CMOSInitFlag%16
	JMP                 CMOS_Init_Exit
	BANK                0
	BC                  CMOS_SS/16,CMOS_SS%16
  Set_Init:
	MOV                 A,@0X88
	LCALL               SIM_SPI_WRITE
	XOR                 A,@0XFF
	JBC                 STATUS,Z          ; R3,2
	JMP                 CMOS_Init_Exit
	;MOV                A,@0XFE           ; Sensitivity 1
	;MOV                A,@0XB4           ; Sensitivity 2
	MOV                 A,@0X64           ; Sensitivity 3
	;MOV                A,@0X36           ; Sensitivity 4
	;MOV                A,@0X20           ; Sensitivity 5
	LCALL               SIM_SPI_WRITE
	BS                  CMOSInitFlag/16,CMOSInitFlag%16
	BANK                0
	BS                  CMOS_SS/16,CMOS_SS%16
  CMOS_Init_Exit:
	JMP                 EXIT_CMOS_FUNCTION
	NOP

;==========================================================================
;input:       CMOS_PARAMETER
;output:      CMOS_STATUS
;Description: CMOS Power Down
;==========================================================================
CMOS_Power_Down:
	BANK                5
	JBC                 CMOSSleepFlag/16,CMOSSleepFlag%16
	JMP                 CMOS_Sleep_Exit
	BANK                0
	BC                  CMOS_SS/16,CMOS_SS%16
  Set_Power_Down:
	MOV                 A,@0XFF
	LCALL               SIM_SPI_WRITE
	XOR                 A,@0XFF
	JBC                 STATUS,Z          ; R3,2
	JMP                 CMOS_Sleep_Exit
	MOV                 A,@0X01
	LCALL               SIM_SPI_WRITE
	BS                  CMOSSleepFlag/16,CMOSSleepFlag%16
	BANK                0
	BS                  CMOS_SS/16,CMOS_SS%16
  CMOS_Sleep_Exit:
	JMP                 EXIT_CMOS_FUNCTION
	NOP

;;==========================================================================
;input:       CMOS_PARAMETER
;output:      CMOS_STATUS
;Description: CMOS Wake Up -- SS pull low 5us
;==========================================================================
CMOS_WakeUP:
	BANK                5
	JBS                 CMOSSleepFlag/16,CMOSSleepFlag%16
	JMP                 CMOS_WakeUp_Exit
	BANK                0
	BS                  CMOS_SS/16,CMOS_SS%16
	NOP
	NOP
	BC                  CMOS_SS/16,CMOS_SS%16
	CALL                DELAY_X10US
	BANK                0
	BS                  CMOS_SS/16,CMOS_SS%16
  CMOS_WakeUp_Exit:
	BANK                5
	BC                  CMOSSleepFlag/16,CMOSSleepFlag%16
	JMP                 EXIT_CMOS_FUNCTION
	NOP

;***********************************************************
;input:       CMOS_PARAMETER[0:init; 1:sleep; 2:get data]
;output:      CMOS_STATUS,
;             CMOS_XPOINT_LOW,
;             CMOS_YPOINT_LOW,
;             CMOS_POINT_HIGH
;Description: Get CMOS Data
;***********************************************************
Get_CMOS_Data:                      ; Read CMOS Data
	BANK                0
	BC                  CMOS_SS/16,CMOS_SS%16
	CALL                DELAY_X10US
	NOP
  Set_Read_Command:
	MOV                 A,@0X37
	LCALL               SIM_SPI_WRITE
	NOP
	XOR                 A,@0XFF
	JBC                 R3,2
	JMP                 Read_Exit
	
	CALL                DELAY_X10US
	LCALL               SIM_SPI_READ
	BANK                6
	MOV                 CMOS_X1_L,A
	CALL                DELAY_X10US
	LCALL               SIM_SPI_READ
	BANK                6
	MOV                 CMOS_Y1_L,A
	CALL                DELAY_X10US
	LCALL               SIM_SPI_READ
	BANK                6
	MOV                 CMOS_Size1,A

	CALL                DELAY_X10US
	CALL                SIM_SPI_READ
	BANK                6
	MOV                 CMOS_X2_L,A
	CALL                DELAY_X10US
	CALL                SIM_SPI_READ
	BANK                6
	MOV                 CMOS_Y2_L,A
	CALL                DELAY_X10US
	CALL                SIM_SPI_READ
	BANK                6
	MOV                 CMOS_Size2,A
	
	MOV                 A,@0X06
	MOV                 Receive_CMOS_Count,A
  Read_Receive_CMOS:
	CALL                DELAY_X10US
	CALL                SIM_SPI_READ
	BANK                5
	MOV                 Receive_CMOS_Data,A
	DJZ                 Receive_CMOS_Count
	JMP                 Read_Receive_CMOS
	BANK                0
	BS                  SPI_BUS,F_CMOS_SS
	BANK                5
	SWAPA               CMOS_Size1
	AND                 A,@0X0C
	MOV                 CMOS_Size_BAK,A
	BC                  R3,0
	RRC                 CMOS_Size_BAK
	RRCA                CMOS_Size_BAK
	MOV                 CMOS_Y1_H,A
	SWAPA               CMOS_Size1
	AND                 A,@0X03
	MOV                 CMOS_X1_H,A
	MOV                 A,@0X0F
	AND                 CMOS_Size1,A

	SWAPA               CMOS_Size2
	AND                 A,@0X0C
	MOV                 CMOS_Size_BAK,A
	BC                  R3,0
	RRC                 CMOS_Size_BAK
	RRCA                CMOS_Size_BAK
	MOV                 CMOS_Y2_H,A
	SWAPA               CMOS_Size2
	AND                 A,@0X03
	MOV                 CMOS_X2_H,A
	MOV                 A,@0X0F
	AND                 CMOS_Size2,A
	JMP                 CMOS_Data_Handle
	
	
  Read_Exit:
	BANK                0
	BS                  CMOS_SS/16,CMOS_SS%16
	BANK                5
	BC                  CMOSGetDataFlag/16,CMOSGetDataFlag%16
	NOP
	NOP
	JMP                 EXIT_CMOS_FUNCTION
	NOP



;***********************************************************
;input:       None
;output:      None
;Description: Delay About 10us
;***********************************************************
DELAY_X10US:
	MOV                 A,@0X0F
	MOV                 DataShiftCounter,A
  X10US_DELAY_LOOP:
	DJZ                 DataShiftCounter
	JMP                 X10US_DELAY_LOOP
	NOP
	RET
	NOP


endif








