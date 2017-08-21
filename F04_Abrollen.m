function [v3,n3,NK3,Umfangsabtrag] = F04_Abrollen(v1,n1,f1)
%Diese Funktion führt eine Transformation der Nutgeometrie von kartesisch
%in zylindrische Koordinaten durch. Danach werden die einzelnen Nutsegmente
%die von 0Grad bis 360Grad reichen in richtiger Reihenfolge
%zusammengehängt damit eine zusammenhängende abgerollte Nutgeometrie
%entsteht.
%Falls die Geometrie im Umfang von 0 bis 360Grad geschlossen ist, wird der
%Output Umfangsabtrag auf 1 gesetzt.
%Falls die Geometrie nicht im Umfang geschlossen ist wird der Output
%Umfangsabtrag auf 0 gesetzt.

%Transformation von kartesisch in zylindrisch
%disp('Transformation von kartesisch zu zylindrisch wird berechnet...');
%tic
v2=zeros(size(v1));
iv2=[1 2 3];
n2=zeros(size(n1));
in2=1;
bar = waitbar(0,'Transformation wird durchgeführt...'); %Ladebalken erstellen
iterationen=size(f1,1);
for i=1:iterationen %Index, der durch die Dreiecke iteriert
    Dr1=[v1(f1(i,1),:);v1(f1(i,2),:);v1(f1(i,3),:)]; %aktuelles Dreieck wird zwischengespeichert
    [~,ind]=sort(Dr1(:,2),'descend');
    Dr2=Dr1(ind,:); %die drei Eckpunktkoordinaten sind nun absteigend nach den Y-Koordinaten sortiert 
    if (Dr2(1,2)>=0)&&(Dr2(3,2)<=0) && max(Dr2(:,3))>0 %Dreieck wird von y=0 Ebene gespalten und hat ein Eckpunkt mit positiven Z-Koordinaten
        if min(Dr2(:,3))<=0 %Dreieck wird von z=0 Ebene gespalten
            warning('Dreieck wird von z=0 und y=0 Ebene gespalten');
            %Fehlerdreieck trotzdem kopieren damit Indices erhalten bleiben und kein Dreieck verloren geht
            Dr3=[Dr1(:,1),atand(Dr1(:,3)./Dr1(:,2))+(Dr1(:,2)>0).*180+90,sqrt(Dr1(:,2).^2+Dr1(:,3).^2)];
            v2(iv2,:)=Dr3;
            iv2=iv2+3;
            %Trotzdem Normalenvektor berechnen
            vb=Dr3(2,:)-Dr3(1,:);
            va=Dr3(3,:)-Dr3(1,:);
            normv=[va(2)*vb(3)-va(3)*vb(2),va(3)*vb(1)-va(1)*vb(3),va(1)*vb(2)-va(2)*vb(1)];
            normv=normv/(normv(1)^2+normv(2)^2+normv(3)^2)^0.5; %normieren
            n2(in2,:)=normv;
            in2=in2+1;
        else 
            %Spezielle Transformation
            Dr3=[Dr1(:,1),atand(Dr1(:,3)./Dr1(:,2))+(Dr1(:,2)>=0).*-180+90,sqrt(Dr1(:,2).^2+Dr1(:,3).^2)]; %Koordinatentransformation geschnittens Dreieck
            v2(iv2,:)=Dr3;
            iv2=iv2+3;
            %Abgerollter Normalenvektor berechnen
            vb=Dr3(2,:)-Dr3(1,:);
            va=Dr3(3,:)-Dr3(1,:);
            normv=[va(2)*vb(3)-va(3)*vb(2),va(3)*vb(1)-va(1)*vb(3),va(1)*vb(2)-va(2)*vb(1)];
            normv=normv/(normv(1)^2+normv(2)^2+normv(3)^2)^0.5; %normieren
            n2(in2,:)=normv;
            in2=in2+1;
        end
    else 
        %Normale Transformation
        Dr3=[Dr1(:,1),atand(Dr1(:,3)./Dr1(:,2))+(Dr1(:,2)>=0).*180+90,sqrt(Dr1(:,2).^2+Dr1(:,3).^2)];
        v2(iv2,:)=Dr3;
        iv2=iv2+3;
        %Abgerollter Normalenvektor berechnen
        vb=Dr3(2,:)-Dr3(1,:);
        va=Dr3(3,:)-Dr3(1,:);
        normv=[va(2)*vb(3)-va(3)*vb(2),va(3)*vb(1)-va(1)*vb(3),va(1)*vb(2)-va(2)*vb(1)];
        normv=normv/(normv(1)^2+normv(2)^2+normv(3)^2)^0.5; %normieren
        n2(in2,:)=normv;
        in2=in2+1;
    end
    if mod(i,round(iterationen/50))==0 %Ladebalken nicht bei jedem Schleifendurchlauf aktualisieren (Rechenleistung sparen)
        waitbar(i/iterationen) %Aktualisierung Ladebalken
    end
end
close(bar) %Ladebalken schliessen
v2(iv2(3)-2:end,:)=[];
n2(in2:end,:)=[];
%toc

%Darstellen der abgerollten NutSegmente
%figure
%hold on
%FD3StlObjekt(v2,1);

%NachbarEckpunkte von v2 suchen und in NE2 abspeichern
%disp('NachbarEckpunkte von v2 suchen und in NE2 abspeichern');
tic 
VS2=v2;
VS2(:,4)=1:size(VS2,1); %EckpunktIndex in 4 Kolone speichern
VS2=sortrows(VS2,[1 2 3]); %Reihen nach x, y, und z sortieren
NE2=cell(size(VS2,1),1); %CellArray zur Speicherung angrenzender EckPunkte
VS2=[VS2;[NaN,NaN,NaN,NaN]]; %Schlusspunkt anhängen damit folge Schlaufe funktioniert
istart=1;
bar = waitbar(0,'Abgerollte Geometrie berechnen'); %Ladebalken erstellen
iterationen=size(VS2,1);
for i=1:iterationen
    if ~(VS2(istart,1)==VS2(i,1)&&VS2(istart,2)==VS2(i,2)&&VS2(istart,3)==VS2(i,3)) %Folgepunkt nicht identisch
        if (i-istart)==1
            %disp('Ein DreieckEckpunkt hat keinen NachbarDreieckEckpunkt')
            %scatter3(VS2(istart,1),VS2(istart,2),VS2(istart,3),50,'r'); %Eckpunkt ohne NachbarEckpunkte darstellen
        end
        a=VS2(istart:i-1,4);
        %Index der Nachbarpunkte bei allen Nachbarpunkten in NE2 speichern
        aInd=1;
        while (aInd<=size(a,1))
            NE2{a(aInd),1}=a; %NachbarIndexe speichern
            NE2{a(aInd),1}(a==a(aInd),:)=[]; %Eigeneintrag rauslöschen
            aInd=aInd+1;
        end
        istart=i;
    end
    if mod(i,round(iterationen/50))==0 %Ladebalken nicht bei jedem Schleifendurchlauf aktualisieren (Rechenleistung sparen)
        waitbar(i/iterationen) %Aktualisierung Ladebalken
    end
end
%toc

%Zusammenhängende Umfangssegmente finden
%disp('Zusammenhängende Umfangssegmente finden');
%tic
NA=zeros(size(v2,1),2); %Angrenzende Eckpunkte
NA(1:3:end,1)=2:3:size(v2,1);
NA(1:3:end,2)=3:3:size(v2,1);
NA(2:3:end,1)=1:3:size(v2,1);
NA(2:3:end,2)=3:3:size(v2,1);
NA(3:3:end,1)=1:3:size(v2,1);
NA(3:3:end,2)=2:3:size(v2,1);
NS=zeros(size(v2,1),1); %Zugehörige SegmentNummer für jeden Eckpunkt
Num=1;
while ~isempty(find(NS==0,1))
    Xval=v2(:,1);
    Xval(NS~=0)=Inf;
    [~,NachbarKan]=min(Xval); %Minimaler x-Punkt suchen der in Xval noch Null ist
    SpalteAlt=NS;
    %Benachbarte Kanten Nummerieren
    NS(NA(NachbarKan,:))=Num;
    %Benachbarte Eckpunkte Nummerieren
    NachbarEck=(NS==Num);
    NS(cell2mat(NE2(NachbarEck)))=Num;
    SpalteNeu=NS;
    while ~isequal(SpalteAlt,SpalteNeu)
        SpalteAlt=SpalteNeu;
        %Benachbarte Kanten Nummerieren
        NachbarKan=(NS==Num);
        NS(NA(NachbarKan,:))=Num;
        %Benachbarte Eckpunkte Nummerieren
        NachbarEck=(NS==Num);
        NS(cell2mat(NE2(NachbarEck)))=Num;
        SpalteNeu=NS;
    end
    Num=Num+1;
end
%toc

%NachbarKanten von v2 suchen und in NK2 abspeichern
%disp('NachbarKanten von v2 suchen und in NK2 abspeichern');
%tic
USegmente=cell(Num-1,2); %Zur Speicherung der Umfangssegmente
USegmente(:,:)={zeros(1000,8)};
USegmenteIndex=ones(size(USegmente));
NK2=zeros(size(v2,1),2); %Zur Speicherung de NachbarsKanten
nn=size(v2,1)/3;
NK2(1:3:3*nn,1)=1:nn;
NK2(2:3:3*nn+1,1)=1:nn;
NK2(3:3:3*nn+2,1)=1:nn;
iterationen=size(NK2,1);
for i=1:iterationen %EckpunktNummer
    if NK2(i,2)==0 %NachbarKantenDreieck noch nicht gefunden
        if mod(i,3)==0 %Kante 3
            a=NE2{i,1}; %NachbarEckpunkte Eckpunkt1
            b=NE2{i-2,1}; %NachbarEckpunkte Eckpunkt2
            Va=v2(i,1:3); %Koordinaten Eckpunkt1
            Vb=v2(i-2,1:3); %Koordinaten Eckpunkt2
        else %Kante 1 oder Kante 2
            a=NE2{i,1}; %NachbarEckpunkte Eckpunkt1
            b=NE2{i+1,1}; %NachbarEckpunkte Eckpunkt2
            Va=v2(i,1:3); %Koordinaten Eckpunkt1
            Vb=v2(i+1,1:3); %Koordinaten Eckpunkt2
        end
        A=NK2(a,1); %Angrenzende KantenNummern
        B=NK2(b,1); %Angrenzende KantensNummern
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
            %plot3([Va(1),Vb(1)],[Va(2),Vb(2)],[Va(3),Vb(3)],'b') %Kante ohne angrenzende Nachbarkante darstellen
            %scatter3(Va(1),Va(2),Va(3),50,'b'); %KantenPunkt1 darstellen
            %scatter3(Vb(1),Vb(2),Vb(3),50,'b'); %KantenPunkt2 darstellen
            Nummer=NS(i);
            Indexa=i;
            if mod(i,3)==0 %Kante 3
                Indexb=i-2;
            else %Kante 1 oder Kante 2
                Indexb=i+1;
            end
            if Va(:,2)<180 %Eckpunktkoordinanten die unterhalb von 180Grad liegen
                USegmente{Nummer,1}(USegmenteIndex(Nummer,1),:)=[Va,Indexa,Vb,Indexb];
                USegmenteIndex(Nummer,1)=USegmenteIndex(Nummer,1)+1;
            else %Eckpunktkoordinanten die oberhalb von 180Grad liegen
                USegmente{Nummer,2}(USegmenteIndex(Nummer,2),:)=[Vb,Indexb,Va,Indexa];
                USegmenteIndex(Nummer,2)=USegmenteIndex(Nummer,2)+1;
            end
        elseif size(d,1)>1
            warning('mehr als zwei Dreiecke stossen in Kante aufeinander');
            plot3([Va(1),Vb(1)],[Va(2),Vb(2)],[Va(3),Vb(3)],'g') %Kante mit mehreren Nachbarkanten darstellen
            %scatter3(Va(1),Va(2),Va(3),20,'g'); %KantenPunkt1 darstellen
            %scatter3(Vb(1),Vb(2),Vb(3),20,'g'); %KantenPunkt2 darstellen
        else
            gg=b(B==d); %Gegenüberliegende NachbarKantenNummer
            NK2(i,2)=gg; %Gegenüberliegende NachbarKantenNummer abspeichern
            NK2(gg,2)=i; %Eigene KantenNummer in gegeneüberliegder NachbarKantenNummer abspeichern
        end
    end
    if mod(i,round(iterationen/50))==0 %Ladebalken nicht bei jedem Schleifendurchlauf aktualisieren (Rechenleistung sparen)
        waitbar(i/iterationen) %Aktualisierung Ladebalken
    end
end
%toc

%Resteinträge löschen und Kanten nach x und z sortieren
for i=1:Num-1
    for j=1:2
        USegmente{i,j}(USegmenteIndex(i,j):end,:)=[];
        USegmente{i,j}=sortrows(USegmente{i,j},[1 3]); %Reihen nach x und z sortieren
        if j==1 && isempty(USegmente{i,j})
            Numstart=i;
        end
    end
end

%Zusammenhängendes Gebülde formen
v3=v2;
n3=n2;
NK3=NK2;
if Num==2
    if ~isempty(USegmente{1,1}) && ~isempty(USegmente{1,2})
        %disp('Nur ein Umfangsgebilde von 0 bis 360 Grad');
        NK3(USegmente{1,2}(:,8),2)=USegmente{1,1}(:,4);
        NK3(USegmente{1,1}(:,4),2)=USegmente{1,2}(:,8);
        Umfangsabtrag=1;
    else
        %disp('Nur ein Umfangsgebilde');
        Umfangsabtrag=0;
    end
else
    %disp('Mehrere Umfangsgebilde von 0 bis 360 Grad');
    Numnow=Numstart;
    Umdrehung=1;
    while ~isempty(USegmente{Numnow,2})
        KantenPunkt=USegmente{Numnow,2}(1,1);
        for i=1:Num-1
            if i~=Numnow && ~isempty(USegmente{i,1}) && KantenPunkt==USegmente{i,1}(1,1)
                %disp('Anschlusssegment gefunden');
                v3(:,2)=v3(:,2)+(NS==i)*Umdrehung*360;
                Umdrehung=Umdrehung+1;
                NK3(USegmente{Numnow,2}(:,8),2)=USegmente{i,1}(:,4); %Fehlende NachbarKantenNummer in NK3 ergänzen
                NK3(USegmente{i,1}(:,4),2)=USegmente{Numnow,2}(:,8); %Fehlende NachbarKantenNummer in NK3 ergänzen
                Numnow=i;
                Umfangsabtrag=0;
            end
        end
    end
end
close(bar) %Ladebalken schliessen


end

