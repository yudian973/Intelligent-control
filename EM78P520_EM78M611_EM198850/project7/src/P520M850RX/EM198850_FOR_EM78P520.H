/*********************************************************************
* Filename     :  EM78P520P44TX.ASM
* Author       :  yu.wei
* Company      :  KEN YEAR
* VERSION      :  4.0
* CRYSTAL      :  8MHZ
* Creat date   :  2010.06.25
* tool Ver.    :  eUIDE 1.02.11
* Description  :  modify for 2.4G remote control in Intelligen Home 
**********************************************************************/

;--------------------------------------------------------------------------
FIFO_PTR                EQU     82              ; FIFO POINTER CONTROL=REG 82
CLR_W_PTR               EQU     0X80            ; CLR POINTER MARK VALUE
FIFO_REG                EQU     80              ; FIFO POINTER=REG 80
READ_MASK               EQU     0X80            ; READ REG,MSB SET TO 1
RX_MASK                 EQU     0X80            ; ENABLE RX

PKT_LEN                 EQU     0X20            ; DataByteLength = 32
TXADDRL                 EQU     0X00
TXADDRH                 EQU     0X11
RX_BUF                  EQU     0B11100000
TX_BUF                  EQU     0B11100000
NoiseStrobe             EQU     0X25
ChannelSum              EQU     75              ; (CH_TABLE_END-CH_TABLE_START)
USED_PID_FUNCTION       EQU     0               ; 1:used this function; 0:not used

;==================================================================
