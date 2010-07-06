;%���������豸��������������,���ַ���
	scom=serial('com1')             ;%��������1���豸����scom
	scom.Terminator='CR'            ;%������ֹ��ΪCR���س�������ȱʡΪLF�����з���
	scom.InputBufferSize=1024       ;%���뻺����Ϊ256B��ȱʡֵΪ512B
	scom.OutputBufferSize=1024      ;%���������Ϊ256B��ȱʡֵΪ512B
	scom.Timeout=0.5                ;%Y����һ�ζ���д������������ʱ��Ϊ0.5s,ȱʡֵΪ10s
	scom.ReadAsyncMode='continuous' ;%���첽ͨ��ģʽ��ʽ��,��ȡ�������ݲ���������������(continuous)��ȱʡ��ʽ

	scom=serial('COM1','BaudRate',38400,'Parity','none','DataBits',8,'StopBits',1)
	set(scom,'BaudRate',38400,'Parity','even')

;%�򿪴����豸����
	fopen(scom);

;%��д���ڲ���
	a.�����ڡ�A=fscanf(scom,'%d',[10,100];%�Ӵ����豸����scom�ж���10*100��������䵽����A[10,100]�У��������͵����ݸ�ʽ���
	b.д���ڡ�Fprintf(scom,'%s','RS232','async');%���ַ�����RS232�������ַ������ݸ�ʽд�뵽�����豸scom��д�������첽�ķ�ʽ����

;%�رղ�����豸����
	fclose(scom)     ;%�رմ����豸����
	delete(scom)     ;%ɾ���ڴ��еĴ����豸����
	clear scom       ;%��������ռ��еĴ����豸����




;%===============================================================
;%����Matlab�жϷ�ʽ��ʵʱ����ͨ�ű��
	%�����豸��
	%��ʼ�������豸�������ô�������Ϊ��PC��COM1�ڣ����뻺����Ϊ1024��
	%��д������ʱ��Ϊ0.6s��������Ϊ38400b/s��1λֹͣλ���������з���ֹ��Ӳ��������
	clc                         ;
	clear                       ;
	scom=serial('COM1')   	    ;
	scom.InputBufferSize=4096 	;
	scom.timeout=0.5         	;
	scom.BaudRate=38400     	;
	scom.Parity='none'        	;
	scom.StopBits=1             ;
	scom.Terminator='LF'      	;%������ֹ��ΪCR���س�������ȱʡΪLF�����з���
	%scom.FlowControl='hardware'	;%�����ź�

	;%-------------------------------------------------------
	fopen(scom)              	;%�򿪴����豸����s
	fwrite(scom,00)          	;%�Զ����Ƶķ�ʽ���������ź�0xFF��ȱʡΪ�첽ͨ�ŷ�ʽ
	out=fread(scom,32,'uint8')  ;%���յ�Ƭ�����͵�32�����ݣ�8λ����������out������

	scom=serial('COM1','InputBufferSize',4096,'timeout',0.6,'BaudRate',38400,'Parity','none','StopBits',1,'Terminator','LF','FlowControl','hardware');
	fopen(scom)              	;%�򿪴����豸����s
	fwrite(scom,00)          	;%�Զ����Ƶķ�ʽ���������ź�0xFF��ȱʡΪ�첽ͨ�ŷ�ʽ
	out=fread(scom,32,'uint8')  ;%���յ�Ƭ�����͵�32�����ݣ�8λ����������out������

;%=================================================================
	%����һ������ͨ��������
	%���ûص����������¼��������ڻ���������33�ֽڵ�����ʱ
	%�����ж��¼����˺��������Զ�����instrcallback(obj,event)�ص�����
	scom.BytesAvailableFcnMode='byte'       ;%�жϴ����¼�Ϊ��bytes-available Event��
	scom.BytesAvailableFcnCount=32          ;%���ջ�����ÿ�յ�32���ֽ�ʱ�������ص�����
	scom.BytesAvailableFcn=@instrcallback   ;%�õ��ص��������

	fopen(scom)                             ;%���Ӵ����豸����
	fwrite(scom,00)                        ;%д���ڣ����������ź�0xFF(�ȼ���ʮ�����µ���ֵ255)

	%�޸�instrcallback(obj,event)�ص����������������Ĵ���ͨ���¼����д���





;%==================================================================
	%�ͷŴ����豸����
	fclose(scom)         ;
	delete(scom)         ;
	clear scom           ;
	clear






;%=================================================================
;%=================================================================
	clc                         ;
	clear                       ;
	scom=serial('COM1')   	    ;
	scom.InputBufferSize=4096 	;
	scom.timeout=0.5         	;
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
