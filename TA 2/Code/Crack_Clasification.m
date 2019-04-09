function varargout = Crack_Clasification(varargin)
clc
% CRACK_CLASIFICATION MATLAB code for Crack_Clasification.fig
%      CRACK_CLASIFICATION, by itself, creates a new CRACK_CLASIFICATION or raises the existing
%      singleton*.
%
%      H = CRACK_CLASIFICATION returns the handle to a new CRACK_CLASIFICATION or the handle to
%      the existing singleton*.
%
%      CRACK_CLASIFICATION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CRACK_CLASIFICATION.M with the given input arguments.
%
%      CRACK_CLASIFICATION('Property','Value',...) creates a new CRACK_CLASIFICATION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Crack_Clasification_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Crack_Clasification_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Crack_Clasification

% Last Modified by GUIDE v2.5 08-Mar-2019 01:35:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Crack_Clasification_OpeningFcn, ...
                   'gui_OutputFcn',  @Crack_Clasification_OutputFcn, ...
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


% --- Executes just before Crack_Clasification is made visible.
function Crack_Clasification_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Crack_Clasification (see VARARGIN)

% Choose default command line output for Crack_Clasification
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Crack_Clasification wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Crack_Clasification_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Header.
function Header_Callback(hObject, eventdata, handles)
% hObject    handle to Header (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Browse.
function Browse_Callback(hObject, eventdata, handles)
global Img_asli 
[filename,pathname] = uigetfile('*.jpg');
Img_asli = imread(fullfile(pathname,filename));
axes(handles.Asli);
imshow(Img_asli);


% --- Executes on button press in Biner.
function Biner_Callback(hObject, eventdata, handles)
global Img_asli L

I = double(rgb2gray(Img_asli));
%figure, imshow(I,[]);
 
% Konvolusi dengan operator Roberts
robertshor = [0 1; -1 0];
robertsver = [1 0; 0 -1];
Ix = conv2(I,robertshor,'same');
Iy = conv2(I,robertsver,'same');
J = sqrt((Ix.^2)+(Iy.^2));
 
% Gambar Hasil
%figure,imshow(Ix,[]);
%figure,imshow(Iy,[]);
%figure,imshow(J,[]);
 
K = uint8(J);
L = im2bw(K,.05);
axes(handles.HasilBiner);
imshow(L);

function Filter_Callback(hObject, eventdata, handles)
global L Z N
%%Morphological filtering
M = imfill(L,'holes');
N = bwareaopen(M,100);
axes(handles.HasilFilter);
imshow(N);
Z=Binary(N);
        
function Segmentasi_Callback(hObject, eventdata, handles)
global Z N
%%Segmented character
%%Initialisation
[row,col]=size(N);
Ib=im2bw(N);

%%proses
stats=regionprops(Ib,{'centroid','boundingbox','extrema'});
axes(handles.HasilSegmentasi);
imshow(Z);
hold on;

function Ekstrak_Callback(hObject, eventdata, handles)
global Z Fitur_GLCM
Fitur_GLCM = GLCMprocess(Z);
set(handles.TabelSigle,'Data',Fitur_GLCM);
set(handles.ProsesSigle,'String','Selesai');



function ProsesSigle_Callback(hObject, eventdata, handles)
% hObject    handle to ProsesSigle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ProsesSigle as text
%        str2double(get(hObject,'String')) returns contents of ProsesSigle as a double


% --- Executes during object creation, after setting all properties.
function ProsesSigle_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ProsesSigle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in StartTraining.
function StartTraining_Callback(hObject, eventdata, handles)
% hObject    handle to StartTraining (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function ProsesTraining_Callback(hObject, eventdata, handles)
% hObject    handle to ProsesTraining (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ProsesTraining as text
%        str2double(get(hObject,'String')) returns contents of ProsesTraining as a double


% --- Executes during object creation, after setting all properties.
function ProsesTraining_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ProsesTraining (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in EkstrakAll.
function EkstrakAll_Callback(hObject, eventdata, handles)
global Fitur_GLCM lewati1 lewati2 lewati3

path_folder_positif = get(handles.PathPositif,'String');
path_folder_negatif = get(handles.PathNegatif,'String');

jum_positif = str2num(get(handles.JumPositif,'String'));
jum_negatif = str2num(get(handles.JumNegatif,'String'));
jum_total = (jum_positif + jum_negatif)*7;

Fitur_GLCM = zeros(jum_total,23);

lewati1 = get(handles.Lewat1,'String');
lewati2 = get(handles.Lewat2,'String');
lewati3 = get(handles.Lewat3,'String');
counter_positif = 0;
counter_negatif = (jum_total/2);

tic
for x = 1 : 10
    if ((x ~= str2num(lewati1)) && (x ~= str2num(lewati2)) && (x ~= str2num(lewati3)))
        full_path_positif=strcat(path_folder_positif,'\',int2str(x),'\');
        filenames_positif = dir(fullfile(full_path_positif, '*.jpg'));
        for y =1 : jum_positif
            counter_positif = counter_positif + 1;
            full_name_positif= fullfile(full_path_positif, filenames_positif(y).name);
            our_images_positif = imread(full_name_positif);
            I = double(rgb2gray(our_images_positif));
            
            % Konvolusi ke Biner dengan operator Roberts
            robertshor = [0 1; -1 0];
            robertsver = [1 0; 0 -1];
            Ix = conv2(I,robertshor,'same');
            Iy = conv2(I,robertsver,'same');
            J = sqrt((Ix.^2)+(Iy.^2));

            K = uint8(J);
            L = im2bw(K,.05);
            
            %Morphological filtering
            M = imfill(L,'holes');
            N = bwareaopen(M,100);
            Z=Binary(N);
            
            %Segmented character
            [row,col]=size(N);
            Ib=im2bw(N);

            %%proses
            stats=regionprops(Ib,{'centroid','boundingbox','extrema'});
            hold on;
            
            %figure, imshow(Z);
            
            %GLCM
            Fitur_GLCM(counter_positif,:) = GLCMprocess(Z);
            Fitur_GLCM(counter_positif,23) = 2;
        end
        
        full_path_negatif=strcat(path_folder_negatif,'\',int2str(x),'\');
        filenames_negatif = dir(fullfile(full_path_negatif, '*.jpg'));
        for y =1 : jum_negatif
            counter_negatif = counter_negatif + 1;
            full_name_negatif= fullfile(full_path_negatif, filenames_negatif(y).name);
            our_images_negatif = imread(full_name_negatif);
            I = double(rgb2gray(our_images_negatif));
            
            % Konvolusi ke Biner dengan operator Roberts
            robertshor = [0 1; -1 0];
            robertsver = [1 0; 0 -1];
            Ix = conv2(I,robertshor,'same');
            Iy = conv2(I,robertsver,'same');
            J = sqrt((Ix.^2)+(Iy.^2));

            K = uint8(J);
            L = im2bw(K,.05);
            
            %Morphological filtering
            M = imfill(L,'holes');
            N = bwareaopen(M,100);
            Z=Binary(N);
            
            %Segmented character
            [row,col]=size(N);
            Ib=im2bw(N);

            %%proses
            stats=regionprops(Ib,{'centroid','boundingbox','extrema'});
            hold on;
            
            %figure, imshow(Z);
            
            %GLCM
            Fitur_GLCM(counter_negatif,:) = GLCMprocess(Z);
            Fitur_GLCM(counter_negatif,23) = 1;
        end
        
    end
end
toc

set(handles.TabelSigle,'Data',Fitur_GLCM);
set(handles.ProsesMulti,'String','Selesai');

function PathPositif_Callback(hObject, eventdata, handles)
% hObject    handle to PathPositif (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PathPositif as text
%        str2double(get(hObject,'String')) returns contents of PathPositif as a double


% --- Executes during object creation, after setting all properties.
function PathPositif_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PathPositif (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PathNegatif_Callback(hObject, eventdata, handles)
% hObject    handle to PathNegatif (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PathNegatif as text
%        str2double(get(hObject,'String')) returns contents of PathNegatif as a double


% --- Executes during object creation, after setting all properties.
function PathNegatif_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PathNegatif (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ProsesMulti_Callback(hObject, eventdata, handles)
% hObject    handle to ProsesMulti (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ProsesMulti as text
%        str2double(get(hObject,'String')) returns contents of ProsesMulti as a double


% --- Executes during object creation, after setting all properties.
function ProsesMulti_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ProsesMulti (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in SaveMulti.
function SaveMulti_Callback(hObject, eventdata, handles)
global Fitur_GLCM lewati1 lewati2 lewati3
path = 'G:\CRS\BERKAS\TA\TA 2\Code\Hasil Ekstraksi\';
nama_versi = strcat(lewati1,lewati2,lewati3);
nama_file = strcat('hasil_',nama_versi);
nama_hasil_mat = strcat(path,'mat\',nama_file,'.mat');
nama_hasil_xls = strcat(path,'xlsx\',nama_file,'.xlsx');
save (nama_hasil_mat,'Fitur_GLCM');
xlswrite(nama_hasil_xls,Fitur_GLCM);
set(handles.ProsesSaveMulti,'String','Sukses');

function ProsesSaveMulti_Callback(hObject, eventdata, handles)
% hObject    handle to ProsesSaveMulti (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ProsesSaveMulti as text
%        str2double(get(hObject,'String')) returns contents of ProsesSaveMulti as a double


% --- Executes during object creation, after setting all properties.
function ProsesSaveMulti_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ProsesSaveMulti (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in LoadTraining.
function LoadTraining_Callback(hObject, eventdata, handles) 
global Fitur_GLCM
[x,y] = uigetfile('*.mat', 'Load Data');
set(handles.ProsesLoadTraining,'String','Load Data Succes');
path = strcat(y,x);
load(path);
set(handles.TabelSigle,'Data',Fitur_GLCM);

function ProsesLoadTraining_Callback(hObject, eventdata, handles)
% hObject    handle to ProsesLoadTraining (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ProsesLoadTraining as text
%        str2double(get(hObject,'String')) returns contents of ProsesLoadTraining as a double


% --- Executes during object creation, after setting all properties.
function ProsesLoadTraining_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ProsesLoadTraining (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in BtnImageTest.
function BtnImageTest_Callback(hObject, eventdata, handles)
global Img_test
set(handles.HasilTest,'String','-');
[filename,pathname] = uigetfile('*.jpg');
Img_test = imread(fullfile(pathname,filename));
axes(handles.ImageTest);
imshow(Img_test);
            
% --- Executes on button press in RunTest.
function RunTest_Callback(hObject, eventdata, handles)
global Fitur_GLCM Img_test

I = double(rgb2gray(Img_test));
            
% Konvolusi ke Biner dengan operator Roberts
robertshor = [0 1; -1 0];
robertsver = [1 0; 0 -1];
Ix = conv2(I,robertshor,'same');
Iy = conv2(I,robertsver,'same');
J = sqrt((Ix.^2)+(Iy.^2));

K = uint8(J);
L = im2bw(K,.05);

%Morphological filtering
M = imfill(L,'holes');
N = bwareaopen(M,100);
Z=Binary(N);

%Segmented character
[row,col]=size(N);
Ib=im2bw(N);

%%proses
stats=regionprops(Ib,{'centroid','boundingbox','extrema'});
hold on;

%figure, imshow(Z);

%GLCM
Fitur_GLCM_test(1,:) = GLCMprocess(Z);
Fitur_GLCM_training = Fitur_GLCM(:,1:22);
Label = Fitur_GLCM(:,23);

%SVM
svm=MSvm(Fitur_GLCM_training,Label,Fitur_GLCM_test(:,1:22));
status_retakan = 'Tidak ditemukan';

if (svm == 2)
    status_retakan = 'Positif';
end
if (svm == 1)
    status_retakan = 'Negatif';
end
set(handles.HasilTest,'String',status_retakan);


function HasilTest_Callback(hObject, eventdata, handles)
% hObject    handle to HasilTest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of HasilTest as text
%        str2double(get(hObject,'String')) returns contents of HasilTest as a double


% --- Executes during object creation, after setting all properties.
function HasilTest_CreateFcn(hObject, eventdata, handles)
% hObject    handle to HasilTest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function JumPositif_Callback(hObject, eventdata, handles)
% hObject    handle to JumPositif (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of JumPositif as text
%        str2double(get(hObject,'String')) returns contents of JumPositif as a double


% --- Executes during object creation, after setting all properties.
function JumPositif_CreateFcn(hObject, eventdata, handles)
% hObject    handle to JumPositif (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function JumNegatif_Callback(hObject, eventdata, handles)
% hObject    handle to JumNegatif (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of JumNegatif as text
%        str2double(get(hObject,'String')) returns contents of JumNegatif as a double


% --- Executes during object creation, after setting all properties.
function JumNegatif_CreateFcn(hObject, eventdata, handles)
% hObject    handle to JumNegatif (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Lewat1_Callback(hObject, eventdata, handles)
% hObject    handle to Lewat1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Lewat1 as text
%        str2double(get(hObject,'String')) returns contents of Lewat1 as a double


% --- Executes during object creation, after setting all properties.
function Lewat1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Lewat1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Lewat2_Callback(hObject, eventdata, handles)
% hObject    handle to Lewat2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Lewat2 as text
%        str2double(get(hObject,'String')) returns contents of Lewat2 as a double


% --- Executes during object creation, after setting all properties.
function Lewat2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Lewat2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Lewat3_Callback(hObject, eventdata, handles)
% hObject    handle to Lewat3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Lewat3 as text
%        str2double(get(hObject,'String')) returns contents of Lewat3 as a double


% --- Executes during object creation, after setting all properties.
function Lewat3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Lewat3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Reset.
function Reset_Callback(hObject, eventdata, handles)
set(handles.ProsesMulti,'String','-');
set(handles.ProsesSaveMulti,'String','-');


% --- Executes on button press in LoadDataTrainingMulti.
function LoadDataTrainingMulti_Callback(hObject, eventdata, handles)
global Fitur_GLCM
[x,y] = uigetfile('*.mat', 'Load Data');
set(handles.HalilLoadMulti,'String','Load Data Succes');
path = strcat(y,x);
load(path);
set(handles.TabelSigle,'Data',Fitur_GLCM);



function HalilLoadMulti_Callback(hObject, eventdata, handles)
% hObject    handle to HalilLoadMulti (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of HalilLoadMulti as text
%        str2double(get(hObject,'String')) returns contents of HalilLoadMulti as a double


% --- Executes during object creation, after setting all properties.
function HalilLoadMulti_CreateFcn(hObject, eventdata, handles)
% hObject    handle to HalilLoadMulti (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in RunMulti.
function RunMulti_Callback(hObject, eventdata, handles)
global Fitur_GLCM Hasil_SVM ambil1 ambil2 ambil3 jum_total

path_folder_positif = get(handles.PathPositifTest,'String');
path_folder_negatif = get(handles.PathNegatifTest,'String');

jum_positif = str2num(get(handles.JumPositifTest,'String'));
jum_negatif = str2num(get(handles.JumNegatifTest,'String'));
jum_total = (jum_positif + jum_negatif)*3;

Fitur_GLCM_test = zeros(jum_total,23);
Hasil_SVM = zeros(jum_total,2);

ambil1 = get(handles.Ambil1,'String');
ambil2 = get(handles.Ambil2,'String');
ambil3 = get(handles.Ambil3,'String');
counter_positif = 0;
counter_negatif = (jum_total/2);

tic
for x = 1 : 10
    if ((x == str2num(ambil1)) || (x == str2num(ambil2)) || (x == str2num(ambil3)))
        full_path_positif=strcat(path_folder_positif,'\',int2str(x),'\');
        filenames_positif = dir(fullfile(full_path_positif, '*.jpg'));
        for y =1 : jum_positif
            counter_positif = counter_positif + 1;
            full_name_positif= fullfile(full_path_positif, filenames_positif(y).name);
            our_images_positif = imread(full_name_positif);
            I = double(rgb2gray(our_images_positif));
            
            % Konvolusi ke Biner dengan operator Roberts
            robertshor = [0 1; -1 0];
            robertsver = [1 0; 0 -1];
            Ix = conv2(I,robertshor,'same');
            Iy = conv2(I,robertsver,'same');
            J = sqrt((Ix.^2)+(Iy.^2));

            K = uint8(J);
            L = im2bw(K,.05);
            
            %Morphological filtering
            M = imfill(L,'holes');
            N = bwareaopen(M,100);
            Z=Binary(N);
            
            %Segmented character
            [row,col]=size(N);
            Ib=im2bw(N);

            %%proses
            stats=regionprops(Ib,{'centroid','boundingbox','extrema'});
            hold on;
            
            %figure, imshow(Z);
            
            %GLCM
            Fitur_GLCM_test(counter_positif,:) = GLCMprocess(Z);
            Fitur_GLCM_test(counter_positif,23) = 2;
        end
        
        full_path_negatif=strcat(path_folder_negatif,'\',int2str(x),'\');
        filenames_negatif = dir(fullfile(full_path_negatif, '*.jpg'));
        for y =1 : jum_negatif
            counter_negatif = counter_negatif + 1;
            full_name_negatif= fullfile(full_path_negatif, filenames_negatif(y).name);
            our_images_negatif = imread(full_name_negatif);
            I = double(rgb2gray(our_images_negatif));
            
            % Konvolusi ke Biner dengan operator Roberts
            robertshor = [0 1; -1 0];
            robertsver = [1 0; 0 -1];
            Ix = conv2(I,robertshor,'same');
            Iy = conv2(I,robertsver,'same');
            J = sqrt((Ix.^2)+(Iy.^2));

            K = uint8(J);
            L = im2bw(K,.05);
            
            %Morphological filtering
            M = imfill(L,'holes');
            N = bwareaopen(M,100);
            Z=Binary(N);
            
            %Segmented character
            [row,col]=size(N);
            Ib=im2bw(N);

            %%proses
            stats=regionprops(Ib,{'centroid','boundingbox','extrema'});
            hold on;
            
            %figure, imshow(Z);
            
            %GLCM
            Fitur_GLCM_test(counter_negatif,:) = GLCMprocess(Z);
            Fitur_GLCM_test(counter_negatif,23) = 1;
        end
        
    end
end

%GLCM
Fitur_GLCM_training = Fitur_GLCM(:,1:22);
Label = Fitur_GLCM(:,23);

Hasil_SVM(:,1) = Fitur_GLCM_test(:,23);

%SVM
for z = 1 : jum_total
    svm=MSvm(Fitur_GLCM_training,Label,Fitur_GLCM_test(z,1:22));
    Hasil_SVM(z,2) = svm;
end

toc

set(handles.TabelSigle,'Data',Fitur_GLCM_test);
set(handles.StatusMulti,'String','Selesai');


function StatusMulti_Callback(hObject, eventdata, handles)
% hObject    handle to StatusMulti (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of StatusMulti as text
%        str2double(get(hObject,'String')) returns contents of StatusMulti as a double


% --- Executes during object creation, after setting all properties.
function StatusMulti_CreateFcn(hObject, eventdata, handles)
% hObject    handle to StatusMulti (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PathPositifTest_Callback(hObject, eventdata, handles)
% hObject    handle to PathPositifTest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PathPositifTest as text
%        str2double(get(hObject,'String')) returns contents of PathPositifTest as a double


% --- Executes during object creation, after setting all properties.
function PathPositifTest_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PathPositifTest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PathNegatifTest_Callback(hObject, eventdata, handles)
% hObject    handle to PathNegatifTest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PathNegatifTest as text
%        str2double(get(hObject,'String')) returns contents of PathNegatifTest as a double


% --- Executes during object creation, after setting all properties.
function PathNegatifTest_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PathNegatifTest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function JumPositifTest_Callback(hObject, eventdata, handles)
% hObject    handle to JumPositifTest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of JumPositifTest as text
%        str2double(get(hObject,'String')) returns contents of JumPositifTest as a double


% --- Executes during object creation, after setting all properties.
function JumPositifTest_CreateFcn(hObject, eventdata, handles)
% hObject    handle to JumPositifTest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function JumNegatifTest_Callback(hObject, eventdata, handles)
% hObject    handle to JumNegatifTest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of JumNegatifTest as text
%        str2double(get(hObject,'String')) returns contents of JumNegatifTest as a double


% --- Executes during object creation, after setting all properties.
function JumNegatifTest_CreateFcn(hObject, eventdata, handles)
% hObject    handle to JumNegatifTest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Ambil1_Callback(hObject, eventdata, handles)
% hObject    handle to Ambil1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Ambil1 as text
%        str2double(get(hObject,'String')) returns contents of Ambil1 as a double


% --- Executes during object creation, after setting all properties.
function Ambil1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Ambil1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Ambil2_Callback(hObject, eventdata, handles)
% hObject    handle to Ambil2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Ambil2 as text
%        str2double(get(hObject,'String')) returns contents of Ambil2 as a double


% --- Executes during object creation, after setting all properties.
function Ambil2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Ambil2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Ambil3_Callback(hObject, eventdata, handles)
% hObject    handle to Ambil3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Ambil3 as text
%        str2double(get(hObject,'String')) returns contents of Ambil3 as a double


% --- Executes during object creation, after setting all properties.
function Ambil3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Ambil3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in SaveMultiTesting.
function SaveMultiTesting_Callback(hObject, eventdata, handles)
global Hasil_SVM  ambil1 ambil2 ambil3 jum_total

Koreksi = zeros(jum_total+2,3);
Koreksi(1:jum_total,1:2) = Hasil_SVM;

counter = 0;
counterPositif = 0;
counterNegatif = 0;
for x = 1 : jum_total
    if (Hasil_SVM(x,1)== Hasil_SVM(x,2))
        Koreksi(x,3) = 1; 
        counter = counter + 1;
        if (x <= (jum_total/2))
            counterPositif = counterPositif + 1;
        else
            counterNegatif = counterNegatif + 1;
        end
    else
        Koreksi(x,3) = 0; 
    end
end

akurasi = (counter/jum_total)*100;
% akurasi                           : Akurasi
% jum_total-counter                 : Predikri Salah
% counter                           : Prediksi Benar
% counterPositif + counterNegatif   : Jumlah Seluruh Data
% counterNegatif                    : Jumlah Data Negatif
% counterPositif                    : Jumlah Data Positif

Koreksi(jum_total+2,3) = akurasi;
Koreksi(jum_total+2,2) = jum_total-counter;
Koreksi(jum_total+2,1) = counter;
Koreksi(jum_total+1,3) = counterPositif + counterNegatif;
Koreksi(jum_total+1,2) = counterNegatif;
Koreksi(jum_total+1,1) = counterPositif;

path = 'G:\CRS\BERKAS\TA\TA 2\Code\Hasil Klasifikasi\';
nama_versi = strcat(ambil1,ambil2,ambil3);
nama_file = strcat('hasil_',nama_versi);
nama_hasil_mat = strcat(path,'mat\',nama_file,'.mat');
nama_hasil_xls = strcat(path,'xlsx\',nama_file,'.xlsx');
save (nama_hasil_mat,'Koreksi');
xlswrite(nama_hasil_xls,Koreksi);
set(handles.StatusMultiTesting,'String','Sukses');



function StatusMultiTesting_Callback(hObject, eventdata, handles)
% hObject    handle to StatusMultiTesting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of StatusMultiTesting as text
%        str2double(get(hObject,'String')) returns contents of StatusMultiTesting as a double


% --- Executes during object creation, after setting all properties.
function StatusMultiTesting_CreateFcn(hObject, eventdata, handles)
% hObject    handle to StatusMultiTesting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton17.
function pushbutton17_Callback(hObject, eventdata, handles)
set(handles.StatusMulti,'String','-');
set(handles.StatusMultiTesting,'String','-');
set(handles.HalilLoadMulti,'String','-');
