
%%%%%%%%%%%%%%%%%%%%%%%%���ڽ��պ���%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%thomas1847,2007.1.22%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%ע����ѯ��ʽ
function serialcomm                                                        
web -browser http://www.ilovematlab.cn/thread-1449-1-1.html
clear;clc;                                                                 %������� 
g=serial('com1');                                                          %�������ڶ���
g.baudrate=2400;                                                           %���ò�����,ȱʡ9600bit/s
g.parity='none';                                                           %����żУ��
g.stopbits=1;                                                              %ֹͣλ
g.timeout=0.5;                                                             %���ö��������ʱ��Ϊ1s,ȱʡ10s                                           
g.inputbuffersize=256;                                                     %���뻺����Ϊ32b��ȱʡֵΪ512b
%����
recbuf=zeros(1,40);                                                        %����ջ�������40��        
framelen=23;                                                               %֡���ȣ�ÿ֡23byte)
framenum=0;                                                                %�����֡��
rectr=0;                                                                   %���ռ���������
xctr=0;
%������յ�����֡��
recnum= input('������Ҫ���յ�����֡��:\n');                                 %�������֡��                                                                      %��  
%�򿪴����豸
fopen(g);                                                                  %�򿪴����豸����g
%�������ѭ��
while framenum<recnum                                                      %
       recdta=fread(g,1,'uint8');                                          %��������
       if recdta==255                                                      %��֡ͷ
          rectr=rectr+1;                                                   %���ռ�������1
          recbuf(rectr)=recdta;                                            %������ջ�����      
       elseif recdta==framelen&rcbuf(1)==255                               %��֤���ճ��Ⱥ�֡ͷ
          framelen=recdta;                                                 %ȡ֡����
          rectr=rectr+1;                                                   %���ռ�������1
          recbuf(rectr)=recdta;                                            %������ջ�����
       elseif rectr>1&rectr<framelen                                       %��������
          rectr=rectr+1;                                                   %���ռ�������1
          recbuf(rectr)=recdta;                                            %������ջ�����
          if rectr==framelen                                               %�����������д��� 
             rectr=0;                                                      %����ռ�����
             framenum=framenum+1;                                          %֡���ۼ�
             %�ɸ��ݾ���ͨѶЭ����ȡ���ݣ����磺data1~data4
             data1=(recbuf(3)*256^3+recbuf(4)*256^2+recbuf(5)*256+recbuf(6))/100;      %����ԭʼ����
             data2=(recbuf(7)*256^3+recbuf(8)*256^2+recbuf(9)*256+recbuf(10))/100;     %���շ����Բ����������
             data3=(recbuf(11)*256^3+recbuf(12)*256^2+recbuf(13)*256+recbuf(14))/100;  %������䲹���������
             data4=(recbuf(15)*256^3+recbuf(16)*256^2+recbuf(17)*256+recbuf(18))/100;  %�����˲��������
             fprintf('%8.2f    %8.2f   %8.2f    %8.2f\n',data1,data2,data3,data4)      %�����ʾ
             %�ɸ��ݾ���ͨѶЭ��ȡ������
          end
       else rectr=0;                                                       %δ�ҵ�֡ͷ�������
       end                                                                 %���ս���   
end                                                                        %��ѭ������                                                                                
%��������رմ�����
fclose(g);                                                                 %�رմ���                                                                
delete(g);                                                                 %ɾ�����ڶ���
clear g ;                                                                  %�������
end

        
       

        