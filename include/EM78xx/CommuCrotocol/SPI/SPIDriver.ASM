/*****************************************************************
* Filename     :  SPI Driver
* Author       :  yu.wei
* Company      :  ELAN
* VERSION      :  1.0
* Creat date   :  2009/11/9
* tool ver.    :  Wiceplus II/eUIDE
* Description  :  modify for code conformity
*****************************************************************/
;----------------------------------------------------------
SPIDriver.ASM    EQU    SPIDriver.ASM

include "SPIDriver.H"

ifndef EM78CtrlIns.H
include "D:\include\EM78xx\EM78CtrlIns.H"
endif

;-----------------------------------------------------------

;====================================================================
; Function: Write SPI communication subroutine rising edge
; Input:    ACC
; Output:   None
;=====================================================================
SIM_SPI_WRITE:
	BANK                2
	CLR                 SPIS
	CLR                 SPIR
	MOV                 SPIW,A         ; Write data to buffer
	BS                  SPIC, SSE       ; Start to shift data
	JBC                 SPIC, SSE       ; Wait to finish shift data
	JMP                 $-1
	BANK                1
	RET

;====================================================================
; Function: Read SPI communication subroutine rising edge
; Input:    None
; Output:   SPI Data
;====================================================================
SIM_SPI_READ:
	BANK                2
	CLR                 SPIS
	CLR                 SPIR
	CLR                 SPIW            ; Write data to buffer
	BS                  SPIC, SSE       ; Start to shift data
	JBC                 SPIC, SSE       ; Wait to finish shift data
	JMP                 $-1
	MOV                 A,SPIR
	BANK                1
   	RET

;====================================================================
; Read/Write subroutine
;====================================================================
SIM_SPI_READ_WRITE:
	BANK                2
	CLR                 SPIS
	CLR                 SPIR
	MOV                 SPIW,A            ; Write data to buffer
	BS                  SPIC, SSE       ; Start to shift data
	JBC                 SPIC, SSE       ; Wait to finish shift data
	JMP                 $-1
	MOV                 A,SPIR
	BANK                1
   	RET


