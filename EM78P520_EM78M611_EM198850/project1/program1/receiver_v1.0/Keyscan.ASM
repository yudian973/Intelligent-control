;==================================================================
;  Tilte:       EM78M198810 include file		;
;  NAME:        EM198810_FOR_EM78M611.ASM
;  Description: The Definition of EM78M198810 for EM78612 Registers ;
;  Company:     Elan Electronic Corp.		;
;  Author:      YU.WEI				;
;  Date:        2009.02.26			;
;  Version:     v1.0				;
;  Tool:        wiceplus 2.7
;=========================================================================
include "Keyscan.H"

ifndef EM78CtrlIns.H
include "EM78CtrlIns.H"
endif
	ORG                 0X1100 ;page 4
ConnectKey_Scan:
	CALL                PAGE4BANK1
	NOP
	MOV                 A,Port9                   
	AND                 A,@00000100B
	MOV                 TEMP,A
	MOV                 A,@00000100B           
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
	JMP                 Edge_Judge_End
Rising_Edge_Judge:
	MOV                 A,TEMP
	XOR                 A,KeystokeFlag_Befor     
	JBC                 STATUS,Z
	JMP                 Edge_Judge_End
	MOV                 A,TEMP                  
	XOR                 A,@00000100B
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
	JBC                 KEY_NUM,7                                   
	CLR                 KEY_NUM
	MOV                 A,KeystokeTimeCNT
	SUB                 A,@70                                       
	JBC                 STATUS,C
	INC                 KeystokeTimeCNT                            

	MOV                 A,KeystokeTimeCNT
	XOR                 A,@17                                    
	JBS                 STATUS,Z                                    
	RET
	BC                  KeyScanStatusFlag/16,KeyScanStatusFlag%16	     
	RET
KeyStatus_Low_Scan:     
	MOV                 A,KeystokeTimeCNT
	SUB                 A,@6                       
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


