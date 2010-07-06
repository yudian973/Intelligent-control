/*****************************************************************
* Filename     :  CmosSensorDev_For_EM78P520
* Author       :  yu.wei
* Company      :  ELAN
* VERSION      :  1.0
* CRYSTAL      :  8MHZ
* Creat date   :  2009/11/9
* tool ver.    :  WicePlus 2.7/eUIDE
* Description  :  modify for code conformity,multi-1v2 CMOS project
*****************************************************************/
;---------------------------------------------------------------
CmosSensorDev.asm        EQU       CmosSensorDev.asm

include "CmosSensorDev.h"

ifndef KalmanFilter.asm
;include "D:\include\EM78xx\Arithmetic\KalmanFilter.asm"
include "KalmanFilter.asm"
endif

ifndef EM78CtrlIns.H
include "D:\include\EM78xx\inc\EM78CtrlIns.H"
endif


;***********************************************************************
	ORG                 0X1400    ; PAGE 5
  if MassageDisplay == 1
	MESSAGE "define 'CmosSensor.ASM' ROM address"
  endif

  if CMOS_SPI_FUNCTION == 1
;===============================================
; Function: Write SPI communication subroutine rising edge
; Input:    ACC
; Output:   None
;===============================================
CMOS_SPI_WRITE:
	BANK                2
	CLR                 SPIS
	CLR                 SPIR
	MOV                 SPIW,A         ; Write data to buffer
	BS                  SPIC, SSE       ; Start to shift data
	NOP
	JBC                 SPIC, SSE       ; Wait to finish shift data
	JMP                 $-2
	BANK                1
	NOP
	RET
	NOP

;======================================================================
; Function: Read SPI communication subroutine rising edge
; Input:    None
; Output:   SPI Data
;======================================================================
CMOS_SPI_READ:
	BANK                2
	CLR                 SPIS
	CLR                 SPIR
	CLR                 SPIW            ; Write data to buffer
	BS                  SPIC, SSE       ; Start to shift data
	NOP
	JBC                 SPIC, SSE       ; Wait to finish shift data
	JMP                 $-2
	MOV                 A,SPIR
	BANK                1
	NOP
   	RET
   	NOP

;==========================================================
; Read/Write subroutine
;==========================================================
CMOS_SPI_READ_WRITE:
	BANK                2
	CLR                 SPIS
	CLR                 SPIR
	MOV                 SPIW,A            ; Write data to buffer
	BS                  SPIC, SSE       ; Start to shift data
	JBC                 SPIC, SSE       ; Wait to finish shift data
	JMP                 $-1
	MOV                 A,SPIR
	BANK                1
	NOP
   	RET
   	NOP
  endif

  if MassageDisplay == 1
    if CMOS_SPI_FUNCTION == 0
      MESSAGE "CMOS_SPI_FUNCTION is disable"
    endif    
  endif


;*************************************************************
; fcuntion:    uart comuniction
; input:       none
; output:      none
; description: using UART cnonect to matlab
;***************************************************************
  if UART_FUNCTION & CMOS_UART_DEBUG & DebugDisplay == 1
Cmos_UartDebug_Function:
	BANK                2
	JBS                 System8msFlag/8,System8msFlag%8
	JMP                 CMOS_Uart_Transmit
	BC                  System8msFlag/8,System8msFlag%8
	INC                 KeySystemTimeCNT
	INC                 ComSystemTimeCNT
	MOV                 A,KeySystemTimeCNT
	SUB                 A,@CmosScanTimeCtrl
	JBC                 STATUS,C
	JMP                 CMOS_Uart_Transmit
	CLR                 KeySystemTimeCNT

	BANK                5
	MOV                 A,@0B00000100
	MOV                 CMOS_PARAMETER,A
	CALL                CMOSSensor_Function
	NOP

  if CMOS_UART_T_DEBUG & DebugDisplay == 1
	BANK                0
	MOV                 A,@0B00100000          ; (test)P85 exchange when intrrupt
	XOR                 PORT8,A
  endif

;----------------------------------------------------------------------
  CMOS_Uart_Transmit:
  if CMOS_UART_DEBUG & DebugDisplay == 1
	MOV                 A,ComSystemTimeCNT
	SUB                 A,@CmosUartTimeCtrl
	JBC                 STATUS,C
	RET
	CLR                 ComSystemTimeCNT
  endif

  if CMOS_UART_T_DEBUG & DebugDisplay == 1
	BANK                0
	MOV                 A,@0B00001000          ; (test)P83 exchange when intrrupt
	XOR                 PORT8,A
  endif

	MOV                 A,@0B11100000          ; 0XC1
	MOV                 R4,A                   ; Select bank0 0x20
  Uart_Transmit_Frame:
	MOV                 A,@CmosFrameHeader     ; Ttranmitter frame header
	BANK                3
	BS                  URC,TXE                ; Enable transmission
	NOP
	MOV                 URTD,A
	JBS                 URC,UTBE
	JMP                 $-1
  Uart_Transmit_Data:
	BANK                0
	MOV                 A,R0
	BANK                3
	BS                  URC,TXE                ; Enable transmission
	NOP
	MOV                 URTD,A
	NOP
	INC                 R4
	JBS                 URC,UTBE
	JMP                 $-1
	MOV                 A,R4
	XOR                 A,@0b11101100          ; 0b11101100(0XEC=0XC0|0x2C)
	JBS                 STATUS,Z               ; Uart Data, bank0: 0X20-0X2C
	JMP                 Uart_Transmit_Data
	NOP
	RET
  endif

  if CMOS_UART_DEBUG & DebugDisplay & MassageDisplay == 1
    if UART_FUNCTION == 0
        MESSAGE "UART_FUNCTION is disable"
    endif
  endif




;******************************************************************
if       CmosSensorTypeSelect == 0
;******************************************************************
; Cmos Sensor MM0200DA(Default) Driver
;******************************************************************
;==========================================================================
;input:       CMOS_PARAMETER[0:init; 1:sleep; 2:get data]
;output:      CMOS_STATUS,
;             CMOS_XPOINT_LOW,
;             CMOS_YPOINT_LOW,
;             CMOS_POINT_HIGH,
;Description: CMOS Function Program for EM78P520
/*
 CMOS_PARAMETER          EQU     0X20
 CMOS_STATUS             EQU     0X21
	CMOSInitFlag         ==      CMOS_STATUS*8+0
	CMOSSleepFlag        ==      CMOS_STATUS*8+1
	CMOSGetDataFlag      ==      CMOS_STATUS*8+2

 CMOS_xAxisH             EQU     0X22    ; X1[9..8]
 CMOS_xAxisL             EQU     0X23    ; X1[7..0]
 CMOS_yAxisH             EQU     0X24    ; Y1[9..8]
 CMOS_yAxisL             EQU     0X25    ; Y1[7..0]
 CMOS_Size               EQU     0X26    ; Size1[3..0]
*/
;==========================================================================
CMOSSensor_Function:
;------------------------- set config --------------------------------
	BANK                4
	BS                  PAIOCR,4                    ; MISO, set input
	BANK                5
	BS                  PAPHCR,4
	BANK                0
	BS                  CMOS_RST/8,CMOS_RST%8
	BS                  SPI_SS/8,SPI_SS%8           ; Disable EM198810
	BC                  AT93C46_CS/8,AT93C46_CS%8   ; Disable 93C46
	BS                  CMOS_SS/8,CMOS_SS%8         ; Disable CMOS
	BANK                2
	MOV                 A,SPIS
	BANK                4
	MOV                 SPIS_TEMP,A    ; push
	BANK                2
	MOV                 A,SPIC
	BANK                4
	MOV                 SPIC_TEMP,A    ; push
	BANK                2
	MOV                 A,@0B00000000  ; Shift left, SDO delay time: 16clk,
	MOV                 SPIS,A         ; disable open-drain
	MOV                 A,@0B11001100  ; Rising edge read data
	MOV                 SPIC,A

;--------------------------------------------------------------------
	BANK                5
	MOV                 A,@0B11000000
	OR                  RSR,A
	JBC                 CMOS_PARAMETER,2
	JMP                 CMOS_GetData
	JBC                 CMOS_PARAMETER,0
	JMP                 CMOS_Init
	JBC                 CMOS_PARAMETER,1
	JMP                 CMOS_PowerDown
	JMP                 CMOS_WakeUP
  EXIT_CMOS_FUNCTION:
	BANK                4
	MOV                 A,SPIS_TEMP    ;reload
	BANK                2
	MOV                 SPIS,A
	BANK                4
	MOV                 A,SPIC_TEMP    ;reload
	BANK                2
	MOV                 SPIC,A
	BANK                0
	BS                  SPI_SS/8,SPI_SS%8           ; Disable EM198810
	BC                  AT93C46_CS/8,AT93C46_CS%8   ; Disable 93C46
	BS                  CMOS_SS/8,CMOS_SS%8         ; Disable CMOS
	RET
	NOP

;==========================================================================
;input:       CMOS_PARAMETER
;output:      CMOS_STATUS
;Description: CMOS Initialize
;==========================================================================
CMOS_Init:
	BANK                5
	JBC                 CMOSInitFlag/8,CMOSInitFlag%8
	JMP                 CMOS_Init_Exit
	BANK                0
	BC                  CMOS_SS/8,CMOS_SS%8
  Set_Init:
	MOV                 A,@0X88
	CALL                CMOS_SPI_WRITE
	XOR                 A,@0XFF
	JBC                 STATUS,Z          ; R3,2
	JMP                 CMOS_Init_Exit
	;MOV                A,@0XFE           ; Sensitivity 1
	;MOV                A,@0XB4           ; Sensitivity 2
	MOV                 A,@0X64           ; Sensitivity 3
	;MOV                A,@0X36           ; Sensitivity 4
	;MOV                A,@0X20           ; Sensitivity 5
	CALL                CMOS_SPI_WRITE
	BS                  CMOSInitFlag/8,CMOSInitFlag%8
	BANK                0
	BS                  CMOS_SS/8,CMOS_SS%8
  CMOS_Init_Exit:
	JMP                 EXIT_CMOS_FUNCTION
	NOP

;==========================================================================
;input:       CMOS_PARAMETER
;output:      CMOS_STATUS
;Description: CMOS Power Down
;==========================================================================
CMOS_PowerDown:
	BANK                5
	JBC                 CMOSSleepFlag/8,CMOSSleepFlag%8
	JMP                 CMOS_Sleep_Exit
	BANK                0
	BC                  CMOS_SS/8,CMOS_SS%8
  Set_Power_Down:
	MOV                 A,@0XFF
	CALL                CMOS_SPI_WRITE
	XOR                 A,@0XFF
	JBC                 STATUS,Z          ; R3,2
	JMP                 CMOS_Sleep_Exit
	MOV                 A,@0X01
	CALL                CMOS_SPI_WRITE
	BS                  CMOSSleepFlag/8,CMOSSleepFlag%8
	BANK                0
	BS                  CMOS_SS/8,CMOS_SS%8
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
	JBS                 CMOSSleepFlag/8,CMOSSleepFlag%8
	JMP                 CMOS_WakeUp_Exit
	BANK                0
	BS                  CMOS_SS/8,CMOS_SS%8
	NOP
	NOP
	BC                  CMOS_SS/8,CMOS_SS%8
	LCALL               DELAY_8MHz_X10US
	BANK                0
	BS                  CMOS_SS/8,CMOS_SS%8
  CMOS_WakeUp_Exit:
	BANK                5
	BC                  CMOSSleepFlag/8,CMOSSleepFlag%8
	JMP                 EXIT_CMOS_FUNCTION
	NOP

;***********************************************************
;input:       CMOS_PARAMETER[0:init; 1:sleep; 2:get data]
;output:      CMOS_STATUS,
;             CMOS_XPOINT_LOW,
;             CMOS_YPOINT_LOW,
;             CMOS_POINT_HIGH,
;Description: Get CMOS Data
;***********************************************************
CMOS_GetData:
	BANK                0
	BC                  CMOS_SS/8,CMOS_SS%8
  Set_Read_Command:
	MOV                 A,@0X37
	CALL                CMOS_SPI_WRITE
	XOR                 A,@0XFF
	JBC                 R3,2
	JMP                 Read_Exit

	MOV                 A,@12
	MOV                 Databytelength,A
	MOV                 A,@0B11100000
	MOV                 R4,A                 ; select bank0 0x20(data buffer)
  Read_Sensor_Buffer:
	CALL                CMOS_SPI_READ
	BANK                0
	MOV                 R0,A
	INC                 R4
	DJZ                 Databytelength
	JMP                 Read_Sensor_Buffer
	CALL                TransformCmosData
	NOP

  Read_Exit:
	LCALL               KalmanFilter_1
	BANK                0
	BS                  CMOS_SS/8,CMOS_SS%8
	BANK                5
	BC                  CMOSGetDataFlag/8,CMOSGetDataFlag%8
	JMP                 EXIT_CMOS_FUNCTION
	NOP

TransformCmosData:
	;--------------------- point ------------------------------
	CLR                 TEMP
	BANK                0
	MOV                 A,CMOS1_xAxisL_Buffer
	BANK                5
	MOV                 CMOS_xAxisL,A           ; CMOS1_xAxisL
	BANK                0
	MOV                 A,CMOS1_yAxisL_Buffer
	BANK                5
	MOV                 CMOS_yAxisL,A           ; CMOS1_yAxisL
	BANK                0
	MOV                 A,CMOS1_yxsAxisH_Buffer
	BANK                5
	MOV                 CMOS_yxsAxisH,A         ; SAVE yxsAxis
	MOV                 TEMP,A
	AND                 A,@0B00001111
	MOV                 CMOS_Size,A             ; CMOS1_Size
	SWAPA               TEMP
	AND                 A,@0B00000011
	MOV                 CMOS_xAxisH,A           ; CMOS1_xAxisH
	SWAP                TEMP
	RRC                 TEMP
	RRCA                TEMP
	AND                 A,@0B00000011
	MOV                 CMOS_yAxisH,A
	;--------------------- point 1 ------------------------------
	CLR                 TEMP
	BANK                0
	MOV                 A,CMOS1_xAxisL_Buffer
	BANK                6
	MOV                 CMOS1_xAxisL,A           ; CMOS1_xAxisL
	BANK                0
	MOV                 A,CMOS1_yAxisL_Buffer
	BANK                6
	MOV                 CMOS1_yAxisL,A           ; CMOS1_yAxisL
	BANK                0
	MOV                 A,CMOS1_yxsAxisH_Buffer
	BANK                6
	MOV                 TEMP,A
	AND                 A,@0B00001111
	MOV                 CMOS1_Size,A             ; CMOS1_Size
	SWAPA               TEMP
	AND                 A,@0B00000011
	MOV                 CMOS1_xAxisH,A           ; CMOS1_xAxisH
	SWAP                TEMP
	RRC                 TEMP
	RRCA                TEMP
	AND                 A,@0B00000011
	MOV                 CMOS1_yAxisH,A
	;--------------------- point 2 ------------------------------
	CLR                 TEMP
	BANK                0
	MOV                 A,CMOS2_xAxisL_Buffer
	BANK                6
	MOV                 CMOS2_xAxisL,A           ; CMOS2_xAxisL
	BANK                0
	MOV                 A,CMOS2_yAxisL_Buffer
	BANK                6
	MOV                 CMOS2_yAxisL,A           ; CMOS2_yAxisL
	BANK                0
	MOV                 A,CMOS2_yxsAxisH_Buffer
	BANK                6
	MOV                 TEMP,A
	AND                 A,@0B00001111
	MOV                 CMOS2_Size,A             ; CMOS2_Size
	SWAPA               TEMP
	AND                 A,@0B00000011
	MOV                 CMOS2_xAxisH,A           ; CMOS2_xAxisH
	SWAP                TEMP
	RRC                 TEMP
	RRCA                TEMP
	AND                 A,@0B00000011
	MOV                 CMOS2_yAxisH,A
	;--------------------- point 3 ------------------------------
	CLR                 TEMP
	BANK                0
	MOV                 A,CMOS3_xAxisL_Buffer
	BANK                6
	MOV                 CMOS3_xAxisL,A           ; CMOS3_xAxisL
	BANK                0
	MOV                 A,CMOS3_yAxisL_Buffer
	BANK                6
	MOV                 CMOS3_yAxisL,A           ; CMOS3_yAxisL
	BANK                0
	MOV                 A,CMOS3_yxsAxisH_Buffer
	BANK                6
	MOV                 TEMP,A
	AND                 A,@0B00001111
	MOV                 CMOS3_Size,A             ; CMOS3_Size
	SWAPA               TEMP
	AND                 A,@0B00000011
	MOV                 CMOS3_xAxisH,A           ; CMOS3_xAxisH
	SWAP                TEMP
	RRC                 TEMP
	RRCA                TEMP
	AND                 A,@0B00000011
	MOV                 CMOS3_yAxisH,A
	;--------------------- point 4 ------------------------------
	CLR                 TEMP
	BANK                0
	MOV                 A,CMOS4_xAxisL_Buffer
	BANK                6
	MOV                 CMOS4_xAxisL,A           ; CMOS4_xAxisL
	BANK                0
	MOV                 A,CMOS4_yAxisL_Buffer
	BANK                6
	MOV                 CMOS4_yAxisL,A           ; CMOS4_yAxisL
	BANK                0
	MOV                 A,CMOS4_yxsAxisH_Buffer
	BANK                6
	MOV                 TEMP,A
	AND                 A,@0B00001111
	MOV                 CMOS4_Size,A             ; CMOS4_Size
	SWAPA               TEMP
	AND                 A,@0B00000011
	MOV                 CMOS4_xAxisH,A           ; CMOS4_xAxisH
	SWAP                TEMP
	RRC                 TEMP
	RRCA                TEMP
	AND                 A,@0B00000011
	MOV                 CMOS4_yAxisH,A
	RET



;******************************************************************
elseif CmosSensorTypeSelect == 1
;******************************************************************
; Cmos Sensor MM0200BA
;******************************************************************
CMOSSensor_Function:

	RET


;******************************************************************
elseif CmosSensorTypeSelect == 2
;******************************************************************
; Cmos Sensor MM0200FA
;******************************************************************
CMOSSensor_Function:

	RET


;******************************************************************
elseif CmosSensorTypeSelect == 3
;******************************************************************
; Cmos Sensor MM0200CA
;******************************************************************
CMOSSensor_Function:

	RET


;******************************************************************
elseif CmosSensorTypeSelect == 4
;******************************************************************
; Cmos Sensor CSM0012BA
;******************************************************************
CMOSSensor_Function:

	RET


;******************************************************************
else


endif