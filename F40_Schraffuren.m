function [ Schraffuren,Bearbeitungszeit ] = F40_Schraffuren(...
    Konturen,Linienabstand,LinienOffsets,Skywritestart,Skywriteend,...
    Schraffurwinkelstart,Schraffurwinkelinkrem,...
    Hatchtyp,MinimalLaenge,OnDelayLength,OffDelayLength,Scangeschw,Jumpgeschw)
%F40_Schraffuren berechnet aus geschlossenen Konturen die Schraffuren. 
%Als Imput bekommt diese Funktion das CellArray Konturen. In diesem Cell
%Array enthält jede Zeile die geschlossenen Konturen einer Schnittebene.
%Jedes einzelnes Array vom Cell Array Konturen hat vier Spalten.
%In den ersten drei Spalten sind die x-, y- und z-Koordinaten der einzelnen
%Eckpunkte der geschlossenen Kontur. Werden diese Zeile für Zeile
%miteinander verbunden, entsteht eine geschlossene Kontur. 
%In der vierten Spalte jedes Arrays, ist die Dreiecksnummer der
%Stl-Datei gespeichert aus dem der Eckpunkt auf dieser Zeile entstanden
%ist.
%Ein weiterer Imput ist der Linienabstand. Dieser gibt an welchen Abstand
%die einzelnen Schraffurlinen später haben sollen. 
%Der Imput Skywrite gibt an ob Skywrite berechnet werden soll (1=ja, 0=nein)
%Skywritestart ist die Länge [mm], die die Skywritestarlinien haben sollen.
%Skywriteend ist die Länge [mm], die die Skywriteendlinien haben sollen.
%Der Imput Schraffurwinkel gibt an ob von Schraffur zu Schraffur ein
%variabler Winkel berechnet werden soll (1=ja, 0=nein)
%Schraffurwinkelstart ist der erste Schraffurwinkel in Grad.
%Schraffurwinkelinkrem ist der variable Winkel in Grad der von Schraffur zu
%Schraffur ändert.
%Mit dem Imput Hatchtyp kann der Linienverlauf der Schraffuren definiert 
%werden(1=Rechteck) (0=Zickzack)
%Output dieser Funktion ist das Cell Array Schraffuren. Jede Zeile in
%diesem Cell Array enthält die berechneten Schraffuren einer Schnittebene.
%In den ersten drei Spalten sind die x-, y- und z-Koordinaten der einzelnen
%Schraffurpunkte enthalten. In der vierten Spalte ist definiert um was für
%einen Linietyp es sich handelt. 
%0=Eilganglinie, die mit ausgeschaltetem Laser so schnell wie möglich 
%abgefahren werden kann (G00)
%1=Linie, die mit eingeschaltetem Laser mit Scangeschwindigkeit abgefahren
%werden kann  (G01) (Skywrite ist nicht aktiv)
%2=Skywritestartlinie, die mit ausgeschaltetem Laser mit
%Scangeschwindigkeit abgefahren werden kann (G01)
%3=Skywriteendlinie, die mit ausgeschaltetem Laser mit
%Scangeschwindigkeit abgefahren werden kann (G01)
%4=Linie, die mit eingeschaltetem Laser mit Scangeschwindigkeit abgefahren
%werden kann (G01) (Skywrite ist aktiv)

[m,n]=size(Konturen); 

    %Folgende Schlaufe dreht alle Punkte in Konturen Ebene um Ebene im Gegenuhrzeigersinn um den Winkel varangle
    winkel=[0:1:size(Konturen,1)-1]*Schraffurwinkelinkrem+ones(1,size(Konturen,1))*Schraffurwinkelstart;
    for k=1:size(Konturen,1) %Index, der durch die Ebenen von Konturen geht
        for i=1:size(Konturen,2) %Index, der durch Unterkurven von Konturen geht
            if ~isempty(Konturen{k,i})
                Konturen{k,i}(:,1:2)=Konturen{k,i}(:,1:2)*[cosd(winkel(k)),sind(winkel(k));-sind(winkel(k)),cosd(winkel(k))];
            end
        end
    end

    Schraffuren=cell(m,1); %CellArray zur Speicherung der Schraffuren jeder Ebene
    bar = waitbar(0,'Schraffuren werden berechnet...'); %Ladebalken erstellen
    Bearbeitungszeit=0;            
    VorangehenderEndPunkt=[0,0];
    for k=1:m %Index, der durch die Ebenen itteriert
        counter=1; %Index, der hilft die berechneten SectPts ins Array SectPts einzufüllen
        if isempty(Konturen{k,1}) %In dieser Ebene gibt es keine geschlossenen Konturen
            Schraffuren{k,1}=[];
        else %In dieser Ebene gibt es geschlossenen Konturen

        %Schritt 0: Arraygrösse Abschätzen
            %tic
            %disp('Schritt 0');
            minx=min(Konturen{k,1}(:,1));
            maxx=max(Konturen{k,1}(:,1));
            AnzahlSectPts=0;
            for i=1:size(Konturen,2) %Index, der durch die geschlossenen Kurven auf der selben Ebene iteriert
                if ~isempty(Konturen{k,i})
                    for p=1:(size(Konturen{k,i},1)-1)
                        AnzahlSectPts=AnzahlSectPts+1+ceil(abs(Konturen{k,i}(p,1)-Konturen{k,i}(p+1,1))/Linienabstand);
                        if min(Konturen{k,i}(:,1))<minx
                            minx=min(Konturen{k,i}(:,1));
                        end
                        if max(Konturen{k,i}(:,1))>maxx
                            maxx=max(Konturen{k,i}(:,1));
                        end
                    end
                end
            end
            AnzahlSectPts=AnzahlSectPts+10000;
            SectPts=zeros(AnzahlSectPts,4); %Array zur Speicherung der Schnittpunkte
            
            %Hatchvektor wird definiert
            if LinienOffsets==0
                hx=[minx+0.0001:Linienabstand:maxx]';
            elseif LinienOffsets==1
                if mod(k,8)==1
                    Offset=(1/16);
                elseif mod(k,8)==2
                    Offset=(9/16); 
                elseif mod(k,8)==3
                    Offset=(5/16);
                elseif mod(k,8)==4
                    Offset=(13/16);
                elseif mod(k,8)==5
                    Offset=(3/16);
                elseif mod(k,8)==6
                    Offset=(11/16);
                elseif mod(k,8)==7
                    Offset=(7/16);
                elseif mod(k,8)==0
                    Offset=(15/16);
                end
                hx=[fliplr([0-Linienabstand*(1-Offset):-Linienabstand:minx]),[0+Linienabstand*Offset:Linienabstand:maxx]]';
                hx=hx(hx>minx & hx<maxx);
            end
            %toc   

        %Schritt 1: Berechne die Schnittpunkte zwischen den X-linien (hx) und den Konturen
            %disp('Schritt 1');
            %tic
            Richtung=1;
            for i=1:size(Konturen,2) %Index, der durch die geschlossenen Kurven auf der selben Ebene iteriert
                if ~isempty(Konturen{k,i}) 
                    Konturen{k,i}=[Konturen{k,i};Konturen{k,i}(1:2,:)]; %Die ersten zwei Punkte werden nochmals hinten an der Liste angehängt(Trick)
                    for j=1:size(Konturen{k,i},1)-2 %Index der durch die Zeilen der Konturen geht
                        E0=Konturen{k,i}(j,1:3); %vorangehender Eckpunkt 0 wird zwischengespeichert
                        E1=Konturen{k,i}(j+1,1:2); %aktiver Eckpunkt 1 wird zwischengespeichert
                        if E0(1)<E1(1)
                            hx_cut=hx((E0(1)<hx)&(hx<=E1(1))); %x-koordinaten der SectPts zwischen E0 und E1 werden berechent 
                            if ~isempty(hx_cut)
                                if hx_cut(end)==E1(1) %E1 liegt auf einer hatchlinie
                                    Richtung=1;
                                    E2=Konturen{k,i}(j+2,1:2); %folgender Eckpunkt 2 wird zwischengespeichert
                                    if E2(1)<E1(1) %"Berührung" 
                                        hx_cut(end)=[]; %E1 wieder entfernen
                                    elseif E2(1)==E1(1) %"Ein Nachbar auf gleicher Linie"
                                        %nichts machen, E1 ist schon richtig gespeichert
                                    else %E2(1)>E1(1) "Schnitt"
                                        %nichts machen, E1 ist schon richtig gespeichert
                                    end
                                end
                            end
                            y_interpol=E0(2)+(E1(2)-E0(2))/(E1(1)-E0(1))*(hx_cut-E0(1)); %y-Koordinaten der SectPts werden berechnet
                        elseif E0(1)>E1(1)
                            hx_cut=hx((E0(1)>hx)&(hx>=E1(1))); %x-koordinaten der SectPts zwischen p1 und p2 werden berechent
                            if ~isempty(hx_cut)
                                if hx_cut(1)==E1(1) %p2 liegt auf einer Hatchlinie
                                    Richtung=-1;
                                    E2=Konturen{k,i}(j+2,1:2); %folgender Eckpunkt 2 wird zwischengespeichert
                                    if E2(1)>E1(1) %"Berührung"
                                        hx_cut(1:end-1,:)=hx_cut(2:end,:); %Restvektor über E1 aufrücken
                                        hx_cut(end)=[]; %letzter Eintrag löschen
                                    elseif E2(1)==E1(1) %"Ein Nachbar auf gleicher Linie"
                                        %nichts machen, E1 ist schon richtig gespeichert
                                    else  %E2(1)<E1(1) "Schnitt"
                                        %nichts machen, E1 ist schon richtig gespeichert
                                    end
                                end
                            end
                            y_interpol=E1(2)+(E0(2)-E1(2))/(E0(1)-E1(1))*(hx_cut-E1(1)); %y-Koordinaten der SectPts werden berechnet
                        else %special case (falls E0,E1 auf hx liegen)
                            if ~isempty(find(hx==E0(1),1)) %liegt punkt E0 (und damit auch E1) genau auf einer Schnittline?
                                E2=Konturen{k,i}(j+2,1:2); %folgender Eckpunkt 2 wird zwischengespeichert
                                if E2(1)==E1(1) %"Beide Nachbarn auf gleicher Linie" 
                                    hx_cut=[]; 
                                    y_interpol=[]; 
                                else %"Ein Nachbar auf gleicher Linie" "Richtungswechsel"
                                    if Richtung==1 && (E1(1)>E2(1)) || Richtung==-1 && (E1(1)<E2(1))
                                        hx_cut=E1(1);
                                        y_interpol=E1(2);
                                    else %"Kein Richtungswechsel"
                                        hx_cut=[]; 
                                        y_interpol=[]; 
                                    end
                                end
                            else %Liniensegment liegt nicht auf einer Linie von hx_cut
                                hx_cut=[];
                                y_interpol=[]; %y-Koordinaten der SectPts werden berechnet
                            end
                        end
                        nmb_cuts=length(hx_cut); %Anzahl Schnittpunke
                        if size(SectPts,1)<counter+nmb_cuts-1 %Hat es in SectPts noch genug platz?
                            warning('Array SectPts ist zu klein');
                            SectPts=[SectPts;zeros(counter+nmb_cuts-1-size(SectPts,1),4)]; %SectPts wird erweitert
                        end
                        SectPts(counter:counter+nmb_cuts-1,1:3)=[hx_cut,y_interpol,ones(nmb_cuts,1)*E0(3)]; %SectPts werden in SectPts angehängt
                        counter=counter+nmb_cuts; %der Index Counter wird ensprechend erhöht
                    end
                end
            end
            SectPts(counter+1:end,:)=[]; %Leere Einträge entfernen
            SectPts(counter,1:3)=[inf,inf,inf]; %Anfügen eines Schlusspunkts (Trick für Folgeschlaufe)
            %toc
            %Schritt1=SectPts;

        %Schritt 2: Sortiere SectPts absteigenden nach x-Koordinaten
            %disp('Schritt 2');
            %tic
            [~,ind]=sort(SectPts(:,1));
            SectPts=SectPts(ind,:);
            %toc
            Schritt2=SectPts;

        %Schritt 3: Schnittpunkte nach X-Linien ins Cell Array XLines sortieren
            %disp('Schritt 3');
            %tic
            XLines=cell(length(hx),1); %CellArray zur Speicherung der Punkte jeder X-Linie
            XLineIndex=1; %Index zum einfüllen der Linienpunkte in XLines
            staIndex=1; %Index zur Kennzeichnung einer neuen X-Linie in SectPts
            for endIndex=1:size(SectPts,1) %Endindex itteriert durch alle SectPts
                if SectPts(endIndex,1)~=SectPts(staIndex,1) %Beginn neuer X-Linie endteckt
                    if mod(XLineIndex,2)==1 || Hatchtyp==0 %aufsteigend
                        LinePts=SectPts(staIndex:endIndex-1,:); %Array zur Speicherung aktueller LinienPunkte
                        LinePts(:,2)=sort(LinePts(:,2),'ascend'); %Sortiert Y-Koordinaten aufsteigend
                        LinePts(1:2:end,4)=1; %Jeder zweite Eintrag in der vierten Spalte wird auf 1 (Laserlinie) gesetzt
                    else %absteigend
                        LinePts=SectPts(staIndex:endIndex-1,:); %Array zur Speicherung aktueller LinienPunkte
                        LinePts(:,2)=sort(LinePts(:,2),'descend'); %Sortiert Y-Koordinaten absteigend
                        LinePts(1:2:end,4)=1; %Jeder zweite Eintrag in der vierten Spalte wird auf 1 (Laserlinie) gesetzt
                    end                    
                %aktuelle LinePts ins Cellarray XLines einfüllen
                XLines{XLineIndex,1}=LinePts;
                XLineIndex=XLineIndex+1;
                staIndex=endIndex;
                end
            end
            XLines(XLineIndex:end)=[]; %Leere CellArrayeinträge entfernen
            %Schritt3=XLines;
            %toc

        %Schritt4: Kurze Liniensegmente entfernen
            if MinimalLaenge~=0
                if ~isempty(XLines)
                    for XLineIndex=1:size(XLines,1) %XLineIndex itteriert durch alle XLinien 
                        %Laserlinien die kürzer als MinimalLaengeN entfernen
                        if ~isempty(XLines{XLineIndex,1})
                            LaserDistancesX=XLines{XLineIndex,1}(2:2:end,2)-XLines{XLineIndex,1}(1:2:end-1,2);
                            Delete1=abs(LaserDistancesX)<MinimalLaenge;
                            Delete2=zeros(2*size(Delete1,1),1);
                            Delete2(1:2:end,1)=Delete1;
                            Delete2(2:2:end,1)=Delete1;
                            XLines{XLineIndex,1}=XLines{XLineIndex,1}(~Delete2,:);
                        end
                        %Zwischenlinien die kürzer als MinimalLaengeN entfernen
                        if ~isempty(XLines{XLineIndex,1})
                            ZwischenDistancesX=XLines{XLineIndex,1}(3:2:end-1,2)-XLines{XLineIndex,1}(2:2:end-2,2);
                            Delete3=abs(ZwischenDistancesX)<MinimalLaenge;
                            Delete4=zeros(2*size(Delete3,1)+2,1);
                            Delete4(2:2:end-2,1)=Delete3;
                            Delete4(3:2:end-1,1)=Delete3;
                            XLines{XLineIndex,1}=XLines{XLineIndex,1}(~Delete4,:);
                        end
                    end
                end
            end
            %Schritt4=XLines;

        %Schritt 5: Start und Endpunkte nach Laserdelays verschieben
            if OnDelayLength~=0||OffDelayLength~=0
                for XLineIndex=1:size(XLines,1) %Itteriert durch alle YLines
                    if ~isempty(XLines{XLineIndex,1})
                        if mod(XLineIndex,2)==1 || Hatchtyp==0 %aufsteigend 
                            XLines{XLineIndex,1}(1:2:end-1,2)=XLines{XLineIndex,1}(1:2:end-1,2)-OnDelayLength; %Startpunkte verschieben
                            XLines{XLineIndex,1}(2:2:end,2)=XLines{XLineIndex,1}(2:2:end,2)-OffDelayLength; %Endpunkte verschieben
                        else %absteigend
                            XLines{XLineIndex,1}(1:2:end-1,2)=XLines{XLineIndex,1}(1:2:end-1,2)+OnDelayLength; %Startpunkte verschieben
                            XLines{XLineIndex,1}(2:2:end,2)=XLines{XLineIndex,1}(2:2:end,2)+OffDelayLength; %Endpunkte verschieben
                        end
                    end
                end
            end
            %Schritt5=XLines;

        % Schritt 6: Skywritelinien berechnen
            %disp('Schritt 6');
            %tic
            if Skywritestart~=0||Skywriteend~=0 %if Skywrite==1
                if ~isempty(XLines)
                    for XLineIndex=1:size(XLines,1) %XLineindex itteriert durch XLines
                        if ~isempty(XLines{XLineIndex,1})
                            if mod(XLineIndex,2)==1 || Hatchtyp==0 %aufsteigend
                                laenge=size(XLines{XLineIndex,1},1);
                                LinePts=zeros(laenge*2,4); %Array zur Speicherung aktueller LinienPunkte
                                LinePts(2:laenge+1,2)=XLines{XLineIndex,1}(:,2);
                                LinePts(2:2:laenge+1,4)=4; %Jeder zweite Eintrag in der vierten Spalte wird auf 4 (Laserlinie) gesetzt
                                LinePts(3:2:laenge+1,4)=3; %Jeder zweite Eintrag in der vierten Spalte wird auf 3 (EndSkywriteline) gesetzt
                                LinePts(1,[2,4])=[LinePts(2,2)-Skywritestart,2]; %Erste Startskywritelinie
                                LinePts(laenge+2,[2,4])=[LinePts(laenge+1,2)+Skywriteend,0]; %Letzte Endskywritelinie
                                %Zwischenskywritelinien berechen
                                Start=3;
                                Stop=laenge+1;
                                while Start<Stop
                                    if LinePts(Start+1,2)-LinePts(Start,2)<(Skywritestart+Skywriteend) %Zwischenskywritelinie existiert nicht
                                        Start=Start+2;
                                    else %Zwischenskywritelinie existiert und wird eingefügt
                                        LinePts(Start+3:Stop+3,[2,4])=LinePts(Start+1:Stop+1,[2,4]); %Restliche Punkte aufschieben
                                        LinePts(Start+1,[2,4])=[LinePts(Start,2)+Skywritestart,0]; %StartSkywritelinie einfügen
                                        LinePts(Start+2,[2,4])=[LinePts(Start+3,2)-Skywriteend,2]; %Eilgang einfügen
                                        Start=Start+2;
                                        Stop=Stop+2;
                                    end
                                end
                                LinePts(Stop+2:end,:)=[]; %Restliche Einträge entfernen
                                LinePts(:,1)=XLines{XLineIndex,1}(1,1); %XKolone ergänzen
                                LinePts(:,3)=XLines{XLineIndex,1}(1,3); %ZKolone ergänzen
                                XLines{XLineIndex,1}=LinePts;
                            else %absteigend
                                laenge=size(XLines{XLineIndex,1},1);
                                LinePts=zeros(laenge*2,4); %Array zur Speicherung aktueller LinienPunkte
                                LinePts(2:laenge+1,2)=XLines{XLineIndex,1}(:,2);
                                LinePts(2:2:laenge+1,4)=4; %Jeder zweite Eintrag in der vierten Spalte wird auf 4 (Laserlinie) gesetzt
                                LinePts(3:2:laenge+1,4)=3; %Jeder zweite Eintrag in der vierten Spalte wird auf 3 (EndSkywriteline) gesetzt
                                LinePts(1,[2,4])=[LinePts(2,2)+Skywriteend,2]; %Letzte Endskywritelinie
                                LinePts(laenge+2,[2,4])=[LinePts(laenge+1,2)-Skywritestart,0]; %Erste Startskywritelinie
                                %Zwischenskywritelinien berechen
                                Start=3;
                                Stop=laenge+1;
                                while Start<Stop
                                    if LinePts(Start,2)-LinePts(Start+1,2)<(Skywritestart+Skywriteend) %Zwischenskywritelinie existiert nicht
                                        Start=Start+2;
                                    else %Zwischenskywritelinie existiert und wird eingefügt
                                        LinePts(Start+3:Stop+3,[2,4])=LinePts(Start+1:Stop+1,[2,4]); %Restliche Punkte aufschieben
                                        LinePts(Start+1,[2,4])=[LinePts(Start,2)-Skywriteend,0]; %StartSkywritelinie einfügen
                                        LinePts(Start+2,[2,4])=[LinePts(Start+3,2)+Skywritestart,2]; %Eilgang einfügen
                                        Start=Start+4;
                                        Stop=Stop+2;
                                    end
                                end
                                LinePts(Stop+2:end,:)=[]; %Restliche Einträge entfernen
                                LinePts(:,1)=XLines{XLineIndex,1}(1,1); %XKolone ergänzen
                                LinePts(:,3)=XLines{XLineIndex,1}(1,3); %ZKolone ergänzen
                                XLines{XLineIndex,1}=LinePts;
                            end
                        end
                    end
                end
            end
            %Schritt6=XLines;
            %toc
                
            %Bearbeitungszeit abschätzen
            if Scangeschw~=0
                if ~isempty(XLines)
                    for XLineIndex=1:size(XLines,1)
                        if ~isempty(XLines{XLineIndex,1})
                            %Bearbeitungszeit Eilganglinie zwischen Linie berechnen
                            DeltaX=VorangehenderEndPunkt(1)-XLines{XLineIndex,1}(1,1);
                            DeltaY=VorangehenderEndPunkt(2)-XLines{XLineIndex,1}(1,2);
                            Bearbeitungszeit=Bearbeitungszeit+(DeltaX^2+DeltaY^2)^0.5/Jumpgeschw;
                            %Bearbeitungszeit auf der XLinie berechnen
                            LengthTypTime=zeros(size(XLines{XLineIndex,1},1)-1,4);
                            LengthTypTime(:,1)=abs(XLines{XLineIndex,1}(2:end,2)-XLines{XLineIndex,1}(1:end-1,2));
                            LengthTypTime(:,2)=XLines{XLineIndex,1}(1:end-1,4);
                            LengthTypTime(LengthTypTime(:,2)==0,3)=Jumpgeschw;
                            LengthTypTime(LengthTypTime(:,2)~=0,3)=Scangeschw;
                            LengthTypTime(:,4)=LengthTypTime(:,1)./LengthTypTime(:,3);
                            Bearbeitungszeit=Bearbeitungszeit+sum(LengthTypTime(:,4));
                            VorangehenderEndPunkt=XLines{XLineIndex,1}(end,1:2);
                        end
                    end
                end
            end
                
            waitbar(k/m) %Ladebalken aktualisieren
            Schraffuren{k,1}=cell2mat(XLines); %für jede Ebene werden die SectPts im CellArray Schraffuren gespeichert
        end
    end
    close(bar) %Ladebalken schliessen

    % Folgende Schlaufe dreht alle Punkte in Konturen Ebene um Ebene im Uhrzeigersinn um den Winkel varangle
    winkel=[0:1:size(Konturen,1)-1]*Schraffurwinkelinkrem+ones(1,size(Konturen,1))*Schraffurwinkelstart;
    for k=1:size(Schraffuren,1) %Index, der durch die Ebenen von Schraffuren geht
        if ~isempty(Schraffuren{k,1})
                Schraffuren{k,1}(:,1:2)=Schraffuren{k,1}(:,1:2)*[cosd(winkel(k)),-sind(winkel(k));sind(winkel(k)),cosd(winkel(k))];
        end
    end

end