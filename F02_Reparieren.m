function [v1,Defekt,Defekte] = F02_Reparieren(v1)
%Diese Funktion prüft die Stl-Datei, damit alle Dreiecke ein geschlossenes 
%Oberflächennetz bilden. Sie sucht Kanten die keine angrenzenden Nachbarkanten haben
%oder mehr als zwei angrenzende Nachbarkanten. Diese Defekte werden
%Versucht zu Reparieren. Falls keine angrenzende Nachbarkante exisitert
%wird die Kante als Nachbarkante definiert die sehr dicht anliegt und
%ebenfalls keine angrenzende Nachbarkante hat. Die Eckpunktkoordinaten 
%werden abgeglichen.

%NachbarEckpunkte suchen und in NE1 abspeichern
%disp('NachbarEckpunkte von v1 suchen und in NE1 abspeichern');
%tic
VS1=v1;
VS1(:,4)=1:size(v1,1); %EckpunktIndex in 4 Kolone speichern
VS1=sortrows(VS1,[1 2 3]); %Reihen nach x, y, und z sortieren
NE1=cell(size(VS1,1),1); %CellArray zur Speicherung angrenzender EckPunkte
VS1=[VS1;[NaN,NaN,NaN,NaN]]; %Schlusspunkt anhängen damit folge Schlaufe funktioniert
istart=1;
bar = waitbar(0,'Stl-Datei auf Defekte überprüfen'); %Ladebalken erstellen
iterationen=size(VS1,1);
for i=1:size(VS1,1)
    if ~(VS1(istart,1)==VS1(i,1)&&VS1(istart,2)==VS1(i,2)&&VS1(istart,3)==VS1(i,3)) %Folgepunkt nicht identisch
        if (i-istart)==1
            disp('Ein DreieckEckpunkt hat keinen NachbarDreieckEckpunkt')
            %scatter3(VS1(istart,1),VS1(istart,2),VS1(istart,3),50,'r'); DreieckPunkt ohne NachbarPunkte darstellen
        end
        a=VS1(istart:i-1,4);
        %Index der Nachbarpunkte bei allen Nachbarpunkten in NE1 speichern
        aInd=1;
        while (aInd<=size(a,1))
            NE1{a(aInd),1}=a; %NachbarIndexe speichern
            NE1{a(aInd),1}(a==a(aInd),:)=[]; %Eigeneintrag rauslöschen
            aInd=aInd+1;
        end
        istart=i;
    end
    if mod(i,round(iterationen/50))==0 %Ladebalken nicht bei jedem Schleifendurchlauf aktualisieren (Rechenleistung sparen)
        waitbar(i/iterationen) %Aktualisierung Ladebalken
    end
end
%toc

%NachbarKante suchen und in NK1 abspeichern
%disp('NachbarKanten von v1 suchen und in NK1 abspeichern');
%tic
NK1=zeros(size(v1,1),2); %Zur Speicherung der Nachbarskanten
nn=size(v1,1)/3;
NK1(1:3:3*nn,1)=1:nn;
NK1(2:3:3*nn+1,1)=1:nn;
NK1(3:3:3*nn+2,1)=1:nn;
Reparatur=zeros(1000,2);
ReparaturIndex=1;
Defekt=0;
Defekte=zeros(1000,7);
DefekteIndex=1;
iterationen=size(NK1,1);
for i=1:iterationen
    if NK1(i,2)==0 %NachbarKantenDreieck noch nicht gefunden
        if mod(i,3)==0 %Kante 3
            a=NE1{i,1}; %NachbarEckpunkte Eckpunkt1
            b=NE1{i-2,1}; %NachbarEckpunkte Eckpunkt2
            %Va=v1(i,1:3); %Koordinaten Eckpunkt1
            %Vb=v1(i-2,1:3); %Koordinaten Eckpunkt2
        else %Kante 1 oder Kante 2
            a=NE1{i,1}; %NachbarEckpunkte Eckpunkt1
            b=NE1{i+1,1}; %NachbarEckpunkte Eckpunkt2
            %Va=v1(i,1:3); %Koordinaten Eckpunkt1
            %Vb=v1(i+1,1:3); %Koordinaten Eckpunkt2
        end
        A=NK1(a,1); %Angrenzende KantenNummern
        B=NK1(b,1); %Angrenzende KantenNummern
        %d=intersect(A,B); %Identische KantenNummern raussuchen
        if ~isempty(A)&&~isempty(B)
            P=zeros(1,max(max(A),max(B)));
            P(A)=1;
            d=B(logical(P(B)));
        else
            d=[];
        end
        if isempty(d)
            %disp('Kein angrenzendes Nachbardreieck an Kante gefunden');
            if mod(i,3)==0 %Kante 3
                %Va=v1(i,1:3);
                %Vb=v1(i-2,1:3);
                Reparatur(ReparaturIndex,:)=[i,i-2];
                ReparaturIndex=ReparaturIndex+1;
            else %Kante 1 oder Kante 2
                %Va=v1(i,1:3);
                %Vb=v1(i+1,1:3);
                Reparatur(ReparaturIndex,:)=[i,i+1];
                ReparaturIndex=ReparaturIndex+1;
            end
            %plot3([Va(1),Vb(1)],[Va(2),Vb(2)],[Va(3),Vb(3)],'b') %Kante ohne angrenzende Nachbarkante darstellen
            %scatter3(Va(1),Va(2),Va(3),50,'b'); %KantenEckpunkt1 darstellen
            %scatter3(Vb(1),Vb(2),Vb(3),50,'b'); %KantenEckpunkt2 darstellen
        elseif size(d,1)>1
            disp('Stl-Datei hat Defekte. Mehr als zwei Dreiecksflächen stossen in gemeinsamer Kante aufeinander');
            Defekt=1;
            if mod(i,3)==0 %Kante 3
                Va=v1(i,1:3);
                Vb=v1(i-2,1:3);
            else %Kante 1 oder Kante 2
                Va=v1(i,1:3);
                Vb=v1(i+1,1:3);
            end
            %plot3([Va(1),Vb(1)],[Va(2),Vb(2)],[Va(3),Vb(3)],'b') %Kante mit mehreren angrenzenden Nachbarkante darstellen
            %scatter3(Va(1),Va(2),Va(3),20,'b','filled'); %KantenEckpunkt1 darstellen
            %scatter3(Vb(1),Vb(2),Vb(3),20,'b','filled'); %KantenEckpunkt2 darstellen
            Defekte(DefekteIndex,:)=[Va,Vb,1];
            DefekteIndex=DefekteIndex+1;
        else
            gg=b(B==d); %Gegenüberliegender NachbarKantenNummer
            NK1(i,2)=gg; %Gegenüberliegender NachbarKantenNummer abspeichern
            NK1(gg,2)=i; %Eigene Kantennummer in Gegeneüberliegder NachbarKantenNummer abspeichern
        end
    end
    if mod(i,round(iterationen/50))==0 %Ladebalken nicht bei jedem Schleifendurchlauf aktualisieren (Rechenleistung sparen)
        waitbar(i/iterationen) %Aktualisierung Ladebalken 
    end
end
%toc
%tic
Reparatur(ReparaturIndex:end,:)=[];
if ~isempty(Reparatur)
    %disp('Fehlende Nachbarkanten suchen');
    for m=1:size(Reparatur,1)/2
        Kante1=[v1(Reparatur(1,1),:),v1(Reparatur(1,2),:)];
        for i=2:size(Reparatur,1)
            Kante2=[v1(Reparatur(i,1),:),v1(Reparatur(i,2),:)];
            if (((Kante1(1)-Kante2(4))^2+(Kante1(2)-Kante2(5))^2+(Kante1(3)-Kante2(6))^2)^0.5<0.00003)&&...
                    (((Kante1(4)-Kante2(1))^2+(Kante1(5)-Kante2(2))^2+(Kante1(6)-Kante2(3))^2)^0.5<0.00003)
                disp('Gegenüberliegende Kante gefunden');
                %Koordinaten von Kante1 mit denen von gegenüberliegender Kante2 abgleichen
                v1(Reparatur(1,1),:)=Kante2(4:6);
                v1(NE1{Reparatur(1,1)},:)=ones(size(NE1{Reparatur(1,1)},1),1)*Kante2(4:6);
                v1(Reparatur(1,2),:)=Kante2(1:3);
                v1(NE1{Reparatur(1,2)},:)=ones(size(NE1{Reparatur(1,2)},1),1)*Kante2(1:3);
                NK1(Reparatur(1,1),2)=Reparatur(i,1);
                NK1(Reparatur(i,1),2)=Reparatur(1,1);
                Reparatur(i,:)=[];
                Reparatur(1,:)=[];
                break;
            end
            if i==size(Reparatur,1)
                disp('Stl-Datei hat Defekte. Keine gegenüberliegende Kante gefunden');
                Defekt=1;
                %plot3([Kante1(1),Kante1(4)],[Kante1(2),Kante1(5)],[Kante1(3),Kante1(6)],'r') %Kante ohne angrenzende Nachbarkante darstellen
                %scatter3(Kante1(1),Kante1(2),Kante1(3),20,'r','filled'); %KantenEckpunkt1 darstellen
                %scatter3(Kante1(4),Kante1(5),Kante1(6),20,'r','filled'); %KantenEckpunkt2 darstellen
                Reparatur(1,:)=[];
                Defekte(DefekteIndex,:)=[Kante1,2];
                DefekteIndex=DefekteIndex+1;
            end
        end
    end
else
    %disp('keine Defekte gefunden');
end
Defekte(DefekteIndex:end,:)=[];
close(bar) %Ladebalken schliessen
%toc

end