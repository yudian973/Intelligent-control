/*****************************************************************
* Filename     :  EM78P520_32PIN44PIN_TX.ASM
* Author       :  yu.wei
* Company      :  ELAN
* VERSION      :  1.0
* CRYSTAL	   :  8MHZ
* Creat date   :  2009/9/11
* tool ver.    :  WicePlus 2.7
* Description  :  modify for code conformity
*****************************************************************/

;--------------------------------------------------------------------------
FIFO_PTR                EQU     82			
CLR_W_PTR               EQU     0X80		
FIFO_REG                EQU     80			
READ_MASK               EQU     0X80		
RX_MASK                 EQU     0X80		

PKT_LEN                 EQU     0X10        
TXADDRL                 EQU     0X00
TXADDRH                 EQU     0X11
RX_BUF                  EQU     0B01100000
TX_BUF                  EQU     0B01100000





;==================================================================
