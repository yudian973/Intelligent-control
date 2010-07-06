
%%%%%%%%%%%%%%%%%%%%%%%%串口接收函数%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%thomas1847,2007.1.22%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%注：查询方式
function serialcomm
%web -browser http://www.ilovematlab.cn/thread-1449-1-1.html
clear ;
clc ;                              %清除变量
scom=serial('com1') ;              %创建串口对象
scom.baudrate=38400 ;              %设置波特率,缺省38400bit/s
scom.parity='none' ;               %无奇偶校验
scom.stopbits=1 ;                  %停止位
scom.timeout=0.5 ;                 %设置读操作完成时间为1s,缺省10s
scom.inputbuffersize=256 ;         %输入缓冲区为32byte，缺省值为512b

%设置
recbuf=zeros(1,40) ;               %清接收缓冲区（40）
framelen=13 ;                      %帧长度（每帧13byte)
framenum=0 ;                       %清接收帧数
rectr=0 ;                          %接收计数器清零
xctr=0 ;

%输入接收的数据帧数
recnum= input('请输入要接收的数据帧数:\n') ;        %输入接收帧数%清

%打开串口设备
fopen(scom) ;                                      %打开串口设备对象scom

%进入接收循环
while framenum<recnum                              %
       recdta=fread(scom,1,'uint8') ;              %读入数据
       if recdta==0                                %找帧头,帧头为0
          rectr=rectr+1;                           %接收计数器加1
          recbuf(rectr)=recdta ;                   %送入接收缓冲区
       elseif recdta==framelen&rcbuf(1)==0         %验证接收长度和帧头
          framelen=recdta ;                        %取帧长度
          rectr=rectr+1 ;                          %接收计数器加1
          recbuf(rectr)=recdta ;                   %送入接收缓冲区
       elseif rectr>1&rectr<framelen               %接收数据
          rectr=rectr+1 ;                          %接收计数器加1
          recbuf(rectr)=recdta ;                   %送入接收缓冲区
          if rectr==framelen                       %如果接收完进行处理
             rectr=0 ;                             %清接收计数器
             framenum=framenum+1 ;                 %帧数累加
             %可根据具体通讯协议提取数据，例如：x1Axis~size4

             x1Axis=(recbuf(3)*2^5)*2^9+(recbuf(3)*2^4)*2^8+recbuf(1);
             y1Axis=(recbuf(3)*2^7)*2^9+(recbuf(3)*2^6)*2^8+recbuf(2);
             size1=recbuf(3)*2^3+recbuf(3)*2^2+recbuf(3)*2^1+recbuf(3)*2^0;

             x2Axis=(recbuf(6)*2^5)*2^9+(recbuf(6)*2^4)*2^8+recbuf(4);
             y2Axis=(recbuf(6)*2^7)*2^9+(recbuf(6)*2^6)*2^8+recbuf(5);
             size2=recbuf(6)*2^3+recbuf(6)*2^2+recbuf(6)*2^1+recbuf(6)*2^0;

             x3Axis=(recbuf(9)*2^5)*2^9+(recbuf(9)*2^4)*2^8+recbuf(7);
             y3Axis=(recbuf(9)*2^7)*2^9+(recbuf(9)*2^6)*2^8+recbuf(8);
             size3=recbuf(6)*2^3+recbuf(6)*2^2+recbuf(6)*2^1+recbuf(6)*2^0;

             x4Axis=(recbuf(12)*2^5)*2^9+(recbuf(12)*2^4)*2^8+recbuf(10);
             y4Axis=(recbuf(12)*2^7)*2^9+(recbuf(12)*2^6)*2^8+recbuf(11);
             size4=recbuf(12)*2^3+recbuf(12)*2^2+recbuf(12)*2^1+recbuf(12)*2^0;
             %fprintf('%16x %16x %16x   %16x %16x %16x   %16x %16x %16x   %16x %16x %16x\n',x1Axis,y1Axis,size1,x2Axis,y2Axis,size2,x3Axis,y3Axis,size3,x4Axis,y4Axis,size4)      %输出显示
             %fprintf('%16x %16x %16x\n',x1Axis,y1Axis,size1)      %输出显示
             
             %可根据具体通讯协议取出数据
          end
       else rectr=0;            %未找到帧头清计数器
       end                      %接收结束
end                             %主循环结束

%程序结束关闭串口类
fclose(scom) ;                  %关闭串口
delete(scom) ;                  %删除串口对象
clear scom ;                    %清除变量
end




