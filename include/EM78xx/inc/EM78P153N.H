;******************************************************;
;  Title:       EM78P153N include file                 ;
;  Description: The Definition of EM78P153S Registers  ;
;  Company:     ELAN MICROELECTRONICS (SZ) LTD.        ;
;  Date:	2010/04/06			       ;			   ;
;******************************************************;
EM78P153N.H    EQU    EM78P153N.H


;======================================================;
; Operational Registers Define   R PAGE                ;
; Registers R0~R2F(Bank 0)                                   ;
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
R3        == 0X03:rpage 0
STATUS    == 0X03:rpage 0
        ;{
           RST      == STATUS.7          ; Bit for reset type
                                	      ; Set to 1 if wake-up from sleep mode on pin change
                              		      ; Set to 0 if wake-up from other reset types
           GP1      == STATUS.6		 ; General purpose read/write bits
           GP0      == STATUS.5
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
	; Bits 5~0 are used to select registers(address: 00~06,0F~2F)in the indirect addressing mode
        ; Bits 7~6 are general-purpose read/write bits
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
;R7~RD:Reserved
;
RE       == 0X0E
LVDISR   == 0X0E
  _LVD   == LVDISR.7
  LVDIF  == LVDISR.6
  LVDWE  == LVDISR.0
  ;
;RF/ISR:Interrupt status register
RF       == 0X0F:rpage 0
ISR      == 0X0F:rpage 0
      ;{
      	 			    ;Bits 7 ~ 3 Not used.
      	 			    ;"1" means interrupt request
      	 			    ;"0" means no interrupt occurs.
      	 EXIF   == ISR.2           ;External interrupt flag
      	 ICIF   == ISR.1           ;Port6 input status change interrupt flag
      	 TCIF   == ISR.0           ;TCC overflow interrupt flag
      ;}
;

;======================================================;
; Operational Registers Define   R PAGE                ;
; Registers R0~R2F(Bank 1)                                    ;
;======================================================;
TBHP          EQU  0X05
TBLP          EQU  0X06

LVDIMR        EQU  0X0E
  LVDIE       ==   LVDIMR.7
  LVDEN       ==   LVDIMR.6
  LVD1        ==   LVDIMR.5
  LVD0        ==   LVDIMR.4
  ;...              ...
  EXWE        ==   LVDIMR.0

SYSCTRL       EQU  0X0F
  TIMERSC     ==   SYSCTRL.6
  CPUS        ==   SYSCTRL.5
  IDLE        ==   SYSCTRL.4
  RCM1        ==   SYSCTRL.1
  RCM0        ==   SYSCTRL.0

;======================================================;
; Operational Registers Define   IOPAGE                ;
; Registers R0~RF                                      ;
;======================================================;
;
; A: Accumulator
; It can't be addressed.
;
; CONT: Control Register
;
     ;{
         		      ; BIT7 not used
         INTE    == 6    ; Interrupt enable flag
                           ; "0" : Masked by DISI or hardware interrupt
                           ; "1" : Enabled by ENI/RETI instructions
         TS      == 5    ; TCC signal source
                           ; "0" : Internal instruction cycle clock,P62 is a bi-directional I/O pin
                           ; "1" : Transition on TCC pin
         TE      == 4    ; TCC signal edge
                           ; "0" : Increment if the transition from low to high takes place on TCC pin
                           ; "1" : Increment if the transition from high to low takes place on TCC pin
         PAB     == 3    ;escaler assignment bit
                           ; "1" : TCC
                           ; "0" : WDT
         PSR2    == 2    ;
         PSR1    == 1    ;
         PSR0    == 0    ; (PSR0~PSR2): TCC/WDT prescaler Select bits
                                ; |------|------|------|----------|----------|
                                ; | PSR2 | PSR1 | PSR0 | TCC Rate | WDT Rate |
                                ; |------|------|------|----------|----------|
                                ; |   0  |   0  |   0  |   1:2    |   1:1    |
                                ; |   0  |   0  |   1  |   1:4    |   1:2    |
                                ; |   0  |   1  |   0  |   1:8    |   1:4    |
                                ; |   0  |   1  |   1  |   1:16   |   1:8    |
                                ; |   1  |   0  |   0  |   1:32   |   1:16   |
                                ; |   1  |   0  |   1  |   1:64   |   1:32   |
                                ; |   1  |   1  |   0  |   1:128  |   1:64   |
                                ; |   1  |   1  |   1  |   1:256  |   1:128  |
                                ; | -----|------|------|----------|----------|
     ;}
;
; PORT 5 I/O Port Control Register
;
 IOC5    ==    0x05:iopage 0    ;
 P5CR    ==    0x05:iopage 0    ;
;
; PORT 6 I/O Port Control Register
;
 IOC6    ==    0x06:iopage 0    ;
 P6CR    ==    0x06:iopage 0    ;
;
; IOCB/PDCR: Port 5 and P6 Pull-down Control Register
;
 IOCB    ==    0x0B:iopage 0    ;
 PDCR    ==    0x0B:iopage 0    ;
;
     ;{                       ; "0": Enable internal pull-down
                              ; "1": Disable internal pull-dowm
                              ; Bit 7 not used
         PD6B    == 6    ; Control bit is used to enable the pull-down of P62 pin
         PD5B    == 5    ; Control bit is used to enable the pull-down of P61 pin
         PD4B    == 4    ; Control bit is used to enable the pull-down of P60 pin
                         ; Bit 3 not used
         PD2B    == 2    ; Control bit is used to enable the pull-down of P52 pin
         PD1B    == 1    ; Control bit is used to enable the pull-down of P51 pin
         PD0B    == 0    ; Control bit is used to enable the pull-down of P50 pin
     ;}
;
; IOCC/ODCR:  Open-drain Control Register
;
 IOCC    ==    0x0C:iopage 0
 ODCR    ==    0x0C:iopage 0
;
     ;{                       ; "0": Disable internal open-drain
                              ; "1": Enable internal open-drain
                              ;
        OD7    ==  7    ; Control bit is used to enable the open-drain of P67 pin
        OD6    ==  6    ; Control bit is used to enable the open-drain of P66 pin
        OD5    ==  5    ; Control bit is used to enable the open-drain of P65 pin
        OD4    ==  4    ; Control bit is used to enable the open-drain of P64 pin
                        ; Bit 3 not used
        OD2    ==  2    ; Control bit is used to enable the open-drain of P62 pin
        OD1    ==  1    ; Control bit is used to enable the open-drain of P61 pin
        OD0    ==  0    ; Control bit is used to enable the open-drain of P60 pin
     ;}
;
;IOCD/PHCR:Pull-high Control Register
;
;
 IOCD    ==    0x0D:iopage 0
 PHCR	 ==    0X0D:iopage 0
     ;{                       ; "0": Enable internal  pull-HIGH
                              ; "1": Disable internal pull-HIGH
         PH7B	 == 7    ; Control bit is used to enable the pull-HIGH of P67 pin
         PH6B    == 6    ; Control bit is used to enable the pull-HIGH of P66 pin
         PH5B    == 5    ; Control bit is used to enable the pull-HIGH of P65 pin
         PH4B    == 4    ; Control bit is used to enable the pull-HIGH of P64 pin
                         ; Bit 3 not used
         PH2B    == 2    ; Control bit is used to enable the pull-HIGH of P62 pin
         PH1B    == 1    ; Control bit is used to enable the pull-HIGH of P61 pin
         PH0B    == 0    ; Control bit is used to enable the pull-HIGH of P60 pin
     ;}
;
; IOCE/WDTCR: WDT Control Register
;
 IOCE     ==    0x0E:iopage 0
 WDTCR    ==    0x0E:iopage 0
;
     ;{
         WDTE   ==  7    ; Control bit is used to enable Watchdog timer
                         ; "0" : Disable WDT
                         ; "1" : Enable WDT
         EIS    ==  6    ; Control bit is used to difine the function of P60(/INT)pin
                               ; "0" : P60,biderectional I/O pin
                               ; "1" : /INT,external interrupt pin
                               ;
                               ; Bits 5~0 not used
        ;}
;
; IOCF/IMR: Interrupt Mask Register
;
 IOCF    ==    0x0F:iopage 0
 IMR     ==    0x0F:iopage 0
;
     ;{
                               ; Bits 7~3 not used
                               ;
         EXIE    ==  2     ; External interrupt enable bit (P60)
                           ; "0" : Disable
                           ; "1" : Enable
         ICIE    ==  1     ; Port6 input status change interrupt enable bit
                           ; "0" : Disable
                           ; "1" : Enable
         TCIE    ==  0     ; TCC overflow interrupt enable bit
                               ; "0" : Disable
                               ; "1" : Enable
     ;}
;
;********************************************************;
;Clear EM78P153N General Register Macro Program           ;
; Common register(16byte) + RAM(16byte)=32byte         ;
;********************************************************;
ClrRamBank  MACRO
	MOV     A,@0X10
	MOV     0X04,A
	
	CLR     0x00
	INC     0X04
	JBC     0X04,5
	JBS     0X04,1
	JMP     $-4
	CLR     0X04
	ENDM