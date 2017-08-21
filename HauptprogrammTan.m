clc %Bereinigt das Command Window
clear all %Löscht alle Variabeln
close all %Vernichtet offene Grafikfenster
format long g %Mehr Nachkommastellen angezeigen

AusgleichX=0;       %Ausgleichsrechnung der Helix über X-Koordinaten (1) oder über Y-Koordinaten (0)
Bahnabstand=0.5;      %Abstand zwischen den BahnPunkte auf der Helix [mm] 
OffsetStart=0;        %Erste KonturoffsetDistanz [mm]
OffsetLength=0.05;     %KonturoffsetDistanz [mm]
OffsetEnd=0.1;          %Maximale KonturoffsetDistanz [mm]
HatchVerlaengerung=0.06;   %Verlängerung der Hatches über den Rand [mm]
MinimalLaenge=0.003; %Minimale Hatchsegmentlänge [mm]
Zusammenfassen=1000;    %Ab diesem Hatch werden die Hatches zusammengefasst
Scangeschw=100;     %Einstellen der Scangeschwindigkeit [mm/s]
Jumpgeschw=100;    %Einstellen der Jumpgeschwindigkeit [mm/s]
VorschubCmax=180;  %Maximale Drehzahl der Drehachse C [°/s]
Zickzack=1;        %Bei Zickzackmodus wird die Scanrichtung bei jedem zweiten Hatch umgedreht
NCCodeKomplett=1;  %NC-Code komplett ausschreiben (1), NC-Code mit MOVEABS Befehlen(0)
LaserOnOffalle=0;  %LaserOnOff bei jeder Hatchlinie (1), LaseronOff nur bei Hatchreihe und Ende (0)

%Einzelne CodeSchnipsel aus denen der NCCode zusammengestellt wird
NCText.Header1='G90';
NCText.Header2='G359';
NCText.Header3='GALVO LASERMODE u 1';
NCText.Header4='GALVO LASEROUTPUTPERIOD u 100';
NCText.Header5='GALVO LASER1PULSEWIDTH u 10';
NCText.Header6='GALVO SUPPRESSIONPULSEWIDTH u 20';
NCText.Header7='GALVO LASERONDELAY u -5';
NCText.Header8='GALVO LASEROFFDELAY u 58';
NCText.Header9='VELOCITY ON';
NCText.Header10='HOME C';
NCText.Header11='';
NCText.Header12='';
NCText.Laseron='';
NCText.Laseroff='';
NCText.Kommentar1='//';
NCText.Kommentar2='';
NCText.Finish1='G00 u0 v0';
NCText.Finish2='END PROGRAM';
NCText.Finish3='';
NCText.Finish4='';
NCText.Finish5='';
NCText.BahnPunktSta='G01';
NCText.BahnPunktEnd=' F60';
NCText.X=' X';
NCText.Y=' Y';
NCText.Z=' Z';
NCText.B=' B';
NCText.C=' C-';
NCText.u=' u';
NCText.v=' v';

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
NCText.Hatchjump1='G08 G01 u';
NCText.Hatchjump2=' v';
NCText.Hatchjump3=' F100';
NCText.Hatchscan1='G08 G01 u';
NCText.Hatchscan2=' v';
NCText.Hatchscan3=' F100';

[FileName,PathName] = uigetfile('*.stl','Auswahl des Stl-Objekts');
Pfad=[PathName,FileName];
Titel=[FileName(1:end-4),'NCCode','.txt'];
%Pfad='C:\Users\Johannes\Desktop\BASA Gysel\CAMK 23\Dingsbums.stl';

%Funktion, die die Stl-Datei einliest
[f1,v1,n1] = F00_stlread(Pfad); 
disp('Stl-Datei eingelesen');

%Darstellung des Stl-Objekts
figure %Darstellung des STL-Objekts in neuem Grafikfenster
hold on
FD3StlObjekt(v1,0);

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
    error('Stl-Datei hat Defekte. Mehr als zwei Dreiecksflächen stossen in gemeinsamer Kante aufeinander (blau). Keine gegenüberliegende Kante gefunden (rot)');
end

%Funktion die die Geometrie Abrollt
[v3,n3,NK3,Umfangsabtrag]=F04_Abrollen(v1,n1,f1);
disp('Abgerollte Geometrie berechnet');

%Darstellen der abgerollten zusammenhängenden Geometrie
figure
hold on
FD3StlObjekt(v3,1);

%Abgerollte geometrie als slt-Datei speichern (für Debugging von F04)
%fv.vertices=v3;
%nn=size(v3,1);
%fv.faces=[[1:3:nn]',[2:3:nn]',[3:3:nn]'];
%stlwrite('Abgerollt.stl',fv);

%Funktion, die die Helix berechnet
[Nutgrund,Rand3,Rand1,KeinRand,HelixZylU,HelixKarU,betasU,...
    HelixZylX,HelixKarX,betasX,HelixZylY,HelixKarY,betasY,...
    Rechtslaufend,NutrandKanten,n1]...
    =F07_Helix(v3,n3,n1,NK3,Umfangsabtrag,Bahnabstand);
disp('Helix wurde berechnet');

%Darstellen der NutrandKanten und der Helix
for j=1:2:size(NutrandKanten,1)
    plot3(NutrandKanten(j:j+1,1),NutrandKanten(j:j+1,2),NutrandKanten(j:j+1,3),'k'); %NutrandKanten darstellen
end

if Umfangsabtrag==1
    betas=betasU;
    HelixZyl=HelixZylU;
    HelixKar=HelixKarU;
    plot3(HelixZyl(:,1),HelixZyl(:,2),HelixZyl(:,3),'r'); %Abgerollte Helix darstellen
else %Umfangsabtrag==0
    plot3(HelixZylY(:,1),HelixZylY(:,2),HelixZylY(:,3),'r'); %Abgerollte Helix darstellen
    plot3(HelixZylX(:,1),HelixZylX(:,2),HelixZylX(:,3),'g'); %Abgerollte Helix darstellen
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

%Funktionen die den NC-Code berechnen und erstellen
[Hatches2,BahnPunkte2,Vorschub]=F53_NCCodeBerechnung(Hatches,BahnPunkte,...
    Umfangsabtrag,Zickzack,Zusammenfassen,Scangeschw,Jumpgeschw,VorschubCmax);
if NCCodeKomplett==1
    %NC-Code erstellen, Methode ausschreiben
    F54_NCCodeSynchron(Hatches2,BahnPunkte2,[Titel(1:end-4),'.txt'],NCText,Vorschub,Umfangsabtrag,LaserOnOffalle);
else %NCCodeKomplett==0
    %NC-Code erstellen, Methode Bahnachsen losschicken
    F55_NCCodeMOVEABS(Hatches2,BahnPunkte2,[Titel(1:end-4),'.txt'],NCText,Vorschub,Umfangsabtrag,LaserOnOffalle);
end
disp('NC-Code erstellt');
    

%%
%Darstellen einer Hatchberechnung
figure
hold on
ErsterHatch=find(~cellfun('isempty', Hatches2(:,1)),1,'first');
LetzterHatch=find(~cellfun('isempty', Hatches2(:,1)),1,'last');
d=round((ErsterHatch+LetzterHatch)/2);
FDHatches(HelixZyl,HelixKar,betas,v1,Nutgrund,Konturs,Deckels,Hatches,Rechtslaufend,d);
%}