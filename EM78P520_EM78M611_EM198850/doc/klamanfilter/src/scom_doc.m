;%创建串口设备对象并设置其属性,两种方法
	scom=serial('com1')             ;%创建串口1的设备对象scom
	scom.Terminator='CR'            ;%设置终止符为CR（回车符），缺省为LF（换行符）
	scom.InputBufferSize=1024       ;%输入缓冲区为256B，缺省值为512B
	scom.OutputBufferSize=1024      ;%输出缓冲区为256B，缺省值为512B
	scom.Timeout=0.5                ;%Y设置一次读或写操作的最大完成时间为0.5s,缺省值为10s
	scom.ReadAsyncMode='continuous' ;%在异步通信模式方式下,读取串口数据采用连续接收数据(continuous)的缺省方式

	scom=serial('COM1','BaudRate',38400,'Parity','none','DataBits',8,'StopBits',1)
	set(scom,'BaudRate',38400,'Parity','even')

;%打开串口设备对象
	fopen(scom);

;%读写串口操作
	a.读串口。A=fscanf(scom,'%d',[10,100];%从串口设备对象scom中读入10*100个数据填充到数组A[10,100]中，并以整型的数据格式存放
	b.写串口。Fprintf(scom,'%s','RS232','async');%将字符串‘RS232？’以字符的数据格式写入到串口设备scom，写操作以异步的方式进行

;%关闭并清除设备对象
	fclose(scom)     ;%关闭串口设备对象
	delete(scom)     ;%删除内存中的串口设备对象
	clear scom       ;%清除工作空间中的串口设备对象




;%===============================================================
;%基于Matlab中断方式的实时串行通信编程
	%开启设备。
	%初始化串口设备对象，设置串口属性为：PC机COM1口，输入缓冲区为1024，
	%读写最大完成时间为0.6s，波特率为38400b/s，1位停止位，遇到换行符中止，硬件流控制
	clc                         ;
	clear                       ;
	scom=serial('COM1')   	    ;
	scom.InputBufferSize=4096 	;
	scom.timeout=0.5         	;
	scom.BaudRate=38400     	;
	scom.Parity='none'        	;
	scom.StopBits=1             ;
	scom.Terminator='LF'      	;%设置终止符为CR（回车符），缺省为LF（换行符）
	%scom.FlowControl='hardware'	;%握手信号

	;%-------------------------------------------------------
	fopen(scom)              	;%打开串口设备对象s
	fwrite(scom,00)          	;%以二进制的方式发送握手信号0xFF，缺省为异步通信方式
	out=fread(scom,32,'uint8')  ;%接收单片机发送的32个数据（8位），并存入out数组中

	scom=serial('COM1','InputBufferSize',4096,'timeout',0.6,'BaudRate',38400,'Parity','none','StopBits',1,'Terminator','LF','FlowControl','hardware');
	fopen(scom)              	;%打开串口设备对象s
	fwrite(scom,00)          	;%以二进制的方式发送握手信号0xFF，缺省为异步通信方式
	out=fread(scom,32,'uint8')  ;%接收单片机发送的32个数据（8位），并存入out数组中

;%=================================================================
	%建立一个串行通信主程序
	%设置回调函数触发事件—当串口缓冲区中有33字节的数据时
	%触发中断事件，此后主程序自动调用instrcallback(obj,event)回调函数
	scom.BytesAvailableFcnMode='byte'       ;%中断触发事件为‘bytes-available Event’
	scom.BytesAvailableFcnCount=32          ;%接收缓冲区每收到32个字节时，触发回调函数
	scom.BytesAvailableFcn=@instrcallback   ;%得到回调函数句柄

	fopen(scom)                             ;%连接串口设备对象
	fwrite(scom,00)                        ;%写串口，发送握手信号0xFF(等价于十进制下的数值255)

	%修改instrcallback(obj,event)回调函数，对所发生的串口通信事件进行处理。





;%==================================================================
	%释放串口设备对象
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
	scom.Terminator='LF'      	            ;%设置终止符为CR（回车符），缺省为LF（换行符）
	%scom.FlowControl='hardware'	        ;%握手信号

	scom.BytesAvailableFcnMode='byte'       ;%中断触发事件为‘bytes-available Event’
	scom.BytesAvailableFcnCount=32          ;%接收缓冲区每收到32个字节时，触发回调函数
	scom.BytesAvailableFcn=@instrcallback   ;%得到回调函数句柄

	fopen(scom)                             ;%连接串口设备对象
	fwrite(scom,00)                         ;%写串口，发送握手信号0xFF(等价于十进制下的数值255)
