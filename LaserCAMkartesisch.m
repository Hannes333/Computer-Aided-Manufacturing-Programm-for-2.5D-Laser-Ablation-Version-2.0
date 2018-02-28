function varargout = LaserCAMkartesisch(varargin)
% Dies ist das Skript zum Fenster LaserCAMkartesisch.fig
% In diesem Code werden alle Eingaben die auf dem LaserCAMkartesisch.fig getätigt
% werden ausgewertet.
% Aus diesem Skript kann ein weiteres Skript aufgerufen namens NCCodekartesisch.m
% Das entsprechende Fenster zu NCCodekartesisch.m lautett NCCodekartesisch.fig

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @LaserCAMkartesisch_OpeningFcn, ...
                   'gui_OutputFcn',  @LaserCAMkartesisch_OutputFcn, ...
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


% --- Executes just before LaserCAMkartesisch is made visible.
function LaserCAMkartesisch_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to LaserCAMkartesisch (see VARARGIN)

clc %Bereinigt das Command Window
set(handles.edit22,'String','LaserCAMkartesisch Version 2.0');

% Globales Struct zur Übergabe der Variabeln wird erstellt
global Var

%Ausgangsvariabeln werden definiert
Schichtdicke=0.1; %Höhenabstand der Schichten in [mm]
Strahlkompensation1=0; %Soll Strahlkompensation1 angewendet werden? (1=ja) (0=nein)
KonturAbstand1=0.01; %Um diesen Abstand wird die Aussenkontur nach Innen verschoben [mm]
Umrandung=0; %Soll die umrandungs Kontur abgefahren werden? (1=ja) (0=nein)
UmrandungBreakangle=30; %Wird dieser Winkel von Kante zu Kante überschritten, wird Skywrite eingefügt [Grad]
UmrandungSkywritestart=0.1; %Skywrite zur Beschleunigung der Spiegel und Galvamotoren [µs]
UmrandungSkywriteend=0.1; %Skywritelänge zur Abbremsung der Spiegel und Galvamotoren [µs]
Strahlkompensation2=0; %Soll Strahlkompensation2 angewendet werden? (1=ja) (0=nein)
KonturAbstand2=0.02; %Um diesen Abstand wird die Aussenkontur nach Innen verschoben [mm]
Schraffur=0; %Sollen die Schraffuren berechnet werden? (1=ja) (0=nein)
Linienabstand=0.1; %Abstand zwischen den Laserbahnen[mm]
LinienOffsets=1;    %Linien werden versetzt um Rillen zu vermeiden  (1=ja) (0=nein)
SchraffurSkywritestart=0.3; %Skywrite zur Beschleunigung der Spiegel und Galvamotoren [µs]
SchraffurSkywriteend=0.3; %Skywrite zur Abbremsung der Spiegel und Galvamotoren [µs]
Schraffurwinkelstart=0; %Richtungswinkel der ersten Schraffur [Grad]
Schraffurwinkelinkrem=23; %Richtungswinkel der darauf folgenden Schraffuren [Grad]
Hatchtyp=1; %Linienverlauf der Schraffuren (1=Rechteck) (0=Zickzack)
MinimalLaenge=0; %Minimale Hatchsegmentlänge [mm]
OnDelayLength=0; %Verschiebung der Startpunkte [mm] (l_on = v_s*t_on)
OffDelayLength=0; %Verschiebung der Startpunkte [mm] (l_off = v_s*t_off)
Scangeschw=500; %Einstellen der Scangeschwindigkeit [mm/s]
Jumpgeschw=1000; %Einstellen der Jumpgeschwindigkeit [mm/s]

%Ausgangsvariabeln werden auf den Feldern eingefügt
set(handles.edit5,'String',num2str(Schichtdicke));
set(handles.checkbox2,'Value',Strahlkompensation1);
set(handles.edit7,'String',num2str(KonturAbstand1));
set(handles.checkbox3,'Value',Umrandung);
set(handles.edit23,'String',num2str(UmrandungBreakangle));
set(handles.edit24,'String',num2str(UmrandungSkywritestart));
set(handles.edit25,'String',num2str(UmrandungSkywriteend));
set(handles.checkbox5,'Value',Strahlkompensation2);
set(handles.edit12,'String',num2str(KonturAbstand2));
set(handles.checkbox6,'Value',Schraffur);
set(handles.edit13,'String',num2str(Linienabstand));
set(handles.checkbox17,'Value',LinienOffsets);
set(handles.edit26,'String',num2str(SchraffurSkywritestart));
set(handles.edit27,'String',num2str(SchraffurSkywriteend));
set(handles.edit28,'String',num2str(Schraffurwinkelstart));
set(handles.edit29,'String',num2str(Schraffurwinkelinkrem));
set(handles.edit30,'String',num2str(MinimalLaenge));
set(handles.edit31,'String',num2str(OnDelayLength));
set(handles.edit32,'String',num2str(OffDelayLength));
set(handles.edit33,'String',num2str(Scangeschw));
set(handles.edit34,'String',num2str(Jumpgeschw));
if Hatchtyp==0 %(0=Zickzack)
    set(handles.checkbox16,'Value',1);
elseif Hatchtyp==1 %(1=Rechteck) 
    set(handles.checkbox15,'Value',1);
end

%Einige Ausgangsvariabeln werden als globale Variabeln gespeichert
Var.Schichtdicke=Schichtdicke;
Var.KonturAbstand1=KonturAbstand1;
Var.UmrandungBreakangle=UmrandungBreakangle;
Var.UmrandungSkywritestart=UmrandungSkywritestart;
Var.UmrandungSkywriteend=UmrandungSkywriteend;
Var.KonturAbstand2=KonturAbstand2;
Var.Linienabstand=Linienabstand;
Var.LinienOffsets=LinienOffsets;
Var.SchraffurSkywritestart=SchraffurSkywritestart;
Var.SchraffurSkywriteend=SchraffurSkywriteend;
Var.Schraffurwinkelstart=Schraffurwinkelstart;
Var.Schraffurwinkelinkrem=Schraffurwinkelinkrem;
Var.Hatchtyp=Hatchtyp;
Var.MinimalLaenge=MinimalLaenge;
Var.OnDelayLength=OnDelayLength;
Var.OffDelayLength=OffDelayLength;
Var.Scangeschw=Scangeschw;
Var.Jumpgeschw=Jumpgeschw;

%Ausgangswerte zum NC-Code werden definiert
Var.NCText.Header1='G90';
Var.NCText.Header2='G359';
Var.NCText.Header3='VELOCITY ON';
Var.NCText.Header4='';
Var.NCText.Header5='';
Var.NCText.Header6='';
Var.NCText.Header7='';
Var.NCText.Header8='';
Var.NCText.Header9='';
Var.NCText.Header10='';
Var.NCText.Fokus1='G00 Z(';
Var.NCText.Fokus2='+zFokus)';
Var.NCText.Eilgang1='G00 U';
Var.NCText.Eilgang2=' V';
Var.NCText.Eilgang3='';
Var.NCText.StartSky1='G08 G01 U';
Var.NCText.StartSky2=' V';
Var.NCText.StartSky3='';
Var.NCText.Laser1='G08 G01 U';
Var.NCText.Laser2=' V';
Var.NCText.Laser3='';
Var.NCText.EndSky1='G08 G01 U';
Var.NCText.EndSky2=' V';
Var.NCText.EndSky3='';
Var.NCText.Laseron='GALVO LASEROVERRIDE U ON';
Var.NCText.Laseroff='GALVO LASEROVERRIDE U OFF';
Var.NCText.Kommentar1='//';
Var.NCText.Kommentar2='';
Var.NCText.Finish1='END PROGRAM';
Var.NCText.Finish2='';
Var.NCText.Finish3='';
Var.NCText.Finish4='';
Var.NCText.Finish5='';
Var.NCText.EbeneSta1='CRITICAL START';
Var.NCText.EbeneSta2='';
Var.NCText.EbeneEnd1='CRITICAL END';
Var.NCText.EbeneEnd2='DWELL 1';

%Pfad, wo der NC-Code gespeichert werden soll
Var.FolderName='';

%Alle Felder bis auf den STL-Datei importieren Button müssen inaktiv sein
set(handles.checkbox1,'Enable','off');
set(handles.edit3,'Enable','off');
set(handles.edit4,'Enable','off');
set(handles.edit5,'Enable','off');
set(handles.checkbox2,'Enable','off');
set(handles.edit7,'Enable','off');
set(handles.checkbox3,'Enable','off');
set(handles.edit24,'Enable','off');
set(handles.edit25,'Enable','off');
set(handles.edit23,'Enable','off');
set(handles.checkbox5,'Enable','off');
set(handles.edit12,'Enable','off');
set(handles.checkbox6,'Enable','off');
set(handles.edit13,'Enable','off');
set(handles.edit26,'Enable','off');
set(handles.edit27,'Enable','off');
set(handles.edit28,'Enable','off');
set(handles.edit29,'Enable','off');
set(handles.edit30,'Enable','off');
set(handles.edit31,'Enable','off');
set(handles.edit32,'Enable','off');
set(handles.edit33,'Enable','off');
set(handles.edit34,'Enable','off');
set(handles.pushbutton2,'Enable','off');
set(handles.checkbox9,'Enable','off');
set(handles.checkbox10,'Enable','off');
set(handles.checkbox11,'Enable','off');
set(handles.checkbox12,'Enable','off');
set(handles.checkbox13,'Enable','off');
set(handles.checkbox14,'Enable','off');
set(handles.slider1,'Enable','off');
set(handles.pushbutton5,'Enable','off');
set(handles.pushbutton6,'Enable','off');
set(handles.pushbutton7,'Enable','off');
set(handles.pushbutton8,'Enable','off');
set(handles.edit22,'Enable','off');
set(handles.pushbutton10,'Enable','off');
set(handles.pushbutton11,'Enable','off');
set(handles.checkbox15,'Enable','off');
set(handles.checkbox16,'Enable','off');
set(handles.checkbox17,'Enable','off');

% Choose default command line output for LaserCAMkartesisch
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes LaserCAMkartesisch wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = LaserCAMkartesisch_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%Wird ausgeführt nach Benutzung von Button1 (Stl-Datei importieren)
function pushbutton1_Callback(hObject, eventdata, handles)
global Var

[FileName,PathName] = uigetfile('*.stl','Auswahl der Stl-Datei');
if ischar(FileName) && ischar(PathName)
    Pfad=[PathName,FileName];
    Titel=[FileName(1:end-4),'NCCode'];
    Var.Titel=Titel;
    
    %Funktion, die die Stl-Datei einliest
    [f,v,n] = F00_stlread(Pfad); 
    fv.vertices=v; %v enthält die Koordinaten der Eckpunkte
    fv.faces=f; %f sagt, welche drei Eckpunkte aus v ein Dreieck bilden
    %Übergabe der Variablen
    Var.v=v;
    Var.n=n;
    Var.f=f;
    Var.fv=fv;
    disp('Stl-Objekt eingelesen');

    %Ausgabe Höchster Punkt Stl-Datei und Tiefster Punkt Stl-Datei
    Stloben=max(v(:,3)); %Z-Koordinate des höchstgelegensten Stl-Objekt Punktes [mm]
    Stlunten=min(v(:,3)); %Z-Koordinate des tiefstgelegensten Stl-Objekt Punktes [mm]
    set(handles.edit1,'String',Stloben);
    set(handles.edit2,'String',Stlunten);
    Var.Stloben=Stloben;

    %Darstellung des Stl-objekts
    cla %Grafik zurücksetzen
    FDStlObjekt(1,fv);
    view([-40 50]); %Set a nice view angle

    %Funktion, die die Schnitthoehen berechnet wird aufgerufen
    Schichtdicke=str2double(get(handles.edit5,'String'));
    Auswahlhoehen=0;
    Auswahlhoeheoben=Stloben;
    Auswahlhoeheunten=Stlunten;
    [Schnitthoehen,Zoben,Zunten,Schichtdicke]=F05_Schnitthoehen(v,Schichtdicke,Auswahlhoehen,Auswahlhoeheoben,Auswahlhoeheunten);
    Var.Schichtdicke=Schichtdicke;
    Var.Schnitthoehen=Schnitthoehen;
    Var.Zoben=Zoben;
    Var.Zunten=Zunten;

    %Aktualisierung einiger Felder auf dem GUI
    set(handles.edit5,'String',Schichtdicke);
    set(handles.edit6,'String',length(Schnitthoehen));
    set(handles.edit3,'String',Zoben);
    set(handles.edit4,'String',Zunten);

    %Häcken werden auf aus zurückgesetzt
    set(handles.checkbox9,'Value',0);
    set(handles.checkbox10,'Value',0);
    set(handles.checkbox11,'Value',0);
    set(handles.checkbox12,'Value',0);
    set(handles.checkbox13,'Value',0);
    set(handles.checkbox14,'Value',0);
    
    %Entsprechende Felder auf dem GUI müssen auswählbar sein
    set(handles.checkbox1,'Enable','on');
    set(handles.checkbox1,'Value',0);
    set(handles.edit3,'Enable','off');
    set(handles.edit4,'Enable','off');
    set(handles.edit5,'Enable','on');
    set(handles.checkbox2,'Enable','on');
    set(handles.pushbutton2,'Enable','on');
    set(handles.pushbutton10,'Enable','on');
    set(handles.pushbutton11,'Enable','on');
        
    %Schalflächen zur Strahlkompensation1 werden aktiviert
    Strahlkompensation1=get(handles.checkbox2,'Value');
    if Strahlkompensation1==1
        set(handles.edit7,'Enable','on');
    else
        set(handles.edit7,'Enable','off');
    end

    %Schalflächen zur Konturumrandung werden richtig aktiviert
    set(handles.checkbox3,'Enable','on');
    Umrandung=get(handles.checkbox3,'Value');
    if Umrandung==1
        set(handles.edit23,'Enable','on');
        set(handles.edit24,'Enable','on');
        set(handles.edit25,'Enable','on');
        set(handles.checkbox5,'Enable','on');
        Strahlkompensation2=get(handles.checkbox5,'Value');
        if Strahlkompensation2==1
            set(handles.edit12,'Enable','on');
        else
            set(handles.edit12,'Enable','off');
        end
    else
        set(handles.edit23,'Enable','off');
        set(handles.edit24,'Enable','off');
        set(handles.edit25,'Enable','off');
        set(handles.checkbox5,'Enable','off');
        set(handles.edit12,'Enable','off');
    end

    %Schalflächen zur Schraffur werden richtig aktiviert
    set(handles.checkbox6,'Enable','on');
    Schraffuren=get(handles.checkbox6,'Value');
    if Schraffuren==1
        set(handles.edit13,'Enable','on');
        set(handles.edit26,'Enable','on');
        set(handles.edit27,'Enable','on');
        set(handles.edit28,'Enable','on');
        set(handles.edit29,'Enable','on');
        set(handles.edit30,'Enable','on');
        set(handles.edit31,'Enable','on');
        set(handles.edit32,'Enable','on');
        set(handles.edit33,'Enable','on');
        set(handles.edit34,'Enable','on');
        set(handles.checkbox15,'Enable','on');
        set(handles.checkbox16,'Enable','on');
        set(handles.checkbox17,'Enable','on');
    else
        set(handles.edit13,'Enable','off');
        set(handles.edit26,'Enable','off');
        set(handles.edit27,'Enable','off');
        set(handles.edit28,'Enable','off');
        set(handles.edit29,'Enable','off');
        set(handles.edit30,'Enable','off');
        set(handles.edit31,'Enable','off');
        set(handles.edit32,'Enable','off');
        set(handles.edit33,'Enable','off');
        set(handles.edit34,'Enable','off');
        set(handles.checkbox15,'Enable','off');
        set(handles.checkbox16,'Enable','off');
        set(handles.checkbox17,'Enable','off');
    end
    
    %Schalflächen mit Ansichtwerzeugen werden aktiviert
    set(handles.pushbutton5,'Enable','on');
    set(handles.pushbutton6,'Enable','on');
    set(handles.pushbutton7,'Enable','on');
end

%Wird ausgeführt nach Benutzung von edit1 (Höchster Punkt Stl-Datei)
function edit1_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Wird ausgeführt nach Benutzung von edit2 (Tiefster Punkt Stl-Datei)
function edit2_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Wird ausgeführt nach Benutzung von checkbox1 (Auswahl Bearbeitungsbereich Slicing)
function checkbox1_Callback(hObject, eventdata, handles)
global Var

%Aktualisierung einiger Felder bezüglich des Sclicing
Auswahlhoehen=get(hObject,'Value');
if Auswahlhoehen==1
    set(handles.edit3,'Enable','on');
    set(handles.edit4,'Enable','on');
else
    set(handles.edit3,'Enable','off');
    set(handles.edit4,'Enable','off')
end

%Funktion, die die Schnitthoehen berechnet wird aufgerufen
Schichtdicke=str2double(get(handles.edit5,'String'));
Auswahlhoehen=get(handles.checkbox1,'Value');
Auswahlhoeheoben=str2double(get(handles.edit3,'String'));
Auswahlhoeheunten=str2double(get(handles.edit4,'String'));
[Schnitthoehen,Zoben,Zunten,Schichtdicke]=F05_Schnitthoehen(Var.v,Schichtdicke,Auswahlhoehen,Auswahlhoeheoben,Auswahlhoeheunten);
Var.Schichtdicke=Schichtdicke;
Var.Schnitthoehen=Schnitthoehen;
Var.Zoben=Zoben;
Var.Zunten=Zunten;

%Aktualisierung einiger Felder auf dem GUI
set(handles.edit5,'String',Schichtdicke);
set(handles.edit6,'String',length(Schnitthoehen));
set(handles.edit3,'String',Zoben);
set(handles.edit4,'String',Zunten);

%Wird ausgeführt nach Benutzung von edit3 (Auswahlhöhe oben)
function edit3_Callback(hObject, eventdata, handles)
global Var
%Eingabe in edit3 wird ausgewertet
Auswahlhoeheoben=str2double(get(handles.edit3,'String'));
if isnan(Auswahlhoeheoben)
    warndlg('Ungültige Eingabe')
else
    %Funktion, die die Schnitthoehen berechnet wird aufgerufen
    Schichtdicke=str2double(get(handles.edit5,'String'));
    Auswahlhoehen=get(handles.checkbox1,'Value');
    Auswahlhoeheunten=str2double(get(handles.edit4,'String'));
    [Schnitthoehen,Zoben,Zunten,Schichtdicke]=F05_Schnitthoehen(Var.v,Schichtdicke,Auswahlhoehen,Auswahlhoeheoben,Auswahlhoeheunten);
    Var.Schichtdicke=Schichtdicke;
    Var.Schnitthoehen=Schnitthoehen;
    Var.Zoben=Zoben;
    Var.Zunten=Zunten;

    %Aktualisierung einiger Felder auf dem GUI
    set(handles.edit5,'String',Schichtdicke);
    set(handles.edit6,'String',length(Schnitthoehen));
    set(handles.edit3,'String',Zoben);
    set(handles.edit4,'String',Zunten);
end


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Wird ausgeführt nach Benutzung von edit4 (Auswahlhöhe unten)
function edit4_Callback(hObject, eventdata, handles)
global Var
%Eingabe in edit4 wird ausgewertet
Auswahlhoeheunten=str2double(get(handles.edit4,'String'));
if isnan(Auswahlhoeheunten)
    warndlg('Ungültige Eingabe')
else
    %Funktion, die die Schnitthoehen berechnet wird aufgerufen
    Schichtdicke=str2double(get(handles.edit5,'String'));
    Auswahlhoehen=get(handles.checkbox1,'Value');
    Auswahlhoeheoben=str2double(get(handles.edit3,'String'));
    Auswahlhoeheunten=str2double(get(handles.edit4,'String'));
    [Schnitthoehen,Zoben,Zunten,Schichtdicke]=F05_Schnitthoehen(Var.v,Schichtdicke,Auswahlhoehen,Auswahlhoeheoben,Auswahlhoeheunten);
    Var.Schichtdicke=Schichtdicke;
    Var.Schnitthoehen=Schnitthoehen;
    Var.Zoben=Zoben;
    Var.Zunten=Zunten;

    %Aktualisierung einiger Felder auf dem GUI
    set(handles.edit5,'String',Schichtdicke);
    set(handles.edit6,'String',length(Schnitthoehen));
    set(handles.edit3,'String',Zoben);
    set(handles.edit4,'String',Zunten);
end

% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Wird ausgeführt nach Benutzung von edit5 (Schichtdicke)
function edit5_Callback(hObject, eventdata, handles)
global Var
%Funktion, die die Schnitthoehen berechnet wird aufgerufen
Schichtdicke=str2double(get(handles.edit5,'String'));
if Schichtdicke==0
    warndlg('Schichtdicke muss grösser Null sein')
    set(handles.edit5,'String',num2str(Var.Schichtdicke));
elseif isnan(Schichtdicke)
    warndlg('Ungültige Eingabe')
    set(handles.edit5,'String',num2str(Var.Schichtdicke));
else
    if Schichtdicke<0
        set(handles.edit5,'String',num2str(abs(Schichtdicke)));
        Schichtdicke=abs(Schichtdicke);
    end
    Auswahlhoehen=get(handles.checkbox1,'Value');
    Auswahlhoeheoben=str2double(get(handles.edit3,'String'));
    Auswahlhoeheunten=str2double(get(handles.edit4,'String'));
    [Schnitthoehen,Zoben,Zunten,Schichtdicke]=F05_Schnitthoehen(Var.v,Schichtdicke,Auswahlhoehen,Auswahlhoeheoben,Auswahlhoeheunten);
    Var.Schichtdicke=Schichtdicke;
    Var.Schnitthoehen=Schnitthoehen;
    Var.Zoben=Zoben;
    Var.Zunten=Zunten;

    %Aktualisierung einiger Felder auf dem GUI
    set(handles.edit5,'String',Schichtdicke);
    set(handles.edit6,'String',length(Schnitthoehen));
    set(handles.edit3,'String',Zoben);
    set(handles.edit4,'String',Zunten);
end

% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Wird ausgeführt nach Benutzung von edit 6 (Anzahl Schichten)
function edit6_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Wird ausgeführt nach Benutzung von checkbox2 (Strahlkompensation 1)
function checkbox2_Callback(hObject, eventdata, handles)
%Entsprechende Unterfelder von checkbox2 werden richtig aktiviert
Strahlkompensation1=get(hObject,'Value');
if Strahlkompensation1==1
    set(handles.edit7,'Enable','on');
else
    set(handles.edit7,'Enable','off');
end

%Wird ausgeführt nach Benutzung von edit7 (Konturabstand 1)
function edit7_Callback(hObject, eventdata, handles)
global Var
%Eingabe in edit7 wird ausgewertet
KonturAbstand1=str2double(get(handles.edit7,'String'));
if KonturAbstand1<0
    set(handles.edit7,'String',num2str(abs(KonturAbstand1)));
elseif KonturAbstand1==0
    warndlg('Konturabstand1 muss grösser Null sein')
    set(handles.edit7,'String',num2str(Var.KonturAbstand1));
elseif isnan(KonturAbstand1)
    warndlg('Ungültige Eingabe')
    set(handles.edit7,'String',num2str(Var.KonturAbstand1));
else
    Var.KonturAbstand1=KonturAbstand1;
end

% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Wird ausgeführt nach Benutzung von checkbox3 (Konturumrandung)
function checkbox3_Callback(hObject, eventdata, handles)
%Entsprechende Unterfelder von checkbox3 werden richtig aktiviert
Umrandung=get(handles.checkbox3,'Value');
if Umrandung==1
    set(handles.edit24,'Enable','on');
    set(handles.edit25,'Enable','on');
    set(handles.edit23,'Enable','on');
    set(handles.checkbox5,'Enable','on');
    Strahlkompensation2=get(handles.checkbox5,'Value');
    if Strahlkompensation2==1
        set(handles.edit12,'Enable','on');
    else
        set(handles.edit12,'Enable','off');
    end
else
    set(handles.edit24,'Enable','off');
    set(handles.edit25,'Enable','off');
    set(handles.edit23,'Enable','off');
    set(handles.checkbox5,'Value',0);
    set(handles.checkbox5,'Enable','off');
    set(handles.edit12,'Enable','off');
end

%Wird ausgeführt nach Benutzung von edit23 (Breakangle)
function edit23_Callback(hObject, eventdata, handles)
global Var
UmrandungBreakangle=str2double(get(handles.edit23,'String'));
if UmrandungBreakangle<0
    set(handles.edit23,'String',num2str(abs(UmrandungBreakangle)));
    Var.UmrandungBreakangle=abs(UmrandungBreakangle);
elseif isnan(UmrandungBreakangle)
    warndlg('Ungültige Eingabe')
    set(handles.edit23,'String',num2str(Var.UmrandungBreakangle));
else
    Var.UmrandungBreakangle=UmrandungBreakangle;
end

% --- Executes during object creation, after setting all properties.
function edit23_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Wird ausgeführt nach Benutzung von edit24 (Skywrite Startlänge)
function edit24_Callback(hObject, eventdata, handles)
global Var
UmrandungSkywritestart=str2double(get(handles.edit24,'String'));
if UmrandungSkywritestart<0
    set(handles.edit24,'String',num2str(abs(UmrandungSkywritestart)));
   Var.UmrandungSkywritestart=abs(UmrandungSkywritestart);
elseif isnan(UmrandungSkywritestart)
    warndlg('Ungültige Eingabe')
    set(handles.edit24,'String',num2str(Var.UmrandungSkywritestart));
else
    Var.UmrandungSkywritestart=UmrandungSkywritestart;
end

% --- Executes during object creation, after setting all properties.
function edit24_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Wird ausgeführt nach Benutzung von edit25 (Skywrite Endlänge)
function edit25_Callback(hObject, eventdata, handles)
global Var
UmrandungSkywriteend=str2double(get(handles.edit25,'String'));
if UmrandungSkywriteend<0
    set(handles.edit11,'String',num2str(abs(UmrandungSkywriteend)));
    Var.UmrandungSkywriteend=abs(UmrandungSkywriteend);
elseif isnan(UmrandungSkywriteend)
    warndlg('Ungültige Eingabe')
    set(handles.edit11,'String',num2str(Var.UmrandungSkywriteend));
else
    Var.UmrandungSkywriteend=UmrandungSkywriteend;
end

% --- Executes during object creation, after setting all properties.
function edit25_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Wird ausgeführt nach Benutzung von checkbox5 (Strahlkompensation 2)
function checkbox5_Callback(hObject, eventdata, handles)
Strahlkompensation2=get(handles.checkbox5,'Value');
if Strahlkompensation2==1
    set(handles.edit12,'Enable','on');
else
    set(handles.edit12,'Enable','off');
end

%Wird ausgeführt nach Benutzung von edit12 (Konturabstand 2)
function edit12_Callback(hObject, eventdata, handles)
global Var
KonturAbstand2=str2double(get(handles.edit12,'String'));
if KonturAbstand2<0
    set(handles.edit12,'String',num2str(abs(KonturAbstand2)));
    Var.KonturAbstand2=abs(KonturAbstand2);
elseif KonturAbstand2==0
    warndlg('Konturabstand 2 muss grösser Null sein')
    set(handles.edit12,'String',num2str(Var.KonturAbstand2));
elseif isnan(KonturAbstand2)
    warndlg('Ungültige Eingabe')
    set(handles.edit12,'String',num2str(Var.KonturAbstand2));
else
	Var.KonturAbstand2=KonturAbstand2;
end

% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Wird ausgeführt nach Benutzung von checkbox6 (Schraffuren)
function checkbox6_Callback(hObject, eventdata, handles)
%Entsprechende Unterfelder von Schraffuren werden richtig aktiviert
Schraffuren=get(handles.checkbox6,'Value');
if Schraffuren==1
    set(handles.edit13,'Enable','on');
    set(handles.edit26,'Enable','on');
    set(handles.edit27,'Enable','on');
    set(handles.edit28,'Enable','on');
    set(handles.edit29,'Enable','on');
    set(handles.edit30,'Enable','on');
    set(handles.edit31,'Enable','on');
    set(handles.edit32,'Enable','on');
    set(handles.edit33,'Enable','on');
    set(handles.edit34,'Enable','on');
    set(handles.checkbox15,'Enable','on');
    set(handles.checkbox16,'Enable','on');
    set(handles.checkbox17,'Enable','on');
else
    set(handles.edit13,'Enable','off');
    set(handles.edit26,'Enable','off');
    set(handles.edit27,'Enable','off');
    set(handles.edit28,'Enable','off');
    set(handles.edit29,'Enable','off');
    set(handles.edit30,'Enable','off');
    set(handles.edit31,'Enable','off');
    set(handles.edit32,'Enable','off');
    set(handles.edit33,'Enable','off');
    set(handles.edit34,'Enable','off');
    set(handles.checkbox15,'Enable','off');
    set(handles.checkbox16,'Enable','off');
    set(handles.checkbox17,'Enable','off');
end

%Wird ausgeführt nach Benutzung von edit13 (Linienabstand
function edit13_Callback(hObject, eventdata, handles)
global Var
Linienabstand=str2double(get(handles.edit13,'String'));
if Linienabstand<0
    set(handles.edit13,'String',num2str(abs(Linienabstand)));
    Var.Linienabstand=abs(Linienabstand);
elseif Linienabstand==0
    warndlg('Der Linienabstand muss grösser Null sein')
    set(handles.edit13,'String',num2str(Var.Linienabstand));
elseif isnan(Linienabstand)
    warndlg('Ungültige Eingabe')
    set(handles.edit13,'String',num2str(Var.Linienabstand));
else
    Var.Linienabstand=Linienabstand;
end

% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Wird ausgeführt nach Benutzung von edit26 (Skywrite Startlänge)
function edit26_Callback(hObject, eventdata, handles)
global Var
SchraffurSkywritestart=str2double(get(handles.edit26,'String'));
if SchraffurSkywritestart<0
    set(handles.edit26,'String',num2str(abs(SchraffurSkywritestart)));
    Var.SchraffurSkywritestart=abs(SchraffurSkywritestart);
elseif isnan(SchraffurSkywritestart)
    warndlg('Ungültige Eingabe')
    set(handles.edit26,'String',num2str(Var.SchraffurSkywritestart));
else
    Var.SchraffurSkywritestart=SchraffurSkywritestart;
end

% --- Executes during object creation, after setting all properties.
function edit26_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Wird ausgeführt nach Benutzung von edit 27 (Skywrite Endlänge)
function edit27_Callback(hObject, eventdata, handles)
global Var
SchraffurSkywriteend=str2double(get(handles.edit27,'String'));
if SchraffurSkywriteend<0
    set(handles.edit27,'String',num2str(abs(SchraffurSkywriteend)));
    Var.SchraffurSkywriteend=abs(SchraffurSkywriteend);
elseif isnan(SchraffurSkywriteend)
    warndlg('Ungültige Eingabe')
    set(handles.edit27,'String',num2str(Var.SchraffurSkywriteend));
else
    Var.SchraffurSkywriteend=SchraffurSkywriteend;
end

% --- Executes during object creation, after setting all properties.
function edit27_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Wird ausgeführt nach Benutzung von edit28 (Schraffurwinkelstart)
function edit28_Callback(hObject, eventdata, handles)
global Var
Schraffurwinkelstart=str2double(get(handles.edit28,'String'));
if isnan(Schraffurwinkelstart)
    warndlg('Ungültige Eingabe')
    set(handles.edit28,'String',num2str(Var.Schraffurwinkelstart));
else
    Var.Schraffurwinkelstart=Schraffurwinkelstart;
end

% --- Executes during object creation, after setting all properties.
function edit28_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Wird ausgeführt nach Benutzung von edit29 (Winkelinkrement)
function edit29_Callback(hObject, eventdata, handles)
global Var
Schraffurwinkelinkrem=str2double(get(handles.edit29,'String'));
if isnan(Schraffurwinkelinkrem)
    warndlg('Ungültige Eingabe')
    set(handles.edit29,'String',num2str(Var.Schraffurwinkelinkrem));
else
    Var.Schraffurwinkelinkrem=Schraffurwinkelinkrem;
end

% --- Executes during object creation, after setting all properties.
function edit29_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Wird ausgeführt nach Benutzung von edit30 (Minimallänge)
function edit30_Callback(hObject, eventdata, handles)
global Var
MinimalLaenge=str2double(get(handles.edit30,'String'));
if MinimalLaenge<0
    set(handles.edit30,'String',num2str(abs(MinimalLaenge)));
    Var.MinimalLaenge=abs(MinimalLaenge);
elseif isnan(MinimalLaenge)
    warndlg('Ungültige Eingabe')
    set(handles.edit30,'String',num2str(Var.MinimalLaenge));
else
    Var.MinimalLaenge=MinimalLaenge;
end

% --- Executes during object creation, after setting all properties.
function edit30_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Wird ausgeführt nach Benutzung von edit31 (OnDelaylänge)
function edit31_Callback(hObject, eventdata, handles)
global Var
OnDelayLength=str2double(get(handles.edit31,'String'));
if OnDelayLength<0
    set(handles.edit31,'String',num2str(abs(OnDelayLength)));
    Var.OnDelayLength=abs(OnDelayLength);
elseif isnan(OnDelayLength)
    warndlg('Ungültige Eingabe')
    set(handles.edit31,'String',num2str(Var.OnDelayLength));
else
    Var.OnDelayLength=OnDelayLength;
end

% --- Executes during object creation, after setting all properties.
function edit31_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Wird ausgeführt nach Benutzung von edit32 (OffDelaylänge)
function edit32_Callback(hObject, eventdata, handles)
global Var
OffDelayLength=str2double(get(handles.edit32,'String'));
if OffDelayLength<0
    set(handles.edit32,'String',num2str(abs(OffDelayLength)));
    Var.OffDelayLength=abs(OffDelayLength);
elseif isnan(OffDelayLength)
    warndlg('Ungültige Eingabe')
    set(handles.edit32,'String',num2str(Var.OnDelayLength));
else
    Var.OffDelayLength=OffDelayLength;
end

% --- Executes during object creation, after setting all properties.
function edit32_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Wird ausgeführt nach Benutzung von edit33 (Scangeschwindigkeit)
function edit33_Callback(hObject, eventdata, handles)
global Var
Scangeschw=str2double(get(handles.edit33,'String'));
if Scangeschw<0
    set(handles.edit33,'String',num2str(abs(Scangeschw)));
    Var.Scangeschw=abs(Scangeschw);
elseif isnan(Scangeschw)
    warndlg('Ungültige Eingabe')
    set(handles.edit33,'String',num2str(Var.Scangeschw));
else
    Var.Scangeschw=Scangeschw;
end

% --- Executes during object creation, after setting all properties.
function edit33_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Wird ausgeführt nach Benutzung von edit34 (Jumpgeschwindigkeit)
function edit34_Callback(hObject, eventdata, handles)
global Var
Jumpgeschw=str2double(get(handles.edit34,'String'));
if Jumpgeschw<0
    set(handles.edit34,'String',num2str(abs(Jumpgeschw)));
    Var.Jumpgeschw=abs(Jumpgeschw);
elseif isnan(Jumpgeschw)
    warndlg('Ungültige Eingabe')
    set(handles.edit34,'String',num2str(Var.Jumpgeschw));
else
    Var.Jumpgeschw=Jumpgeschw;
end

% --- Executes during object creation, after setting all properties.
function edit34_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Wird ausgeführt nach Benutzung von pushbutton2 (Laserbahnen berechnen)
function pushbutton2_Callback(hObject, eventdata, handles)
global Var
%Zusammensuchen der benötigten Werte
Schichtdicke=str2double(get(handles.edit5,'String'));
Schnitthoehen=Var.Schnitthoehen;
v=Var.v;
n=Var.n;
f=Var.f;
fv=Var.fv;
Zoben=Var.Zoben;
Titel=Var.Titel;
Strahlkompensation1=get(handles.checkbox2,'Value');
KonturAbstand1=str2double(get(handles.edit7,'String'));
Umrandung=get(handles.checkbox3,'Value');
UmrandungBreakangle=str2double(get(handles.edit23,'String'));
UmrandungSkywritestart=str2double(get(handles.edit24,'String'));
UmrandungSkywriteend=str2double(get(handles.edit25,'String'));
Strahlkompensation2=get(handles.checkbox5,'Value');
KonturAbstand2=str2double(get(handles.edit12,'String'));
Schraffur=get(handles.checkbox6,'Value');
Linienabstand=str2double(get(handles.edit13,'String'));
LinienOffsets=get(handles.checkbox17,'Value');
SchraffurSkywritestart=str2double(get(handles.edit26,'String'));
SchraffurSkywriteend=str2double(get(handles.edit27,'String'));
Schraffurwinkelstart=str2double(get(handles.edit28,'String'));
Schraffurwinkelinkrem=str2double(get(handles.edit29,'String'));
MinimalLaenge=str2double(get(handles.edit30,'String'));
OnDelayLength=str2double(get(handles.edit31,'String'));
OffDelayLength=str2double(get(handles.edit32,'String'));
Scangeschw=str2double(get(handles.edit33,'String'));
Jumpgeschw=str2double(get(handles.edit34,'String'));
if get(handles.checkbox15,'Value')==1
    Hatchtyp=1; %(1=Rechteck) 
elseif get(handles.checkbox16,'Value')==1
    Hatchtyp=0; %(0=Dreieck)
end

%Ebene die Dargestellt werden soll
d=1; 

%Aktualisierung edit 22
Hoehe=flipud(Var.Schnitthoehen);
set(handles.edit22,'String',['Ebene: ',num2str(d),'   Schnitthöhe: ',num2str(Hoehe(d))]); 

%Darstellung des Stl-objekts
cla %Grafik zurücksetzen
FDStlObjekt(1,fv);
view([-40 50]); %Set a nice view angle

%Funktion, die die Slices macht wird aufgerufen
disp('Slices werden berechnet...');
[Konturen0]=F10_Slicing( f,v,Schnitthoehen,Schichtdicke );
disp('Slices berechnet');

%Die Schichten werden absteigend sortiert
Konturen0=flipud(Konturen0); %Oberste Schnittebene ist nun im obersten CellArray Eintrag
Var.Konturen0=Konturen0;

%Darstellung der Schnittkonturen 
FDSchnittkontur(1,d,Konturen0);

%Entsprechende Schaltflächen zur Darstellung werden sichtbar gemacht
set(handles.checkbox9,'Enable','on'); %Checkbox Darstellung Stl-Objekt
set(handles.checkbox9,'Value',1); %Checkbox Darstellung Stl-Objekt
set(handles.checkbox10,'Enable','on'); %Checkbox Darstellung Schnittkontur
set(handles.checkbox10,'Value',1); %Checkbox Darstellung Schnittkontur

%Funktion, die die Strahlkompensation 1 berechnet
if Strahlkompensation1==1
    bar = waitbar(0,'Strahlkompensation 1 wird berechnet...'); %Ladebalken erstellen
    Konturen1=cell(size(Konturen0));
    for k=1:size(Konturen0,1) %Index, der durch die Ebenen von ClosedCurves geht
        Kontur1=Konturen0(k,:);
        [Kontur1]=F20_Strahlkomp( Kontur1,n,KonturAbstand1 ); %Funktion die die Strahlkompensation berechnet
        Konturen1(k,1:size(Kontur1,2))=Kontur1;
        waitbar(k / size(Konturen0,1)) %Ladebalken aktualisieren
    end
    close(bar) %Ladebalken schliessen
else
    Konturen1=Konturen0;
end
Var.Konturen1=Konturen1;

%Darstellung der Schnittlinien mit Strahlkompensation1
if Strahlkompensation1==1
    FDSchnittkontur(1,d,Konturen1);
    set(handles.checkbox11,'Enable','on'); %Checkbox Darstellung Strahlkompensation1
    set(handles.checkbox11,'Value',1); %Checkbox Darstellung Strahlkompensation1
end

%Funktion, die die Umrandungskontur berechnet
if Umrandung==1
    [UmrandungKonturen,Bearbeitungszeit1]= F30_Umrandung( Konturen1,UmrandungBreakangle,UmrandungSkywritestart,UmrandungSkywriteend,Scangeschw,Jumpgeschw);
else
    UmrandungKonturen=cell(size(Konturen1));
    Bearbeitungszeit1=0;
end
Var.UmrandungKonturen=UmrandungKonturen;

%Darstellung der Umrandungskontur
if Umrandung==1
    FDUmrandung(1,d,UmrandungKonturen);
    set(handles.checkbox13,'Enable','on'); %Checkbox Darstellung Umrandung
    set(handles.checkbox13,'Value',1); %Checkbox Darstellung Umrandung
end

%Funktion, die die Strahlkompensation 2 berechnet
if Strahlkompensation2==1
    bar = waitbar(0,'Strahlkompensation 2 wird berechnet...'); %Ladebalken erstellen
    Konturen2=cell(size(Konturen1));
    for k=1:size(Konturen1,1) %Index, der durch die Ebenen von ClosedCurves geht
        Kontur2=Konturen1(k,:);
        [Kontur2]=F20_Strahlkomp( Kontur2,n,KonturAbstand2 ); %Funktion die die Strahlkompensation berechnet
        Konturen2(k,1:size(Kontur2,2))=Kontur2;
        waitbar(k / size(Konturen0,1)) %Ladebalken aktualisieren
    end
    close(bar) %Ladebalken schliessen
else
    Konturen2=Konturen1;
end
Var.Konturen2=Konturen2;

%Darstellung der Schnittlinien mit Strahlkompensation2
if Strahlkompensation2==1
    FDSchnittkontur(1,d,Konturen2);
    set(handles.checkbox12,'Enable','on'); %Checkbox Darstellung Strahlkompensation2
    set(handles.checkbox12,'Value',1); %Checkbox Darstellung Kontur
end

%Funktion, die die Schraffuren berechnet
if Schraffur==1
    [Schraffuren,Bearbeitungszeit2]=F40_Schraffuren(...
        Konturen2,Linienabstand,LinienOffsets,SchraffurSkywritestart,SchraffurSkywriteend,...
        Schraffurwinkelstart,Schraffurwinkelinkrem,...
        Hatchtyp,MinimalLaenge,OnDelayLength,OffDelayLength,Scangeschw,Jumpgeschw);
else
    Schraffuren=cell(size(Konturen2,1),1);
    Bearbeitungszeit2=0;
end
Var.Schraffuren=Schraffuren;

%Bearbeitungszeit auf Benutzeroberfläche anzeigen
Bearbeitungszeit=Bearbeitungszeit1+Bearbeitungszeit2;
set(handles.edit35,'String',['Geschätze Bearbeitungszeit: ',num2str(round(Bearbeitungszeit/60)),'min ',num2str(mod(Bearbeitungszeit,60),'%4.1f'),'s']); 

%Darstellung der Schraffuren
if Schraffur==1
    FDSchraffur(1,d,Schraffuren);
    set(handles.checkbox14,'Enable','on'); %Checkbox Darstellung Schraffuren
    set(handles.checkbox14,'Value',1); %Checkbox Darstellung Schraffuren
end

%Aktivierung Slider
set(handles.slider1,'Min',-length(Schnitthoehen)-0.1);
set(handles.slider1,'Value',-1);
set(handles.slider1,'Enable','on');

%Pushbutton 8 (NC-Code erstellen) wird aktiviert 
set(handles.pushbutton8,'Enable','on');


%Wird ausgeführt nach Benutzung von checkbox9 (Stl-Objekt)
function checkbox9_Callback(hObject, eventdata, handles)
global Var
DStlObjekt=get(handles.checkbox9,'Value');
DKontur0=get(handles.checkbox10,'Value');
DKontur1=get(handles.checkbox11,'Value');
DKontur2=get(handles.checkbox12,'Value');
DUmrandung=get(handles.checkbox13,'Value');
DSchraffur=get(handles.checkbox14,'Value');
d=abs(get(handles.slider1,'Value'));
cla
FDStlObjekt(DStlObjekt,Var.fv);
FDSchnittkontur(DKontur0,d,Var.Konturen0);
FDSchnittkontur(DKontur1,d,Var.Konturen1);
FDSchnittkontur(DKontur2,d,Var.Konturen2);
FDUmrandung(DUmrandung,d,Var.UmrandungKonturen);
FDSchraffur(DSchraffur,d,Var.Schraffuren);

%Wird ausgeführt nach Benutzung von checkbox10 (Schnittkontur)
function checkbox10_Callback(hObject, eventdata, handles)
global Var
DStlObjekt=get(handles.checkbox9,'Value');
DKontur0=get(handles.checkbox10,'Value');
DKontur1=get(handles.checkbox11,'Value');
DKontur2=get(handles.checkbox12,'Value');
DUmrandung=get(handles.checkbox13,'Value');
DSchraffur=get(handles.checkbox14,'Value');
d=abs(get(handles.slider1,'Value'));
cla
FDStlObjekt(DStlObjekt,Var.fv);
FDSchnittkontur(DKontur0,d,Var.Konturen0);
FDSchnittkontur(DKontur1,d,Var.Konturen1);
FDSchnittkontur(DKontur2,d,Var.Konturen2);
FDUmrandung(DUmrandung,d,Var.UmrandungKonturen);
FDSchraffur(DSchraffur,d,Var.Schraffuren);

%Wird ausgeführt nach Benutzung von checkbox11 (Kontur Strahlkompensation1)
function checkbox11_Callback(hObject, eventdata, handles)
global Var
DStlObjekt=get(handles.checkbox9,'Value');
DKontur0=get(handles.checkbox10,'Value');
DKontur1=get(handles.checkbox11,'Value');
DKontur2=get(handles.checkbox12,'Value');
DUmrandung=get(handles.checkbox13,'Value');
DSchraffur=get(handles.checkbox14,'Value');
d=abs(get(handles.slider1,'Value'));
cla
FDStlObjekt(DStlObjekt,Var.fv);
FDSchnittkontur(DKontur0,d,Var.Konturen0);
FDSchnittkontur(DKontur1,d,Var.Konturen1);
FDSchnittkontur(DKontur2,d,Var.Konturen2);
FDUmrandung(DUmrandung,d,Var.UmrandungKonturen);
FDSchraffur(DSchraffur,d,Var.Schraffuren);

%Wird ausgeführt nach Benutzung von checkbox12 (Kontur Strahlkompensation)
function checkbox12_Callback(hObject, eventdata, handles)
global Var
DStlObjekt=get(handles.checkbox9,'Value');
DKontur0=get(handles.checkbox10,'Value');
DKontur1=get(handles.checkbox11,'Value');
DKontur2=get(handles.checkbox12,'Value');
DUmrandung=get(handles.checkbox13,'Value');
DSchraffur=get(handles.checkbox14,'Value');
d=abs(get(handles.slider1,'Value'));
cla
FDStlObjekt(DStlObjekt,Var.fv);
FDSchnittkontur(DKontur0,d,Var.Konturen0);
FDSchnittkontur(DKontur1,d,Var.Konturen1);
FDSchnittkontur(DKontur2,d,Var.Konturen2);
FDUmrandung(DUmrandung,d,Var.UmrandungKonturen);
FDSchraffur(DSchraffur,d,Var.Schraffuren);

%Wird ausgeführt nach Benutzung von checkbox13 (Laserbahnen Umrandung)
function checkbox13_Callback(hObject, eventdata, handles)
global Var
DStlObjekt=get(handles.checkbox9,'Value');
DKontur0=get(handles.checkbox10,'Value');
DKontur1=get(handles.checkbox11,'Value');
DKontur2=get(handles.checkbox12,'Value');
DUmrandung=get(handles.checkbox13,'Value');
DSchraffur=get(handles.checkbox14,'Value');
d=abs(get(handles.slider1,'Value'));
cla
FDStlObjekt(DStlObjekt,Var.fv);
FDSchnittkontur(DKontur0,d,Var.Konturen0);
FDSchnittkontur(DKontur1,d,Var.Konturen1);
FDSchnittkontur(DKontur2,d,Var.Konturen2);
FDUmrandung(DUmrandung,d,Var.UmrandungKonturen);
FDSchraffur(DSchraffur,d,Var.Schraffuren);

%Wird ausgeführt nach Benutzung von checkbox14 (Laserbahnen Schraffur)
function checkbox14_Callback(hObject, eventdata, handles)
global Var
DStlObjekt=get(handles.checkbox9,'Value');
DKontur0=get(handles.checkbox10,'Value');
DKontur1=get(handles.checkbox11,'Value');
DKontur2=get(handles.checkbox12,'Value');
DUmrandung=get(handles.checkbox13,'Value');
DSchraffur=get(handles.checkbox14,'Value');
d=abs(get(handles.slider1,'Value'));
cla
FDStlObjekt(DStlObjekt,Var.fv);
FDSchnittkontur(DKontur0,d,Var.Konturen0);
FDSchnittkontur(DKontur1,d,Var.Konturen1);
FDSchnittkontur(DKontur2,d,Var.Konturen2);
FDUmrandung(DUmrandung,d,Var.UmrandungKonturen);
FDSchraffur(DSchraffur,d,Var.Schraffuren);

%Wird ausgeführt nach Benutzung von slider1
function slider1_Callback(hObject, eventdata, handles)
global Var
d=get(handles.slider1,'Value');
d=round(d);
set(handles.slider1,'Value',d);
d=abs(d);
%Aktualisierung edit 22
Hoehe=flipud(Var.Schnitthoehen);
set(handles.edit22,'String',['Ebene: ',num2str(d),'   Schnitthöhe: ',num2str(Hoehe(d))]); 
DStlObjekt=get(handles.checkbox9,'Value');
DKontur0=get(handles.checkbox10,'Value');
DKontur1=get(handles.checkbox11,'Value');
DKontur2=get(handles.checkbox12,'Value');
DUmrandung=get(handles.checkbox13,'Value');
DSchraffur=get(handles.checkbox14,'Value');
cla
FDStlObjekt(DStlObjekt,Var.fv);
FDSchnittkontur(DKontur0,d,Var.Konturen0);
FDSchnittkontur(DKontur1,d,Var.Konturen1);
FDSchnittkontur(DKontur2,d,Var.Konturen2);
FDUmrandung(DUmrandung,d,Var.UmrandungKonturen);
FDSchraffur(DSchraffur,d,Var.Schraffuren);

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

%Wird ausgeführt nach Benutzung von pushbutton5 (3D Ansicht Werkzeug)
function pushbutton5_Callback(hObject, eventdata, handles)
rotate3d on

%Wird ausgeführt nach Benutzung von pushbutton6 (Zoom Werkzeug)
function pushbutton6_Callback(hObject, eventdata, handles)
zoom on

%Wird ausgeführt nach Benutzung von pushbutton7 (Verschiebe Werkzeug)
function pushbutton7_Callback(hObject, eventdata, handles)
pan on

%Wird ausgeführt nach Benutzung von pushbutton8 (NC-Code berechnen)
function pushbutton8_Callback(hObject, eventdata, handles)
NCCodekartesisch

%Wird ausgeführt nach Benutzung von edit22
function edit22_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit22_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Wird ausgeführt nach Benutzung von pushbutton10 (Parameter laden)
function pushbutton10_Callback(hObject, eventdata, handles)
global Var

%Dialogfenster um Ladeverzeichnis zu wählen
[FileName,PathName] = uigetfile('*.txt','Einstellungen laden');
if ischar(FileName) && ischar(PathName)
    fid = fopen([PathName,FileName], 'r'); %txt-file wird geöffnet
    %Textdatei einlesen, Zeilen mit '%' ignorieren und ':' als Separator verwenden
    text=textscan(fid,'%s%s', 'CommentStyle','%','Delimiter',':');
    fclose(fid);
    %Folgend wird den Variabeln den eingelesenen text richtig zugewiesen
    Schichtdicke=str2double(text{2}(strncmpi('Schichtdicke',text{1},12)));
    Auswahlhoehen=str2double(text{2}(strncmpi('Auswahlhoehen',text{1},13)));
    Auswahlhoeheoben=str2double(text{2}(strncmpi('Auswahlhoeheoben',text{1},16)));
    Auswahlhoeheunten=str2double(text{2}(strncmpi('Auswahlhoeheunten',text{1},17)));
    Strahlkompensation1=str2double(text{2}(strncmpi('Strahlkompensation1',text{1},19)));
    KonturAbstand1=str2double(text{2}(strncmpi('KonturAbstand1',text{1},14)));
    Umrandung=str2double(text{2}( strncmpi('Umrandung',text{1},9)&(9==cellfun(@length,text{1}))));
    UmrandungSkywritestart=str2double(text{2}(strncmpi('UmrandungSkywritestart',text{1},22)));
    UmrandungSkywriteend=str2double(text{2}(strncmpi('UmrandungSkywriteend',text{1},20)));
    UmrandungBreakangle=str2double(text{2}(strncmpi('UmrandungBreakangle',text{1},19)));
    Strahlkompensation2=str2double(text{2}(strncmpi('Strahlkompensation2',text{1},19)));
    KonturAbstand2=str2double(text{2}(strncmpi('KonturAbstand2',text{1},14)));
    Schraffur=str2double(text{2}(strncmpi('Schraffur',text{1},9)&(9==cellfun(@length,text{1}))));
    Linienabstand=str2double(text{2}(strncmpi('Linienabstand',text{1},13)));
    LinienOffsets=str2double(text{2}(strncmpi('LinienOffsets',text{1},13)));
    SchraffurSkywritestart=str2double(text{2}(strncmpi('SchraffurSkywritestart',text{1},22)));
    SchraffurSkywriteend=str2double(text{2}(strncmpi('SchraffurSkywriteend',text{1},20)));
    Schraffurwinkelstart=str2double(text{2}(strncmpi('Schraffurwinkelstart',text{1},16)));
    Schraffurwinkelinkrem=str2double(text{2}(strncmpi('Schraffurwinkelinkrem',text{1},17)));
    MinimalLaenge=str2double(text{2}(strncmpi('MinimalLaenge',text{1},13)));
    OnDelayLength=str2double(text{2}(strncmpi('OnDelayLength',text{1},13)));
    OffDelayLength=str2double(text{2}(strncmpi('OffDelayLength',text{1},14)));
    Scangeschw=str2double(text{2}(strncmpi('Scangeschw',text{1},10)));
    Jumpgeschw=str2double(text{2}(strncmpi('Jumpgeschw',text{1},10)));
    HatchtypRechteck=str2double(text{2}(strncmpi('HatchtypRechteck',text{1},16)));
    HatchtypDreieck=str2double(text{2}(strncmpi('HatchtypDreieck',text{1},15)));
    Var.NCText.Header1=text{2}{find(strncmpi('NCText.Header1',text{1},14),1)};
    Var.NCText.Header2=text{2}{find(strncmpi('NCText.Header2',text{1},14),1)};
    Var.NCText.Header3=text{2}{find(strncmpi('NCText.Header3',text{1},14),1)};
    Var.NCText.Header4=text{2}{find(strncmpi('NCText.Header4',text{1},14),1)};
    Var.NCText.Header5=text{2}{find(strncmpi('NCText.Header5',text{1},14),1)};
    Var.NCText.Header6=text{2}{find(strncmpi('NCText.Header6',text{1},14),1)};
    Var.NCText.Header7=text{2}{find(strncmpi('NCText.Header7',text{1},14),1)};
    Var.NCText.Header8=text{2}{find(strncmpi('NCText.Header8',text{1},14),1)};
    Var.NCText.Header9=text{2}{find(strncmpi('NCText.Header9',text{1},14),1)};
    Var.NCText.Header10=text{2}{find(strncmpi('NCText.Header10',text{1},15),1)};
    Var.NCText.Fokus1=text{2}{find(strncmpi('NCText.Fokus1',text{1},13),1)};
    Var.NCText.Fokus2=text{2}{find(strncmpi('NCText.Fokus2',text{1},13),1)};
    Var.NCText.Eilgang1=text{2}{find(strncmpi('NCText.Eilgang1',text{1},15),1)};
    Var.NCText.Eilgang2=text{2}{find(strncmpi('NCText.Eilgang2',text{1},15),1)};
    Var.NCText.Eilgang3=text{2}{find(strncmpi('NCText.Eilgang3',text{1},15),1)};
    Var.NCText.StartSky1=text{2}{find(strncmpi('NCText.StartSky1',text{1},16),1)};
    Var.NCText.StartSky2=text{2}{find(strncmpi('NCText.StartSky2',text{1},16),1)};
    Var.NCText.StartSky3=text{2}{find(strncmpi('NCText.StartSky3',text{1},16),1)};
    Var.NCText.Laser1=text{2}{find(strncmpi('NCText.Laser1',text{1},13),1)};
    Var.NCText.Laser2=text{2}{find(strncmpi('NCText.Laser2',text{1},13),1)};
    Var.NCText.Laser3=text{2}{find(strncmpi('NCText.Laser3',text{1},13),1)};
    Var.NCText.EndSky1=text{2}{find(strncmpi('NCText.EndSky1',text{1},14),1)};
    Var.NCText.EndSky2=text{2}{find(strncmpi('NCText.EndSky2',text{1},14),1)};
    Var.NCText.EndSky3=text{2}{find(strncmpi('NCText.EndSky3',text{1},14),1)};
    Var.NCText.Laseron=text{2}{find(strncmpi('NCText.Laseron',text{1},14),1)};
    Var.NCText.Laseroff=text{2}{find(strncmpi('NCText.Laseroff',text{1},15),1)};
    Var.NCText.Kommentar1=text{2}{find(strncmpi('NCText.Kommentar1',text{1},17),1)};
    Var.NCText.Kommentar2=text{2}{find(strncmpi('NCText.Kommentar2',text{1},17),1)};
    Var.NCText.Finish1=text{2}{find(strncmpi('NCText.Finish1',text{1},14),1)};
    Var.NCText.Finish2=text{2}{find(strncmpi('NCText.Finish2',text{1},14),1)};
    Var.NCText.Finish3=text{2}{find(strncmpi('NCText.Finish3',text{1},14),1)};
    Var.NCText.Finish4=text{2}{find(strncmpi('NCText.Finish4',text{1},14),1)};
    Var.NCText.Finish5=text{2}{find(strncmpi('NCText.Finish5',text{1},14),1)};
    Var.NCText.EbeneSta1=text{2}{find(strncmpi('NCText.EbeneSta1',text{1},16),1)};
    Var.NCText.EbeneSta2=text{2}{find(strncmpi('NCText.EbeneSta2',text{1},16),1)};
    Var.NCText.EbeneEnd1=text{2}{find(strncmpi('NCText.EbeneEnd1',text{1},16),1)};
    Var.NCText.EbeneEnd2=text{2}{find(strncmpi('NCText.EbeneEnd2',text{1},16),1)};
    
    %Funktion, die die Schnitthoehen berechnet wird aufgerufen
    [Schnitthoehen,Zoben,Zunten,Schichtdicke]=F05_Schnitthoehen(Var.v,Schichtdicke,Auswahlhoehen,Auswahlhoeheoben,Auswahlhoeheunten);
    Var.Schichtdicke=Schichtdicke;
    Var.Schnitthoehen=Schnitthoehen;
    Var.Zoben=Zoben;
    Var.Zunten=Zunten; 
    
    %Aktualisierung einiger Felder bezüglich des Slicing
    if Auswahlhoehen==1
        set(handles.checkbox1,'Value',1);
        set(handles.edit3,'Enable','on');
        set(handles.edit4,'Enable','on');
    else
        set(handles.checkbox1,'Value',0);
        set(handles.edit3,'Enable','off');
        set(handles.edit4,'Enable','off')
    end
    set(handles.edit5,'String',Schichtdicke);
    set(handles.edit6,'String',length(Schnitthoehen));
    set(handles.edit3,'String',Zoben);
    set(handles.edit4,'String',Zunten);
    
    %Die Variabeln werden in die Felder auf dem Frontpanel geschrieben
    set(handles.edit5,'String',num2str(Schichtdicke));
    set(handles.checkbox2,'Value',Strahlkompensation1);
    set(handles.edit7,'String',num2str(KonturAbstand1));
    set(handles.checkbox3,'Value',Umrandung);
    set(handles.edit23,'String',num2str(UmrandungBreakangle));
    set(handles.edit24,'String',num2str(UmrandungSkywritestart));
    set(handles.edit25,'String',num2str(UmrandungSkywriteend));
    set(handles.checkbox5,'Value',Strahlkompensation2);
    set(handles.edit12,'String',num2str(KonturAbstand2));
    set(handles.checkbox6,'Value',Schraffur);
    set(handles.edit13,'String',num2str(Linienabstand));
    set(handles.edit26,'String',num2str(SchraffurSkywritestart));
    set(handles.edit27,'String',num2str(SchraffurSkywriteend));
    set(handles.edit28,'String',num2str(Schraffurwinkelstart));
    set(handles.edit29,'String',num2str(Schraffurwinkelinkrem));
    set(handles.edit30,'String',num2str(MinimalLaenge));
    set(handles.edit31,'String',num2str(OnDelayLength));
    set(handles.edit32,'String',num2str(OffDelayLength));
    set(handles.edit33,'String',num2str(Scangeschw));
    set(handles.edit34,'String',num2str(Jumpgeschw));
    if HatchtypRechteck==1
        set(handles.checkbox15,'Value',1);
        set(handles.checkbox16,'Value',0);
    end
    if HatchtypDreieck==1
        set(handles.checkbox15,'Value',0);
        set(handles.checkbox16,'Value',1);
    end
    set(handles.checkbox17,'Value',LinienOffsets);
    
    %Einige Variabeln werden als globable Variabeln gespeichert
    Var.Schichtdicke=Schichtdicke;
    Var.KonturAbstand1=KonturAbstand1;
    Var.UmrandungBreakangle=UmrandungBreakangle;
    Var.UmrandungSkywritestart=UmrandungSkywritestart;
    Var.UmrandungSkywriteend=UmrandungSkywriteend;
    Var.KonturAbstand2=KonturAbstand2;
    Var.Linienabstand=Linienabstand;
    Var.LinienOffsets=LinienOffsets;
    Var.SchraffurSkywritestart=SchraffurSkywritestart;
    Var.SchraffurSkywriteend=SchraffurSkywriteend;
    Var.Schraffurwinkelstart=Schraffurwinkelstart;
    Var.Schraffurwinkelinkrem=Schraffurwinkelinkrem;
    Var.MinimalLaenge=MinimalLaenge;
    Var.OnDelayLength=OnDelayLength;
    Var.OffDelayLength=OffDelayLength;
    Var.Scangeschw=Scangeschw;
    Var.Jumpgeschw=Jumpgeschw;
    
    %Schalflächen zur Strahlkompensation1 werden aktiviert
    Strahlkompensation1=get(handles.checkbox2,'Value');
    if Strahlkompensation1==1
        set(handles.edit7,'Enable','on');
    else
        set(handles.edit7,'Enable','off');
    end

    %Schalflächen zur Konturumrandung werden richtig aktiviert
    set(handles.checkbox3,'Enable','on');
    Umrandung=get(handles.checkbox3,'Value');
    if Umrandung==1
        set(handles.edit24,'Enable','on');
        set(handles.edit25,'Enable','on');
        set(handles.edit23,'Enable','on');
        set(handles.checkbox5,'Enable','on');
        Strahlkompensation2=get(handles.checkbox5,'Value');
        if Strahlkompensation2==1
            set(handles.edit12,'Enable','on');
        else
            set(handles.edit12,'Enable','off');
        end
    else
        set(handles.edit24,'Enable','off');
        set(handles.edit25,'Enable','off');
        set(handles.edit23,'Enable','off');
        set(handles.checkbox5,'Enable','off');
        set(handles.edit12,'Enable','off');
    end

    %Schaltflächen zur Schraffur werden richtig aktiviert
    set(handles.checkbox6,'Enable','on');
    Schraffuren=get(handles.checkbox6,'Value');
    if Schraffuren==1
        set(handles.edit13,'Enable','on');
        set(handles.edit26,'Enable','on');
        set(handles.edit27,'Enable','on');
        set(handles.edit28,'Enable','on');
        set(handles.edit29,'Enable','on');
        set(handles.edit30,'Enable','on');
        set(handles.edit31,'Enable','on');
        set(handles.edit32,'Enable','on');
        set(handles.edit33,'Enable','on');
        set(handles.edit34,'Enable','on');
        set(handles.checkbox15,'Enable','on');
        set(handles.checkbox16,'Enable','on');
        set(handles.checkbox17,'Enable','on');
    else
        set(handles.edit13,'Enable','off');
        set(handles.edit26,'Enable','off');
        set(handles.edit27,'Enable','off');
        set(handles.edit28,'Enable','off');
        set(handles.edit29,'Enable','off');
        set(handles.edit30,'Enable','off');
        set(handles.edit31,'Enable','off');
        set(handles.edit32,'Enable','off');
        set(handles.edit33,'Enable','off');
        set(handles.edit34,'Enable','off');
        set(handles.checkbox15,'Enable','off');
        set(handles.checkbox16,'Enable','off');
        set(handles.checkbox17,'Enable','off');
    end
    
end

%Wird ausgeführt nach Benutzung von pushbutton11 (Aktuelle Parameterspeichern)
function pushbutton11_Callback(hObject, eventdata, handles)
global Var

%Dialogfenster um Speicherverzeichnis zu bestimmen
[FileName,PathName] = uiputfile('*.txt','Alle Einstellungen Speichern');
if ischar(FileName) && ischar(PathName)
    fid = fopen([PathName,FileName], 'w'); %Ein neues txt-file wird geöffnet

    %Parameter werden ins Textfile gespeichert
    fprintf(fid,['Schichtdicke:',get(handles.edit5,'String'),'\r\n']);
    fprintf(fid,['Auswahlhoehen:',num2str(get(handles.checkbox1,'Value')),'\r\n']);
    fprintf(fid,['Auswahlhoeheoben:',get(handles.edit3,'String'),'\r\n']);
    fprintf(fid,['Auswahlhoeheunten:',get(handles.edit4,'String'),'\r\n']);
    fprintf(fid,['Strahlkompensation1:',num2str(get(handles.checkbox2,'Value')),'\r\n']);
    fprintf(fid,['KonturAbstand1:',get(handles.edit7,'String'),'\r\n']);
    fprintf(fid,['Umrandung:',num2str(get(handles.checkbox3,'Value')),'\r\n']);
    fprintf(fid,['UmrandungBreakangle:',get(handles.edit23,'String'),'\r\n']);
    fprintf(fid,['UmrandungSkywritestart:',get(handles.edit24,'String'),'\r\n']);
    fprintf(fid,['UmrandungSkywriteend:',get(handles.edit25,'String'),'\r\n']);
    fprintf(fid,['Strahlkompensation2:',num2str(get(handles.checkbox5,'Value')),'\r\n']);
    fprintf(fid,['KonturAbstand2:',get(handles.edit12,'String'),'\r\n']);
    fprintf(fid,['Schraffur:',num2str(get(handles.checkbox6,'Value')),'\r\n']);
    fprintf(fid,['Linienabstand:',get(handles.edit13,'String'),'\r\n']);
    fprintf(fid,['LinienOffsets:',num2str(get(handles.checkbox17,'Value')),'\r\n']);
    fprintf(fid,['SchraffurSkywritestart:',get(handles.edit26,'String'),'\r\n']);
    fprintf(fid,['SchraffurSkywriteend:',get(handles.edit27,'String'),'\r\n']);
    fprintf(fid,['Schraffurwinkelstart:',get(handles.edit28,'String'),'\r\n']);
    fprintf(fid,['Schraffurwinkelinkrem:',get(handles.edit29,'String'),'\r\n']);
    fprintf(fid,['MinimalLaenge:',get(handles.edit30,'String'),'\r\n']);
    fprintf(fid,['OnDelayLength:',get(handles.edit31,'String'),'\r\n']);
    fprintf(fid,['OffDelayLength:',get(handles.edit32,'String'),'\r\n']);
    fprintf(fid,['Scangeschw:',get(handles.edit33,'String'),'\r\n']);
    fprintf(fid,['Jumpgeschw:',get(handles.edit34,'String'),'\r\n']);
    fprintf(fid,['HatchtypRechteck:',num2str(get(handles.checkbox15,'Value')),'\r\n']);
    fprintf(fid,['HatchtypDreieck:',num2str(get(handles.checkbox16,'Value')),'\r\n']);    
    fprintf(fid,['NCText.Header1:',Var.NCText.Header1,'\r\n']);
    fprintf(fid,['NCText.Header2:',Var.NCText.Header2,'\r\n']);
    fprintf(fid,['NCText.Header3:',Var.NCText.Header3,'\r\n']);
    fprintf(fid,['NCText.Header4:',Var.NCText.Header4,'\r\n']);
    fprintf(fid,['NCText.Header5:',Var.NCText.Header5,'\r\n']);
    fprintf(fid,['NCText.Header6:',Var.NCText.Header6,'\r\n']);
    fprintf(fid,['NCText.Header7:',Var.NCText.Header7,'\r\n']);
    fprintf(fid,['NCText.Header8:',Var.NCText.Header8,'\r\n']);
    fprintf(fid,['NCText.Header9:',Var.NCText.Header9,'\r\n']);
    fprintf(fid,['NCText.Header10:',Var.NCText.Header10,'\r\n']);
    fprintf(fid,['NCText.Fokus1:',Var.NCText.Fokus1,'\r\n']);
    fprintf(fid,['NCText.Fokus2:',Var.NCText.Fokus2,'\r\n']);
    fprintf(fid,['NCText.Eilgang1:',Var.NCText.Eilgang1,'\r\n']);
    fprintf(fid,['NCText.Eilgang2:',Var.NCText.Eilgang2,'\r\n']);
    fprintf(fid,['NCText.Eilgang3:',Var.NCText.Eilgang3,'\r\n']);
    fprintf(fid,['NCText.StartSky1:',Var.NCText.StartSky1,'\r\n']);
    fprintf(fid,['NCText.StartSky2:',Var.NCText.StartSky2,'\r\n']);
    fprintf(fid,['NCText.StartSky3:',Var.NCText.StartSky3,'\r\n']);
    fprintf(fid,['NCText.Laser1:',Var.NCText.Laser1,'\r\n']);
    fprintf(fid,['NCText.Laser2:',Var.NCText.Laser2,'\r\n']);
    fprintf(fid,['NCText.Laser3:',Var.NCText.Laser3,'\r\n']);
    fprintf(fid,['NCText.EndSky1:',Var.NCText.EndSky1,'\r\n']);
    fprintf(fid,['NCText.EndSky2:',Var.NCText.EndSky2,'\r\n']);
    fprintf(fid,['NCText.EndSky3:',Var.NCText.EndSky3,'\r\n']);
    fprintf(fid,['NCText.Laseron:',Var.NCText.Laseron,'\r\n']);
    fprintf(fid,['NCText.Laseroff:',Var.NCText.Laseroff,'\r\n']);
    fprintf(fid,['NCText.Kommentar1:',Var.NCText.Kommentar1,'\r\n']);
    fprintf(fid,['NCText.Kommentar2:',Var.NCText.Kommentar2,'\r\n']);
    fprintf(fid,['NCText.Finish1:',Var.NCText.Finish1,'\r\n']);
    fprintf(fid,['NCText.Finish2:',Var.NCText.Finish2,'\r\n']);
    fprintf(fid,['NCText.Finish3:',Var.NCText.Finish3,'\r\n']);
    fprintf(fid,['NCText.Finish4:',Var.NCText.Finish4,'\r\n']);
    fprintf(fid,['NCText.Finish5:',Var.NCText.Finish5,'\r\n']);
    fprintf(fid,['NCText.EbeneSta1:',Var.NCText.EbeneSta1,'\r\n']);
    fprintf(fid,['NCText.EbeneSta2:',Var.NCText.EbeneSta2,'\r\n']);
    fprintf(fid,['NCText.EbeneEnd1:',Var.NCText.EbeneEnd1,'\r\n']);
    fprintf(fid,['NCText.EbeneEnd2:',Var.NCText.EbeneEnd2,'\r\n']);

    fclose(fid); %txt-file wird geschlossen
end

%Wird ausgeführt nach benutzung von edit35
function edit35_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit35_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Wird ausgeführt nach Benutzung von checkbox15 (Hattchtyp Rechteck)
function checkbox15_Callback(hObject, eventdata, handles)
set(handles.checkbox15,'Value',1);
set(handles.checkbox16,'Value',0);

%Wird ausgeführt nach Benutzung von checkbox16 (Hattchtyp Dreieck)
function checkbox16_Callback(hObject, eventdata, handles)
set(handles.checkbox15,'Value',0);
set(handles.checkbox16,'Value',1);

%Wird ausgeführt nach Benutzung von checkbox17 (Erster Linienabstand variieren)
function checkbox17_Callback(hObject, eventdata, handles)
