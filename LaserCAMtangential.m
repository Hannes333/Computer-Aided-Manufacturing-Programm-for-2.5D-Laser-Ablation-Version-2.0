function varargout = LaserCAMtangential(varargin)
% Dies ist das Skript zum Fenster LaserCAMtangential.fig
% In diesem Code werden alle Eingaben die auf dem LaserCAMtangential.fig getätigt
% werden ausgewertet.
% Aus diesem Skript kann ein weiteres Skript aufgerufen namens NCCodetangential.m
% Das entsprechende Fenster zu NCCodetangential.m lautet NCCodetangential.fig

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @LaserCAMtangential_OpeningFcn, ...
                   'gui_OutputFcn',  @LaserCAMtangential_OutputFcn, ...
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


% --- Executes just before LaserCAMtangential is made visible.
function LaserCAMtangential_OpeningFcn(hObject, eventdata, handles, varargin)

clc %Bereinigt das Command Window

% Globales Struct zur Übergabe der Variabeln wird erstellt
global Var

%Ausgangsvariabeln werden definiert
AusgleichX=0;       %Ausgleichsrechnung der Helix über X-Koordinaten (1) oder über Y-Koordinaten (0)
Bahnabstand=0.2; %Abstand zwischen den BahnPunkte auf der Helix [mm] 
OffsetStart=0;  %Erste KonturoffsetDistanz [mm]
OffsetLength=0.03; %KonturoffsetDistanz [mm]
OffsetEnd=2; %Maximale KonturoffsetDistanz [mm]
HatchVerlaengerung=0.06; %Verlängerung der Hatches über den Rand [mm]
MinimalLaenge=0.003; %Minimale Hatchsegmentlänge [mm]
Zusammenfassen=3; %Ab diesem Hatch werden die Hatches zusammengefasst
Scangeschw=100; %Einstellen der Scangeschwindigkeit [mm/s]
Jumpgeschw=100; %Einstellen der Jumpgeschwindigkeit [mm/s]
VorschubCmax=180; %Maximale Drehzahl der Drehachse C [°/s]
Zickzack=1; %Bei Zickzackmodus wird die Scanrichtung bei jedem zweiten Hatch umgedreht
NCCodeKomplett=1; %NC-Code komplett ausschreiben (1), NC-Code mit MOVEABS Befehlen(0)
LaserOnOffalle=0; %LaserOnOff bei jeder Hatchlinie (1), LaseronOff nur bei Hatchreihe und Ende (0)

%Ausgangsvariabeln werden auf den Feldern eingefügt
set(handles.edit1,'String',num2str(Bahnabstand));
set(handles.edit2,'String',num2str(OffsetStart));
set(handles.edit3,'String',num2str(OffsetLength));
set(handles.edit4,'String',num2str(OffsetEnd));
set(handles.edit5,'String',num2str(HatchVerlaengerung));
set(handles.edit6,'String',num2str(MinimalLaenge));
set(handles.edit7,'String',num2str(Zusammenfassen));
set(handles.edit8,'String',num2str(Scangeschw));
set(handles.edit9,'String',num2str(Jumpgeschw));
set(handles.edit10,'String',num2str(VorschubCmax));
set(handles.checkbox1,'Value',Zickzack);
set(handles.checkbox5,'Value',AusgleichX);
set(handles.checkbox6,'Value',~AusgleichX);

%Einige Ausgangsvariabeln werden als globale Variabeln gespeichert
Var.AusgleichX=AusgleichX;
Var.Bahnabstand=Bahnabstand;
Var.OffsetStart=OffsetStart;
Var.OffsetLength=OffsetLength;
Var.OffsetEnd=OffsetEnd;
Var.HatchVerlaengerung=HatchVerlaengerung;
Var.MinimalLaenge=MinimalLaenge;
Var.Zusammenfassen=Zusammenfassen;
Var.Scangeschw=Scangeschw;
Var.Jumpgeschw=Jumpgeschw;
Var.VorschubCmax=VorschubCmax;
Var.Zickzack=Zickzack;
Var.NCCodeKomplett=NCCodeKomplett;
Var.LaserOnOffalle=LaserOnOffalle;

%Ausgangswerte zum NC-Code werden definiert
NCText.Header1='G90';
NCText.Header2='G359';
NCText.Header3='GALVO LASERMODE U 1';
NCText.Header4='GALVO LASEROUTPUTPERIOD U 100';
NCText.Header5='GALVO LASER1PULSEWIDTH U 10';
NCText.Header6='GALVO SUPPRESSIONPULSEWIDTH U 20';
NCText.Header7='GALVO LASERONDELAY U -5';
NCText.Header8='GALVO LASEROFFDELAY U 58';
NCText.Header9='VELOCITY ON';
NCText.Header10='HOME C';
NCText.Header11='';
NCText.Header12='';
NCText.Laseron='GALVO LASEROVERRIDE U ON';
NCText.Laseroff='GALVO LASEROVERRIDE U OFF';
NCText.Kommentar1='//';
NCText.Kommentar2='';
NCText.Finish1='G00 U0 V0';
NCText.Finish2='END PROGRAM';
NCText.Finish3='';
NCText.Finish4='';
NCText.Finish5='';
NCText.EbeneSta1='';
NCText.EbeneSta2='';
NCText.EbeneEnd1='';
NCText.EbeneEnd2='';
NCText.BahnPunktSta='G01';
NCText.BahnPunktEnd=' F60';
NCText.X=' X';
NCText.Y=' Y';
NCText.Z=' Z';
NCText.B=' B';
NCText.C=' C-';
NCText.u=' U';
NCText.v=' V';

NCText.Vorschub1='F';
NCText.Vorschub2=' //Dominante Geschw [°/s]';
NCText.LaserSta='G01';
NCText.LaserEnd='';

NCText.MoveabsX='MOVEABS X';
NCText.MoveabsY='MOVEABS Y';
NCText.MoveabsZ='MOVEABS Z';
NCText.MoveabsB='MOVEABS B';
NCText.MoveabsC='MOVEABS C-';
NCText.Movewait='WAIT MOVEDONE X Y Z B C';
NCText.Hatchjump1='G08 G01 U';
NCText.Hatchjump2=' V';
NCText.Hatchjump3=' F100';
NCText.Hatchscan1='G08 G01 U';
NCText.Hatchscan2=' V';
NCText.Hatchscan3=' F100';

%NCText als globale Variable speichern
Var.NCText=NCText;

%Pfad, wo der NC-Code gespeichert werden soll
Var.FolderName='';
%Pfad, wo die Stl-Dateien ausgelesen werden sollen
Var.PathName='';

%Alle Felder bis auf den STL-Datei importieren Button müssen inaktiv sein
set(handles.edit1,'Enable','off');
set(handles.edit2,'Enable','off');
set(handles.edit3,'Enable','off');
set(handles.edit4,'Enable','off');
set(handles.edit5,'Enable','off');
set(handles.edit6,'Enable','off');
set(handles.edit7,'Enable','off');
set(handles.edit8,'Enable','off');
set(handles.edit9,'Enable','off');
set(handles.edit10,'Enable','off');
set(handles.checkbox1,'Enable','off');
set(handles.checkbox2,'Enable','off');
set(handles.checkbox3,'Enable','off');
set(handles.checkbox4,'Enable','off');
set(handles.checkbox5,'Enable','off');
set(handles.checkbox6,'Enable','off');
set(handles.slider1,'Enable','off');
set(handles.pushbutton2,'Enable','off');
set(handles.pushbutton3,'Enable','off');
set(handles.pushbutton4,'Enable','off');
set(handles.pushbutton5,'Enable','off');
set(handles.pushbutton6,'Enable','off');
set(handles.edit11,'Enable','off');

% Choose default command line output for LaserCAMtangential
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes LaserCAMtangential wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = LaserCAMtangential_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%Wird ausgeführt nach Benutzung von Button1 (Stl-Datei importieren)
function pushbutton1_Callback(hObject, eventdata, handles)
global Var

[FileName,PathName] = uigetfile('*.stl','Auswahl der Stl-Datei',Var.PathName);
if ischar(FileName) && ischar(PathName)
    Var.PathName=PathName;
    Pfad=[PathName,FileName];
    Titel=[FileName(1:end-4),'NCCode'];
    Var.Titel=Titel;
    
    %Funktion, die die Stl-Datei einliest
    [f1,v1,n1] = F00_stlread(Pfad); 
    disp('Stl-Datei eingelesen');

    %Darstellung des Stl-Objekts
    cla %Grafik zurücksetzen
    FD3StlObjekt(v1,0);
    hold on
    view([-45 45]); %Set a nice view angle
    
    %Funktion die die Stl-Datei überprüft und repariert
    [v1,Defekt,Defekte]=F02_Reparieren(v1);
    disp('Stl-Datei überprüft');
    if Defekt==1
        for i=1:size(Defekte,1)
            if Defekte(i,7)==1
                plot3([Defekte(i,1),Defekte(i,4)],[Defekte(i,2),Defekte(i,5)],[Defekte(i,3),Defekte(i,6)],'b') %Kante mit mehreren angrenzenden Nachbarkante darstellen
                scatter3(Defekte(i,1),Defekte(i,2),Defekte(i,3),20,'b','filled'); %KantenEckpunkt1 darstellen
                scatter3(Defekte(i,4),Defekte(i,5),Defekte(i,6),20,'b','filled'); %KantenEckpunkt2 darstellen
            elseif Defekte(i,7)==2
                plot3([Defekte(i,1),Defekte(i,4)],[Defekte(i,2),Defekte(i,5)],[Defekte(i,3),Defekte(i,6)],'r') %Kante mit mehreren angrenzenden Nachbarkante darstellen
                scatter3(Defekte(i,1),Defekte(i,2),Defekte(i,3),20,'r','filled'); %KantenEckpunkt1 darstellen
                scatter3(Defekte(i,4),Defekte(i,5),Defekte(i,6),20,'r','filled'); %KantenEckpunkt2 darstellen
            end
        end
        errordlg('Stl-Datei hat Defekte. Mehr als zwei Dreiecksflächen stossen in gemeinsamer Kante aufeinander (blau). Keine gegenüberliegende Kante gefunden (rot)');
        set(handles.pushbutton4,'Enable','on');
        set(handles.pushbutton5,'Enable','on');
        set(handles.pushbutton6,'Enable','on');
        error('Stl-Datei hat Defekte. Mehr als zwei Dreiecksflächen stossen in gemeinsamer Kante aufeinander (blau). Keine gegenüberliegende Kante gefunden (rot)');
    end
    
    %Funktion die die Geometrie Abrollt
    [v3,n3,NK3,Umfangsabtrag]=F04_Abrollen(v1,n1,f1);
    disp('Abgerollte Geometrie berechnet');
  
    %Funktion zur Erstellung der Demohelix
    Bahnabstand=0.05;
    [Nutgrund,Rand3,Rand1,KeinRand,HelixZylU,HelixKarU,betasU,...
        HelixZylX,HelixKarX,betasX,HelixZylY,HelixKarY,betasY,...
        Rechtslaufend,NutrandKanten,n1]...
        =F07_Helix(v3,n3,n1,NK3,Umfangsabtrag,Bahnabstand);
    disp('Helix wurde berechnet');
    
    %Aufgerollte Demohelix darstellen
    hold on
    if Umfangsabtrag==1
        plot3(HelixKarU(:,1),HelixKarU(:,2),HelixKarU(:,3),'r'); %Aufgerollte Helix darstellen
    else %Umfangsabtrag==0
        AusgleichX=get(handles.checkbox5,'Value');
        if AusgleichX==1
            plot3(HelixKarX(:,1),HelixKarX(:,2),HelixKarX(:,3),'r'); %Aufgerollte Helix darstellen
        else %AusleichX==0
            plot3(HelixKarY(:,1),HelixKarY(:,2),HelixKarY(:,3),'r'); %Aufgerollte Helix darstellen
        end
    end
    axis tight %DarstellungsFeld so nahe am 3d Objekt wie möglich
    
    %Übergabe der Variablen
    Var.v1=v1;
    Var.n1=n1;
    Var.v3=v3;
    Var.n3=n3;
    Var.NK3=NK3;
    Var.Umfangsabtrag=Umfangsabtrag;
    Var.HelixZylU=HelixZylU;
    Var.HelixKarU=HelixKarU;
    Var.HelixZylX=HelixZylX;
    Var.HelixKarX=HelixKarX;
    Var.HelixZylY=HelixZylY;
    Var.HelixKarY=HelixKarY;
    Var.NutrandKanten=NutrandKanten;
    
    %Entsprechende Felder auf dem GUI aktualisieren
    set(handles.edit1,'Enable','on');
    set(handles.edit2,'Enable','on');
    set(handles.edit3,'Enable','on');
    set(handles.edit4,'Enable','on');
    set(handles.edit5,'Enable','on');
    set(handles.edit6,'Enable','on');
    set(handles.edit7,'Enable','on');
    set(handles.edit8,'Enable','on');
    set(handles.edit9,'Enable','on');
    set(handles.edit10,'Enable','on');
    set(handles.checkbox1,'Enable','on');
    set(handles.checkbox2,'Enable','on');
    set(handles.checkbox3,'Enable','on');
    set(handles.checkbox4,'Enable','off');
    set(handles.pushbutton2,'Enable','on');
    set(handles.pushbutton3,'Enable','off');
    set(handles.pushbutton4,'Enable','on');
    set(handles.pushbutton5,'Enable','on');
    set(handles.pushbutton6,'Enable','on');
    set(handles.slider1,'Enable','off');
    set(handles.checkbox2,'Value',1);
    set(handles.checkbox3,'Value',0);
    set(handles.checkbox4,'Value',0);
    if Umfangsabtrag==0
        set(handles.checkbox5,'Enable','on');
        set(handles.checkbox6,'Enable','on');
    else
        set(handles.checkbox5,'Enable','off');
        set(handles.checkbox6,'Enable','off');
    end
end


%Wird ausgeführt nach Benutzung von Button2 (Laserbahnen berechnen)
function pushbutton2_Callback(hObject, eventdata, handles)
global Var
%Zusammensuchen der benötigten Werte
Bahnabstand=str2double(get(handles.edit1,'String')); 
OffsetStart=str2double(get(handles.edit2,'String'));
OffsetLength=str2double(get(handles.edit3,'String'));
OffsetEnd=str2double(get(handles.edit4,'String'));
HatchVerlaengerung=str2double(get(handles.edit5,'String'));
MinimalLaenge=str2double(get(handles.edit6,'String'));
Umfangsabtrag=Var.Umfangsabtrag;
n1=Var.n1;
v1=Var.v1;
n3=Var.n3;
v3=Var.v3;
NK3=Var.NK3;

%Funktion zur Erstellung der Helix
[Nutgrund,Rand3,Rand1,KeinRand,HelixZylU,HelixKarU,betasU,...
    HelixZylX,HelixKarX,betasX,HelixZylY,HelixKarY,betasY,...
    Rechtslaufend,NutrandKanten,n1]...
    =F07_Helix(v3,n3,n1,NK3,Umfangsabtrag,Bahnabstand);
disp('Helix wurde berechnet');

%Ausgewählte Ausgleichshelix speichern

if Umfangsabtrag==1
    betas=betasU;
    HelixZyl=HelixZylU;
    HelixKar=HelixKarU;
else %Umfangsabtrag==0
    AusgleichX=get(handles.checkbox5,'Value');
    if AusgleichX==1
        betas=betasX;
        HelixZyl=HelixZylX;
        HelixKar=HelixKarX;
    else %AusleichX==0
        betas=betasY;
        HelixZyl=HelixZylY;
        HelixKar=HelixKarY;
    end
end

%Funktion die die Schattenwürfe und die Konturoffsets berechnet
[Konturs,Deckels,Hatches,BahnPunkte]=F15_Schattenwuerfe(HelixKar,HelixZyl,...
    betas,v1,n1,v3,NK3,Nutgrund,Rand1,KeinRand,Umfangsabtrag,Rechtslaufend,...
    OffsetStart,OffsetLength,OffsetEnd,HatchVerlaengerung,MinimalLaenge);
disp('Schattenwürfe und Konturoffset berechnet');

%Zwischenspeichern einiger Variabeln
Var.Hatches=Hatches;
Var.BahnPunkte=BahnPunkte;
Var.HelixZyl=HelixZyl;
Var.HelixKar=HelixKar;
Var.betas=betas;
Var.Nutgrund=Nutgrund;
Var.Konturs=Konturs;
Var.Deckels=Deckels;
Var.Hatches=Hatches;
Var.Rechtslaufend=Rechtslaufend;

%Slider in Betrieb nehmen
ErsterHatch=find(~cellfun('isempty', Hatches(:,1)),1,'first');
LetzterHatch=find(~cellfun('isempty', Hatches(:,1)),1,'last');
d=round((ErsterHatch+LetzterHatch)/2);
set(handles.slider1,'Enable','on');
set(handles.slider1,'Min',ErsterHatch);
set(handles.slider1,'Max',LetzterHatch);
set(handles.slider1,'Value',d);

%Aktualisierung edit 11
set(handles.edit11,'String',['Hatch: ',num2str(d),'  Bahnpunkt:  X',num2str(BahnPunkte(d,1),'%4.3f'),'  Y',num2str(BahnPunkte(d,2),'%4.3f'),'  Z',num2str(BahnPunkte(d,3),'%4.3f'),'  B',num2str(BahnPunkte(d,4),'%4.3f'),'  C',num2str(BahnPunkte(d,5),'%4.3f')]); 

%Darstellen einer Hatchberechnung
cla %Grafik zurücksetzen
hold on
FDHatches(HelixZyl,HelixKar,betas,v1,Nutgrund,Konturs,Deckels,Hatches,Rechtslaufend,d);
axis tight %DarstellungsFeld so nahe am 3d Objekt wie möglich

%Freischalten von Benutzerfunktionen
set(handles.pushbutton3,'Enable','on');
set(handles.checkbox4,'Enable','on');
set(handles.checkbox2,'Value',0);
set(handles.checkbox3,'Value',0);
set(handles.checkbox4,'Value',1);

%Wird ausgeführt nach Benutzung von Button3 (NC-Code berechnen)
function pushbutton3_Callback(hObject, eventdata, handles)
global Var
%Zusammensuchen der benötigten Werte
Zusammenfassen=str2double(get(handles.edit7,'String'));
Scangeschw=str2double(get(handles.edit8,'String'));
Jumpgeschw=str2double(get(handles.edit9,'String'));
VorschubCmax=str2double(get(handles.edit10,'String'));
Zickzack=get(handles.checkbox1,'Value');
Var.Zusammenfassen=Zusammenfassen;
Var.Scangeschw=Scangeschw;
Var.Jumpgeschw=Jumpgeschw;
Var.VorschubCmax=VorschubCmax;
Var.Zickzack=Zickzack;
NCCodetangential

%Wird ausgeführt nach Benutzung von Button4 (3D Ansicht)
function pushbutton4_Callback(hObject, eventdata, handles)
rotate3d on

%Wird ausgeführt nach Benutzung von Button5 (Zoom)
function pushbutton5_Callback(hObject, eventdata, handles)
zoom on

%Wird ausgeführt nach Benutzung von Button4 (Verschieben)
function pushbutton6_Callback(hObject, eventdata, handles)
pan on

%Wird ausgeführt nach Benutzung von checkbox1 (Zickzack)
function checkbox1_Callback(hObject, eventdata, handles)

%Wird ausgeführt nach Benutzung von checkbox2 (Original Geometrie)
function checkbox2_Callback(hObject, eventdata, handles)
set(handles.checkbox2,'Value',1);
set(handles.checkbox3,'Value',0);
set(handles.checkbox4,'Value',0);
global Var

%Darstellung des Stl-Objekts
cla %Grafik zurücksetzen
FD3StlObjekt(Var.v1,0);
hold on

%Entsprechende Aufgerollte Helix darstellen
Umfangsabtrag=Var.Umfangsabtrag;
if Umfangsabtrag==1
    HelixKarU=Var.HelixKarU;
    plot3(HelixKarU(:,1),HelixKarU(:,2),HelixKarU(:,3),'r'); %Aufgerollte Helix darstellen
else %Umfangsabtrag==0
    AusgleichX=get(handles.checkbox5,'Value');
    if AusgleichX==1
        HelixKarX=Var.HelixKarX;
        plot3(HelixKarX(:,1),HelixKarX(:,2),HelixKarX(:,3),'r'); %Aufgerollte Helix darstellen
    else %AusleichX==0
        HelixKarY=Var.HelixKarY;
        plot3(HelixKarY(:,1),HelixKarY(:,2),HelixKarY(:,3),'r'); %Aufgerollte Helix darstellen
    end
end
axis tight %DarstellungsFeld so nahe am 3d Objekt wie möglich

%Wird ausgeführt nach Benutzung von checkbox3 (Abgerollte Geometrie)
function checkbox3_Callback(hObject, eventdata, handles)
set(handles.checkbox2,'Value',0);
set(handles.checkbox3,'Value',1);
set(handles.checkbox4,'Value',0);
global Var  

%Darstellen der abgerollten zusammenhängenden Geometrie
cla %Grafik zurücksetzen
FD3StlObjekt(Var.v3,1);
hold on    

%Darstellen der NutrandKanten und der DemoHelix
NutrandKanten=Var.NutrandKanten;
for j=1:2:size(NutrandKanten,1)
    plot3(NutrandKanten(j:j+1,1),NutrandKanten(j:j+1,2),NutrandKanten(j:j+1,3),'k'); %NutrandKanten darstellen
end

%Entsprechende Abgerollte Helix darstellen
Umfangsabtrag=Var.Umfangsabtrag;
if Umfangsabtrag==1
    HelixZylU=Var.HelixZylU;
    plot3(HelixZylU(:,1),HelixZylU(:,2),HelixZylU(:,3),'r'); %Abgerollte Helix darstellen
else %Umfangsabtrag==0
    AusgleichX=get(handles.checkbox5,'Value');
    if AusgleichX==1
        HelixZylX=Var.HelixZylX;
        plot3(HelixZylX(:,1),HelixZylX(:,2),HelixZylX(:,3),'r'); %Abgerollte Helix darstellen
    else %AusleichX==0
        HelixZylY=Var.HelixZylY;
        plot3(HelixZylY(:,1),HelixZylY(:,2),HelixZylY(:,3),'r'); %Abgerollte Helix darstellen
    end
end
axis tight %DarstellungsFeld so nahe am 3d Objekt wie möglich

%Wird ausgeführt nach Benutzung von checkbox4 (Ausgerichtete Geometrie mit Hatches)
function checkbox4_Callback(hObject, eventdata, handles)
set(handles.checkbox2,'Value',0);
set(handles.checkbox3,'Value',0);
set(handles.checkbox4,'Value',1);

%Variabeln zusammensuchen
global Var
BahnPunkte=Var.BahnPunkte;
HelixZyl=Var.HelixZyl;
HelixKar=Var.HelixKar;
betas=Var.betas;
v1=Var.v1;
Nutgrund=Var.Nutgrund;
Konturs=Var.Konturs;
Deckels=Var.Deckels;
Hatches=Var.Hatches;
Rechtslaufend=Var.Rechtslaufend;
d=get(handles.slider1,'Value');

%Aktualisierung edit 11
set(handles.edit11,'String',['Hatch: ',num2str(d),'  Bahnpunkt:  X',num2str(BahnPunkte(d,1),'%4.3f'),'  Y',num2str(BahnPunkte(d,2),'%4.3f'),'  Z',num2str(BahnPunkte(d,3),'%4.3f'),'  B',num2str(BahnPunkte(d,4),'%4.3f'),'  C',num2str(BahnPunkte(d,5),'%4.3f')]); 

%Darstellen der ausgerichteten Geometrie mit Hatches
cla
hold on
FDHatches(HelixZyl,HelixKar,betas,v1,Nutgrund,Konturs,Deckels,Hatches,Rechtslaufend,d);
axis tight %DarstellungsFeld so nahe am 3d Objekt wie möglich

%Wird ausgeführt nach Benutzung von checkbox5 (Bahnhelix über X-Koordinaten berechnen)
function checkbox5_Callback(hObject, eventdata, handles)
set(handles.checkbox5,'Value',1);
set(handles.checkbox6,'Value',0);
global Var
Umfangsabtrag=Var.Umfangsabtrag;

%Falls Checkbox2 (Original Geometrie) ausgewählt, Aufgerollte Helix darstellen
if get(handles.checkbox2,'Value')==1
    %Darstellung der original Geometrie
    cla
    FD3StlObjekt(Var.v1,0);
    hold on
    if Umfangsabtrag==1
        HelixKarU=Var.HelixKarU;
        plot3(HelixKarU(:,1),HelixKarU(:,2),HelixKarU(:,3),'r'); %Aufgerollte Helix darstellen
    else %Umfangsabtrag==0
        AusgleichX=get(handles.checkbox5,'Value');
        if AusgleichX==1
            HelixKarX=Var.HelixKarX;
            plot3(HelixKarX(:,1),HelixKarX(:,2),HelixKarX(:,3),'r'); %Aufgerollte Helix darstellen
        else %AusleichX==0
            HelixKarY=Var.HelixKarY;
            plot3(HelixKarY(:,1),HelixKarY(:,2),HelixKarY(:,3),'r'); %Aufgerollte Helix darstellen
        end
    end
end

%Falls Checkbox3 (Abgerollte Geometrie) ausgewählt, Abgerollte Helix darstellen
if get(handles.checkbox3,'Value')==1
    %Darstellen der abgerollten zusammenhängenden Geometrie
    cla
    FD3StlObjekt(Var.v3,1);
    hold on    
    %Darstellen der NutrandKanten und der DemoHelix
    NutrandKanten=Var.NutrandKanten;
    for j=1:2:size(NutrandKanten,1)
        plot3(NutrandKanten(j:j+1,1),NutrandKanten(j:j+1,2),NutrandKanten(j:j+1,3),'k'); %NutrandKanten darstellen
    end
    if Umfangsabtrag==1
        HelixZylU=Var.HelixZylU;
        plot3(HelixZylU(:,1),HelixZylU(:,2),HelixZylU(:,3),'r'); %Abgerollte Helix darstellen
    else %Umfangsabtrag==0
        AusgleichX=get(handles.checkbox5,'Value');
        if AusgleichX==1
            HelixZylX=Var.HelixZylX;
            plot3(HelixZylX(:,1),HelixZylX(:,2),HelixZylX(:,3),'r'); %Abgerollte Helix darstellen
        else %AusleichX==0
            HelixZylY=Var.HelixZylY;
            plot3(HelixZylY(:,1),HelixZylY(:,2),HelixZylY(:,3),'r'); %Abgerollte Helix darstellen
        end
    end
end
axis tight %DarstellungsFeld so nahe am 3d Objekt wie möglich

%Wird ausgeführt nach Benutzung von checkbox6 (Bahnhelix über Y-Koordinaten berechnen)
function checkbox6_Callback(hObject, eventdata, handles)
set(handles.checkbox5,'Value',0);
set(handles.checkbox6,'Value',1);
global Var
Umfangsabtrag=Var.Umfangsabtrag;

%Falls Checkbox2 (Original Geometrie) ausgewählt, Aufgerollte Helix darstellen
if get(handles.checkbox2,'Value')==1
    %Darstellung der original Geometrie
    cla
    FD3StlObjekt(Var.v1,0);
    hold on
    if Umfangsabtrag==1
        HelixKarU=Var.HelixKarU;
        plot3(HelixKarU(:,1),HelixKarU(:,2),HelixKarU(:,3),'r'); %Aufgerollte Helix darstellen
    else %Umfangsabtrag==0
        AusgleichX=get(handles.checkbox5,'Value');
        if AusgleichX==1
            HelixKarX=Var.HelixKarX;
            plot3(HelixKarX(:,1),HelixKarX(:,2),HelixKarX(:,3),'r'); %Aufgerollte Helix darstellen
        else %AusleichX==0
            HelixKarY=Var.HelixKarY;
            plot3(HelixKarY(:,1),HelixKarY(:,2),HelixKarY(:,3),'r'); %Aufgerollte Helix darstellen
        end
    end
end

%Falls Checkbox3 (Abgerollte Geometrie) ausgewählt, Abgerollte Helix darstellen
if get(handles.checkbox3,'Value')==1
    %Darstellen der abgerollten zusammenhängenden Geometrie
    cla
    FD3StlObjekt(Var.v3,1);
    hold on    
    %Darstellen der NutrandKanten und der DemoHelix
    NutrandKanten=Var.NutrandKanten;
    for j=1:2:size(NutrandKanten,1)
        plot3(NutrandKanten(j:j+1,1),NutrandKanten(j:j+1,2),NutrandKanten(j:j+1,3),'k'); %NutrandKanten darstellen
    end
    if Umfangsabtrag==1
        HelixZylU=Var.HelixZylU;
        plot3(HelixZylU(:,1),HelixZylU(:,2),HelixZylU(:,3),'r'); %Abgerollte Helix darstellen
    else %Umfangsabtrag==0
        AusgleichX=get(handles.checkbox5,'Value');
        if AusgleichX==1
            HelixZylX=Var.HelixZylX;
            plot3(HelixZylX(:,1),HelixZylX(:,2),HelixZylX(:,3),'r'); %Abgerollte Helix darstellen
        else %AusleichX==0
            HelixZylY=Var.HelixZylY;
            plot3(HelixZylY(:,1),HelixZylY(:,2),HelixZylY(:,3),'r'); %Abgerollte Helix darstellen
        end
    end
end
axis tight %DarstellungsFeld so nahe am 3d Objekt wie möglich

%Wird ausgeführt nach Benutzung von slider1
function slider1_Callback(hObject, eventdata, handles)
global Var
BahnPunkte=Var.BahnPunkte;
HelixZyl=Var.HelixZyl;
HelixKar=Var.HelixKar;
betas=Var.betas;
v1=Var.v1;
Nutgrund=Var.Nutgrund;
Konturs=Var.Konturs;
Deckels=Var.Deckels;
Hatches=Var.Hatches;
Rechtslaufend=Var.Rechtslaufend;
d=get(handles.slider1,'Value');
d=round(d);
set(handles.slider1,'Value',d);
%Aktualisierung edit 11
set(handles.edit11,'String',['Hatch: ',num2str(d),'  Bahnpunkt:  X',num2str(BahnPunkte(d,1),'%4.3f'),'  Y',num2str(BahnPunkte(d,2),'%4.3f'),'  Z',num2str(BahnPunkte(d,3),'%4.3f'),'  B',num2str(BahnPunkte(d,4),'%4.3f'),'  C',num2str(BahnPunkte(d,5),'%4.3f')]); 

cla
hold on
FDHatches(HelixZyl,HelixKar,betas,v1,Nutgrund,Konturs,Deckels,Hatches,Rechtslaufend,d);
axis tight %DarstellungsFeld so nahe am 3d Objekt wie möglich

function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

%Wird ausgeführt nach Benutzung von edit1
function edit1_Callback(hObject, eventdata, handles)
global Var
%Eingabe in edit1 wird ausgewertet
Bahnabstand=str2double(get(handles.edit1,'String'));
if Bahnabstand<0
    set(handles.edit1,'String',num2str(abs(Bahnabstand)));
    Var.Bahnabstand=abs(Bahnabstand);
elseif Bahnabstand==0
    warndlg('Der Bahnabstand muss grösser Null sein')
    set(handles.edit1,'String',num2str(Var.Bahnabstand));
elseif isnan(Bahnabstand)
    warndlg('Ungültige Eingabe')
    set(handles.edit1,'String',num2str(Var.Bahnabstand));
else
    Var.Bahnabstand=Bahnabstand;
end

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Wird ausgeführt nach Benutzung von edit2
function edit2_Callback(hObject, eventdata, handles)
global Var
%Eingabe in edit2 wird ausgewertet
OffsetStart=str2double(get(handles.edit2,'String'));
if OffsetStart<0
    set(handles.edit2,'String',num2str(abs(OffsetStart)));
    Var.OffsetStart=abs(OffsetStart);    
elseif isnan(OffsetStart)
    warndlg('Ungültige Eingabe')
    set(handles.edit2,'String',num2str(Var.OffsetStart));
else
    Var.OffsetStart=OffsetStart;
end

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Wird ausgeführt nach Benutzung von edit3
function edit3_Callback(hObject, eventdata, handles)
global Var
%Eingabe in edit3 wird ausgewertet
OffsetLength=str2double(get(handles.edit3,'String'));
if OffsetLength<0
    set(handles.edit3,'String',num2str(abs(OffsetLength)));
    Var.OffsetLength=abs(OffsetLength);
elseif OffsetLength==0
    warndlg('Die Konturoffsetabstände müssen grösser Null sein')
    set(handles.edit3,'String',num2str(Var.OffsetLength));
elseif isnan(OffsetLength)
    warndlg('Ungültige Eingabe')
    set(handles.edit3,'String',num2str(Var.OffsetLength));
else
    Var.OffsetLength=OffsetLength;
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
OffsetEnd=str2double(get(handles.edit4,'String'));
if OffsetEnd<0
    set(handles.edit4,'String',num2str(abs(OffsetEnd)));
    Var.OffsetEnd=abs(OffsetEnd);
elseif isnan(OffsetEnd)
    warndlg('Ungültige Eingabe')
    set(handles.edit4,'String',num2str(Var.OffsetEnd));
else
    Var.OffsetEnd=OffsetEnd;
end

% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Wird ausgeführt nach Benutzung von edit5
function edit5_Callback(hObject, eventdata, handles)
global Var
%Eingabe in edit5 wird ausgewertet
HatchVerlaengerung=str2double(get(handles.edit5,'String'));
if HatchVerlaengerung<0
    set(handles.edit5,'String',num2str(abs(HatchVerlaengerung)));
    Var.HatchVerlaengerung=abs(HatchVerlaengerung);
elseif isnan(HatchVerlaengerung)
    warndlg('Ungültige Eingabe')
    set(handles.edit5,'String',num2str(Var.HatchVerlaengerung));
else
    Var.HatchVerlaengerung=HatchVerlaengerung;
end

% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Wird ausgeführt nach Benutzung von edit6
function edit6_Callback(hObject, eventdata, handles)
global Var
%Eingabe in edit6 wird ausgewertet
MinimalLaenge=str2double(get(handles.edit6,'String'));
if MinimalLaenge<0
    set(handles.edit6,'String',num2str(abs(MinimalLaenge)));
    Var.MinimalLaenge=abs(MinimalLaenge);
elseif isnan(MinimalLaenge)
    warndlg('Ungültige Eingabe')
    set(handles.edit6,'String',num2str(Var.MinimalLaenge));
else
    Var.MinimalLaenge=MinimalLaenge;
end

% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Wird ausgeführt nach Benutzung von edit7
function edit7_Callback(hObject, eventdata, handles)
global Var
%Eingabe in edit7 wird ausgewertet
Zusammenfassen=str2double(get(handles.edit7,'String'));
if mod(Zusammenfassen,1)~=0
    set(handles.edit7,'String',num2str(round(Zusammenfassen)));
    Var.Zusammenfassen=round(Zusammenfassen);
elseif Zusammenfassen<0
    set(handles.edit7,'String',num2str(abs(Zusammenfassen)));
    Var.Zusammenfassen=abs(Zusammenfassen);
elseif Zusammenfassen==0
    warndlg('Wert muss grösser Null sein')
    set(handles.edit7,'String',num2str(Var.Zusammenfassen));
elseif isnan(Zusammenfassen)
    warndlg('Ungültige Eingabe')
    set(handles.edit7,'String',num2str(Var.Zusammenfassen));
else
    Var.Zusammenfassen=Zusammenfassen;
end

% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Wird ausgeführt nach Benutzung von edit8
function edit8_Callback(hObject, eventdata, handles)
global Var
%Eingabe in edit8 wird ausgewertet
Scangeschw=str2double(get(handles.edit8,'String'));
if Scangeschw<0
    set(handles.edit8,'String',num2str(abs(Scangeschw)));
    Var.Scangeschw=abs(Scangeschw);
elseif Scangeschw==0
    warndlg('Die Scangeschwindigkeit muss grösser Null sein')
    set(handles.edit8,'String',num2str(Var.Scangeschw));
elseif isnan(Scangeschw)
    warndlg('Ungültige Eingabe')
    set(handles.edit8,'String',num2str(Var.Scangeschw));
else
    Var.Scangeschw=Scangeschw;
end

% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Wird ausgeführt nach Benutzung von edit9
function edit9_Callback(hObject, eventdata, handles)
global Var
%Eingabe in edit9 wird ausgewertet
Jumpgeschw=str2double(get(handles.edit9,'String'));
if Jumpgeschw<0
    set(handles.edit9,'String',num2str(abs(Jumpgeschw)));
    Var.Jumpgeschw=abs(Jumpgeschw);
elseif Jumpgeschw==0
    warndlg('Die Jumpgeschwindigkeit muss grösser Null sein')
    set(handles.edit9,'String',num2str(Var.Jumpgeschw));
elseif isnan(Jumpgeschw)
    warndlg('Ungültige Eingabe')
    set(handles.edit9,'String',num2str(Var.Jumpgeschw));
else
    Var.Jumpgeschw=Jumpgeschw;
end

% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Wird ausgeführt nach Benutzung von edit10
function edit10_Callback(hObject, eventdata, handles)
global Var
%Eingabe in edit10 wird ausgewertet
VorschubCmax=str2double(get(handles.edit10,'String'));
if VorschubCmax<0
    set(handles.edit10,'String',num2str(abs(VorschubCmax)));
    Var.VorschubCmax=abs(VorschubCmax);
elseif VorschubCmax==0
    warndlg('Die Maximalgeschwindigkeit der Drehachse muss grösser Null sein')
    set(handles.edit10,'String',num2str(Var.VorschubCmax));
elseif isnan(VorschubCmax)
    warndlg('Ungültige Eingabe')
    set(handles.edit10,'String',num2str(Var.VorschubCmax));
else
    Var.VorschubCmax=VorschubCmax;
end

% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Wird ausgeführt nach Benutzung von edit11
function edit11_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
