function varargout = comdraw(varargin)
% COMDRAW M-file for comdraw.fig
%      COMDRAW, by itself, creates a new COMDRAW or raises the existing
%      singleton*.
%
%      H = COMDRAW returns the handle to a new COMDRAW or the handle to
%      the existing singleton*.
%
%      COMDRAW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in COMDRAW.M with the given input arguments.
%
%      COMDRAW('Property','Value',...) creates a new COMDRAW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before comdraw_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to comdraw_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help comdraw

% Last Modified by GUIDE v2.5 29-May-2007 16:33:53

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @comdraw_OpeningFcn, ...
                   'gui_OutputFcn',  @comdraw_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

global  handle_com;
global  serial_buf;

% --- Executes just before comdraw is made visible.
function comdraw_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to comdraw (see VARARGIN)

% Choose default command line output for comdraw
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes comdraw wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = comdraw_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function popup_com_port_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_com_port (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function comport_callback(obj, event)
%warning( 'COM recevice 16 bytes' );
global  seriala_buf;
%get( obj )
send_len = get( obj, 'BytesAvailable' );
serial_buf = fread( obj, 16,'uint8')
%get( event )

% --- Executes on selection change in popup_com_port.
function popup_com_port_Callback(hObject, eventdata, handles)
global  handle_com;
% hObject    handle to popup_com_port (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popup_com_port contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_com_port
sel_val = get(hObject,'Value');
com_str = get(hObject,'String');    %get COM ports list
sel_str = com_str{ sel_val };       %get old COM port name
handle_com = serial( sel_str );
baud_rate = get( handles.popup_baud_rate,'Value' );
data_bit = get( handles.popup_data_bit,'Value' );
stop_bit = get( handles.popup_stop_bit,'Value' );
parity = get( handles.popup_parity,'Value' );
%warning( 'COM port set-----------------------------' );
try
        switch baud_rate
            case    1
                handle_com.BaudRate=115200;
            case    2
                handle_com.BaudRate=57600;
            case    3
                handle_com.BaudRate=38400;
            case    4
                handle_com.BaudRate=19200;
            otherwise
                handle_com.BaudRate=9600;
        end
%        warning( 'COM baud rate-----------------------------' );
        switch data_bit
            case    1
                handle_com.DataBits=8;
            case    2
                handle_com.DataBits=7;
            case    3
                handle_com.DataBits=6;
            case    4
                handle_com.DataBits=5;
            otherwise
                handle_com.DataBits=8;
        end
        switch stop_bit
            case    1
                handle_com.StopBits=1;
            case    2
                handle_com.StopBits=1.5;
            case    3
                handle_com.StopBits=2;
            otherwise
               handle_com.StopBits=1;
       end
        switch parity
            case    1
                handle_com.Parity='none';
            case    2
                handle_com.Parity='odd';
            case    3
                handle_com.Parity='even';
            otherwise
                handle_com.Parity='none';
        end
        handle_com.InputBufferSize=1024;
        handle_com.timeout=0.5;
        handle_com.Terminator='LF';
        handle_com.FlowControl='none';
        handle_com.BytesAvailableFcnMode = 'byte';
        handle_com.BytesAvailableFcnCount = 16;
        handle_com.BytesAvailableFcn = @comport_callback;
%        handle_com.BytesAvailableFcn = @instrcallback;
%        handle_com.OutputEmptyFcn = @instrcallback;
        get( handle_com )
        fopen( handle_com );
%        warning( 'open COM ok' );
        set( hObject, 'Enable', 'off' );
        set( handles.popup_baud_rate,'Enable','off' );
        set( handles.popup_data_bit,'Enable','off' );
        set( handles.popup_stop_bit,'Enable','off' );
        set( handles.popup_parity,'Enable','off' );
%        fwrite(handle_com,'COM init OK');
%        out_data=fread(handle_com,16,'uint8')%接收32个数据（8位），并存入out数组中
%        warning( out_data );
%        fclose( handle_com );
%        delete( handle_com );
%        clear( handle_com );
catch
        fclose( handle_com );
        info_str = sprintf( '%s open failure, please select another!\n', sel_str);
        errordlg( info_str,'COM PORT ERROR','modal');
end




% --- Executes during object creation, after setting all properties.
function popup_baud_rate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_baud_rate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in popup_baud_rate.
function popup_baud_rate_Callback(hObject, eventdata, handles)
% hObject    handle to popup_baud_rate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popup_baud_rate contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_baud_rate


% --- Executes during object creation, after setting all properties.
function popup_data_bit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_data_bit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in popup_data_bit.
function popup_data_bit_Callback(hObject, eventdata, handles)
% hObject    handle to popup_data_bit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popup_data_bit contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_data_bit


% --- Executes during object creation, after setting all properties.
function popup_stop_bit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_stop_bit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in popup_stop_bit.
function popup_stop_bit_Callback(hObject, eventdata, handles)
% hObject    handle to popup_stop_bit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popup_stop_bit contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_stop_bit


% --- Executes during object creation, after setting all properties.
function popup_parity_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_parity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in popup_parity.
function popup_parity_Callback(hObject, eventdata, handles)
% hObject    handle to popup_parity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popup_parity contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_parity

% --- radio button mutual exclude function
function radio_mutual_exclude( h_on, h_off )
% h_on      handle to the selected radio button
% h_off     handle to all not selected radio buttons of same group

% Write by HouWu Wei
set( h_on, 'Value', 1 );
set( h_off, 'Value', 0 );

% --- Executes on button press in radio_hex_fmt.
function radio_hex_fmt_Callback(hObject, eventdata, handles)
% hObject    handle to radio_hex_fmt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio_hex_fmt
h_on  = handles.radio_hex_fmt;
h_off = handles.radio_asc_fmt;
radio_mutual_exclude( h_on, h_off );

% --- Executes on button press in radio_asc_fmt.
function radio_asc_fmt_Callback(hObject, eventdata, handles)
% hObject    handle to radio_asc_fmt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio_asc_fmt
h_on  = handles.radio_asc_fmt;
h_off = handles.radio_hex_fmt;
radio_mutual_exclude( h_on, h_off );

% --- Executes during object creation, after setting all properties.
function edit_send_box_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_send_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_send_box_Callback(hObject, eventdata, handles)
% hObject    handle to edit_send_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_send_box as text
%        str2double(get(hObject,'String')) returns contents of edit_send_box as a double


% --- ascii string to hex numbers
function hexnum = asciistr_to_hex_nums( ascStr )
% ascStr is need transf string
len = length( ascStr );
hexnum= [];
for k = 1:len;
    hexasc = ascStr(k);
    if hexasc>='0'&& hexasc<='9'
        hextmp = hexasc-'0';
    elseif hexasc>='A' && hexasc<='F'
        hextmp = hexasc-'A'+10;
    elseif hexasc>='a' && hexasc<='f'
        hextmp = hexasc-'a'+10;
    else
        hextmp = 0;
    end
    
    if bitand(k,1)==1;
        hexval = hextmp;
    else
        hexnum(k/2) = hexval*16+hextmp;
    end
end

% --- Executes on button press in pbutton_send_data.
function pbutton_send_data_Callback(hObject, eventdata, handles)
% hObject    handle to pbutton_send_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global  handle_com
txtstr = get( handles.edit_send_box, 'String' );
sendfmt = get( handles.radio_asc_fmt, 'Value' );
if  sendfmt==1.0
    fwrite( handle_com,txtstr );
else
    hexnum = asciistr_to_hex_nums( txtstr );
    fwrite( handle_com, hexnum );
    %len = length( hexnum );
    %for k = 1:len;
    %    fwrite( handle_com, hexnum(k) );
    %end
end
% --- Executes during object creation, after setting all properties.
function edit_dc1_offset_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_dc1_offset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_dc1_offset_Callback(hObject, eventdata, handles)
% hObject    handle to edit_dc1_offset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_dc1_offset as text
%        str2double(get(hObject,'String')) returns contents of edit_dc1_offset as a double


% --- Executes during object creation, after setting all properties.
function edit_ac1_amp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ac1_amp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_ac1_amp_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ac1_amp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ac1_amp as text
%        str2double(get(hObject,'String')) returns contents of edit_ac1_amp as a double


% --- Executes during object creation, after setting all properties.
function edit_dc2_offset_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_dc2_offset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_dc2_offset_Callback(hObject, eventdata, handles)
% hObject    handle to edit_dc2_offset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_dc2_offset as text
%        str2double(get(hObject,'String')) returns contents of edit_dc2_offset as a double


% --- Executes during object creation, after setting all properties.
function edit_ac2_amp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ac2_amp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_ac2_amp_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ac2_amp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ac2_amp as text
%        str2double(get(hObject,'String')) returns contents of edit_ac2_amp as a double


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global  handle_com
%com_str = get(handles.popup_com_port,'String');        %get COM ports list
%sel_val = get(handles.popup_com_port,'Value');        %get COM ports list
%sel_str = com_str{ sel_val };       %get old COM port name
%handle_com = serial( sel_str );
%fclose( handle_com );
%delete( handle_com );
%clear handle_com ;
try
    fclose( handle_com );
    delete( handle_com );
    clear handle_com ;
catch
    warning( 'Not find COM port opened' );
end
% Hint: delete(hObject) closes the figure
delete(hObject);


