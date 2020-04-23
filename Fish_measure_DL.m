function varargout = Fish_measure_DL(varargin)
% FISH_MEASURE_DL MATLAB code for Fish_measure_DL.fig
%      FISH_MEASURE_DL, by itself, creates a new FISH_MEASURE_DL or raises the existing
%      singleton*.
%
%      H = FISH_MEASURE_DL returns the handle to a new FISH_MEASURE_DL or the handle to
%      the existing singleton*.
%
%      FISH_MEASURE_DL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FISH_MEASURE_DL.M with the given input arguments.
%
%      FISH_MEASURE_DL('Property','Value',...) creates a new FISH_MEASURE_DL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Fish_measure_DL_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Fish_measure_DL_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Fish_measure_DL

% Last Modified by GUIDE v2.5 23-Apr-2020 17:29:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Fish_measure_DL_OpeningFcn, ...
                   'gui_OutputFcn',  @Fish_measure_DL_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

% End initialization code - DO NOT EDIT
end

% --- Executes just before Fish_measure_DL is made visible.
function Fish_measure_DL_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Fish_measure_DL (see VARARGIN)

% Choose default command line output for Fish_measure_DL
handles.output = hObject;

% 加载已训练的语义分割网络
Trainednetwork=load('trainingmask-crop-8-300.mat');
%Trainednetwork=load('trainingmask-8-100.mat');
net=Trainednetwork.net;
set(handles.Title,'userdata',net)

% Update handles structure
guidata(hObject, handles);
% UIWAIT makes Fish_measure_DL wait for user response (see UIRESUME)
% uiwait(handles.FM_background);
end

% --- Outputs from this function are returned to the command line.
function varargout = Fish_measure_DL_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end

% --- Executes on button press in openfile.
% 点击“打开文件”后执行流程
function openfile_Callback(hObject, eventdata, handles)
% hObject    handle to openfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
video_file=uigetfile('*.avi'); 
I=VideoReader(video_file);
set(handles.n,'userdata',I); % 通过控件属性的userdata实现不同控件函数之间数据调用
set(handles.filename,'String',video_file);

end

function n_Callback(hObject, eventdata, handles)
% hObject    handle to n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of n as text
%        str2double(get(hObject,'String')) returns contents of n as a double
I=get(handles.n,'userdata'); 
num=get(I,'numberOfFrames'); % 总帧数
n=str2num(get(handles.n,'String'));

% 确保起始帧在(1,总帧数)之间
if n>num || n<1
    prompt=strcat('起始帧应在1至',num2str(num),'之间,请重新输入');
    warndlg(prompt,'警告');
    uiwait
end
a=read(I,n);
axes(handles.Crop_img)
imshow(a)
set(handles.crop_n,'String',get(handles.n,'String'))
end

% --- Executes on button press in nextfig.
% 点击‘下一张’键的执行流程
function nextfig_Callback(hObject, eventdata, handles)
% hObject    handle to nextfig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
I=get(handles.n,'userdata'); 
num=get(I,'numberOfFrames'); % 总帧数
n=str2num(get(handles.crop_n,'String'));
n=n+1;
set(handles.crop_n,'String',num2str(n))
% 确保起始帧在(1,总帧数)之间
if n>num || n<1
    prompt=strcat('起始帧应在1至',num2str(num),'之间,请重新输入');
    warndlg(prompt,'警告');
    uiwait
end

a=read(I,n);
axes(handles.Crop_img)
imshow(a)
end

% --- Executes on button press in lastfig.
% 点击‘上一张’键的执行流程
function lastfig_Callback(hObject, eventdata, handles)
% hObject    handle to lastfig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
I=get(handles.n,'userdata'); 
num=get(I,'numberOfFrames'); % 总帧数
n=str2num(get(handles.crop_n,'String'));
n=n-1;
set(handles.crop_n,'String',num2str(n))
% 确保起始帧在(1,总帧数)之间
if n>num || n<1
    prompt=strcat('起始帧应在1至',num2str(num),'之间,请重新输入');
    warndlg(prompt,'警告');
    uiwait
end

a=read(I,n);
axes(handles.Crop_img)
imshow(a)
end

% --- Executes on button press in crop_button.
% 点击‘框选’键的执行流程
function crop_button_Callback(hObject, eventdata, handles)
% hObject    handle to crop_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.current_n,'String',[]);

I=get(handles.n,'userdata'); 
num=get(I,'numberOfFrames'); % 总帧数
n=str2num(get(handles.crop_n,'String'));

% 确保起始帧在(1,总帧数)之间
if n>num || n<1
    prompt=strcat('Please choose the frame between',num2str(num));
    warndlg(prompt,'Warning');
    uiwait
end

a=read(I,n);
figure(1);
[temp, rect] = imcrop(a);
close 1
% 显示框选区域的尺寸大小
set(handles.rec_Original,'String',strcat('[',num2str(rect(1)),',',num2str(rect(2)),']'));
set(handles.rec_Width,'String',num2str(rect(3)));
set(handles.rec_Height,'String',num2str(rect(4)));

set(handles.rec_Original,'userdata',temp);
set(handles.rec_Width,'userdata',rect);

axes(handles.Crop_img)
title('原始图像')
imshow(temp)
end

% 点击选择阈值时的执行流程
function bw_thre_Callback(hObject, eventdata, handles)
% hObject    handle to bw_thre (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of bw_thre as text
%        str2double(get(hObject,'String')) returns contents of bw_thre as a double
set(handles.bw_thre,'userdata',[]);
set(handles.show_thre,'String',get(handles.bw_thre,'value')); % 同步显示滑动条数值
temp=get(handles.rec_Original,'userdata');
rect=get(handles.rec_Width,'userdata');

switch get(handles.method_choice,'value')
    case 1
    %阈值法
        bw_thre=get(handles.bw_thre,'value');
        bw=abs(1-im2bw(temp,bw_thre));
        set(handles.bw_thre,'userdata',temp);
    case 2
    %Deep Learning
        ld_img=zeros(600,400,3);
%         ld_img=zeros(720,960,3);
        h=ceil((600-ceil(rect(4)))/2);%高度上边缘尺寸
        w=ceil((400-ceil(rect(3)))/2);%宽度上边缘尺寸
%         h=ceil((720-ceil(rect(4)))/2);%高度上边缘尺寸
%         w=ceil((960-ceil(rect(3)))/2);%宽度上边缘尺寸
        ld_img(h:h-1+ceil(rect(4)),w:w-1+ceil(rect(3)),:)=temp;%将所截图像放入空图的正中
        temp=uint8(ld_img);
        set(handles.bw_thre,'userdata',temp);
        
        net=get(handles.Title,'userdata');
        C=semanticseg(temp,net);
        bw = (C=='foreground');
end

axes(handles.bw_img)
title('二值化图')
imshow(bw)

remove=str2num(get(handles.remove,'String'));
se=strel('disk',2);
openbw=imclose(bw,se);
% openbw=abs(1-openbw);
BW = bwareaopen(openbw,remove);

skeletonizedImage = bwmorph(BW, 'skel', inf);
remtimes=str2num(get(handles.remtimes,'String'));
BW1 = bwmorph(skeletonizedImage,'spur',remtimes); % 去骨刺
% BW2 = bwmorph(BW1,'diag'); %将4连通区域变为8连通区域
[x11,y11]=find(BW1==1);

axes(handles.open_img)
imshow(BW)
hold on
plot(y11,x11,'r.') %plot的x,y相反可能与axes所建立的坐标轴有关
hold off
set(handles.bas_point,'userdata',[x11,y11]);

BW3 = bwmorph(BW1,'endpoint');
[x111,y111]=find(BW3==1);
axes(handles.Crop_img)
imshow(temp);
hold on
plot(y111,x111,'r.')
hold off
end

% --- Executes on button press in contitest_button.
% 点击‘连续测试’键的执行流程
function contitest_button_Callback(hObject, eventdata, handles)
% hObject    handle to contitest_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB

bas_rate=str2num(get(handles.bas_point,'String'));
test_time=str2double(get(handles.test_time,'String'));
I=get(handles.n,'userdata');
n=str2num(get(handles.crop_n,'String'));
rec_Original=str2num(get(handles.rec_Original,'String'));

% 确保选择的测试时间不超过总时长
start_time=n/I.FrameRate;
if (test_time+start_time)>I.duration
    prompt=strcat('起始时间',num2str(start_time),'秒与测试时间的加和已超过视频总长',num2str(I.duration),'秒，请重新输入');
    warndlg(prompt,'警告');
    uiwait
end

test_frames=fix(test_time*I.FrameRate);

% 建立空间存储fir_pot/dist/ang/COM
fir_pot=zeros(test_frames+1,2);
COM_pot=zeros(test_frames+1,2);
ang=zeros(test_frames+1,1);

rect=get(handles.rec_Width,'userdata'); %%
remove=str2num(get(handles.remove,'String'));
remtimes=str2num(get(handles.remtimes,'String'));

for i=n:n+test_frames
    set(handles.current_n,'String',num2str(i))
    a=read(I,i);
    temp=imcrop(a,rect);
    
    switch get(handles.method_choice,'value')
        case 1
            bw_thre=get(handles.bw_thre,'value');
            
            [fir_pot((i-n+1),1:2),basline]=calcu_distang(temp,bw_thre,remove,remtimes,bas_rate);
            % 绘制曲线图和中心基准线
            x11=basline(:,1);
            y11=basline(:,2);
            bas_point=fix(0.01*bas_rate*size(basline,1));
            axes(handles.Crop_img)
            imshow(temp,[],'parent',gca)
            hold on
            plot(y11,x11,'r.')
            plot(y11(1:bas_point),x11(1:bas_point),'bx')
            plot(fir_pot(i-n+1,2),fir_pot(i-n+1,1),'yx')
            COM_pot(i-n+1,1:2)=ginput(1); % 获取的坐标点基于plot的
            plot(COM_pot(i-n+1,1),COM_pot(i-n+1,2),'gx')
            hold off
            ang(i-n+1)=atan((fir_pot(i-n+1,1)-COM_pot(i-n+1,2))/(fir_pot(i-n+1,2)-COM_pot(i-n+1,1)))*180/pi;
            ang(ang<0)=ang(ang<0)+180;
        case 2
            ld_img=zeros(600,400,3);
%             ld_img=zeros(720,960,3);
            h=ceil((600-ceil(rect(4)))/2);%高度上边缘尺寸
            w=ceil((400-ceil(rect(3)))/2);%宽度上边缘尺寸
%             h=ceil((720-ceil(rect(4)))/2);%高度上边缘尺寸
%             w=ceil((960-ceil(rect(3)))/2);%宽度上边缘尺寸
            ld_img(h:h-1+ceil(rect(4)),w:w-1+ceil(rect(3)),:)=temp;%将所截图像放入空图的正中
            temp=uint8(ld_img);
            net=get(handles.Title,'userdata');
            
            [pot1,basline]=calcu_distang_dl(temp,net,remove,remtimes,bas_rate);
            fir_pot((i-n+1),1:2)=pot1+fliplr(rec_Original);
            % 绘制曲线图和中心基准线
            x11=basline(:,1);
            y11=basline(:,2);
            bas_point=fix(0.01*bas_rate*size(basline,1));
            axes(handles.Crop_img)
            imshow(temp,[],'parent',gca)
            hold on
            plot(y11,x11,'r.')
            plot(y11(1:bas_point),x11(1:bas_point),'bx')
            plot(pot1(2),pot1(1),'yx')
            COM_pot1=ginput(1); % 获取的坐标点基于plot的
            plot(COM_pot1(1),COM_pot1(2),'gx')
            COM_pot(i-n+1,1:2)=COM_pot1+rec_Original;
            hold off
            ang(i-n+1)=atan((fir_pot(i-n+1,1)-COM_pot(i-n+1,2))/(fir_pot(i-n+1,2)-COM_pot(i-n+1,1)))*180/pi;
            ang(ang<0)=ang(ang<0)+180;
    end
    
end
COM_vel=sqrt(sum(diff(COM_pot).^2,2));

set(handles.filename,'userdata',COM_vel)
set(handles.show_thre,'userdata',ang)
set(handles.test_time,'userdata',COM_pot)
% set(handles.avel_s2_90,'userdata',TBamp_Nsum);
end

% --- Executes on button press in export_data.
% 点击‘导出数据’键的执行流程
function export_data_Callback(hObject, eventdata, handles)
% hObject    handle to export_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
exp_name=string(inputdlg('请输入导出文件名称','导出文件命名',[1 50]));
xlstitle='COM'+string(['x';'y']);
COM_pot=get(handles.test_time,'userdata');
xlswrite(exp_name,xlstitle','COM坐标','A1')
xlswrite(exp_name,COM_pot,'COM坐标','A2')
xlstitle='COM'+string(['vel';'ang']);
COM_vel=get(handles.filename,'userdata');
COM_ang=get(handles.show_thre,'userdata');
xlswrite(exp_name,xlstitle','COM速度及角速度','A1')
xlswrite(exp_name,COM_vel,'COM速度及角速度','A2')
xlswrite(exp_name,COM_ang,'COM速度及角速度','B2')
helpdlg('数据导出完毕','导出完成提醒')
end

%-------------------------------------------------------------------------%
% 以下是暂未需要使用回调函数的控件，可暂时忽略
% --- Executes during object creation, after setting all properties.
function filename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to species (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','grey');
end
end

% --- Executes on selection change in species.
function species_Callback(hObject, eventdata, handles)
% hObject    handle to species (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = cellstr(get(hObject,'String')) returns species contents as cell array
%        contents{get(hObject,'Value')} returns selected item from species
end

% --- Executes during object creation, after setting all properties.
function species_CreateFcn(hObject, eventdata, handles)
% hObject    handle to species (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes during object creation, after setting all properties.
function n_CreateFcn(hObject, eventdata, handles)
% hObject    handle to n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes during object creation, after setting all properties.
function bw_thre_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bw_thre (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end

function bas_point_Callback(hObject, eventdata, handles)
% hObject    handle to bas_point (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of bas_point as text
%        str2double(get(hObject,'String')) returns contents of bas_point as a double
end

% --- Executes during object creation, after setting all properties.
function bas_point_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bas_point (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function test_time_Callback(hObject, eventdata, handles)
% hObject    handle to test_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of test_time as text
%        str2double(get(hObject,'String')) returns contents of test_time as a double
end

% --- Executes during object creation, after setting all properties.
function test_time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to test_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function remove_Callback(hObject, eventdata, handles)
% hObject    handle to remtimes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of remtimes as text
%        str2double(get(hObject,'String')) returns contents of remtimes as a double
end

% --- Executes during object creation, after setting all properties.
function remove_CreateFcn(hObject, eventdata, handles)
% hObject    handle to remove (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function remtimes_Callback(hObject, eventdata, handles)
% hObject    handle to remtimes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of remtimes as text
%        str2double(get(hObject,'String')) returns contents of remtimes as a double
end

% --- Executes during object creation, after setting all properties.
function remtimes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to remtimes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function FM_background_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fishnum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
end


% --- Executes on selection change in method_choice.
function method_choice_Callback(hObject, eventdata, handles)
% hObject    handle to method_choice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns method_choice contents as cell array
%        contents{get(hObject,'Value')} returns selected item from method_choice
switch get(handles.method_choice,'value')
    case 1
        set(handles.bw_thre,'style','slider')
        set(handles.show_thre,'visible','on')
    case 2
        set(handles.bw_thre,'style','pushbutton')
        set(handles.bw_thre,'String','Process Preview')
        set(handles.show_thre,'visible','off')
end
end

% --- Executes during object creation, after setting all properties.
function method_choice_CreateFcn(hObject, eventdata, handles)
% hObject    handle to method_choice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
