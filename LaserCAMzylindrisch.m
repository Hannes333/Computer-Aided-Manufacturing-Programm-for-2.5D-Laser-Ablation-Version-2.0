function varargout = LaserCAMzylindrisch(varargin)
% Dies ist das Skript zum Fenster LaserCAMzylindrisch.fig
% In diesem Code werden alle Eingaben die auf dem LaserCAMzylindrisch.fig getätigt
% werden ausgewertet.
% Aus diesem Skript kann ein weiteres Skript aufgerufen namens NCCodezylindrisch.m
% Das entsprechende Fenster zu NCCodezylindrisch.m lautet NCCodezylindrisch.fig

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @LaserCAMzylindrisch_OpeningFcn, ...
                   'gui_OutputFcn',  @LaserCAMzylindrisch_OutputFcn, ...
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


% --- Executes just before LaserCAMzylindrisch is made visible.
function LaserCAMzylindrisch_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to LaserCAMzylindrisch (see VARARGIN)

clc %Bereinigt das Command Window
set(handles.edit22,'String','LaserCAMzylindrisch Version 2.0'); 

% Globales Struct zur Übergabe der Variabeln wird erstellt
global Var

%Ausgangsvariabeln werden definiert
Schichtdicke=0.001; %Höhenabstand der Schichten in [mm]
Linienabstand=0.005; %Abstand zwischen den Laserbahnen[mm]
SchraffurSkywritestart=0.1; %Skywrite zur Beschleunigung der Spiegel und Galvamotoren [mm]
SchraffurSkywriteend=0.1; %Skywrite zur Abbremsung der Spiegel und Galvamotoren [mm]
Schraffurwinkelstart=20; %Richtungswinkel der ersten Schraffur [Grad]
Schraffurwinkelinkrem=0; %Richtungswinkel der darauf folgenden Schraffuren [Grad]
Scangeschw=500; %Einstellen der Scangeschwindigkeit [mm/s]
VorschubAmax=2700; %Maximale Drehzahl der Drehachse A [°/s]
Drehoffsetlength=0.2; %Minimale Länge zwischen den Schraffuren in Drehrichtung [mm]
MinJumplengthY=0.001; %Minimale Länge der Jumplinie in Y-Richtung [mm]
Modus=1; %Startwinkel (1=kleinsmöglicher Winkel) (2=freiwählbarer Winkel) (3=grösstmöglicher Winkel)
Verhaeltnis=0.6; %Verhältnis zwischen Markierlinie zu Jumplinie bei Startwinkelberechnung nach Modus 1
WinkelAnpassung=0; %Winkel anpassen damit maximale Drehzahl und Scangeschwindigkeit nicht überschritten und kleinstmöchlier Winkel nicht unterschritten wird (1=ja) (0=nein)
MinimalLaenge=0; %Minimale Hatchsegmentlänge [mm]
OnDelayLength=0;    %Verschiebung der Startpunkte [mm] (l_on = v_s*t_on)
OffDelayLength=0;   %Verschiebung der Startpunkte [mm] (l_off = v_s*t_off)
AxialRichtung=1;    %(Von links nach rechts=1 ,von rechts nach links=2, alternieren=3)

%Ausgangsvariabeln werden auf den Feldern eingefügt
set(handles.edit5,'String',num2str(Schichtdicke));
set(handles.edit13,'String',num2str(Linienabstand));
set(handles.edit15,'String',num2str(SchraffurSkywritestart));
set(handles.edit16,'String',num2str(SchraffurSkywriteend));
set(handles.edit17,'String',num2str(Schraffurwinkelstart));
set(handles.edit18,'String',num2str(Schraffurwinkelinkrem));
set(handles.edit23,'String',num2str(Scangeschw));
set(handles.edit24,'String',num2str(VorschubAmax));
set(handles.edit25,'String',num2str(Drehoffsetlength));
set(handles.edit26,'String',num2str(MinJumplengthY));
set(handles.edit29,'String',num2str(Verhaeltnis));
set(handles.edit30,'String',num2str(MinimalLaenge));
set(handles.edit31,'String',num2str(OnDelayLength));
set(handles.edit32,'String',num2str(OffDelayLength));
set(handles.checkbox21,'Value',WinkelAnpassung);
if Modus==1 %kleinstmöglicher Winkel
    set(handles.checkbox22,'Value',1);
    set(handles.checkbox16,'Value',0);
    set(handles.checkbox17,'Value',0);
elseif Modus==2 %freiwählbarer Winkel
    set(handles.checkbox22,'Value',0);
    set(handles.checkbox16,'Value',1);
    set(handles.checkbox17,'Value',0);
elseif Modus==3 %Grösstmöglicher Winkel
    set(handles.checkbox22,'Value',0);
    set(handles.checkbox16,'Value',0);
    set(handles.checkbox17,'Value',1);
end
if AxialRichtung==1 %Von links nach rechts=1
    set(handles.checkbox24,'Value',1);
    set(handles.checkbox26,'Value',0);
    set(handles.checkbox27,'Value',0);
elseif AxialRichtung==2 %von rechts nach links=2
    set(handles.checkbox24,'Value',0);
    set(handles.checkbox26,'Value',1);
    set(handles.checkbox27,'Value',0);
elseif AxialRichtung==3 %alternieren=3
    set(handles.checkbox24,'Value',0);
    set(handles.checkbox26,'Value',0);
    set(handles.checkbox27,'Value',1);
end

%Einige Ausgangsvariabeln werden als globale Variabeln gespeichert
Var.Schichtdicke=Schichtdicke;
Var.Linienabstand=Linienabstand;
Var.SchraffurSkywritestart=SchraffurSkywritestart;
Var.SchraffurSkywriteend=SchraffurSkywriteend;
Var.Schraffurwinkelstart=Schraffurwinkelstart;
Var.Schraffurwinkelinkrem=Schraffurwinkelinkrem;
Var.Modus=Modus;
Var.Scangeschw=Scangeschw;
Var.VorschubAmax=VorschubAmax;
Var.Drehoffsetlength=Drehoffsetlength;
Var.MinJumplengthY=MinJumplengthY;
Var.Verhaeltnis=Verhaeltnis;
Var.MinimalLaenge=MinimalLaenge;
Var.OnDelayLength=OnDelayLength;
Var.OffDelayLength=OffDelayLength;

%Ausgangswerte zum NC-Code werden definiert
NCText.Header1='G90';
NCText.Header2='G359';
NCText.Header3='VELOCITY ON';
NCText.Header4='HOME A';
NCText.Header5='';
NCText.Header6='';
NCText.Header7='';
NCText.Header8='';
NCText.Header9='';
NCText.Header10='';
NCText.Fokus1='G01 X';
NCText.Fokus2=' A';
NCText.Fokus3=' Z';
NCText.Fokus4='';
NCText.Vorschub1='F';
NCText.Vorschub2=' //Dominante Geschw [°/s]';
NCText.Eilgang1='G00 X';
NCText.Eilgang2=' A';
NCText.Eilgang3='';
NCText.Laseraus1='G01 X';
NCText.Laseraus2=' A';
NCText.Laseraus3='';
NCText.StartSky1='G01 X';
NCText.StartSky2=' A';
NCText.StartSky3='';
NCText.Laser1='G01 X';
NCText.Laser2=' A';
NCText.Laser3='';
NCText.EndSky1='G01 X';
NCText.EndSky2=' A';
NCText.EndSky3='';
NCText.Laseron='GALVO LASEROVERRIDE A ON';
NCText.Laseroff='GALVO LASEROVERRIDE A OFF';
NCText.Kommentar1='//';
NCText.Kommentar2='';
NCText.Finish1='END PROGRAM';
NCText.Finish2='';
NCText.Finish3='';
NCText.Finish4='';
NCText.Finish5='';

%NCText als globale Variable speichern
Var.NCText=NCText;

%Pfad, wo der NC-Code gespeichert werden soll
Var.FolderName='';

%Alle Felder bis auf den STL-Datei importieren Button müssen inaktiv sein
set(handles.checkbox1,'Enable','off');
set(handles.edit3,'Enable','off');
set(handles.edit4,'Enable','off');
set(handles.edit5,'Enable','off');
set(handles.edit13,'Enable','off');
%%%%set(handles.checkbox7,'Enable','off');
set(handles.edit15,'Enable','off');
set(handles.edit16,'Enable','off');
set(handles.edit17,'Enable','off');
set(handles.edit18,'Enable','off');
set(handles.pushbutton2,'Enable','off');
set(handles.checkbox9,'Enable','off');
set(handles.checkbox10,'Enable','off');
set(handles.checkbox11,'Enable','off');
set(handles.checkbox12,'Enable','off');
set(handles.slider1,'Enable','off');
set(handles.pushbutton5,'Enable','off');
set(handles.pushbutton6,'Enable','off');
set(handles.pushbutton7,'Enable','off');
set(handles.pushbutton8,'Enable','off');
set(handles.edit22,'Enable','off');
set(handles.pushbutton10,'Enable','off');
set(handles.pushbutton11,'Enable','off');
set(handles.edit23,'Enable','off');
set(handles.edit24,'Enable','off');
set(handles.edit25,'Enable','off');
set(handles.edit25,'Enable','off');
set(handles.edit26,'Enable','off');
set(handles.edit29,'Enable','off');
set(handles.checkbox22,'Enable','off');
set(handles.checkbox16,'Enable','off');
set(handles.checkbox17,'Enable','off');
set(handles.checkbox21,'Enable','off');
set(handles.edit30,'Enable','off');
set(handles.edit31,'Enable','off');
set(handles.edit32,'Enable','off');
set(handles.checkbox24,'Enable','off');
set(handles.checkbox26,'Enable','off');
set(handles.checkbox27,'Enable','off');
set(handles.edit33,'Enable','off');

% Choose default command line output for LaserCAMzylindrisch
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes LaserCAMzylindrisch wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = LaserCAMzylindrisch_OutputFcn(hObject, eventdata, handles) 
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
    disp('Stl-Objekt eingelesen');

    cla %Grafik zurücksetzen
    
    %Darstellung des original Stl-Objekts
    RadiusMax=max((v(:,2).^2+v(:,3).^2).^0.5);
    v1=v; 
    v1(:,2)=v1(:,2)*-(360/(2*pi*RadiusMax)); %Anpassung der orignal Stldatei an die Skalierung in Grad der Y-Richtung
    fv1.vertices=v1; %v enthält die Koordinaten der Eckpunkte
    fv1.faces=f; %f sagt, welche drei Eckpunkte aus v ein Dreieck bilden
    FD2StlObjekt(1,fv1,[0.2 0.2 0.8],RadiusMax);
    view([45 45]); %Set a nice view angle
    camlight(0,0); %Lichtquelle hinzufügen
    
    %Funktion, die die Stl-Datei von Kartesisch- in Zylinderkoordinaten umwandelt
    [f2,v2] = F03_Transformation(f,v);
    disp('Transformation durchgeführt');

    %Darstellung des Stl-Objekts nach der Koordinatentrasformation
    fv2.vertices=v2; %v enthält die Koordinaten der Eckpunkte
    fv2.faces=f2; %f sagt, welche drei Eckpunkte aus v ein Dreieck bilden
    FD2StlObjekt(1,fv2,[0.2 0.8 0.8],RadiusMax);
    
    %Übergabe der Variablen
    Var.v2=v2;
    Var.fv1=fv1;
    Var.fv2=fv2;
    Var.RadiusMax=RadiusMax;
    
    %Ausgabe Höchster Punkt Stl-Datei und Tiefster Punkt Stl-Datei
    Stloben=max(v2(:,3)); %Z-Koordinate des höchstgelegensten Stl-Objekt Punktes [mm]
    Stlunten=min(v2(:,3)); %Z-Koordinate des tiefstgelegensten Stl-Objekt Punktes [mm]
    set(handles.edit1,'String',Stloben);
    set(handles.edit2,'String',Stlunten);
    Var.Stloben=Stloben;

    %Funktion, die die Schnitthoehen berechnet wird aufgerufen
    Schichtdicke=str2double(get(handles.edit5,'String'));
    Auswahlhoehen=0;
    Auswahlhoeheoben=Stloben;
    Auswahlhoeheunten=Stlunten;
    [Schnitthoehen,Zoben,Zunten,Schichtdicke]=F05_Schnitthoehen(v2,Schichtdicke,Auswahlhoehen,Auswahlhoeheoben,Auswahlhoeheunten);
    Var.Schichtdicke=Schichtdicke;
    Var.Schnitthoehen=Schnitthoehen;
    Var.Zoben=Zoben;
    Var.Zunten=Zunten;

    %Aktualisierung einiger Felder auf dem GUI
    set(handles.edit5,'String',Schichtdicke);
    set(handles.edit6,'String',length(Schnitthoehen));
    set(handles.edit3,'String',Zoben);
    set(handles.edit4,'String',Zunten);

    %DarstellungsHäcken werden aktualisiert
    set(handles.checkbox9,'Value',1);
    set(handles.checkbox10,'Value',1);
    set(handles.checkbox11,'Value',0);
    set(handles.checkbox12,'Value',0);
    set(handles.checkbox9,'Enable','on');
    set(handles.checkbox10,'Enable','on');
    set(handles.checkbox11,'Enable','off');
    set(handles.checkbox12,'Enable','off');
    
    %Entsprechende Felder auf dem GUI müssen auswählbar sein
    set(handles.checkbox1,'Enable','on');
    set(handles.checkbox1,'Value',0);
    set(handles.edit3,'Enable','off');
    set(handles.edit4,'Enable','off');
    set(handles.edit5,'Enable','on');
    set(handles.pushbutton2,'Enable','on');
    set(handles.pushbutton10,'Enable','on');
    set(handles.pushbutton11,'Enable','on');
    
    set(handles.edit13,'Enable','on');
    set(handles.edit23,'Enable','on');
    set(handles.edit24,'Enable','on');
    set(handles.edit25,'Enable','on');
    set(handles.edit15,'Enable','on');
    set(handles.edit16,'Enable','on');
    set(handles.checkbox22,'Enable','on');
    set(handles.checkbox16,'Enable','on');
    set(handles.checkbox17,'Enable','on');
       
    %Schalflächen für den Schraffurwinkel werden richtig aktiviert
    Modus=Var.Modus;
    if Modus==1 %kleinstmöglicher Winkel
        set(handles.edit29,'Enable','on');
        set(handles.edit17,'Enable','off');
        set(handles.edit18,'Enable','off');
        set(handles.edit26,'Enable','off');
        set(handles.checkbox21,'Enable','off');
    elseif Modus==2 %freiwählbarer Winkel
        set(handles.edit29,'Enable','off');
        set(handles.edit17,'Enable','on');
        set(handles.edit18,'Enable','on');
        set(handles.edit26,'Enable','on');
        set(handles.checkbox21,'Enable','on');
    elseif Modus==3 %Grösstmöglicher Winkel
        set(handles.edit29,'Enable','off');
        set(handles.edit17,'Enable','off');
        set(handles.edit18,'Enable','off');
        set(handles.edit26,'Enable','off');
        set(handles.checkbox21,'Enable','off');
    end
    
    %Schaltflächen für Minimallänge, Delays und Axialrichtung aktivieren
    set(handles.edit30,'Enable','on');
    set(handles.edit31,'Enable','on');
    set(handles.edit32,'Enable','on');
    set(handles.checkbox24,'Enable','on');
    set(handles.checkbox26,'Enable','on');
    set(handles.checkbox27,'Enable','on');
    
    %Schalflächen mit Ansichtwerzeugen werden aktiviert
    set(handles.pushbutton5,'Enable','on');
    set(handles.pushbutton6,'Enable','on');
    set(handles.pushbutton7,'Enable','on');
end

%Wird ausgeführt nach Benutzung von edit1
function edit1_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Wird ausgeführt nach Benutzung von edit2
function edit2_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Wird ausgeführt nach Benutzung von checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
global Var

%Aktualisierung einiger Felder bezüglich des Slicing
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
[Schnitthoehen,Zoben,Zunten,Schichtdicke]=F05_Schnitthoehen(Var.v2,Schichtdicke,Auswahlhoehen,Auswahlhoeheoben,Auswahlhoeheunten);
Var.Schichtdicke=Schichtdicke;
Var.Schnitthoehen=Schnitthoehen;
Var.Zoben=Zoben;
Var.Zunten=Zunten;

%Aktualisierung einiger Felder auf dem GUI
set(handles.edit5,'String',Schichtdicke);
set(handles.edit6,'String',length(Schnitthoehen));
set(handles.edit3,'String',Zoben);
set(handles.edit4,'String',Zunten);

%Wird ausgeführt nach Benutzung von edit3
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
    [Schnitthoehen,Zoben,Zunten,Schichtdicke]=F05_Schnitthoehen(Var.v2,Schichtdicke,Auswahlhoehen,Auswahlhoeheoben,Auswahlhoeheunten);
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

%Wird ausgeführt nach Benutzung von edit4
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
    [Schnitthoehen,Zoben,Zunten,Schichtdicke]=F05_Schnitthoehen(Var.v2,Schichtdicke,Auswahlhoehen,Auswahlhoeheoben,Auswahlhoeheunten);
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

%Wird ausgeführt nach Benutzung von edit5
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
    [Schnitthoehen,Zoben,Zunten,Schichtdicke]=F05_Schnitthoehen(Var.v2,Schichtdicke,Auswahlhoehen,Auswahlhoeheoben,Auswahlhoeheunten);
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

%Wird ausgeführt nach Benutzung von edit 6
function edit6_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Wird ausgeführt nach Benutzung von edit13
function edit13_Callback(hObject, eventdata, handles)
global Var
%Eingabe in edit13 wird ausgewertet
Linienabstand=str2double(get(handles.edit13,'String'));
if Linienabstand<0
    set(handles.edit13,'String',num2str(abs(Linienabstand)));
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

%Wird ausgeführt nach Benutzung von edit15 (Skywrite Startlänge [mm])
function edit15_Callback(hObject, eventdata, handles)
global Var
%Eingabe in edit15 wird ausgewertet
SchraffurSkywritestart=str2double(get(handles.edit15,'String'));
if SchraffurSkywritestart<0
    set(handles.edit15,'String',num2str(abs(SchraffurSkywritestart)));
elseif isnan(SchraffurSkywritestart)
    warndlg('Ungültige Eingabe')
    set(handles.edit15,'String',num2str(Var.SchraffurSkywritestart));
else
    Var.SchraffurSkywritestart=SchraffurSkywritestart;
end

% --- Executes during object creation, after setting all properties.
function edit15_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Wird ausgeführt nach Benutzung von edit16 (Skywrite Endlänge [mm])
function edit16_Callback(hObject, eventdata, handles)
global Var
%Eingabe in edit16 wird ausgewertet
SchraffurSkywriteend=str2double(get(handles.edit16,'String'));
if SchraffurSkywriteend<0
    set(handles.edit16,'String',num2str(abs(SchraffurSkywriteend)));
elseif isnan(SchraffurSkywriteend)
    warndlg('Ungültige Eingabe')
    set(handles.edit16,'String',num2str(Var.SchraffurSkywriteend));
else
    Var.SchraffurSkywriteend=SchraffurSkywriteend;
end

% --- Executes during object creation, after setting all properties.
function edit16_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Wird ausgeführt nach Benutzung von edit17 (Freiwählbarer Winkel [°])
function edit17_Callback(hObject, eventdata, handles)
global Var
Schraffurwinkelstart=str2double(get(handles.edit17,'String'));
if isnan(Schraffurwinkelstart)
    warndlg('Ungültige Eingabe')
    set(handles.edit17,'String',num2str(Var.Schraffurwinkelstart));
elseif Schraffurwinkelstart<-89.999
    set(handles.edit17,'String',num2str(-89.999));
    Var.Schraffurwinkelstart=-89.999;
elseif Schraffurwinkelstart>89.999
    set(handles.edit17,'String',num2str(89.999));
    Var.Schraffurwinkelstart=89.999;
else
    Var.Schraffurwinkelstart=Schraffurwinkelstart;
end

% --- Executes during object creation, after setting all properties.
function edit17_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Wird ausgeführt nach Benutzung von edit18 (Winkelinrement pro Ebene [°])
function edit18_Callback(hObject, eventdata, handles)
global Var
Schraffurwinkelinkrem=str2double(get(handles.edit18,'String'));
if isnan(Schraffurwinkelinkrem)
    warndlg('Ungültige Eingabe')
    set(handles.edit18,'String',num2str(Var.Schraffurwinkelinkrem));
elseif Schraffurwinkelinkrem<0
    set(handles.edit18,'String',num2str(abs(Schraffurwinkelinkrem)));
    Var.Schraffurwinkelinkrem=abs(Schraffurwinkelinkrem);
else
    Var.Schraffurwinkelinkrem=Schraffurwinkelinkrem;
end

% --- Executes during object creation, after setting all properties.
function edit18_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Wird ausgeführt nach Benutzung von pushbutton2. (Laserbahnen berechnen)
function pushbutton2_Callback(hObject, eventdata, handles)
global Var
%Zusammensuchen der benötigten Werte
Schichtdicke=str2double(get(handles.edit5,'String'));
Schnitthoehen=Var.Schnitthoehen;
v2=Var.v2;
fv2=Var.fv2;
Zoben=Var.Zoben;
Titel=Var.Titel;
RadiusMax=Var.RadiusMax;
Linienabstand=str2double(get(handles.edit13,'String'));
Scangeschw=str2double(get(handles.edit23,'String'));
VorschubAmax=str2double(get(handles.edit24,'String'));
Drehoffsetlength=str2double(get(handles.edit25,'String'));
SchraffurSkywritestart=str2double(get(handles.edit15,'String'));
SchraffurSkywriteend=str2double(get(handles.edit16,'String'));
if get(handles.checkbox22,'Value')==1
    Modus=1;
elseif get(handles.checkbox16,'Value')==1
    Modus=2;
elseif get(handles.checkbox17,'Value')==1
    Modus=3;
end
Verhaeltnis=str2double(get(handles.edit29,'String'));
Schraffurwinkelstart=str2double(get(handles.edit17,'String'));
Schraffurwinkelinkrem=str2double(get(handles.edit18,'String'));
MinJumplengthY=str2double(get(handles.edit26,'String'));
WinkelAnpassung=get(handles.checkbox21,'Value');

MinimalLaenge=str2double(get(handles.edit30,'String'));
OnDelayLength=str2double(get(handles.edit31,'String'));
OffDelayLength=str2double(get(handles.edit32,'String'));
if get(handles.checkbox24,'Value')==1
    Axialrichtung=1;
elseif get(handles.checkbox26,'Value')==1
    Axialrichtung=2;
elseif get(handles.checkbox27,'Value')==1
    Axialrichtung=3;
end

%Ebene die Dargestellt werden soll
d=1; 

%Darstellung des Stl-objekts
cla %Grafik zurücksetzen
FD2StlObjekt(1,Var.fv2,[0.2 0.8 0.8],RadiusMax);
camlight(0,0); %Lichtquelle hinzufügen
%Entsprechende Schaltflächen zur Darstellung werden sichtbar gemacht
set(handles.checkbox9,'Value',0); %Checkbox Darstellung Schnittkontur
set(handles.checkbox10,'Value',1); %Checkbox Darstellung Schnittkontur

%Funktion, die die Slices macht wird aufgerufen
disp('Slices werden berechnet...');
[Konturen]=F11_Slicing( fv2.faces,fv2.vertices,Schnitthoehen,Schichtdicke );
disp('Slices berechnet');

%Die Schichten werden absteigend sortiert
Konturen=flipud(Konturen); %Oberste Schnittebene ist nun im obersten CellArray Eintrag
Var.Konturen=Konturen;

%Darstellung der Schnittkonturen 
FD2Schnittkontur(1,d,Konturen,RadiusMax);

%Entsprechende Schaltflächen zur Darstellung werden sichtbar gemacht
set(handles.checkbox11,'Enable','on'); %Checkbox Darstellung Schnittkontur
set(handles.checkbox11,'Value',1); %Checkbox Darstellung Schnittkontur

%Funktion, die die Schraffuren berechnet
disp('Schraffuren werden berechnet...');
[Schraffuren,VorschubDominant,Winkel]=F41_Schraffuren(...
    Konturen,Linienabstand,SchraffurSkywritestart,SchraffurSkywriteend,...
    Schraffurwinkelstart,Schraffurwinkelinkrem,Verhaeltnis,Scangeschw,...
    VorschubAmax,Drehoffsetlength,Modus,MinJumplengthY,WinkelAnpassung,...
    MinimalLaenge,OnDelayLength,OffDelayLength,Axialrichtung); 
disp('Schraffuren berechnet');

%Abschätzung der Bearbeitungszeit
WinkelStart=0;
Bearbeitungszeit=0;
for k=1:size(Schraffuren,1) %Index, der durch die Ebenen von Konturen geht
    if ~isempty(Schraffuren{k,1})
        WinkelEnd=Schraffuren{k,1}(end,2);
        Bearbeitungszeit=Bearbeitungszeit+abs((WinkelEnd-WinkelStart)/VorschubDominant(k));
        WinkelStart=WinkelEnd;
    end
end
%Bearbeitungszeit auf Benutzeroberfläche anzeigen
set(handles.edit33,'String',['Geschätze Bearbeitungszeit: ',num2str(round(Bearbeitungszeit/60)),'min ',num2str(mod(Bearbeitungszeit,60),'%4.1f'),'s']); 

%Speicherung einiger Variablen
Var.Schraffuren=Schraffuren;
Var.VorschubDominant=VorschubDominant;
Var.Winkel=Winkel;

%Darstellung der Schraffuren
FD2Schraffur(1,d,Schraffuren,RadiusMax);

%Entsprechende Schaltflächen zur Darstellung werden sichtbar gemacht
set(handles.checkbox12,'Enable','on'); %Checkbox Darstellung Schnittkontur
set(handles.checkbox12,'Value',1); %Checkbox Darstellung Schnittkontur

%Aktualisierung edit 22
Hoehe=flipud(Var.Schnitthoehen);
set(handles.edit22,'String',['Ebene: ',num2str(d),'   Radius: ',num2str(Hoehe(d)),'mm   Schraffurwinkel: ',num2str(Var.Winkel(d)),'°']); 

%Aktivierung Slider
set(handles.slider1,'Min',-length(Schnitthoehen)-0.1);
set(handles.slider1,'Value',-1);
set(handles.slider1,'Enable','on');

%Pushbutton 8 (NC-Code erstellen) wird aktiviert 
set(handles.pushbutton8,'Enable','on');


%Wird ausgeführt nach Benutzung von checkbox9 (Original Stl-Objekt)
function checkbox9_Callback(hObject, eventdata, handles)
global Var
DStlObjekt1=get(handles.checkbox9,'Value');
DStlObjekt2=get(handles.checkbox10,'Value');
DKontur=get(handles.checkbox11,'Value');
DSchraffur=get(handles.checkbox12,'Value');
d=abs(get(handles.slider1,'Value'));
cla %Grafik zurücksetzen
FD2StlObjekt(DStlObjekt1,Var.fv1,[0.2 0.2 0.8],Var.RadiusMax);
FD2StlObjekt(DStlObjekt2,Var.fv2,[0.2 0.8 0.8],Var.RadiusMax);
camlight(0,0); %Lichtquelle hinzufügen
if DKontur==1
    FD2Schnittkontur(DKontur,d,Var.Konturen,Var.RadiusMax);
end
if DSchraffur==1
    FD2Schraffur(DSchraffur,d,Var.Schraffuren,Var,RadiusMax);
end

%Wird ausgeführt nach Benutzung von checkbox10 (Transformiertes Stl-Objekt)
function checkbox10_Callback(hObject, eventdata, handles)
global Var
DStlObjekt1=get(handles.checkbox9,'Value');
DStlObjekt2=get(handles.checkbox10,'Value');
DKontur=get(handles.checkbox11,'Value');
DSchraffur=get(handles.checkbox12,'Value');
d=abs(get(handles.slider1,'Value'));
cla %Grafik zurücksetzen
FD2StlObjekt(DStlObjekt1,Var.fv1,[0.2 0.2 0.8],Var.RadiusMax);
FD2StlObjekt(DStlObjekt2,Var.fv2,[0.2 0.8 0.8],Var.RadiusMax);
camlight(0,0); %Lichtquelle hinzufügen
if DKontur==1
    FD2Schnittkontur(DKontur,d,Var.Konturen,Var.RadiusMax);
end
if DSchraffur==1
    FD2Schraffur(DSchraffur,d,Var.Schraffuren,Var.RadiusMax);
end

%Wird ausgeführt nach Benutzung von checkbox11 (Schnittkontur)
function checkbox11_Callback(hObject, eventdata, handles)
global Var
DStlObjekt1=get(handles.checkbox9,'Value');
DStlObjekt2=get(handles.checkbox10,'Value');
DKontur=get(handles.checkbox11,'Value');
DSchraffur=get(handles.checkbox12,'Value');
d=abs(get(handles.slider1,'Value'));
cla %Grafik zurücksetzen
FD2StlObjekt(DStlObjekt1,Var.fv1,[0.2 0.2 0.8],Var.RadiusMax);
FD2StlObjekt(DStlObjekt2,Var.fv2,[0.2 0.8 0.8],Var.RadiusMax);
camlight(0,0); %Lichtquelle hinzufügen
if DKontur==1
    FD2Schnittkontur(DKontur,d,Var.Konturen,Var.RadiusMax);
end
if DSchraffur==1
    FD2Schraffur(DSchraffur,d,Var.Schraffuren,Var.RadiusMax);
end

%Wird ausgeführt nach Benutzung von checkbox12 (Laserbahnen Schraffur)
function checkbox12_Callback(hObject, eventdata, handles)
global Var
DStlObjekt1=get(handles.checkbox9,'Value');
DStlObjekt2=get(handles.checkbox10,'Value');
DKontur=get(handles.checkbox11,'Value');
DSchraffur=get(handles.checkbox12,'Value');
d=abs(get(handles.slider1,'Value'));
cla %Grafik zurücksetzen
FD2StlObjekt(DStlObjekt1,Var.fv1,[0.2 0.2 0.8],Var.RadiusMax);
FD2StlObjekt(DStlObjekt2,Var.fv2,[0.2 0.8 0.8],Var.RadiusMax);
camlight(0,0); %Lichtquelle hinzufügen
if DKontur==1
    FD2Schnittkontur(DKontur,d,Var.Konturen,Var.RadiusMax);
end
if DSchraffur==1
    FD2Schraffur(DSchraffur,d,Var.Schraffuren,Var.RadiusMax);
end

%Wird ausgeführt nach Benutzung von slider1
function slider1_Callback(hObject, eventdata, handles)
global Var
d=get(handles.slider1,'Value');
d=round(d);
set(handles.slider1,'Value',d);
d=abs(d);
%Aktualisierung edit 22
Hoehe=flipud(Var.Schnitthoehen);
set(handles.edit22,'String',['Ebene: ',num2str(d),'   Radius: ',num2str(Hoehe(d)),'mm   Schraffurwinkel: ',num2str(Var.Winkel(d)),'°']); 
DStlObjekt1=get(handles.checkbox9,'Value');
DStlObjekt2=get(handles.checkbox10,'Value');
DKontur=get(handles.checkbox11,'Value');
DSchraffur=get(handles.checkbox12,'Value');
d=abs(get(handles.slider1,'Value'));
cla
FD2StlObjekt(DStlObjekt1,Var.fv1,[0.2 0.2 0.8],Var.RadiusMax);
FD2StlObjekt(DStlObjekt2,Var.fv2,[0.2 0.8 0.8],Var.RadiusMax);
camlight(0,0); %Lichtquelle hinzufügen
if DKontur==1
    FD2Schnittkontur(DKontur,d,Var.Konturen,Var.RadiusMax);
end
if DSchraffur==1
    FD2Schraffur(DSchraffur,d,Var.Schraffuren,Var.RadiusMax);
end

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
NCCodezylindrisch

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
    Linienabstand=str2double(text{2}(strncmpi('Linienabstand',text{1},13)));
    Scangeschw=str2double(text{2}(strncmpi('Scangeschw',text{1},10)));
    VorschubAmax=str2double(text{2}(strncmpi('VorschubAmax',text{1},12)));
    Drehoffsetlength=str2double(text{2}(strncmpi('Drehoffsetlength',text{1},16)));
    SchraffurSkywritestart=str2double(text{2}(strncmpi('SchraffurSkywritestart',text{1},22)));
    SchraffurSkywriteend=str2double(text{2}(strncmpi('SchraffurSkywriteend',text{1},20)));
    Schraffurwinkelstart=str2double(text{2}(strncmpi('Schraffurwinkelstart',text{1},16)));
    Schraffurwinkelinkrem=str2double(text{2}(strncmpi('Schraffurwinkelinkrem',text{1},17)));
    Verhaeltnis=str2double(text{2}(strncmpi('Verhaeltnis',text{1},11)));    
    MinJumplengthY=str2double(text{2}(strncmpi('MinJumplengthY',text{1},14)));
    WinkelAnpassung=str2double(text{2}(strncmpi('WinkelAnpassung',text{1},15))); 
    KleinWinkel=str2double(text{2}(strncmpi('KleinWinkel',text{1},11))); 
    FreiWinkel=str2double(text{2}(strncmpi('FreiWinkel',text{1},10)));     
    GrossWinkel=str2double(text{2}(strncmpi('GrossWinkel',text{1},11)));
    MinimalLaenge=str2double(text{2}(strncmpi('MinimalLaenge',text{1},13)));
    OnDelayLength=str2double(text{2}(strncmpi('OnDelayLength',text{1},13)));
    OffDelayLength=str2double(text{2}(strncmpi('OffDelayLength',text{1},14)));
    linksrechts=str2double(text{2}(strncmpi('linksrechts',text{1},11)));
    rechtslinks=str2double(text{2}(strncmpi('rechtslinks',text{1},11)));
    alternierend=str2double(text{2}(strncmpi('alternierend',text{1},12)));
    
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
    Var.NCText.Fokus3=text{2}{find(strncmpi('NCText.Fokus3',text{1},13),1)};
    Var.NCText.Fokus4=text{2}{find(strncmpi('NCText.Fokus4',text{1},13),1)};
    Var.NCText.Vorschub1=text{2}{find(strncmpi('NCText.Vorschub1',text{1},16),1)};
    Var.NCText.Vorschub2=text{2}{find(strncmpi('NCText.Vorschub2',text{1},16),1)};
    Var.NCText.Eilgang1=text{2}{find(strncmpi('NCText.Eilgang1',text{1},15),1)};
    Var.NCText.Eilgang2=text{2}{find(strncmpi('NCText.Eilgang2',text{1},15),1)};
    Var.NCText.Eilgang3=text{2}{find(strncmpi('NCText.Eilgang3',text{1},15),1)};
    Var.NCText.Laseraus1=text{2}{find(strncmpi('NCText.Laseraus1',text{1},16),1)};    
    Var.NCText.Laseraus2=text{2}{find(strncmpi('NCText.Laseraus2',text{1},16),1)};
    Var.NCText.Laseraus3=text{2}{find(strncmpi('NCText.Laseraus3',text{1},16),1)};    
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
    
    %Funktion, die die Schnitthoehen berechnet wird aufgerufen
    [Schnitthoehen,Zoben,Zunten,Schichtdicke]=F05_Schnitthoehen(Var.v2,Schichtdicke,Auswahlhoehen,Auswahlhoeheoben,Auswahlhoeheunten);
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
    set(handles.edit13,'String',num2str(Linienabstand));
    set(handles.edit23,'String',num2str(Scangeschw));
    set(handles.edit24,'String',num2str(VorschubAmax));
    set(handles.edit25,'String',num2str(Drehoffsetlength));
    set(handles.edit29,'String',num2str(Verhaeltnis));    
    set(handles.edit26,'String',num2str(MinJumplengthY));
    set(handles.checkbox21,'Value',WinkelAnpassung);
    set(handles.checkbox22,'Value',KleinWinkel);
    set(handles.checkbox16,'Value',FreiWinkel); 
    set(handles.checkbox17,'Value',GrossWinkel);    
    set(handles.edit15,'String',num2str(SchraffurSkywritestart));
    set(handles.edit16,'String',num2str(SchraffurSkywriteend));
    set(handles.edit17,'String',num2str(Schraffurwinkelstart));
    set(handles.edit18,'String',num2str(Schraffurwinkelinkrem));
    set(handles.edit30,'String',num2str(MinimalLaenge));
    set(handles.edit31,'String',num2str(OnDelayLength));
    set(handles.edit32,'String',num2str(OffDelayLength));   
    
    %Einige Variabeln werden als globale Variabeln gespeichert
    Var.Schichtdicke=Schichtdicke;
    Var.Linienabstand=Linienabstand;
    Var.Scangeschw=Scangeschw;
    Var.VorschubAmax=VorschubAmax;
    Var.Drehoffsetlength=Drehoffsetlength;
    Var.SchraffurSkywritestart=SchraffurSkywritestart;
    Var.SchraffurSkywriteend=SchraffurSkywriteend;
    Var.Schraffurwinkelstart=Schraffurwinkelstart;
    Var.Schraffurwinkelinkrem=Schraffurwinkelinkrem;
    Var.Verhaeltnis=Verhaeltnis;
    Var.MinJumplengthY=MinJumplengthY;
    Var.MinimalLaenge=MinimalLaenge;
    Var.OnDelayLength=OnDelayLength;
    Var.OffDelayLength=OffDelayLength;
        
    %Schaltflächen zur Schraffur werden richtig aktiviert
    set(handles.edit15,'Enable','on');
    set(handles.edit16,'Enable','on');

    %Schaltflächen zum Schraffurwinkel werden richtig aktiviert    
    if KleinWinkel==1 %kleinstmöglicher Winkel
        set(handles.edit29,'Enable','on');
        set(handles.edit17,'Enable','off');
        set(handles.edit18,'Enable','off');
        set(handles.edit26,'Enable','off');
        set(handles.checkbox21,'Enable','off');
    end
    if FreiWinkel==1 %freiwählbarer Winkel
        set(handles.edit29,'Enable','off');
        set(handles.edit17,'Enable','on');
        set(handles.edit18,'Enable','on');
        set(handles.edit26,'Enable','on');
        set(handles.checkbox21,'Enable','on');
    end
    if GrossWinkel==1 %Grösstmöglicher Winkel
        set(handles.edit29,'Enable','off');
        set(handles.edit17,'Enable','off');
        set(handles.edit18,'Enable','off');
        set(handles.edit26,'Enable','off');
        set(handles.checkbox21,'Enable','off');
    end
    
    %Schaltflächen für Minimallänge, Delays und Axialrichtung aktivieren
    if linksrechts==1 %Von links nach rechts
        set(handles.checkbox24,'Value',1);
        set(handles.checkbox26,'Value',0);
        set(handles.checkbox27,'Value',0);
    end
    if rechtslinks==1 %von rechts nach links
        set(handles.checkbox24,'Value',0);
        set(handles.checkbox26,'Value',1);
        set(handles.checkbox27,'Value',0);
    end
    if alternierend==1 %alternieren
        set(handles.checkbox24,'Value',0);
        set(handles.checkbox26,'Value',0);
        set(handles.checkbox27,'Value',1);
    end
    
end

%Wird ausgeführt nach Benutzen von pushbutton11 (Aktuelle Parameter speichern)
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
    fprintf(fid,['Linienabstand:',get(handles.edit13,'String'),'\r\n']);
    fprintf(fid,['Scangeschw:',get(handles.edit23,'String'),'\r\n']);
    fprintf(fid,['VorschubAmax:',get(handles.edit24,'String'),'\r\n']);
    fprintf(fid,['Drehoffsetlength:',get(handles.edit25,'String'),'\r\n']);
    fprintf(fid,['SchraffurSkywritestart:',get(handles.edit15,'String'),'\r\n']);
    fprintf(fid,['SchraffurSkywriteend:',get(handles.edit16,'String'),'\r\n']);
    fprintf(fid,['Schraffurwinkelstart:',get(handles.edit17,'String'),'\r\n']);
    fprintf(fid,['Schraffurwinkelinkrem:',get(handles.edit18,'String'),'\r\n']);
    fprintf(fid,['Verhaeltnis:',get(handles.edit29,'String'),'\r\n']);    
    fprintf(fid,['MinJumplengthY:',get(handles.edit26,'String'),'\r\n']);
    fprintf(fid,['WinkelAnpassung:',num2str(get(handles.checkbox21,'Value')),'\r\n']);
    fprintf(fid,['KleinWinkel:',num2str(get(handles.checkbox22,'Value')),'\r\n']);    
    fprintf(fid,['FreiWinkel:',num2str(get(handles.checkbox16,'Value')),'\r\n']);  
    fprintf(fid,['GrossWinkel:',num2str(get(handles.checkbox17,'Value')),'\r\n']);  
    fprintf(fid,['MinimalLaenge:',get(handles.edit30,'String'),'\r\n']);
    fprintf(fid,['OnDelayLength:',get(handles.edit31,'String'),'\r\n']);    
    fprintf(fid,['OffDelayLength:',get(handles.edit32,'String'),'\r\n']);
    fprintf(fid,['linksrechts:',num2str(get(handles.checkbox24,'Value')),'\r\n']);    
    fprintf(fid,['rechtslinks:',num2str(get(handles.checkbox26,'Value')),'\r\n']);  
    fprintf(fid,['alternierend:',num2str(get(handles.checkbox27,'Value')),'\r\n']);   
    
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
    fprintf(fid,['NCText.Fokus3:',Var.NCText.Fokus3,'\r\n']);
    fprintf(fid,['NCText.Fokus4:',Var.NCText.Fokus4,'\r\n']);    
    fprintf(fid,['NCText.Vorschub1:',Var.NCText.Vorschub1,'\r\n']);
    fprintf(fid,['NCText.Vorschub2:',Var.NCText.Vorschub2,'\r\n']);
    fprintf(fid,['NCText.Eilgang1:',Var.NCText.Eilgang1,'\r\n']);
    fprintf(fid,['NCText.Eilgang2:',Var.NCText.Eilgang2,'\r\n']);
    fprintf(fid,['NCText.Eilgang3:',Var.NCText.Eilgang3,'\r\n']);
    fprintf(fid,['NCText.Laseraus1:',Var.NCText.Laseraus1,'\r\n']);
    fprintf(fid,['NCText.Laseraus2:',Var.NCText.Laseraus2,'\r\n']);
    fprintf(fid,['NCText.Laseraus3:',Var.NCText.Laseraus3,'\r\n']);    
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
    
    fclose(fid); %txt-file wird geschlossen
end

%Wird ausgeführt nach Benutzung von edit23 (Scangeschwindigkeit [mm/s])
function edit23_Callback(hObject, eventdata, handles)
global Var
Scangeschw=str2double(get(handles.edit23,'String'));
if Scangeschw==0
    warndlg('Scangeschwindigkeit muss grösser Null sein')
    set(handles.edit23,'String',num2str(Var.Scangeschw));
elseif isnan(Scangeschw)
    warndlg('Ungültige Eingabe')
    set(handles.edit23,'String',num2str(Var.Scangeschw));
elseif Scangeschw<0
    set(handles.edit23,'String',num2str(abs(Scangeschw)));
    Var.Scangeschw=abs(Scangeschw);
else
    Var.Scangeschw=Scangeschw;
end

% --- Executes during object creation, after setting all properties.
function edit23_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Wird ausgeführt nach Benutzung von edit24 (Maximale Drehzahl [°/s])
function edit24_Callback(hObject, eventdata, handles)
global Var
VorschubAmax=str2double(get(handles.edit24,'String'));
if VorschubAmax==0
    warndlg('Maximale Drehzahl muss grösser Null sein')
    set(handles.edit24,'String',num2str(Var.VorschubAmax));
elseif isnan(VorschubAmax)
    warndlg('Ungültige Eingabe')
    set(handles.edit24,'String',num2str(Var.VorschubAmax));
elseif VorschubAmax<0
    set(handles.edit24,'String',num2str(abs(VorschubAmax)));
    Var.VorschubAmax=abs(VorschubAmax);
else
    Var.VorschubAmax=VorschubAmax;
end

% --- Executes during object creation, after setting all properties.
function edit24_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Wird ausgeführt nach Benutzung von edit25 (Drehoffset der Ebene [mm])
function edit25_Callback(hObject, eventdata, handles)
global Var
Drehoffsetlength=str2double(get(handles.edit25,'String'));
if isnan(Drehoffsetlength)
    warndlg('Ungültige Eingabe')
    set(handles.edit25,'String',num2str(Var.Drehoffsetlength));
elseif Drehoffsetlength<0
    set(handles.edit25,'String',num2str(abs(Drehoffsetlength)));
    Var.Drehoffsetlength=abs(Drehoffsetlength);
else
    Var.Drehoffsetlength=Drehoffsetlength;
end

% --- Executes during object creation, after setting all properties.
function edit25_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Wird ausgeführt nach Benutzung von edit26 (Minimale Jumplinienlänge)
function edit26_Callback(hObject, eventdata, handles)
global Var
MinJumplengthY=str2double(get(handles.edit26,'String'));
if isnan(MinJumplengthY)
    warndlg('Ungültige Eingabe')
    set(handles.edit26,'String',num2str(Var.MinJumplengthY));
elseif MinJumplengthY<0
    set(handles.edit26,'String',num2str(abs(MinJumplengthY)));
    Var.MinJumplengthY=abs(MinJumplengthY);
else
    Var.MinJumplengthY=MinJumplengthY;
end

% --- Executes during object creation, after setting all properties.
function edit26_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Wird ausgeführt nach Benutzung von checkbox16 (freiwählbarer Winkel)
function checkbox16_Callback(hObject, eventdata, handles)
set(handles.checkbox22,'Value',0);
set(handles.checkbox16,'Value',1);
set(handles.checkbox17,'Value',0);
set(handles.checkbox21,'Enable','on');
set(handles.edit29,'Enable','off');
set(handles.edit17,'Enable','on');
set(handles.edit18,'Enable','on');
set(handles.edit26,'Enable','on');

%Wird ausgeführt nach Benutzung von checkbox17 (grösstmöglicher Winkel)
function checkbox17_Callback(hObject, eventdata, handles)
set(handles.checkbox22,'Value',0);
set(handles.checkbox16,'Value',0);
set(handles.checkbox17,'Value',1);
set(handles.checkbox21,'Enable','off');
set(handles.edit29,'Enable','off');
set(handles.edit17,'Enable','off');
set(handles.edit18,'Enable','off');
set(handles.edit26,'Enable','off');

%Wird ausgeführt nach Benutzung von checkbox21 (Winkel Anpassen)
function checkbox21_Callback(hObject, eventdata, handles)

%Wird ausgeführt nach Benutzung von checkbox22 (kleinstmöglicher Winkel)
function checkbox22_Callback(hObject, eventdata, handles)
set(handles.checkbox22,'Value',1);
set(handles.checkbox16,'Value',0);
set(handles.checkbox17,'Value',0);
set(handles.checkbox21,'Enable','off');
set(handles.edit29,'Enable','on');
set(handles.edit17,'Enable','off');
set(handles.edit18,'Enable','off');
set(handles.edit26,'Enable','off');

%Wird ausgeführt nach Benutzung von edit29 (Verhältnis)
function edit29_Callback(hObject, eventdata, handles)
global Var
Verhaeltnis=str2double(get(handles.edit29,'String'));
if isnan(Verhaeltnis)
    warndlg('Ungültige Eingabe')
    set(handles.edit29,'String',num2str(Var.Verhaeltnis));
elseif Verhaeltnis<0
    set(handles.edit29,'String',num2str(0));
    Var.Verhaeltnis=0;
elseif Verhaeltnis>1
    set(handles.edit29,'String',num2str(1));
    Var.Verhaeltnis=1;
else
    Var.Verhaeltnis=Verhaeltnis;
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
if isnan(MinimalLaenge)
    warndlg('Ungültige Eingabe')
    set(handles.edit30,'String',num2str(Var.MinimalLaenge));
elseif MinimalLaenge<0
    set(handles.edit30,'String',num2str(abs(MinimalLaenge)));
    Var.MinimalLaenge=abs(MinimalLaenge);
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
if isnan(OnDelayLength)
    warndlg('Ungültige Eingabe')
    set(handles.edit31,'String',num2str(Var.OnDelayLength));
elseif OnDelayLength<0
    set(handles.edit31,'String',num2str(abs(OnDelayLength)));
    Var.OnDelayLength=abs(OnDelayLength);
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
OffDelayLength=str2double(get(handles.edit30,'String'));
if isnan(OffDelayLength)
    warndlg('Ungültige Eingabe')
    set(handles.edit32,'String',num2str(Var.OffDelayLength));
elseif OffDelayLength<0
    set(handles.edit32,'String',num2str(abs(OffDelayLength)));
    Var.OffDelayLength=abs(OffDelayLength);
else
    Var.OffDelayLength=OffDelayLength;
end

% --- Executes during object creation, after setting all properties.
function edit32_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Wird ausgeführt nach Benutzung von checkbox24 (Axialrichtung von links nach rechts)
function checkbox24_Callback(hObject, eventdata, handles)
set(handles.checkbox24,'Value',1);
set(handles.checkbox26,'Value',0);
set(handles.checkbox27,'Value',0);

%Wird ausgeführt nach Benutzung von checkbox26 (Axialrichtung von rechts nach links)
function checkbox26_Callback(hObject, eventdata, handles)
set(handles.checkbox24,'Value',0);
set(handles.checkbox26,'Value',1);
set(handles.checkbox27,'Value',0);

%Wird ausgeführt nach Benutzung von checkbox26 (Axialrichtung alternierend)
function checkbox27_Callback(hObject, eventdata, handles)
set(handles.checkbox24,'Value',0);
set(handles.checkbox26,'Value',0);
set(handles.checkbox27,'Value',1);

%Wird ausgeführt nach Benutzung von edit33 (Bearbeitungszeit)
function edit33_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit33_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
