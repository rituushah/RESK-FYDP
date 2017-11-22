function varargout = GUI(varargin)
% GUI MATLAB code for GUI.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI

% Last Modified by GUIDE v2.5 20-Nov-2017 23:36:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_OutputFcn, ...
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

% --- Executes just before GUI is made visible.
function GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI (see VARARGIN)

% Choose default command line output for GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);
end

% --- Outputs from this function are returned to the command line.
function varargout = GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

end
% --- Executes on button press in Record.
function Record_Callback(hObject, eventdata, handles)
% hObject    handle to Record (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

MVC_required = str2double(get(handles.edit3, 'string'));
time_required = str2double(get(handles.edit4, 'string'));
is_correct = exercise(MVC_required, time_required);
% is_correct_conversion = int2str(is_correct);
% set(handles.text11,'string', is_correct_conversion);

if(is_correct) == 0
    a = imread('bad.jpg');
    axes(handles.axes1);
    imshow(a);
    set(handles.text11,'string', 'Try again');
else 
    a = imread('good.jpg');
    axes(handles.axes1);
    imshow(a);
    set(handles.text11,'string', 'Good job! You did it!');
end

end


function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double

end
% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double

end
% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function is_correct = exercise(MVC_required, time_required )



%1 - Data from flexvolt collected with shirley (3 pulses, no MVC)
%2 - Data for eliza flat knee flex and MVC 
%3 - Cometa data 
%4 - Kassy Data

%TESTING 

file = 2; 

if file == 1 
    load('2017-10-26'); 
elseif file == 2
    load('2017-11-06')
    MVC = C1_Raw_MVC_Trial2; 
    fs = 2000; 
elseif file == 3
    load('Cometa')
    C1_Raw_MVC_2 = MVC_Quad_C1;
    C1_Raw_2 = Squat_C1;
    fs = 4096; 
elseif file == 4
    load ('Kassy_2017-11-16')
    C1_Raw_MVC_2 = C1_K_MVC;
    C1_Raw_2 = C1_K_Trial; 
    fs = 2000; 
end 

%If flexvolt data, cutting them to be same legnth and detrending 
if file == 2
    C1_Raw_2 = Length_Cut(C1_Raw, MVC); 
    C1_Raw_2 = detrend(C1_Raw_2); 
    C1_Raw_MVC_2 = detrend(MVC); 
end 

%Make Time vector to the length of MVC
Time_MVC = Time_Vector(fs,C1_Raw_MVC_2);
Time_Exercise = Time_Vector(fs,C1_Raw_2); 

%Gets rid of the random spikes in data 
C1_Raw_2 = medfilt1(C1_Raw_2,3); 
C1_Filtered = C1_Raw_2; 

%MVC random spike filtering 
C1_Raw_MVC_2 = medfilt1(C1_Raw_MVC_2,3); 
C1_Filtered_MVC = C1_Raw_MVC_2; 

%Butterworth filter 
Wnhigh = 500; 
Wnlow = 10; 
[b,a] = butter(5, [Wnlow Wnhigh]/(fs/2), 'bandpass');
C1_Filtered = filter(b,a, C1_Filtered);
C1_Filtered_MVC = filter(b,a, C1_Filtered_MVC); 

%Rectification 
C1_Filtered = abs(C1_Filtered); 
C1_Filtered_MVC = abs(C1_Filtered_MVC); 


%Liear envelope of EMG signal
C1_Envelope = C1_Filtered; 
[c,d] = butter(5, 1/(fs/2), 'low');
C1_Envelope = filter(c,d,C1_Envelope);
C1_MVC_Envelope = filter(c,d,C1_Filtered_MVC); 

%Find Max
Max = Find_MVC(C1_MVC_Envelope);
C1_Mean = movingmean(C1_Envelope, 2000, 1, 1); 

MVC_flag = Max*(MVC_required/100); 
Timer = false; 
T1 = false; 
T2 = false; 
Tlow = 0;
Thigh = 0; 
i = 1; 
l1 = length(C1_Mean); 
time_set = time_required; 
correct = false;

while (i <= l1 & Timer == false)
    value = C1_Mean(i); 
    
    if (value >= MVC_flag & T1 == false)
        Tlow = Time_Exercise(i);
        T1 = true;
    end 
    
    if (value < MVC_flag & T1 == true && T2 == false)
        Thigh = Time_Exercise(i-1);
        T2 = true;
    end 
    
    difference = Thigh - Tlow;
    
    if (difference > time_set)
       disp('You r successful') 
       Timer = true;
       correct = true;
    elseif (T1 == true & T2 == true)
       T1 = false;
       T1 = false; 
       disp('You failed') 
    end 
    
    i = i+1; 
end 
is_correct = correct;

end

function Max = Find_MVC(C1_MVC_Envelope)
    MVC_mean = movingmean(C1_MVC_Envelope, 3000, 1, 1);
    Max = max(MVC_mean);  
end


    
