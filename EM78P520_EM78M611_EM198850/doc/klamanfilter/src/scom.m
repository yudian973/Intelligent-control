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
	scom.Terminator='LF'      	            ;%设置终止符为CR（回车符），缺省为LF（换行符）
	%scom.FlowControl='hardware'	        ;%握手信号

	scom.BytesAvailableFcnMode='byte'       ;%中断触发事件为‘bytes-available Event’
	scom.BytesAvailableFcnCount=32          ;%接收缓冲区每收到32个字节时，触发回调函数
	scom.BytesAvailableFcn=@instrcallback   ;%得到回调函数句柄

	fopen(scom)                             ;%连接串口设备对象
	fwrite(scom,00)                         ;%写串口，发送握手信号0xFF(等价于十进制下的数值255)
