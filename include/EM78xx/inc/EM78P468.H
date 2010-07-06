;******************************************************;
;  Title:       EM78P468N include file                 ;
;  Description: The Definition of EM78P468N Registers ;
;  Company:     ELAN MICROELECTRONICS (SZ) LTD.        ;
;  Date:	2008/04/22
;******************************************************;
EM78P468.H    EQU    EM78P468H

;======================================================;
; Operational Registers Define                         ;
;======================================================;
;
;======================================================;
; Register R0~RF                                       ;
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
; Status Register and ROM Page Select Register
;
 R3    ==    0X03:rpage 0
 STATUS	==	0x03:rpage 0
 SR	==	0x03:rpage 0
;
     ;{
         PS1     ==    STATUS.6    ; Page Select Bit[1]
         PS0     ==    STATUS.5    ; Page Select Bit[0]
                            ;
                            ; |-----|-----|-----------------------------|
                            ; | PS1 | PS0 | Program ROM Page and Address|
                            ; |-----|-----|-----------------------------|
                            ; |  0  |  0  |     Page 0 (0x000~0x3FF)    |
                            ; |  0  |  1  |     Page 1 (0x400~0x7FF)    |
                            ; |  1  |  0  |     Page 2 (0x800~0xBFF)    |
                            ; |  1  |  1  |     Page 3 (0xC00~0xFFF)    |
                            ; |-----|-----|-----------------------------|
                            ;
         T       ==    STATUS.4    ; Time-Out Bit
         P       ==    STATUS.3    ; Power Down Bit
         Z       ==    STATUS.2    ; Zero Flag
         DC      ==    STATUS.1    ; Auxiliary Carry Flag
         C       ==    STATUS.0    ; Carry Flag                            ;

;
; RAM Select Register (RSR)
;
 R4     ==    0X04:rpage 0
 RSR    ==    0X04:rpage 0
     ;{                         ; Bits 7~6 are determoned the R20~R3F which bank is active
                                ; Bits 5~0 are used to select registers(address: 00~3F)
                                ; in the indirect addressing mode
                                ;
         RBS1     ==    RSR.7    ; R20~R3F ram bank select bit
         RBS0     ==    RSR.6    ; it can using "bank" instruction to set these bits.
                             ;
         RSR5     ==    RSR.5    ;
         RSR4     ==    RSR.4    ;
         RSR3     ==    RSR.3    ;
         RSR2     ==    RSR.2    ;
         RSR1     ==    RSR.1    ;
         RSR0     ==    RSR.0    ;

     ;}
;
; Port 5 data and IOC Page Select Register
;
 R5       ==	0X05:rpage 0
 PORT5    ==    0X05:rpage 0
     ;{
         P57          ==    PORT5.7    ; I/O data of P5.7
         P56          ==    PORT5.6    ; I/O data of P5.6
         P55          ==    PORT5.5    ; I/O data of P5.5
         P54          ==    PORT5.4    ; I/O data of P5.4
                                       ; bits 3~1 not use
         IOCPAGE      ==    PORT5.0    ; IOC5~IOCF Page Select Bit.
                                       ; "0" : Page0 -> Select IOC50~IOCF0
                                       ; "1" : Page1 -> Select IOC61~IOCE1
     ;}
;
; Port 6 data Register
 R6       ==    0X06:rpage 0
 PORT6    ==    0X06:rpage 0
     ;{
         P67          ==    PORT6.7    ; I/O data of P6.7
         P66          ==    PORT6.6    ; I/O data of P6.6
         P65          ==    PORT6.5    ; I/O data of P6.5
         P64          ==    PORT6.4    ; I/O data of P6.4
         P63          ==    PORT6.3    ; I/O data of P6.3
         P62          ==    PORT6.2    ; I/O data of P6.2
         P61          ==    PORT6.1    ; I/O data of P6.1
         P60          ==    PORT6.0    ; I/O data of P6.0
     ;}
;
; Port 7 data Register
 R7       ==    0X07:rpage 0
 PORT7    ==    0X07:rpage 0
     ;{
         P77          ==    PORT7.7    ; I/O data of P7.7
         P76          ==    PORT7.6    ; I/O data of P7.6
         P75          ==    PORT7.5    ; I/O data of P7.5
         P74          ==    PORT7.4    ; I/O data of P7.4
         P73          ==    PORT7.3    ; I/O data of P7.3
         P72          ==    PORT7.2    ; I/O data of P7.2
         P71          ==    PORT7.1    ; I/O data of P7.1
         P70          ==    PORT7.0    ; I/O data of P7.0
     ;}
;
; Port 8 data Register
 R8       ==    0X08:rpage 0
 PORT8    ==    0X08:rpage 0
     ;{
         P87          ==    PORT8.7    ; I/O data of P8.7
         P86          ==    PORT8.6    ; I/O data of P8.6
         P85          ==    PORT8.5    ; I/O data of P8.5
         P84          ==    PORT8.4    ; I/O data of P8.4
         P83          ==    PORT8.3    ; I/O data of P8.3
         P82          ==    PORT8.2    ; I/O data of P8.2
         P81          ==    PORT8.1    ; I/O data of P8.1
         P80          ==    PORT8.0    ; I/O data of P8.0
     ;} 
;
; LCD Control Register
;
 R9       ==    0X09:rpage 0
 LCDCR    ==    0X09:rpage 0
;
     ;{
         LCDBS       ==   LCDCR.7    ; LCD Bias Select Bit."0":1/2 Bias,"1":1/3 Bias
         DS1         ==   LCDCR.6    ; LCD Duty Select Bit[1]
         DS0         ==   LCDCR.5    ; LCD Duty Select Bit[0]
                                     ;
                                     ; |-----|-----|----------|
                                     ; | DS1 | DS0 | LCD Duty |
                                     ; |-----|-----|----------|
                                     ; |  0  |  0  | 1/2 Duty |
                                     ; |  0  |  1  | 1/3 Duty |
                                     ; |  1  |  X  | 1/4 Duty |
                                     ; |-----|-----|----------|
                                     ; bit 5 not use
         LCDEN       ==   LCDCR.4    ; LCD Enable Bit."0":Disable,"1":Enable
         LCDTYPE     ==   LCDCR.2    ; LCD Drive Waveform Select Bit
                                     ; "0" : A Type Waveform,
                                     ; "1" : B Type Waveform
         LCDF1       ==   LCDCR.1    ; LCD Frame Frequency Control Bit[1]
         LCDF0       ==   LCDCR.0    ; LCD Frame Frequency Control Bit[0]
                                     ;
                                     ; |-----|-----|------------------------|----|
                                     ; |     |     |   LCD Frame Frequency  |    |
                                     ; |LCDF1|LCDF0|------------------------|Unit|
                                     ; |     |     |1/2 Duty|1/3Duty|1/4Duty|    |
                                     ; |-----|-----|--------|-------|-------|----|
                                     ; |  0  |  0  |  64.0  |  63.5 |  64.0 | Hz |
                                     ; |  0  |  1  |  58.5  |  58.0 |  58.5 | Hz |
                                     ; |  1  |  0  |  53.9  |  53.5 |  53.9 | Hz |
                                     ; |  1  |  1  |  70.6  |  70.0 |  70.6 | Hz |
                                     ; |-----|-----|--------|-------|-------|----|
                                     ;
     ;}
;
; LCD RAM Address
;
 RA          ==    0X0A:rpage 0
 LCD_ADDR    ==    0X0A:rpage 0
;
; LCD Data Buffer
;
 RB        ==    0X0B:rpage 0
 LCD_DB    ==    0X0B:rpage 0
;
; Counter/Timer Enable Register
;
 RC       ==    0X0C:rpage 0
 CNTER    ==    0X0C:rpage 0
;
     ;{
                                    ; bit 7~4 not use
         LPWTEN     ==   CNTER.3    ; LPWT Enable Bit
                                    ; "0" : Disable
                                    ; "1" : Enable
         HPWTEN     ==   CNTER.2    ; HPWT Enable Bit
                                    ; "0" : Disable
                                    ; "1" : Enable
         CNT2EN     ==   CNTER.1    ; Counter 2 Enable Bit
                                    ; "0" : Disable
                                    ; "1" : Enable
         CNT1EN     ==   CNTER.0    ; Counter 1 Enable Bit
                                    ; "0" : Disable
                                    ; "1" : Enable
                                    ;
      ;}
;
; System Clock, Booster Frequency and PLL Frequency Control Register
;
 RD       ==    0X0D:rpage 0
 SBPCR    ==    0X0D:rpage 0
;
     ;{
                                  ; bit 7 not use
         CLK2     ==   SBPCR.6    ; Main Clock Select Bit[2] for PLL Mode
         CLK1     ==   SBPCR.5    ; Main Clock Select Bit[1] for PLL Mode
         CLK0     ==   SBPCR.4    ; Main Clock Select Bit[0] for PLL Mode
                                  ;
                                  ; |-----|-----|-----|----------|
                                  ; |CLK2 |CLK1 |CLK0 | PLL FREQ |
                                  ; |-----|-----|-----|----------|
                                  ; |  0  |  0  |  0  | 4.260 MHz|
                                  ; |  0  |  0  |  1  | 2.130 MHz|
                                  ; |  0  |  1  |  0  | 1.065 MHz|
                                  ; |  0  |  1  |  1  | 532.5 KHz|
                                  ; |  1  |  X  |  X  | 8.000 MHz|
                                  ; |-----|-----|-----|----------|
			          ;
         IDLE     ==   SBPCR.3    ; IDLE Mode Select Bit
                                  ; "0"+SLEP -> Sleep Mode
                                  ; "1"+SLEP -> IDLE Mode
         BF1      ==   SBPCR.2    ; LCD Booster Frequency Select Bit[1]
         BF0      ==   SBPCR.1    ; LCD Booster Frequency Select Bit[0]
                                  ;
                                  ; |-----|-----|------------|
                                  ; | BF1 | BF0 |BOOSTER FREQ|
                                  ; |-----|-----|------------|
                                  ; |  0  |  0  |    FS      |
                                  ; |  0  |  1  |    FS/4    |
                                  ; |  1  |  0  |    FS/8    |
                                  ; |  1  |  1  |    FS/16   |
                                  ; |-----|-----|------------|
                                  ;
         CPUS     ==    SBPCR.0   ; CPU oscillator Source Select Bit.
                                  ; "0" : run on Sub Oscillator
                                  ; "1" : run on Main Oscillator
                                  ;
                                  ; bit 7 not use
     ;}
;
; IR (Infrared) Control and PORT5 External Function Pins Set Register
;
 RE      ==    0X0E:rpage 0
 IRCR    ==    0X0E:rpage 0
;
     ;{
         IRE        ==    IRCR.7    ; IR/PWM Enable Bit.
                                    ; "0" : Disable
                                    ; "1" : Enable
         HF         ==    IRCR.6    ; IR/PWM Select Bit
                                    ; "0" : for PWM
                                    ; "1" : for IR
         LGP        ==    IRCR.5    ; Long Pulse, Only Output Low Pulse.
                                    ; "0" : Normal
                                    ; "1" : Only Output LPWT (Include Carrier Freq.)
                                    ; bit 4 not use
         IROUTE     ==    IRCR.3    ; Control Bit is used to define the function of P5.7(IROUT) Pin
                                    ; "0" : P5.7,bi-directional I/O Pin.
                                    ; "1" : IROUT Pin. The bit7 of IOC50 must be set to "0"
         TCCE       ==    IRCR.2    ; Control Bit is used to define the function of P5.6(TCC) Pin
                                    ; "0" : P5.6,bi-directional I/O Pin.
                                    ; "1" : External input pin of TCC. The bit6 of IOC50 must be set to "1"
         EINT1      ==    IRCR.1    ; Control Bit is used to define the function of P5.5(INT1) Pin
                                    ; "0" : P5.5,bi-directional I/O Pin.
                                    ; "1" : INT1,External Interrupt Pin. The bit5 of IOC50 must be set to "1"
         EINT0      ==    IRCR.0    ; Control Bit is used to define the function of P5.4(INT0) Pin
                                    ; "0" : P5.4,bi-directional I/O Pin.
                                    ; "1" : INTO,External Interrupt Pin. The bit4 of IOC50 must be set to "1"
     ;
;
; Interrupt Status Register
;
 RF     ==    0X0F:rpage 0
 ISR    ==    0X0F:rpage 0
;
     ;{
                                  ; Totally "0" : Interrupt not Occur
                                  ;         "1" : Interrupt Occur
                                  ;
         ICIF      ==    ISR.7    ; Pin Change Wake Up Interrupt Flag
         LPWTF     ==    ISR.6    ; Low Pulse Width Timer Interrupt Flag
         HPWTF     ==    ISR.5    ; High Pulse Width Timer Interrupt Flag
         CNT2F     ==    ISR.4    ; Counter 2 Interrupt Flag
         CNT1F     ==    ISR.3    ; Counter 1 Interrupt Flag
         INT1F     ==    ISR.2    ; INT1 Interrupt Flag
         INT0F     ==    ISR.1    ; INT0 Interrupt Flag
         TCIF      ==    ISR.0    ; TCC Interrupt Flag
                                  ;
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
;==============================================================;
; Register IOC50 ~ IOCF0                                       ;
; Must be Set Bit0 of R5 to "0" and use IOW and IOR Instruction;
;==============================================================;
;
;PORT 5 I/O Control and PORT7,8 for LCD Segment Control Register
;
 IOC50    ==    0X05:iopage 0
 P5CR     ==    0x05:iopage 0
;
     ;{                           ; Bit[n]="1",Set P5.[n] as Input Pin, n=7~4
                                  ; Bit[n]="0",Set P5[n] as Output Pin, n=7~4
         IOC57    ==    7    ;
         IOC56    ==    6    ;
         IOC55    ==    5    ;
         IOC54    ==    4    ;
                             ; "0" : for General I/O
                             ; "1" : for LCD Segment
         P8HS     ==    3    ; Switch P8.4~7 to General I/O or to LCD Segment Pin(SEG28~31).
         P8LS     ==    2    ; Switch P8.0~3 to General I/O or to LCD Segment Pin(SEG24~27).
         P7HS     ==    1    ; Switch P7.4~7 to General I/O or to LCD Segment Pin(SEG20~23).
         P7LS     ==   0    ; Switch P8.0~3 to General I/O or to LCD Segment Pin(SEG16~19).
     ;}
;
; Port 6 I/O Control Register
;
 IOC60    ==    0X06:iopage 0
 P6CR     ==    0x06:iopage 0
;
; Port 7 I/O Control Register
;
 IOC70    ==    0X07:iopage 0
 P7CR     ==    0x07:iopage 0
;
; Port 8 I/O Control Register
;
 IOC80    ==    0X08:iopage 0
 P8CR     ==    0x08:iopage 0
;
;IOC90/RAM_ADDR:128 Byte RAM Address
;
 IOC90       ==    0X09:iopage 0
 RAM_ADDR    ==    0X09:iopage 0
;
;IOCA0/RAM_DB :128 Byte RAM Data Buffer
;
 IOCA0     ==    0X0A:iopage 0
 RAM_DB    ==    0X0A:iopage 0
;
;IOCB0/CNT1PR:Counter 1 Preset Register
;
 IOCB0     ==    0X0B:iopage 0
 CNT1PR    ==    0X0B:iopage 0
;
;IOCC0/CNT2PR:Counter 2 Preset Register
;
 IOCC0     ==    0X0C:iopage 0
 CNT2PR    ==    0X0C:iopage 0
;
;IOCD0/HPWTPR:High Pulse Width Timer Preset Register
;
 IOCD0     ==    0X0D:iopage 0
 HPWTPR    ==    0X0D:iopage 0
;
; IOCE0/LPWTPR:Low Pulse Width Timer Preset Register
;
 IOCE0     ==    0X0E:iopage 0
 LPWTPR    ==    0X0E:iopage 0
;
; IOCF0/IMR:Interrupt Mask Register
;
 IOCF0    ==    0X0F:iopage 0
 IMR      ==    0X0F:iopage 0
;
     ;{                          ; "0" : Disable Interrupt.
                                 ; "1" : Enable Interrupt.
         ICIE     ==    7    ; Pin Change Wake Up Interrupt Enable Bit
         LPWTE    ==    6    ; Low Pulse Width Timer Interrupt Enable Bit
         HPWTE    ==    5    ; High Pulse Width Timer Interrupt Enable Bit
         CNT2E    ==    4    ; Counter 2 Interrupt Enable Bit
         CNT1E    ==    3    ; Counter 2 Interrupt Enable Bit
         INT1E    ==    2    ; INT1 Interrupt Enable Bit
         INT0E    ==    1    ; INT0 Interrupt Enable Bit
         TCIE     ==    0    ; TCC Interrupt Enable Bit
     ;}
;
;==============================================================;
; Register IOC61~IOCF1                                         ;
; Must be Set Bit0 of R5 to "1" and use IOW and IOR Instruction;
;==============================================================;
;
; Wake up control Register and IROUT Sink Current Control
;
 IOC61    ==    0X06:iopage 1
 WUCR     ==    0X06:iopage 1
;
     ;{
         IROCS     ==    7    ; IROUT/P5.7 Sink  current Set Bit.
                              ; "0" : Normal
                              ; "1" : Double Current
                              ; bit 6~4 not use
         WUE8HB    ==    3    ; P8.4~7 Pin Change Wake up Function.
                              ; "0" : Enable
                              ; "1" : Disable
         WUE8LB    ==    2    ; P8.0~3 Pin Change Wake up Function.
                              ; "0" : Enable
                              ; "1" : Disable
         WUE6HB    ==    1    ; P6.4~7 Pin Change Wake up Function.
                              ; "0" : Enable
                              ; "1" : Disable
         WUE6LB    ==    0    ; P6.0~3 Pin Change Wake up Function.
                                   ; "0" : Enable
                                   ; "1" : Disable
     ;}
;
; TCC Control Register and INT0 Edge Set
;
 IOC71    ==    0X07:iopage 1
 TCCCR    ==    0X07:iopage 1
;
     ;{
        INT_EDGE==    7    ; INT0 Edge Select Bit.
                           ; "0" : Rising Edge
                           ; "1" : Falling Edge
        INTE    ==    6    ; INT Enable Flag
        TS      ==    5    ; TCC Signal Source.
                           ; "0" : Internal Instruction Cycle Clock
                           ; "1" : Transition on TCC Pin.
        TE      ==    4    ; TCC Signal Edge Select bit.
                           ; "0" : Rising Edge
                           ; "1" : Falling Edge
        PSRE    ==    3    ; Prescaler Register Enable Bit.
                           ; "0" : TCC Rate 1:1,
                           ; "1" : Depend on Table
        TCCP2   ==    2    ; TCC Prescaler Select Bit[2]
        TCCP1   ==    1    ; TCC Prescaler Select Bit[1]
        TCCP0   ==    0    ; TCC Prescaler Select Bit[0]
                                 ;
                                 ; |----|-----|-----|-----|----------|
                                 ; |PSRE|TCCP2|TCCP1|TCCP0| TCC rate |
                                 ; |----|-----|-----|-----|----------|
                                 ; |  0 |  x  |  x  |  x  |   1:1    |
                                 ; |  1 |  0  |  0  |  0  |   1:2    |
                                 ; |  1 |  0  |  0  |  1  |   1:4    |
                                 ; |  1 |  0  |  1  |  0  |   1:8    |
                                 ; |  1 |  0  |  1  |  1  |   1:16   |
                                 ; |  1 |  1  |  0  |  0  |   1:32   |
                                 ; |  1 |  1  |  0  |  1  |   1:64   |
                                 ; |  1 |  1  |  1  |  0  |   1:128  |
                                 ; |  1 |  1  |  1  |  1  |   1:256  |
                                 ; |----|-----|-----|-----|----------|
     ;}
;
; WDT(Watch Dog Timer) Control Register
;
 IOC81    ==    0x08:iopage 1
 WDTCR    ==    0x08:iopage 1
;
     ;{
                                   ; bit 7~4 not use
         WDTE     ==   3    ; WDT Enable Bit."0":Disable,"1":Enable
         WDTP2    ==   2    ; WDT Prescaler Select Bit[2]
         WDTP1    ==   1    ; WDT Prescaler Select Bit[1]
         WDTP0    ==   0    ; WDT Prescaler Select Bit[0]
                                   ;
                                   ; |-----|-----|-----|----------|
                                   ; |WDTP2|WDTP1|WDTP0| WDT rate |
                                   ; |-----|-----|-----|----------|
                                   ; |  0  |  0  |  0  |   1:1    |
                                   ; |  0  |  0  |  1  |   1:2    |
                                   ; |  0  |  1  |  0  |   1:4    |
                                   ; |  0  |  1  |  1  |   1:8    |
                                   ; |  1  |  0  |  0  |   1:16   |
                                   ; |  1  |  0  |  1  |   1:32   |
                                   ; |  1  |  1  |  0  |   1:64   |
                                   ; |  1  |  1  |  1  |   1:128  |
                                   ; |-----|-----|-----|----------|
     ;}
;
; IOC91/CNT12CR:Counter1 and Counter2 Control Register
;
 IOC91      ==    0x09:iopage 1
 CNT12CR    ==    0x09:iopage 1
;
     ;{
         CNT2S     ==    7    ; Counter 2 Clock Source select bit.
                              ; "0" : Fs (sub oscillator)
                              ; "1" : Fm (main oscillator)
         CNT2P2    ==    6    ; Counter 2 Prescaler Select Bit[2]
         CNT2P1    ==    5    ; Counter 2 Prescaler Select Bit[1]
         CNT2P0    ==    4    ; Counter 2 Prescaler Select Bit[0]
                                      ;
                                      ; |------|------|------|----------------|
                                      ; |CNT2P2|CNT2P1|CNT2P0| Counter2 Scaler|
                                      ; |------|------|------|----------------|
                                      ; |   0  |   0  |   0  |      1:2       |
                                      ; |   0  |   0  |   1  |      1:4       |
                                      ; |   0  |   1  |   0  |      1:8       |
                                      ; |   0  |   1  |   1  |      1:16      |
                                      ; |   1  |   0  |   0  |      1:32      |
                                      ; |   1  |   0  |   1  |      1:64      |
                                      ; |   1  |   1  |   0  |      1:128     |
                                      ; |   1  |   1  |   1  |      1:256     |
                                      ; |------|------|------|----------------|
                                      ;
         CNT1S     ==    3    ; Counter 1 Clock Source select bit.
                              ; "0" : Fs (sub oscillator)
                              ; "1" : Fm (main oscillator)
         CNT1P2    ==    2    ; Counter 1 Prescaler Select Bit[2]
         CNT1P1    ==    1    ; Counter 1 Prescaler Select Bit[1]
         CNT1P0    ==    0    ; Counter 1 Prescaler Select Bit[0]
                                      ;
                                      ; |------|------|------|----------------|
                                      ; |CNT1P2|CNT1P1|CNT1P0| Counter1 Scaler|
                                      ; |------|------|------|----------------|
                                      ; |   0  |   0  |   0  |       1:2      |
                                      ; |   0  |   0  |   1  |       1:4      |
                                      ; |   0  |   1  |   0  |       1:8      |
                                      ; |   0  |   1  |   1  |       1:16     |
                                      ; |   1  |   0  |   0  |       1:32     |
                                      ; |   1  |   0  |   1  |       1:64     |
                                      ; |   1  |   1  |   0  |       1:128    |
                                      ; |   1  |   1  |   1  |       1:256    |
                                      ; |------|------|------|----------------|
     ;}
;
; High/Low Pulse Width Timer Control Register
;
 IOCA1      ==    0x0A:iopage 1
 HLPWTCR    ==    0x0A:iopage 1
;
     ;{
         LPWTS     ==    7    ; Low Pulse Width Timer Clock Source select.
                              ; "0" : Fs (sub oscillator)
                              ; "1" : Fm (main oscillator)
         LPWTP2    ==    6    ; Low Pulse Width Timer Prescaler Select Bit[2]
         LPWTP1    ==    5    ; Low Pulse Width Timer Prescaler Select Bit[1]
         LPWTP0    ==    4    ; Low Pulse Width Timer Prescaler Select Bit[0]
                                      ;
                                      ; |------|------|------|----------------|
                                      ; |LPWTP2|LPWTP1|LPWTP0|   LPWT Scaler  |
                                      ; |------|------|------|----------------|
                                      ; |   0  |   0  |   0  |       1:2      |
                                      ; |   0  |   0  |   1  |       1:4      |
                                      ; |   0  |   1  |   0  |       1:8      |
                                      ; |   0  |   1  |   1  |       1:16     |
                                      ; |   1  |   0  |   0  |       1:32     |
                                      ; |   1  |   0  |   1  |       1:64     |
                                      ; |   1  |   1  |   0  |       1:128    |
                                      ; |   1  |   1  |   1  |       1:256    |
                                      ; |------|------|------|----------------|
                                      ;
         HPWTS     ==    3    ; High Pulse Width Timer Clock Source select.
                              ; "0" : Fs (sub oscillator)
                              ; "1" : Fm (main oscillator)
         HPWTP2    ==    2    ; High Pulse Width Timer Prescaler Select Bit[2]
         HPWTP1    ==    1    ; High Pulse Width Timer Prescaler Select Bit[1]
         HPWTP0    ==    0    ; High Pulse Width Timer Prescaler Select Bit[0]
                                      ;
                                      ; |------|------|------|----------------|
                                      ; |HPWTP2|HPWTP1|HPWTP0|   HPWT Scaler  |
                                      ; |------|------|------|----------------|
                                      ; |   0  |   0  |   0  |       1:2      |
                                      ; |   0  |   0  |   1  |       1:4      |
                                      ; |   0  |   1  |   0  |       1:8      |
                                      ; |   0  |   1  |   1  |       1:16     |
                                      ; |   1  |   0  |   0  |       1:32     |
                                      ; |   1  |   0  |   1  |       1:64     |
                                      ; |   1  |   1  |   0  |       1:128    |
                                      ; |   1  |   1  |   1  |       1:256    |
                                      ; |------|------|------|----------------|
     ;}
;
; IOCB1/P6PH:Port 6 Pull High Control Register
;
 IOCB1    ==    0X0B:iopage 1
 P6PH     ==    0X0B:iopage 1
;
     ;{                          ; Bit[n]="0", Disable P6.[n] Pull High Function.n=7~0
                                 ; Bit[n]="1", Enable P6.[n] Pull High Function.n=7~0
         PH67    ==    7    ;The enable bits of Port 6 pull high function
         PH66    ==    6    ;
         PH65    ==    5    ;
         PH64    ==    4    ;
         PH63    ==    3    ;
         PH62    ==    2    ;
         PH61    ==    1    ;
         PH60    ==    0    ;
     ;}
;
; Port 6 Open Drain Control Register
;
 IOCC1    ==    0X0C:iopage 1
 P6OD     ==    0X0C:iopage 1
;
     ;{                         ; Bit[n]="0", Disable P6.[n] Open Drain Function. n=7~0
                                ; Bit[n]="1", Enable P6.[n] Open Drain Function. n=7~0
         OD67    ==    7    ;
         OD66    ==    6    ;
         OD65    ==    5    ;
         OD64    ==    4    ;
         OD63    ==    3    ;
         OD62    ==    2    ;
         OD61    ==    1    ;
         OD60    ==    0    ;
     ;}
;
; Port 8 Pull High Control Register
;
 IOCD1    ==    0X0D:iopage 1
 P8PH     ==    0X0D:iopage 1
;
     ;{                         ; Bit[n]="0", Disable P8.[n] Pull High Function. n=7~0
                                ; Bit[n]="1", Enable P8.[n] Pull High Function. n=7~0
         PH87    ==    7    ;
         PH86    ==    6    ;
         PH85    ==    5    ;
         PH84    ==    4    ;
         PH83    ==    3    ;
         PH82    ==    2    ;
         PH81    ==    1    ;
         PH80    ==    0    ;
     ;}
;
; Port 6 Pull Low Control Register
;
 IOCE1    ==    0X0E:iopage 1
 P6PL     ==    0X0E:iopage 1
;
     ;{                         ; Bit[n]="0", Disable P6.[n] Pull Low Function. n=7~0
                                ; Bit[n]="1", Enable P6.[n] Pull Low Function. n=7~0
         PL67    ==    7    ;
         PL66    ==    6    ;
         PL65    ==    5    ;
         PL64    ==    4    ;
         PL63    ==    3    ;
         PL62    ==    2    ;
         PL61    ==    1    ;
         PL60    ==    0    ;
     ;}
;
;======================================================;
; Others Define                                        ;
;======================================================;
;
; Bit set use BC or BS
;
 B0     ==    0
 B1     ==    1
 B2     ==    2
 B3     ==    3
 B4     ==    4
 B5     ==    5
 B6     ==    6
 B7     ==    7
 ;
 ;**********************************
 ;title:clear EM78P468N Ram Bank Register Macro Program
 ;
 ;************************************************
 ;
  MCLR468NRAMBANK  MACRO
 ;
      MOV   A,@0X10
      MOV   RSR,A
 $_CLRLOOP:
      CLR   R0
      INC   RSR
      JBC   RSR,6
      BS    RSR,5
      JBC   RSR,7
      BS    RSR,5
      JBS   Z
      JMP   $_CLRLOOP
;
      ENDM
