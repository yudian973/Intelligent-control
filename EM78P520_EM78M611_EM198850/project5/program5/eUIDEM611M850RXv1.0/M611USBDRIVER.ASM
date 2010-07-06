;==================================================================
; Filename     :  EM78M611
; Author       :  yu.wei
; Company      :  ELAN
; VERSION      :  1.1
; CRYSTAL      :  6MHZ
; Creat date   :  2009/11/4
; tool ver.    :  eUIDE
; Description  :  modify for code conformity
;=========================================================================
M611USBDriver.ASM    EQU    M611USBDriver.ASM


include "M611USBDescData.ASM"

ifndef EM78CtrlIns.H
include "EM78CtrlIns.H"
endif

ifndef M611rxP40.H
include "M611rxP40.H"
endif
;=========================================================================

	ORG                 0X1150    ;PAGE 4
	MESSAGE "define 'M611USBDriver.ASM' ROM address"
;***********************************************************************************
;**********************************************************************************
; USB Driver
;*********************************************************************************
;==============================================================================
;==============================================================================
; READ USB COMMAND ,HOST command
;==============================================================================

READ_COMMAND:
	JBC                 RC,EP0_BUSY           ;CHECK UDC BUSY OR NOT
	JMP                 READ_COMMAND
	JBS                 RC,EP0_W              ;CHECK EP0 W HAVE DATA OR NOT
	JMP                 READ_COMMAND
	BC                  RC,EP0_R              ;DISABLE UDC READ

	MOV                 A,@0X10
	MOV                 RD,A
	CLR                 RE                    ;RESET POINTER & COUNTER
	CLR                 RD

	MOV                 A,RE
	MOV                 BYTE0,A
	MOV                 A,RE
	MOV                 BYTE1,A
	MOV                 A,RE
	MOV                 BYTE2,A
	MOV                 A,RE
	MOV                 BYTE3,A
	MOV                 A,RE
	MOV                 BYTE4,A
	MOV                 A,RE
	MOV                 BYTE5,A
	MOV                 A,RE
	MOV                 BYTE6,A
	MOV                 A,RE
	MOV                 BYTE7,A
	MOV                 A,@0X10
	MOV                 RD,A
	CLR                 RE                                             ;RESET POINTER & COUNTER
	CLR                 RD
	BC                  RC,EP0_W                                       ;CLEAR EP0_W
	BC                  SetupDataStageFlag/16,SetupDataStageFlag%16    ;REFRESH EP0_REPORT COMMAND
	BC                  UsbEP0interruptflag/16,UsbEP0interruptflag%16
	;CLR                 TRANSFER

;=========================================================
;USB COMMAND DECODE:
;	|
;	|---STANDARD_DEVICE_REQUESTS
;	|	|
;	|	|---GET_DESCRIPTOR
;	|		|
;	|		|---STANDARD_DESCRIPTOR_TYPE
;	|		|	|
;	|		|	|---GET_DEVICE_D
;	|		|	|---GET_CONFIGURATION_D
;	|		|	|---GET_STRING_D
;	|		|
;	|		|---CLASS_DESCRIPTOR_TYPE
;	|			|
;	|			|---GET_HID_D
;	|			|---GET_REPORT_D
;	|
;	|---CLASS_SPECIFIC_REQUESTS
;		|
;		|---HID_SET_REQUEST
;		|	|
;		|	|---SET_REPORT_R
;		|	|---SET_IDLE_R
;		|	|---SET_PROTOCOL_R
;		|
;		|---HID_GET_REQUEST
;			|
;			|---GET_REPORT_R
;			|---GET_IDLE_R
;			|---GET_PROTOCOL_R
;=========================================================
DECODE:
	MOV                 A,BYTE0				        ;bmRequestType
	AND                 A,@0B01100000
	JBC                 STATUS,Z
	JMP                 STANDARD_DEVICE_REQUESTS	;bmRequestType[6,5]=[0,0]
	XOR                 A,@0B00100000
	JBC                 STATUS,Z
	JMP                 CLASS_SPECIFIC_REQUESTS		;bmRequestType[6,5]=[0,1]    [0,1]
	JMP                 STALL_STATUS				;bmRequestType[6,5]=[1,0] OR [1,1]

STANDARD_DEVICE_REQUESTS:
	MOV                 A,@0B00000110                  ;0X06
	XOR                 A,BYTE1				        ;bRequest (Request Code)
	JBC                 STATUS,Z
	JMP                 GET_DESCRIPTOR
	JMP                 STALL_STATUS
  GET_DESCRIPTOR:
	CLR                 TABLE_INDEX
	MOV                 A,BYTE3				        ;wValue (Descriptor Type)
	AND                 A,@0B01100000
	JBC                 STATUS,Z
	JMP                 STANDARD_DESCRIPTOR_TYPE	;wValue[6,5]=[0,0]
	XOR                 A,@0B00100000
	JBC                 STATUS,Z
	JMP                 CLASS_DESCRIPTOR_TYPE		;wValue[6,5]=[0,1]
	JMP                 STALL_STATUS				;wValue[6,5]=[1,0] OR [1,1]

  STANDARD_DESCRIPTOR_TYPE:
	MOV                 A,BYTE3
	SUB                 A,@0X03
	JBS                 STATUS,C
	JMP                 STALL_STATUS

	TBL
	JMP                 STRING_SET          ;	3
	JMP                 CONFIG_SET          ;	2
	JMP                 DEVICE_SET          ;	1
	JMP                 STALL_STATUS        ;	0

  CLASS_DESCRIPTOR_TYPE:
	MOV                 A,@0X21
	XOR                 A,BYTE3
	JBC                 STATUS,2
	JMP                 HID_SET             ; GET HID

	MOV                 A,@0X22
	XOR                 A,BYTE3
	JBC                 STATUS,2
	JMP                 HID_REPORT_SET      ; GET REPORT

  STALL_STATUS:
	BS                  RC,0
	BC                  RC,7
	BC                  ISR,EP0IF
	JMP                 BC_EP0_FLAG
;----------------------------
;	GET DESCRIPTOR
;----------------------------
  DEVICE_SET:
	CLR                 CMD_SELECT
	MOV                 A,@0X12
	MOV                 DataMaxTable1,A
	CLR                 DataMaxTable2
	CLR                 DataMaxTable3
	CALL                Set_Table1_Select
	JMP                 END_DESCRIPTOR

  CONFIG_SET:
	MOV                 A,@0X01
	MOV                 CMD_SELECT,A
	MOV                 A,@0X22
	MOV                 DataMaxTable1,A
	CLR                 DataMaxTable2
	CLR                 DataMaxTable3
	CALL                Set_Table1_Select
	JMP                 END_DESCRIPTOR

  HID_SET:
	MOV                 A,@0X01
	MOV                 CMD_SELECT,A
	MOV                 A,@0X12
	MOV                 TABLE_INDEX,A
	MOV                 A,@0X09
	MOV                 DataMaxTable1,A
	CLR                 DataMaxTable2
	CLR                 DataMaxTable3
	CALL                Set_Table1_Select
	JMP                 END_DESCRIPTOR

  HID_REPORT_SET:
	MOV                 A,@0X02
	MOV                 CMD_SELECT,A
	MOV                 A,@(End_HID_Report_Table1-Begin_HID_Report_Table1)
	MOV                 DataMaxTable1,A
	MOV                 A,@(End_HID_Report_Table2-Begin_HID_Report_Table2)
	MOV                 DataMaxTable2,A
	MOV                 A,@(End_HID_Report_Table3-Begin_HID_Report_Table3)
	MOV                 DataMaxTable3,A
	JMP                 END_DESCRIPTOR

  STRING_SET:
	MOV                 A,@0X00
	XOR                 A,BYTE2
	JBC                 STATUS,2
	JMP                 STRING0

	MOV                 A,@0X02
	XOR                 A,BYTE2
	JBC                 STATUS,2
	JMP                 STRING2
  STRING0:
	MOV                 A,@0X06
	MOV                 CMD_SELECT,A
	MOV                 A,@0X04
	MOV                 DataMaxTable1,A
	JMP                 END_DESCRIPTOR

  STRING2:
	MOV                 A,@0X07
	MOV                 CMD_SELECT,A
	MOV                 A,@0X1E
	MOV                 DataMaxTable1,A
	JMP                 END_DESCRIPTOR

  END_DESCRIPTOR:
	MOV                 A,BYTE6
	MOV                 PC_WANT0,A
	MOV                 A,BYTE7
	MOV                 PC_WANT1,A
	BS                  SetupDataStageFlag/16,SetupDataStageFlag%16
	JMP                 BC_EP0_FLAG

;------------------------------------------
;	HID_CLASS_SPECIFIC_REQUESTS
;------------------------------------------
CLASS_SPECIFIC_REQUESTS:
	MOV                 A,@0X21
	XOR                 A,BYTE0
	JBC                 STATUS,Z
	JMP                 HID_SET_REQUEST

	MOV                 A,@0XA1
	XOR                 A,BYTE0
	JBC                 STATUS,Z
	JMP                 HID_GET_REQUEST
	JMP                 STALL_STATUS

  HID_SET_REQUEST:
	MOV                 A,@0X09
	XOR                 A,BYTE1
	JBC                 STATUS,Z
	JMP                 SET_REPORT

	MOV                 A,@0X0A
	XOR                 A,BYTE1
	JBC                 STATUS,Z
	JMP                 SET_IDLE

	MOV                 A,@0X0B
	XOR                 A,BYTE1
	JBC                 STATUS,Z
	JMP                 SET_PROTOCOL
	JMP                 STALL_STATUS

  SET_REPORT:
	JMP                 SET_RET
  SET_IDLE:
	MOV                 A,BYTE3
	MOV                 IDLE_TEMP,A
	JMP                 SET_RET
  SET_PROTOCOL:
	MOV                 A,BYTE2
	MOV                 PROTOCOL_TEMP,A
  SET_RET:
	CLR                 TABLE_INDEX
	CLR                 DataMaxTable1
	CLR                 PC_WANT0
	CLR                 PC_WANT1
	BS                  SetupDataStageFlag/16,SetupDataStageFlag%16
	CLRA
	JMP                 BC_EP0_FLAG

  HID_GET_REQUEST:
	MOV                 A,BYTE1
	SUB                 A,@0X03
	JBS                 STATUS,C
	JMP                 STALL_STATUS
	TBL
	JMP                 GET_PROTOCOL     ; BYTE1 = 0X03
	JMP                 GET_IDLE         ; BYTE1 = 0X02
	JMP                 GET_REPORT       ; BYTE1 = 0X01
	JMP                 STALL_STATUS

  GET_IDLE:
	MOV                 A,@0X03
	MOV                 CMD_SELECT,A
	JMP                 GET_RET
  GET_PROTOCOL:
	MOV                 A,@0X04
	MOV                 CMD_SELECT,A
	JMP                 GET_RET
  GET_REPORT:
	MOV                 A,@0X05
	MOV                 CMD_SELECT,A
  GET_RET:
	MOV                 A,@0X01
	MOV                 DataMaxTable1,A
	JMP                 END_DESCRIPTOR

  BC_EP0_FLAG:
	BC                  ISR,EP0IF
	PAGE                0
	JMP                 INT_RET


;===================================================================================
;===================================================================================
EP0_REPORT:
	BS                  RC,EP0_W          ;Set 1, when MCU will write data to FIFO
	JBS                 RC,EP0_BUSY       ;It is '1' while UDC write/read endpoint0 FIFO
	JMP                 REPORT_INITIAL
	BC                  RC,EP0_W          ;if EP0 busy go back main loop wait for udc non-busy
	RET
  REPORT_INITIAL:	                   ;clear pointer and counter
	MOV                 A,@0X10
	MOV                 RD,A       ;set to control pointer & counter
	CLR                 RE         ;clear pointer & counter
	CLR                 RD         ; FIFO adress=base
  REPORT_START:
	MOV                 DataMaxTable1,DataMaxTable1
	JBS                 STATUS,Z
	JMP                 Load_FIFO_ByteLength	    ;if DataMaxTable1/2/3 = 0  jmp to finish
	MOV                 DataMaxTable2,DataMaxTable2
	JBS                 STATUS,Z
	JMP                 Load_FIFO_ByteLength
	MOV                 DataMaxTable3,DataMaxTable3
	JBC                 STATUS,Z
	JMP                 FINISH

  Load_FIFO_ByteLength:
	MOV                 A,@0X08
	MOV                 DataByteLength,A
	;CLR                 RE
	CLR                 RD
  REPORT_LOOP:
	MOV                 A,CMD_SELECT
	TBL
	JMP                 DEVICE_LOOP	;0
	JMP                 CONFIG_LOOP	;1
	JMP                 HID_REPORTL	;2
	JMP                 IDLE_LOOP	;3
	JMP                 PROTOCOLL	;4
	JMP                 REPORT_EP0	;5
	JMP                 STRING0L	;6
	;JMP                 STRING1L    ;7
	JMP                 STRING2L	;8

;-------------------------------------------------------------
  DEVICE_LOOP:
	MOV                 A,TABLE_INDEX
	PAGE                3
	CALL                DEVICE_TABLE
	PAGE                4
	JMP                 RLOOP
;-------------------------------------------------------------
  CONFIG_LOOP:
	MOV                 A,TABLE_INDEX
	PAGE                3
	CALL                CONFIG_TABLE
	PAGE                4
	JMP                 RLOOP
;-------------------------------------------------------------
  HID_REPORTL:
	JBC                 TableSelectFlag1/16,TableSelectFlag1%16
	JMP                 HID_Table_1st
	JBC                 TableSelectFlag2/16,TableSelectFlag2%16
	JMP                 HID_Table_2nd
	JBC                 TableSelectFlag3/16,TableSelectFlag3%16
	JMP                 HID_Table_3rd

  HID_Table_1st:
	MOV                 A,TABLE_INDEX
	PAGE                3
	CALL                HID_REPORT_TABLE1
	PAGE                4
	JMP                 RLOOP
  HID_Table_2nd:
	MOV                 A,TABLE_INDEX
	PAGE                3
	CALL                HID_REPORT_TABLE2
	PAGE                4
	JMP                 RLOOP
  HID_Table_3rd:
	MOV                 A,TABLE_INDEX
	PAGE                3
	CALL                HID_REPORT_TABLE3
	PAGE                4
	JMP                 RLOOP
;--------------------------------------------------------------
  IDLE_LOOP:
	MOV                 A,IDLE_TEMP
	JMP                 RLOOP
;---------------------------------------------------------------
  PROTOCOLL:
	MOV                 A,PROTOCOL_TEMP
	JMP                 RLOOP
;---------------------------------------------------------------
  REPORT_EP0:
	MOV                 A,@0X10
	MOV                 RD,A		;EP0 POINTER&COUNTER
	CLR                 RE
	MOV                 A,@0X00
	MOV                 RD,A		;EP0 FIFO
	CALL                SEND_USB_DATA
	JMP                 FINISH
;---------------------------------------------------------------
  STRING0L:
	MOV                 A,TABLE_INDEX
	PAGE                3
	CALL                STRING0T
	PAGE                4
	JMP                 RLOOP

;STRING1L:
;	CALL                STRING_SUB
;	CALL                STRING1T
;	JMP                 RLOOP

  STRING2L:
	CALL                STRING_SUB
	JMP                 RLOOP

  STRING_SUB:
	MOV                 A,TABLE_INDEX
	SUB	                A,@0X01
	JBC                 STATUS,C
	RET
	JBC                 TABLE_INDEX,0
	RETL                @0X02
	RRCA                TABLE_INDEX
	ADD                 A,@0X02
	RET

;***************************************************************
;***************************************************************
RLOOP:
	MOV                 RE,A
	INC                 TABLE_INDEX
	DEC                 PC_WANT0
	MOV                 PC_WANT0,PC_WANT0
	JBC                 STATUS,Z
	JMP                 Null_Data                 ;PC_WANT0 null data

  To_Continue:
	MOV                 DataMaxTable3,DataMaxTable3
	JBS                 STATUS,Z
	JMP                 Continue_Fill_In_8Byte
	MOV                 DataMaxTable2,DataMaxTable2
	JBS                 STATUS,Z
	JMP                 Continue_Fill_In_8Byte
	MOV                 DataMaxTable1,DataMaxTable1
	JBC                 STATUS,Z
	JMP                 FINISH

  Continue_Fill_In_8Byte:
	DJZ                 DataByteLength
	JMP                 Fill_In_8Byte_Cycle

	JBC                 TableSelectFlag3/16,TableSelectFlag3%16
	DEC                 DataMaxTable3
	JBC                 TableSelectFlag2/16,TableSelectFlag2%16
	DEC                 DataMaxTable2
	JBC                 TableSelectFlag1/16,TableSelectFlag1%16
	DEC                 DataMaxTable1
	CALL                Set_Table_Select
	JMP                 END_Fill_In_8Byte_Cycle   ;8 byte full , End this cycle

  Fill_In_8Byte_Cycle:
	JBC                 TableSelectFlag3/16,TableSelectFlag3%16
	DEC                 DataMaxTable3
	JBC                 TableSelectFlag2/16,TableSelectFlag2%16
	DEC                 DataMaxTable2
	JBC                 TableSelectFlag1/16,TableSelectFlag1%16
	DEC                 DataMaxTable1
	CALL                Set_Table_Select
	MOV                 DataMaxTable3,DataMaxTable3
	JBS                 STATUS,Z
	JMP                 HID_NOT_END
	MOV                 DataMaxTable2,DataMaxTable2
	JBS                 STATUS,Z
	JMP                 HID_NOT_END
	MOV                 DataMaxTable1,DataMaxTable1
	JBS                 STATUS,Z
	JMP                 HID_NOT_END
	JMP                 END_Fill_In_8Byte_Cycle
  HID_NOT_END:
	JBC                 TableSelectFlag1/16,TableSelectFlag1%16
	JMP                 Table1_Sel
	JBC                 TableSelectFlag2/16,TableSelectFlag2%16
	JMP                 Table2_Sel
	JBC                 TableSelectFlag3/16,TableSelectFlag3%16
	JMP                 Table3_Sel
  Table1_Sel:
	;DEC                 DataMaxTable1
	MOV                 DataMaxTable1,DataMaxTable1
	JBC                 STATUS,Z
	JMP                 FINISH
	JMP                 REPORT_LOOP
  Table2_Sel:
	;DEC                 DataMaxTable2
	MOV                 DataMaxTable2,DataMaxTable2
	JBC                 STATUS,Z
	JMP                 FINISH
	JMP                 REPORT_LOOP
  Table3_Sel:
	;DEC                 DataMaxTable3
	MOV                 DataMaxTable3,DataMaxTable3
	JBC                 STATUS,Z
	JMP                 FINISH
	JMP                 REPORT_LOOP

  Null_Data:
	MOV                 A,PC_WANT1
	JBC                 STATUS,Z
	JMP                 FINISH
	DEC                 PC_WANT1
	JMP                 To_Continue

  END_Fill_In_8Byte_Cycle:
	NOP
	BC                  RC,7
	BS                  RC,6
	RET

  Set_Table_Select:
	MOV                 DataMaxTable3,DataMaxTable3
	JBS                 STATUS,Z
	CALL                Set_Table3_Select
	MOV                 DataMaxTable2,DataMaxTable2
	JBS                 STATUS,Z
	CALL                Set_Table2_Select
	MOV                 DataMaxTable1,DataMaxTable1
	JBS                 STATUS,Z
	CALL                Set_Table1_Select
	RET
  Set_Table1_Select:
	BS                  TableSelectFlag1/16,TableSelectFlag1%16
	BC                  TableSelectFlag2/16,TableSelectFlag2%16
	BC                  TableSelectFlag3/16,TableSelectFlag3%16
	MOV                 A,TABLE_INDEX         ;table max mustn't at 8*N,or it will error
	XOR                 A,@(End_HID_Report_Table3-Begin_HID_Report_Table3)
	JBC                 STATUS,Z
	CLR                 TABLE_INDEX
	RET
  Set_Table2_Select:
	BC                  TableSelectFlag1/16,TableSelectFlag1%16
	BS                  TableSelectFlag2/16,TableSelectFlag2%16
	BC                  TableSelectFlag3/16,TableSelectFlag3%16
	MOV                 A,TABLE_INDEX         ;table max mustn't at 8*N,or it will error
	XOR                 A,@(End_HID_Report_Table3-Begin_HID_Report_Table3)
	JBC                 STATUS,Z
	CLR                 TABLE_INDEX
	RET
  Set_Table3_Select:
	BC                  TableSelectFlag1/16,TableSelectFlag1%16
	BC                  TableSelectFlag2/16,TableSelectFlag2%16
	BS                  TableSelectFlag3/16,TableSelectFlag3%16
	MOV                 A,TABLE_INDEX         ;table max mustn't at 8*N,or it will error
	XOR                 A,@(End_HID_Report_Table3-Begin_HID_Report_Table3)
	JBC                 STATUS,Z
	CLR                 TABLE_INDEX
	RET
;=========================================================
  FINISH:
	BC                  RC,7
	BS                  RC,6
	BC                  SetupDataStageFlag/16,SetupDataStageFlag%16
	RET


;=================================================================
;	USB DATA FORMAT
;	BYTE1	BYTE2	BYTE3	BYTE4	BYTE5	BYTE6	BYTE7	BYTE8
;   BOOT	BTM	X_8	Y_8	--	--	--	--	--
;=================================================================
SEND_USB_DATA:
	MOV                 A,@0X01
	MOV                 RE,A			;BYTE1(BTM)

  REPORT_PROTOCOL_DATA:
	MOV                 A,@0X7F
	MOV                 RE,A			;BYTE2(X)
	MOV                 RE,A			;BYTE3(Y)
	MOV                 RE,A			;BYTE4
	MOV                 RE,A			;BYTE5
	MOV                 A,@0X3F
	MOV                 RE,A			;BYTE6(X)
	MOV                 A,@0X00
	MOV                 RE,A			;BYTE7(X)
	MOV                 RE,A			;BYTE8(X)

	JBC                 RD,0		;CHECK EP0 or EP1
	BS                  RC,EP1_R
  RETURN:
	RET

;=================================================================================
;================================================================================
USB_MAIN:
	JBC                 UsbEP0interruptflag/16,UsbEP0interruptflag%16
	RET
	MOV                 A,ComuClock    ;8ms
	SUB                 A,@0X40
	JBC                 STATUS,C
	JMP                 Add_TimeCount
	INC                 TEMP
	CLR                 ComuClock
	MOV                 A,TEMP
	SUB                 A,@0X10        ;T = 0x10*0X50*ComuClock
	JBC                 STATUS,C
	JMP                 Add_TimeCount
	NOP
	CLR                 TEMP
	BS                  UsbEP0interruptflag/16,UsbEP0interruptflag%16
	RET
 Add_TimeCount:
	NOP
	CALL                PAGE4BANK0
	JBC                 RC,EP0_R       ;EP0 FIFO READED £»it is auto clear by udc and data send out finish
	JMP                 USB_MAIN
	JBC                 SetupDataStageFlag/16,SetupDataStageFlag%16    ;CHECK SETUP TRANSFER DATA STAGE
	CALL                EP0_REPORT
	NOP
	JMP                 USB_MAIN




;===================================================================================
; ipnut data
;=================================================================================




;============================ Digital MODE=================================
EP1_Report_1st:
;--------------------------------------------------------------------
	CALL                PAGE4BANK2
	JBC                 RC,EP1_R         ;CHECK EP1 DATA HAS BEEN READED BY HOST
	RET
	BC                  RC,EP1_R
	MOV                 A,@0X11
	MOV                 RD,A		     ;EP1 POINTER&COUNTER
	CLR                 RE
	MOV                 A,@0X01
	MOV                 RD,A             ;EP1 FIFO

	MOV                 A,@0X01
	MOV                 RE,A             ;BYTE1 (ID)
	MOV                 A,TX1_DATA1
	MOV                 RE,A             ;BYTE2 (LX)
	MOV                 A,TX1_DATA2
	MOV                 RE,A             ;BYTE3 (LY)
	MOV                 A,TX1_DATA3
	MOV                 RE,A             ;BYTE4 (RX)
	MOV                 A,TX1_DATA4
	MOV                 RE,A             ;BYTE5 (RY)
	MOV                 A,TX1_DATA5
	MOV                 RE,A             ;BYTE6 "A_1  B_2  C_3  D_4  L1_5  R1_6  L2_7  R2_8"
	MOV                 A,TX1_DATA6
	MOV                 RE,A             ;BYTE7 "SEL_9  START_10  LSW_11  RSW_12  T_13  T_14  MACRO   MODE"
	MOV                 A,TX1_DATA7
	MOV                 RE,A             ;BYTE8 (Hat Switch)

	BS                  RC,5
	RET

;------------------------------------------------------------------------
EP1_Report_2nd:
	NOP
	CALL                PAGE4BANK2
	JBC                 RC,EP1_R    ;CHECK EP1 DATA HAS BEEN READED BY HOST
	RET
	BC                  RC,EP1_R
	MOV                 A,@0X11
	MOV                 RD,A		;EP1 POINTER&COUNTER
	CLR                 RE
	MOV                 A,@0X01
	MOV                 RD,A        ;EP1 FIFO

	MOV                 A,@0X02
	MOV                 RE,A             ;BYTE1 (ID)
	MOV                 A,TX2_DATA1
	MOV                 RE,A             ;BYTE2 (LX)
	MOV                 A,TX2_DATA2
	MOV                 RE,A             ;BYTE3 (LY)
	MOV                 A,TX2_DATA3
	MOV                 RE,A             ;BYTE4 (RX)
	MOV                 A,TX2_DATA4
	MOV                 RE,A             ;BYTE5 (RY)
	MOV                 A,TX2_DATA5
	MOV                 RE,A             ;BYTE6 "A_1  B_2  C_3  D_4  L1_5  R1_6  L2_7  R2_8"
	MOV                 A,TX2_DATA6
	MOV                 RE,A             ;BYTE7 "SEL_9  START_10  LSW_11  RSW_12  T_13  T_14  MACRO   MODE"
	MOV                 A,TX2_DATA7
	MOV                 RE,A             ;BYTE8 (Hat Switch)

	BS                  RC,5
	RET

;---------------------------------------------------------------------------
EP1_Report_3rd:
	CALL                PAGE4BANK2
	JBC                 RC,EP1_R    ;CHECK EP1 DATA HAS BEEN READED BY HOST
	RET
	BC                  RC,EP1_R
	MOV                 A,@0X11
	MOV                 RD,A		;EP1 POINTER&COUNTER
	CLR                 RE
	MOV                 A,@0X01
	MOV                 RD,A        ;EP1 FIFO

	MOV                 A,@0X03
	MOV                 RE,A             ;BYTE1 (ID)
	MOV                 A,TX3_DATA1
	MOV                 RE,A             ;BYTE2 (LX)
	MOV                 A,TX3_DATA2
	MOV                 RE,A             ;BYTE3 (LY)
	MOV                 A,TX3_DATA3
	MOV                 RE,A             ;BYTE4 (RX)
	MOV                 A,TX3_DATA4
	MOV                 RE,A             ;BYTE5 (RY)
	MOV                 A,TX3_DATA5
	MOV                 RE,A             ;BYTE6 "A_1  B_2  C_3  D_4  L1_5  R1_6  L2_7  R2_8"
	MOV                 A,TX3_DATA6
	MOV                 RE,A             ;BYTE7 "SEL_9  START_10  LSW_11  RSW_12  T_13  T_14  MACRO   MODE"
	MOV                 A,TX3_DATA7
	MOV                 RE,A             ;BYTE8 (Hat Switch)

	BS                  RC,5
	RET

;---------------------------------------------------------------------------
EP1_Report_4th:
	CALL                PAGE4BANK2
	JBC                 RC,EP1_R    ;CHECK EP1 DATA HAS BEEN READED BY HOST
	RET
	BC                  RC,EP1_R
	MOV                 A,@0X11
	MOV                 RD,A		;EP1 POINTER&COUNTER
	CLR                 RE
	MOV                 A,@0X01
	MOV                 RD,A        ;EP1 FIFO

	MOV                 A,@0X04
	MOV                 RE,A             ;BYTE1 (ID)
	MOV                 A,TX4_DATA1
	MOV                 RE,A             ;BYTE2 (LX)
	MOV                 A,TX4_DATA2
	MOV                 RE,A             ;BYTE3 (LY)
	MOV                 A,TX4_DATA3
	MOV                 RE,A             ;BYTE4 (RX)
	MOV                 A,TX4_DATA4
	MOV                 RE,A             ;BYTE5 (RY)
	MOV                 A,TX4_DATA5
	MOV                 RE,A             ;BYTE6 "A_1  B_2  C_3  D_4  L1_5  R1_6  L2_7  R2_8"
	MOV                 A,TX4_DATA6
	MOV                 RE,A             ;BYTE7 "SEL_9  START_10  LSW_11  RSW_12  T_13  T_14  MACRO   MODE"
	MOV                 A,TX4_DATA7
	MOV                 RE,A             ;BYTE8 (Hat Switch)

	BS                  RC,5
	RET

;---------------------------------------------------------------------------
EP1_Report_5th:
	CALL                PAGE4BANK3
	JBC                 RC,EP1_R    ;CHECK EP1 DATA HAS BEEN READED BY HOST
	RET
	BC                  RC,EP1_R
	MOV                 A,@0X11
	MOV                 RD,A		;EP1 POINTER&COUNTER
	CLR                 RE
	MOV                 A,@0X01
	MOV                 RD,A        ;EP1 FIFO

	MOV                 A,@0X05
	MOV                 RE,A             ;BYTE1 (ID)
	MOV                 A,TX5_DATA1
	MOV                 RE,A             ;BYTE2 (LX)
	MOV                 A,TX5_DATA2
	MOV                 RE,A             ;BYTE3 (LY)
	MOV                 A,TX5_DATA3
	MOV                 RE,A             ;BYTE4 (RX)
	MOV                 A,TX5_DATA4
	MOV                 RE,A             ;BYTE5 (RY)
	MOV                 A,TX5_DATA5
	MOV                 RE,A             ;BYTE6 "A_1  B_2  C_3  D_4  L1_5  R1_6  L2_7  R2_8"
	MOV                 A,TX5_DATA6
	MOV                 RE,A             ;BYTE7 "SEL_9  START_10  LSW_11  RSW_12  T_13  T_14  MACRO   MODE"
	MOV                 A,TX5_DATA7
	MOV                 RE,A             ;BYTE8 (Hat Switch)

	BS                  RC,5
	RET

;---------------------------------------------------------------------------
EP1_Report_6th:
	CALL                PAGE4BANK3
	JBC                 RC,EP1_R    ;CHECK EP1 DATA HAS BEEN READED BY HOST
	RET
	BC                  RC,EP1_R
	MOV                 A,@0X11
	MOV                 RD,A		;EP1 POINTER&COUNTER
	CLR                 RE
	MOV                 A,@0X01
	MOV                 RD,A        ;EP1 FIFO

	MOV                 A,@0X06
	MOV                 RE,A             ;BYTE1 (ID)
	MOV                 A,TX6_DATA1
	MOV                 RE,A             ;BYTE2 (LX)
	MOV                 A,TX6_DATA2
	MOV                 RE,A             ;BYTE3 (LY)
	MOV                 A,TX6_DATA3
	MOV                 RE,A             ;BYTE4 (RX)
	MOV                 A,TX6_DATA4
	MOV                 RE,A             ;BYTE5 (RY)
	MOV                 A,TX6_DATA5
	MOV                 RE,A             ;BYTE6 "A_1  B_2  C_3  D_4  L1_5  R1_6  L2_7  R2_8"
	MOV                 A,TX6_DATA6
	MOV                 RE,A             ;BYTE7 "SEL_9  START_10  LSW_11  RSW_12  T_13  T_14  MACRO   MODE"
	MOV                 A,TX6_DATA7
	MOV                 RE,A             ;BYTE8 (Hat Switch)

	BS                  RC,5
	RET
