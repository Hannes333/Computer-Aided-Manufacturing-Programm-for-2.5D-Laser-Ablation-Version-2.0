function [ Konturen ] = F11_Slicing(f,v,Schnitthoehen,Schichtdicke)
%F11_Slicing berechnet aus der Stl-Datei die Schnitkonturen auf den
%entsprechenden Schnitthoehen.
%Imput Array v, enthält die Koordinaten der Eckpunkt der Dreiecke, aus
%denen das Stl-Objekt aufgebaut ist.
%imput Array f, enthält die Informationen, welche drei Eckpunkte vom Array
%v zu einem Dreieck verbunden werden müssen.
%Imput Vektor Schnitthoehen enthält jene Höhen auf denen ein Schnitt
%berechnet werden soll
%Output ist das Cell Array Konturen. In diesem Cell
%Array enthält jede Zeile die geschlossenen Konturen einer Schnittebene.
%Jedes einzelnes Array vom Cell Array Konturen hat vier Spalten.
%In den ersten drei Spalten sind die x-, y- und z-Koordinaten der einzelnen
%Eckpunkte der geschlossenen Kontur. Werden diese Zeile für Zeile
%miteinander verbunden, entsteht eine Kontur. 
%In der vierten Spalte jedes Arrays, ist die Dreiecksnummer der
%Stl-Datei gespeichert aus dem der Eckpunkt auf dieser Zeile entstanden
%ist.

n=size(f,1); %Anzahl Dreiecke
Z=length(Schnitthoehen); %Anzahl Schnittebenen

%Schritt 0: Arraygrösse Abschätzen
AnzahlSectPts=0;
for i=1:n %Index, der durch die Dreiecke iteriert
    minz=min(v(f(i,:),3));
    maxz=max(v(f(i,:),3));
    AnzahlSectPts=AnzahlSectPts+2+2*fix((maxz-minz)/Schichtdicke);
end
SectPts=zeros(AnzahlSectPts,4); %Array zur Speicherung der Schnittpunkte wird erstellt

%Schritt 1: Alle Schnittpunkte werden berechnet
%disp('Schritt1');
%tic
counter=1; %Index der durch die Zeilen vom SectPts Array geht
bar = waitbar(0,'Schnittkonturen werden berechnet...'); %Ladebalken erstellen
for i=1:n %Index, der durch die Dreiecke iteriert
    vs=[v(f(i,1),:);v(f(i,2),:);v(f(i,3),:)]; %aktuelles Dreieck wir in vs zwischengespeichert
    [~,ind]=sort(vs(:,3),'descend');
    vs=vs(ind,:); %die drei Eckpunktkoordinaten sind nun absteigend nach den Z einträgen sortiert 
    if (vs(1,3)>vs(2,3))&&(vs(2,3)>vs(3,3)) %Normalfall
        Schnitthoehen1=Schnitthoehen((Schnitthoehen<vs(1,3))&(Schnitthoehen>=vs(2,3))); %Aus Schnitthoehen werden jene höhen die zwischen Punkt 1 und 2 sind in vektor Schnitthoehen1 geschrieben
        if ~isempty(Schnitthoehen1)
            p1=ones(size(Schnitthoehen1))*vs(2,:)+(ones(size(Schnitthoehen1))*(vs(1,:)-vs(2,:))).*...
            ((Schnitthoehen1-vs(2,3))/(vs(1,3)-vs(2,3))*ones(1,3)); %Schnittpunkte der Kante werden berechnet
            p1(:,3)=Schnitthoehen1; %Z-Koordinaten auf Schnitthöhen trimmen
        else
            p1=[];
        end
        Schnitthoehen2=Schnitthoehen((Schnitthoehen<vs(2,3))&(Schnitthoehen>vs(3,3)));
        if ~isempty(Schnitthoehen2)
            p2=ones(size(Schnitthoehen2))*vs(3,:)+(ones(size(Schnitthoehen2))*(vs(2,:)-vs(3,:))).*...
            ((Schnitthoehen2-vs(3,3))/(vs(2,3)-vs(3,3))*ones(1,3)); %Schnittpunkte der Kante werden berechnet
            p2(:,3)=Schnitthoehen2; %Z-Koordinaten auf Schnitthöhen trimmen
        else
            p2=[];
        end
        Schnitthoehen3=vertcat(Schnitthoehen2,Schnitthoehen1);
        if ~isempty(Schnitthoehen3)
            p3=ones(size(Schnitthoehen3))*vs(3,:)+(ones(size(Schnitthoehen3))*(vs(1,:)-vs(3,:))).*...
            ((Schnitthoehen3-vs(3,3))/(vs(1,3)-vs(3,3))*ones(1,3)); %Schnittpunkte der Kante werden berechnet
            p3(:,3)=Schnitthoehen3; %Z-Koordinaten auf Schnitthöhen trimmen
            count=2*length(Schnitthoehen3); %number of intersection points
            if (counter-1+count)>size(SectPts,1) %Hat es noch genug platz in SectPts?
                warning('Speicher in SectPts muss aloziert werden(langsam)');
                SectPts=[SectPts;zeros(counter-1+count-size(SectPts,1),4)]; %SectPts wird erweitert   
            end
            SectPts(counter:counter-1+count,1:3)=[p1;p2;p3]; %Schnittpunkte werden gespeichert
            SectPts(counter:counter-1+count,4)=i*ones(count,1); %Dreiecksnummer wird gespeichert
            counter=counter+count;
        end
    elseif(vs(1,3)>vs(2,3))&&(vs(2,3)==vs(3,3)) %Spezialfall B
        Schnitthoehen1=Schnitthoehen((Schnitthoehen<vs(1,3))&(Schnitthoehen>=vs(2,3)));
        if ~isempty(Schnitthoehen1)
            p1=ones(size(Schnitthoehen1))*vs(2,:)+(ones(size(Schnitthoehen1))*(vs(1,:)-vs(2,:))).*...
            ((Schnitthoehen1-vs(2,3))/(vs(1,3)-vs(2,3))*ones(1,3)); %Schnittpunkte der Kante werden berechnet
            p1(:,3)=Schnitthoehen1; %Z-Koordinaten auf Schnitthöhen trimmen
        else
            p1=[];
        end
        if ~isempty(Schnitthoehen1)
            
            p11=ones(size(Schnitthoehen1))*vs(3,:)+(ones(size(Schnitthoehen1))*(vs(1,:)-vs(3,:))).*...
            ((Schnitthoehen1-vs(3,3))/(vs(1,3)-vs(3,3))*ones(1,3)); %Schnittpunkte der Kante werden berechnet
            p11(:,3)=Schnitthoehen1; %Z-Koordinaten auf Schnitthöhen trimmen
        else
            p11=[];
        end
        count=2*length(Schnitthoehen1); %Anzahl Schnittpunkte
        if (counter-1+count)>size(SectPts,1) %Hat es noch genug platz in SectPts?
            warning('Speicher in SectPts muss aloziert werden(langsam)');
            SectPts=[SectPts;zeros(counter-1+count-size(SectPts,1),4)]; %SectPts wird erweitert   
        end
        SectPts(counter:counter-1+count,1:3)=[p1;p11]; %Schnittpunkte werden gespeichert
        SectPts(counter:counter-1+count,4)=i*ones(count,1); %Dreiecksnummer wird gespeichert
        counter=counter+count;
    elseif(vs(2,3)>vs(3,3))&&(vs(1,3)==vs(2,3)) %Spezialfall A
        Schnitthoehen1=Schnitthoehen((Schnitthoehen<=vs(1,3))&(Schnitthoehen>vs(3,3)));
        if ~isempty(Schnitthoehen1)
            p1=ones(size(Schnitthoehen1))*vs(3,:)+(ones(size(Schnitthoehen1))*(vs(1,:)-vs(3,:))).*...
            ((Schnitthoehen1-vs(3,3))/(vs(1,3)-vs(3,3))*ones(1,3)); %Schnittpunkte der Kante werden berechnet
            p1(:,3)=Schnitthoehen1; %Z-Koordinaten auf Schnitthöhen trimmen
        else
            p1=[];
        end
        if ~isempty(Schnitthoehen1)
            p11=ones(size(Schnitthoehen1))*vs(3,:)+(ones(size(Schnitthoehen1))*(vs(2,:)-vs(3,:))).*...
            ((Schnitthoehen1-vs(3,3))/(vs(2,3)-vs(3,3))*ones(1,3)); %Schnittpunkte der Kante werden berechnet
            p11(:,3)=Schnitthoehen1; %Z-Koordinaten auf Schnitthöhen trimmen
        else
            p11=[];
        end
        count=2*length(Schnitthoehen1); %Anzahl Schnittpunkte
        if (counter-1+count)>size(SectPts,1) %Hat es noch genug platz in SectPts?
            warning('Speicher in SectPts muss aloziert werden(langsam)');
            SectPts=[SectPts;zeros(counter-1+count-size(SectPts,1),4)]; %SectPts wird erweitert    
        end
        SectPts(counter:counter-1+count,1:3)=[p1;p11]; %Schnittpunkte werden gespeichert
        SectPts(counter:counter-1+count,4)=i*ones(count,1); %Dreiecksnummer wird gespeichert
        counter=counter+count;
    elseif ~isempty(find(vs(1,3)==Schnitthoehen,1)) %Speziallfall C
        %warning('Ein Dreieck liegt genau in einer Ebene.')
    end
    if mod(i,round(n/50))==0 %Ladebalken nicht bei jedem Schleifendurchlauf aktualisieren (Rechenleistung sparen)
        waitbar((i/n)/2) %Aktualisierung Ladebalken
    end
end
SectPts(counter+1:end,:)=[]; %Leere Einträge entfernen
SectPts(counter,1:3)=[inf,inf,inf]; %SchlussPunkt wird angehängt damit Forschleife in Schritt 3a ein Schlusspunkt hat
%toc
%Schritt1=SectPts;


%Schritt 2: Sortiere das Array SectPts absteigenden nach z-Koordinaten
%disp('Schritt2');
%tic
[~,ind]=sort(SectPts(:,3));
SectPts=SectPts(ind,:);
%toc
%Schritt2=SectPts;


%Schritt 3: In diesem Schritt wird SectPts ins CellArray PlaneCurves geschrieben
%disp('Schritt3');
%tic
PlaneCurves=cell(Z,1); %to store the points for each cutting Plane in a cell
staIndex=1;
staWert=SectPts(staIndex,3);
%PlaneCurvesIndex=1;
for endIndex=1:size(SectPts,1)
    if SectPts(endIndex,3)~=staWert
        PlaneCurvesIndex=(Schnitthoehen==staWert);
        PlaneCurves{PlaneCurvesIndex,1}=SectPts(staIndex:endIndex-1,:);
        %PlaneCurvesIndex=PlaneCurvesIndex+1;
        staIndex=endIndex;
        staWert=SectPts(staIndex,3);
    end
end
%toc
%Schritt3=PlaneCurves;


% Schritt 4: Berechne aus den Schnittpunkten die geschlossenen Schnittkonturen 
%disp('Schritt4');
%tic
Konturen=cell(Z,1);
for k=1:Z %Iteriert durch Anzahl Schnittebenen
    i=1; %Iteriert durch Konturen auf dieser Schnittebene
    %Reparatur=[]; %Array zur Speicherung der Start- und Endpunkte ungeschlossener Konturnsegmente
    while ~isempty(PlaneCurves{k,1}) 
        punktindex=0; %Index des Aktuellen Punktes dessen FolgePunkt oder FolgeGerade gesucht wird
        indexliste=zeros(size(PlaneCurves{k,1},1),1); %indexliste enthält die sortierten Indexe für eine geschlossene Kontur
        counter=1; %Index zur schrittweisen Einordnung der Punktindex in der indexliste
        jumpstyle=0; %jumpstyle==1 FolgePunkt suchen, jumpstyle==0 FolgeGerade suchen
        ungeschlossen=0; %Variable zum Finden ungeschlossener Kontursegmente
        while punktindex~=1 %Schlaufe wiederholen bis Punktindex wieder beim ersten Punkt, dann geschlossene Kontur gefunden
            if punktindex==0
                punktindex=1; %Punktindex wird auf ersten Eintrag gesetzt
            end
            indexliste(counter)=punktindex; %aktueller Punktindex wird in indexliste gespeichert
            counter=counter+1;
            if jumpstyle==0  %FolgeGerade wird gesucht  (nach Eintrag 4)
                x=PlaneCurves{k,1}(punktindex,4)==PlaneCurves{k,1}(:,4); %Einträge der FolgeGerade suchen die identisch zu Punktindex sind
                x(punktindex)=0; %Aktueller Punktindex in x wird auf 0 gesetzt
                punktindex=find(x); %Index des Folgepunktes gefunden
                if length(punktindex)>1
                    warning(['Mehr als zwei Dreiecke teilen einen Eckpunkt in Schnittebene ',int2str(k),'. Die resultierende Kontur mag falsch sein.'])
                    tmp=0;
                    for kkk=1:length(punktindex)
                        if ~(indexliste==punktindex(kkk))
                            tmp=punktindex(kkk);
                        end
                    end
                    punktindex=tmp;
                end
                jumpstyle=1;
            else %(jumpstyle==1) %FolgePunkt wird gesucht (nach Einträge 1,2)
                x=(PlaneCurves{k,1}(punktindex,1)==PlaneCurves{k,1}(:,1))&... %Einträge der FolgePunkte suchen die identisch zu Punktindex sind
                   (PlaneCurves{k,1}(punktindex,2)==PlaneCurves{k,1}(:,2)); %&...
                    %(PlaneCurves{k,1}(punktindex,3)==PlaneCurves{k,1}(:,3));
                x(punktindex)=0; %Aktueller Punktindex in x wird auf 0 gesetzt
                punktindex=find(x); %Index des Folgepunktes gefunden
                if isempty(punktindex)==1 %Folgepunkt nicht gefunden 
                    if ungeschlossen==0 %Erstes ungeschlossenes Konturende gefunden
                        ywert=PlaneCurves{k,1}(indexliste(counter-1),2);
                        if (ywert==0) || (ywert==360) 
                            %disp('erstes unbedenkliches ungeschlossenes Konturende gefunden');
                        else 
                            %disp('erstes defektes ungeschlossenes Konturende gefunden');
                        end
                        indexliste(1:counter-1)=flipud(indexliste(1:counter-1));
                        ungeschlossen=1;
                        punktindex=0;
                        counter=counter-1;
                        jumpstyle=1;
                    else %Zweites ungeschlossenes Konturende gefunden
                        ywert=PlaneCurves{k,1}(indexliste(counter-1),2);
                        if (ywert==0) || (ywert==360)
                            %disp('zweites unbedenkliches ungeschlossenes Konturende gefunden');
                        else
                            warning(['Kontur nicht geschlossen in Schnittebene: ', int2str(k) ]);
                            %disp('zweites defektes ungeschlossenes Konturende gefunden');
                            %Reparatur=[Reparatur;[i,PlaneCurves{k,1}(indexliste(1),1:3)];[i,PlaneCurves{k,1}(indexliste(counter-1),1:3)]];
                        end
                        break;
                    end
                else
                    if length(punktindex)>1 %Mehr als 1 FolgePunkt gefunden
                        warning(['Mehr als zwei Dreiecke teilen einen Eckpunkt in Schnittebene ',int2str(k),'. Die resultierende Kontur mag falsch sein.'])
                        freeindex=0;
                        %Eine noch freie Kante als Folgekante auswählen
                        for kkk=1:length(punktindex)
                            if ~(indexliste==punktindex(kkk))
                                freeindex=punktindex(kkk);
                            end
                        end
                        punktindex=freeindex;
                    end
                    jumpstyle=0;
                end
            end
        end
        indexliste(counter:end)=[]; %restliche leere Einträge entfernen
        copyliste=indexliste;
        copyliste(2:2:end-1)=[]; %Jeder zweite Punktindex löschen weil er doppelt vertretten ist. Letzter punkt nicht löschen
        Konturen{k,i}=PlaneCurves{k,1}(copyliste,1:4); %in richtiger Reihenfolge Rüberkopieren
        i=i+1; %Index für geschlossene Kontur wird erhöht        
        PlaneCurves{k,1}(indexliste,:)=[]; %Abgearbeitete Punkte nach indexliste in PlaneCurves vernichten
    end
    %if size(Reparatur,1)>1 %Reparaturmodus für nicht geschlossene Konturen
    %    disp(['in Ebene ', int2str(k),' befinden sich mehr als ein ungeschlossenes Kontursegment']);
    %    while size(Reparatur,1)>2 %Reparaturarray enthält mehr als ein ungeschlossenes Konturensegement
    %        KurvsegA=Reparatur(2,1); %Index des ungeschlossenen Konturensegments A wird zwischengespeichert
    %        closedist=Inf; %Variable zur Speicherung der kürzestenDistanz
    %        for g=3:size(Reparatur,1) %Nächstgelegener Punkt wird gesucht
    %            closedistneu=sqrt((Reparatur(2,2)-Reparatur(g,2))^2+(Reparatur(2,3)-Reparatur(g,3))^2); %Distanz zwischen Punkt 2 und Punkt g wird berechnet
    %            if closedistneu<closedist 
    %                closedist=closedistneu; %neue noch kürzere Distanz zwischenspeichern
    %                gindex=g;
    %                KurvsegB=Reparatur(g,1); %Index des ungeschlossenen folgesegments zwischenspeichern
    %            end
    %        end
    %        if sqrt((Reparatur(1,2)-Reparatur(2,2))^2+(Reparatur(1,3)-Reparatur(2,3))^2)<closedist %erstes Kontursegment in sich geschlossen
    %            Reparatur(1:2,:)=[]; %Index des abgearbeiteten Kontursegments aus Reparaturarray entfernen
    %        elseif mod(gindex,2)==1 %ungerader FolgePunkt im Reparaturarray, Folgekontursegment muss nicht gekehrt werden
    %            Reparatur(2,2:4)=Konturen{k,KurvsegB}(end,1:3);
    %            Reparatur(gindex:gindex+1,:)=[]; %Index des abgearbeiteten Kontursegments aus Reparaturarray entfernen
    %            Konturen{k,KurvsegA}=[Konturen{k,KurvsegA}(:,:);Konturen{k,KurvsegB}(:,:)]; %Kontursegment B zu Kontursegment A hinzufügen
    %            Konturen{k,KurvsegB}=[]; %altes Kontursegment B löschen
    %        elseif mod(gindex,2)==0 %gerader FolgePunkt im Reparaturarray, Folgekontursegment muss gekert werden
    %            Reparatur(2,2:4)=Konturen{k,KurvsegB}(1,1:3);
    %            Reparatur(gindex-1:gindex,:)=[]; %Index des abgearbeiteten Kontursegments aus Reparaturarray entfernen
    %            Konturen{k,KurvsegA}=[Konturen{k,KurvsegA}(:,:);flipud(Konturen{k,KurvsegB}(:,:))]; %Kontursegment B zu Kontursegment A hinzufügen
    %            Konturen{k,KurvsegB}=[]; %altes Kontursegment B löschen
    %        end
    %    end
    %end
    waitbar((k/Z)/2+0.5) %Aktualisierung Ladebalken
end
%close(bar); %Ladebalken schliessen
delete(bar);

%toc
%Schritt4=Konturen;

end