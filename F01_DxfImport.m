function Konturs = F01_DxfImport(Pfad)

%Schritt 1: Dxf Datei einlesen und Abschnitt der Entities heraussuchen
fid=fopen(Pfad); %dxf-file wird geöffnet
dxftext=textscan(fid,'%d%s','Delimiter','\n');
fclose(fid);
GroupCode=dxftext{1};   %Enthält die Gruppen Codes des dxf-files
AsignValu=dxftext{2};   %Enthält die Assigned Values des dxf-files
PosZeros=find(GroupCode==0); %Enthält Indices der Nulleinträge von GroupCode
PosStart=strmatch('ENTITIES',AsignValu(PosZeros(1:end-1)+1),'exact'); %Suche (0,SECTION),(2,ENTITIES) 
PosEnd=strmatch('ENDSEC',AsignValu(PosZeros(PosStart:end)),'exact'); %Suche (0,ENDSEC)
PosENTITIES = PosZeros(PosStart+1:PosStart-1+PosEnd(1)); %Indices +1 der GroupCode der ENTITIES SECTION 
AsignValu(PosENTITIES)

%Schritt 2: CellArrays definieren für Entities
c_Point=cell(sum(strcmp('POINT',AsignValu(PosENTITIES))),1); %CellArray für POINTS
c_Line=cell(sum(strcmp('LINE',AsignValu(PosENTITIES))),1); %CellArray für LINES
c_LwPolyline=cell(sum(strcmp('LWPOLYLINE',AsignValu(PosENTITIES))),1); %CellArray für LWPOLYLINES
c_Spline=cell(sum(strcmp('SPLINE',AsignValu(PosENTITIES))),1); %CellArray für SPLINES
c_Circle=cell(sum(strcmp('CIRCLE',AsignValu(PosENTITIES))),1); %CellArray für CIRCLES
c_Ellipse=cell(sum(strcmp('ELLIPSE',AsignValu(PosENTITIES))),1); %CellArray für ELLIPSES
c_Arc=cell(sum(strcmp('ARC',AsignValu(PosENTITIES))),1); %CellArray für ARCS
c_3DFace=cell(sum(strcmp('3DFACE',AsignValu(PosENTITIES))),1); %CellArray für 3DFACES

%Schritt 3: CellArrays mit Daten der Entities füllen
iPoint=1;
iLine=1;
iLwPolyline=1;
iSpline=1;
iCircle=1;
iEllipse=1;
iArc=1;
i3DFace=1;
for iEnt=1:length(PosENTITIES)-1
    GroupCodeEnt=GroupCode(PosENTITIES(iEnt):PosENTITIES(iEnt+1)-1); %GroupCodes des aktuellen Entities
    AsignValuEnt=AsignValu(PosENTITIES(iEnt):PosENTITIES(iEnt+1)-1); %AssignedValues des aktuellen Entities
    nomEnt=AsignValuEnt{1}; %AsignValuEnt{m_PosCero(iEnt+1)}
    %In the entitie's name is assumed uppercase
    switch nomEnt            
        case 'POINT'
            %(X,Y,Z) Position
            c_Point{iPoint,1}=[str2double(AsignValuEnt(10==GroupCodeEnt)),...
                str2double(AsignValuEnt(20==GroupCodeEnt)),...
                str2double(AsignValuEnt(30==GroupCodeEnt))];
            %AsignValuEnt(10==GroupCodeEnt)
            %Layer
            %c_Point(iPoint,2)=str2double(AsignValuEnt(8==GroupCodeEnt));
            %Color (if no exist is ByLayer (256))
            %c_Point{iLine,3} = str2double(AsignValuEnt(62==GroupCodeEnt));
            %Add properties
            iPoint=iPoint+1;
        case 'LINE'
            % (Xi,Yi,Zi,Xj,Yj,Zj) start and end points
            c_Line{iLine,1}=[str2double(AsignValuEnt(10==GroupCodeEnt)),...
                str2double(AsignValuEnt(20==GroupCodeEnt)),...
                str2double(AsignValuEnt(30==GroupCodeEnt)),...
                str2double(AsignValuEnt(11==GroupCodeEnt)),...
                str2double(AsignValuEnt(21==GroupCodeEnt)),...
                str2double(AsignValuEnt(31==GroupCodeEnt))];
            %Layer
            %c_Line(iLine,2)=str2double(AsignValuEnt(8==GroupCodeEnt));
            %Add properties
            iLine = iLine+1;  
        case 'LWPOLYLINE'
            % (X,Y) vertexs
            %Is not take into account the budge (group code 42, arc in the polyline).
            m_Coord=[str2double(AsignValuEnt(10==GroupCodeEnt)),...
                    str2double(AsignValuEnt(20==GroupCodeEnt))];
            if strcmp(AsignValuEnt(70==GroupCodeEnt),'1')&&...
                    any(m_Coord(1,:)~=m_Coord(end,:))
                %Close polyline
                c_LwPolyline{iLwPolyline,1} = [m_Coord;m_Coord(1,:)];
            else
                c_LwPolyline{iLwPolyline,1} = m_Coord;
            end
            %Layer
            %c_LwPolyline(iLwPolyline,2)=str2double(AsignValuEnt(8==GroupCodeEnt));
            iLwPolyline=iLwPolyline+1;   
        case 'SPLINE'
            %degree_of_Bspline=str2double(AsignValuEnt(71==GroupCodeEnt));
            number_of_knots=str2double(AsignValuEnt(72==GroupCodeEnt));
            number_of_ctrlpt=str2double(AsignValuEnt(73==GroupCodeEnt));
            %n=2+3+number_of_knots+number_of_ctrlpt*3;
            c_Spline{iSpline,1}=[number_of_knots,...
                number_of_ctrlpt,...
                str2double(AsignValuEnt(210==GroupCodeEnt)),...
                str2double(AsignValuEnt(220==GroupCodeEnt)),...
                str2double(AsignValuEnt(230==GroupCodeEnt)),...
                str2double(AsignValuEnt(40==GroupCodeEnt))',...
                str2double(AsignValuEnt(10==GroupCodeEnt))',...
                str2double(AsignValuEnt(20==GroupCodeEnt))',...
                str2double(AsignValuEnt(30==GroupCodeEnt))'];
            %Layer
            %c_Spline(iSpline,2)=str2double(AsignValuEnt(8==GroupCodeEnt));
            iSpline=iSpline+1;
        case 'CIRCLE'
            % Center Coordinates, Normal Vector Coordinates, Radius
            c_Circle{iCircle,1} = [str2double(AsignValuEnt(10==GroupCodeEnt)),...
                str2double(AsignValuEnt(20==GroupCodeEnt)),...
                str2double(AsignValuEnt(30==GroupCodeEnt)),...
                str2double(AsignValuEnt(210==GroupCodeEnt)),...
                str2double(AsignValuEnt(220==GroupCodeEnt)),...
                str2double(AsignValuEnt(230==GroupCodeEnt)),...
                str2double(AsignValuEnt(40==GroupCodeEnt))];
            if length(c_Circle{iCircle,1})==4
                c_Circle{iCircle,1}=[str2double(AsignValuEnt(10==GroupCodeEnt)),...
                str2double(AsignValuEnt(20==GroupCodeEnt)),...
                str2double(AsignValuEnt(30==GroupCodeEnt)),...
                0,0,1.0,...
                str2double(AsignValuEnt(40==GroupCodeEnt))];
            end
            % Layer
            %c_Circle(iCirle,2)=str2double(AsignValuEnt(8==GroupCodeEnt));
            % Add properties
            iCircle=iCircle+1;
        case 'ELLIPSE'
            c_Ellipse{iEllipse,1}=[str2double(AsignValuEnt(10==GroupCodeEnt)),...
                str2double(AsignValuEnt(20==GroupCodeEnt)),...
                str2double(AsignValuEnt(30==GroupCodeEnt)),...
                str2double(AsignValuEnt(11==GroupCodeEnt)),...
                str2double(AsignValuEnt(21==GroupCodeEnt)),...
                str2double(AsignValuEnt(31==GroupCodeEnt)),...
                str2double(AsignValuEnt(210==GroupCodeEnt)),...
                str2double(AsignValuEnt(220==GroupCodeEnt)),...
                str2double(AsignValuEnt(230==GroupCodeEnt)),...
                str2double(AsignValuEnt(40==GroupCodeEnt)),...
                str2double(AsignValuEnt(41==GroupCodeEnt)),...
                str2double(AsignValuEnt(42==GroupCodeEnt))];
                %Layer
                %c_Ellipse(iEllipse,2)=str2double(AsignValuEnt(8==GroupCodeEnt));
                %Add properties
                iEllipse=iEllipse+1;
        case 'ARC'  %%%% Problem mit center: ist in OCS angegeben
            % Format: ...
            c_Arc{iArc,1} = [str2double(AsignValuEnt(10==GroupCodeEnt)),...
                str2double(AsignValuEnt(20==GroupCodeEnt)),...
                str2double(AsignValuEnt(30==GroupCodeEnt)),...
                str2double(AsignValuEnt(40==GroupCodeEnt)),...
                str2double(AsignValuEnt(50==GroupCodeEnt)),...
                str2double(AsignValuEnt(51==GroupCodeEnt)),...
                str2double(AsignValuEnt(210==GroupCodeEnt)),...
                str2double(AsignValuEnt(220==GroupCodeEnt)),...
                str2double(AsignValuEnt(230==GroupCodeEnt))];
            if length(c_Arc{iArc,1})==6
                c_Arc{iArc,1} = [str2double(AsignValuEnt(10==GroupCodeEnt)),...
                str2double(AsignValuEnt(20==GroupCodeEnt)),...
                str2double(AsignValuEnt(30==GroupCodeEnt)),...
                str2double(AsignValuEnt(40==GroupCodeEnt)),...
                str2double(AsignValuEnt(50==GroupCodeEnt)),...
                str2double(AsignValuEnt(51==GroupCodeEnt)),...
                0,0,1.0];
            end
            %Layer
            %c_Arc(iArc,2)=str2double(AsignValuEnt(8==GroupCodeEnt));
            %Add properties
            iArc = iArc+1;
        case '3DFACE'
            c_3DFace{i3dFace,1}=[str2double(AsignValuEnt(10==GroupCodeEnt)),...
                str2double(AsignValuEnt(20==GroupCodeEnt)),...
                str2double(AsignValuEnt(30==GroupCodeEnt)),...
                str2double(AsignValuEnt(11==GroupCodeEnt)),...
                str2double(AsignValuEnt(21==GroupCodeEnt)),...
                str2double(AsignValuEnt(31==GroupCodeEnt)),...
                str2double(AsignValuEnt(12==GroupCodeEnt)),...
                str2double(AsignValuEnt(22==GroupCodeEnt)),...
                str2double(AsignValuEnt(32==GroupCodeEnt)),...
                str2double(AsignValuEnt(13==GroupCodeEnt)),...
                str2double(AsignValuEnt(23==GroupCodeEnt)),...
                str2double(AsignValuEnt(33==GroupCodeEnt))];
            if length(c_3DFace{i3DdFace,1})==9
                for index=1:3
                    c_3DFace{i3DFace,1}(index+9)=c_3DFace{i3DFace,1}(index+6);
                end
            end
            %Layer               
            %c_3DFace(i3DFace,2)=str2double(AsignValuEnt(8==GroupCodeEnt));
            %Add properties
            iDdFace=i3DFace+1;
        %case Add Entities
    end        
end

%Schritt 4: Darstellen der Entities
%figure
%hold on
%axis equal
PosBig=1;
segment=0.05; %Länge eines Liniensegments für Kreise Elipsen und Splines
c_Big=cell(size(c_Line,1)+size(c_LwPolyline,1)+size(c_Spline,1)+...
    size(c_Circle,1)+size(c_Ellipse,1)+size(c_Arc,1),1); %Cell Array für alle Linienkonstrukte

%POINTS Darstellen (black)
for i=1:size(c_Point,1)
    %scatter3(c_Point{i,1}(1,1),c_Point{i,1}(1,2),c_Point{i,1}(1,3),20,'k');
end

%LINES Darstellen (rot) und Randpunkte in c_Big eintragen
for i=1:size(c_Line,1)
    %plot3([c_Line{i,1}(1,1),c_Line{i,1}(1,4)],...
    %    [c_Line{i,1}(1,2),c_Line{i,1}(1,5)],...
    %    [c_Line{i,1}(1,3),c_Line{i,1}(1,6)],'r');
    c_Big{PosBig}=[c_Line{i,1}(1,1:3);c_Line{i,1}(1,4:6)];
    PosBig=PosBig+1;
end

%LWPOLYLINE Darstellen (mangenta) und Randpunkte in c_Big eintragen
for i=1:size(c_LwPolyline,1) %Index der durch CellArrays itteriert
    %plot(c_LwPolyline{i,1}(:,1),c_LwPolyline{i,1}(:,2),'m');
    c_Big{PosBig}=[c_LwPolyline{i,1},zeros(size(c_LwPolyline{i,1},1),1)];
    PosBig=PosBig+1;
end

%CIRCLE Darstellen (blau) und Randpunkte in c_Big eintragen
for i=1:size(c_Circle,1)
    center=c_Circle{i,1}(1,1:3);            %Mittelpunkt des Kreises
    radius=c_Circle{i,1}(1,7);              %Circle Radius
    %number=round((2*pi*radius)/segment);   %Anzahl Liniensegmente
    number=72;                              %Anzahl Liniensegmente
    n=c_Circle{i,1}(1,4:6);                 %NormalVektor
    n=n./(n(1)^2+n(2)^2+n(3)^2)^0.5;        %NormalVektor normieren
    a=zeros(3,1);                           %RadiusVektor
    if n(1)==0
        a(1)=1;
    elseif n(2)==0
        a(2)=1;
    elseif n(3)==0
        a(3)=1;
    else
        a(1)=1;
        a(2)=1;
        a(3)=(-n(1)-n(2))/n(3);
    end
    a=a./(a(1)^2+a(2)^2+a(3)^2)^0.5*radius;
    CircArray=zeros(number+1,3);
    CircArray(1,:)=a+center';
    q=2*pi/number;
    R=[(n(1))^2*(1-cos(q))+cos(q),n(1)*n(2)*(1-cos(q))-n(3)*sin(q),n(1)*n(3)*(1-cos(q))+n(2)*sin(q);...
        n(2)*n(1)*(1-cos(q))+n(3)*sin(q),(n(2))^2*(1-cos(q))+cos(q),n(2)*n(3)*(1-cos(q))-n(1)*sin(q);...
        n(3)*n(1)*(1-cos(q))-n(2)*sin(q),n(3)*n(2)*(1-cos(q))+n(1)*sin(q),(n(3))^2*(1-cos(q))+cos(q)];
    for j=1:number
        a=R*a;
        CircArray(j+1,:)=a+center';
    end
    %plot3(CircArray(:,1),CircArray(:,2),CircArray(:,3),'b')
    c_Big{PosBig}=CircArray;
    PosBig=PosBig+1;
end

%ARC Darstellen (cyan) und Randpunkte in c_Big eintragen
for i=1:size(c_Arc,1)
    radius=c_Arc{i,1}(1,4);
    center=c_Arc{i,1}(1,1:3);
    n=c_Arc{i,1}(1,7:9);
    winkel1=(2*pi*c_Arc{i,1}(1,5))/360;
    winkel2=(2*pi*c_Arc{i,1}(1,6))/360;
    if winkel1>winkel2
        winkel2=winkel2+2*pi;
    end
    %bogen=(radius*abs(winkel2-winkel1));
    %number=round(bogen/segment);
    number=round((abs(winkel2-winkel1)*72)/(2*pi));
    n=n./(n(1)^2+n(2)^2+n(3)^2)^0.5;
    a=zeros(3,1);
    if (n(1)==0)&&(n(2)==0)
        n(3)=1; % Is it a special case if n(3) was -1 ?
        a(1)=1;
    else
        q=pi/2;
        Ra=[(0)^2*(1-cos(q))+cos(q),0*0*(1-cos(q))-1*sin(q),0*0*(1-cos(q))+0*sin(q);...
            0*0*(1-cos(q))+1*sin(q),(0)^2*(1-cos(q))+cos(q),0*1*(1-cos(q))-0*sin(q);...
            1*0*(1-cos(q))-0*sin(q),1*0*(1-cos(q))+0*sin(q),(1)^2*(1-cos(q))+cos(q)];
        a0=[n(1);n(2);0];
        a=Ra*a0;
    end
    a=a./(a(1)^2+a(2)^2+a(3)^2)^0.5*radius;
    q=winkel1;
    R0=[(n(1))^2*(1-cos(q))+cos(q),n(1)*n(2)*(1-cos(q))-n(3)*sin(q),n(1)*n(3)*(1-cos(q))+n(2)*sin(q);...
        n(2)*n(1)*(1-cos(q))+n(3)*sin(q),(n(2))^2*(1-cos(q))+cos(q),n(2)*n(3)*(1-cos(q))-n(1)*sin(q);...
        n(3)*n(1)*(1-cos(q))-n(2)*sin(q),n(3)*n(2)*(1-cos(q))+n(1)*sin(q),(n(3))^2*(1-cos(q))+cos(q)];
    a=R0*a;
    q=(winkel2-winkel1)/number;
    R=[(n(1))^2*(1-cos(q))+cos(q),n(1)*n(2)*(1-cos(q))-n(3)*sin(q),n(1)*n(3)*(1-cos(q))+n(2)*sin(q);...
        n(2)*n(1)*(1-cos(q))+n(3)*sin(q),(n(2))^2*(1-cos(q))+cos(q),n(2)*n(3)*(1-cos(q))-n(1)*sin(q);...
        n(3)*n(1)*(1-cos(q))-n(2)*sin(q),n(3)*n(2)*(1-cos(q))+n(1)*sin(q),(n(3))^2*(1-cos(q))+cos(q)];
    ArcArray=zeros(number+1,3);
    ArcArray(1,:)=a+center';
    for j=1:number
        a=R*a;
        ArcArray(j+1,:)=a+center';
    end
    %plot3(ArcArray(:,1),ArcArray(:,2),ArcArray(:,3),'c')
    c_Big{PosBig}=ArcArray;
    PosBig=PosBig+1;
end

%ELLIPSE Darstellen (yellow) und Randpunkte in c_Big eintragen
for i=1:size(c_Ellipse,1)
    center=c_Ellipse{i,1}(1,1:3)';
    a=c_Ellipse{i,1}(1,4:6)';
    n=c_Ellipse{i,1}(1,7:9)';
    t=c_Ellipse{i,1}(1,10);
    winkel1=c_Ellipse{i,1}(1,11);
    winkel2=c_Ellipse{i,1}(1,12);
    aleng=(a(1)^2+a(2)^2+a(3)^2)^0.5;
    %bogen=abs(winkel2-winkel1)*(0.5*(aleng^2+(aleng*t)^2))^0.5;
    %number=round(bogen/segment);
    number=round((abs(winkel2-winkel1)*72)/(2*pi));
    if winkel1>winkel2
        winkel2=winkel2+2*pi;
    end
    La=norm(a);
    Lb=La*t;
    aa=a./La;
    q=winkel1;
    R0=[(n(1))^2*(1-cos(q))+cos(q),n(1)*n(2)*(1-cos(q))-n(3)*sin(q),n(1)*n(3)*(1-cos(q))+n(2)*sin(q);...
        n(2)*n(1)*(1-cos(q))+n(3)*sin(q),(n(2))^2*(1-cos(q))+cos(q),n(2)*n(3)*(1-cos(q))-n(1)*sin(q);...
        n(3)*n(1)*(1-cos(q))-n(2)*sin(q),n(3)*n(2)*(1-cos(q))+n(1)*sin(q),(n(3))^2*(1-cos(q))+cos(q)];
    q=(winkel2-winkel1)/number;
    R1=[(n(1))^2*(1-cos(q))+cos(q),n(1)*n(2)*(1-cos(q))-n(3)*sin(q),n(1)*n(3)*(1-cos(q))+n(2)*sin(q);...
        n(2)*n(1)*(1-cos(q))+n(3)*sin(q),(n(2))^2*(1-cos(q))+cos(q),n(2)*n(3)*(1-cos(q))-n(1)*sin(q);...
        n(3)*n(1)*(1-cos(q))-n(2)*sin(q),n(3)*n(2)*(1-cos(q))+n(1)*sin(q),(n(3))^2*(1-cos(q))+cos(q)];
    EllipsArray=zeros(number+1,3);
    aa=R0*aa;
    th=winkel1;
    EllipsArray(1,:)=(Lb/(1-(1-Lb^2/La^2)*cos(th)^2)^0.5*aa+center)';
    for j=1:number
       th=winkel1+j*(winkel2-winkel1)/number;
       aa=R1*aa;
       EllipsArray(1+j,:)=(Lb/(1-(1-Lb^2/La^2)*cos(th)^2)^0.5*aa+center)';
    end
    %plot3(EllipsArray(:,1),EllipsArray(:,2),EllipsArray(:,3),'y')
    c_Big{PosBig}=EllipsArray;
    PosBig=PosBig+1;
end

%SPLINE Darstellen (green) und Randpunkte in c_Big eintragen
for i=1:size(c_Spline,1)
    row=c_Spline{i,1};
    if length(row)==row(1)+3*row(2)+5-3
        row=[row(1:2),0,0,1,row(3:end)];
    end
    knots=row(6:(6+row(1)-1));
    ctrlpoints=zeros(3,row(2));
    ctrlpoints(1,:)=row((6+row(1)):(6+row(1)+row(2)-1));
    ctrlpoints(2,:)=row((6+row(1)+row(2)):(6+row(1)+2*row(2)-1));
    ctrlpoints(3,:)=row((6+row(1)+2*row(2)):(6+row(1)+3*row(2)-1));
    %bogen=0;
    %for j=1:size(ctrlpoints,2)-1
    %    bogen=bogen+((ctrlpoints(1,j+1)-ctrlpoints(1,j))^2+(ctrlpoints(2,j+1)-ctrlpoints(2,j))^2+(ctrlpoints(3,j+1)-ctrlpoints(3,j))^2)^0.5;
    %end
    %number=round(bogen/segment);
    %number=size(ctrlpoints,2)*10;
    number=100;
    sp=spmak(knots,ctrlpoints);
    SplineArray=fnval(sp,knots(1):(knots(end)-knots(1))/number:knots(end))';
    %plot3(SplineArray(:,1),SplineArray(:,2),SplineArray(:,3),'g');
    %scatter3(ctrlpoints(1,:),ctrlpoints(2,:),ctrlpoints(3,:));
    c_Big{PosBig}=SplineArray;
    PosBig=PosBig+1;
end

%Überprüfen ob Geometrien vorhanden
if isempty(c_Big)
    error('Geometrien der Dxf-Datei nicht implementiert oder Dxf-Datei leer');
end

%Schritt 5: Geometrien in richtiger Reihenfolge aneinanderhängen
c_Big=cellfun(@(x) round(x*1000000)/1000000,c_Big,'UniformOutput',false); %Auf 6 Nachkommastellen runden
Konturs=cell(1,1); %CellArray zur Speicherung zusammengesetzter Segmente  
Kx=1; %Index Konturen
Ky=1; %Index sortierte Segmente
Bx=1; %Index unsortierte Segmente
Konturs{Ky,Kx}(:,:)=c_Big{Bx}(:,:); %Erstes Segment nach Konturs kopieren
c_Big(Bx)=[]; %Segment aus c_Big löschen 
while(~isempty(c_Big))
    p1=Konturs{1,Kx}(1,:); %Startpunkt 
    p2=Konturs{Ky,Kx}(end,:); %Endpunkt
    if (p1==p2) %Kontur geschlossen
        disp('Kontur geschlossen')
        Kx=Kx+1;
        Ky=1;
        Konturs{Ky,Kx}(:,:)=c_Big{Bx}(:,:); %Array nach Konturs kopieren
        c_Big(Bx)=[]; %Array löschen
    else %Kontur nicht geschlossen, Folge Segment suchen 
        PointsSta=cell2mat(cellfun(@(x) x(1,1:3),c_Big,'UniformOutput',false)); %Alle Anfangspunkte aus c_Big 
        PointsEnd=cell2mat(cellfun(@(x) x(end,1:3),c_Big,'UniformOutput',false)); %Alle Endpunkte aus c_Big
        Next1=(p2(1)==PointsSta(:,1))&(p2(2)==PointsSta(:,2))&(p2(3)==PointsSta(:,3));
        Next2=(p2(1)==PointsEnd(:,1))&(p2(2)==PointsEnd(:,2))&(p2(3)==PointsEnd(:,3));
        Next3=(p1(1)==PointsSta(:,1))&(p1(2)==PointsSta(:,2))&(p1(3)==PointsSta(:,3));
        Next4=(p1(1)==PointsEnd(:,1))&(p1(2)==PointsEnd(:,2))&(p1(3)==PointsEnd(:,3));
        BNext1=find(Next1);
        BNext2=find(Next2);
        BNext3=find(Next3);
        BNext4=find(Next4);
        if ~isempty(BNext1)
            disp('Folge EndeSegment gefunden');
            Ky=Ky+1;
            Konturs{Ky,Kx}(:,:)=c_Big{BNext1}(:,:); %Segment nach Konturs kopieren
            c_Big(BNext1)=[]; %Segment aus c_Big löschen
        elseif ~isempty(BNext2)
            disp('Folge EndeSegment gefunden aber EndeSegment verkehrt')
            Ky=Ky+1;
            Konturs{Ky,Kx}(:,:)=flipud(c_Big{BNext2}(:,:)); %Segment nach Konturs kopieren
            c_Big(BNext2)=[]; %Segment aus c_Big löschen
        elseif ~isempty(BNext3)
            disp('Folge AnfangSegment gefunden aber AnfangSegment verkehrt');
            Ky=Ky+1;
            Konturs(2:Ky,Kx)=Konturs(1:Ky-1,Kx); %Aufrücken um am Anfang platz zu machen
            Konturs{1,Kx}(:,:)=flipud(c_Big{BNext3}(:,:)); %Segment nach Konturs kopieren
            c_Big(BNext3)=[]; %Segment aus c_Big löschen
        elseif ~isempty(BNext4)
            disp('Folge AnfangSegment');
            Ky=Ky+1;
            Konturs(2:Ky,Kx)=Konturs(1:Ky-1,Kx); %Aufrücken um am Anfang platz zu machen
            Konturs{1,Kx}(:,:)=c_Big{BNext4}(:,:); %Segment nach Konturs kopieren
            c_Big(BNext4)=[]; %Segment aus c_Big löschen
        else
            disp('Kein Folge Segment gefunden')
            Kx=Kx+1;
            Ky=1;
            Konturs{Ky,Kx}(:,:)=c_Big{Bx}(:,:); %Segment nach Konturs kopieren
            c_Big(Bx)=[]; %Segment aus c_Big löschen
        end
    end
end

%Schritt 6: Doppelt vertretene Punkte zwischen den Segmenten entfernen
for i=2:size(Konturs,1) 
    for j=1:size(Konturs,2)
        if ~isempty(Konturs{i,j})
            Konturs{i,j}(1,:)=[];
        end
    end
end

%Schritt 7: Jede Spalte in Konturs zu einem Array zusammenfassen
for i=1:size(Konturs,2) 
    if ~isempty(Konturs{1,i})
        Konturs{1,i}=cell2mat(Konturs(:,i));
    end
end
Konturs(2:end,:)=[]; %Restliche CellArray Einträge löschen

if size(Konturs,2)>1
    warning('Dxf-Geometrieelemente nicht zusammenhängend');
end

%{
%Schritt 8: Reihenfolge der Punkte anordnen, damit Startpunkt negativ x
for i=1:size(Konturs,2) 
    if ~isempty(Konturs{1,i})
        if Konturs{1,i}(1,1)>Konturs{1,i}(end,1)
            Konturs{1,i}=flipud(Konturs{1,i});
        end
    end
end

%Darstellen der Segmente
for i=1:size(Konturs,2) 
    if ~isempty(Konturs{1,i})
        plot3(Konturs{1,i}(:,1),Konturs{1,i}(:,2),Konturs{1,i}(:,3),'k');
    end
end
%}

end

