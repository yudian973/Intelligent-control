
%%%%%%%%%%%%%%%%%%%%%%%%串口接收函数%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%thomas1847,2007.1.22%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%注：查询方式
function serialcomm                                                        
web -browser http://www.ilovematlab.cn/thread-1449-1-1.html
clear;clc;                                                                 %清除变量 
g=serial('com1');                                                          %创建串口对象
g.baudrate=2400;                                                           %设置波特率,缺省9600bit/s
g.parity='none';                                                           %无奇偶校验
g.stopbits=1;                                                              %停止位
g.timeout=0.5;                                                             %设置读操作完成时间为1s,缺省10s                                           
g.inputbuffersize=256;                                                     %输入缓冲区为32b，缺省值为512b
%设置
recbuf=zeros(1,40);                                                        %清接收缓冲区（40）        
framelen=23;                                                               %帧长度（每帧23byte)
framenum=0;                                                                %清接收帧数
rectr=0;                                                                   %接收计数器清零
xctr=0;
%输入接收的数据帧数
recnum= input('请输入要接收的数据帧数:\n');                                 %输入接收帧数                                                                      %清  
%打开串口设备
fopen(g);                                                                  %打开串口设备对象g
%进入接收循环
while framenum<recnum                                                      %
       recdta=fread(g,1,'uint8');                                          %读入数据
       if recdta==255                                                      %找帧头
          rectr=rectr+1;                                                   %接收计数器加1
          recbuf(rectr)=recdta;                                            %送入接收缓冲区      
       elseif recdta==framelen&rcbuf(1)==255                               %验证接收长度和帧头
          framelen=recdta;                                                 %取帧长度
          rectr=rectr+1;                                                   %接收计数器加1
          recbuf(rectr)=recdta;                                            %送入接收缓冲区
       elseif rectr>1&rectr<framelen                                       %接收数据
          rectr=rectr+1;                                                   %接收计数器加1
          recbuf(rectr)=recdta;                                            %送入接收缓冲区
          if rectr==framelen                                               %如果接收完进行处理 
             rectr=0;                                                      %清接收计数器
             framenum=framenum+1;                                          %帧数累加
             %可根据具体通讯协议提取数据，例如：data1~data4
             data1=(recbuf(3)*256^3+recbuf(4)*256^2+recbuf(5)*256+recbuf(6))/100;      %接收原始数据
             data2=(recbuf(7)*256^3+recbuf(8)*256^2+recbuf(9)*256+recbuf(10))/100;     %接收非线性补偿后的数据
             data3=(recbuf(11)*256^3+recbuf(12)*256^2+recbuf(13)*256+recbuf(14))/100;  %接收蠕变补偿后的数据
             data4=(recbuf(15)*256^3+recbuf(16)*256^2+recbuf(17)*256+recbuf(18))/100;  %接收滤波后的数据
             fprintf('%8.2f    %8.2f   %8.2f    %8.2f\n',data1,data2,data3,data4)      %输出显示
             %可根据具体通讯协议取出数据
          end
       else rectr=0;                                                       %未找到帧头清计数器
       end                                                                 %接收结束   
end                                                                        %主循环结束                                                                                
%程序结束关闭串口类
fclose(g);                                                                 %关闭串口                                                                
delete(g);                                                                 %删除串口对象
clear g ;                                                                  %清除变量
end

        
       

        