;******************************************************;
;                                                      ;
;  Tilte:       EM78P520N include file                 ;
;  Description: The Definition of EM78P520N Registers  ;
;  Company:     Elan Electronic Corp.                  ;
;  Date:        2008/12/11                             ;
;******************************************************;
;
;======================================================;
; Operational Registers Define                         ;
;======================================================;
;
;======================================================;
; Register R0~R4                                       ;
;======================================================;
; 
; Indirect Addressing register
; 
 R0     ==    0x00:rpage 0
 IAR    ==    0x00:rpage 0	
; 
; Time Clock/Counter
; 
 R1     ==    0x01:rpage 0
 TCC    ==    0x01:rpage 0    ; TCC Counter Preset
;
; Program Counter
; 
 R2     ==    0X02:rpage 0
 PC     ==    0X02:rpage 0   
;
; Status Register and Voltage Detect
; 
 R3     ==    0X03:rpage 0
 LVDCR  ==    0X03:rpage 0
 STATUS	==    0x03:rpage 0	
; 
     ;{
     	 LVDEN	==    STATUS.7    ; Voltage Detect Enable Bit
         LVDS1	==    STATUS.6    ; Detect Voltage Select Bit[1]
         LVDS0	==    STATUS.5    ; Detect Voltage Select Bit[0]
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
         T      ==    STATUS.4    ; Time-Out Bit
         P      ==    STATUS.3    ; Power Down Bit
         Z      ==    STATUS.2    ; Zero Flag
         DC     ==    STATUS.1    ; Auxiliary Carry Flag
         C      ==    STATUS.0    ; Carry Flag
                                  ;        
     ;}
; 
; RAM Select Register (RSR)
; 
 R4     ==    0X04:rpage 0
 RSR    ==    0X04:rpage 0    
     ;{
                                ; Bits 5~0 are used to select up to 64 registers in the 
                                ; indirect addressing mode.
                                ;
         VDB	  ==    RSR.7    ; Voltage Detector 
         BNC      ==    RSR.6    ; Bank Control Register
                                ;
         RSR5     ==    RSR.5    ;  
         RSR4     ==    RSR.4    ;
         RSR3     ==    RSR.3    ;
         RSR2     ==    RSR.2    ;
         RSR1     ==    RSR.1    ;
         RSR0     ==    RSR.0    ;
                                ;
     ;}
;======================================================;
; Bank0~6 Register R5~RF                               ;
;======================================================;     
;                      
; Bank0 R5(RAM Bank Select Register)
; 
 R5  	  ==	0X05:rpage 0
 BSR      ==    0X05:rpage 0
; 
     ;{
     				    ; Bit3~7 is "0" 	
         BS2          ==    BSR.2    ; RAM Bank Select Register Bits[2]
         BS1          ==    BSR.1    ; RAM Bank Select Register Bits[1]
         BS0          ==    BSR.0    ; RAM Bank Select Register Bits[0]
     ;}
; 
; Bank0 R7(Port 7 data Register)
; 
 R7   	  ==    0X07:rpage 0
 PORT7    ==    0X07:rpage 0
;  
; Bank0 R8(Port 8 data Register)
; 
 R8  	  ==    0X08:rpage 0
 PORT8    ==    0X08:rpage 0
;  
; Bank0 R9(PORT 9 Data Register)
;
 R9       ==    0X09:rpage 0
 PORT9    ==    0X09:rpage 0
;
;  Bank0 RA(PORTA Data Register)
;
 RA	  ==	0X0A:rpage 0
 PORTA	  ==	0X0A:rpage 0     
;
;  Bank0 RB(PORT8 Data Register)
;
 RB	==	0X0B:rpage 0
 PORTB	==	0X0B:rpage 0
;
;  Bank0 RC(System Clock Control Register)
;
 RC	==	0X0C:rpage 0
 SCCR	==	0X0C:rpage 0
;
	;{
				   ; Bit7 is "0"
		CLK2	==  SCCR.6 ;
		CLK1	==  SCCR.5 ;
		CLK0	==  SCCR.4 ; Main Clock Select Bit for PLL Mode
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
		IDLE	==  SCCR.3 ; Idle Mode Enable Bit.
		 		   ; IDLE="0"+SLEP instruction=>sleep mode
		 		   ; IDLE="1"+SLEP instruction=>idle mode
		CPUS	==  SCCR.0 ; CPU Oscillator Source Select.
				   ; 0/1=>sub-oscillator(fs)/main oscillator(fm)
	;}
;
; Bank0 RD(TCC and WDT Timer control register)
; 		   
 RD	==	0X0D:rpage 0	
 TWTCR	==	0X0D:rpage 0
;
	;{
		WDTE	==  TWTCR.7 ; Watchdog Timer Enable.0/1=>disable/enable
		WPSR2	==  TWTCR.6
		WPSR1	==  TWTCR.5
		WPSR0	==  TWTCR.4 ; WDT Prescaler Bits
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
		TCCS	==  TWTCR.3 ; TCC Clock Source Select Bit.0/1=>Fm/Fs
		TPSR2	==  TWTCR.2 
		TPSR1	==  TWTCR.1
		TPSR0	==  TWTCR.0 ; TCC Prescaler Bits
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
 RE	==	0X0E:rpage 0
 IMR	==	0X0E:rpage 0
;
	;{
		T1IE	==  IMR.7 ; Timer1 Interrupt Enable Bit
		LVDIE   ==  IMR.6 ; low Voltage Detect Interrupt Enable Bit
		ADIE	==  IMR.5 ; A/D convert Interrupt Enable Bit
		SPIIE    ==  IMR.4 ; SPI transfer Interrupt Enable Bit
		URTIE	==  IMR.3 ; UART transmit Interrupt Enable Bit
		EXIE9	==  IMR.2 ; External interrupt 9 Enable Bit
		EXIE8	==  IMR.1 ; External interrupt 8 Enable Bit
		TCIE	==  IMR.0 ; TCC Overflow Interrupt Enable Bit
	;}
;
;  Bank0 RF (Interrupt Status Register)
;
 RF	==	0X0F:rpage 0
 ISR	==	0X0F:rpage 0
;
	;{
		T1IF	==  ISR.7 ; interrupt flag of timer1 interrupt
		LVDIF	==  ISR.6 ; interrupt flag of low voltage detector interrupt
		ADIF	==  ISR.5 ; interrupt flag of A/D convert Complete
		SPIIF	==  ISR.4 ; interrupt flag of SPI transfer complete
		URTIF	==  ISR.3 ; interrupt flag of UART transfer complete
		EXIF9	==  ISR.2 ; interrupt flag of external interrupt 9 Occur.
		EXIF8	==  ISR.1 ; interrupt flag of external interrupt 8 Occur.
		TCIF	==  ISR.0 ; interrupt flag of TCC Overflow
	;}
;
;  Bank1 R5 (LCD Control Register)
;
 LCDCR	==	0X05:rpage 1
;
	;{
		LCDEN	==  LCDCR.7 ; lCD Enable Select Bit.0/1=>disable/enable
		LCDTYPE	==  LCDCR.6 ; LCD Drive Waveform Type Select Bit
		LBS1	==  LCDCR.5 
		LBS0	==  LCDCR.4 ; LCD Bias Select Bits		
				 ; |---|---|---------------|
				 ; |BS1|BS0|LCD Bias Select|
				 ; |---|---|---------------|
				 ; | 0 | 0 |   1/2 Bias    |
				 ; |---|---|---------------|
				 ; | 0 | 1 |   1/3 Bias    |
				 ; |---|---|---------------|
				 ; | 1 | X |   1/4 Bias    |
				 ; |---|---|---------------|
		DS1	==  LCDCR.3
		DS0	==  LCDCR.2 ; LCD Duty Select Bits
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
		LCDF1	==  LCDCR.1 ;
		LCDF0	==  LCDCR.0 ; LCD Frame Frequency Control Bits
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
 LCDAR	==    0X06:rpage 1
;
; Bank1 R7 (LCD Data Buffer)
;
 LCDBR	==    0X07:rpage 1
;
;  Bank1 R8 (LCD Voltage Control Register)	
;
 LCDVCR	==	0x08:rpage 1
;
	;{
				 ; Bit7~5 Reserved
		LCDC1	==  LCDVCR.4
		LCDC0	==  LCDVCR.3 ; LCD Clock
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
		LCDVC2	==  LCDVCR.2
		LCDVC1	==  LCDVCR.1
		LCDVC0	==  LCDVCR.0 ; LCD Voltage Control Bits
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
 LCDCCR	==	0x09:rpage 1
;
	;{
		COM7	==  LCDCCR.7 ; 0:Disable, functions as normal I/O or other functions,	
		COM6	==  LCDCCR.6 ; 1:LEnable, functions as LCD common driver pins.
		COM5	==  LCDCCR.5		
		COM4	==  LCDCCR.4		
		COM3	==  LCDCCR.3		
		COM2	==  LCDCCR.2		
		COM1	==  LCDCCR.1		
		COM0	==  LCDCCR.0
	;}
;		
;  Bank1 RA (LCD Segment Control Register0)
;
 LCDSCR0	==	0X0A:rpage 1
;
	;{
		SEG7	==  LCDSCR0.7 ;  0 : Disable, functions as normal I/O or other functions
		SEG6	==  LCDSCR0.6 ;  1 : Enable, functions as LCD common driver pins
		SEG5	==  LCDSCR0.5  
		SEG4	==  LCDSCR0.4  
		SEG3	==  LCDSCR0.3  
		SEG2	==  LCDSCR0.2  
		SEG1	==  LCDSCR0.1  
		SEG0	==  LCDSCR0.0  
	;}
;
;  Bank1 RB (LCD Segment Control Register1)
;
 LCDSCR1	==	0X0B:rpage 1
;
	;{
		SEG15	==  LCDSCR1.7 ;   0 : Disable, functions as normal I/O or other functions
		SEG14	==  LCDSCR1.6 ;   1 : Enable, functions as LCD common driver pins        
		SEG13	==  LCDSCR1.5 ;                                                          
		SEG12	==  LCDSCR1.4 ;                                                          
		SEG11	==  LCDSCR1.3 ;                                                          
		SEG10	==  LCDSCR1.2 ;                                                          
		SEG9	==  LCDSCR1.1 ;                                                          
		SEG8	==  LCDSCR1.0 ;                                                          
	;}
;
;  Bank1 RC (LCD Segment Control Register2)
;
 LCDSCR2	==	0X0C:rpage 1
;
	;{
				      ; Bit7:Reserved
		SEG22	==  LCDSCR2.6 ; 0 : Disable, functions as normal I/O or other functions
		SEG21	==  LCDSCR2.5 ; 1 : Enable, functions as LCD common driver pins        
		SEG20	==  LCDSCR2.4 ;                                                          
		SEG19	==  LCDSCR2.3 ;                                                          
		SEG18	==  LCDSCR2.2 ;                                                          
		SEG17	==  LCDSCR2.1 ;                                                          
		SEG16	==  LCDSCR2.0 ;                                                          
	;}                                                                                     
;
;  Bank1 RE (External Interrupt Mask Register)
;
 EIMR	==	0X0E:rpage 1
;
	;{
		EXIE7	==  EIMR.7
		EXIE6	==  EIMR.6
		EXIE5	==  EIMR.5
		EXIE4	==  EIMR.4
		EXIE3	==  EIMR.3
		EXIE2	==  EIMR.2
		EXIE1	==  EIMR.1
		EXIE0	==  EIMR.0 
	;}

	;{		
	;	|-----|----------------|------------------|-----------------|----|
	;	|INT7 |PB3, SEG11      |ENI+EXIE7 (EIMR7) |Rising or Falling|2/Fc|
	;	|-----|----------------|------------------|-----------------|----|       		
	;	|INT6 |PB2, SEG10, AD11|ENI+EXIE6 (EIMR6) |Rising or Falling|2/Fc|
	;	|-----|----------------|------------------|-----------------|----|
	;	|INT5 |PB1, SEG9, AD10 |ENI+EXIE5 (EIMR5) |Rising or Falling|2/Fc|
	;	|-----|----------------|------------------|-----------------|----|       		
	;	|INT4 |PB0, SEG8, AD9  |ENI+EXIE4 (EIMR4) |Rising or Falling|2/Fc|
	;	|-----|----------------|------------------|-----------------|----|       		
	;	|INT3 |P77, T1CAP      |ENI+EXIE3 (EIMR3) |Rising or Falling|2/Fc|
	;	|-----|----------------|------------------|-----------------|----|       		
	;	|INT2 |P76, T1CK       |ENI+EXIE2 (EIMR2) |Rising or Falling|2/Fc|
	;	|-----|----------------|------------------|-----------------|----|       		
	;	|INT1 |P75, T1OUT, PWM1|ENI+EXIE1 (EIMR1) |Rising or Falling|2/Fc|
	;	|-----|----------------|------------------|-----------------|----|	
	 ;       |INT0 |P74, SEG18      |ENI+EXIE0 (EIMR0) |Rising or Falling|2/Fc|
	 ;       |-----|----------------|------------------|-----------------|----|
	 ;}        
;
;  Bank1 RF (External Interrupt Status Register)
;
 EISR	==	0X0F:rpage 1
;
	;{
		EXIF7	==  EISR.7 ; /INT7 Interrupt Flag Bit.
		EXIF6	==  EISR.6 ; /INT6 Interrupt Flag Bit.
		EXIF5	==  EISR.5 ; /INT5 Interrupt Flag Bit.
		EXIF4	==  EISR.4 ; /INT4 Interrupt Flag Bit.
		EXIF3	==  EISR.3 ; /INT3 Interrupt Flag Bit.
		EXIF2	==  EISR.2 ; /INT2 Interrupt Flag Bit.
		EXIF1	==  EISR.1 ; /INT1 Interrupt Flag Bit.
		EXIF0	==  EISR.0 ; /INT0 Interrupt Flag Bit.
	;}
;
;  Bank2 R5 (Timer1 Control Register)
;
 T1CR	==	0X05:rpage 2
;
	;{
		T1S1	==  TICR.7
		T1S0	==  TICR.6 ; Timer1 and Timer2 Interrupt Type Select Bits.
				 ; |----|----|---------------------------------------|
				 ; |T1S1|T1S0|Timer1 and Timer2 Interrupt Type Select|
				 ; |----|----|---------------------------------------|
				 ; |  0 |  0 |           TXPD underflow              |
				 ; |----|----|---------------------------------------|
				 ; |  0 |  1 |           TXTD underflow             |
				 ; |----|----|---------------------------------------|
				 ; |  1 |  X |      TXPD and TXTD underflow          |
				 ; |----|----|---------------------------------------|
		T1MS2	==  TICR.5 
		T1MS1	==  TICR.4 
		T1MS0	==  TICR.3 ; Timer1 Operation Mode Select Bits
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
		T1P2	==  TICR.2 
		T1P1	==  TICR.1 
		T1P0	==  TICR.0 ; Timer1 Prescaler Bits
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
  TSR	==	0X06:rpage 2
;
	;{
		T1MOD	==  TSR.7 ; Timer Operates Mode Select Bit.
		TRCB	==  TSR.6 ; Timer1,2 Read Control Bit.
		T1CSS1	==  TSR.5 ;
		T1CSS0	==  TSR.4 ; Timer1 Clock Source Select Bits
				 ; |------|------|--------------------------|
				 ; |T1CSS1|T1CSS0|Timer1 Clock Source select|
				 ; |------|------|--------------------------|
				 ; |  0   |  0   |            Fm            |
				 ; |------|------|--------------------------|
				 ; |  0   |  1   |            Fs            |
				 ; |------|------|--------------------------|
				 ; |  1   |  X   |           T1CK           |
				 ; |------|------|--------------------------|				  
		T2CSS	==  TSR.3 ; Timer2 Clock Source Select Bit.0/1=>Fm/Fs.
		T1EN	==  TSR.2 ; Timer1 Start Bit.
		T1OMS	==  TSR.1 ; Timer1 Output Mode Select Bit.0/1=>repeating/on-shot.
		T1OC	==  TSR.0 ; Timer1 Output Flip-Flop Control Bit.
	;}
;
;  Bank2 R7 (Timer1 Period Buffer)
;
 T1PD	==	0X07:rpage 2
;
;  Bank2 R8 (Timer1 Duty Buffer)
;
 T1TD	==	0X08:rpage 2
;
;  Bank2 R9 (Timer2 Control Register)
;
 T2CR	==	0X09:rpage 2
;
	;{
		T2IF	==  T2CR.7 ; Interrupt Flag of Timer2 Interrupt
		T2IE	==  T2CR.6 ; Timer2 Interrupt Mask Bit
		T2S	==  T2CR.5 ; Timer2 Start Bit
		T2MS1	==  T2CR.4 
		T2MS0	==  T2CR.3 ; Timer2 Operation Mode Select Bits.						
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
		T2P2	==  T2CR.2 
		T2P1	==  T2CR.1
		T2P0	==  T2CR.0 ; Timer2 Prescaler Bits
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
				 ; |-----|-----|-----|-----------------| 
				 ; |  1  |  1  |  0  |      1:128      |
				 ; |-----|-----|-----|-----------------|
				 ; |  1  |  1  |  1  |      1:256      |
				 ; |-----|-----|-----|-----------------|
	;}
;
;  Bank2 RA (Timer2 Period Buffer)
;
 T2PD	==	0X0A:rpage 2
;
; Bank2 RB (Timer Duty Buffer)
;
  T2TD	==	0X0B:rpage 2
;
;  Bank2 RC (SPI Status Register)
;
 SPIS	==	0X0C:rpage 2
;
	;{
		DORD	==  SPIS.7 ; Data Shift Control 0 : Shift left (MSB first)/1 : Shift right (LSB first)
		TD1	==  SPIS.6 ; 
		TD0	==  SPIS.5 ; SDO Status Output Delay Times Options
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
		OD3	==  SPIS.3 ; Open-Drain Control Bit
		OD4	==  SPIS.2 ;
				 ; Bi1 Reserved
		RBF	==  SPIS.0 ; Read Buffer Full Flag
	;}
;
;  Bank2 RD (SPI Control Register)
;
 SPIC	==	0X0D:rpage 2
;
	;{
		CES	==  SPIC.7 ; Clock Edge Select Bit
		SPIE	==  SPIC.6 ; SPI Enable Bit
		SRO	==  SPIC.5 ; SPI Read Overflow Bit
		SSE	==  SPIC.4 ; SPI Shift Enable Bit
		SDOC	==  SPIC.3 ; SDO Output Status Control Bit
		SBRS2	==  SPIC.2
		SBRS1	==  SPIC.1
		SBRS0	==  SPIC.0 ; SPI Baud Rate Select Bits
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
 SPIR	==	0X0E:rpage 2
;
;  Bank2 RF (SPI Write Buffer)
;
 SPIW	==	0X0F:rpage 2
;
;  Bank3 R5 (UART Control Register)
;
 URC	==	0X05:rpage 3
;
	;{
		URTD8	==  URC.7 ; Transmission Data Bit8
		UMODE1	==  URC.6
		UM0DE0	==  URC.5 ; UART Transmission Mode Select Bit
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
		BRATE2	==  URC.4 
		BRATE1	==  URC.3
		BRATE0	==  URC.2 ; Transmit Baud Rate Select(Tuart=Fc/16)
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
		UTBE==  URC.1
		TXE	==  URC.0 ; Enable transmission
	;}
;
;  Bank 3 R6 (UART Status)
;
 URS	==  0X06:rpage 3
;
	;{
		URRD8	==  URS.7 ; Receiving Data Bit8
		EVEN	==  URS.6 ; Select Parity Check
		PRE	==  URS.5 ; Enable Parity Check
		PRERR	==  URS.4 ; Parity Error Flag
		OVERR	==  URS.3 ; Over Running Error Flag
		FMERR	==  URS.2 ; Framing Error Flag
		URBF	==  URS.1 ; UART Read Buffer Full Flag
		RXE	==  URS.0 ; Enable Receiving
	;}
;
;  Bank3 R7 (UART_RD Data Buffer)
;
 URRD	==	0X07:rpage 3
;
;  Bank3 R8 (UART_TD Data Buffer)
;
 URTD	==	0X08:rpage 3
;
;  Bank3 R9 (A/D Control Register)
;
 ADCR	==	0X09:rpage 3
;
	;{
		ADRUN	==  ADCR.7 ; AD Conversion Start
		ADP		==  ADCR.6 ; A/D Power Control
		ADCK1	==  ADCR.5
		ADCK0	==  ADCR.4 ; A/D Input Select Bits
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
		ADIS3	==  ADCR.3
		ADIS2	==  ADCR.2
		ADIS1	==  ADCR.1
		ADIS0	==  ADCR.0 ; A/D Input Select Bits
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
 ADICH	==	0X0A:rpage 3
;
	;{
		CALI	==  ADICH.7 ; Calibration Enable Bit for A/D Offset
		ADREF	==  ADICH.6 ; AD Reference Voltage Input Select
				 ; Bit4~5:Reserved
		ADE11	==  ADICH.3 ; AD Input Pin Enalbe Control.0//1=>I/O//Analog.
		ADE10	==  ADICH.2 ; AD Input Pin Enalbe Control.0//1=>I/O//Analog.
		ADE9	==  ADICH.1 ; AD Input Pin Enalbe Control.0//1=>I/O//Analog.
		ADE8	==  ADICH.0 ; AD Input Pin Enalbe Control.0//1=>I/O//Analog.
	;}
;
;  Bank3 RB (A/D Input Control Register)
;
 ADICL	==	0X0B:rpage 3
;
	;{
		ADE7	==  ADICL.7 ; AD Input Pin Enalbe Control.0//1=>I/O//Analog.
		ADE6	==  ADICL.6 ; AD Input Pin Enalbe Control.0//1=>I/O//Analog.
		ADE5	==  ADICL.5 ; AD Input Pin Enalbe Control.0//1=>I/O//Analog.
		ADE4	==  ADICL.4 ; AD Input Pin Enalbe Control.0//1=>I/O//Analog.
		ADE3	==  ADICL.3 ; AD Input Pin Enalbe Control.0//1=>I/O//Analog.
		ADE2	==  ADICL.2 ; AD Input Pin Enalbe Control.0//1=>I/O//Analog.
		ADE1	==  ADICL.1 ; AD Input Pin Enalbe Control.0//1=>I/O//Analog.
		ADE0	==  ADICL.0 ; AD Input Pin Enalbe Control.0//1=>I/O//Analog.
	;}
;
;  Bank3 RC (A/D High 8-bits Data Buffer)
;
 ADDH	==	0X0C:rpage 3
;
;  Bank3 RD (A/D Low 4-bits Data Buffer)
;
 ADDL	==	0X0D:rpage 3
;
	;{
		SIGN	==  ADDL.7 ; Polarity Bit of Offset Voltage.0/1=>Negative/Positive
		VOF2	==  ADDL.6
		VOF1	==  ADDL.5
		VOF0	==  ADDL.4 ; Offset Voltage Bits.
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
		ADD3	==  ADDL.3
		ADD2	==  ADDL.2
		ADD1	==  ADDL.1
		ADD0	==  ADDL.0
	;}
;
;  Bank3 RE (External Interrupt Edge Select Control Register High Byte)
;
 EIESH	==	0X0E:rpage 3
;
	;{
		EIES7	==  EIESH.7 ; External Interrupt 7 Edge Select Bit.0/1=>Falling/Rising
		EIES6	==  EIESH.6 ; External Interrupt 6 Edge Select Bit.0/1=>Falling/Rising
		EIES5	==  EIESH.5 ; External Interrupt 5 Edge Select Bit.0/1=>Falling/Rising
		EIES4	==  EIESH.4 ; External Interrupt 4 Edge Select Bit.0/1=>Falling/Rising
		EIES3	==  EIESH.3 ; External Interrupt 3 Edge Select Bit.0/1=>Falling/Rising
		EIES2	==  EIESH.2 ; External Interrupt 2 Edge Select Bit.0/1=>Falling/Rising
		EIES1	==  EIESH.1 ; External Interrupt 1 Edge Select Bit.0/1=>Falling/Rising
		EIES0	==  EIESH.0 ; External Interrupt 0 Edge Select Bit.0/1=>Falling/Rising
	;}
;
;  Bank3 RF (External Interrupt Edge Select Control Register Low Byte)
;
 EIESL	==	0X0F:rpage 3
;
	;{
				 ;Bit4~7 is "0"
		ADWK	==  EIESL.4 ; A/D Converter Wake Up Function Enable Bit
		INTWK9	==  EIESL.3 ; External Interrupt 9 Wake Up Function Enable Bit
		INTWK8	==  EIESL.2 ; External Interrupt 8 Wake Up Function Enable Bit
		EIES9	==  EIESL.1 ; External Interrupt 9 Edge Select Bit
		EIES8	==  EIESL.0 ; External Interrupt 8 Edge Select Bit
	;}
;
;  Bank4 R5 (LED Drive Control Register)
;
 LEDDCR	==	0X05:rpage 4
;
	;{
		LEDD7	==  LEDDCR.7 ; 0:P9.7 as normal I/O,1:P9.7 as LED direct drive I/O.
		LEDD6	==  LEDDCR.6 ; 0:P9.6 as normal I/O,1:P9.6 as LED direct drive I/O.
		LEDD5	==  LEDDCR.5 ; 0:P9.5 as normal I/O,1:P9.5 as LED direct drive I/O.
		LEDD4	==  LEDDCR.4 ; 0:P9.4 as normal I/O,1:P9.4 as LED direct drive I/O.
		LEDD3	==  LEDDCR.3 ; 0:P9.3 as normal I/O,1:P9.3 as LED direct drive I/O.
		LEDD2	==  LEDDCR.2 ; 0:P9.2 as normal I/O,1:P9.2 as LED direct drive I/O.
		LEDD1	==  LEDDCR.1 ; 0:P9.1 as normal I/O,1:P9.1 as LED direct drive I/O.
		LEDD0	==  LEDDCR.0 ; 0:P9.0 as normal I/O,1:P9.0 as LED direct drive I/O.
	;}
;
;  Bank4 R6 (Watch Timer and Buzzer Control Register)
;
 WBCR	==	0X06:rpage 4
;
	;{
		WTCS	==  WBCR.7 ; Watch Timer and Buzzer Clock Source Select Bit.
		WTIE	==  WBCR.6 ; Watch Timer Enable Bit and Interrupt Mask
		WTIF	==  WBCR.5 ; Watch Timer Interrupt Flag
		WTSSB1	==  WBCR.4 ; 
		WTSSB0  ==  WBCR.3 ; Watch Timer Interval Select Bits
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
		BUZE	==  WBCR.2 ; Buzzer Enable and PORT91 as Buzzer Output Pin
		BSSB1	==  WBCR.1
		BSSB0	==  WBCR.0 ; Buzzer Output Frequency Select Bits
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
 IOC7	==	0X07:rpage 4
 P7IOCR	==	0X07:rpage 4
 P7CR	==	0X07:rpage 4
;
;  Bank4 R8 (PORT8 I/O Control Register)
;
 IOC8	==	0X08:rpage 4
 P8IOCR	==	0X08:rpage 4
 P8CR	==	0X08:rpage 4
;
;  Bank4 R9 (PORT9 I/O Control Register)
;
 IOC9	==	0X09:rpage 4
 P9IOCR	==	0X09:rpage 4	
 P9CR	==	0X09:rpage 4
;
;  Bank4 RA (PORTA I/O Control Register)
;
 IOCA	==	0X0A:rpage 4
 PAIOCR	==	0X0A:rpage 4
 PACR	==  0X0A:rpage 4
;
;  Bank4 RB (PORTB I/O Control Register)
;
 IOCB	==	0X0B:rpage 4
 PBIOCR	==	0X0B:rpage 4
 PBCR	==	0X0B:rpage 4
;
;  Bank4 RC (PORTC I/O Control Register)
;
 IOCC	==	0X0C:rpage 4
 PCIOCR	==	0X0C:rpage 4
 PCCR	==	0X0C:rpage 4
;
;  Bank4 RF (Wake Up Control Register)
;
 WKCR	==	0X0F:rpage 4
;
	;{
		INTWK7	==  WKCR.7 ; External Interrupt 7 Wake Up Function Enable Bit.
		INTWK6	==  WKCR.6 ; External Interrupt 6 Wake Up Function Enable Bit.
		INTWK5	==  WKCR.5 ; External Interrupt 5 Wake Up Function Enable Bit.
		INTWK4	==  WKCR.4 ; External Interrupt 4 Wake Up Function Enable Bit.
		INTWK3	==  WKCR.3 ; External Interrupt 3 Wake Up Function Enable Bit.
		INTWK2	==  WKCR.2 ; External Interrupt 2 Wake Up Function Enable Bit.
		INTWK1	==  WKCR.1 ; External Interrupt 1 Wake Up Function Enable Bit.
		INTWK0	==  WKCR.0 ; External Interrupt 0 Wake Up Function Enable Bit.
	;}
;
;  Bank4 R6 (UART Control Register 2)
;
 UARC2	==	0X06:rpage 5
;
	;{
		UARTE	==   UARC2.5  ; UART Function Enable
		UINVEN	==   UARC2.3  ; Enable UART TX and RX Port Inverse Ouput
				  ; other Bits is "0"
	;}
;
; Bank5 R7 (PORT7 Pull High Control Register)
;
 P7PHCR	==	0X07:rpage 5
;
	;{
		PH77	==  P7PHCR.7 ;	
		PH76	==  P7PHCR.6 ;	
		PH75	==  P7PHCR.5 ;	
		PH74	==  P7PHCR.4 ;	
		PH73	==  P7PHCR.3 ;	
		PH72	==  P7PHCR.2 ;	
		PH71	==  P7PHCR.1 ;	
		PH70	==  P7PHCR.0 ;	
	;}
;
; Bank5 R8 (PORT8 Pull High Control Register)
;
 P8PHCR	==	0X08:rpage 5
;
	;{
		PH87	==  P8PCR.7 ;	
		PH86	==  P8PCR.6 ;	
		PH85	==  P8PCR.5 ;	
		PH84	==  P8PCR.4 ;	
		PH83	==  P8PCR.3 ;	
		PH82	==  P8PCR.2 ;	
		PH81	==  P8PCR.1 ;	
		PH80	==  P8PCR.0 ;	
	;}
;
; Bank5 R9 (PORT9 Pull High Control Register)
;
 P9PHCR	==	0X09:rpage 5
;
	;{
		PH97	==  P9PHCR.7 ;	
		PH96	==  P9PHCR.6 ;	
		PH95	==  P9PHCR.5 ;	
		PH94	==  P9PHCR.4 ;	
		PH93	==  P9PHCR.3 ;	
		PH92	==  P9PHCR.2 ;	
		PH91	==  P9PHCR.1 ;	
		PH90	==  P9PHCR.0 ;	
	;}
;
; Bank5 RA (PORTA Pull High Control Register)
;
 PAPHCR	==	0X0A:rpage 5
;
	;{
		PHA7	==  PAPHCR.7 ;	
		PHA6	==  PAPHCR.6 ;	
		PHA5	==  PAPHCR.5 ;	
		PHA4	==  PAPHCR.4 ;	
		PHA3	==  PAPHCR.3 ;	
		PHA2	==  PAPHCR.2 ;	
		PHA1	==  PAPHCR.1 ;	
		PHA0	==  PAPHCR.0 ;	
	;}
;
; Bank5 RB (PORTB Pull High Control Register)
;
 PBPHCR	==	0X0B:rpage 5
;
	;{
		PHB7	==  PBPHCR.7 ;	
		PHB6	==  PBPHCR.6 ;	
		PHB5	==  PBPHCR.5 ;	
		PHB4	==  PBPHCR.4 ;	
		PHB3	==  PBPHCR.3 ;	
		PHB2	==  PBPHCR.2 ;	
		PHB1	==  PBPHCR.1 ;	
		PHB0	==  PBPHCR.0 ;	
	;}
;
; Bank5 RC (PORTC Pull High Control Register)
;
 PCPHCR	==	0X0C:rpage 5
;
	;{
		PHC3	==  PCPHCR.3 ;	
		PHC2	==  PCPHCR.2 ;	
		PHC1	==  PCPHCR.1 ;	
		PHC0	==  PCPHCR.0 ;	
				 ; Other Bits is "0"
	;}
;
LVRCR	==	0X06:rpage 6
;
;  Bank6 R7 (PORT7 Open Drain Control Reister)
;
 P7ODCR	==	0X07:rpage 6
;
	;{
		P7OD7	==  P70DCR.7 ;
		P7OD6	==  P70DCR.6 ;
		P7OD5	==  P70DCR.5 ;
		P7OD4	==  P70DCR.4 ;
		P7OD3	==  P70DCR.3 ;
		P7OD2	==  P70DCR.2 ;
		P7OD1	==  P70DCR.1 ;
		P7OD0	==  P70DCR.0 ;
	;}
;
;  Bank6 R8 (PORT8 Open Drain Control Reister)
;
 P8ODCR	==	0X08:rpage 6
;
	;{
		P8OD7	==  P8ODCR.7 ;
		P8OD6	==  P8ODCR.6 ;
		P8OD5	==  P8ODCR.5 ;
		P8OD4	==  P8ODCR.4 ;
		P8OD3	==  P8ODCR.3 ;
		P8OD2	==  P8ODCR.2 ;
		P8OD1	==  P8ODCR.1 ;
		P8OD0	==  P8ODCR.0 ;
	;}
;
;  Bank6 R9 (PORT9 Open Drain Control Reister)
;
 P9ODCR	==	0X09:rpage 6
;
	;{
		P9OD7	==  P9ODCR.7 ;
		P9OD6	==  P9ODCR.6 ;
		P9OD5	==  P9ODCR.5 ;
		P9OD4	==  P9ODCR.4 ;
		P9OD3	==  P9ODCR.3 ;
		P9OD2	==  P9ODCR.2 ;
		P9OD1	==  P9ODCR.1 ;
		P9OD0	==  P9ODCR.0 ;
	;}
;
;  Bank6 RA (PORTA Open Drain Control Reister)
;
 PAODCR	==	0X0A:rpage 6
;
	;{
		PAOD7	==  PAODCR.7 ;
		PAOD6	==  PAODCR.6 ;
		PAOD5	==  PAODCR.5 ;
		PAOD4	==  PAODCR.4 ;
		PAOD3	==  PAODCR.3 ;
		PAOD2	==  PAODCR.2 ;
		PAOD1	==  PAODCR.1 ;
		PAOD0	==  PAODCR.0 ;
	;}
;
;  Bank6 RB (PORTB Open Drain Control Reister)
;
 PBODCR	==	0X0B:rpage 6
;
	;{
		PBOD7	==  PBODCR.7 ;
		PBOD6	==  PBODCR.6 ;
		PBOD5	==  PBODCR.5 ;
		PBOD4	==  PBODCR.4 ;
		PBOD3	==  PBODCR.3 ;
		PBOD2	==  PBODCR.2 ;
		PBOD1	==  PBODCR.1 ;
		PBOD0	==  PBODCR.0 ;
	;}
;
;  Bank6 RC (PORTC Open Drain Control Reister)
;
 PORTC	==	0X0C:rpage 6
;
	;{
				 ; Other 
		RC3	==  PORTC.3 ;
		RC2	==  PORTC.2 ;
		RC1	==  PORTC.1 ;
		RC0	==  PORTC.0 ;
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
;
;*************************************************
;
; title:clear EM78P510 Ram register macro program
;
;*************************************************
;
 M510CLRRAMBANK  MACRO
; 
	MOV	A,@0XD0
	MOV	RSR,A	
$_CLRLOOP:	
	CLR	R0
	INC	RSR
	MOV	A,RSR
	AND	A,@0X3F
	JBS	Z
	JMP	$_CLRLOOP
	INC	BSR
	BS	RSR,5
	MOV	A,@0X07
	AND	BSR,A
	BS	RSR,6
	JBS	Z
	JMP	$_CLRLOOP 
; 
        ENDM   