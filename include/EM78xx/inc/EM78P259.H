;******************************************************;
;  Title:       EM78P259N include file   	       ;
;  Description: The Definition of EM78P259N Registers  ;
;  Company:     ELAN MICROELECTRONICS (SZ) LTD.        ;
;  Date:	2008/04/16
;******************************************************;
EM78P259.H    EQU    EM78P259.H

;======================================================;
; Operational Registers Define                         ;
;======================================================;
;
;======================================================;
; Registers R0~R3F                                     ;
;======================================================;
;
; R0/IAR: Indirect Address Register
;
R0	==	0X00:rpage 0
IAR     ==      0X00:rpage 0
;
; R1/TCC: Time Clock/Counter
;
R1	==	0X01:rpage 0
TCC	==	0X01:rpage 0
;
;
; R2/PC: Program Counter & Stack
;
R2	==	0X02:rpage 0
PC	==	0X02:rpage 0
;
;
; R3/PSR: Process Status Register
;
R3	==	0X03:rpage 0
STATUS	==	0X03:rpage 0
;
	;{
	    RST	    ==	     STATUS.7    ;Bit of reset type
	    IOCS    ==       STATUS.6    ;I/O REGISTER PEGER CONTER BIT
	    				 ;0 = Segment 0 (IOC50 ~ IOCF0) selected
					 ;1 = Segment 1 (IOC51 ~ IOCC1) selected
	    PS0     ==       STATUS.5    ;Page select bits.
	    				 ;0:Page0[000-3FF]
	    				 ;1:Page1[400-7FF]
	    T       ==       STATUS.4    ; Time-out bit
            P       ==       STATUS.3    ; Power down bit
            Z       ==       STATUS.2    ; Zero flag
            DC      ==       STATUS.1    ; Auxiliary carry flag
            C       ==       STATUS.0    ; Carry flag
	;}		
;
;R4/RSR:RAM Select Register
;
R4	==	0X04:rpage 0
RSR	==	0X04:rpage 0
			;Bit 7: 	Set to "0" all the time
			;Bit 6: 	Used to select Bank 0 or Bank 1 of the register
			;Bits 5~0:	Used to select a register (Address: 00~0F, 10~3F) in indirect addressing mode
;
; R5 ~ R7: I/O Port Address
R5	==	0X05:rpage 0
PORT5	==      0X05:rpage 0
;
R6	==      0X06:rpage 0
PORT6	==      0X06:rpage 0
;
R7	==	0X07:rpage 0
PORT7	==	0X07:rpage 0
		;[With Simulator (C3~C0, RCM1, & RCM0)]: are IRC calibration bits in IRC oscillator mode
    ;{
	 C3	==	PORT7.7		;Calibrator of internal RC mode
	 C2	==	PORT7.6
	 C1	==	PORT7.5
	 C0	==	PORT7.4
	 RCM1	==	PORT7.3		;IRC mode selection bits
	 RCM0	==	PORT7.2 	;RCM 1	RCM 0	Frequency (MHz)
					;1	1	4 (default)
					;1	0	8
					;0	1	1
					;0	0	455kHz
     ;}
;
;R8/AISR: ADC Input Select Register
;
R8	==	0X08:rpage 0
AISR	==	0X08:rpage 0	
;
;{
					;ADC input select register
	ADE3	==	AISR.3		;AD converter enable bit of P53 pin
					;0 = Disable ADC3, P53 functions as I/O pin
					;1 = Enable ADC3 to function as analog input pin
	ADE2	==	AISR.2		;AD converter enable bit of P52 pin
					;0 = Disable ADC2, P52 functions as I/O pin
					;1 = Enable ADC2 to function as analog input pin
	ADE1	==	AISR.1		;AD converter enable bit of P51 pin
					;0 = Disable ADC1, P51 functions as I/O pin
					;1 = Enable ADC1 to function as analog input pin
	ADE0	==	AISR.0		;AD cnverter enable bit of P50 pin
					;0 = Disable ADC0, P50 functions as I/O pin
					;1 = Enable ADC0 to function as analog input pin

;}
;
;R9/ADCON: ADC Control Register
;
R9	==	0X09:rpage 0
ADCON	==	0X09:rpage 0
;{
	VREFS	==	ADCON.7		;Input source of the Vref of the ADC
					;0 = The Vref of the ADC is connected to Vdd (default value), and the P54/VREF pin carries out the function of P54
					;1 = The Vref of the ADC is connected to P54/VREF
	CKR1	==	ADCON.6		;Prescaler of oscillator clock rate of ADC
	CKR0	==	ADCON.5
					;00 = 1: 16 (default value)
					;01 = 1: 4
					;10 = 1: 64
					;11 = 1: WDT ring oscillator frequency
	ADRUN	==	ADCON.4		;ADC starts to RUN
					;0 = Reset upon completion of the conversion
					;1 = AD conversion is started
	ADPD	==	ADCON.3		;ADC Power-down mode
					;0 = Switch off the resistor reference to conserve power even while the CPU is operating
					;1 = ADC is operating
					;Bit 2:	Not used
	ADIS1	==	ADCON.1		;Analog Input Select
	ADIS0	==	ADCON.0		;Analog Input Select
					;00 = ADIN0/P50
					;01 = ADIN1/P51
					;10 = ADIN2/P52
					;11 = ADIN3/P53
;}
;
;RA/ADOC: ADC Offset Calibration Register
;
RA	==	0X0A:rpage 0
ADOC	==	0X0A:rpage 0
;{
	CALI	==	ADOC.7		;Calibration enable bit for ADC offset
					;0 = Calibration disable
					;1 = Calibration enable
	SIGN	==	ADOC.6		;Polarity bit of offset voltage
					;0 = Negative voltage
					;1 = Positive voltage
	VOF2	==	ADOC.5		;Offset voltage bits
	VOF1	==	ADOC.4		;Offset voltage bits
	VOF0	==	ADOC.3		;Offset voltage bits
					;|VOF[2]|VOF[1]	|VOF[0] |EM78P259N	|ICE259N|
					;|0	|0	|0	|0LSB		|0LSB   |
					;|0	|0	|1	|2LSB		|1LSB   |
					;|0	|1	|0	|4LSB		|2LSB   |
					;|0	|1	|1	|6LSB		|3LSB   |
					;|1	|0	|0	|8LSB		|4LSB   |
					;|1	|0	|1	|10LSB		|5LSB   |
					;|1	|1	|0	|12LSB		|6LSB   |
					;|1	|1	|1	|14LSB		|7LSB   |
					;Bit 2 ~ Bit 0:	Unimplemented, read as '0'
;}
;
;RB/ADDATA: Converted Value of ADC
;
RB	==	0X0B:rpage 0		;AD data high 8 bit
ADDATA	==	0X0B:rpage 0		;RB is read only. 
;
;RC/ADDATA1H: Converted Value of ADC
;
RC		==	0X0C:rpage 0	;RC is read only
ADDATA1H	==	0X0C:rpage 0	;AD DATA HIGHT 4 BIT
;
;RD/ADDATA1L: Converted Value of ADC
;
RD		==	0X0D:rpage 0	;AD data low 8 bit
ADDATA1L	==	0X0D:rpage 0	;RD is read only	
;
;RE/Interrupt Status 2 and Wake-up Control Register
;
RE	==	0X0E:rpage 0		;interrupt status & wake up control register  
ISR2	==	0X0E:rpage 0
WUCR	==	0X0E:rpage 0
;{
					;Bit 7 & Bit 6:	Not used
	ADIF	==	ISR2.5		;Interrupt flag for analog to digital conversion.  Set when AD conversion is completed
					;0 = no interrupt occurs
					;1 = with interrupt request
	CMPIF	==	ISR2.4		;Comparator interrupt flag.  Set when a change occurs in the output of Comparator.
					;0 = no interrupt occurs
					;1 = with interrupt reques
	ADWE	==	WUCR.3		;ADC wake-up enable bit
					;0 = Disable ADC wake-up
					;1 = Enable ADC wake-up
	CMPWE	==	WUCR.2		;Comparator wake-up enable bit
					;0 = Disable Comparator wake-up
					;1 = Enable Comparator wake-up
	ICWE	==	WUCR.1		;Port 5 input change to wake-up status enable bit
					;0 = Disable Port 5 input change to wake-up status
					;1 = Enable Port 5 input change to wake-up status
					;Bit 0:	Not implemented
;}
;
;RF/ISR1:Interrupt Status 1 Register
RF	==	0X0F:rpage 0		;interrupt status register
ISR1	==	0X0F:rpage 0
;{
	LPWTIF	==	ISR1.7		;Internal low-pulse width timer underflow interrupt flag for IR/PWM function
	HPWTIF	==	ISR1.6		;Internal high-pulse width timer underflow interrupt flag for IR/PWM function
	TCCCIF	==	ISR1.5		;TCCC overflow interrupt flag
	TCCBIF	==	ISR1.4		;TCCB overflow interrupt flag
	TCCAIF	==	ISR1.3		;TCCA overflow interrupt flag
	EXIF	==	ISR1.2		;External interrupt flag
	ICIF	==	ISR1.1		;Port 5 input status change interrupt flag
	TCIF	==	ISR1.0		;TCC overflow interrupt flag
;}
;
;
;======================================================;
; Special Purpose Registers Define                     ;
;======================================================;
;
; A: Accumulator
; It can't be addressed.
;
;
; CONT: Control Register
;
        ;{
            INTE   ==  7    ; INT signal edge
                                  ; 0: Interrupt occurs at the rising edge on the INT pin
                                  ; 1: Interrupt occurs at the falling edge on the INT pin
            INTF    ==  6    ; Interrupt enable
                                  ; 0: Masked by DISI or hardware interrupt
                                  ; 1: Enabled by ENI/RETI instructions
            TS      ==  5    ; TCC signal source
                                  ; 0: Internal instruction cycle clock
                                  ; 1: Transition on TCC pin
            TE      ==  4    ; TCC signal edge
                                  ; 0: Increment if the transition from low to high takes place on TCC pin
                                  ; 1: Increment if the transition from high to low takes place on TCC pin
            PSTE    ==  3    ; Prescaler enable bit for TCC
            		          ;0 = prescaler disable bit. TCC rate is 1:1.
            		          ;1 = prescaler enable bit. TCC rate is set as Bit 2 ~ Bit 0.
            PSR2    ==  2    ;
            PSR1    ==  1    ;
            PSR0    ==  0    ; (PSR2~PSR0): TCC prescaler Select bits
                                  ; ------------------------------ ;
                                  ; PSR2  PSR1  PSR0    TCC Rate   ;
                                  ;   0     0     0       1:2      ;
                                  ;   0     0     1       1:4      ;
                                  ;   0     1     0       1:8      ;
                                  ;   0     1     1       1:16     ;
                                  ;   1     0     0       1:32     ;
                                  ;   1     0     1       1:64     ;
                                  ;   1     1     0       1:128    ;
                                  ;   1     1     1       1:256    ;
                                  ; ------------------------------ ;
        ;}
;
;IOC50 ~ IOC70:I/O Port Control Register
;
IOC50	==	0X05:iopage 0
P5CR	==	0X05:iopage 0
IOC60	==	0X06:iopage 0
P6CR	==	0X06:iopage 0
IOC70	==	0X07:iopage 0
P7CR	==	0X07:iopage 0
	;Under 14 Pin :IOC50 <7, 6>, IOC60<5, 4, 3, 2> : These bits must set to "0" all the time,
	;	       Other bits could be readable and writable.
	;	       The IOC70 registers are all readable and writable.
 	;Under 16 Pin :IOC50 <7, 6>, IOC60 <3, 2> : These bits must be set to "0" all the time,
	;		Other bits could be readable and writable.
	;		The IOC70 registers are all readable and writable.
 	;Under 18 Pin :IOC50<7, 6> : These bits must set to "0" all the time,
	;		Other bits could readable and writable.
	;		The IOC60, IOC70 registers are all readable and writable.
 	;Under 20 Pin :The IOC50, IOC60, IOC70 registers are all readable and writable.
;
;IOC80/CTCR:Comparator and TCCA Control Register
;
IOC80	==	0X08:iopage 0
CMCR	==	0X08:iopage 0
TCCACR	==	0X08:iopage 0
;{
				;Bit 7 and Bit 6:Not used
	CMPOUT	==  5	;Result of the comparator output
	COS1	==  4	;Comparator/OP Select bits
	COS0	==  3	;Comparator/OP Select bits
				; |---------|---------|---------------------------------------------------------------------------|
				; | CMPCOS1 | CMPCPS0 | Function Description                                                      |
				; |---------|---------|---------------------------------------------------------------------------|
				; |   0     |   0     |Comparator and OP are not used.  P64, P65, and P66 are normal I/O pins     |
				; |   0     |   1     |Acts as Comparator and P64 is normal I/O pin                               |
				; |   1     |   0     |Acts as Comparator and P64 is Comparator output pin (CO)                   |
				; |   1     |   1     |Acts as OP and P64 is OP output pin (CO)                                   |
				; | --------|---------|---------------------------------------------------------------------------|
	TCCAEN	==  2	;TCCA ENABLE BIT
				;0 = disable TCCA 
				;1 = enable TCCA
	TCCATS	==  1	;TCCA SIGNAL SOURE
				;0 =: internal instruction cycle clock.  P61 is a bi-directional I/O pin. 
				;1 = transit through the TCCA pin
	TCCATE	==  0	;TCCA SIGNAL EDGE
				;0 = increment if transition from low to high takes place on the TCCA pin
				;1 = increment if transition from high to low takes place on the TCCA pin
;}
;
;IOC90/TCR::TCCB and TCCC Control Register
;
IOC90	==	0X09:iopage 0	;TCCB AND TCCC CONTORL REGISTER   
TCCBCR	==	0X09:iopage 0
TCCCCR	==	0X09:iopage 0
;{
	TCCBHE	==  7	;Control bit is used to enable the most significant byte of counter
				;0 = Disable the most significant byte of TCCBH (default value)
				;    TCCB is an 8-bit counter
				;1 = Enable the most significant byte of TCCBH 
				;    TCCB is a 16-bit counter	
	TCCBEN	==  6	;TCCB enable bit
				;0 = disable TCCB 
				;1 = enable TCCB 
	TCCBTS	==  5	;TCCB signal source
				;0 = internal instruction cycle clock.  P62 is a bi-directional I/O pin. 
				;1 = transit through the TCCB pin
	TCCBTE	==  4	;TCCB signal edge
				;0 = increment if the transition from low to high takes place on the TCCB pin
				;1 = increment if the transition from high to low takes place on the TCCB pin
			  	;Bit 3: Not used
	TCCCEN	== 2	;TCCC enable bit
				;0 = disable TCCC 
				;1 = enable TCCC
	TCCCTS	==  1	;TCCC signal source
				;0 = internal instruction cycle clock.  P63 is a bi-directional I/O pin. 
				;1 = transit through the TCCC pin
	TCCCTE	==  0	;TCCC signal edge
				;0 = increment if the transition from low to high takes place on the TCCC pin
				;1 = increment if the transition from high to low takes place on the TCCC pin
;}
;
;IOCA0/IRTCR:IR and TCCC Scale Control Register
;
 IOCA0	==	0X0A:iopage 0
 IRCR	==	0X0A:iopage 0
 TCCCSCR==	0X0A:iopage 0
;
;{
	TCCCSE	==  7	;SCALE ENABLE BIT FOR TCCC
				;0 = scale disable bit, TCCC rate is 1:1
				;1 = scale enable bit, TCCC rate is set as Bit 6 ~ Bit 4
	TCCS2	==  6	;TCCC scale bits
	TCCS1	==  5	;TCCC scale bits
	TCCS0	==  4	;TCCC scale bits
				;TCCCS2	TCCCS1	TCCCS0	TCCC Rate
				;0	0	0	1:2
				;0	0	1	1:4
				;0	1	0	1:8
				;0	1	1	1:16
				;1	0	0	1:32
				;1	0	1	1:64
				;1	1	0	1:128
				;1	1	1	1:256
	IRE	==  3	;Infrared Remote Enable bit
				;0:Disable IRE
				;1:Enable IRE
	HF	==  2	;High Frequency bit
				;0:PWM application
				;1:IR application mode
	LGP	==  1	;Long Pulse
				;0:high time register and low time register is valid
				;1:high time register is ignored
	IROUT	== 0	;Control bit to define the P67 (IROUT) pin function 
				;0:P67 is defined as bi-directional I/O pin
				;1:P67 is defined as IROUT
;}
;
;IOCB0/PDCR:Pull-down Control Register
;
IOCB0	==	0X0B:iopage 0		;PULL DOWN CONTROL REGISTER
PDCR	==	0X0B:iopage 0	
;{
  					;0 = Enable internal pull-down
					;1 = Disable internal pull-down
  	PD7B	==     7		;Control bit is used to enable the pull-down of the P57 pin
  	PD6B	==     6		;Control bit is used to enable the pull-down of the P56 pin
  	PD5B	==     5		;Control bit is used to enable the pull-down of the P55 pin
  	PD4B	==     4		;Control bit is used to enable the pull-down of the P54 pin
  	PD3B	==     3		;Control bit is used to enable the pull-down of the P53 pin
  	PD2B	==     2		;Control bit is used to enable the pull-down of the P52 pin
  	PD1B	==     1		;Control bit is used to enable the pull-down of the P51 pin
  	PD0B	==     0		;Control bit is used to enable the pull-down of the P50 pin	
;}
;
;IOCC0/OD6CR:Open-Drain Control Register
;
IOCC0	==	0X0C:iopage 0
ODCR	==	0X0C:iopage 0
;{
  					;0 = Enable open-drain output
					;1 = Disable open-drain output
  	OD7B   ==    7		;Control bit used to enable the open-drain output of the P67 pin
  	OD6B   ==    6		;Control bit used to enable the open-drain output of the P66 pin
  	OD5B   ==    5		;Control bit used to enable the open-drain output of the P65 pin
  	OD4B   ==    4		;Control bit used to enable the open-drain output of the P64 pin
   	OD3B   ==    3		;Control bit used to enable the open-drain output of the P63 pin
   	OD2B   ==    2		;Control bit used to enable the open-drain output of the P62 pin
  	OD1B   ==    1		;Control bit used to enable the open-drain output of the P61 pin
	OD0B   ==    0		;Control bit used to enable the open-drain output of the P60 pin
;}
;
;IOCD0/PHCR:Pull-high Control Register
;
IOCD0	==	0X0D:iopage 0
PHCR	==	0X0D:iopage 0
;{
					;0 = Enable internal pull-high
					;1 = Disable internal pull-high
  	PH7B   ==   7		;Control bit used to enable the pull-high function of the P57 pin
  	PH6B   ==   6		;Control bit used to enable the pull-high function of the P56 pin
  	PH5B   ==   5		;Control bit used to enable the pull-high function of the P55 pin
   	PH4B   ==   4		;Control bit used to enable the pull-high function of the P54 pin
   	PH3B   ==   3		;Control bit used to enable the pull-high function of the P53 pin
  	PH2B   ==   2		;Control bit used to enable the pull-high function of the P52 pin
  	PH1B   ==   1		;Control bit used to enable the pull-high function of the P51 pin
	PH0B   ==   0		;Control bit used to enable the pull-high function of the P50 pin
;}
;
;IOCE0/WDTCR:WDT Control and Interrupt Mask Registers 2
;
IOCE0	==	0X0E:iopage 0
WDTCR	==	0X0E:iopage 0
IMR2	==	0X0E:iopage 0
;{
	WDTE	==  7		;Control bit used to enable Watchdog Timer
					;0:Disable WDT
					;1:Enable WDT
	EIS	==  6		;Control bit used to define the function of the P60 (/INT) pin
					;0:P60, bi-directional I/O pin
					;1 :/INT, external interrupt pin
	ADIE	== 5		;ADIF INTERRUPT ENABLE BIT
					;0 = disable ADIF interrupt
					;1 = enable ADIF interrupt
	CMPIE	==  4		;CMPIF INTERRUPT ENABLE BIT
					;0 = disable CMPIF interrupt
					;1 = enable CMPIF interrupt
	PSWE	==  3		;Prescaler enable bit for WDT
					;0 = prescaler disable bit, WDT rate is 1:1
					;1 = prescaler enable bit, WDT rate is set as Bit 2 ~ Bit 0
	PSW2	==  2		;WDT PRESCALER BITS
	PSW1	==  1
	PSW0	==  0
  					; |------|------|------|----------|
                              		; | PSR2 | PSR1 | PSR0 | WDT Rate | 
                             		; |------|------|------|----------|
                             		; |  0   |  0   |  0   |   1:2    | 
                              		; |  0   |  0   |  1   |   1:4    |  
                              		; |  0   |  1   |  0   |   1:8    |  
                              		; |  0   |  1   |  1   |   1:16   |   
                              		; |  1   |  0   |  0   |   1:32   |   
                              		; |  1   |  0   |  1   |   1:64   |   
                              		; |  1   |  1   |  0   |   1:128  |   
                             		; |  1   |  1   |  1   |   1:256  |
                              		; |------|------|------|----------|
;}
;
;IOCF0/IMR1:Interrupt Mask Register
IOCF0	==	0X0F:iopage 0
IMR1	==	0X0F:iopage 0
;{
  				;0: Disable  interrupt
				;1: Enable  interrupt
        LPWTIE	==  7	;LPWTIF interrupt enable bit
  	HPWTIE	==  6	;HPWTIF interrupt enable bit
  	TCCCIE	==  5	;TCCCIF interrupt enable bit
  	TCCBIE	==  4	;TCCBIF interrupt enable bit
  	TCCAIE	==  3	;TCCAIF interrupt enable bit
  	EXIE 	==  2	;EX0IF and EX1IF interrupts enable bit
  	ICIE	==  1	;ICIF interrupt enable bit
  	TCIE	==  0	;TCIF interrupt enable bit
;}
;
;I/0 REGISTER PAGE 1
;
;IOC51/TCCAC:TCCA COUNTER
;
IOC51	==	0X05:iopage 1		;TCCA COUNTER		
TCCAC	==	0X05:iopage 1
;
;IOC61/TCCBLC:TCCB LSB Counter
;
IOC61	==	0X06:iopage 1		;TCCB Counter
TCCBLC	==	0X06:iopage 1
;
;IOC71/TCCBC:TCCB HSB COUNTER
;
IOC71	==	0X07:iopage 1		;TCCBHMSB COUNTER
TCCBHC	==	0X07:iopage 1
;
;IOC81/TCCCC:;TCCC Counter
IOC81	==	0X08:iopage 1		;TCCC Counter
TCCCC	==	0X08:iopage 1
;
;IOC91/LTR:LOW TIME REGISTER
;
IOC91	==	0X09:iopage 1		;LOW TIME REGISTER
LTR	==	0X09:iopage 1
;
;IOCA1/HTR:HIGH TIME REGISTER
IOCA1	==	0X0A:iopage 1		;HIGH TIME REGISTER
HTR	==	0X0A:iopage 1
;
;IOCB1/TSCR:High/Low Time Scale Control Register
;
IOCB1	==	0X0B:iopage 1		;High/Low Time Scale Control Register
TSCR	==	0X0B:iopage 1
;{
	HTSE	==  7		;High time scale enable bit
					;0 = scale disable bit, High time rate is 1:1
					;1 = scale enable bit, High time rate is set as Bit 6~Bit 4
	HTS2	==  6		;High time scale bits
	HTS1	==  5		;High time scale bits
	HTS0	==  4		;High time scale bits
  					; |------|------|------|----------------|
                              		; | HTS2 | HTS1 | HTS0 | High Time Rate | 
                             		; |------|------|------|----------------|
                             		; |  0   |  0   |  0   |   1:2          | 
                              		; |  0   |  0   |  1   |   1:4          |  
                              		; |  0   |  1   |  0   |   1:8          |  
                              		; |  0   |  1   |  1   |   1:16         |   
                              		; |  1   |  0   |  0   |   1:32         |   
                              		; |  1   |  0   |  1   |   1:64         |   
                              		; |  1   |  1   |  0   |   1:128        |   
                             		; |  1   |  1   |  1   |   1:256        |
                              		; |------|------|------|----------------|
	LTSE	==  3		;Low time scale enable bit
					;0 = scale disable bit, Low time rate is 1:1
					;1 = scale enable bit, Low time rate is set as Bit 2~Bit 0
	LTS2	==  2		;Low time scale bits
	LTS1	==  1		;Low time scale bits
	LTS0	==  0		;Low time scale bits
					; |------|------|------|----------------|
                              		; | LTS2 | LTS1 | LTS0 | Ligh Time Rate | 
                             		; |------|------|------|----------------|
                             		; |  0   |  0   |  0   |   1:2          | 
                              		; |  0   |  0   |  1   |   1:4          |  
                              		; |  0   |  1   |  0   |   1:8          |  
                              		; |  0   |  1   |  1   |   1:16         |   
                              		; |  1   |  0   |  0   |   1:32         |   
                              		; |  1   |  0   |  1   |   1:64         |   
                              		; |  1   |  1   |  0   |   1:128        |   
                             		; |  1   |  1   |  1   |   1:256        |
                              		; |------|------|------|----------------|
;}
;
;IOCC1/TCCPC:TCC Prescaler Counter
;
IOCC1	==	0X0C:iopage 1		;TCC PRESCALE COUNTER
TCCPC	==	0X0C:iopage 1
;
;
;********************************************************;
;CLEAR EM78P259N GENERAL REGISTER MACRO PROGRAM           ;
;                                                        ;
;********************************************************;
;
 M259NCLRRAMBANK  MACRO 
;
     MOV	A,@0X10
     MOV   	RSR,A
$_CLRLOOP:    
     CLR   	R0   
     INC   	RSR
     JBC   	RSR,6
     BS    	RSR,5 
     MOV	A,RSR
     AND	A,@0X7F
     JBS	Z        
     JMP   	$_CLRLOOP   
     ENDM	