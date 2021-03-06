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

% Last Modified by GUIDE v2.5 14-May-2019 05:41:19

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
Fitur_GLCM = GLCMprocess(Z,23,5);
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
global Fitur_GLCM lewati1 lewati2 lewati3 jumlahFitur sudutFitur

path_folder_positif = get(handles.PathPositif,'String');
path_folder_negatif = get(handles.PathNegatif,'String');

if (get(handles.statuskelas3,'Value')==1)
    path_folder_kelas3 = get(handles.PathKelas3,'String');
    jum_kelas3 = str2num(get(handles.JumKelas3,'String'));
end

jum_positif = str2num(get(handles.JumPositif,'String'));
jum_negatif = str2num(get(handles.JumNegatif,'String'));

if (get(handles.statuskelas3,'Value')==1)
    jum_total = (jum_positif + jum_negatif + jum_kelas3)*7;
    counter_positif = 0;
    counter_negatif = (jum_total/3);
    counter_kelas3 = counter_negatif*2;
end
if (get(handles.statuskelas3,'Value')==0)
    jum_total = (jum_positif + jum_negatif)*7;
    counter_positif = 0;
    counter_negatif = (jum_total/2);
end

Fitur_GLCM = zeros(jum_total,23);

lewati1 = get(handles.Lewat1,'String');
lewati2 = get(handles.Lewat2,'String');
lewati3 = get(handles.Lewat3,'String');
counter = 0;

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
            Fitur_GLCM(counter_positif,:) = GLCMprocess(Z,jumlahFitur+1,sudutFitur);
            if (get(handles.statuskelas3,'Value')==1)
                Fitur_GLCM(counter_positif,23) = 3;
            else
                Fitur_GLCM(counter_positif,23) = 2;
            end
            counter = counter+1
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
            Fitur_GLCM(counter_negatif,:) = GLCMprocess(Z, jumlahFitur+1,sudutFitur);
            if (get(handles.statuskelas3,'Value')==1)
                Fitur_GLCM(counter_negatif,23) = 2;
            else
                Fitur_GLCM(counter_negatif,23) = 1;
            end
            counter = counter+1
        end
        
        if (get(handles.statuskelas3,'Value')==1)
            full_path_kelas3=strcat(path_folder_kelas3,'\',int2str(x),'\');
            filenames_kelas3 = dir(fullfile(full_path_kelas3, '*.jpg'));
            for y =1 : jum_kelas3
                counter_kelas3 = counter_kelas3 + 1;
                full_name_kelas3= fullfile(full_path_kelas3, filenames_kelas3(y).name);
                our_images_kelas3 = imread(full_name_kelas3);
                I = double(rgb2gray(our_images_kelas3));

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
                Fitur_GLCM(counter_kelas3,:) = GLCMprocess(Z, jumlahFitur+1,sudutFitur);
                Fitur_GLCM(counter_kelas3,23) = 1;
                counter = counter+1
            end
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

path = get(handles.pathSimpanEkstraksi,'String');
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
global Fitur_GLCM Img_test jumlahFitur sudutFitur

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
svm = 0;
Fitur_GLCM_test(1,:) = GLCMprocess(Z, jumlahFitur+1,sudutFitur); 
if (sudutFitur == 1)
    Tampung(:,1) = Fitur_GLCM(:,1);
    Tampung(:,2) = Fitur_GLCM(:,5);
    Tampung(:,3) = Fitur_GLCM(:,9);
    Tampung(:,4) = Fitur_GLCM(:,13);
    
    TampungSementara(:,1) = Fitur_GLCM_test(:,1);
    TampungSementara(:,2) = Fitur_GLCM_test(:,5);
    TampungSementara(:,3) = Fitur_GLCM_test(:,9);
    TampungSementara(:,4) = Fitur_GLCM_test(:,13);
    
    Fitur_GLCM_training = Tampung(:,1:4);
    Label = Fitur_GLCM(:,23);
    %SVM
    svm=MSvm(Fitur_GLCM_training,Label,TampungSementara(:,1:4));
end
if (sudutFitur == 2)
    Tampung(:,1) = Fitur_GLCM(:,2);
    Tampung(:,2) = Fitur_GLCM(:,6);
    Tampung(:,3) = Fitur_GLCM(:,10);
    Tampung(:,4) = Fitur_GLCM(:,14);
    
    TampungSementara(:,1) = Fitur_GLCM_test(:,2);
    TampungSementara(:,2) = Fitur_GLCM_test(:,6);
    TampungSementara(:,3) = Fitur_GLCM_test(:,10);
    TampungSementara(:,4) = Fitur_GLCM_test(:,14);
    
    Fitur_GLCM_training = Tampung(:,1:4);
    Label = Fitur_GLCM(:,23);
    %SVM
    svm=MSvm(Fitur_GLCM_training,Label,TampungSementara(:,1:4));
end
if (sudutFitur == 3)
    Tampung(:,1) = Fitur_GLCM(:,3);
    Tampung(:,2) = Fitur_GLCM(:,7);
    Tampung(:,3) = Fitur_GLCM(:,11);
    Tampung(:,4) = Fitur_GLCM(:,15);
    
    TampungSementara(:,1) = Fitur_GLCM_test(:,3);
    TampungSementara(:,2) = Fitur_GLCM_test(:,7);
    TampungSementara(:,3) = Fitur_GLCM_test(:,11);
    TampungSementara(:,4) = Fitur_GLCM_test(:,15);
    
    Fitur_GLCM_training = Tampung(:,1:4);
    Label = Fitur_GLCM(:,23);
    %SVM
    svm=MSvm(Fitur_GLCM_training,Label,TampungSementara(:,1:4));
end
if (sudutFitur == 4)
    Tampung(:,1) = Fitur_GLCM(:,4);
    Tampung(:,2) = Fitur_GLCM(:,8);
    Tampung(:,3) = Fitur_GLCM(:,12);
    Tampung(:,4) = Fitur_GLCM(:,16);
    
    TampungSementara(:,1) = Fitur_GLCM_test(:,4);
    TampungSementara(:,2) = Fitur_GLCM_test(:,8);
    TampungSementara(:,3) = Fitur_GLCM_test(:,12);
    TampungSementara(:,4) = Fitur_GLCM_test(:,16);
    
    Fitur_GLCM_training = Tampung(:,1:4);
    Label = Fitur_GLCM(:,23);
    %SVM
    svm=MSvm(Fitur_GLCM_training,Label,TampungSementara(:,1:4));
end
if (sudutFitur == 5)
    Tampung(:,:) = Fitur_GLCM(:,jumlahFitur);
    TampungSementara(:,:) = Fitur_GLCM_test(:,1:jumlahFitur);
    Fitur_GLCM_training = Fitur_GLCM(:,1:jumlahFitur);
    Label = Fitur_GLCM(:,23);
    %SVM
    hasillatihSVM = svmtrain(Fitur_GLCM_training,Label,'kernelcachelimit',40000);
    svm = svmclassify(hasillatihSVM,TampungSementara);
end

status_retakan = 'Tidak ditemukan';

if (get(handles.statuskelas3,'Value')==1)
    if (svm == 3)
        status_retakan = 'Berat';
    end
    if (svm == 2)
        status_retakan = 'Sedang';
    end
    if (svm == 1)
        status_retakan = 'Ringan';
    end
else
    if (svm == 2)
        status_retakan = 'Berat';
    end
    if (svm == 1)
        status_retakan = 'Ringan';
    end
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
global Fitur_GLCM Hasil_SVM ambil1 ambil2 ambil3 jum_total jumlahFitur sudutFitur

path_folder_positif = get(handles.PathPositifTest,'String');
path_folder_negatif = get(handles.PathNegatifTest,'String');

if (get(handles.statuskelas3tes,'Value')==1)
    path_folder_kelas3 = get(handles.PathKelas3Test,'String');
    jum_kelas3 = str2num(get(handles.JumKelas3Test,'String'));
end

jum_positif = str2num(get(handles.JumPositifTest,'String'));
jum_negatif = str2num(get(handles.JumNegatifTest,'String'));

if (get(handles.statuskelas3tes,'Value')==1)
    jum_total = (jum_positif + jum_negatif + jum_kelas3)*3;
    counter_positif = 0;
    counter_negatif = (jum_total/3);
    counter_kelas3 = counter_negatif*2;
end
if (get(handles.statuskelas3tes,'Value')==0)
    jum_total = (jum_positif + jum_negatif)*3;
    counter_positif = 0;
    counter_negatif = (jum_total/2);
end

Fitur_GLCM_test = zeros(jum_total,23);
Hasil_SVM = zeros(jum_total,2);

ambil1 = get(handles.Ambil1,'String');
ambil2 = get(handles.Ambil2,'String');
ambil3 = get(handles.Ambil3,'String');
counter = 0;

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
            Fitur_GLCM_test(counter_positif,:) = GLCMprocess(Z, jumlahFitur+1,sudutFitur);
            get(handles.statuskelas3tes,'Value')
            if (get(handles.statuskelas3tes,'Value')==1)
                Fitur_GLCM_test(counter_positif,23) = 3;
            end
            if (get(handles.statuskelas3tes,'Value')==0)
                Fitur_GLCM_test(counter_positif,23) = 2;
            end
            counter = counter+1
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
            Fitur_GLCM_test(counter_negatif,:) = GLCMprocess(Z, jumlahFitur+1,sudutFitur);
            get(handles.statuskelas3tes,'Value')
            if (get(handles.statuskelas3tes,'Value')==1)
                Fitur_GLCM_test(counter_negatif,23) = 2;
            end
            if (get(handles.statuskelas3tes,'Value')==0)
                Fitur_GLCM_test(counter_negatif,23) = 1;
            end
            counter = counter+1
        end
        
        if (get(handles.statuskelas3tes,'Value')==1)
            full_path_kelas3=strcat(path_folder_kelas3,'\',int2str(x),'\');
            filenames_kelas3 = dir(fullfile(full_path_kelas3, '*.jpg'));
            for y =1 : jum_negatif
                counter_kelas3 = counter_kelas3 + 1;
                full_name_kelas3= fullfile(full_path_kelas3, filenames_kelas3(y).name);
                our_images_kelas3 = imread(full_name_kelas3);
                I = double(rgb2gray(our_images_kelas3));

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
                Fitur_GLCM_test(counter_kelas3,:) = GLCMprocess(Z, jumlahFitur+1,sudutFitur);
                Fitur_GLCM_test(counter_kelas3,23) = 1;
                counter = counter+1
            end
        end
        
    end
end

%GLCM
if (sudutFitur == 1)
    Tampung(:,1) = Fitur_GLCM(:,1);
    Tampung(:,2) = Fitur_GLCM(:,5);
    Tampung(:,3) = Fitur_GLCM(:,9);
    Tampung(:,4) = Fitur_GLCM(:,13);
    
    TampungSementara(:,1) = Fitur_GLCM_test(:,1);
    TampungSementara(:,2) = Fitur_GLCM_test(:,5);
    TampungSementara(:,3) = Fitur_GLCM_test(:,9);
    TampungSementara(:,4) = Fitur_GLCM_test(:,13);
    
    Fitur_GLCM_training = Tampung(:,1:4);
    Label = Fitur_GLCM(:,23);
    Hasil_SVM(:,1) = Fitur_GLCM_test(1:jum_total,23);
    %SVM
    if(get(handles.statuskelas3tes,'Value')==0)
        hasillatihSVM = svmtrain(Fitur_GLCM_training(:,1:4),Label,'kernelcachelimit',28000);
    end
    for z = 1 : jum_total
        if (get(handles.statuskelas3tes,'Value')==1)
            svm=MSvm(Fitur_GLCM_training(:,1:4),Label,TampungSementara(z,1:4));
        else
            %hasillatihSVM = svmtrain(Fitur_GLCM_training(:,1:4),Label,'kernelcachelimit',28000);
            svm = svmclassify(hasillatihSVM,Fitur_GLCM_test(z,1:4));
        end
        Hasil_SVM(z,2) = svm;
        set(handles.StatusMulti,'String',z);
    end
end
if (sudutFitur == 2)
    Tampung(:,1) = Fitur_GLCM(:,2);
    Tampung(:,2) = Fitur_GLCM(:,6);
    Tampung(:,3) = Fitur_GLCM(:,10);
    Tampung(:,4) = Fitur_GLCM(:,14);
    
    TampungSementara(:,1) = Fitur_GLCM_test(:,2);
    TampungSementara(:,2) = Fitur_GLCM_test(:,6);
    TampungSementara(:,3) = Fitur_GLCM_test(:,10);
    TampungSementara(:,4) = Fitur_GLCM_test(:,14);
    
    Fitur_GLCM_training = Tampung(:,1:4);
    Label = Fitur_GLCM(:,23);
    Hasil_SVM(:,1) = Fitur_GLCM_test(1:jum_total,23);
    %SVM
    if(get(handles.statuskelas3tes,'Value')==0)
        hasillatihSVM = svmtrain(Fitur_GLCM_training(:,1:4),Label,'kernelcachelimit',28000);
    end
    for z = 1 : jum_total
        if (get(handles.statuskelas3tes,'Value')==1)
            svm=MSvm(Fitur_GLCM_training(:,1:4),Label,TampungSementara(z,1:4));
        else
            %hasillatihSVM = svmtrain(Fitur_GLCM_training(:,1:4),Label,'kernelcachelimit',28000);
            svm = svmclassify(hasillatihSVM,Fitur_GLCM_test(z,1:4));
        end
        Hasil_SVM(z,2) = svm;
        set(handles.StatusMulti,'String',z);
    end
end
if (sudutFitur == 3)
    Tampung(:,1) = Fitur_GLCM(:,3);
    Tampung(:,2) = Fitur_GLCM(:,7);
    Tampung(:,3) = Fitur_GLCM(:,11);
    Tampung(:,4) = Fitur_GLCM(:,15);
    
    TampungSementara(:,1) = Fitur_GLCM_test(:,3);
    TampungSementara(:,2) = Fitur_GLCM_test(:,7);
    TampungSementara(:,3) = Fitur_GLCM_test(:,11);
    TampungSementara(:,4) = Fitur_GLCM_test(:,15);
    
    Fitur_GLCM_training = Tampung(:,1:4);
    Label = Fitur_GLCM(:,23);
    Hasil_SVM(:,1) = Fitur_GLCM_test(1:jum_total,23);
    %SVM
    if(get(handles.statuskelas3tes,'Value')==0)
        hasillatihSVM = svmtrain(Fitur_GLCM_training(:,1:4),Label,'kernelcachelimit',28000);
    end
    for z = 1 : jum_total
        if (get(handles.statuskelas3tes,'Value')==1)
            svm=MSvm(Fitur_GLCM_training(:,1:4),Label,TampungSementara(z,1:4));
        else
            %hasillatihSVM = svmtrain(Fitur_GLCM_training(:,1:4),Label,'kernelcachelimit',28000);
            svm = svmclassify(hasillatihSVM,Fitur_GLCM_test(z,1:4));
        end
        Hasil_SVM(z,2) = svm;
        set(handles.StatusMulti,'String',z);
    end
end
if (sudutFitur == 4)
    Tampung(:,1) = Fitur_GLCM(:,4);
    Tampung(:,2) = Fitur_GLCM(:,8);
    Tampung(:,3) = Fitur_GLCM(:,12);
    Tampung(:,4) = Fitur_GLCM(:,16);
    
    TampungSementara(:,1) = Fitur_GLCM_test(:,4);
    TampungSementara(:,2) = Fitur_GLCM_test(:,8);
    TampungSementara(:,3) = Fitur_GLCM_test(:,12);
    TampungSementara(:,4) = Fitur_GLCM_test(:,16);
    
    Fitur_GLCM_training = Tampung(:,1:4);
    Label = Fitur_GLCM(:,23);
    Hasil_SVM(:,1) = Fitur_GLCM_test(1:jum_total,23);
    %SVM
    if(get(handles.statuskelas3tes,'Value')==0)
        hasillatihSVM = svmtrain(Fitur_GLCM_training(:,1:4),Label,'kernelcachelimit',28000);
    end
    for z = 1 : jum_total
        if (get(handles.statuskelas3tes,'Value')==1)
            svm=MSvm(Fitur_GLCM_training(:,1:4),Label,TampungSementara(z,1:4));
        else
            %hasillatihSVM = svmtrain(Fitur_GLCM_training(:,1:4),Label,'kernelcachelimit',28000);
            svm = svmclassify(hasillatihSVM,Fitur_GLCM_test(z,1:4));
        end
        Hasil_SVM(z,2) = svm;
        set(handles.StatusMulti,'String',z);
    end
end
if (sudutFitur == 5)
    Tampung(:,:) = Fitur_GLCM(:,:);
    TampungSementara(:,:) = Fitur_GLCM_test(:,:);
    Fitur_GLCM_training = Tampung(:,1:jumlahFitur);
    Label = Fitur_GLCM(:,23);
    Hasil_SVM(:,1) = Fitur_GLCM_test(1:jum_total,23);
    %SVM
    if(get(handles.statuskelas3tes,'Value')==0)
        hasillatihSVM = svmtrain(Fitur_GLCM_training(:,1:jumlahFitur),Label,'kernelcachelimit',28000);
    end
    for z = 1 : jum_total
        if (get(handles.statuskelas3tes,'Value')==1)
            svm=MSvm(Fitur_GLCM_training(:,1:jumlahFitur),Label,TampungSementara(z,1:jumlahFitur));
        else
            %hasillatihSVM = svmtrain(Fitur_GLCM_training(:,1:jumlahFitur),Label,'kernelcachelimit',28000);
            svm = svmclassify(hasillatihSVM,Fitur_GLCM_test(z,1:jumlahFitur));
        end
        Hasil_SVM(z,2) = svm;
        set(handles.StatusMulti,'String',z);
    end
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
global Hasil_SVM  ambil1 ambil2 ambil3 jum_total jumlahFiturId sudutFiturId
jumlahKelas = '';
AA = 0; AB = 0; AC = 0;
BA = 0; BB = 0; BC = 0;
CA = 0; CB = 0; CC = 0;

if (get(handles.statuskelas3tes,'Value')==1)
    jumlahKelas = '3';
    Koreksi = zeros(jum_total+4,5);
    Koreksi(1:jum_total,1:2) = Hasil_SVM;
    for x = 1 : jum_total
        if (Hasil_SVM(x,1)== Hasil_SVM(x,2))
            if (x <= (jum_total/3))
                AA = AA + 1;
            elseif ((x > (jum_total/3))&&(x <= (jum_total/3)*2))
                BB = BB + 1;
            else
                CC = CC + 1;
            end
        elseif (Hasil_SVM(x,1)==3 && Hasil_SVM(x,2)==2)
            AB = AB + 1;
        elseif (Hasil_SVM(x,1)==3 && Hasil_SVM(x,2)==1)
            AC = AC + 1;
        elseif (Hasil_SVM(x,1)==2 && Hasil_SVM(x,2)==3)
            BA = BA + 1;
        elseif (Hasil_SVM(x,1)==2 && Hasil_SVM(x,2)==1)
            BC = BC + 1;
        elseif (Hasil_SVM(x,1)==1 && Hasil_SVM(x,2)==3)
            CA = CA + 1;
        elseif (Hasil_SVM(x,1)==1 && Hasil_SVM(x,2)==2)
            CB = CB + 1;
        end
    end

    akurasi_A = (AA/(AA+AB+AC))*100;
    akurasi_B = (BB/(BA+BB+BC))*100;
    akurasi_C = (CC/(CA+CB+CC))*100;
    
    presisi_A = (AA/(AA+BA+CA))*100;
    presisi_B = (BB/(AB+BB+CB))*100;
    presisi_C = (CC/(AC+BC+CC))*100;
    
    recall_A = (AA/(AA+AB+AC))*100;
    recall_B = (BB/(BA+BB+BC))*100;
    recall_C = (CC/(CA+CB+CC))*100; 

    Koreksi(jum_total+1,1) = AA;
    Koreksi(jum_total+1,2) = AB;
    Koreksi(jum_total+1,3) = AC;
    Koreksi(jum_total+1,4) = recall_A;
    Koreksi(jum_total+1,5) = presisi_A;
    Koreksi(jum_total+2,1) = BA;
    Koreksi(jum_total+2,2) = BB;
    Koreksi(jum_total+2,3) = BC;
    Koreksi(jum_total+2,4) = recall_B;
    Koreksi(jum_total+2,5) = presisi_B;
    Koreksi(jum_total+3,1) = CA;
    Koreksi(jum_total+3,2) = CB;
    Koreksi(jum_total+3,3) = CC;
    Koreksi(jum_total+3,4) = recall_C;
    Koreksi(jum_total+3,5) = presisi_C;
    Koreksi(jum_total+4,1) = akurasi_A;
    Koreksi(jum_total+4,2) = akurasi_B;
    Koreksi(jum_total+4,3) = akurasi_C;
    Koreksi(jum_total+4,4) = 0;
    Koreksi(jum_total+4,5) = ((AA+BB+CC)/(AA+AB+AC+BA+BB+BC+CA+CB+CC))*100;
end
if (get(handles.statuskelas3tes,'Value')==0) 
    jumlahKelas = '2';
    Koreksi = zeros(jum_total+3,4);
    Koreksi(1:jum_total,1:2) = Hasil_SVM;
    for x = 1 : jum_total
        if (Hasil_SVM(x,1)== Hasil_SVM(x,2))
            if (x <= (jum_total/2))
                AA = AA + 1;
            else
                BB = BB + 1;
            end
        elseif (Hasil_SVM(x,1)==2 && Hasil_SVM(x,2)==1)
            AB = AB + 1;
        elseif (Hasil_SVM(x,1)==1 && Hasil_SVM(x,2)==2)
            BA = BA + 1;
        end
    end

    akurasi_A = (AA/(AA+AB))*100;
    akurasi_B = (BB/(BA+BB))*100;
    
    presisi_A = (AA/(AA+BA))*100;
    presisi_B = (BB/(AB+BB))*100;
    
    recall_A = (AA/(AA+AB))*100;
    recall_B = (BB/(BA+BB))*100;

    Koreksi(jum_total+1,1) = AA;
    Koreksi(jum_total+1,2) = AB;
    Koreksi(jum_total+1,3) = recall_A;
    Koreksi(jum_total+1,4) = presisi_A;
    Koreksi(jum_total+2,1) = BA;
    Koreksi(jum_total+2,2) = BB;
    Koreksi(jum_total+2,3) = recall_B;
    Koreksi(jum_total+2,4) = presisi_B;
    Koreksi(jum_total+3,1) = akurasi_A;
    Koreksi(jum_total+3,2) = akurasi_B;
    Koreksi(jum_total+3,3) = 0;
    Koreksi(jum_total+3,4) = ((AA+BB)/(AA+AB+BA+BB))*100;
end

path = get(handles.pathSimpanKlasifikasi,'String');
nama_versi = strcat(ambil1,ambil2,ambil3);
nama_kode = strcat('-',jumlahKelas,'_kelas-',int2str(jum_total),'_data-',jumlahFiturId,'-',sudutFiturId);
nama_file = strcat('hasil model_',nama_versi,nama_kode);
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


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in setJumlahFitur.
function setJumlahFitur_Callback(hObject, eventdata, handles)
global jumlahFitur jumlahFiturId

if (get(handles.jumlahFitur1,'Value')==1)
    jumlahFitur=4;
    jumlahFiturId='1_fitur';
end
if (get(handles.jumlahFitur2,'Value')==1)
    jumlahFitur=8;
    jumlahFiturId='2_fitur';
end
if (get(handles.jumlahFitur3,'Value')==1)
    jumlahFitur=12;
    jumlahFiturId='3_fitur';
end
if (get(handles.jumlahFitur4,'Value')==1)
    jumlahFitur=16;
    jumlahFiturId='4_fitur';
end
if (get(handles.jumlahFitur5,'Value')==1)
    jumlahFitur=20;
    jumlahFiturId='5_fitur';
end
if (get(handles.jumlahFitur6,'Value')==1)
    jumlahFitur=22;
    jumlahFiturId='semua_fitur';
end

function pathSimpanEkstraksi_Callback(hObject, eventdata, handles)
% hObject    handle to pathSimpanEkstraksi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pathSimpanEkstraksi as text
%        str2double(get(hObject,'String')) returns contents of pathSimpanEkstraksi as a double


% --- Executes during object creation, after setting all properties.
function pathSimpanEkstraksi_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pathSimpanEkstraksi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pathSimpanKlasifikasi_Callback(hObject, eventdata, handles)
% hObject    handle to pathSimpanKlasifikasi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pathSimpanKlasifikasi as text
%        str2double(get(hObject,'String')) returns contents of pathSimpanKlasifikasi as a double


% --- Executes during object creation, after setting all properties.
function pathSimpanKlasifikasi_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pathSimpanKlasifikasi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in setSudut.
function setSudut_Callback(hObject, eventdata, handles)
global sudutFitur sudutFiturId

if (get(handles.sudutFitur0,'Value')==1)
    sudutFitur=1;
    sudutFiturId='0_derajat';
end
if (get(handles.sudutFitur45,'Value')==1)
    sudutFitur=2;
    sudutFiturId='45_derajat';
end
if (get(handles.sudutFitur90,'Value')==1)
    sudutFitur=3;
    sudutFiturId='90_derajat';
end
if (get(handles.sudutFitur135,'Value')==1)
    sudutFitur=4;
    sudutFiturId='145_derajat';
end
if (get(handles.sudutFiturAll,'Value')==1)
    sudutFitur=5;
    sudutFiturId='semua_derajat';
end

% --- Executes on button press in pushbutton19.
function pushbutton19_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton20.
function pushbutton20_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function PathKelas3_Callback(hObject, eventdata, handles)
% hObject    handle to PathKelas3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PathKelas3 as text
%        str2double(get(hObject,'String')) returns contents of PathKelas3 as a double


% --- Executes during object creation, after setting all properties.
function PathKelas3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PathKelas3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function JumKelas3_Callback(hObject, eventdata, handles)
% hObject    handle to JumKelas3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of JumKelas3 as text
%        str2double(get(hObject,'String')) returns contents of JumKelas3 as a double


% --- Executes during object creation, after setting all properties.
function JumKelas3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to JumKelas3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in statuskelas3.
function statuskelas3_Callback(hObject, eventdata, handles)
% hObject    handle to statuskelas3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of statuskelas3



function PathKelas3Test_Callback(hObject, eventdata, handles)
% hObject    handle to PathKelas3Test (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PathKelas3Test as text
%        str2double(get(hObject,'String')) returns contents of PathKelas3Test as a double


% --- Executes during object creation, after setting all properties.
function PathKelas3Test_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PathKelas3Test (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function JumKelas3Test_Callback(hObject, eventdata, handles)
% hObject    handle to JumKelas3Test (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of JumKelas3Test as text
%        str2double(get(hObject,'String')) returns contents of JumKelas3Test as a double


% --- Executes during object creation, after setting all properties.
function JumKelas3Test_CreateFcn(hObject, eventdata, handles)
% hObject    handle to JumKelas3Test (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in statuskelas3tes.
function statuskelas3tes_Callback(hObject, eventdata, handles)
% hObject    handle to statuskelas3tes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of statuskelas3tes


% --- Executes on button press in statusLewati.
function statusLewati_Callback(hObject, eventdata, handles)
% hObject    handle to statusLewati (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of statusLewati
