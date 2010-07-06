;=========================================================
;//	RAM USE Bady is EPD3331
;// ..... Bank 0 - 0 ~ 55h for function register
;// ..... Bank 0 - 56 ~ 7Fh for normal register
;// ..... Bank 0 ~ 11 for Bank register
;//*******************************************************
;=================================================================


;==================================================================
FuncRes                 DSEG    0,0
;// Special register assignment
INDF0                   EQU     0X00	;Indirect Addressing Pointer 0
FSR0                    EQU     0X01	;File Select Register 0 For Indf0
PCL                     EQU     0X02	;Program Counter, Low
PCM                     EQU     0X03	;Program Counter, Mid.
BSR                     EQU     0X05	;Bank Select Register (For Indf0 And General)
STKPTR                  EQU     0X06	;Stack Pointer
BSR1                    EQU     0X07	;Bank Select Register (For Indf1)
INDF1                   EQU     0X08	;Indirect Addressing Pointer 1
FSR1                    EQU     0X09	;File Select Register 1 For Indf1
ACC                     EQU     0X0A	;Accumulator
TABPTRL                 EQU     0X0B	;Table Pointer Low
TABPTRM                 EQU     0X0C	;Table Pointer Mid.
TABPTRH                 EQU     0X0D	;Table Pointer High
;
CPUCON                  EQU     0X0E	;//CPU Control.
PEN                     EQU     7   	;PLL Enable Control Bit.
SMCAND                  EQU     4   	;Signed/Unsigned Multiplicand.
SMIER                   EQU     3   	;Signed / Unsigned Multiplier.
GLINT                   EQU     2   	;Enable Global Interrupt.
MS1                     EQU     1   	;Cpu Operation Mode Control (0: Sleep, 1: Idle).
MS0                     EQU     0   	;Cpu Operation Mode Control (0: Slow, 1: Fast).
;
STATUS                  EQU     0X0F	;//Status Detect Byte.
F_TO                    EQU     7   	;Wdt Time Out Detect Bit.
F_PD                    EQU     6   	;Wdt Power Down Detect Bit.
F_SGE                   EQU     5   	;Greater Than Or Equal Flag.
F_SLE                   EQU     4   	;Less Than Or Equal Flag.
F_OV                    EQU     3   	;Overflow Flag.
F_Z                     EQU     2   	;Zero Flag.
F_DC                    EQU     1   	;Auxiliary Carry Flag.
F_C                     EQU     0   	;Carry Flag.
;
TRL2                    EQU     0X10	;//Timer2 Register.
PRODL                   EQU     0X11	;//Unsigned/Signed Multiplier Low.
PRODH                   EQU     0X12	;//Unsigned/Signed Multiplier High.
;
ADOTL                   EQU     0X13	;//ADC Output Data And Control Register.
WDTEN                   EQU     7   	;Wake Up Timer Enable Control Bit.
ADWKEN                  EQU     5   	;AD Wake Up Enable Bit.
FSS                     EQU     2   	;Frequency Source Select Bit.
ADOT1                   EQU     1   	;ADC output data Register 1.
ADOT0                   EQU     0   	;ADC output data Register 0.
;
ADOTH                   EQU     0X14	;//ADC Output Data Register 8-10.
UARTTX                  EQU     0X15	;//UART Tx Data Register.
UARTRX                  EQU     0X16	;//UART Rx Data Register.
PORTA                   EQU     0X17	;//PORTA register.
PORTB                   EQU     0X18	;//PORTB register.
PORTC                   EQU     0X19	;//PORTC register.
PORTD                   EQU     0X1A	;//PORTD register.
PORTG                   EQU     0X1D	;//PORTG register.
PORTH                   EQU     0X1E	;//PORTH register.
PFS                     EQU     0X20	;//PLL Frequency Select.
;
STBCON                  EQU     0X21	;//Key strobe control/UART control.
UINVEN                  EQU     7   	;Enable UART TXD/RXD port inverse output.
SCAN                    EQU     6   	;Automatic key scan.
BITST                   EQU     5   	;Enable Bit Strobe.
ALL                     EQU     4   	;All Strobe.
STB3                    EQU     3   	;Strobe Signal Bit3.
STB2                    EQU     2   	;Strobe Signal Bit2.
STB1                    EQU     1   	;Strobe Signal Bit1.
STB0                    EQU     0   	;Strobe Signal Bit0.
;
INTCON                  EQU     0X22	;//Interrupt Mask Control.
CPIE                    EQU     7   	;Mask Control Bit Of Capture Interrupt.
ADIE                    EQU     6   	;Mask Control Bit Of A/D Interrupt.
URXIE                   EQU     5   	;Mask Control Bit Of Uart Rx Buffer Full.
UTXIE                   EQU     4   	;Mask Control Bit Of Uart Transfer Buffer Empty.
UERRIE                  EQU     3   	;Mask Control Bit Of Uart Receiving Error Interrupt.
TMR2IE                  EQU     2   	;Mask Control Bit Of Timer2 Interrupt.
TMR1IE                  EQU     1   	;Mask Control Bit Of Timer1 Interrupt.
TMR0IE                  EQU     0   	;Mask Control Bit Of Timer0 Interrupt.
;
INTSTA                  EQU     0X23	;//Interrupt State.
CPIF                    EQU     7   	;Bit Of Capture Interrupt.
ADIF                    EQU     6   	;Bit Of A/D Interrupt.
URXI                    EQU     5   	;Bit Of Uart Rx Buffer Full.
UTXI                    EQU     4   	;Bit Of Uart Transfer Buffer Empty.
UERRI                   EQU     3   	;Bit Of Uart Receiving Error Interrupt.
TMR2I                   EQU     2   	;Bit Of Timer2 Interrupt.
TMR1I                   EQU     1   	;Bit Of Timer1 Interrupt.
TMR0I                   EQU     0   	;Bit Of Timer0 Interrupt.
;
TRL0L                   EQU     0X24	;//Timer 0 Reload Low Byte.
TRL0H                   EQU     0X25	;//Timer 0 Reload High Byte.
TRL1                    EQU     0X26	;//Timer 1 Reload Buffer.
;
TR01CON                 EQU     0X27	;//Timer 0-1 Control.
T1WKEN                  EQU     7   	;Enable Bit Of Timer 1 Underflow Wakeup Function In Idle Mode.
T1EN                    EQU     6   	;Timer 1 Enable Control Bit.
T1PSR1                  EQU     5   	;Timer 1 Prescale Select Bit 1.
T1PSR0                  EQU     4   	;Timer 1 Prescale Select Bit 0.
IREN                    EQU     3   	;Ir Enable Select Bit.
T0CS                    EQU     2   	;Timer0 Clock Source Select Bit.
T0PSR1                  EQU     1   	;Timer0 Prescale Select Bit 1.
T0PSR0                  EQU     0   	;Timer0 Prescale Select Bit 0.
;
TR2CON                  EQU     0X28	;//Timer2 Control.
IRPSR1                  EQU     7   	;Ir Prescale Select Bit 1.
IRPSR0                  EQU     6   	;Ir Prescale Select Bit 0.
T0FNEN1                 EQU     5   	;Timer1 Enable Control Bit1.
T0FNEN0                 EQU     4   	;Timer1 Enable Control Bit0.
T2EN                    EQU     3   	;Timer2 Enable Control Bit.
T2CS                    EQU     2   	;Timer2 Clock Source Select Bit.
T2PSR1                  EQU     1   	;Timer2 Prescale Select Bit 1.
T2PSR0                  EQU     0   	;Timer2 Prescale Select Bit 0.
;
TRLIR                   EQU     0X29	;//Timer IR Reload Buffer.
;
POST_ID                 EQU     0X2B	;//Post increase/decrease control.
LCD_ID                  EQU     6   	;Auto inc/dec of LCD RAM (1: inc, 0: dec).
FSR1_ID                 EQU     5   	;Auto inc/dec of FRS1 (1: inc, 0: dec).
FSR0_ID                 EQU     4   	;Auto inc/dec of FRS0 (1: inc, 0: dec).
LCDPE                   EQU     2   	;Enable LCD RAM post inc/dec function.
FSR1PE                  EQU     1   	;Enable FSR1 post inc/dec function.
FSR0PE                  EQU     0   	;Enable FSR0 post inc/dec function.
;
ADCON                   EQU     0X2C	;//A/D control register.
DET                     EQU     7   	;Enable detect the touch panel.
VRS                     EQU     6   	;External/Internal Reference voltage selection bit.
ADEN                    EQU     5   	;A/D enable bit.
PIRQB                   EQU     4   	;pen down interrupt flag.
S_DB                    EQU     3   	;Single or differential mode selection.
CHS2                    EQU     2   	;Channel selection bit 2.
CHS1                    EQU     1   	;Channel selection bit 1.
CHS0                    EQU     0   	;Channel selection bit 0.
;
PAINTEN                 EQU     0X2D	;//PortA Interrupt Enable.
PAINTSTA                EQU     0X2E	;//PortA Interrupt Status.
PAWAKE                  EQU     0X2F	;//PortA Wakeup.
;
UARTCON                 EQU     0x30	;//UART Control.
TB8                     EQU     7   	;Transmission data bit8.
UMODE1                  EQU     6   	;UART mode 1.
UMODE0                  EQU     5   	;UART mode 0.
BRATE2                  EQU     4   	;Baud rate selector 2.
BRATE1                  EQU     3   	;Baud rate selector 1.
BRATE0                  EQU     2   	;Baud rate selector 0.
UTBE                    EQU     1   	;UART transfer buffer empty detect bit (read-only).
TXE                     EQU     0   	;Enable transmission.
;
UARTSTA                 EQU     0x31	;//UART Status.
RB8                     EQU     7   	;Receiving data bit8.
EVEN                    EQU     6   	;Select parity check 0/1:Odd/Even parity.
PRE                     EQU     5   	;Enable parity addition 0/1:En/Disable.
PRERR                   EQU     4   	;Parity error.
OVERR                   EQU     3   	;Over running error.
FMERR                   EQU     2   	;Framing error.
URBF                    EQU     1   	;UART 1 character recieved detect bit.
RXE                     EQU     0   	;Enable recieving funciton.
;
DCRB                    EQU     0X34	;//Direction Control Of PortB.
DCRC                    EQU     0X35	;//Direction Control Of PortC.
;
DCRDE                   EQU     0X36	;//Pull Up & Direction Control Of PortD,PortE.
DHNPU                   EQU     3   	;Port D High Nibble Pull Up register.
DHNDC                   EQU     1   	;Port D High Nibble Direction Control.
;
DCRFG                   EQU     0X37	;//Pull Up & Direction Control Of PortF,PortG.
GHNPU                   EQU     7   	;Port G High Nibble Pull Up register.
GLNPU                   EQU     6   	;Port G Low Nibble Pull Up register.
GHNDC                   EQU     5   	;Port G High Nibble Direction Control.
GLNDC                   EQU     4   	;Port G Low Nibble Direction Control.
;
DCRHI                   EQU     0X38	;//Pull Up & Direction Control Of PortH,PortI.
HHNPU                   EQU     3   	;Port H High Nibble Pull Up Register.
HLNPU                   EQU     2   	;Port H Low Nibble Pull Up Register.
HHNDC                   EQU     1   	;Port H High Nibble Direction Control.
HLNDC                   EQU     0   	;Port H Low Nibble Direction Control.
;
PBCON                   EQU     0X3A	;//Port B Pull Up Bit Control.
PCCON                   EQU     0X3B	;//Port C Pull Up Bit Control.
PLLF                    EQU     0X3C	;//PLL actual frequency register.
T0CL                    EQU     0X3D	;//T0 counting value low byte register.
T0CH                    EQU     0X3E	;//T0 counting value high  byte register.
;
SPICON                  EQU     0X3F	;//SPI Control.
TLS1                    EQU     7   	;TX Length Select H.
TLS0                    EQU     6   	;TX Length Select L.
BRS2                    EQU     5   	;TX Bit Rate Select H.
BRS1                    EQU     4   	;TX Bit Rate Select M.
BRS0                    EQU     3   	;TX Bit Rate Select L.
EDS                     EQU     2   	;Select Rising Or Falling Edge.
DORD                    EQU     1   	;Data Tran. Direction.
SE                      EQU     0   	;Shift Enable.
;
SPISTA                  EQU     0X40	;//SPI State Control.
SRBFIE                  EQU     5   	;SPI interrupt flag.
SRBFI                   EQU     4   	;SPI interrupt enable.
SPWKEN                  EQU     3   	;SPI Wake Up Enable Control.
SMP                     EQU     2   	;SPI Data Input Sample Phase.
DCOL                    EQU     1   	;SPI Data Collision Detect.
RBF                     EQU     0   	;Buffer Full Detector.
;
SPRL                    EQU     0X41	;//Serial Peripheral Low Byte.
SPRM                    EQU     0X42	;//Serial Peripheral Middle Byte.
SPRH                    EQU     0X43	;//Serial Peripheral High Byte.
;
SFCR                    EQU     0X44	;//Special function control register.
AGMD2                   EQU     7   	;Edge detection mode selection bit 2.
AGMD1                   EQU     6   	;Edge detection mode selection bit 1.
AGMD0                   EQU     5   	;Edge detection mode selection bit 0.
WDTPRS1                 EQU     4   	;Watch dog timer prescale bit 1.
WDTPRS0                 EQU     3   	;Watch dog timer prescale bit 0.
SPHSB                   EQU     2   	;Speech select bank.
CSB1                    EQU	    1   	;Control select bank bit 1.
CSB0                    EQU     0   	;Control select bank bit 0.
;
ADDL                    EQU     0X45	;//Melody chanel 1-4 address Low byte register.
ADDM                    EQU     0X46	;//Melody chanel 1-4 address Middle byte register.
ADDH                    EQU     0X47	;//Melody chanel 1-4 address High byte register.
ENV                     EQU     0X48	;//Melody envelope 1-4 register.
SPHDR                   EQU     0X48	;//Speech data register.
;
MTCON                   EQU     0X49	;//Melody channel 1-4 control register.
MTEN                    EQU     3   	;Melody timer enable control.
MTRL2                   EQU     2   	;Melody channel 1-4 reload register 10 bit.
MTRL1                   EQU     1   	;Melody channel 1-4 reload register 9 bit.
MTRL0                   EQU     0   	;Melody channel 1-4 reload register 8 bit.
;
SPHTCON                 EQU     0X49	;//Speech control register.
SPHTI                   EQU     5   	;Speech timer interrupt flag.
SPHTIE                  EQU     4   	;Speech timer interrupt control.
SPHTEN                  EQU     3   	;Speech timer enable control.
SPHTRLH2                EQU     2   	;Speech reload register 10 bit.
SPHTRLH1                EQU     1   	;Speech reload register 9 bit.
SPHTRLH0                EQU     0   	;Speech reload register 8 bit.
;
MTRL                    EQU     0X4A	;//Melody channel 1-4 reload register 0-7 bit.
SPHTRL                  EQU     0X4A	;//Speech reload register 0-7 bit.
;
VOCON                   EQU     0X4B	;//Voice output control register.
VOEN                    EQU     7   	;Voice output control of DAC/PWM.
SETR1                   EQU     5   	;Dynamic range 1 of DAC/PWM.
SETR0                   EQU     4   	;Dynamic range 0 of DAC/PWM.
PWMPSR                  EQU     3   	;PWM Timer Pre-scale 1:1/1:2.
VOL2                    EQU     2   	;Volume control-2 of DAC.
VOL1                    EQU     1   	;Volume control-1 of DAC.
VOL0                    EQU     0   	;Volume control-0 of DAC.
;
TR1C                    EQU     0X4C	;//Store the Timer1 counting value.
TR2C                    EQU     0X4D	;//Store the Timer2 counting value.
ADCF                    EQU     0X4E	;//A/D clock factor such as F(A/D)=F(PLL)/(ADCF+1).
;
LCDCONA                 EQU     0X50	;//Two stage amplifier control byte.
BSEL2                   EQU     7   	;LCD bias control bit 2
BSEL1                   EQU     6   	;LCD bias control bit 1
BSEL0                   EQU     5   	;LCD bias control bit 0
ADJ4                    EQU     4   	;LCD contrast adjustment 4
ADJ3                    EQU     3   	;LCD contrast adjustment 3
ADJ2                    EQU     2   	;LCD contrast adjustment 2
ADJ1                    EQU     1   	;LCD contrast adjustment 1
ADJ0                    EQU     0   	;LCD contrast adjustment 0
;
LCDCONB                 EQU     0X51	;//Two stage amplifier control byte.
REV                     EQU     7   	;LCD panel display status control
LCDON                   EQU     5   	;LCD display control bit
LCDPM2                  EQU     4   	;LCD power control mode 2
LCDPM1                  EQU     3   	;LCD power control mode 1
LCDPM0                  EQU     2   	;LCD power control mode 0
SFR1                    EQU     1   	;LCD frame frequency control bit 1
SFR0                    EQU     0   	;LCD frame frequency control bit 0
;
LCDCONC                 EQU     0X52	;//Two stage amplifier control byte.
DRSEL2                  EQU     6   	;LCD duties select bit 2.
DRSEL1                  EQU     5   	;LCD duties select bit 1.
DRSEL0                  EQU     4   	;LCD duties select bit 0.
BOOST                   EQU     3   	;Setting boost time.
LCDARH2                 EQU     2   	;LCD RAM address High bit 2
LCDARH1                 EQU     1   	;LCD RAM address High bit 1
LCDARH0                 EQU     0   	;LCD RAM address High bit 0
;
LCDARL                  EQU     0X53	;//LCD RAM address Low
LCDDATA                 EQU     0X54	;//LCD data RAM
;
PACON                   EQU     0X55	;//Pull-up control of Port-A / Detector control
BIT7PU                  EQU     3   	;Enable A.7 pull up
R2EN                    EQU     2   	;R2 pull-up(large).
R1EN                    EQU     1   	;R1 pull-up(small).
KE                      EQU     0   	;Key input enable