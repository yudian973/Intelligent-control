;==================================================================
;  Tilte:       EM78M612 include file                ;
;  Description: The Definition of EM78M612 Registers ;
;  Company:     Elan Electronic Corp.                  ;
;  Author:      YU.WEI                            ;
;  Date:        2009.02.26                             ;
;  Version:     v1.0                                   ;
;===================================================================
;-----------------------------------------------------------------
EM78M611E.H     EQU     EM78M611E.H

;-----------------------------------------------------------------
; Indirect Addressing register
	R0      ==      0X00

; Time Clock/Counter
	R1      ==      0X01
	TCC     ==      0X01

; Program Counter
	R2      ==      0X02
	PC      ==      0X02

; Status Register
	R3      ==      0X03
	STATUS  ==      0X03
	;{
		C       == 0X00; CARRYFLAG
		DC      == 0X01; AUXILIARY CARRY FLAG
		Z       == 0X02; ZERO FLAG
		P       == 0X03; POWER DOWN BIT
		T       == 0X04; TIME-OUT BIT
		PS0     == 0X05; PAGE select BIT 1
		PS1     == 0X06; PAGE select BIT 2
		PS2     == 0X07; PAGE select BIT 3
		;{
			PAGE0	MACRO			;000
				BC	STATUS,PS2
				BC	STATUS,PS1
				BC	STATUS,PS0
				ENDM
			PAGE1	MACRO			;001
				BC	STATUS,PS2
				BC	STATUS,PS1
				BS	STATUS,PS0
				ENDM
			PAGE2	MACRO			;010
				BC	STATUS,PS2
				BS	STATUS,PS1
				BC	STATUS,PS0
				ENDM
			PAGE3	MACRO			;011
				BC	STATUS,PS2
				BS	STATUS,PS1
				BS	STATUS,PS0
				ENDM
			PAGE4	MACRO			;100
				BS	STATUS,PS2
				BC	STATUS,PS1
				BC	STATUS,PS0
				ENDM
			PAGE5	MACRO			;101
				BS	STATUS,PS2
				BC	STATUS,PS1
				BS	STATUS,PS0
				ENDM

		;}
          ;}


; RAM Select Register (RSR)
	R4             ==     0X04;
	RSR            ==     0X04
	;{
		BK0     == 0X06; BANK selector BIT 0
		BK1     == 0X07; BANK selector BIT 1

		BANK0	MACRO		;00
			BC	RSR,BK0
			BC	RSR,BK1
			ENDM
		BANK1	MACRO		;01
			BS	RSR,BK0
			BC	RSR,BK1
			ENDM
		BANK2	MACRO		;10
			BC	RSR,BK0
			BS	RSR,BK1
			ENDM
		BANK3	MACRO		;11
			BS	RSR,BK0
			BS	RSR,BK1
			ENDM
	;}

;====================================================================
	R5      == 0X05
	PORT5   == 0X05
	;{
		P57	== 0X07
		P56	== 0X06
		P55	== 0X05
		P54	== 0X04
		P53	== 0X03
		P52	== 0X02
		P51	== 0X01
		P50	== 0X00
	;}

;====================================================================
	R6      == 0X06
	PORT6   == 0X06
	;{
		P67	== 0X07
		P66	== 0X06
		P65	== 0X05
		P64	== 0X04
		P63	== 0X03
		P62	== 0X02
		P61	== 0X01
		P60	== 0X00
	;}

;====================================================================
	R7      == 0X07
	PORT7   == 0X07
	;{
		P77	== 0X07
		P76	== 0X06
		P75	== 0X05
		P74	== 0X04
		P73	== 0X03
		P72	== 0X02
		P71	== 0X01
		P70	== 0X00
	;}

;====================================================================
	R8      == 0X08; /PORT6 WAKE-UP PIN SELECT REGISTER
	PORT8   == 0X08
	;{
		P87	== 0X07
		P86	== 0X06
		P85	== 0X05
		P84	== 0X04
		P83	== 0X03
		P82	== 0X02
		P81	== 0X01
		P80	== 0X00
	;}

;====================================================================
	R9      == 0X09; /PORT7 WAKE-UP PIN SELECT REGISTER
	PORT9   == 0X09;
	;{
		P97	== 0X07
		P96	== 0X06
		P95	== 0X05
		P94	== 0X04
		P93	== 0X03
		P92	== 0X02
		P91	== 0X01
		P90	== 0X00
	;}

;====================================================================
	RA      == 0X0A; HIGH PATTERN COUNTER
	EECR    == 0X0A
	;{
		EE_OK	== 0X02
		EE_C1	== 0X01
		EE_C0	== 0X00
	;}

;====================================================================
	RB      == 0X0B; LOW PATTERN COUNTER
	PDACR       == 0X0B
	;{
		SE2F    == 0X07
		SE1F    == 0X06
		SR2	== 0X05
		SR1	== 0X04
		SR0	== 0X03
		DB2	== 0X02
		DB1	== 0X01
		DB0	== 0X00
	;}

;====================================================================
	RC      == 0X0C; USB APPLICATION STATUS REGISTER
	USBASR  == 0X0C
	;{
		EP0_W           == 0X07
		EP0_R           == 0X06
		EP1_R           == 0X05
		EP2_R           == 0X04
		EP2_W           == 0X03
		HOST_SUSPEND    == 0X02
		EP0_BUSY        == 0X01
		STALL           == 0X00
	;}

;====================================================================
	RD       == 0X0D; USB APPLICATION FIFO ADDRESS REGISTER
	FIFOAR   == 0X0D
	;{
		;---------------------------
		;   00	Endpoint 0
			;---------
			;    0
			;---------
			;    1
			;---------
			;    2
			;---------
			;    3
			;---------
			;    4
			;---------
			;    5
			;---------
			;    6
			;---------
			;    7
		;---------------------------
		;    01    ;
		;    :     ;
		;    :	   ; Endpoint address
		;    :     ;
		;    0F    ;
		;---------------------------
		;    10	   ; EP0_STATUS
		;---------------------------
		;    11    ;
		;    :     ;
		;    :     ; EP_STATUS
		;    :     ;
		;    1F    ;
		;---------------------------

	;}

;====================================================================
	RE          == 0X0E; USB APPLICATION FIFO DATA REGISTER ¡A[0..3]POINTER [4..7]COUNTER
	FIFODR      == 0X0E
	;{

	;}

;====================================================================
	RF      == 0X0F; INTERRUPT STATUS REGISTER
	ISR     == 0X0F; INTERRUPT STATUS REGISTER
	;{
		TCCIF       == 0X00
		EP0IF       == 0X01
		USBSIF      == 0X02
		USBRIF      == 0X03
		P7SCIF      == 0X04
		SE1IF       == 0X05
		SE2IF       == 0X06
		USBHRIF     == 0X07
	;}

;====================================================================


	IOC5		== 0X05;	port 5 direction control register
	IOC6		== 0X06;	port 6 direction control register
	IOC7		== 0X07;	port 7 direction control register
	IOC8		== 0X08; 	port 8 direction control register
	IOC9		== 0X09; 	port 9 direction control register
	IOCA		== 0X0A; 	OPERATION MODE
	;{
		USBM        == 0X00
		PS2M        == 0X01
		PDAM        == 0X02
		EXRegSel    == 0X03
	;}
;====================================================================
	IOCB		== 0X0B; PORT6 PULL-LOW

;====================================================================
	IOCC		== 0X0C; PORT6 PULL-HIGH

;====================================================================
	IOCD		== 0X0D; PORT7 PULL-HIGH

;====================================================================
	IOCE		== 0X0E; SPECIAL FUNCTION
	SFCR		== 0X0E;
	;{
		RUN         == 0X04
		WTE         == 0X05
		_PULL8      == 0X02
		_PULL6      == 0X01
		_PULL5      == 0X00
	;}

;====================================================================
	IOCF    == 0X0F; INTERRUPT MASK
	IMR     == 0X0F
	;{
		TCIE        == 0X00
		EPOIE       == 0X01
		USBSIE      == 0X02
		USBRIE      == 0X03
		P5SCIE      == 0X04
		SE1IE       == 0X05
		SE2IE       == 0X06
		USBHRIE     == 0X04
	;}




;======================================================;
; Register R10~R3F                                     ;
;======================================================;
;
; (R10 ~ R3F): General Purpose Register
;
 R10    ==    0x10
 R11    ==    0x11
 R12    ==    0x12
 R13    ==    0x13
 R14    ==    0x14
 R15    ==    0x15
 R16    ==    0x16
 R17    ==    0x17
 R18    ==    0x18
 R19    ==    0x19
 R1A    ==    0x1A
 R1B    ==    0x1B
 R1C    ==    0x1C
 R1D    ==    0x1D
 R1E    ==    0x1E
 R1F    ==    0x1F
;
 R20    ==    0x20
 R21    ==    0x21
 R22    ==    0x22
 R23    ==    0x23
 R24    ==    0x24
 R25    ==    0x25
 R26    ==    0x26
 R27    ==    0x27
 R28    ==    0x28
 R29    ==    0x29
 R2A    ==    0x2A
 R2B    ==    0x2B
 R2C    ==    0x2C
 R2D    ==    0x2D
 R2E    ==    0x2E
 R2F    ==    0x2F
;
 R30    ==    0x30
 R31    ==    0x31
 R32    ==    0x32
 R33    ==    0x33
 R34    ==    0x34
 R35    ==    0x35
 R36    ==    0x36
 R37    ==    0x37
 R38    ==    0x38
 R39    ==    0x39
 R3A    ==    0x3A
 R3B    ==    0x3B
 R3C    ==    0x3C
 R3D    ==    0x3D
 R3E    ==    0x3E
 R3F    ==    0x3F