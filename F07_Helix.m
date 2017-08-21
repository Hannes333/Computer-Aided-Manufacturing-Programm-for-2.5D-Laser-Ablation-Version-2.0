function [Nutgrund,Rand3,Rand1,KeinRand,HelixZylU,HelixKarU,betasU,...
    HelixZylX,HelixKarX,betasX,HelixZylY,HelixKarY,betasY,...
    Rechtslaufend,NutrandKanten,n1]...
    =F07_Helix(v3,n3,n1,NK3,Umfangsabtrag,Bahnabstand)
%Aus der Nutgeometrie wird durch Ausgleichsrechnung eine Helix berechnet.
%Aus den Nutrandkanten zwischen Nutdeckelflächen (Normalenvektoren haben positive
%Z-Komponente) und Nutgrundflächen (Normalenvektoren haben negative
%Z-Komponente. Anhand der Helix kann das Werstück mit den 5 mechanischen 
%Achsen zum Laser ausgerichtet werden.

%Hilfsvektoren berechnen     
Nutgrund=(n3(:,3)<0);
Nutgrund=logical(reshape((Nutgrund*[1 1 1])',size(Nutgrund,1)*3,1));
Axial=(n1(:,2)<0.005)&(n1(:,2)>-0.005)&(n1(:,3)<0.005)&(n1(:,3)>-0.005);
n1(Axial&n1(:,1)>0,:)=ones(size(find(Axial&n1(:,1)>0),1),1)*[1 0 0]; %n1 glätten
n1(Axial&n1(:,1)<0,:)=ones(size(find(Axial&n1(:,1)<0),1),1)*[-1 0 0]; %n1 glätten
Axial=logical(reshape((Axial*[1 1 1])',size(Axial,1)*3,1));
Nutboden=Nutgrund|Axial; %Nutboden mit Axialflächen
Nutgrund=Nutgrund&~Axial; %Nutgrund ohne Axialflächen
KantenNutdeckels=zeros(size(v3,1),1);    
KantenNutdeckels(NK3(~Nutboden,2))=1;
Rand3=Nutboden&KantenNutdeckels;
KantenNutdecke=zeros(size(v3,1),1);    
KantenNutdecke(NK3(~Nutgrund,2))=1;
KantenNutboden=zeros(size(v3,1),1);
KantenNutboden(NK3(Nutgrund,2))=1;
Rand1=Nutgrund&KantenNutdecke; %Eine Hälfte der Randkanten
Rand2=~Nutgrund&KantenNutboden; %Andere Hälfte der Randkanten
KeinRand=~Rand1&~Rand2; %Alles ausser Randkanten
%Visualisierung von Hilfsvektoren beim Debugging (Zum Beispiel Nutgrund)
%figure
%hold on
%FD3StlObjekt(v1(Nutgrund==1,:),0);

%Nutrand berechnen
Nutrand=find(Rand3);
NutrandKanten=zeros(size(Nutrand,1),3);
iNutrandKanten=1;
for j=1:size(Nutrand,1)
    Eckpunkt=Nutrand(j);
    if mod(Eckpunkt,3)==0 %Kante3
        E1=v3(Eckpunkt,1:3);
        E2=v3(Eckpunkt-2,1:3);
    else %Kante 1 oder 2
        E1=v3(Eckpunkt,1:3);
        E2=v3(Eckpunkt+1,1:3);
    end
    NutrandKanten(iNutrandKanten:iNutrandKanten+1,:)=[E1;E2];
    iNutrandKanten=iNutrandKanten+2;
end
NutrandKanten(iNutrandKanten:end,:)=[];
%NutrandKanten darstellen
%for j=1:2:size(NutrandKanten,1)
%    plot3(NutrandKanten(j:j+1,1),NutrandKanten(j:j+1,2),NutrandKanten(j:j+1,3),'k');
%end

%Helix berechnen
if Umfangsabtrag==1
    MaxR=max(v3(:,3));    
    Anzahl=round((2*pi*MaxR)/Bahnabstand);
    if mod(Anzahl,2)==0
        Anzahl=Anzahl+1;
    end
    Bahnabstandneu=360/Anzahl;
    y=[0:Bahnabstandneu:360]';
    x=(min(v3(:,1))+max(v3(:,1)))/2;
    HelixZylU=[x*ones(size(y,1),1),y,MaxR*ones(size(y,1),1)];
    betasU=90*ones(size(y,1),1);
    %plot3(HelixZylU(:,1),HelixZylU(:,2),HelixZylU(:,3),'r'); %Abgerollte Helix darstellen
    HelixKarU=[HelixZylU(:,1),-sin(HelixZylU(:,2)*pi/180).*HelixZylU(:,3),cos(HelixZylU(:,2)*pi/180).*HelixZylU(:,3)]; %Helix von zylinder in kartesische Koordinaten umwandeln
    HelixZylY=[];
    HelixKarY=[];
    HelixZylX=[];
    HelixKarX=[];
    betasY=[];
    betasX=[];
    Rechtslaufend=1;
end
if Umfangsabtrag==0
    NutrandPunkte=v3(Rand3,:);
    %scatter3(NutrandPunkte(:,1),NutrandPunkte(:,2),NutrandPunkte(:,3),'k','.'); %Punkte aus denen die Helix durch Ausgleichsrechung gebildet wird
    MaxR=max(v3(:,3));
    xmin1=min(v3(:,1));
    xmax1=max(v3(:,1));
    ymin1=min(v3(:,2));
    ymax1=max(v3(:,2));
      
    %disp('Helix berechnen über y-Koordinaten');
    polynomYX=polyfit(NutrandPunkte(:,2),NutrandPunkte(:,1),2);
    polynomYZ=polyfit(NutrandPunkte(:,2),NutrandPunkte(:,3),5);
    y=(ymin1+ymax1)/2;
    Steigung1=atand((2*polynomYX(1)*y+polynomYX(2))*360/(2*pi*MaxR));
    if Steigung1>0
        ymin2=(-polynomYX(2)+sqrt(4*polynomYX(1)*xmin1-4*polynomYX(1)*polynomYX(3)+polynomYX(2)^2))/(2*polynomYX(1));
        ymax2=(-polynomYX(2)+sqrt(4*polynomYX(1)*xmax1-4*polynomYX(1)*polynomYX(3)+polynomYX(2)^2))/(2*polynomYX(1));
    else
        ymin2=(-polynomYX(2)-sqrt(4*polynomYX(1)*xmax1-4*polynomYX(1)*polynomYX(3)+polynomYX(2)^2))/(2*polynomYX(1));
        ymax2=(-polynomYX(2)-sqrt(4*polynomYX(1)*xmin1-4*polynomYX(1)*polynomYX(3)+polynomYX(2)^2))/(2*polynomYX(1));
    end
    yminimum=min(ymin1,ymin2)-2*(Bahnabstand*360/(2*pi*MaxR));
    ymaximum=max(ymax1,ymax2)+2*(Bahnabstand*360/(2*pi*MaxR));
    entries=round((ymaximum-yminimum)/(Bahnabstand*cosd(Steigung1)*360/(2*pi*MaxR)));
    HelixZylY=zeros(2*entries,3);
    betasY=zeros(2*entries,1);
    index=1;    
    y=yminimum;
    while 1
        x=polyval(polynomYX,y);
        z=polyval(polynomYZ,y);
        beta=atand((2*polynomYX(1)*y+polynomYX(2))*360/(2*pi*z));
        HelixZylY(index,:)=[x,y,z];
        betasY(index)=beta;
        index=index+1;
        if y>ymaximum
            break;
        else
            deltay=Bahnabstand*cosd(beta)*360/(2*pi*z);
            y=y+deltay;
        end
    end
    HelixZylY(index:end,:)=[];
    betasY(index:end,:)=[];
    %plot3(HelixZylY(:,1),HelixZylY(:,2),HelixZylY(:,3),'r'); %Abgerollte Helix darstellen
    HelixKarY=[HelixZylY(:,1),-sin(HelixZylY(:,2)*pi/180).*HelixZylY(:,3),cos(HelixZylY(:,2)*pi/180).*HelixZylY(:,3)]; %Helix von zylinder in kartesische Koordinaten umwandeln
    
    %disp('Helix berechnen über x-Koordinaten');   
    polynomXY=polyfit(NutrandPunkte(:,1),NutrandPunkte(:,2),2);  
    polynomXZ=polyfit(NutrandPunkte(:,1),NutrandPunkte(:,3),5);
    x=(xmin1+xmax1)/2;
    Steigung2=atand(360/((2*polynomXY(1)*x+polynomXY(2))*(2*pi*MaxR)));
    if Steigung2>0
        xmin2=(-polynomXY(2)+sqrt(4*polynomXY(1)*ymin2-4*polynomXY(1)*polynomXY(3)+polynomXY(2)^2))/(2*polynomXY(1));
        xmax2=(-polynomXY(2)+sqrt(4*polynomXY(1)*ymax2-4*polynomXY(1)*polynomXY(3)+polynomXY(2)^2))/(2*polynomXY(1));
    else
        xmin2=(-polynomXY(2)-sqrt(4*polynomXY(1)*ymax2-4*polynomXY(1)*polynomXY(3)+polynomXY(2)^2))/(2*polynomXY(1));
        xmax2=(-polynomXY(2)-sqrt(4*polynomXY(1)*ymin2-4*polynomXY(1)*polynomXY(3)+polynomXY(2)^2))/(2*polynomXY(1));
    end
    xminimum=min(xmin1,xmin2)-2*Bahnabstand;
    xmaximum=max(xmax1,xmax2)+2*Bahnabstand;
    entries=round((xmaximum-xminimum)/(Bahnabstand*cosd(Steigung2)));
    HelixZylX=zeros(2*entries,3);
    betasX=zeros(2*entries,1);
    index=1;
    x=xminimum;
    while 1
        y=polyval(polynomXY,x);
        z=polyval(polynomXZ,x);
        beta=atand((2*polynomXY(1)*x+polynomXY(2))*(2*pi*z)/360);
        HelixZylX(index,1:3)=[x,y,z];
        betasX(index)=beta;
        index=index+1;
        if x>xmaximum
            break; 
        else
            deltax=Bahnabstand*cosd(beta);
            x=x+deltax;
        end
    end
    HelixZylX(index:end,:)=[];
    betasX(index:end,:)=[];
    %plot3(HelixZylX(:,1),HelixZylX(:,2),HelixZylX(:,3),'r'); %Abgerollte Helix darstellen
    HelixKarX=[HelixZylX(:,1),-sin(HelixZylX(:,2)*pi/180).*HelixZylX(:,3),cos(HelixZylX(:,2)*pi/180).*HelixZylX(:,3)]; %Helix von zylinder in kartesische Koordinaten umwandeln
    HelixZylU=[];
    HelixKarU=[];
    betasU=[];
    if Steigung1>0
        Rechtslaufend=1;
        betasY=90-betasY;
    else
        Rechtslaufend=0;
        betasX=-betasX;
        HelixZylY=flipud(HelixZylY);
        betasY=90+betasY;
    end
end

end