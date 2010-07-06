;******************************************************;
;  Tilte:       EM78f652 include file                 ;
;  Description: The Definition of EM78f652 Registers   ;
;  Company:     ELAN MICROELECTRONICS (SZ) LTD.        ;
;  Date:	2009/1/5
;******************************************************;
;
;======================================================;
; Operational Registers Define   BANK0                 ;
; Registers R0~R3F                                     ;
;======================================================;
;
; R0/IAR: Indirect Address Register
;
R0        == 0X00:rpage 0
IAR       == 0X00:rpage 0
; 
;R1/TCC: Time Clock/Counter
;
R1        == 0X01:rpage 0         
TCC       == 0X01:rpage 0 
;
; R2/PC: Program Counter & Stack
;
R2        == 0x02:rpage 0
PC        == 0x02:rpage 0
;
;R3/STATUS:Status Register
;
R3       == 0X03:rpage 0
STATUS   == 0X03:rpage 0
        ;{
           GP1      == STATUS.7          ;General Purpose read/write bits
           GP0      == STATUS.6
           PS0      == STATUS.5          ;Page select bit
           T        == STATUS.4          ;Time out bit
           P        == STATUS.3          ;Power down bit
           Z        == STATUS.2          ;Zero flag
           DC       == STATUS.1          ;Auxiliary carry flag
           C        == STATUS.0          ;Carry flag
         ;}
;
;R4/RSR:RAM Select Register
;
R4       == 0X04:rpage 0
RSR      == 0X04:rpage 0
;
;R5/PORT5:I/O Register
;
R5       == 0X05:rpage 0
PORT5    == 0X05:rpage 0
;
;R6/PORT6:I/O Register
;
R6       == 0X06:rpage 0
PORT6    == 0X06:rpage 0
;
;R7/PORT7:I/O Register
;
R7       == 0X07:rpage 0
PORT7    == 0X07:rpage 0
R8		 == 0X08:rpage 0
PORT8	 == 0X08:rpage 0
R9		 == 0X09:rpage 0
PORT9    == 0X09:rpage 0
;
;R8~R9:Reserved
;
;
;RA/WUCR:Wake up Control Register
;
WUCR	==	0X0A:rpage 0
RA		==	0X0A:rpage 0
       ;{
       	  ICWE     == WUCR.6        ;Port6 input status change wake up enable bit
       	                       ;0:disable,1;enable
       	  ADWE     == WUCR.5        ;ADC wakeup enable bit
       	                       ;0:disable ADC wake up
       	                       ;1:enable ADC wake up                     
       ;}
;
;RB/EPCR:EEPROM Control Register
;
EPCR	==	0X0B:rpage 0
RB		==	0X0B:rpage 0
      ;{
      	  RDCR      == EPCR.7        ;Read control register
      	                       ;0:Does not excute EEPROM read
      	                       ;1:Read EEPROM content
      	  WR      == EPCR.6         ;Write control register
      	                       ;0:Write cycle to the EEPROM is complete
      	                       ;1:Intiate a write cycle
      	  EEWE    == EPCR.5         ;EEPROM Write enable bit
      	                       ;0:Prohibit write to the EEPROM
      	                       ;1:Allows EEPROM write cycles
      	  EEDF    == EPCR.4         ;EEPROM Detective flag
      	                       ;0:Write cycle is completed
      	                       ;1:Write cycle is unfinished
      	  EEPC    == EPCR.3         ;EEPROM Power down control bit
      	                       ;0:Switch off the EEPROM
      	                       ;1:EEPROM is operating 
      ;}
;
;RC/EPADR:256 Bytes EEPROM Address
;
EEPA	== 	0X0C:rpage 0
RC		==	0X0C:rpage 0
       ;{
       	  EE_A7   == EEPA.7         ;256 bytes EEPROM address
       	  EE_A6   == EEPA.6
       	  EE_A5   == EEPA.5
       	  EE_A4   == EEPA.4
       	  EE_A3   == EEPA.3
       	  EE_A2   == EEPA.2
       	  EE_A1   == EEPA.1
       	  EE_A0   == EEPA.0
       ;}      	                                                                 
;
;RD/EPD:256 Bytes EEPROM data
RD	==	0X0D:rpage 0
;
EEPD	==	0X0D:rpage 0
      ;{
      	 EE_D7   == EEPD.7          ;256 Bytes EEPROM DATA
      	 EE_D6   == EEPD.6
      	 EE_D5   == EEPD.5
      	 EE_D4   == EEPD.4
      	 EE_D3   == EEPD.3
      	 EE_D2   == EEPD.2
      	 EE_D1   == EEPD.1
      	 EE_D0   == EEPD.0
      ;}
;
;RE/LVD:LVD Control register
RE		==	0X0E:rpage 0
;
LVDCR     == 	0X0E:rpage 0
      ;{
      	 LVDEN  == LVDCR.3           ;Low Voltage Dectector Enable Bit
      	                       ;0:LVD Disable 1:LVD Enable
      	 LVD   == LVDCR.2           ;Low Voltage Detector
      	                       ;0:low voltage is detected
      	                       ;1:low voltage is not detected or LVD function is disabled
      	 LVD1   == LVDCR.1           ;Low Voltage Dectect Level Select bit
      	 LVD0   == LVDCR.0           ;LVD1     LVD0     LVD Voltage Interrupt Level
      	                       ;  0       0                  2.1
      	                       ;  0       1                  3.1
      	                       ;  1       0                  3.8
      	                       ;  1       1                  4.3
      	                       ;-------------------------------------------------------- 
      ;}
;
;RF/ISR1:Interrupt status register
;
RF		==	0X0F:rpage 0
ISR    == 	0X0F:rpage 0
      ;{
      	 LVDIF  == ISR.7           ;Low voltage dectector interrupt flag
      	 ADIF   == ISR.6           ;Interrupt flag for analog to digital convertion
      	 SPIF   == ISR.5           ;SPI mode interrupt flag
      	 EXIF   == ISR.2           ;External interrupt flag
      	 ICIF   == ISR.1           ;Port6 input status change interrupt flag
      	 TCIF   == ISR.0           ;TCC overflow interrupt flag
      ;}

                     	                                                                       	                             	                                                                                                                  	                                                                                                                                                                     	                            	         	                            	                            	                                                                                                                         	                                                                                                             	                            
;*******************************************************
;Special Function Register
;*******************************************************
;CONT                           ;Control Register
      ;{
      	 INTE  == 6            ;Interrupt enable flag
      	                       ;0:masked by DISI or hardware interrupt
      	                       ;1:enabled by ENI/RETI instructions
      	 TS    == 5            ;TCC signal source
      	                       ;0:internal instruction cycle clock
      	                       ;1:transition on TCC pin
      	 TE    == 4            ;TCC signal edge                      
      	                       ;0:increment if a transition from low to high takes place on TCC pin
      	                       ;1:increment if a transition from high to low takes place on TCC pin 
      	 PSTE  == 3            ;Prescaler enable bit for TCC
      	                       ;0:prescaler disable bit,TCC rate is 1:1
      	                       ;1:prescaler enable bit,TCC rate is set as Bit2~Bit0                                                 	       	                       
      	 PST2  == 2            ;TCC prescaler bits
      	 PST1  == 1            ;PST2    PST1      PST0       TCC Rate
      	 PST0  == 0            ;  0       0         0           1:2
      	                       ;  0       0         1           1:4
      	                       ;  0       1         0           1:8
      	                       ;  0       1         1           1:16  
      	                       ;  1       0         0           1:32
      	                       ;  1       0         1           1:64
      	                       ;  1       1         0           1:128
      	                       ;  1       1         1           1:256 
      	                       ;-----------------------------------------------------------------
      ;}
;
;IOC5:PORT5 I/O Control register
;
IOC5    == 0X05:iopage 0
P5CR	== 0X05:iopage 0          	                              	                                                                                               	       	 
;
;IOC6:PORT6 I/O Control register
;
IOC6    == 0X06:iopage 0   
P6CR	== 0X06:iopage 0
;
;IOC7:PORT7 I/O Control register
;
IOC7    == 0X07:iopage 0 
P7CR	== 0X07:iopage 0
IOC8	== 0X08:iopage 0
P8CR	== 0X08:iopage 0
IOC9	== 0X09:iopage 0
P9CR	== 0X09:iopage 0
;
;IOC8~IOC9:Reserved 
;
;IOCA/WDTCR:WDT Control register
;
IOCA    == 0X0A:iopage 0
WDTCR   == 0X0A:iopage 0
       ;{
       	   WDTE  == 7           ;Control bit used to the enable Watchdog timer
       	                        ;0:disable WDT, 1:enable WDT
       	   EIS   == 6           ;Control bit used to define the function of p60 pin
       	                        ;0:P60 ,bidrectional I/O pin
       	                        ;1:/INT,external interrupt pin
       	   PSWE  == 3           ;Prescaler enable bit for WDT
       	                        ;0:prescaler disable bit,WDT rate is 1:1
       	                        ;1:prescaler enable bit, WDT rate is set as Bit2~Bit0
       	   PSW2  == 2           ;WDT Prescaler bits
       	   PSW1  == 1           ; PSW2    PSW1      PSW0     WDT Rate
       	   PSW0  == 0           ;  0       0         0           1:2
      	                        ;  0       0         1           1:4
      	                        ;  0       1         0           1:8
      	                        ;  0       1         1           1:16  
      	                        ;  1       0         0           1:32
      	                        ;  1       0         1           1:64
      	                        ;  1       1         0           1:128
      	                        ;  1       1         1           1:256 
      	                        ;---------------------------------------------------------
      ;}    
;
;IOCB:Pull down control register
;
IOCB    == 0X0B:iopage 0
PDCR   == 0X0B:iopage 0
      ;{
      	  _PD7  == 7            ;Control bit used to enable the of P63 pull down pin
      	                        ;0:enable internal pull down
      	                        ;1:disable internal pull down
      	  _PD6  == 6
      	  _PD5  == 5
      	  _PD4  == 4
      	  _PD3  == 3            ;Control bit used to enable the of P53 pull down pin
      	  _PD2  == 2
      	  _PD1  == 1
      	  _PD0  == 0 
      ;}
;
;IOCC :Open Drain control register  
;  
ODCR   == 0X0C:iopage 0  	                       
IOCC   == 0X0C:iopage 0                  ; 
      ;{
      	  ;OD3  == 3             ;Control bit used to enable the Open drain output of P63 pin
      	                        ;0:Disable open drain output
      	                        ;1:Enable open drain output
      	  ;OD2  == 2
      	  ;OD1  == 1
      	  ;OD0  == 0
      ;}
;
;IOCD:Pull High control register
;
IOCD   == 0X0D:iopage 0 
PHCR  == 0X0D:iopage 0                 
      ;{
      	 ;_PH3  == 3             ;Control bit used to enable the of P63 pull high pin
      	                        ;0:enable internal pull high
      	                        ;1:disable internal pull high
      	 ;_PH2  == 2
      	 ;_PH1  == 1
      	 ;_PH0  == 0
      ;}
;
;IOCE/IMR2:Interrupt mask register
;
IOCE    == 0X0E:iopage 0

;IOCF/IMR1:Interrupt mask registe
;
IOCF    == 0X0F:iopage 0
IMR    == 0X0F:iopage 0
     ;{
     	LVDIE  == 7             ;LVD Interrupt enable bit
     	                        ;0:disable LVD interrupt 
     	                        ;1:enable LVD interrupt
     	ADIE   == 6             ;ADIF Interrupt enable bit
     	SPIE   == 5             ;Interrupt enable bit                        
     	EXIE   == 2             ;External  Interrupt enable bit
     	ICIE   == 1             ;ICIF Interrupt enable bit
     	TCIE   == 0             ;TCC Interrupt enable bit
      ;}
 ; ===========================================                                      
;Clear the all ram macro                                                           
;-------------------------------------------;                                      
m651ClrRAMBank  MACRO      
	MOV   	A,@0X10
     	MOV   	RSR,A
$_CLRLOOP:
     	CLR   	R0    
     	INC   	RSR
     	JBC   	RSR,6
     	BS    	RSR,5
     	JBC   	RSR,7
     	BS    	RSR,5 
     	JBS   	Z
     	JMP   	$_CLRLOOP
	ENDM                                                                  	               	                       