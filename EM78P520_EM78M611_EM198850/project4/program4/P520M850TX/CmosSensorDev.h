/*****************************************************************
* Filename     :  CmosSensor.H
* Author       :  yu.wei
* Company      :  ELAN
* VERSION      :  1.0
* CRYSTAL      :  8MHZ
* Creat date   :  2009/11/9
* tool ver.    :  WicePlus 2.7/eUIDE
* Description  :  modify for code conformity,multi-1v2 CMOS project
*****************************************************************/
;-----------------------------------------------------------------
CmosSensorDev.h      EQU       CmosSensorDev.h




;=====================================================================
CmosSensorTypeSelect    EQU     0      ; select type,Default=0(MM0200DA)
                                       ; 0: MM0200DA (SPI Interface)
                                       ; 1: MM0200BA (I2C Interface)
                                       ; 2: MM0200FA
                                       ; 3: MM0200CA
                                       ; 4: CSM0012BA (I2C Interface)

CMOS_DEBUG             EQU     0       ; CMOS function debug
CMOS_T_DEBUG           EQU     0       ; CMOS time test debug
CMOS_UART_DEBUG        EQU     1       ; CMOS function debug
CMOS_UART_T_DEBUG      EQU     1       ; CMOS time test debug
CMOS_SPI_FUNCTION      EQU     1       ; Enable cmos SPI function
CMOS_I2C_FUNCTION      EQU     0       ; Enable cmos I2C function

CmosScanTimeCtrl       EQU     0       ; T=(KeyScanTimeCtrl+1)*8ms             KeyScanTimeCtrl¡Ý0
CmosUartTimeCtrl       EQU     0       ; T=(ComTimeCtrl+1)*8ms, (default:180,Value=0 do the fastest)
CmosFrameHeader        EQU     0x55    ; CMOS Data frame header