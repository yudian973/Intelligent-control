;=============================================================================
;=============================================================================
; Filename    :	KEYSCAN.ASM
; Author      : yu.wei
; Company     : ELAN
; VERSION     : 1.1
; CRYSTAL     : 4MHZ
; Creat date  : 2009/1/20
; tool ver.   : WicePlus 2.7
; descripition:	FOR_EM78520
;=============================================================================
;=============================================================================

;---------------------------------------------------
keyscan.asm             EQU       keyscan.asm
include "keyscan.H"

ifndef EM78CtrlIns.H
include "D:\include\EM78xx\EM78CtrlIns.H"
endif
;----------------------------------------------------
	ORG                 0x1100    ;PAGE 4
Key_Scan:
	BANK                4		
	MOV                 A,@00010000B	   
	MOV                 PAIOCR, A       	
	MOV                 A,@00110111B	   
	MOV                 PBIOCR,A       	   
 	MOV                 A,@11111111B
 	MOV                 IOC9,A		       
 	MOV                 A,@00000000B
 	MOV                 IOC8,A
 	MOV                 IOC7,A             
	BANK                5
	MOV                 A,@00110111B
	MOV                 PBPHCR,A	    
 	MOV                 A,@11110000B
 	MOV                 P9PHCR,A		    

 	BANK                2
	MOV                 A,F_MODE
	XOR                 A,@0X00
	JBC                 STATUS,Z		
	JMP                 SET_VR_STATUS_0
	JMP                 SET_VR_STATUS_1
SET_VR_STATUS_1:
	NOP
	BANK                0
	BS                  LED1_STATUS/16,LED1_STATUS%16		
	JMP                 SET_VR_STATUS_END
SET_VR_STATUS_0:
	NOP
	BANK                0
	BC                  LED1_STATUS/16,LED1_STATUS%16		
	JMP                 SET_VR_STATUS_END
SET_VR_STATUS_END:
	BANK                2
 	NOP
	CALL                KeyPort_Check
	CLR                 DataA
	RLC                 LINE2_KEY_INPUT
	RRC                 DataA
	RLC                 LINE2_KEY_INPUT
	RRC                 DataA
	RLC                 LINE2_KEY_INPUT
	RRC                 DataA
	RLC                 LINE2_KEY_INPUT
	RRC                 DataA
	RLC                 LINE3_KEY_INPUT
	RRC                 DataA
	RLC                 LINE3_KEY_INPUT
	RRC                 DataA
	RLC                 LINE3_KEY_INPUT
	RRC                 DataA
	RLC                 LINE3_KEY_INPUT
	RRC                 DataA
	NOP
	CLR                 DataB
	RLC                 LINE4_KEY_INPUT
	RRC                 DataB
	RLC                 LINE4_KEY_INPUT
	RRC                 DataB
	RLC                 LINE4_KEY_INPUT
	RRC                 DataB
	RLC                 LINE4_KEY_INPUT
	RRC                 DataB
	SWAP                DataB
	CALL                KeyBoardScan
	CALL                RockerKeyScan
	BANK                2
	COM                 DataA
	MOV                 A,@11110111B
	AND                 DataB,A
	MOV                 A,@00001000B
	AND                 A,F_MODE
	OR                  DataB,A
	COM                 DataB
	NOP
	BANK                0
KEY_SCAN_END:
	RET
KeyPort_Check:
	BANK                0
	MOV                 A,PORTB		;00110111
	BANK                2
	MOV                 LINE1_KEY_INPUT_CACHE,A
	MOV                 TEMP1,A
	BANK                0
	MOV                 A,@11101000B
	MOV                 PORT7,A
	CALL                KEY_DELAY
	MOV                 A,PORT9
	BANK                2
	MOV                 LINE2_KEY_INPUT_CACHE,A
	BANK                0
	MOV                 A,@11011000B
	MOV                 PORT7,A
	CALL                KEY_DELAY
	MOV                 A,PORT9
	BANK                2
	MOV                 LINE3_KEY_INPUT_CACHE,A
	BANK                0
	MOV                 A,@10111000B
	MOV                 PORT7,A
	CALL                KEY_DELAY
	MOV                 A,PORT9
	BANK                2
	MOV                 LINE4_KEY_INPUT_CACHE,A
	BANK                0
	MOV                 A,@01111000B
	MOV                 PORT7,A
	CALL                KEY_DELAY
	MOV                 A,PORT9
	BANK                2
	MOV                 LINE5_KEY_INPUT_CACHE,A
	NOP
	RLC                 TEMP1
	RLC                 TEMP1
	MOV                 A,@11011000B
	AND                 A,TEMP1
	MOV                 LINE1_KEY_INPUT,A	
	CALL                RestoreKeyCache
	MOV                 A,@10000000B
	AND                 TEMP2,A
	MOV                 A,@01000000B
	AND                 TEMP3,A
	MOV                 A,@00100000B
	AND                 TEMP4,A
	MOV                 A,@00010000B
	AND                 A,TEMP5
	OR                  A,TEMP4
	OR                  A,TEMP3
	OR                  A,TEMP2
	BANK                2
	MOV                 LINE2_KEY_INPUT,A	
	CALL                RestoreKeyCache
	MOV                 A,@00100000B
	AND                 TEMP2,A
	MOV                 A,@10010000B
	AND                 TEMP3,A
	MOV                 A,@01000000B
	AND                 A,TEMP4
	OR                  A,TEMP3
	OR                  A,TEMP2
	BANK                2
	MOV                 LINE3_KEY_INPUT,A	
	CALL                RestoreKeyCache
	MOV                 A,@00100000B
	AND                 TEMP3,A
	MOV                 A,@10010000B
	AND                 TEMP4,A
	MOV                 A,@01000000B
	AND                 A,TEMP5
	OR                  A,TEMP4
	OR                  A,TEMP3
	BANK                2
	MOV                 LINE4_KEY_INPUT,A	
	MOV                 F_TEMP,A		
	RET
KeyBoardScan:
LEFT_RIGHT_KEY:
	CLR                 DataC
	JBS                 LINE1_KEY_INPUT,6 
	JMP                 JudgeRight
	JBS                 LINE1_KEY_INPUT,3 
	JMP                 JudgeLeft
	MOV                 A,@0X7F
	MOV                 DataC,A
	JMP                 Left_Right_Finsh
JudgeRight:
	MOV                 A,@0XFF
	MOV                 DataC,A
	JMP                 Left_Right_Finsh
JudgeLeft:
	MOV                 A,@0X00
	MOV                 DataC,A
	JMP                 Left_Right_Finsh
Left_Right_Finsh:
	NOP
UP_DOWN_KEY:
	CLR                 DataD
	JBS                 LINE1_KEY_INPUT,7 
	JMP                 JudgeUp
	JBS                 LINE1_KEY_INPUT,4 
	JMP                 JudgeDown
	MOV                 A,@0X7F
	MOV                 DataD,A
	JMP                 UP_DOWN_Finsh
JudgeUp:
	MOV                 A,@0XFF
	MOV                 DataD,A
	JMP                 UP_DOWN_Finsh
JudgeDown:
	MOV                 A,@0X00
	MOV                 DataD,A
	JMP                 UP_DOWN_Finsh
UP_DOWN_Finsh:
	NOP
	RET
KEY_DELAY:
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	RET
RestoreKeyCache:
	MOV                 A,LINE2_KEY_INPUT_CACHE
	MOV                 TEMP2,A
	MOV                 A,LINE3_KEY_INPUT_CACHE
	MOV                 TEMP3,A
	MOV                 A,LINE4_KEY_INPUT_CACHE
	MOV                 TEMP4,A
	MOV                 A,LINE5_KEY_INPUT_CACHE
	MOV                 TEMP5,A
	RET
RockerKeyScan:
	CALL                 SUB_RINIT
	CALL                 SUB_ADJ
	BANK                 3
	MOV                  A, @0X80             
	OR                   ADCR, A
	CALL                 SUB_ADC
	MOV                  A, ADDH
	BANK                 2
	MOV                  KEY_RIGHT_X,A     
	CALL                 SUB_RINIT
	CALL                 SUB_ADJ
	BANK                 3
	MOV                  A, @0X81            
	OR                   ADCR, A
	CALL                 SUB_ADC
	MOV                  A, ADDH
	BANK                 2
	MOV                  KEY_RIGHT_Y,A
	CALL                 SUB_RINIT
	CALL                 SUB_ADJ
	BANK                 3
	MOV                  A, @0X82             
	CALL                 SUB_ADC
	MOV                  A,ADDH
	BANK                 2
	MOV                  KEY_LEFT_X,A
	CALL                 SUB_RINIT
	CALL                 SUB_ADJ
	BANK                 3
	MOV                  A,@0X83            
	OR                   ADCR, A
	CALL                 SUB_ADC
	MOV                  A,ADDH
	BANK                 2
	MOV                  KEY_LEFT_Y,A
	NOP
	MOV                 A,F_TEMP			
	AND                 A,@00010000B
	XOR                 A,@0X00
	JBS                 R3,Z
	JMP                 MODE_NOCHANGE
	MOV                 A,F_MODE_BEFOR      
	XOR                 A,@00010000B
	JBS                 R3,Z
	JMP                 MODE_NOCHANGE
	COM                 F_MODE
MODE_NOCHANGE:
	MOV                 A,F_TEMP
	AND                 A,@00010000B
	MOV                 F_MODE_BEFOR,A
	JBS                 F_MODE,4			
	JMP                 DealWithDigital
	JMP                 DealWithAnalog
DealWithDigital:
	CLR                 DataE
	MOV                 A,KEY_LEFT_X		
	MOV                 TEMP1,A
	CALL                AreaJugde_direction
	MOV                 DataE,A
	CLR                 DataF
	MOV                 A,KEY_LEFT_Y		
	MOV                 TEMP1,A
	CALL                AreaJugde_direction
	MOV                 DataF,A
	CLR                 DataG
	CLR                 DataH
	MOV                 A,KEY_RIGHT_X		
	MOV                 TEMP2,A
	MOV                 A,KEY_RIGHT_Y
	MOV                 TEMP3,A
	CALL                AreaJugde_Button
	MOV                 A,TEMP2
	MOV                 DataG,A
	MOV                 A,TEMP3
	MOV                 DataH,A
	NOP
	JMP                 RockerCheakFinish
DealWithAnalog:
	MOV                 A,KEY_LEFT_X		
	MOV                 DataE,A
	MOV                 A,KEY_LEFT_Y		
	MOV                 DataF,A
	MOV                 A,KEY_RIGHT_X		
	MOV                 DataG,A
	MOV                 A,KEY_RIGHT_Y		
	MOV                 DataH,A
	JMP                     RockerCheakFinish
RockerCheakFinish:
	NOP
	RET
AreaJugde_direction:
	BANK                2
	MOV                 A,TEMP1	
	SUB                 A,@0XBF
	JBS                 R3,0		
	JMP                 CheakTop_Left
	JMP                 CheakMiddle_Left
CheakTop_Left:
	MOV                 A,@0XFF
	JMP                 CheakAreaFinish_Left
CheakMiddle_Left:
	MOV                 A,TEMP1
	SUB                 A,@0X40
	JBC                 R3,0
	JMP                 CheakBottom_Left
	MOV                 A,@0X7F
	JMP                 CheakAreaFinish_Left
CheakBottom_Left:
	MOV                 A,@0X00
	JMP                 CheakAreaFinish_Left
CheakAreaFinish_Left:
	NOP
	NOP
	RET
AreaJugde_Button:
	BANK                2
	MOV                 A,TEMP2    
	SUB                 A,@0XD0
	JBS                 R3,C	     
	JMP                 CheakTop_Right_y
	JMP                 CheakMiddle_Right_y
CheakTop_Right_y:
	MOV                 A,@0XFF
	JMP                 CheakAreaFinish_Right_y
CheakMiddle_Right_y:
	MOV                 A,TEMP2
	SUB                 A,@0X25
	JBS                 R3,C
	JMP                 CheakBottom_Right_y
	MOV                 A,@0X00
	JMP                 CheakAreaFinish_Right_y
CheakBottom_Right_y:
	MOV                 A,@0X7F
	JMP                 CheakAreaFinish_Right_y
CheakAreaFinish_Right_y:
	MOV                 TEMP2,A
	NOP

	BANK                2
	MOV                 A,TEMP3   
	SUB                 A,@0XD0
	JBS                 R3,C	     
	JMP                 CheakTop_Right_x
	JMP                 CheakMiddle_Right_x
CheakTop_Right_x:
	MOV                 A,@0XFF
	JMP                 CheakAreaFinish_Right_x
CheakMiddle_Right_x:
	MOV                 A,TEMP3
	SUB                 A,@0X25
	JBS                 R3,0
	JMP                 CheakBottom_Right_x
	MOV                 A,@0X00
	JMP                 CheakAreaFinish_Right_x
CheakBottom_Right_x:
	MOV                 A,@0X7F
	JMP                 CheakAreaFinish_Right_x
CheakAreaFinish_Right_x:
	MOV                 TEMP3,A
	NOP
	RET
SUB_ADJ:
	BANK                3
	BS                  ADICH,CALI             
_ADJ_LOOP:
	BS                  ADCR,ADRUN
	JBC                 ADCR,ADRUN
	JMP                 $-1
	MOV                 A,ADDL
	AND                 A,@0X0F
	JBS                 R3, Z
	JMP                 _ADJ_DONE
	MOV                 A, ADDH
	JBS                 R3, Z
	JMP                 _ADJ_DONE
	MOV                 A, @0X10
	ADD                 ADDL,A
	JMP                 _ADJ_LOOP
_ADJ_DONE:
	BC                  ADICH, CALI
	BANK                0
	RET
SUB_RINIT:
 	BANK                5
 	MOV                 A,@00000000B
 	MOV                 P9PHCR,A		
	BANK                3
	MOV                 A,@0X0F
	MOV                 ADICL, A              
	CLR                 ADICH                 
	MOV                 A,@0X60
	MOV                 ADCR, A             
	RET
SUB_ADC:
	BANK                3
	BS                  ADCR, ADRUN
	JBC                 ADCR, ADRUN
	JMP                 $-1
	NOP
	RET
ConnectKey_Scan:
	BANK                0
	MOV                 A,@11011000B
	MOV                 PORT7,A
	CALL                KEY_DELAY
	MOV                 A,PORT9                
	BANK                2
	AND                 A,@00100000B           ;
	MOV                 TEMP,A
	MOV                 A,@00100000B          
	AND                 KeystokeFlag_Befor,A
Falling_Edge_Judge:
	MOV                 A,TEMP
	XOR                 A,KeystokeFlag_Befor     
	JBC                 STATUS,Z
	JMP                 Rising_Edge_Judge         
	MOV                 A,TEMP                    
	XOR                 A,@00000000B
	JBS                 STATUS,Z
	JMP                 Rising_Edge_Judge        
	JBS                 KeyScanStatusFlag/16,KeyScanStatusFlag%16        
	BS                  KEY_NUM,0                            
	CLR                 KeystokeTimeCNT                     
	BC                  KeyStatusFlag/16,KeyStatusFlag%16    
	BS                  KeyScanStatusFlag/16,KeyScanStatusFlag%16	    
	JMP                 Edge_Judge_End
Rising_Edge_Judge:
	MOV                 A,TEMP
	XOR                 A,KeystokeFlag_Befor     
	JBC                 STATUS,Z
	JMP                 Edge_Judge_End
	MOV                 A,TEMP                   
	XOR                 A,@00100000B
	JBS                 STATUS,Z
	JMP                 Edge_Judge_End
	NOP
	CALL                KeyStatus_Low_Scan        
	CLR                 KeystokeTimeCNT           
	BS                  KeyStatusFlag/16,KeyStatusFlag%16
Edge_Judge_End:
	MOV                 A,TEMP                    
	MOV                 KeystokeFlag_Befor,A
KeystokeScan_End:                                                    
	JBS                 KeyScanStatusFlag/16,KeyScanStatusFlag%16
	CLR                 KEY_NUM
	JBC                 KEY_NUM,7                                    
	CLR                 KEY_NUM
	BC                  System16msFlag/16,System16msFlag%16
	MOV                 A,KeystokeTimeCNT
	SUB                 A,@250                                       
	JBC                 STATUS,C
	INC                 KeystokeTimeCNT                             
	MOV                 A,KeystokeTimeCNT
	SUB                 A,@65                                       
	JBC                 STATUS,C                                     
	RET
	BC                  KeyScanStatusFlag/16,KeyScanStatusFlag%16    
	BS                  KeyScanFinishFlag/16,KeyScanFinishFlag%16
	RET
KeyStatus_Low_Scan:    
	MOV                 A,KeystokeTimeCNT
	SUB                 A,@40                     
	JBC                 STATUS,C                   
	JMP                 KeyScan_Short_Press	      
	JMP                 KeyScan_Lasting_Press     
KeyScan_Short_Press:
	BC                  STATUS,C
	RLC                 KEY_NUM
	RET
KeyScan_Lasting_Press:
	BS                  STATUS,C
	RLC                 KEY_NUM
	RET
SUB_IO_ADC:
	RET
