/*****************************************************************
* Filename     :  EM78M611dev.ASM
* Author       :  yu.wei
* Company      :  ELAN
* VERSION      :  1.0
* CRYSTAL	   :  6MHZ
* Creat date   :  2009/9/11
* tool ver.    :  WicePlus 2.7
* Description  :  modify for code conformity
*****************************************************************/

;--------------------------------------------------------------------------
FIFO_PTR                EQU     82          ;FIFO POINTER CONTROL=REG 82
CLR_W_PTR               EQU     0X80        ;CLR POINTER MARK VALUE
FIFO_REG                EQU     80          ;FIFO POINTER=REG 80
READ_MASK               EQU     0X80        ;READ REG,MSB SET TO 1
RX_MASK                 EQU     0X80        ;ENABLE RX

PKT_LEN                 EQU     0X20        ;DataByteLength = 32
TXADDRL                 EQU     0X00
TXADDRH                 EQU     0X11
RX_BUF                  EQU     0B00100000  ;0x20(bank 0)
TX_BUF                  EQU     0B00100000  ;0x20(bank 0)
NoiseStrobe             EQU     0X20        ;dirty:0x08-0x0A, neatness:0x28-0x2A
ChannelSum              EQU     76




;==================================================================
