%Dieses Skript führt die gesammte CAM Bahnberechnung durch 
%!!! für Zylindrische Werkstücke !!! 
%Für jeden Bearbeitungsschritt wird die entsprechende Teilfunktion aufgerufen
%Die Teilfunktione beginnen mit dem Buchsstaben F
%Für die Entwicklung von neuem Programmcode, empfielt sich zuerst nur mit diesem
%Skript ohne Benutzeroberfläche zu arbeiten, weil es übersichtlicher ist.
%In einem zweiten Schritt, kann dann der Programmcode in die
%Benutzeroberfläche integriert werden
%Das Skript zur Benutzeroberfläche lautet LaserCAM.m

clc %Bereinigt das Command Window
clear all %Löscht alle Variabeln
close all %Vernichtet offene Grafikfenster
format long g %Nicht wissenschaftliche Schreibweise

Schichtdicke=0.1; %Höhenabstand der Schichten in [mm]

Auswahlhoehen=0; %Auswahl der Bearbeitungshöhen (1=ja) (0=nein)
Auswahlhoeheoben=5; %Auswahlhöhe Oben
Auswahlhoeheunten=4.9; %Auswahlhöhe Unten

Linienabstand=0.5; %Abstand zwischen den Laserbahnen[mm]
Scangeschw=500; %Einstellen der Scangeschwindigkeit [mm/s]
VorschubAmax=36000; %Maximale Drehzahl der Drehachse A [°/s]
MinJumplengthY=0.2; %Minimale Länge der Jumplinie in Y-Richtung [mm]
DrehoffsetStart=20; %Startdrehwinkel zur ersten Schraffuren [°]
Drehoffset=10; %Drehwinkel zwischen den Schraffuren [°]
SchraffurSkywritestart=1; %Skywritelänge zur Beschleunigung der Spiegel und Galvamotoren [mm]
SchraffurSkywriteend=1; %Skywritelänge zur Abbremsung der Spiegel und Galvamotoren [mm]
Modus=1; %Startwinkel (1=kleinsmöglicher Winkel) (2=freiwählbarer Winkel) (3=grösstmöglicher Winkel)
Verhaeltnis=0.6; %Verhältnis zwischen Markierlinie zu Jumplinie bei Startwinkelberechnung nach Modus 1
Schraffurwinkelstart=5; %Richtungswinkel der ersten Schraffur [Grad]
Schraffurwinkelinkrem=0; %Richtungswinkel der darauf folgenden Schraffuren [Grad]
WinkelAnpassung=0; %Winkel anpassen damit maximale Drehzahl und Scangeschwindigkeit nicht überschritten und kleinstmöchlier Winkel nicht unterschritten wird (1=ja) (0=nein)
OnDelayLength=Scangeschw*0.000015; %Verschiebung der Startpunkte [mm] (l_on = v_s*t_on)
OffDelayLength=Scangeschw*0.000015; %Verschiebung der Startpunkte [mm] (l_off = v_s*t_off)
MinimalLaenge=0.1; %Minimale Hatchsegmentlänge [mm]
AxialRichtung=3;    %(Von links nach rechts=1 ,von rechts nach links=2, alternieren=3)

DStlObjekt1=1; %Soll das zylindrische Stl-Objekt Dargestellt werden? (1=ja) (0=nein)
DStlObjekt2=1; %Soll das kartesische Stl-Objekt Dargestellt werden? (1=ja) (0=nein)
DKontur=1; %Soll die Schnittkontur Dargestellt werden? (1=ja) (0=nein)
DSchraffur=1; %Soll die Laserbahn der Schraffur Dargestellt werden? (1=ja) (0=nein)
d=1; %Ebene die Dargestellt werden soll

%Einzelne CodeSchnipsel aus denen der NCCode zusammengestellt wird
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
NCText.Finish1='FREERUN A STOP';
NCText.Finish2='END PROGRAM';
NCText.Finish3='';
NCText.Finish4='';
NCText.Finish5='';
NCText.EbeneSta1='';
NCText.EbeneSta2='';
NCText.EbeneEnd1='';
NCText.EbeneEnd2='';

%Dialogfenster zum einlesen der Stl-Datei
[FileName,PathName] = uigetfile('*.stl','Auswahl des Stl-Objekts');
Pfad=[PathName,FileName];
Titel=[FileName(1:end-4),'NCCode','.txt'];

%Funktion, die die Stl-Datei einliest
[f,v,n] = F00_stlread(Pfad); 
disp('Stl-Objekt eingelesen');

%Darstellung des original Stl-Objekts
RadiusMax=max((v(:,2).^2+v(:,3).^2).^0.5);
v1=v;
v1(:,2)=v1(:,2)*-(360/(2*pi*RadiusMax)); %Anpassung der orignal Stldatei an die Skalierung in Grad der Y-Richtung
fv1.vertices=v1; %v enthält die Koordinaten der Eckpunkte
fv1.faces=f; %f sagt, welche drei Eckpunkte aus v ein Dreieck bilden
FD2StlObjekt(DStlObjekt1,fv1,[0.3 0.3 0.3],RadiusMax);
view([45 45]); %Set a nice view angle

%Funktion, die die Stl-Datei von Kartesisch- in Zylinderkoordinaten umwandelt
[f2,v2] = F03_Transformation(f,v);
disp('Transformation durchgeführt');

%Darstellung des Stl-Objekts nach der Koordinatentrasformation
fv2.vertices=v2; %v enthält die Koordinaten der Eckpunkte
fv2.faces=f2; %f sagt, welche drei Eckpunkte aus v ein Dreieck bilden
FD2StlObjekt(DStlObjekt2,fv2,[0.8 0.8 0.8],RadiusMax);
camlight(0,0); %Lichtquelle hinzufügen

%Funktion, die die Schnitthoehen berechnet wird aufgerufen
[Schnitthoehen,Zoben,Zunten]=F05_Schnitthoehen(v2,Schichtdicke,Auswahlhoehen,Auswahlhoeheoben,Auswahlhoeheunten);
Zoben 
Zunten
Schnitthoehen
AnzahlSchnittebenen=size(Schnitthoehen,1)

%Funktion, die die Slices macht wird aufgerufen
[Konturen]=F11_Slicing( f2,v2,Schnitthoehen,Schichtdicke );
disp('Slices berechnet');

%Die Schichten werden absteigend sortiert
Konturen=flipud(Konturen); %Oberste Schnittebene ist nun im obersten CellArray Eintrag

%Darstellung der Schnittkonturen 
FD2Schnittkontur(DKontur,d,Konturen,RadiusMax);

%Funktion, die die Schraffuren berechnet
[Schraffuren,VorschubDominant,Winkel]=F41_Schraffuren( Konturen,Linienabstand,SchraffurSkywritestart,SchraffurSkywriteend,Schraffurwinkelstart,Schraffurwinkelinkrem,Verhaeltnis,Scangeschw,VorschubAmax,Drehoffset,DrehoffsetStart,Modus,MinJumplengthY,WinkelAnpassung,MinimalLaenge,OnDelayLength,OffDelayLength,AxialRichtung); 
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
disp(['Geschätze Bearbeitungszeit: ',num2str(round(Bearbeitungszeit/60)),'min ',num2str(mod(Bearbeitungszeit,60),'%4.1f'),'s']);

%Darstellung der Schraffuren
FD2Schraffur(DSchraffur,d,Schraffuren,RadiusMax);

%Funktion, die den NC-Code erstellt
F51_NCCode(Schraffuren,Titel,NCText,VorschubDominant);
disp('NC-Code erstellt');

%% Darstellung einer neuen Ebene 
%{
cla
d=1; %Ebene die dargestellt werden soll
%FD2StlObjekt(DStlObjekt1,fv1,[0.3 0.3 0.3],RadiusMax); %Erstellt ein neues Fenster...
FD2StlObjekt(DStlObjekt2,fv2,[0.8 0.8 0.8],RadiusMax);
camlight(0,0); %Lichtquelle hinzufügen
FD2Schnittkontur(DKontur,d,Konturen,RadiusMax);
FD2Schraffur(DSchraffur,d,Schraffuren,RadiusMax);
%}
