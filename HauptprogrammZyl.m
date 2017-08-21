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

Schichtdicke=0.008; %Höhenabstand der Schichten in [mm]

Auswahlhoehen=0; %Auswahl der Bearbeitungshöhen (1=ja) (0=nein)
Auswahlhoeheoben=15; %Auswahlhöhe Oben
Auswahlhoeheunten=11.3338; %Auswahlhöhe Unten

Linienabstand=0.008; %Abstand zwischen den Laserbahnen[mm]
Scangeschw=4712; %Einstellen der Scangeschwindigkeit [mm/s]
VorschubAmax=36000; %Maximale Drehzahl der Drehachse A [°/s]
MinJumplengthY=0.2; %Minimale Länge der Jumplinie in Y-Richtung [mm]
Drehoffsetlength=0.1; %Minimale Länge zwischen den Schraffuren in Drehrichtung [mm]
SchraffurSkywritestart=1; %Skywritelänge zur Beschleunigung der Spiegel und Galvamotoren [mm]
SchraffurSkywriteend=1; %Skywritelänge zur Abbremsung der Spiegel und Galvamotoren [mm]
Modus=3; %Startwinkel (1=kleinsmöglicher Winkel) (2=freiwählbarer Winkel) (3=grösstmöglicher Winkel)
Verhaeltnis=0.7; %Verhältnis zwischen Markierlinie zu Jumplinie bei Startwinkelberechnung nach Modus 1
Schraffurwinkelstart=-85; %Richtungswinkel der ersten Schraffur [Grad]
Schraffurwinkelinkrem=0; %Richtungswinkel der darauf folgenden Schraffuren [Grad]
WinkelAnpassung=0; %Winkel anpassen damit maximale Drehzahl und Scangeschwindigkeit nicht überschritten und kleinstmöchlier Winkel nicht unterschritten wird (1=ja) (0=nein)
OnDelayLength=Scangeschw*0.000015; %Verschiebung der Startpunkte [mm] (l_on = v_s*t_on)
OffDelayLength=Scangeschw*0.000015; %Verschiebung der Startpunkte [mm] (l_off = v_s*t_off)
MinimalLaenge=0.1; %Minimale Hatchsegmentlänge [mm]
%MinimalLaenge=Scangeschw*(0.000015-0.000015); %Minimale Hatchsegmentlänge [mm]
AxialRichtung=3;    %(Von links nach rechts=1 ,von rechts nach links=2, alternieren=3)

DStlObjekt1=1; %Soll das zylindrische Stl-Objekt Dargestellt werden? (1=ja) (0=nein)
DStlObjekt2=1; %Soll das kartesische Stl-Objekt Dargestellt werden? (1=ja) (0=nein)
DKontur=1; %Soll die Schnittkontur Dargestellt werden? (1=ja) (0=nein)
DSchraffur=1; %Soll die Laserbahn der Schraffur Dargestellt werden? (1=ja) (0=nein)
d=1; %Ebene die Dargestellt werden soll

[FileName,PathName] = uigetfile('*.stl','Auswahl des Stl-Objekts');
Pfad=[PathName,FileName];
%Pfad='ETHZylinder2mmNegativ.stl';
Titel=[FileName(1:end-4),'NCCode','.txt'];
%Titel='ETHZylinderNCcode.txt';

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
NCText.Finish1='END PROGRAM';
NCText.Finish2='';
NCText.Finish3='';
NCText.Finish4='';
NCText.Finish5='';

%Funktion, die die Stl-Datei einliest
[f,v,n] = F00_stlread(Pfad); 
disp('Stl-Objekt eingelesen');

%Darstellung des original Stl-Objekts
RadiusMax=max((v(:,2).^2+v(:,3).^2).^0.5);
v1=v;
v1(:,2)=v1(:,2)*-(360/(2*pi*RadiusMax)); %Anpassung der orignal Stldatei an die Skalierung in Grad der Y-Richtung
fv1.vertices=v1; %v enthält die Koordinaten der Eckpunkte
fv1.faces=f; %f sagt, welche drei Eckpunkte aus v ein Dreieck bilden
FD2StlObjekt(DStlObjekt1,fv1,[0.2 0.2 0.8],RadiusMax);
view([45 45]); %Set a nice view angle

%Funktion, die die Stl-Datei von Kartesisch- in Zylinderkoordinaten umwandelt
[f2,v2] = F03_Transformation(f,v);
disp('Transformation durchgeführt');

%Abgerollte geometrie als slt-Datei speichern (für Debugging von F03)
%stlwrite('Abgerollt.stl',f2,v2);

%Darstellung des Stl-Objekts nach der Koordinatentrasformation
fv2.vertices=v2; %v enthält die Koordinaten der Eckpunkte
fv2.faces=f2; %f sagt, welche drei Eckpunkte aus v ein Dreieck bilden
FD2StlObjekt(DStlObjekt2,fv2,[0.2 0.8 0.8],RadiusMax);
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
[Schraffuren,VorschubDominant,Winkel]=F41_Schraffuren( Konturen,Linienabstand,SchraffurSkywritestart,SchraffurSkywriteend,Schraffurwinkelstart,Schraffurwinkelinkrem,Verhaeltnis,Scangeschw,VorschubAmax,Drehoffsetlength,Modus,MinJumplengthY,WinkelAnpassung,MinimalLaenge,OnDelayLength,OffDelayLength,AxialRichtung); 
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
%F51_NCCode(Schraffuren,Titel,NCText,VorschubDominant);
%disp('NC-Code erstellt');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PSO Ramsch %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Schraffurwinkel und Beschleunigungswinkel
%BeschlWinkel=1000*360;
BeschlWinkelSta=round((VorschubDominant(1)^2/(2*600))/360)*360;
BeschlWinkelEnd=round((VorschubDominant(end)^2/(2*600))/360)*360;
ZwischenUmdrehungen=0;
for k=1:size(Schraffuren,1)
    if ~isempty(Schraffuren{k,1})
        Schraffuren{k,1}(:,2)=Schraffuren{k,1}(:,2)+BeschlWinkelSta+ZwischenUmdrehungen;
        ZwischenUmdrehungen=ZwischenUmdrehungen+10*360;
    end
end
EndWinkel=Schraffuren{end,1}(end,2)+BeschlWinkelEnd;

%Umrechnung der Schraffurwinkel in Ticks
PSOArray=cell(size(Schraffuren));
PSOEntry=zeros(size(PSOArray));
for k=1:size(Schraffuren,1)
    if ~isempty(Schraffuren{k,1})
        PSOArray{k,1}=round(Schraffuren{k,1}(2:end-1,2)*(100000/360));
        PSOEntry(k,1)=size(PSOArray{k,1},1);
        if ceil(PSOArray{k,1}(1,1)/2^31)<ceil(PSOArray{k,1}(end,1)/2^31)
            disp(['Ebene: ',int2str(k),' wird wegen Aerotechproblemen gelöscht']);
            PSOArray{k,1}=[];
            PSOEntry(k,1)=0;
        end
    end
end
AnzahlPSOEntry=sum(PSOEntry);

%NC-Code erstellung für PSO
fid = fopen(Titel, 'W'); %Ein neues txt-file wird geöffnet 
fprintf(fid,['//Array Stuff','\r\n']);
fprintf(fid,['DVAR $AW[',int2str(AnzahlPSOEntry),']','\r\n']);
%PSOArray in file ausschreiben
PSOArrayString=['$AW[','%1.0f',']=','%1.0f','\r\n'];
PSOArrayIndex=0;
for k=1:size(PSOArray,1)
    if ~isempty(PSOArray{k,1})
        for h=1:size(PSOArray{k,1},1)
            fprintf(fid,PSOArrayString,[PSOArrayIndex,PSOArray{k,1}(h,1)]);
            PSOArrayIndex=PSOArrayIndex+1;
        end
    end
end
fprintf(fid,['ARRAY A WRITE $AW[0] 0 ',int2str(AnzahlPSOEntry),'\r\n']);
fprintf(fid,['\r\n']);

fprintf(fid,['//Startposition','\r\n']);
fprintf(fid,['G90','\r\n']);
fprintf(fid,['G359','\r\n']);
fprintf(fid,['VELOCITY ON','\r\n']);
fprintf(fid,['POSOFFSET CLEAR X Y Z','\r\n']);
fprintf(fid,['G01 Z(-17.2) X(61.6) Y(-21.715) F10','\r\n']);
fprintf(fid,['POSOFFSET SET X0 Y0 Z0','\r\n']);
fprintf(fid,['HOME A','\r\n']);
fprintf(fid,['\r\n']);

fprintf(fid,['//PSO Start','\r\n']);
fprintf(fid,['PSOCONTROL A RESET','\r\n']);
fprintf(fid,['PSOOUTPUT A CONTROL 0 1','\r\n']);
fprintf(fid,['PSOWINDOW A 1 INPUT 2','\r\n']);
fprintf(fid,['PSOWINDOW A 1 RANGE ARRAY 0 ',int2str(AnzahlPSOEntry),'\r\n']);
fprintf(fid,['PSOOUTPUT A WINDOW','\r\n']);
fprintf(fid,['PSOCONTROL A ARM','\r\n']);
fprintf(fid,['\r\n']);

%CodeZeilen um die Bearbeitungshöhe anzusteuern wird zusammengesetzt
FokusString=[NCText.Fokus1,'%4.4f',NCText.Fokus2,'%4.4f',NCText.Fokus3,'%4.4f',NCText.Fokus4,'\r\n'];
%CodeZeilen um den Vorschub der Dominanten Achse anzugeben wird zusammengesetzt
VorschubString=[NCText.Vorschub1,'%4.4f',NCText.Vorschub2,'\r\n'];
%CodeZeilen für eine Laserbearbeitungslinie wird zusammengesetzt
LaserString=[NCText.Laser1,'%4.4f',NCText.Laser2,'%4.4f',NCText.Laser3,'\r\n']; 
%CodeZeilen für die Auskommentierung wird zusammengesetzt
KommentarString1=[NCText.Kommentar1,'################### Ebene %1.0f ####################',NCText.Kommentar2,'\r\n'];

bar = waitbar(0,'NC-Code wird berechnet...'); %Ladebalken erstellen
fprintf(fid,['//NC-Code','\r\n']);
for k=1:size(Schraffuren,1)
    if ~isempty(Schraffuren{k,1})
        %Kommentar mit Ebenenbenennung
        fprintf(fid,KommentarString1,k);
        %CodeZeile zum Einstellen des Vorschubs der Dominanten Drehachse
        fprintf(fid,VorschubString,VorschubDominant(k));
        %Mit der Z-Achse den Fokus einstellen
        SchnittHoehe=Schraffuren{k}(1,3);
        Korrekturwert=abs(SchnittHoehe); %Bei zylindrischer Bearbeitung
        %Erster Punkt der Schraffur wird angefahren inklusive Fokuseinstellung
        fprintf(fid,FokusString,[Schraffuren{k}(1,1:2),Korrekturwert]); 
        %Letzer Punkt der Schraffur wird angefahren 
        fprintf(fid,LaserString,Schraffuren{k}(end,1:2)); 
    end
    waitbar(k/size(Schraffuren,1)) %Aktualisierung Ladebalken
end
%Entschleunigung
%Letzer Punkt der Schraffur wird angefahren 
fprintf(fid,LaserString,[Schraffuren{end,1}(end,1),EndWinkel]); 
close(bar) %Ladebalken schliessen
fprintf(fid,['\r\n']);

fprintf(fid,['//PSO Ende','\r\n']);
fprintf(fid,['PSOWINDOW A 1 OFF','\r\n']);
fprintf(fid,['PSOCONTROL A OFF','\r\n']);
fprintf(fid,['END PROGRAM','\r\n']);

fclose(fid); %txt-file wird geschlossen
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PSO Ramsch Ende %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Darstellung einer neuen Ebene
cla
d=1; %Ebene die dargestellt werden soll
%FD2StlObjekt(DStlObjekt1,fv1,[0.2 0.2 0.8],RadiusMax); %Erstellt ein neues Fenster...
FD2StlObjekt(DStlObjekt2,fv2,[0.2 0.8 0.8],RadiusMax);
camlight(0,0); %Lichtquelle hinzufügen
FD2Schnittkontur(DKontur,d,Konturen,RadiusMax);
FD2Schraffur(DSchraffur,d,Schraffuren,RadiusMax);
%}