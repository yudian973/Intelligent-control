function varargout = chulisty(varargin)
% CHULISTY Application M-file for chulisty.fig
%    FIG = CHULISTY launch chulisty GUI.
%    CHULISTY('callback_name', ...) invoke the named callback.
% Last Modified by GUIDE v2.0 23-May-2005 18:06:55
if nargin == 0  % LAUNCH GUI
	fig = openfig(mfilename,'reuse');
	% Generate a structure of handles to pass to callbacks, and store it. 
	handles = guihandles(fig);
	guidata(fig, handles);
if nargout > 0
		varargout{1} = fig;
	end
elseif ischar(varargin{1}) % INVOKE NAMED SUBFUNCTION OR CALLBACK
	try
		if (nargout)
			[varargout{1:nargout}] = feval(varargin{:}); % FEVAL switchyard
		else
			feval(varargin{:}); % FEVAL switchyard
		end
	catch
		disp(lasterr);
	end
end
%| ABOUT CALLBACKS:
%| GUIDE automatically appends subfunction prototypes to this file, and 
%| sets objects' callback properties to call them through the FEVAL 
%| switchyard above. This comment describes that mechanism.
%|
%| Each callback subfunction declaration has the following form:
%| <SUBFUNCTION_NAME>(H, EVENTDATA, HANDLES, VARARGIN)
%|
%| The subfunction name is composed using the object's Tag and the 
%| callback type separated by '_', e.g. 'slider2_Callback',
%| 'figure1_CloseRequestFcn', 'axis1_ButtondownFcn'.
%|
%| H is the callback object's handle (obtained using GCBO).
%|
%| EVENTDATA is empty, but reserved for future use.
%|
%| HANDLES is a structure containing handles of components in GUI using
%| tags as fieldnames, e.g. handles.figure1, handles.slider2. This
%| structure is created at GUI startup using GUIHANDLES and stored in
%| the figure's application data using GUIDATA. A copy of the structure
%| is passed to each callback.  You can store additional information in
%| this structure at GUI startup, and you can change the structure
%| during callbacks.  Call guidata(h, handles) after changing your
%| copy to replace the stored original so that subsequent callbacks see
%| the updates. Type "help guihandles" and "help guidata" for more
%| information.
%|
%| VARARGIN contains any extra arguments you have passed to the
%| callback. Specify the extra arguments by editing the callback
%| property in the inspector. By default, GUIDE sets the property to:
%| <MFILENAME>('<SUBFUNCTION_NAME>', gcbo, [], guidata(gcbo))
%| Add any extra arguments after the last argument, before the final
%| closing parenthesis.
% --------------------------------------------------------------------
%�����������ص�����
% --------------------------------------------------------------------
function varargout = pushbutton1_Callback(h, eventdata, handles, varargin)
set(handles.pushbutton1,'Enable','off');   %�����������У����Ρ���������
set(handles.pushbutton7,'String','����Ҷ�任');  %��ʼ��������Ҷ�任����
set(handles.edit5,'Enable','off');         %�����������У����Ρ������ļ���������
m=1;                              %������־λ
n=1;
n1=0;
n2=1;
m1=1;
m2=1;
m3=1;
da=get(handles.edit5,'String');                %ȡ���ݱ����ļ���
signal_s1=get(handles.radiobutton9,'Value');     %ȡ�źŲɼ�����
set(handles.text15,'String',1);                 %��ʼ����־��
set(handles.text11,'String',0);
s=serial('COM3');                          %�򿪴���
set(s,'BaudRATE',1200);                     %���ô�������
set(s,'InputBufferSize',1);
set(s,'OutputBufferSize',1);
set(s,'Timeout',0.5);
answer=get(handles.text7,'String');            %ȡ��������
if strcmp(answer,'0.5')                      %���Ͳ�������
    fopen(s)
    fwrite(s,255);
    fwrite(s,50);                         %����ǰ����ʱֵ
    fwrite(s,18);                      %����ǰ����ʱֵ
    fclose(s);
elseif strcmp(answer,'1')
    fopen(s)
    fwrite(s,255);
    fwrite(s,70);
    fwrite(s,4);
    fclose(s);
elseif strcmp(answer,'1.5')
    fopen(s)
    fwrite(s,255);
    fwrite(s,66);
    fwrite(s,3);
    fclose(s);
elseif strcmp(answer,'2')
    fopen(s)
    fwrite(s,255);
    fwrite(s,48);
    fwrite(s,3);
    fclose(s);
elseif strcmp(answer,'2.5')
    fopen(s)
    fwrite(s,255);
    fwrite(s,59);
    fwrite(s,2);
    fclose(s);
elseif strcmp(answer,'3')
    fopen(s)
    fwrite(s,255);
    fwrite(s,48);
    fwrite(s,2);
    fclose(s);
elseif strcmp(answer,'3.5')
    fopen(s)
    fwrite(s,255);
    fwrite(s,40);
    fwrite(s,2);
    fclose(s);
elseif strcmp(answer,'4')
    fopen(s)
    fwrite(s,255);
    fwrite(s,34);
    fwrite(s,2);
    fclose(s);
elseif strcmp(answer,'4.5')
    fopen(s)
    fwrite(s,255);
    fwrite(s,29);
    fwrite(s,2);
    fclose(s);
elseif strcmp(answer,'5')
    fopen(s)
    fwrite(s,255);
    fwrite(s,26);
    fwrite(s,2);
    fclose(s);
elseif strcmp(answer,'5.5')
    fopen(s)
    fwrite(s,255);
    fwrite(s,23);
    fwrite(s,2);
    fclose(s);
elseif strcmp(answer,'6')
    fopen(s)
    fwrite(s,255);
    fwrite(s,48);
    fwrite(s,1);
    fclose(s);
elseif strcmp(answer,'6.5')
   fopen(s)
    fwrite(s,255);
    fwrite(s,44);
    fwrite(s,1);
    fclose(s);
else
    fopen(s)
    fwrite(s,255);
    fwrite(s,40);
    fwrite(s,1);
    fclose(s);
end
fopen(s);
fp=fopen(da,'ab');            %�����ݱ����ļ�
fwrite(s,1);               %�������ֽ����ź�
out=fread(s,1,'uint8');         %�������ݴ��俪ʼ�ź�
if signal_s1==1              
fclose(s);
end
if out==0
while(m>0)
       if signal_s1==1;          %�вɼ��ź����ͣ���Ϊ��Ƶ
         fopen(s);
       end
       a(n)=fread(s,1,'uint8');     %��������
       fwrite(fp,a(n));           %��������
       a(n)=4.961/255*a(n);      %��������
       if signal_s1==1;          %�вɼ��ź����ͣ���Ϊ��Ƶ
         fclose(s);
       end
       n=n+1;                %���������ۼ�
       if m3==1              %���޸���Ҷ�任����ʵʱ��ͼ
           plot(a);
       end
       drawnow;
       if n==1000              %���Ѳ���10 0 0 �㣬���Զ�������־
          m=0;
          m2=0;
       end
set(handles.text15,'String',n);   
set(handles.text8,'String',max(a));   %������ѹֵ��־��
set(handles.text9,'String',min(a));   %����С��ѹֵ��־��
set(handles.text10,'String',mean(a));  %��ƽ����ѹֵ��־��
disp_v=get(handles.text11,'String');   %ȡ�������ͱ�־��ֵ
         if (strcmp(disp_v,'2'))
            set(handles.edit3,'String',max(a));
            set(handles.radiobutton5,'Value',1);
            set(handles.radiobutton6,'Value',0);
            set(handles.radiobutton7,'Value',0);
            set(handles.radiobutton8,'Value',0);
        elseif strcmp(disp_v,'3')
            set(handles.edit3,'String',min(a));
            set(handles.radiobutton6,'Value',1);
            set(handles.radiobutton7,'Value',0);
            set(handles.radiobutton8,'Value',0);
        elseif strcmp(disp_v,'4')
            set(handles.edit3,'String',mean(a));
            set(handles.radiobutton5,'Value',0);
            set(handles.radiobutton6,'Value',0);
            set(handles.radiobutton7,'Value',1);
            set(handles.radiobutton8,'Value',0);
        elseif (strcmp(disp_v,'8')|strcmp(disp_v,'0'))
            set(handles.text3,'String','˲ʱ��ѹֵ��');
            set(handles.edit3,'String',a(n-1));
            set(handles.radiobutton5,'Value',0);
            set(handles.radiobutton6,'Value',0);
            set(handles.radiobutton7,'Value',0);
            set(handles.radiobutton8,'Value',1);
            m3=1;     %����Ҷ�任��־ 
        elseif strcmp(disp_v,'5')
            m=0;
        elseif strcmp(disp_v,'6')
            m=0;
            m1=0;
       elseif (strcmp(disp_v,'9')|strcmp(disp_v,'10'))
           m=0;
           m2=0;
       elseif strcmp(disp_v,'1')
           m3=0;     %����Ҷ�任��־
        else
           m=0;
        end
end
else
 warndlg('����ʧ��,������!!' ,'ϵͳ��Ϣ��ʾ');     %����ʧ����ʾ��Ϣ
end
if signal_s1==1
fopen(s);
end
fwrite(s,0);         %�������ݲɼ�ֹͣ����
fclose(fp);          %�ر����ݱ����ļ�
fclose(s);           %�رմ���
delete(s);
clear s;
set(handles.text11,'String',0);      %�����ֹͣ��־
set(handles.text15,'String',0);
set(handles.pushbutton1,'Enable','on');  %����ֹͣ������������ʹ��
set(handles.edit5,'Enable','on');        %����ֹͣ���������ļ���������ʹ��
if m1==0                         %�����˳��������£����˳�����ϵͳ
    m1=1;
    Close(gcf);
end
if m2==0
    m2=1;
    chulisty('pushbutton1_Callback',gcbo,[],guidata(gcbo)); 
end
% --------------------------------------------------------------------
%�� ֹͣ�����ص�����
% --------------------------------------------------------------------
function varargout = pushbutton2_Callback(h, eventdata, handles, varargin)
set(handles.text11,'String',5);     %����ֹͣ��ť��־
% --------------------------------------------------------------------
%���˳������ص�����
% --------------------------------------------------------------------
function varargout = pushbutton4_Callback(h, eventdata, handles, varargin)
exit_chu=get(handles.text15,'String');      %ȡϵͳ״̬��־
if strcmp(exit_chu,'0')         %��ϵͳ����������״̬����ر��˳�ϵͳ
    Close(gcf);
else
set(handles.text11,'String',6);    %��ϵͳ���ڲɼ����������˳���־λ
end
% --------------------------------------------------------------------
%���޸ġ����ص�����
% --------------------------------------------------------------------
function varargout = pushbutton5_Callback(h, eventdata, handles, varargin)
%����ʽ�Ի���
prompt={'�����µĲ�������:                       ��λ:KS/s'};
title='���������޸ĶԻ���';
lines=[1];
def={'0'};
answer=inputdlg(prompt,title,lines,def);       %ȡ������ֵ
if isempty(answer)
  answer=get(handles.text7,'String');      %�������룬��ȡԭ����ֵ
  set(handles.text7,'String',answer); 
else                                 %���򣬱Ƚ������Ƿ�Ϸ�
    if(strcmp(answer,'0.5')|strcmp(answer,'1')|strcmp(answer,'1.5')|strcmp(answer,'2')|...
        strcmp(answer,'2.5')|strcmp(answer,'3')|strcmp(answer,'3.5')|strcmp(answer,'4')...
       |strcmp(answer,'4.5')|strcmp(answer,'5')|strcmp(answer,'5.5')|strcmp(answer,'6')...
        |strcmp(answer,'6.5')|strcmp(answer,'7'))
              set(handles.text7,'String',answer);     %�Ϸ���ı����������ʾֵ
              set(handles.text11,'String',10);      %�������������Ѹı�־
   else                                      %���Ϸ����򵯳�������Ϣ
         button=questdlg('��������! ����������?','����Ի���','Yes','No','No');
         if strcmp(button,'Yes')
             %set(handles.text11,'String',10);
             chulisty('pushbutton5_Callback',gcbo,[],guidata(gcbo))
         elseif strcmp(button,'No')
           warndlg('�ѱ���ԭ���Ĳ�������' ,'ϵͳ��Ϣ��ʾ');
         end
     end
end
% --------------------------------------------------------------------
%����ѹ������Ͽ򡱻ص�����
% --------------------------------------------------------------------
function varargout = radiobutton8_Callback(h, eventdata, handles, varargin)
set(handles.text3,'String','˲ʱ��ѹֵ��');
set(handles.text11,'String',8);
g=get(handles.text10,'String');
set(handles.edit3,'String',g);
set(handles.radiobutton6,'Value',0);
set(handles.radiobutton5,'Value',0);
set(handles.radiobutton7,'Value',0);
% --------------------------------------------------------------------
function varargout = radiobutton5_Callback(h, eventdata, handles, varargin)
set(handles.text3,'String','����ѹֵ��');
set(handles.text11,'String',2);
g=get(handles.text8,'String');
set(handles.edit3,'String',g);
set(handles.radiobutton6,'Value',0);
set(handles.radiobutton7,'Value',0);
set(handles.radiobutton8,'Value',0);
% --------------------------------------------------------------------
function varargout = radiobutton6_Callback(h, eventdata, handles, varargin)
set(handles.text3,'String','��С��ѹֵ��');
set(handles.text11,'String',3);
g=get(handles.text9,'String');
set(handles.edit3,'String',g);
set(handles.radiobutton5,'Value',0);
set(handles.radiobutton7,'Value',0);
set(handles.radiobutton8,'Value',0);
% --------------------------------------------------------------------
function varargout = radiobutton7_Callback(h, eventdata, handles, varargin)
set(handles.text3,'String','ƽ����ѹֵ��');
set(handles.text11,'String',4);
g=get(handles.text10,'String');
set(handles.edit3,'String',g);
set(handles.radiobutton6,'Value',0);
set(handles.radiobutton5,'Value',0);
set(handles.radiobutton8,'Value',0);
% --------------------------------------------------------------------
%������Ҷ�任�����ص�����
% --------------------------------------------------------------------
function varargout = pushbutton7_Callback(h, eventdata, handles, varargin)
tag_fft=get(handles.pushbutton7,'String');
dat_save=get(handles.edit5,'String');
char_n=get(handles.text15,'String');
val=str2num(char_n)
if strcmp(tag_fft,'����Ҷ�任')
    if val~=0
      set(handles.text11,'String',1);
      fp=fopen(dat_save,'rb');
      a=fread(fp,'uint8');
      fp=fopen(dat_save,'ab');
      a=4.961/255*a;
      X=fft(a);
      N=length(X);
      cn=X/N;
      z_cn=find(abs(cn)<1.0e-10);
      cn(z_cn)=zeros(length(z_cn),1);
      cn_SH=fftshift(cn);
      stem(abs(cn_SH));
  else
      fp=fopen(dat_save,'rb');
      a=fread(fp,'uint8');
      fclose(fp);
      a=4.961/255*a;
      X=fft(a);
      N=length(X);
      cn=X/N;
      z_cn=find(abs(cn)<1.0e-10);
      cn(z_cn)=zeros(length(z_cn),1);
      cn_SH=fftshift(cn);
      stem(abs(cn_SH));
end
set(handles.pushbutton7,'String','����');
else
    if val~=0
  %set(handles.text11,'String',11);
  set(handles.pushbutton7,'String','����Ҷ�任');
  set(handles.text11,'String',8); 
else
    fp=fopen(dat_save,'rb');
    a=fread(fp,'uint8');
    fclose(fp);
    a=4.961/255*a;
    plot(a)
    set(handles.pushbutton7,'String','����Ҷ�任');
end
end
% --------------------------------------------------------------------
%�����������ص�����
% --------------------------------------------------------------------
function varargout = pushbutton8_Callback(h, eventdata, handles, varargin)
set(handles.text11,'String',9);
x=0;
plot(x);
% --------------------------------------------------------------------
%���ɼ��ź����͡����ƿ�ص�����
% --------------------------------------------------------------------
function varargout = radiobutton9_Callback(h, eventdata, handles, varargin)
tag=get(handles.text15,'String');
if strcmp(tag,'0')
set(handles.radiobutton9,'Value',1);
set(handles.radiobutton10,'Value',0);
set(handles.radiobutton9,'Enable','inactive');
set(handles.radiobutton10,'Enable','on')
else
     warndlg('����ֹͣ���ݲɼ�' ,'ϵͳ��Ϣ��ʾ');
     set(handles.radiobutton9,'Value',0);
end
% --------------------------------------------------------------------
function varargout = radiobutton10_Callback(h, eventdata, handles, varargin)
tag=get(handles.text15,'String');
if strcmp(tag,'0')
    set(handles.radiobutton9,'Value',0);
set(handles.radiobutton10,'Value',1);
set(handles.radiobutton10,'Enable','inactive');
set(handles.radiobutton9,'Enable','on')
else
    warndlg('����ֹͣ���ݲɼ�' ,'ϵͳ��Ϣ��ʾ');
    set(handles.radiobutton10,'Value',0);

end
