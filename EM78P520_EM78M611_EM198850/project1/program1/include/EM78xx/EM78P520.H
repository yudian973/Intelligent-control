;******************************************************;
;                                                      ;
;  Tilte:       EM78x510xx include file                ;
;  Description: The Definition of EM78x510xx Registers ;
;  Company:     Elan Electronic Corp.                  ;
;  Author:      hongxi.tang                            ;
;  Date:        24/05/2006                             ;
;  Version:     v1.0                                   ;
;                                                      ;
;******************************************************;
;
;======================================================;
; Operational Registers Define                         ;
;======================================================;
EM78P520.H    EQU    EM78P520.H

;
;======================================================;
; Register R0~R4                                       ;
;======================================================;
;
; Indirect Addressing register
;
 R0     ==    0x00
 IAR    ==    0x00
;
; Time Clock/Counter
;
 R1     ==    0x01
 TCC    ==    0x01    ; TCC Counter Preset
;
; Program Counter
;
 R2     ==    0X02
 PC     ==    0X02
;
; Status Register and Voltage Detect
;
 R3    ==    0X03
 SR    ==    0X03
 STATUS	==	0x03
;
     ;{
     	 LVDEN	==    0x07    ; Voltage Detect Enable Bit
         LVDS1	==    0x06    ; Detect Voltage Select Bit[1]
         LVDS0	==    0x05    ; Detect Voltage Select Bit[0]
                               ;
                               ; |-------|-------|----------------|
                               ; | LVDS1 | LVDS0 | Detect Voltage |
                               ; |-------|-------|----------------|
                               ; |   0   |   0   |      2.4V      |
                               ; |   0   |   1   |      2.7V      |
                               ; |   1   |   0   |      3.3V      |
                               ; |   1   |   1   |      3.9V      |
                               ; |-------|-------|----------------|
                               ;
         T       ==    0x04    ; Time-Out Bit
         P       ==    0x03    ; Power Down Bit
         Z       ==    0x02    ; Zero Flag
         DC      ==    0x01    ; Auxiliary Carry Flag
         C       ==    0x00    ; Carry Flag
                               ;
     ;}
;
; RAM Select Register (RSR)
;
 R4     ==    0X04
 RSR    ==    0X04
     ;{
                                ; Bits 5~0 are used to select up to 64 registers in the
                                ; indirect addressing mode.
                                ;
         VDB	  ==    0x07    ; Voltage Detector
         BNC      ==    0x06    ; Bank Control Register
                                ;
         RSR5     ==    0x05    ;
         RSR4     ==    0x04    ;
         RSR3     ==    0x03    ;
         RSR2     ==    0x02    ;
         RSR1     ==    0x01    ;
         RSR0     ==    0x00    ;
                                ;
     ;}
;======================================================;
; Bank0~6 Register R5~RF                               ;
;======================================================;
;
; Bank0 R5(RAM Bank Select Register)
;
 B0_R5    ==	0X05
 BSR      ==    0X05
;
     ;{
     				    ; Bit3~7 is "0"
         BS2          ==    0x02    ; RAM Bank Select Register Bits[2]
         BS1          ==    0x01    ; RAM Bank Select Register Bits[1]
         BS0          ==    0x00    ; RAM Bank Select Register Bits[0]
     ;}
;
; Bank 0 R6(Program Page Select Register)
;
 B0_R6    ==    0X06
 PSR      ==    0X06
;
     ;{
     			       ; Bit3~7 is "0"
         PS2     ==    0x02    ; Program Page Select Register Bits[2]
         PS1     ==    0x01    ; Program Page Select Register Bits[1]
         PS0     ==    0x00    ; Program Page Select Register Bits[0]
     ;}
;
; Bank0 R7(Port 7 data Register)
;
 B0_R7    ==    0X07
 PORT7    ==    0X07
;
     ;{
         R77     ==    0x07    ; I/O data of P7.7
         R76     ==    0x06    ; I/O data of P7.6
         R75     ==    0x05    ; I/O data of P7.5
         R74     ==    0x04    ; I/O data of P7.4
         R73     ==    0x03    ; I/O data of P7.3
         R72     ==    0x02    ; I/O data of P7.2
         R71     ==    0x01    ; I/O data of P7.1
         R70     ==    0x00    ; I/O data of P7.0
     ;}
;
; Bank0 R8(Port 8 data Register)
;
 B0_R8    ==    0X08
 PORT8    ==    0X08
;
     ;{
         R87     ==    0x07    ; I/O data of P8.7
         R86     ==    0x06    ; I/O data of P8.6
         R85     ==    0x05    ; I/O data of P8.5
         R84     ==    0x04    ; I/O data of P8.4
         R83     ==    0x03    ; I/O data of P8.3
         R82     ==    0x02    ; I/O data of P8.2
         R81     ==    0x01    ; I/O data of P8.1
         R80     ==    0x00    ; I/O data of P8.0
     ;}
;
; Bank0 R9(PORT 9 Data Register)
;
 B0_R9    ==    0X09
 PORT9    ==    0X09
;
     ;{
         R97     ==    0x07    ; I/O data of P9.7
         R96     ==    0x06    ; I/O data of P9.6
         R95     ==    0x05    ; I/O data of P9.5
         R94     ==    0x04    ; I/O data of P9.4
         R93     ==    0x03    ; I/O data of P9.3
         R92     ==    0x02    ; I/O data of P9.2
         R91     ==    0x01    ; I/O data of P9.1
         R90     ==    0X00    ; I/O data of P9.0
     ;}
;
;  Bank0 RA(PORTA Data Register)
;
 B0_RA	  ==	0X0A
 PORTA	  ==	0X0A
;
	;{
		RA7	==	0X07	; I/O Data of PA.7
		RA6	==	0X06 	; I/O Data of PA.6
		RA5	==	0X05	; I/O Data of PA.5
		RA4	==	0X04	; I/O Data of PA.4
		RA3	==	0X03	; I/O Data of PA.3
		RA2	==	0X02	; I/O Data of PA.2
		RA1	==	0X01	; I/O Data of PA.1
		RA0	==	0X00	; I/O Data of PA.0
	;}
;
;  Bank0 RB(PORT8 Data Register)
;
 B0_RB	==	0X0B
 PORTB	==	0X0B
;
	;{
		RB7	==	0X07	; I/O Data of PB.7
		RB6	==	0X06 	; I/O Data of PB.6
		RB5	==	0X05	; I/O Data of PB.5
		RB4	==	0X04	; I/O Data of PB.4
		RB3	==	0X03	; I/O Data of PB.3
		RB2	==	0X02	; I/O Data of PB.2
		RB1	==	0X01	; I/O Data of PB.1
		RB0	==	0X00	; I/O Data of PB.0
	;}
;
;  Bank0 RC(System Clock Control Register)
;
 B0_RC	==	0X0C
 SCCR	==	0X0C
;
	;{
				 ; Bit7 is "0"
		CLK2	==  0X06 ;
		CLK1	==  0X05 ;
		CLK0	==  0X04 ; Main Clock Select Bit for PLL Mode
				 ; |------|------|------|------------|---------------|
				 ; | CLK2 | CLK1 | CLK0 | Main Clock | Ex:Fs=32.768k |
				 ; |------|------|------|------------|---------------|
				 ; |  0   |  0   |  0   |   Fs*122   |   3.997 MHz   |
				 ; |------|------|------|------------|---------------|
				 ; |  0   |  0   |  1   |    Fs*61   |   1.998 MHz   |
				 ; |------|------|------|------------|---------------|
				 ; |  0   |  1   |  0   |   Fs*61/2  |   0.999 MHz   |
				 ; |------|------|------|------------|---------------|
				 ; |  0   |  1   |  1   |   Fs*61/4  |   499.7 kHz   |
				 ; |------|------|------|------------|---------------|
				 ; |  1   |  0   |  0   |   Fs*244   |   7.995 MHz   |
				 ; |------|------|------|------------|---------------|
				 ; |  1   |  0   |  1   |   Fs*366   |   11.99 MHz   |
				 ; |------|------|------|------------|---------------|
				 ; |  1   |  1   |  X   |   Fs*488   |   15.99 MHz   |
				 ; |------|------|------|------------|---------------|
		IDLE	==  0X03 ; Idle Mode Enable Bit.
		 		 ; IDLE="0"+SLEP instruction=>sleep mode
		 		 ; IDLE="1"+SLEP instruction=>idle mode
		BF1	==  0x02 ;
		BF0	==  0x01 ; LCD Booster Frequency Select Bit.
				 ; |-----|-----|-------------------|
				 ; | BF1 | BF0 | Booster frequency |
				 ; |-----|-----|-------------------|
				 ; |  0  |  0  |        Fs         |
				 ; |-----|-----|-------------------|
				 ; |  0  |  1  |       Fs/4        |
				 ; |-----|-----|-------------------|
				 ; |  1  |  0  |       Fs/8        |
				 ; |-----|-----|-------------------|
				 ; |  1  |  1  |       Fs/16       |
				 ; |-----|-----|-------------------|
		CPUS	==  0x00 ; CPU Oscillator Source Select.
				 ; 0/1=>sub-oscillator(fs)/main oscillator(fm)
	;}
;
; Bank0 RD(TCC and WDT Timer control register)
;
 B0_RD	==	0X0D
 TWTCR	==	0X0D
;
	;{
		WDTE	==  0X07 ; Watchdog Timer Enable.0/1=>disable/enable
		WPSR2	==  0X06
		WPSR1	==  0X05
		WPSR0	==  0X04 ; WDT Prescaler Bits
				 ; |-----|-----|-----|-----------|
				 ; |WPSR2|WPSR1|WPSR0| Prescaler |
				 ; |-----|-----|-----|-----------|
				 ; |  0  |  0  |  0  |    1:1    |
				 ; |-----|-----|-----|-----------|
				 ; |  0  |  0  |  1  |    1:2    |
				 ; |-----|-----|-----|-----------|
				 ; |  0  |  1  |  0  |    1:4    |
				 ; |-----|-----|-----|-----------|
				 ; |  0  |  1  |  1  |    1:8    |
				 ; |-----|-----|-----|-----------|
				 ; |  1  |  0  |  0  |   1:16    |
				 ; |-----|-----|-----|-----------|
				 ; |  1  |  0  |  1  |   1:32    |
				 ; |-----|-----|-----|-----------|
				 ; |  1  |  1  |  0  |   1:64    |
				 ; |-----|-----|-----|-----------|
				 ; |  1  |  1  |  1  |   1:128   |
				 ; |-----|-----|-----|-----------|
		TCCS	==  0x03 ; TCC Clock Source Select Bit.0/1=>Fm/Fs
		TPSR2	==  0x02
		TPSR1	==  0X01
		TPSR0	==  0X00 ; TCC Prescaler Bits
				 ; |-----|-----|-----|-----------|
				 ; |TPSR2|TPSR1|TPSR0| Prescaler |
				 ; |-----|-----|-----|-----------|
				 ; |  0  |  0  |  0  |    1:2    |
				 ; |-----|-----|-----|-----------|
				 ; |  0  |  0  |  1  |    1:4    |
				 ; |-----|-----|-----|-----------|
				 ; |  0  |  1  |  0  |    1:8    |
				 ; |-----|-----|-----|-----------|
				 ; |  0  |  1  |  1  |   1:16    |
				 ; |-----|-----|-----|-----------|
				 ; |  1  |  0  |  0  |   1:32    |
				 ; |-----|-----|-----|-----------|
				 ; |  1  |  0  |  1  |   1:64    |
				 ; |-----|-----|-----|-----------|
				 ; |  1  |  1  |  0  |   1:128   |
				 ; |-----|-----|-----|-----------|
				 ; |  1  |  1  |  1  |   1:256   |
				 ; |-----|-----|-----|-----------|
	;}
;
; Bank0 RE (Interrupt Mask Register)
;
 B0_RE	==	0X0E
 RE	==	0X0E							;ADD
 IMR	==	0X0E
;
	;{
		T1IE	==  0X07 ; Timer1 Interrupt Enable Bit
		LVDIE   ==  0X06 ; low Voltage Detect Interrupt Enable Bit
		ADIE	==  0X05 ; A/D convert Interrupt Enable Bit
		SPIE    ==  0X04 ; SPI transfer Interrupt Enable Bit
		URTIE	==  0X03 ; UART transmit Interrupt Enable Bit
		EXIE9	==  0X02 ; External interrupt 9 Enable Bit
		EXIE8	==  0X01 ; External interrupt 8 Enable Bit
		TCIE	==  0X00 ; TCC Overflow Interrupt Enable Bit
	;}
;
;  Bank0 RF (Interrupt Status Register)
;
 B0_RF	==	0X0F
 RF     ==  0x0F
 ISR	==	0X0F
;
	;{
		T1IF	==  0X07 ; interrupt flag of timer1 interrupt
		LVDIF	==  0X06 ; interrupt flag of low voltage detector interrupt
		ADIF	==  0X05 ; interrupt flag of A/D convert Complete
		SPIF	==  0X04 ; interrupt flag of SPI transfer complete
		URTIF	==  0X03 ; interrupt flag of UART transfer complete
		EXIF9	==  0X02 ; interrupt flag of external interrupt 9 Occur.
		EXIF8	==  0X01 ; interrupt flag of external interrupt 8 Occur.
		TCIF	==  0X00 ; interrupt flag of TCC Overflow
	;}
;
;  Bank1 R5 (LCD Control Register)
;
 B1_R5	==	0X05
 LCDCR	==	0X05
;
	;{
		LCDEN	==  0X07 ; lCD Enable Select Bit.0/1=>disable/enable
		LCDTYPE	==  0X06 ; LCD Drive Waveform Type Select Bit
		LBS1	==  0x05
		LBS0	==  0x04 ; LCD Bias Select Bits
				 ; |---|---|---------------|
				 ; |BS1|BS0|LCD Bias Select|
				 ; |---|---|---------------|
				 ; | 0 | 0 |   1/2 Bias    |
				 ; |---|---|---------------|
				 ; | 0 | 1 |   1/3 Bias    |
				 ; |---|---|---------------|
				 ; | 1 | X |   1/4 Bias    |
				 ; |---|---|---------------|
		DS1	==  0x03
		DS0	==  0x02 ; LCD Duty Select Bits
				 ; |---|---|---------------|
				 ; |DS1|DS0|LCD Duty Select|
				 ; |---|---|---------------|
				 ; | 0 | 0 |    Static     |
				 ; |---|---|---------------|
				 ; | 0 | 1 |   1/3 Duty    |
				 ; |---|---|---------------|
				 ; | 1 | 0 |   1/4 Duty    |
				 ; |---|---|---------------|
				 ; | 1 | 1 |   1/8 Duty    |
				 ; |---|---|---------------|
		LCDF1	==  0x01 ;
		LCDF0	==  0x00 ; LCD Frame Frequency Control Bits
				 ; |-----|-----|---------------|---------------|---------------|--------------|
				 ; |LCDF1|LCDF0|     Static    |    1/3 Duty   |    1/4 Duty   |   1/8 Duty   |
				 ; |-----|-----|---------------|---------------|---------------|--------------|
				 ; |  0  |  0  |Fs/(512*1)=64.0|Fs/(172*3)=63.5|Fs/(128*4)=64.0|Fs/(64*8)=64.0|
				 ; |-----|-----|---------------|---------------|---------------|--------------|
				 ; |  0  |  1  |Fs/(560*1)=58.5|Fs/(188*3)=58.0|Fs/(140*4)=58.5|Fs/(70*8)=58.5|
				 ; |-----|-----|---------------|---------------|---------------|--------------|
				 ; |  1  |  0  |Fs/(608*1)=53.9|Fs/(204*3)=53.5|Fs/(152*4)=53.9|Fs/(76*8)=53.9|
				 ; |-----|-----|---------------|---------------|---------------|--------------|
				 ; |  1  |  1  |Fs/(464*1)=70.6|Fs/(156*3)=70.0|Fs/(116*4)=70.6|Fs/(58*8)=70.6|
				 ; |-----|-----|---------------|---------------|---------------|--------------|
	;}
;
;  Bank1 R6 (LCD Address Register)
;
 B1_R6	==    0X06
 LCDAR	==    0X06
;
	;{
				 ; Bit5~7 is "0"
		LCD_A4	==  0x04 ; LCD RAM Address:00H~16H
		LCD_A3	==  0x03
		LCD_A2  ==  0x02
		LCD_A1	==  0x01
		LCD_A0	==  0x00
	;}
;
; Bank1 R7 (LCD Data Buffer)
;
 B1_R7	==    0X07
 LCDBR	==    0X07
;
	;{
		LCD_D7	==  0x07
		LCD_D6	==  0x06
		LCD_D5	==  0x05
		LCD_D4	==  0x04
		LCD_D3	==  0x03
		LCD_D2	==  0x02
		LCD_D1	==  0x01
		LCD_D0	==  0x00
	;}
;
;  Bank1 R8 (LCD Voltage Control Register)
;
 B1_R8	==	0x08
 LCDVCR	==	0x08
;
	;{
				 ; Bit5~6 is "0"
		LCDC1	==  0x04
		LCDC0	==  0x03 ; LCD Clock
				 ; |-----|-----|------|--------|
				 ; |LCDC1|LCDC0|  Fm  |  Flcd  |
				 ; |-----|-----|------|--------|
				 ; |  0  |  0  | 16M  | Fc/2^9 |
				 ; |-----|-----|------|--------|
				 ; |  0  |  1  |  8M  | Fc/2^8 |
				 ; |-----|-----|------|--------|
				 ; |  1  |  0  |  4M  | Fc/2^7 |
				 ; |-----|-----|------|--------|
				 ; |  1  |  1  |  2M  | Fc/2^6 |
				 ; |-----|-----|------|--------|
		LCDVC2	==  0x02
		LCDVC1	==  0x01
		LCDVC0	==  0x00 ; LCD Voltage Control Bits
				 ; |------|------|------|--------------|
				 ; |LCDVC2|LCDVC1|LCDVC0|    Output    |
				 ; |------|------|------|--------------|
				 ; |   0  |   0  |   0  |  0.4VDD~VDD  |
				 ; |------|------|------|--------------|
				 ; |   0  |   0  |   1  | 0.34VDD~VDD  |
				 ; |------|------|------|--------------|
				 ; |   0  |   1  |   0  | 0.26VDD~VDD  |
				 ; |------|------|------|--------------|
				 ; |   0  |   1  |   1  | 0.18VDD~VDD  |
				 ; |------|------|------|--------------|
				 ; |   1  |   0  |   0  | 0.13VDD~VDD  |
				 ; |------|------|------|--------------|
				 ; |   1  |   0  |   1  | 0.07VDD~VDD  |
				 ; |------|------|------|--------------|
				 ; |   1  |   1  |   0  | 0.04VDD~VDD  |
				 ; |------|------|------|--------------|
				 ; |   1  |   1  |   1  |    0V~VDD    |
				 ; |------|------|------|--------------|
	;}
;
;  Bank1 R9 (LCD Com Control Register)
;
 B1_R9	==	0x09
 LCDCCR	==	0x09
;
	;{
		COM7	==  0x07 ; 0:I/O Function,1:LCD common driver pin.
		COM6	==  0x06
		COM5	==  0x05
		COM4	==  0x04
		COM3	==  0x03
		COM2	==  0x02
		COM1	==  0x01
		COM0	==  0x00
	;}
;
;  Bank1 RA (LCD Segment Control Register0)
;
 B1_RA		==	0X0A
 LCDSCR0	==	0X0A
;
	;{
		SEG7	==  0X07 ; LCD Segment7 Control Bit.0:I/O,1:LCD Driver pin.
		SEG6	==  0X06 ; LCD Segment6 Control Bit.0:I/O,1:LCD Driver pin.
		SEG5	==  0X05 ; LCD Segment5 Control Bit.0:I/O,1:LCD Driver pin.
		SEG4	==  0X04 ; LCD Segment4 Control Bit.0:I/O,1:LCD Driver pin.
		SEG3	==  0X03 ; LCD Segment3 Control Bit.0:I/O,1:LCD Driver pin.
		SEG2	==  0X02 ; LCD Segment2 Control Bit.0:I/O,1:LCD Driver pin.
		SEG1	==  0X01 ; LCD Segment1 Control Bit.0:I/O,1:LCD Driver pin.
		SEG0	==  0X00 ; LCD Segment0 Control Bit.0:I/O,1:LCD Driver pin.
	;}
;
;  Bank1 RB (LCD Segment Control Register1)
;
 B1_RB		==	0X0B
 LCDSCR1	==	0X0B
;
	;{
		SEG15	==  0X07 ; LCD Segment15 Control Bit.0:I/O,1:LCD Driver pin.
		SEG14	==  0X06 ; LCD Segment14 Control Bit.0:I/O,1:LCD Driver pin.
		SEG13	==  0X05 ; LCD Segment13 Control Bit.0:I/O,1:LCD Driver pin.
		SEG12	==  0X04 ; LCD Segment12 Control Bit.0:I/O,1:LCD Driver pin.
		SEG11	==  0X03 ; LCD Segment11 Control Bit.0:I/O,1:LCD Driver pin.
		SEG10	==  0X02 ; LCD Segment10 Control Bit.0:I/O,1:LCD Driver pin.
		SEG9	==  0X01 ; LCD Segment9 Control Bit.0:I/O,1:LCD Driver pin.
		SEG8	==  0X00 ; LCD Segment8 Control Bit.0:I/O,1:LCD Driver pin.
	;}
;
;  Bank1 RC (LCD Segment Control Register2)
;
 B1_RC		==	0X0C
 LCDSCR2	==	0X0C
;
	;{
				 ; Bit7 not used
		SEG22	==  0X06 ; LCD Segment22 Control Bit.0:I/O,1:LCD Driver pin.
		SEG21	==  0X05 ; LCD Segment21 Control Bit.0:I/O,1:LCD Driver pin.
		SEG20	==  0X04 ; LCD Segment20 Control Bit.0:I/O,1:LCD Driver pin.
		SEG19	==  0X03 ; LCD Segment19 Control Bit.0:I/O,1:LCD Driver pin.
		SEG18	==  0X02 ; LCD Segment18 Control Bit.0:I/O,1:LCD Driver pin.
		SEG17	==  0X01 ; LCD Segment17 Control Bit.0:I/O,1:LCD Driver pin.
		SEG16	==  0X00 ; LCD Segment16 Control Bit.0:I/O,1:LCD Driver pin.
	;}
;
;  Bank1 RE (External Interrupt Mask Register)
;
 B1_RE	==	0X0E
 EIMR	==	0X0E
;
	;{
		EXIE7	==  0x07 ; /INT7 Interrupt Enable Control Bit.0/1=>Disalbe/Enable.
		EXIE6	==  0x06 ; /INT6 Interrupt Enable Control Bit.0/1=>Disalbe/Enable.
		EXIE5	==  0x05 ; /INT5 Interrupt Enable Control Bit.0/1=>Disalbe/Enable.
		EXIE4	==  0x04 ; /INT4 Interrupt Enable Control Bit.0/1=>Disalbe/Enable.
		EXIE3	==  0x03 ; /INT3 Interrupt Enable Control Bit.0/1=>Disalbe/Enable.
		EXIE2	==  0x02 ; /INT2 Interrupt Enable Control Bit.0/1=>Disalbe/Enable.
		EXIE1	==  0x01 ; /INT1 Interrupt Enable Control Bit.0/1=>Disalbe/Enable.
		EXIE0	==  0x00 ; /INT0 Interrupt Enable Control Bit.0/1=>Disalbe/Enable.
	;}
;
;  Bank1 RF (External Interrupt Status Register)
;
 B1_RF	==	0X0F
 EISR	==	0X0F
;
	;{
		EXIF7	==  0x07 ; /INT7 Interrupt Flag Bit.
		EXIF6	==  0x06 ; /INT6 Interrupt Flag Bit.
		EXIF5	==  0x05 ; /INT5 Interrupt Flag Bit.
		EXIF4	==  0x04 ; /INT4 Interrupt Flag Bit.
		EXIF3	==  0x03 ; /INT3 Interrupt Flag Bit.
		EXIF2	==  0x02 ; /INT2 Interrupt Flag Bit.
		EXIF1	==  0x01 ; /INT1 Interrupt Flag Bit.
		EXIF0	==  0x00 ; /INT0 Interrupt Flag Bit.
	;}
;
;  Bank2 R5 (Timer1 Control Register)
;
 B2_R5	==	0X05
 T1CR	==	0X05
;
	;{
		T1S1	==  0x07
		T1S0	==  0x06 ; Timer1 and Timer2 Interrupt Type Select Bits.
				 ; |----|----|---------------------------------------|
				 ; |T1S1|T1S0|Timer1 and Timer2 Interrupt Type Select|
				 ; |----|----|---------------------------------------|
				 ; |  0 |  0 |           T1PD underflow              |
				 ; |----|----|---------------------------------------|
				 ; |  0 |  1 |           T1TD underflow              |
				 ; |----|----|---------------------------------------|
				 ; |  1 |  X |      T1PD and T1TD underflow          |
				 ; |----|----|---------------------------------------|
		T1MS2	==  0x05
		T1MS1	==  0x04
		T1MS0	==  0x03 ; Timer1 Operation Mode Select Bits
				 ; |-----|-----|-----|-------------------------|
				 ; |T1MS2|T1MS1|T1MS0|   Timer1 Mode Select    |
				 ; |-----|-----|-----|-------------------------|
				 ; |  0  |  0  |  0  |         Timer1          |
				 ; |-----|-----|-----|-------------------------|
				 ; |  0  |  0  |  1  |        T1OUT Mode       |
				 ; |-----|-----|-----|-------------------------|
				 ; |  0  |  1  |  0  |Capture Mode Rising Edge |
				 ; |-----|-----|-----|-------------------------|
				 ; |  0  |  1  |  1  |Capture Mode Falling Edge|
				 ; |-----|-----|-----|-------------------------|
				 ; |  1  |  0  |  0  |UART Baud Rate Generator |
				 ; |-----|-----|-----|-------------------------|
				 ; |  1  |  0  |  1  |                         |
				 ; |-----|-----|-----|                         |
				 ; |  1  |  1  |  0  |          PWM1           |
				 ; |-----|-----|-----|                         |
				 ; |  1  |  1  |  1  |                         |
				 ; |-----|-----|-----|-------------------------|
		T1P2	==  0x02
		T1P1	==  0x01
		T1P0	==  0x00 ; Timer1 Prescaler Bits
				 ; |-----|-----|-----|-----------------|
				 ; | T1P2| T1P1| T1P0|   Prescalaer    |
				 ; |-----|-----|-----|-----------------|
				 ; |  0  |  0  |  0  |      1:2        |
				 ; |-----|-----|-----|-----------------|
				 ; |  0  |  0  |  1  |      1:4        |
				 ; |-----|-----|-----|-----------------|
				 ; |  0  |  1  |  0  |	    1:8        |
				 ; |-----|-----|-----|-----------------|
				 ; |  0  |  1  |  1  |      1:16       |
				 ; |-----|-----|-----|-----------------|
				 ; |  1  |  0  |  0  |      1:32       |
				 ; |-----|-----|-----|-----------------|
				 ; |  1  |  0  |  1  |      1:64       |
				 ; |-----|-----|-----|-----------------|                         |
				 ; |  1  |  1  |  0  |      1:128      |
				 ; |-----|-----|-----|-----------------|
				 ; |  1  |  1  |  1  |      1:256      |
				 ; |-----|-----|-----|-----------------|
	;}
;
;  Bank2 R6 (Timer Status Register)
;
 B2_R6	==	0X06
 TSR	==	0X06
;
	;{
		T1MOD	==  0X07 ; Timer Operates Mode Select Bit.
		TRCB	==  0x06 ; Timer1,2 Read Control Bit.
		T1CSS1	==  0x05 ;
		T1CSS0	==  0x04 ; Timer1 Clock Source Select Bits
				 ; |------|------|--------------------------|
				 ; |T1CSS1|T1CSS0|Timer1 Clock Source select|
				 ; |------|------|--------------------------|
				 ; |  0   |  0   |            Fm            |
				 ; |------|------|--------------------------|
				 ; |  0   |  1   |            Fs            |
				 ; |------|------|--------------------------|
				 ; |  1   |  X   |           T1CK           |
				 ; |------|------|--------------------------|
		T2CSS	==  0x03 ; Timer2 Clock Source Select Bit.0/1=>Fm/Fs.
		T1EN	==  0x02 ; Timer1 Start Bit.
		T1OMS	==  0x01 ; Timer1 Output Mode Select Bit.0/1=>repeating/on-shot.
		T1OC	==  0x00 ; Timer1 Output Flip-Flop Control Bit.
	;}
;
;  Bank2 R7 (Timer1 Period Buffer)
;
 B2_R7	==	0X07
 T1PD	==	0X07
;
;  Bank2 R8 (Timer1 Duty Buffer)
;
 B2_R8	==	0X08
 T1TD	==	0X08
;
;  Bank2 R9 (Timer2 Control Register)
;
 B2_R9	==	0X09
 T2CR	==	0X09
;
	;{
		T2IF	==  0X07 ; Interrupt Flag of Timer2 Interrupt
		T2IE	==  0X06 ; Timer2 Interrupt Mask Bit
		T2EN	==  0X05 ; Timer2 Start Bit
		T2S     ==  0x05 ;
		T2MS1	==  0X04 ;
		T2MS0	==  0X03 ; Timer2 Operation Mode Select Bits.
				 ; |-----|-----|-----------------------|
				 ; |T2MS1|T2MS0|   Timer2 Mode Select  |
				 ; |-----|-----|-----------------------|
				 ; |  0  |  0  |        Timer2         |
				 ; |-----|-----|-----------------------|
				 ; |  0  |  1  |SPI Baud Rate Generator|
				 ; |-----|-----|-----------------------|
				 ; |  1  |  0  |                       |
				 ; |-----|-----|         PWM2          |
				 ; |  1  |  0  |                       |
				 ; |-----|-----|-----------------------|
		T2P2	==  0x02
		T2P1	==  0x01
		T2P0	==  0x00 ; Timer2 Prescaler Bits
				 ; |-----|-----|-----|-----------------|
				 ; | T2P2| T2P1| T2P0|   Prescalaer    |
				 ; |-----|-----|-----|-----------------|
				 ; |  0  |  0  |  0  |      1:2        |
				 ; |-----|-----|-----|-----------------|
				 ; |  0  |  0  |  1  |      1:4        |
				 ; |-----|-----|-----|-----------------|
				 ; |  0  |  1  |  0  |	    1:8        |
				 ; |-----|-----|-----|-----------------|
				 ; |  0  |  1  |  1  |      1:16       |
				 ; |-----|-----|-----|-----------------|
				 ; |  1  |  0  |  0  |      1:32       |
				 ; |-----|-----|-----|-----------------|
				 ; |  1  |  0  |  1  |      1:64       |
				 ; |-----|-----|-----|-----------------|                         |
				 ; |  1  |  1  |  0  |      1:128      |
				 ; |-----|-----|-----|-----------------|
				 ; |  1  |  1  |  1  |      1:256      |
				 ; |-----|-----|-----|-----------------|
	;}
;
;  Bank2 RA (Timer2 Period Buffer)
;
 B2_RA	==	0X0A
 T2PD	==	0X0A
;
; Bank2 RB (Timer Duty Buffer)
;
 B2_RB	==	0X0B
 T2TD	==	0X0B
;
;  Bank2 RC (SPI Status Register)
;
 B2_RC	==	0X0C
 SPIS	==	0X0C
;
	;{
		DORD	==  0X07 ; Data Shift Control Bit.0/1=>left/right
		TD1	==  0X06 ;
		TD0	==  0X05 ; SDO Status Output Delay Times Options
				 ; |---|---|----------|
				 ; |TD1|TD0|Delay Time|
				 ; |---|---|----------|
				 ; | 0 | 0 |   8 CLK  |
				 ; |---|---|----------|
				 ; | 0 | 1 |  16 CLK  |
				 ; |---|---|----------|
				 ; | 1 | 0 |  24 CLK  |
				 ; |---|---|----------|
				 ; | 1 | 1 |  32 CLK  |
				 ; |---|---|----------|
				 ; Bit4 Reserved
		OD3	==  0X03 ; Open-Drain Control Bit
		OD4	==  0X02 ;
				 ; Bi1 Reserved
		RIBF	==  0X00 ; Read Buffer Full Flag
	;}
;
;  Bank2 RD (SPI Control Register)
;
 B2_RD	==	0X0D
 SPIC	==	0X0D
;
	;{
		CES	==  0X07 ; Clock Edge Select Bit
		SPIEB	==  0X06 ; SPI Enable Bit
		SRO	==  0X05 ; SPI Read Overflow Bit
		SSE	==  0X04 ; SPI Shift Enable Bit
		SDOC	==  0X03 ; SDO Output Status Control Bit
		SBRS2	==  0X02
		SBRS1	==  0X01
		SBRS0	==  0X00 ; SPI Baud Rate Select Bits
				 ; |-----|-----------|--------|-------------------|
				 ; |SBRS2|SBRS1|SBRS0|  Mode  |   SPI Baud Rate   |
				 ; |-----|-----------|--------|-------------------|
				 ; |  0  |  0  |  0  | Master |       Fcsc/2      |
				 ; |-----|-----------|--------|-------------------|
				 ; |  0  |  0  |  1  | Master |       Fcsc/4      |
				 ; |-----|-----------|--------|-------------------|
				 ; |  0  |  1  |  0  | Master |       Fcsc/8      |
				 ; |-----|-----------|--------|-------------------|
				 ; |  0  |  1  |  1  | Master |      Fcsc/16      |
				 ; |-----|-----------|--------|-------------------|
				 ; |  1  |  0  |  0  | Master |      Fcsc/32      |
				 ; |-----|-----------|--------|-------------------|
				 ; |  1  |  0  |  1  | Master |       Timer2      |
				 ; |-----|-----------|--------|-------------------|
				 ; |  1  |  1  |  0  | Slave  |     /SS enable    |
				 ; |-----|-----------|--------|-------------------|
				 ; |  1  |  1  |  1  | Slave  |     /SS enable    |
				 ; |-----|-----------|--------|-------------------|
	;}
;
;  Bank2 RE (SPI Read Buffer)
;
 B2_RE	==	0X0E
 SPIR	==	0X0E
;
;  Bank2 RF (SPI Write Buffer)
;
 B2_RF	==	0X0F
 SPIW	==	0X0F
;
;  Bank3 R5 (UART Control Register)
;
 B3_R5	==	0X05
 URC	==	0X05
;
	;{
		URTD8	==  0X07 ; Transmission Data Bit8
		UMODE1	==  0X06
		UM0DE0	==  0X05 ; UART Transmission Mode Select Bit
				 ; |------|------|-----------|
				 ; |UMODE1|UMODE0| UART Mode |
				 ; |  0   |   0  |Mode1:7-Bit|
				 ; |------|------|-----------|
				 ; |  0   |   1  |Mode1:8-Bit|
				 ; |------|------|-----------|
				 ; |  1   |   0  |Mode1:9-Bit|
				 ; |------|------|-----------|
				 ; |  1   |   1  | Reserved  |
				 ; |------|------|-----------|
		BRATE2	==  0X04
		BRATE1	==  0X03
		BRATE0	==  0X02 ; Transmit Baud Rate Select(Tuart=Fc/16)
				 ; |------|------|------|-------------|-------------|
				 ; |BRATE2|BRATE1|BRATE0|  Baud Rate  | e.g.FC=8Mhz |
				 ; |------|------|------|-------------|-------------|
				 ; |  0   |  0   |  0   |   Tuart/13  |    38400    |
				 ; |------|------|------|-------------|-------------|
				 ; |  0   |  0   |  1   |   Tuart/26  |    19200    |
				 ; |------|------|------|-------------|-------------|
				 ; |  0   |  1   |  0   |   Tuart/52  |     9600    |
				 ; |------|------|------|-------------|-------------|
				 ; |  0   |  1   |  1   |  Tuart/104  |     4800    |
				 ; |------|------|------|-------------|-------------|
				 ; |  1   |  0   |  0   |  Tuart/208  |     2400    |
				 ; |------|------|------|-------------|-------------|
				 ; |  1   |  0   |  1   |  Tuart/416  |     1200    |
				 ; |------|------|------|---------------------------|
				 ; |  1   |  1   |  0   |            Timer1         |
				 ; |------|------|------|---------------------------|
				 ; |  1   |  1   |  1   |           Reserved        |
				 ; |------|------|------|---------------------------|
		UTBE ==  0X01
		TXE	 ==  0X00 ; Enable transmission
	;}
;
;  Bank 3 R6 (UART Status)
;
 B3_R6	==  0X06
 URS	==  0X06
;
	;{
		URRD8	==  0X07 	; Receiving Data Bit8
		EVEN	==  0X06 	; Select Parity Check
		PRE		==  0X05	; Enable Parity Check
		PRERR	==  0X04 	; Parity Error Flag
		OVERR	==  0X03 	; Over Running Error Flag
		FMERR	==  0X02 	; Framing Error Flag
		URBF	==  0X01 	; UART Read Buffer Full Flag
		RXE	==  0X00 		; Enable Receiving
	;}
;
;  Bank3 R7 (UART_RD Data Buffer)
;
 B3_R7	==	0X07
 URRD	==	0X07
;
;  Bank3 R8 (UART_TD Data Buffer)
;
 B3_R8	==	0X08
 URTD	==	0X08
;
;  Bank3 R9 (A/D Control Register)
;
 B3_R9	==	0X09
 ADCR	==	0X09
;
	;{
		ADRUN	==  0X07 ; AD Conversion Start
		ADP	==  0X06 ; A/D Power Control
		ADCK1	==  0X05
		ADCK0	==  0X04 ; A/D Input Select Bits
				 ; |-----|-----|------------|---------------------------|
				 ; |ADCK1|ADCK0|Clock Source|Max.Operating Frequency(Fc)|
				 ; |-----|-----|------------|---------------------------|
				 ; |  0	 |  0  |    Fc/4    |           1MHz            |
				 ; |-----|-----|------------|---------------------------|
				 ; |  0	 |  1  |   Fc/16    |           4MHz            |
				 ; |-----|-----|------------|---------------------------|
				 ; |  1	 |  0  |   Fc/32    |           8MHz            |
				 ; |-----|-----|------------|---------------------------|
				 ; |  1	 |  1  |   Fc/64    |          16MHz            |
				 ; |-----|-----|------------|---------------------------|
		ADIS3	==  0X03
		ADIS2	==  0X02
		ADIS1	==  0X01
		ADIS0	==  0X00 ; A/D Input Select Bits
				 ; |-----|-----|-----|----------------------|
				 ; |ADIS3|ADIS2|ADIS1|ADIS0|Analog Input Pin|
				 ; |-----|-----|-----|----------------------|
				 ; |  0  |  0  |  0  |  0  |      AD0       |
				 ; |-----|-----|-----|----------------------|
				 ; |  0  |  0  |  0  |  1  |      AD1       |
				 ; |-----|-----|-----|----------------------|
				 ; |  0  |  0  |  1  |  0  |      AD2       |
				 ; |-----|-----|-----|----------------------|
				 ; |  0  |  0  |  1  |  1  |      AD3       |
				 ; |-----|-----|-----|----------------------|
				 ; |  0  |  1  |  0  |  0  |      AD4       |
				 ; |-----|-----|-----|----------------------|
				 ; |  0  |  1  |  0  |  1  |      AD5       |
				 ; |-----|-----|-----|----------------------|
				 ; |  0  |  1  |  1  |  0  |      AD6       |
				 ; |-----|-----|-----|----------------------|
				 ; |  0  |  1  |  1  |  1  |      AD7       |
				 ; |-----|-----|-----|----------------------|
				 ; |  1  |  0  |  0  |  0  |      AD8       |
				 ; |-----|-----|-----|----------------------|
				 ; |  1  |  0  |  0  |  1  |      AD9       |
				 ; |-----|-----|-----|----------------------|
				 ; |  1  |  0  |  1  |  0  |      AD10      |
				 ; |-----|-----|-----|----------------------|
				 ; |  1  |  0  |  1  |  1  |      AD11      |
				 ; |-----|-----|-----|----------------------|
	;}
;
;  Bank3 RA (A/D Input Control Register)
;
 B3_RA	==	0X0A
 ADICH	==	0X0A
;
	;{
		CALI	==  0X07 ; Calibration Enable Bit for A/D Offset
		ADREF	==  0X06 ; AD Reference Voltage Input Select
				 ; Bit4~5:Reserved
		ADE11	==  0X03 ; AD Input Pin Enalbe Control.0//1=>I/O//Analog.
		ADE10	==  0X02 ; AD Input Pin Enalbe Control.0//1=>I/O//Analog.
		ADE9	==  0x01 ; AD Input Pin Enalbe Control.0//1=>I/O//Analog.
		ADE8	==  0X00 ; AD Input Pin Enalbe Control.0//1=>I/O//Analog.
	;}
;
;  Bank3 RB (A/D Input Control Register)
;
 B3_RB	==	0X0B
 ADICL	==	0X0B
;
	;{
		ADE7	==  0X07 ; AD Input Pin Enalbe Control.0//1=>I/O//Analog.
		ADE6	==  0X06 ; AD Input Pin Enalbe Control.0//1=>I/O//Analog.
		ADE5	==  0x05 ; AD Input Pin Enalbe Control.0//1=>I/O//Analog.
		ADE4	==  0X04 ; AD Input Pin Enalbe Control.0//1=>I/O//Analog.
		ADE3	==  0X03 ; AD Input Pin Enalbe Control.0//1=>I/O//Analog.
		ADE2	==  0X02 ; AD Input Pin Enalbe Control.0//1=>I/O//Analog.
		ADE1	==  0x01 ; AD Input Pin Enalbe Control.0//1=>I/O//Analog.
		ADE0	==  0X00 ; AD Input Pin Enalbe Control.0//1=>I/O//Analog.
	;}
;
;  Bank3 RC (A/D High 8-bits Data Buffer)
;
 B3_RC	==	0X0C
 ADDH	==	0X0C
;
;  Bank3 RD (A/D Low 4-bits Data Buffer)
;
 B3_RD	==	0X0D
 ADDL	==	0X0D
;
	;{
		SIGN	==  0X07 ; Polarity Bit of Offset Voltage.0/1=>Negative/Positive
		VOF2	==  0X06
		VOF1	==  0X05
		VOF0	==  0X04 ; Offset Voltage Bits.
				 ; |----|----|----|---------|
				 ; |VOF2|VOF1|VOF0|EM78P510N|
				 ; |----|----|----|---------|
				 ; |  0 |  0 |  0 |   0LSB  |
				 ; |----|----|----|---------|
				 ; |  0 |  0 |  1 |   2LSB  |
				 ; |----|----|----|---------|
				 ; |  0 |  1 |  0 |   4LSB  |
				 ; |----|----|----|---------|
				 ; |  0 |  1 |  1 |   6LSB  |
				 ; |----|----|----|---------|
				 ; |  1 |  0 |  0 |   8LSB  |
				 ; |----|----|----|---------|
				 ; |  1 |  0 |  1 |  10LSB  |
				 ; |----|----|----|---------|
				 ; |  1 |  1 |  0 |  12LSB  |
				 ; |----|----|----|---------|
				 ; |  1 |  1 |  1 |  14LSB  |
				 ; |----|----|----|---------|
		ADD3	==  0X03
		ADD2	==  0X02
		ADD1	==  0X01
		ADD0	==  0X00
	;}
;
;  Bank3 RE (External Interrupt Edge Select Control Register High Byte)
;
 B3_RE	==	0X0E
 EIESH	==	0X0E
;
	;{
		EIES7	==  0X07 ; External Interrupt 7 Edge Select Bit.0/1=>Falling/Rising
		EIES6	==  0X06 ; External Interrupt 6 Edge Select Bit.0/1=>Falling/Rising
		EIES5	==  0X05 ; External Interrupt 5 Edge Select Bit.0/1=>Falling/Rising
		EIES4	==  0X04 ; External Interrupt 4 Edge Select Bit.0/1=>Falling/Rising
		EIES3	==  0X03 ; External Interrupt 3 Edge Select Bit.0/1=>Falling/Rising
		EIES2	==  0X02 ; External Interrupt 2 Edge Select Bit.0/1=>Falling/Rising
		EIES1	==  0X01 ; External Interrupt 1 Edge Select Bit.0/1=>Falling/Rising
		EIES0	==  0X00 ; External Interrupt 0 Edge Select Bit.0/1=>Falling/Rising
	;}
;
;  Bank3 RF (External Interrupt Edge Select Control Register Low Byte)
;
 B3_RF	==	0X0F
 EIESL	==	0X0F
;
	;{
				 ;Bit4~7 is "0"
		ADWK	==  0X04 ; A/D Converter Wake Up Function Enable Bit
		INTWK9	==  0X03 ; External Interrupt 9 Wake Up Function Enable Bit
		INTWK8	==  0X02 ; External Interrupt 8 Wake Up Function Enable Bit
		EIES9	==  0X01 ; External Interrupt 9 Edge Select Bit
		EIES8	==  0x00 ; External Interrupt 8 Edge Select Bit
	;}
;
;  Bank4 R5 (LED Drive Control Register)
;
 B4_R5	==	0X05
 LEDDCR	==	0X05
;
	;{
		LEDD7	==  0X07 ; 0:P9.7 as normal I/O,1:P9.7 as LED direct drive I/O.
		LEDD6	==  0X06 ; 0:P9.6 as normal I/O,1:P9.6 as LED direct drive I/O.
		LEDD5	==  0X05 ; 0:P9.5 as normal I/O,1:P9.5 as LED direct drive I/O.
		LEDD4	==  0X04 ; 0:P9.4 as normal I/O,1:P9.4 as LED direct drive I/O.
		LEDD3	==  0X03 ; 0:P9.3 as normal I/O,1:P9.3 as LED direct drive I/O.
		LEDD2	==  0X02 ; 0:P9.2 as normal I/O,1:P9.2 as LED direct drive I/O.
		LEDD1	==  0X01 ; 0:P9.1 as normal I/O,1:P9.1 as LED direct drive I/O.
		LEDD0	==  0X00 ; 0:P9.0 as normal I/O,1:P9.0 as LED direct drive I/O.
	;}
;
;  Bank4 R6 (Watch Timer and Buzzer Control Register)
;
 B4_R6	==	0X06
 WBCR	==	0X06
;
	;{
		WTCS	==  0X07 ; Watch Timer and Buzzer Clock Source Select Bit.
		WTIE	==  0X06 ; Watch Timer Enable Bit and Interrupt Mask
		WTIF	==  0X05 ; Watch Timer Interrupt Flag
		WTSSB1	==  0X04 ;
		WTSSB0  ==  0X03 ; Watch Timer Interval Select Bits
				 ; |------|------|-----------------------------------|
				 ; |WTSSB1|WTSSB0|Watch Timer Interval Select(WTCS=1)|
				 ; |  0   |   0  |                1.0S               |
				 ; |------|------|-----------------------------------|
				 ; |  0   |   1  |                0.5S               |
				 ; |------|------|-----------------------------------|
				 ; |  1   |   0  |               0.25S               |
				 ; |------|------|-----------------------------------|
				 ; |  1   |   1  |              3.91MS               |
				 ; |------|------|-----------------------------------|
		BUZE	==  0X02 ; Buzzer Enable and PORT91 as Buzzer Output Pin
		BSSB1	==  0X01
		BSSB0	==  0X00 ; Buzzer Output Frequency Select Bits
				 ; |-----|-----|----------------------------|
				 ; |BSSB1|BSSB0|Buzzer Signal Select(WTCS=1)|
				 ; |-----|-----|----------------------------|
				 ; |  0  |  0  |           0.5KHz           |
				 ; |-----|-----|----------------------------|
				 ; |  0  |  1  |           1.0KHz           |
				 ; |-----|-----|----------------------------|
				 ; |  1  |  0  |           2.0KHz           |
				 ; |-----|-----|----------------------------|
				 ; |  1  |  1  |           4.0KHz           |
				 ; |-----|-----|----------------------------|
	;}
;
;  Bank4 R7 (PORT7 I/O Control Register)
;
 B4_R7	==	0X07
 IOC7	==	0X07
 P7IOCR	==	0X07
;
;  Bank4 R8 (PORT8 I/O Control Register)
;
 B4_R8	==	0X08
 IOC8	==	0X08
 P8IOCR	==	0X08
;
;  Bank4 R9 (PORT9 I/O Control Register)
;
 B4_R9	==	0X09
 IOC9	==	0X09
 P9IOCR	==	0X09
;
;  Bank4 RA (PORTA I/O Control Register)
;
 B4_RA	==	0X0A
 IOCA	==	0X0A
 PAIOCR	==	0X0A
;
;  Bank4 RB (PORTB I/O Control Register)
;
 B4_RB	==	0X0B
 IOCB	==	0X0B
 PBIOCR	==	0X0B
;
;  Bank4 RC (PORTC I/O Control Register)
;
 B4_RC	==	0X0C
 IOCC	==	0X0C
 PCIOCR	==	0X0C
;
;  Bank4 RF (Wake Up Control Register)
;
 B4_RF	==	0X0F
 WKCR	==	0X0F
;
	;{
		INTWK7	==  0X07 ; External Interrupt 7 Wake Up Function Enable Bit.
		INTWK6	==  0X06 ; External Interrupt 6 Wake Up Function Enable Bit.
		INTWK5	==  0X05 ; External Interrupt 5 Wake Up Function Enable Bit.
		INTWK4	==  0X04 ; External Interrupt 4 Wake Up Function Enable Bit.
		INTWK3	==  0X03 ; External Interrupt 3 Wake Up Function Enable Bit.
		INTWK2	==  0X02 ; External Interrupt 2 Wake Up Function Enable Bit.
		INTWK1	==  0X01 ; External Interrupt 1 Wake Up Function Enable Bit.
		INTWK0	==  0X00 ; External Interrupt 0 Wake Up Function Enable Bit.
	;}
;
;  Bank4 R6 (UART Control Register 2)
;
 B5_R6	==	0X06
 UARC2	==	0X06
;
	;{
		UARTE	==  0X05  ; UART Function Enable
		UINVEN	==  0X03  ; Enable UART TX and RX Port Inverse Ouput
				  ; other Bits is "0"
	;}
;
; Bank5 R7 (PORT7 Pull High Control Register)
;
 B5_R7	==	0X07
 P7PHCR	==	0X07
;
	;{
		PH77	==  0X07 ;
		PH76	==  0X06 ;
		PH75	==  0X05 ;
		PH74	==  0X04 ;
		PH73	==  0X03 ;
		PH72	==  0X02 ;
		PH71	==  0X01 ;
		PH70	==  0X00 ;
	;}
;
; Bank5 R8 (PORT8 Pull High Control Register)
;
 B5_R8	==	0X08
 P8PHCR	==	0X08
;
	;{
		PH87	==  0X07 ;
		PH86	==  0X06 ;
		PH85	==  0X05 ;
		PH84	==  0X04 ;
		PH83	==  0X03 ;
		PH82	==  0X02 ;
		PH81	==  0X01 ;
		PH80	==  0X00 ;
	;}
;
; Bank5 R9 (PORT9 Pull High Control Register)
;
 B5_R9	==	0X09
 P9PHCR	==	0X09
;
	;{
		PH97	==  0X07 ;
		PH96	==  0X06 ;
		PH95	==  0X05 ;
		PH94	==  0X04 ;
		PH93	==  0X03 ;
		PH92	==  0X02 ;
		PH91	==  0X01 ;
		PH90	==  0X00 ;
	;}
;
; Bank5 RA (PORTA Pull High Control Register)
;
 B5_RA	==	0X0A
 PAPHCR	==	0X0A
;
	;{
		PHA7	==  0X07 ;
		PHA6	==  0X06 ;
		PHA5	==  0X05 ;
		PHA4	==  0X04 ;
		PHA3	==  0X03 ;
		PHA2	==  0X02 ;
		PHA1	==  0X01 ;
		PHA0	==  0X00 ;
	;}
;
; Bank5 RB (PORTB Pull High Control Register)
;
 B5_RB	==	0X0B
 PBPHCR	==	0X0B
;
	;{
		PHB7	==  0X07 ;
		PHB6	==  0X06 ;
		PHB5	==  0X05 ;
		PHB4	==  0X04 ;
		PHB3	==  0X03 ;
		PHB2	==  0X02 ;
		PHB1	==  0X01 ;
		PHB0	==  0X00 ;
	;}
;
; Bank5 RC (PORTC Pull High Control Register)
;
 B5_RC	==	0X0C
 PCPHCR	==	0X0C
;
	;{
		PHC3	==  0X03 ;
		PHC2	==  0X02 ;
		PHC1	==  0X01 ;
		PHC0	==  0X00 ;
				 ; Other Bits is "0"
	;}
;
;  Bank6 R6 (Low Voltage Reset Control Register)
;
 B6_R6  ==  0x06
 LVRCR  ==  0x06
;
    ;{
        LVREN   ==  0x02 ;
        LVRS1   ==  0x01 ;
        LVRS0   ==  0x00 ;
    ;}

;  Bank6 R7 (PORT7 Open Drain Control Reister)
;
 B6_R7	==	0X07
 P7ODCR	==	0X07
;
	;{
		P7OD7	==  0X07 ;
		P7OD6	==  0X06 ;
		P7OD5	==  0X05 ;
		P7OD4	==  0X04 ;
		P7OD3	==  0X03 ;
		P7OD2	==  0X02 ;
		P7OD1	==  0X01 ;
		P7OD0	==  0X00 ;
	;}
;
;  Bank6 R8 (PORT8 Open Drain Control Reister)
;
 B6_R8	==	0X08
 P8ODCR	==	0X08
;
	;{
		P8OD7	==  0X07 ;
		P8OD6	==  0X06 ;
		P8OD5	==  0X05 ;
		P8OD4	==  0X04 ;
		P8OD3	==  0X03 ;
		P8OD2	==  0X02 ;
		P8OD1	==  0X01 ;
		P8OD0	==  0X00 ;
	;}
;
;  Bank6 R9 (PORT9 Open Drain Control Reister)
;
 B6_R9	==	0X09
 P9ODCR	==	0X09
;
	;{
		P9OD7	==  0X07 ;
		P9OD6	==  0X06 ;
		P9OD5	==  0X05 ;
		P9OD4	==  0X04 ;
		P9OD3	==  0X03 ;
		P9OD2	==  0X02 ;
		P9OD1	==  0X01 ;
		P9OD0	==  0X00 ;
	;}
;
;  Bank6 RA (PORTA Open Drain Control Reister)
;
 B6_RA	==	0X0A
 PAODCR	==	0X0A
;
	;{
		PAOD7	==  0X07 ;
		PAOD6	==  0X06 ;
		PAOD5	==  0X05 ;
		PAOD4	==  0X04 ;
		PAOD3	==  0X03 ;
		PAOD2	==  0X02 ;
		PAOD1	==  0X01 ;
		PAOD0	==  0X00 ;
	;}
;
;  Bank6 RB (PORTB Open Drain Control Reister)
;
 B6_RB	==	0X0B
 PBODCR	==	0X0B
;
	;{
		PBOD7	==  0X07 ;
		PBOD6	==  0X06 ;
		PBOD5	==  0X05 ;
		PBOD4	==  0X04 ;
		PBOD3	==  0X03 ;
		PBOD2	==  0X02 ;
		PBOD1	==  0X01 ;
		PBOD0	==  0X00 ;
	;}
;
;  Bank6 RC (PORTC Open Drain Control Reister)
;
 B6_RC	==	0X0C
 PCODCR	==	0X0C
;
	;{
				 ; Other
		PCOD3	==  0X03 ;
		PCOD2	==  0X02 ;
		PCOD1	==  0X01 ;
		PCOD0	==  0X00 ;
	;}
;
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
