%=================================================================
%=================================================================
	clc ;                                    %����
	clear ;                                  %���ڴ�
%���崮��ͨ������
	scom=serial('com1') ;                    %����һ������
	scom.DataBits=8 ;                        %����ÿ֡���ݵı���λ��
	scom.BaudRate=38400 ;                    %���崫�䲨����
	scom.Parity='none' ;                     %������żУ������
	scom.StopBits=1 ;                        %�������ڱ�ʾ֡�����ı���λ��
	scom.InputBufferSize=512 ;               %���뻺����Ϊ32B��ȱʡֵΪ512B
	scom.OutputBufferSize=512 ;              %���������Ϊ256B��ȱʡֵΪ512B

%���崮�ڻص�����
	scom.timeout=0.5 ;                       %����һ�ζ���д������������ʱ��Ϊ0.5s,ȱʡֵΪ10s
	scom.Terminator='CR' ;                   %������ֹ��ΪCR���س�������ȱʡΪLF�����з���
	scom.BytesAvailableFcnCount=13 ;         %���ջ�����ÿ�յ�13���ֽ�ʱ�������ص�����
	scom.BytesAvailableFcnMode='byte' ;      %�жϴ����¼�Ϊ��bytes-available Event��
	scom.ReadAsyncMode='continuous' ;        %�����첽������Ϊ������ʽ�����ֹ���ʽ manual,continuous
	scom.BytesAvailableFcn=@instrcallback ;  %�����ж��¼��Ļص��������õ��ص��������
	%scom.PinStatusFcn= ;                    %���嵱���ڵ�CD/CTS/DSR��RI��״̬�����仯ʱ�����Ļص�����

%����������������
	%scom.DataTerminal= ;                    %���崮�ڵ�DTR ���״̬
	scom.FlowControl='none' ;                %����ʹ�õ��������ط�ʽ

%�����豸
	fopen(scom) ;                            %���Ӵ����豸����
	scom.status ;
	%fwrite(scom,00) ;                       %д���ڣ����������ź�0xFF(�ȼ���ʮ�����µ���ֵ255)
	%arrang=fread(scom,1,'uint8');







