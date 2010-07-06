
%%%%%%%%%%%%%%%%%%%%%%%%���ڽ��պ���%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%thomas1847,2007.1.22%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%ע����ѯ��ʽ
function serialcomm
%web -browser http://www.ilovematlab.cn/thread-1449-1-1.html
clear ;
clc ;                              %�������
scom=serial('com1') ;              %�������ڶ���
scom.baudrate=38400 ;              %���ò�����,ȱʡ38400bit/s
scom.parity='none' ;               %����żУ��
scom.stopbits=1 ;                  %ֹͣλ
scom.timeout=0.5 ;                 %���ö��������ʱ��Ϊ1s,ȱʡ10s
scom.inputbuffersize=256 ;         %���뻺����Ϊ32byte��ȱʡֵΪ512b

%����
recbuf=zeros(1,40) ;               %����ջ�������40��
framelen=13 ;                      %֡���ȣ�ÿ֡13byte)
framenum=0 ;                       %�����֡��
rectr=0 ;                          %���ռ���������
xctr=0 ;

%������յ�����֡��
recnum= input('������Ҫ���յ�����֡��:\n') ;        %�������֡��%��

%�򿪴����豸
fopen(scom) ;                                      %�򿪴����豸����scom

%�������ѭ��
while framenum<recnum                              %
       recdta=fread(scom,1,'uint8') ;              %��������
       if recdta==0                                %��֡ͷ,֡ͷΪ0
          rectr=rectr+1;                           %���ռ�������1
          recbuf(rectr)=recdta ;                   %������ջ�����
       elseif recdta==framelen&rcbuf(1)==0         %��֤���ճ��Ⱥ�֡ͷ
          framelen=recdta ;                        %ȡ֡����
          rectr=rectr+1 ;                          %���ռ�������1
          recbuf(rectr)=recdta ;                   %������ջ�����
       elseif rectr>1&rectr<framelen               %��������
          rectr=rectr+1 ;                          %���ռ�������1
          recbuf(rectr)=recdta ;                   %������ջ�����
          if rectr==framelen                       %�����������д���
             rectr=0 ;                             %����ռ�����
             framenum=framenum+1 ;                 %֡���ۼ�
             %�ɸ��ݾ���ͨѶЭ����ȡ���ݣ����磺x1Axis~size4

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
             %fprintf('%16x %16x %16x   %16x %16x %16x   %16x %16x %16x   %16x %16x %16x\n',x1Axis,y1Axis,size1,x2Axis,y2Axis,size2,x3Axis,y3Axis,size3,x4Axis,y4Axis,size4)      %�����ʾ
             %fprintf('%16x %16x %16x\n',x1Axis,y1Axis,size1)      %�����ʾ
             
             %�ɸ��ݾ���ͨѶЭ��ȡ������
          end
       else rectr=0;            %δ�ҵ�֡ͷ�������
       end                      %���ս���
end                             %��ѭ������

%��������رմ�����
fclose(scom) ;                  %�رմ���
delete(scom) ;                  %ɾ�����ڶ���
clear scom ;                    %�������
end




