%=================================================================
%=================================================================
	clc ;                                    %清屏
	clear ;                                  %清内存
%定义串口通信属性
	scom=serial('com1') ;                    %定义一个串口
	scom.DataBits=8 ;                        %定义每帧数据的比特位数
	scom.BaudRate=38400 ;                    %定义传输波特率
	scom.Parity='none' ;                     %定义奇偶校验类型
	scom.StopBits=1 ;                        %定义用于表示帧结束的比特位数
	scom.InputBufferSize=512 ;               %输入缓冲区为32B，缺省值为512B
	scom.OutputBufferSize=512 ;              %输出缓冲区为256B，缺省值为512B

%定义串口回调属性
	scom.timeout=0.5 ;                       %设置一次读或写操作的最大完成时间为0.5s,缺省值为10s
	scom.Terminator='CR' ;                   %设置终止符为CR（回车符），缺省为LF（换行符）
	scom.BytesAvailableFcnCount=13 ;         %接收缓冲区每收到13个字节时，触发回调函数
	scom.BytesAvailableFcnMode='byte' ;      %中断触发事件为‘bytes-available Event’
	scom.ReadAsyncMode='continuous' ;        %定义异步读操作为连续方式还是手工方式 manual,continuous
	scom.BytesAvailableFcn=@instrcallback ;  %定义中断事件的回调函数，得到回调函数句柄
	%scom.PinStatusFcn= ;                    %定义当串口的CD/CTS/DSR或RI针状态发生变化时触发的回调函数

%控制连接线针属性
	%scom.DataTerminal= ;                    %定义串口的DTR 针的状态
	scom.FlowControl='none' ;                %定义使用的数据流控方式

%启用设备
	fopen(scom) ;                            %连接串口设备对象
	scom.status ;
	%fwrite(scom,00) ;                       %写串口，发送握手信号0xFF(等价于十进制下的数值255)
	%arrang=fread(scom,1,'uint8');







