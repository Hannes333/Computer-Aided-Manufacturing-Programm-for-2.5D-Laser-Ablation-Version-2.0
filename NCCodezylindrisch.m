function varargout = NCCodezylindrisch(varargin)
% Dies ist das Skript zum Fenster NCCodezylindrisch.fig
% In diesem Code werden alle Eingaben die auf dem NCCodezylindrisch.fig getätigt
% werden ausgewertet.

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @NCCodezylindrisch_OpeningFcn, ...
                   'gui_OutputFcn',  @NCCodezylindrisch_OutputFcn, ...
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

% --- Executes just before NCCodezylindrisch is made visible.
function NCCodezylindrisch_OpeningFcn(hObject, eventdata, handles, varargin)
global Var
%Falls der Pfad mit Titel (Titelpfad) leer ist, wird Button2 ausgegraut
if isempty(Var.FolderName)
    %Button NC-Code wird ausgeblendet
    set(handles.pushbutton2,'Enable','off');
end

%Werte werden in die entsprechenden Felder geschrieben
set(handles.edit1,'String',Var.NCText.Header1);
set(handles.edit2,'String',Var.NCText.Header2);
set(handles.edit3,'String',Var.NCText.Header3);
set(handles.edit4,'String',Var.NCText.Header4);
set(handles.edit5,'String',Var.NCText.Header5);
set(handles.edit6,'String',Var.NCText.Header6);
set(handles.edit7,'String',Var.NCText.Header7);
set(handles.edit8,'String',Var.NCText.Header8);
set(handles.edit9,'String',Var.NCText.Header9);
set(handles.edit10,'String',Var.NCText.Header10);
set(handles.edit43,'String',Var.NCText.Vorschub1);
set(handles.edit44,'String',Var.NCText.Vorschub2);
set(handles.edit11,'String',Var.NCText.Fokus1);
set(handles.edit12,'String',Var.NCText.Fokus2);
set(handles.edit41,'String',Var.NCText.Fokus3);
set(handles.edit42,'String',Var.NCText.Fokus4);
set(handles.edit13,'String',Var.NCText.Eilgang1);
set(handles.edit14,'String',Var.NCText.Eilgang2);
set(handles.edit15,'String',Var.NCText.Eilgang3);
set(handles.edit45,'String',Var.NCText.Laseraus1);
set(handles.edit46,'String',Var.NCText.Laseraus2);
set(handles.edit47,'String',Var.NCText.Laseraus3);
set(handles.edit16,'String',Var.NCText.StartSky1);
set(handles.edit17,'String',Var.NCText.StartSky2);
set(handles.edit18,'String',Var.NCText.StartSky3);
set(handles.edit19,'String',Var.NCText.Laser1);
set(handles.edit20,'String',Var.NCText.Laser2);
set(handles.edit21,'String',Var.NCText.Laser3);
set(handles.edit22,'String',Var.NCText.EndSky1);
set(handles.edit23,'String',Var.NCText.EndSky2);
set(handles.edit24,'String',Var.NCText.EndSky3);
set(handles.edit25,'String',Var.NCText.Laseron);
set(handles.edit26,'String',Var.NCText.Laseroff);
set(handles.edit27,'String',Var.NCText.Kommentar1);
set(handles.edit28,'String',Var.NCText.Kommentar2);
set(handles.edit29,'String',Var.NCText.Finish1);
set(handles.edit30,'String',Var.NCText.Finish2);
set(handles.edit31,'String',Var.NCText.Finish3);
set(handles.edit32,'String',Var.NCText.Finish4);
set(handles.edit33,'String',Var.NCText.Finish5);
set(handles.edit48,'String',Var.NCText.EbeneSta1);
set(handles.edit49,'String',Var.NCText.EbeneSta2);
set(handles.edit50,'String',Var.NCText.EbeneEnd1);
set(handles.edit51,'String',Var.NCText.EbeneEnd2);

% Choose default command line output for NCCodezylindrisch
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes NCCodezylindrisch wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = NCCodezylindrisch_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%Wird ausgeführt nach Betätigung des pushbutton1 (Zielverzeichnis NC-Code)
function pushbutton1_Callback(hObject, eventdata, handles)
global Var
FolderName = uigetdir('C:\','Speicherungs Ordner auswählen');
if ischar(FolderName);
    Var.FolderName=FolderName;
    %Pushbutton2 wird eingeblendet
    set(handles.pushbutton2,'Enable','on');
end


%Wird ausgeführt nach Betätigung des pushbutton2 (NC-Code erstellen)
function pushbutton2_Callback(hObject, eventdata, handles)
global Var
%Einzelnen Angabefelder werden ausgelesen und im struct NCText gespeichert
Var.NCText.Header1=get(handles.edit1,'String');
Var.NCText.Header2=get(handles.edit2,'String');
Var.NCText.Header3=get(handles.edit3,'String');
Var.NCText.Header4=get(handles.edit4,'String');
Var.NCText.Header5=get(handles.edit5,'String');
Var.NCText.Header6=get(handles.edit6,'String');
Var.NCText.Header7=get(handles.edit7,'String');
Var.NCText.Header8=get(handles.edit8,'String');
Var.NCText.Header9=get(handles.edit9,'String');
Var.NCText.Header10=get(handles.edit10,'String');
Var.NCText.Vorschub1=get(handles.edit43,'String');
Var.NCText.Vorschub2=get(handles.edit44,'String');
Var.NCText.Laseraus1=get(handles.edit45,'String');
Var.NCText.Laseraus2=get(handles.edit46,'String');
Var.NCText.Laseraus3=get(handles.edit47,'String');
Var.NCText.Fokus1=get(handles.edit11,'String');
Var.NCText.Fokus2=get(handles.edit12,'String');
Var.NCText.Fokus3=get(handles.edit41,'String');
Var.NCText.Fokus4=get(handles.edit42,'String');
Var.NCText.Eilgang1=get(handles.edit13,'String');
Var.NCText.Eilgang2=get(handles.edit14,'String');
Var.NCText.Eilgang3=get(handles.edit15,'String');
Var.NCText.StartSky1=get(handles.edit16,'String');
Var.NCText.StartSky2=get(handles.edit17,'String');
Var.NCText.StartSky3=get(handles.edit18,'String');
Var.NCText.Laser1=get(handles.edit19,'String');
Var.NCText.Laser2=get(handles.edit20,'String');
Var.NCText.Laser3=get(handles.edit21,'String');
Var.NCText.EndSky1=get(handles.edit22,'String');
Var.NCText.EndSky2=get(handles.edit23,'String');
Var.NCText.EndSky3=get(handles.edit24,'String');
Var.NCText.Laseron=get(handles.edit25,'String');
Var.NCText.Laseroff=get(handles.edit26,'String');
Var.NCText.Kommentar1=get(handles.edit27,'String');
Var.NCText.Kommentar2=get(handles.edit28,'String');
Var.NCText.Finish1=get(handles.edit29,'String');
Var.NCText.Finish2=get(handles.edit30,'String');
Var.NCText.Finish3=get(handles.edit31,'String');
Var.NCText.Finish4=get(handles.edit32,'String');
Var.NCText.Finish5=get(handles.edit33,'String');
Var.NCText.EbeneSta1=get(handles.edit48,'String');
Var.NCText.EbeneSta2=get(handles.edit49,'String');
Var.NCText.EbeneEnd1=get(handles.edit50,'String');
Var.NCText.EbeneEnd2=get(handles.edit51,'String');
Titelpfad=[Var.FolderName,'\',Var.Titel,'.txt'];

%Funktion, die den NC-Code erstellt
F51_NCCode(Var.Schraffuren,Titelpfad,Var.NCText,Var.VorschubDominant);
close(NCCodezylindrisch)


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit1_Callback(hObject, eventdata, handles)
global Var
Var.NCText.Header1=get(handles.edit1,'String');


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit2_Callback(hObject, eventdata, handles)
global Var
Var.NCText.Header2=get(handles.edit2,'String');


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit3_Callback(hObject, eventdata, handles)
global Var
Var.NCText.Header3=get(handles.edit3,'String');


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit4_Callback(hObject, eventdata, handles)
global Var
Var.NCText.Header4=get(handles.edit4,'String');


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit5_Callback(hObject, eventdata, handles)
global Var
Var.NCText.Header5=get(handles.edit5,'String');


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit6_Callback(hObject, eventdata, handles)
global Var
Var.NCText.Header6=get(handles.edit6,'String');


function edit7_Callback(hObject, eventdata, handles)
global Var
Var.NCText.Header7=get(handles.edit7,'String');


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit8_Callback(hObject, eventdata, handles)
global Var
Var.NCText.Header8=get(handles.edit8,'String');


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit9_Callback(hObject, eventdata, handles)
global Var
Var.NCText.Header9=get(handles.edit9,'String');


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit10_Callback(hObject, eventdata, handles)
global Var
Var.NCText.Header10=get(handles.edit10,'String');


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit11_Callback(hObject, eventdata, handles)
global Var
Var.NCText.Fokus1=get(handles.edit11,'String');


% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit12_Callback(hObject, eventdata, handles)
global Var
Var.NCText.Fokus2=get(handles.edit12,'String');


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit13_Callback(hObject, eventdata, handles)
global Var
Var.NCText.Eilgang1=get(handles.edit13,'String');


% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit14_Callback(hObject, eventdata, handles)
global Var
Var.NCText.Eilgang2=get(handles.edit14,'String');


% --- Executes during object creation, after setting all properties.
function edit14_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit15_Callback(hObject, eventdata, handles)
global Var
Var.NCText.Eilgang3=get(handles.edit15,'String');


% --- Executes during object creation, after setting all properties.
function edit15_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit16_Callback(hObject, eventdata, handles)
global Var
Var.NCText.StartSky1=get(handles.edit16,'String');


% --- Executes during object creation, after setting all properties.
function edit16_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit17_Callback(hObject, eventdata, handles)
global Var
Var.NCText.StartSky2=get(handles.edit17,'String');


% --- Executes during object creation, after setting all properties.
function edit17_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit18_Callback(hObject, eventdata, handles)
global Var
Var.NCText.StartSky3=get(handles.edit18,'String');


% --- Executes during object creation, after setting all properties.
function edit18_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit19_Callback(hObject, eventdata, handles)
global Var
Var.NCText.Laser1=get(handles.edit19,'String');

% --- Executes during object creation, after setting all properties.
function edit19_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit20_Callback(hObject, eventdata, handles)
global Var
Var.NCText.Laser2=get(handles.edit20,'String');


% --- Executes during object creation, after setting all properties.
function edit20_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit21_Callback(hObject, eventdata, handles)
global Var
Var.NCText.Laser3=get(handles.edit21,'String');


% --- Executes during object creation, after setting all properties.
function edit21_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit22_Callback(hObject, eventdata, handles)
global Var
Var.NCText.EndSky1=get(handles.edit22,'String');


% --- Executes during object creation, after setting all properties.
function edit22_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit23_Callback(hObject, eventdata, handles)
global Var
Var.NCText.EndSky2=get(handles.edit23,'String');


% --- Executes during object creation, after setting all properties.
function edit23_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit24_Callback(hObject, eventdata, handles)
global Var
Var.NCText.EndSky3=get(handles.edit24,'String');


% --- Executes during object creation, after setting all properties.
function edit24_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit25_Callback(hObject, eventdata, handles)
global Var
Var.NCText.Laseron=get(handles.edit25,'String');


% --- Executes during object creation, after setting all properties.
function edit25_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit26_Callback(hObject, eventdata, handles)
global Var
Var.NCText.Laseroff=get(handles.edit26,'String');


% --- Executes during object creation, after setting all properties.
function edit26_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit27_Callback(hObject, eventdata, handles)
global Var
Var.NCText.Kommentar1=get(handles.edit27,'String');


% --- Executes during object creation, after setting all properties.
function edit27_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit28_Callback(hObject, eventdata, handles)
global Var
Var.NCText.Kommentar2=get(handles.edit28,'String');


% --- Executes during object creation, after setting all properties.
function edit28_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit29_Callback(hObject, eventdata, handles)
global Var
Var.NCText.Finish1=get(handles.edit29,'String');


% --- Executes during object creation, after setting all properties.
function edit29_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit30_Callback(hObject, eventdata, handles)
global Var
Var.NCText.Finish2=get(handles.edit30,'String');


% --- Executes during object creation, after setting all properties.
function edit30_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit31_Callback(hObject, eventdata, handles)
global Var
Var.NCText.Finish3=get(handles.edit31,'String');


% --- Executes during object creation, after setting all properties.
function edit31_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit32_Callback(hObject, eventdata, handles)
global Var
Var.NCText.Finish4=get(handles.edit32,'String');


% --- Executes during object creation, after setting all properties.
function edit32_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit33_Callback(hObject, eventdata, handles)
global Var
Var.NCText.Finish5=get(handles.edit33,'String');


% --- Executes during object creation, after setting all properties.
function edit33_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit41_Callback(hObject, eventdata, handles)
global Var
Var.NCText.Fokus3=get(handles.edit41,'String');

% --- Executes during object creation, after setting all properties.
function edit41_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit42_Callback(hObject, eventdata, handles)
global Var
Var.NCText.Fokus4=get(handles.edit42,'String');

% --- Executes during object creation, after setting all properties.
function edit42_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit43_Callback(hObject, eventdata, handles)
global Var
Var.NCText.Vorschub1=get(handles.edit43,'String');

% --- Executes during object creation, after setting all properties.
function edit43_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit44_Callback(hObject, eventdata, handles)
global Var
Var.NCText.Vorschub2=get(handles.edit44,'String');


% --- Executes during object creation, after setting all properties.
function edit44_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit45_Callback(hObject, eventdata, handles)
global Var
Var.NCText.Laseraus1=get(handles.edit45,'String');


% --- Executes during object creation, after setting all properties.
function edit45_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit46_Callback(hObject, eventdata, handles)
global Var
Var.NCText.Laseraus2=get(handles.edit46,'String');


% --- Executes during object creation, after setting all properties.
function edit46_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit47_Callback(hObject, eventdata, handles)
global Var
Var.NCText.Laseraus3=get(handles.edit47,'String');


% --- Executes during object creation, after setting all properties.
function edit47_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit48_Callback(hObject, eventdata, handles)
global Var
Var.NCText.EbeneSta1=get(handles.edit48,'String');


% --- Executes during object creation, after setting all properties.
function edit48_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit49_Callback(hObject, eventdata, handles)
global Var
Var.NCText.EbeneSta2=get(handles.edit49,'String');


% --- Executes during object creation, after setting all properties.
function edit49_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit50_Callback(hObject, eventdata, handles)
global Var
Var.NCText.EbeneEnd1=get(handles.edit50,'String');


% --- Executes during object creation, after setting all properties.
function edit50_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit51_Callback(hObject, eventdata, handles)
global Var
Var.NCText.EbeneEnd2=get(handles.edit51,'String');


% --- Executes during object creation, after setting all properties.
function edit51_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
