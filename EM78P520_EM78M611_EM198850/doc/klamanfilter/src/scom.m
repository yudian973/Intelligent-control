;%=================================================================
;%=================================================================
	clc                         ;
	clear                       ;
	scom=serial('COM1')   	    ;
	scom.InputBufferSize=4096 	;
	scom.timeout=0.6         	;
	scom.BaudRate=38400     	;
	scom.Parity='none'        	;
	scom.StopBits=1             ;
	scom.Terminator='LF'      	            ;%������ֹ��ΪCR���س�������ȱʡΪLF�����з���
	%scom.FlowControl='hardware'	        ;%�����ź�

	scom.BytesAvailableFcnMode='byte'       ;%�жϴ����¼�Ϊ��bytes-available Event��
	scom.BytesAvailableFcnCount=32          ;%���ջ�����ÿ�յ�32���ֽ�ʱ�������ص�����
	scom.BytesAvailableFcn=@instrcallback   ;%�õ��ص��������

	fopen(scom)                             ;%���Ӵ����豸����
	fwrite(scom,00)                         ;%д���ڣ����������ź�0xFF(�ȼ���ʮ�����µ���ֵ255)
