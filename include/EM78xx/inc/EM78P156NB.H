;******************************************************;
;  Title:       EM78P156NB include file                ;
;  Description: The Definition of EM78P156EL Registers ;
;  Company:     ELAN MICROELECTRONICS (SZ) LTD.        ;
;  Date:	2010/04/16
;******************************************************;
EM78P156NB.H    EQU    EM78P156NB.H


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
 R0     ==    0x00:rpage 0
 IAR    ==    0x00:rpage 0
;
;
; R1/TCC: Time Clock/Counter
;
 R1     ==    0x01:rpage 0
 TCC    ==    0x01:rpage 0
;
; R2/PC: Program Counter & Stack
;
 R2    ==    0x02:rpage 0
 PC    ==    0x02:rpage 0
;
; R3/PSR: Status Register
;
 R3	==    	0x03:rpage 0
 STATUS	==	0X03:rpage 0
;
     ;{
         GP2      == STATUS.7          ;General Purpose read/write bits
         GP1      == STATUS.6
         GP0      == STATUS.5
         T        == STATUS.4          ;Time out bit
         P        == STATUS.3          ;Power down bit
         Z        == STATUS.2          ;Zero flag
         DC       == STATUS.1          ;Auxiliary carry flag
         C        == STATUS.0          ;Carry flag
     ;}
;
; R4/RSR: RAM Select Register
;
 R4     ==    0x04:rpage 0    ;
 RSR    ==    0x04:rpage 0    ;
                      ; Bits 7~6 are not usedSET TO 1 ALL THE TIME
                      ; Bits 5~0 are used to select registers(address: 00~06,0F~3F)in the indirect addressing mode
;
; R5/PORT5: PORT 5 I/O Data
;
 R5       ==    0x05:rpage 0
 PORT5    ==    0x05:rpage 0
;
; R6/PORT6: PORT 6 I/O Data
;
 R6       ==    0x06:rpage 0
 PORT6    ==    0x06:rpage 0
;

;R7~RD:Reserved
;
RE       == 0X0E
LVDISR   == 0X0E
  _LVD   == LVDISR.7
  LVDIF  == LVDISR.6
  LVDWE  == LVDISR.0

; RF/ISR: Interrupt Status Register
;
 RF      ==    0x0F:rpage 0
 ISR     ==    0x0F:rpage 0
     ;{
                             ;"1" means interrupt request
                             ;"0" means no interrupt occurs
                             ; bit 7~3 not used
         EXIF    == ISR.2    ; External interrupt flag
         ICIF    == ISR.1    ; Port 6 input status change interrupt flag
         TCIF    == ISR.0    ; TCC interrupt flag
     ;}
; (R10 ~ R3F): General Purpose Register
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
; Special Purpose Registers Define                     ;
;======================================================;
;
; A: Accumulator
; It can't be addressed.
;
; CONT: Control Register
;
     ;{
                              ; bit 7 not used
         _INT   == 6   ; Interrupt enable flag
                         ; "0" : Masked by DISI or hardware interrupt
                         ; "1" : Enabled by ENI/RETI instructions
         TS      == 5   ; TCC signal source
                        ; "0" : Internal instruction cycle clock
                        ; "1" : Transition on TCC pin
         TE      == 4   ; TCC signal edge
                        ; "0" : Increment if the transition from low to high takes place on TCC pin
                        ; "1" : Increment if the transition from high to low takes place on TCC pin
         PAB     == 3   ; Prescaler assignment bit
                        ; "0" : Prescaler assign to TCC
                        ; "1" : Prescaler assign to WDT
         PSR2    == 2   ; TCC/WDT prescaler Select bit[2]
         PSR1    == 1   ; TCC/WDT prescaler Select bit[1]
         PSR0    == 0   ; TCC/WDT prescaler Select bit[0]
                              ; |------|------|------|----------|----------|
                              ; | PSR2 | PSR1 | PSR0 | TCC Rate | WDT Rate |
                              ; |------|------|------|----------|----------|
                              ; |  0   |  0   |  0   |   1:2    |   1:1    |
                              ; |  0   |  0   |  1   |   1:4    |   1:2    |
                              ; |  0   |  1   |  0   |   1:8    |   1:4    |
                              ; |  0   |  1   |  1   |   1:16   |   1:8    |
                              ; |  1   |  0   |  0   |   1:32   |   1:16   |
                              ; |  1   |  0   |  1   |   1:64   |   1:32   |
                              ; |  1   |  1   |  0   |   1:128  |   1:64   |
                              ; |  1   |  1   |  1   |   1:256  |   1:128  |
                              ; |------|------|------|----------|----------|
        ;}
;
; IOC5: PORT 5 I/O Port Control Register
;
 IOC5    ==    0x05:iopage 0
 P5CR    ==    0x05:iopage 0
;
; IOC6: PORT 6 I/O Port Control Register
;
 IOC6    ==    0x06:iopage 0
 P6CR    ==    0x06:iopage 0
;
; IOCA/PCR: Prescaler Counter Register
;
 IOCA    ==    0x0A:iopage 0
 PCR     ==    0x0A:iopage 0
;
; IOCB/PDCR: Pull-down Control Register
;
 IOCB    ==    0x0B:iopage 0
 PDCR    ==    0x0B:iopage 0
;
     ;{
                              ; "0" : Enable internal pull-down
                              ; "1" : Disable internal pull-dowm
                              ;
         PD7B    ==  7    ; Control bit is used to enable the pull-down of P63 pin
         PD6B    ==  6    ; Control bit is used to enable the pull-down of P62 pin
         PD5B    ==  5    ; Control bit is used to enable the pull-down of P61 pin
         PD4B    ==  4    ; Control bit is used to enable the pull-down of P60 pin
                          ; Bit 3 not used.
         PD2B    ==  2    ; Control bit is used to enable the pull-down of P52 pin
         PD1B    ==  1    ; Control bit is used to enable the pull-down of P51 pin
         PD0B    ==  0    ; Control bit is used to enable the pull-down of P50 pin
     ;}
;
; IOCC/ODCR:Open-drain Control Register
;
 IOCC     ==    0x0C:iopage 0
 ODCR     ==    0x0C:iopage 0
;
     ;{
                                ; Bit[n]= "0" , Disable P6[n] Open Drain Function. n=7~0
                                ; Bit[n]= "1" , Enable P6[n] Open Drain Function. n=7~0
                                ;
         OD7    ==    7    ; Control bit is used to enable the open-drain of P67 pin
         OD6    ==    6    ; Control bit is used to enable the open-drain of P66 pin
         OD5    ==    5    ; Control bit is used to enable the open-drain of P65 pin
         OD4    ==    4    ; Control bit is used to enable the open-drain of P64 pin
         OD3    ==    3    ; Control bit is used to enable the open-drain of P63 pin
         OD2    ==    2    ; Control bit is used to enable the open-drain of P62 pin
         OD1    ==    1    ; Control bit is used to enable the open-drain of P61 pin
         OD0    ==    0    ; Control bit is used to enable the open-drain of P60 pin
     ;}
;
; IOCD/PHCR: Pull-high Control Register
;
 IOCD    ==    0x0D:iopage 0
 PHCR    ==    0x0D:iopage 0
;
     ;{
                                ; "0" : Enable internal pull-high
                                ; "1" : Disable internal pull-high
         PH7B    ==    7    ; Control bit is used to enable the pull-high of P67 pin
         PH6B    ==    6    ; Control bit is used to enable the pull-high of P66 pin
         PH5B    ==    5    ; Control bit is used to enable the pull-high of P65 pin
         PH4B    ==    4    ; Control bit is used to enable the pull-high of P64 pin
         PH3B    ==    3    ; Control bit is used to enable the pull-high of P63 pin
         PH2B    ==    2    ; Control bit is used to enable the pull-high of P62 pin
         PH1B    ==    1    ; Control bit is used to enable the pull-high of P61 pin
         PH0B    ==    0    ; Control bit is used to enable the pull-high of P60 pin
     ;}
;
;
; IOCE/WDTCR: WDT Control Register
;
 IOCE      ==    0x0E:iopage 0
 WDTCR     ==    0x0E:iopage 0
;
     ;{
         WDTE   ==    7  ; Control bit is used to enable Watchdog timer
                          ; "0" : Disable WDT
                          ; "1" : Enable WDT
         EIS    ==    6  ; Control bit is used to difine the function of P60(/INT)pin
                          ; "0" : P60,biderectional I/O pin
                          ; "1" : /INT,external interrupt pin
                          ; Bit 5 not used
     ;}
;
; IOCF/IMR: Interrupt Mask Register
;
 IOCF    ==    0x0F:iopage 0
 IMR     ==    0x0F:iopage 0
;
     ;{
                               ; Bits 7~3 not used
         EXIE   ==    2    ; External interrupt pin enable bit
                           ; "0" : Disable
                           ; "1" : Enable
         ICIE   ==    1    ; Port 6 input status change interrupt enable bit
                           ; "0" : Disable
                           ; "1" : Enable
         TCIE   ==    0    ; TCC overflow interrupt enable bit
                               ; "0" : Disable
                               ; "1" : Enable
        ;}
;

;********************************************************;
;CLEAR EM78P156NB GENERAL REGISTER MACRO PROGRAM           ;
; Common register(16byte) + RAM(32byte)=48byte      ;
;********************************************************;
ClrRamBank  MACRO
	MOV     A,@0X10
	MOV     0X04,A
	NOP
	CLR     0x00
	INC     0X04
	JBS     0X04,6
	JMP     $-3
	CLR     0X04
	ENDM