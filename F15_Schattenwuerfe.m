function [Konturs,Deckels,Hatches,BahnPunkte]=F15_Schattenwuerfe(HelixKar,HelixZyl,...
    betas,v1,n1,v3,NK3,Nutgrund,Rand1,KeinRand,Umfangsabtrag,Rechtslaufend,...
    OffsetStart,OffsetLength,OffsetEnd,HatchVerlaengerung,MinimalLaenge)
%Diese Funktion berechnet aus der Nutgeometrie die anhand der Helix
%ausgerichtet wird die Schattenwürfe und die Konturoffsets. Zudem werden
%die Hatchenden verlängert und sehr kurz Konturkanten unterhalb der
%MinimalLänge entfernt.

%Schattenwürfe berechnen 
bar = waitbar(0,'Schattenwürfe und Konturoffsets berechnen...'); %Ladebalken erstellen
Konturs=cell(size(HelixKar,1),1); %Cellarray zur Speicherung der Schattenkonturen
Deckels=cell(size(HelixKar,1),1); %Cellarray zur Speicherung der Schattenkonturdeckel
Hatches=cell(size(HelixKar,1),1); %Cellarray zur Speicherung der Konturoffsets
BahnPunkte=[zeros(size(HelixKar)),betas,HelixZyl(:,2)]; %Bahnpunkte für die 5 mechanischen Achsen
iterationen=size(HelixKar,1);
for i=1:iterationen
    %i=225; %Für Debugginganalyse einzelner Hatchebenen
    %disp(['# Schattenwurfberechnung Nummer: ',int2str(i)]);
    %BlickRichtung aus beta und gamma erstellen
    %betas(i)=betas(i)-7; %Winkel beta manipulieren
    if Rechtslaufend==1
        BR=[cosd(betas(i)),-sind(betas(i))*cosd(HelixZyl(i,2)),-sind(betas(i))*sind(HelixZyl(i,2))];
    else %Linkslaufend
        BR=[cosd(betas(i)),sind(betas(i))*cosd(HelixZyl(i,2)),sind(betas(i))*sind(HelixZyl(i,2))];
    end
    Zugewandt=((n1(:,1)*BR(1)+n1(:,2)*BR(2)+n1(:,3)*BR(3))<0);
    Zugewandt=reshape((Zugewandt*[1 1 1])',size(Zugewandt,1)*3,1);
    KantenAbgewandt=zeros(size(v3,1),1);
    KantenAbgewandt(NK3(~Zugewandt,2))=1;
    Schatten=Zugewandt&KantenAbgewandt;
    WinkelC=HelixZyl(i,2);
    if Umfangsabtrag==0
        WBereich=(v3(:,2)>WinkelC-90&v3(:,2)<WinkelC+90); 
    else %Umfangsabtrag==1
        if WinkelC<90
            WBereich=(v3(:,2)>WinkelC+270|v3(:,2)<WinkelC+90);
        elseif WinkelC>270
            WBereich=(v3(:,2)>WinkelC-90|v3(:,2)<WinkelC-270);
        else
            WBereich=(v3(:,2)>WinkelC-90&v3(:,2)<WinkelC+90);
        end
    end
    %Darstellen der zugewandten Flächen
    %figure
    %hold on
    %vv=v1(Zugewandt==1,:);
    %FD3StlObjekt(vv,0);
    %plot3(HelixKar(:,1),HelixKar(:,2),HelixKar(:,3),'r'); %Aufgerollte Helix darstellen
    %scatter3(HelixKar(i,1),HelixKar(i,2),HelixKar(i,3),50,'r'); %Aktueller Helixpunkt darstellen
    %quiver3(HelixKar(i,1),HelixKar(i,2),HelixKar(i,3),BR(1),BR(2),BR(3),1,'color','k'); %BlickRichtung darstellen

    %Schattenwurfkanten Nutdeckel finden
    Kanten=find(~Nutgrund&Schatten&KeinRand&WBereich);
    KantenD=zeros(size(Kanten,1),3);
    iKantenD=1;
    for j=1:size(Kanten,1)
        Eckpunkt=Kanten(j);
        if mod(Eckpunkt,3)==0 %Kante3
            E1=v1(Eckpunkt,1:3);
            E2=v1(Eckpunkt-2,1:3);
        else %Kante 1 oder 2
            E1=v1(Eckpunkt,1:3);
            E2=v1(Eckpunkt+1,1:3);
        end
        %plot3([E1(1),E2(1)],[E1(2),E2(2)],[E1(3),E2(3)],'m')
        KantenD(iKantenD:iKantenD+1,:)=[E1;E2];
        iKantenD=iKantenD+2;
    end
    KantenD(iKantenD:end,:)=[];
    
    %Schattenwurfkanten Nutgrund finden
    Kanten=find(Nutgrund&Schatten&KeinRand&WBereich);
    KantenB=zeros(size(Kanten,1),3);
    iKantenB=1;
    for j=1:size(Kanten,1)
        Eckpunkt=Kanten(j);
        if mod(Eckpunkt,3)==0 %Kante3
            E1=v1(Eckpunkt,1:3);
            E2=v1(Eckpunkt-2,1:3);
        else %Kante 1 oder 2
            E1=v1(Eckpunkt,1:3);
            E2=v1(Eckpunkt+1,1:3);
        end
        %plot3([E1(1),E2(1)],[E1(2),E2(2)],[E1(3),E2(3)],'g')
        KantenB(iKantenB:iKantenB+1,:)=[E1;E2];
        iKantenB=iKantenB+2;
    end
    KantenB(iKantenB:end,:)=[];

    if ~isempty(KantenD)&&~isempty(KantenB)&&i~=iterationen  %Schattenwurf exisitert %Kein Schattenwurf bei letztem durchgang (Aber Bahnpunkt) berechnen
    
        %Überganskanten Nutgrund und Nutdeckel finden (Rand)
        Rand=find(Rand1&WBereich);
        RandA=zeros(size(Rand,1),3);
        iRandA=1;
        for j=1:size(Rand,1)
            Eckpunkt=Rand(j);
            if mod(Eckpunkt,3)==0 %Kante3
                E1=v1(Eckpunkt,1:3);
                E2=v1(Eckpunkt-2,1:3);
            else %Kante 1 oder 2
                E1=v1(Eckpunkt,1:3);
                E2=v1(Eckpunkt+1,1:3);
            end
            %plot3([E1(1),E2(1)],[E1(2),E2(2)],[E1(3),E2(3)],'b')
            RandA(iRandA:iRandA+1,:)=[E1;E2];
            iRandA=iRandA+2;
        end
        RandA(iRandA:end,:)=[];

        %Drehen um C-Achse (X-Achse)
        WinkelC=HelixZyl(i,2);
        if Rechtslaufend==1
            winkel1=90-WinkelC;
        else %Linkslaufend
            winkel1=270-WinkelC;
        end
        winkel1=winkel1*pi/180; %Umrechnung Grad in Bogenmass
        HelixKar2=[HelixKar(:,1),HelixKar(:,2).*cos(winkel1)-HelixKar(:,3).*sin(winkel1),HelixKar(:,2).*sin(winkel1)+HelixKar(:,3).*cos(winkel1)]; %Helix um x-Achse drehen
        RandA2=[RandA(:,1),RandA(:,2).*cos(winkel1)-RandA(:,3).*sin(winkel1),RandA(:,2).*sin(winkel1)+RandA(:,3).*cos(winkel1)]; %Rand um x-Achse drehen
        KantenB2=[KantenB(:,1),KantenB(:,2).*cos(winkel1)-KantenB(:,3).*sin(winkel1),KantenB(:,2).*sin(winkel1)+KantenB(:,3).*cos(winkel1)]; %KantenB um x-Achse drehen
        KantenD2=[KantenD(:,1),KantenD(:,2).*cos(winkel1)-KantenD(:,3).*sin(winkel1),KantenD(:,2).*sin(winkel1)+KantenD(:,3).*cos(winkel1)]; %KantenD um x-Achse drehen
        %figure
        %hold on
        %vv2=[vv(:,1),vv(:,2).*cos(winkel1)-vv(:,3).*sin(winkel1),vv(:,2).*sin(winkel1)+vv(:,3).*cos(winkel1)];
        %BR2=[BR(:,1),BR(:,2).*cos(winkel1)-BR(:,3).*sin(winkel1),BR(:,2).*sin(winkel1)+BR(:,3).*cos(winkel1)];
        %FD3StlObjekt(vv2,0); %Um x-Achse gedrehte zugewandte Flächen darstellen
        %plot3(HelixKar2(:,1),HelixKar2(:,2),HelixKar2(:,3),'r'); %Um x-Achse gedrehte Helix darstellen
        %scatter3(HelixKar2(i,1),HelixKar2(i,2),HelixKar2(i,3),50,'r'); %Aktueller HelixPunkt darstellen
        %quiver3(HelixKar2(i,1),HelixKar2(i,2),HelixKar2(i,3),BR2(1),BR2(2),BR2(3),1, 'color','k');
        %Drehen um B-Achse (Y-Achse)
        WinkelB=betas(i);
        winkel2=90-WinkelB;
        winkel2=winkel2*pi/180; %Umrechnung Grad in Bogenmass
        HelixKar3=[HelixKar2(:,1).*cos(winkel2)+HelixKar2(:,3).*sin(winkel2),HelixKar2(:,2),HelixKar2(:,1).*-sin(winkel2)+HelixKar2(:,3).*cos(winkel2)]; %Helix um y-Achse drehen
        RandA3=[RandA2(:,1).*cos(winkel2)+RandA2(:,3).*sin(winkel2),RandA2(:,2),RandA2(:,1).*-sin(winkel2)+RandA2(:,3).*cos(winkel2)]; %Rand um y-Achse drehen
        KantenB3=[KantenB2(:,1).*cos(winkel2)+KantenB2(:,3).*sin(winkel2),KantenB2(:,2),KantenB2(:,1).*-sin(winkel2)+KantenB2(:,3).*cos(winkel2)]; %KantenB um y-Achse drehen
        KantenD3=[KantenD2(:,1).*cos(winkel2)+KantenD2(:,3).*sin(winkel2),KantenD2(:,2),KantenD2(:,1).*-sin(winkel2)+KantenD2(:,3).*cos(winkel2)]; %KantenD um y-Achse drehen
        BahnPunkte(i,1:3)=HelixKar3(i,:);
        %figure
        %hold on
        %vv3=[vv2(:,1).*cos(winkel2)+vv2(:,3).*sin(winkel2),vv2(:,2),vv2(:,1).*-sin(winkel2)+vv2(:,3).*cos(winkel2)];
        %BR3=[BR2(:,1).*cos(winkel2)+BR2(:,3).*sin(winkel2),BR2(:,2),BR2(:,1).*-sin(winkel2)+BR2(:,3).*cos(winkel2)];
        %FD3StlObjekt(vv3,0); %Um y-Achse gedrehte zugewandte Flächen darstellen
        %plot3(HelixKar3(:,1),HelixKar3(:,2),HelixKar3(:,3),'r'); %Um y-Achse gedrehte Helix darstellen
        %scatter3(HelixKar3(i,1),HelixKar3(i,2),HelixKar3(i,3),50,'r'); %Aktueller HelixPunkt darstellen
        %quiver3(HelixKar3(i,1),HelixKar3(i,2),HelixKar3(i,3),BR3(1),BR3(2),BR3(3),1, 'color','k');

        %Minimale YRadius Kante definieren
        if Rechtslaufend==1
            MinRY=-min(v3(:,3))+0.02;
        else %Linksgängig
            MinRY=min(v3(:,3))-0.02;
        end
        KanteMinY=[min(RandA3(:,1))-0.1,MinRY,0;max(RandA3(:,1))+0.1,MinRY,0];

        %Liste definieren
        Liste=[[KantenD3,ones(size(KantenD3,1),1)];[RandA3,2*ones(size(RandA3,1),1)];...
            [KantenB3,3*ones(size(KantenB3,1),1)];[KanteMinY,[0;0]]];
        
        %Liste=round(Liste*10000000)/10000000;
        
        %Kanten die über MinRY liegen aus Liste entfernen
        Delete=zeros(size(Liste,1),1);
        if Rechtslaufend==1
            for j=1:2:size(Liste,1)
                if Liste(j,2)>MinRY&&Liste(j+1,2)>MinRY
                    Delete(j:j+1)=1;
                end
            end
        else %Linkslaufend
            for j=1:2:size(Liste,1)
                if Liste(j,2)<MinRY&&Liste(j+1,2)<MinRY
                    Delete(j:j+1)=1;
                end
            end
        end
        Liste2=Liste(~Delete,:);
        %{
        %Kanten darstellen
        figure
        hold on
        axis equal
        for j=1:2:size(Liste2,1)
            E1=Liste2(j,:);
            E2=Liste2(j+1,:);
            Typus=Liste2(j,4);
            if Typus==1 %DeckelKante
                plot3([E1(1),E2(1)],[E1(2),E2(2)],[E1(3),E2(3)],'m')
            elseif Typus==2 %RandKante
                plot3([E1(1),E2(1)],[E1(2),E2(2)],[E1(3),E2(3)],'b')
            elseif Typus==3 %NutgrundKante  
                plot3([E1(1),E2(1)],[E1(2),E2(2)],[E1(3),E2(3)],'g')
            elseif Typus==0 %MinRYKante
                plot3([E1(1),E2(1)],[E1(2),E2(2)],[E1(3),E2(3)],'y')
            end
        end        
        %}
        
        %Erster Startvektor definieren
        if Rechtslaufend==1
            StaPunktA=[(max(Liste2(Liste2(:,4)==1,1))+min(Liste2(Liste2(:,4)==1,1)))/2,max(Liste2(Liste2(:,4)==1,2))+0.1];
            EndPunktA=[StaPunktA(1),min(Liste2(Liste2(:,4)==1,2))-0.1];
        else
            StaPunktA=[(max(Liste2(Liste2(:,4)==1,1))+min(Liste2(Liste2(:,4)==1,1)))/2,min(Liste2(Liste2(:,4)==1,2))-0.1];
            EndPunktA=[StaPunktA(1),max(Liste2(Liste2(:,4)==1,2))+0.1];            
        end
        VektorA=EndPunktA-StaPunktA;
        IndexA=0;

        %Innenkontur finden
        Innenkontur=zeros(size(Liste2));
        InnenkonturIndex=1;
        Durchlauf=0;
        DurchlaufMax=size(Liste2,1);
        while(1)
            Durchlauf=Durchlauf+1;
            if Durchlauf==1
                Liste3=Liste2(Liste2(:,4)==1,1:4);
            elseif Durchlauf==2
                Liste3=Liste2;
            elseif Durchlauf==3
                BeginSta=StaPunktA;
                BeginEnd=EndPunktA;
                BeginIndex=IndexA;
                Innenkontur(InnenkonturIndex,1:3)=[StaPunktA,Liste3(IndexA,4)]; %Erster StaPunktA und Kantentyp zwischenspeichern
                InnenkonturIndex=InnenkonturIndex+1; 
                %scatter3(StaPunktA(1),StaPunktA(2),HelixKar3(i,3),50,'r'); %Startpunkt darstellen 
            else
                if BeginIndex==IndexA
                    if (round(BeginSta(1)*1000000)/1000000==round(StaPunktA(1)*1000000)/1000000)&&...
                        (round(BeginSta(2)*1000000)/1000000==round(StaPunktA(2)*1000000)/1000000)&&...
                        (round(BeginEnd(1)*1000000)/1000000==round(EndPunktA(1)*1000000)/1000000)&&...
                        (round(BeginEnd(2)*1000000)/1000000==round(EndPunktA(2)*1000000)/1000000)
                        %disp('Schattenwurf gefunden');
                        break;
                    end
                end
                Innenkontur(InnenkonturIndex,1:3)=[StaPunktA,Liste3(IndexA,4)]; %StaPunktA und Kantentyp zwischenspeichern
                InnenkonturIndex=InnenkonturIndex+1; 
            end
            if Durchlauf>DurchlaufMax %Notfall Abbruchbedingung (sollte im idealfall nicht eintreten)
                %errordlg('Schattenwurfberechnung gescheitert. Fehler bitte dem Programmierer melden')
                warning(['Schattenwurfberechnung gescheitert. Hatch: ',num2str(i)]);
                InnenkonturIndex=1;
                break;
            end
            %Debugging Informationenen
            %disp(['# Innenkontur Durchlauf: ',int2str(Durchlauf)]); 
            %disp(['StaPunktA: ',num2str(StaPunktA),' EndPunktA: ',num2str(EndPunktA),' IndexA: ',int2str(IndexA)]); %Infos zu VektorA
            %scatter3(StaPunktA(1),StaPunktA(2),HelixKar3(i,3),10,'k'); %Startpunkt VektorA darstellen
            %plot3([StaPunktA(1),EndPunktA(1)],[StaPunktA(2),EndPunktA(2)],[HelixKar3(i,3),HelixKar3(i,3)],'k','LineWidth',2); %VektorA darstellen
            %Kanten darstellen
            %plot3([Liste3(25,1),Liste3(26,1)],[Liste3(25,2),Liste3(26,2)],[Liste3(25,3),Liste3(26,3)],'r','LineWidth',3);
            %plot3([Liste3(27,1),Liste3(28,1)],[Liste3(27,2),Liste3(28,2)],[Liste3(27,3),Liste3(28,3)],'b','LineWidth',3);
            %plot3([Liste3(29,1),Liste3(30,1)],[Liste3(29,2),Liste3(30,2)],[Liste3(29,3),Liste3(30,3)],'g','LineWidth',3);
            %scatter(Auswahl1(1,4),Auswahl1(1,5),50,'r')
            %Überschneidende und Angrenzende Kanten suchen und in Auswahl1 speichern
            WinkelA=atand(VektorA(2)/VektorA(1))+(VektorA(1)>=0)*180+90; %WinkelA berechnen
            Auswahl1=zeros(size(Liste3,1),6);
            AuswahlIndex=1;
            for j=1:2:size(Liste3,1)
                if j~=IndexA %VektorA nicht mit sich selber schneiden
                    StaPunktB=Liste3(j,1:2);
                    EndPunktB=Liste3(j+1,1:2);
                    VektorB=EndPunktB-StaPunktB;            
                    Nenner=(VektorA(1)*VektorB(2)-VektorA(2)*VektorB(1));
                    if Nenner<0.00000005&&Nenner>-0.00000005 %VektorB parallel zu VektorA
                        %disp('VektorB parallel zu VektorA'); 
                        if VektorA(2)>-0.000001&&VektorA(2)<0.000001 &&...
                                (StaPunktA(2)-0.00001)<StaPunktB(2)&&StaPunktB(2)<(StaPunktA(2)+0.00001)
                            l1=(StaPunktB(1)-StaPunktA(1))/(EndPunktA(1)-StaPunktA(1));
                            if l1>0.999999&&l1<1.000001
                                %disp('VektorA horizontal und parallel zu VektorB. StaPunktB liegt auf VektorA');
                                Auswahl1(AuswahlIndex,1:5)=[j,j+1,l1,StaPunktB];
                                AuswahlIndex=AuswahlIndex+1;
                            end
                            l3=(EndPunktB(1)-StaPunktA(1))/(EndPunktA(1)-StaPunktA(1));
                            if l3>0.999999&&l3<1.000001 
                                %disp('VektorA horizontal und parallel zu VektorB. EndPunktB liegt auf VektorA');
                                Auswahl1(AuswahlIndex,1:5)=[j,j+1,l3,EndPunktB];
                                AuswahlIndex=AuswahlIndex+1;
                            end
                        elseif VektorA(1)>-0.000001&&VektorA(1)<0.000001 &&...
                                (StaPunktA(1)-0.00001)<StaPunktB(1)&&StaPunktB(1)<(StaPunktA(1)+0.00001)         
                            l2=(StaPunktB(2)-StaPunktA(2))/(EndPunktA(2)-StaPunktA(2));                     
                            if l2>0.999999&&l2<1.000001
                                %disp('VektorA vertikal und parallel zu VektorB. StaPunktB liegt auf VektorA');
                                Auswahl1(AuswahlIndex,1:5)=[j,j+1,l2,StaPunktB];
                                AuswahlIndex=AuswahlIndex+1;
                            end
                            l4=(EndPunktB(2)-StaPunktA(2))/(EndPunktA(2)-StaPunktA(2));                       
                            if l4>0.999999&&l4<1.000001
                                %disp('VektorA vertikal und parallel zu VektorB. EndPunktB liegt auf VektorA');
                                Auswahl1(AuswahlIndex,1:5)=[j,j+1,l4,EndPunktB];
                                AuswahlIndex=AuswahlIndex+1; 
                            end
                        else   
                            l1=(StaPunktB(1)-StaPunktA(1))/(EndPunktA(1)-StaPunktA(1));
                            l2=(StaPunktB(2)-StaPunktA(2))/(EndPunktA(2)-StaPunktA(2));
                            l3=(EndPunktB(1)-StaPunktA(1))/(EndPunktA(1)-StaPunktA(1));
                            l4=(EndPunktB(2)-StaPunktA(2))/(EndPunktA(2)-StaPunktA(2));
                            if l1>0.999999&&l1<1.000001&&l2>0.999999&&l2<1.000001
                                %disp('VektorA parallel zu VektorB. StaPunktB liegt auf VektorA');
                                Auswahl1(AuswahlIndex,1:5)=[j,j+1,l1,StaPunktB];
                                AuswahlIndex=AuswahlIndex+1; 
                            elseif l3>0.999999&&l3<1.000001&&l4>0.999999&&l4<1.000001
                                %disp('VektorA parallel zu VektorB. EndPunktB liegt auf VektorA');
                                Auswahl1(AuswahlIndex,1:5)=[j,j+1,l3,EndPunktB];
                                AuswahlIndex=AuswahlIndex+1;
                            end
                        end
                    else %VektorB nicht parallel zu VektorA 
                        k=(VektorB(1)*(StaPunktA(2)-StaPunktB(2))+VektorB(2)*(StaPunktB(1)-StaPunktA(1)))/Nenner;
                        if k>0.00000001&&k<1.00000001 %Schnittpunkt liegt auf VektorA
                            I=StaPunktA+k*VektorA;
                            minx=min(StaPunktB(1),EndPunktB(1))-0.000000001;
                            maxx=max(StaPunktB(1),EndPunktB(1))+0.000000001;
                            miny=min(StaPunktB(2),EndPunktB(2))-0.000000001;
                            maxy=max(StaPunktB(2),EndPunktB(2))+0.000000001;
                            if (minx<I(1)&&I(1)<maxx)&&(miny<I(2)&&I(2)<maxy) %Schnittpunkt liegt auf VektorB
                                Auswahl1(AuswahlIndex,1:5)=[j,j+1,k,I];
                                AuswahlIndex=AuswahlIndex+1;
                            end
                        end
                    end
                end
            end
            Auswahl1(AuswahlIndex:end,:)=[]; %Leere Resteinträge löschen
            Auswahl1=sortrows(Auswahl1,3); %Auswahl nach k sortieren
            %Auswahl1 auswerten und korrekte Anschlusskante auswählen
            if isempty(Auswahl1)
                %disp('Keine Überschneidungen oder Anschlusskante'); 
                ZwiPunktA=StaPunktA;
                StaPunktA=EndPunktA;
                EndPunktA=ZwiPunktA;
                VektorA=-VektorA; %Vektor Umkehren
            elseif ~isempty(Auswahl1(Auswahl1(:,3)<=0.99999999))
                %disp('Intersektionspunkt exisitert');
                Auswahl2=Auswahl1(Auswahl1(:,3)<=(Auswahl1(1,3)+0.00000001),:);
                for j=1:size(Auswahl2,1) 
                    EndPunktB1=Liste3(Auswahl2(j,1),1:2);
                    EndPunktB2=Liste3(Auswahl2(j,2),1:2);
                    Intersect=Auswahl2(j,4:5);
                    if isequal((Intersect-0.0000001)<EndPunktB1&EndPunktB1<(Intersect+0.0000001),[1,1])
                        %disp('Intersectionspunkt fast identisch dem EndPunktB1. Neuer Vektor ist VektorB2');
                        VektorB2=EndPunktB2-Intersect;
                        WinkelB2=atand(VektorB2(2)/VektorB2(1))+(VektorB2(1)>=0)*180+90;
                        WinkelB2=mod(540+WinkelA-WinkelB2,360);
                        Auswahl2(j,6)=WinkelB2;  
                    elseif isequal((Intersect-0.0000001)<EndPunktB2&EndPunktB2<(Intersect+0.0000001),[1,1])
                        %disp('Intersectionspunkt fast identisch dem EndPunktB2. Neuer Vektor ist VektorB1');
                        VektorB1=EndPunktB1-Intersect;
                        WinkelB1=atand(VektorB1(2)/VektorB1(1))+(VektorB1(1)>=0)*180+90;
                        WinkelB1=mod(540+WinkelA-WinkelB1,360);
                        Auswahl2(j,6)=WinkelB1;
                        Auswahl2(j,1:2)=[Auswahl2(j,2),Auswahl2(j,1)]; %Indexeinträge vertauschen
                    else
                        VektorB1=EndPunktB1-Intersect;
                        WinkelB1=atand(VektorB1(2)/VektorB1(1))+(VektorB1(1)>=0)*180+90;
                        WinkelB1=mod(540+WinkelA-WinkelB1,360);
                        VektorB2=EndPunktB2-Intersect;
                        WinkelB2=atand(VektorB2(2)/VektorB2(1))+(VektorB2(1)>=0)*180+90;
                        WinkelB2=mod(540+WinkelA-WinkelB2,360);
                        if WinkelB1>WinkelB2
                            %disp('Neuer Vektor ist VektorB1');
                            Auswahl2(j,6)=WinkelB1;
                            Auswahl2(j,1:2)=[Auswahl2(j,2),Auswahl2(j,1)]; %Indexeinträge vertauschen
                        else
                            %disp('Neuer Vektor ist VektorB2');
                            Auswahl2(j,6)=WinkelB2;
                        end
                    end
                end
                [~,IndMaxW]=max(Auswahl2(:,6)); %Vektor mit grösstem Winkel auswählen 
                Intersect=Auswahl2(IndMaxW,4:5);
                StaPunktA=Intersect;
                EndPunktA=Liste3(Auswahl2(IndMaxW,2),1:2);
                VektorA=EndPunktA-Intersect;
                IndexA=min(Auswahl2(IndMaxW,1:2));
            elseif ~isempty(Auswahl1(Auswahl1(:,3)>0.99999999))
                %disp('Anschlusskante exisitert');
                Auswahl3=Auswahl1(Auswahl1(:,3)>0.99999999,:);
                for j=1:size(Auswahl3,1) %Winkel der Anschlussvektoren berechnen 
                    StaPunktB=Liste3(Auswahl3(j,1),1:2);
                    EndPunktB=Liste3(Auswahl3(j,2),1:2);
                    Intersect=Auswahl3(j,4:5);
                    if round(Intersect(1)*1000000)/1000000==round(StaPunktB(1)*1000000)/1000000&&...
                            round(Intersect(2)*1000000)/1000000==round(StaPunktB(2)*1000000)/1000000
                        %disp('Anschlusskante richtig ausgerichtet');
                        VektorB=EndPunktB-StaPunktB;
                        WinkelB=atand(VektorB(2)/VektorB(1))+(VektorB(1)>=0)*180+90;
                        WinkelB=mod(540+WinkelA-WinkelB,360);
                        Auswahl3(j,6)=WinkelB;  
                    elseif round(Intersect(1)*1000000)/1000000==round(EndPunktB(1)*1000000)/1000000&&...
                            round(Intersect(2)*1000000)/1000000==round(EndPunktB(2)*1000000)/1000000
                        %disp('Anschlusskante falsch ausgerichtet');
                        Auswahl3(j,1:2)=[Auswahl3(j,2),Auswahl3(j,1)]; %Indexeinträge vertauschen
                        VektorB=StaPunktB-EndPunktB;
                        WinkelB=atand(VektorB(2)/VektorB(1))+(VektorB(1)>=0)*180+90;
                        WinkelB=mod(540+WinkelA-WinkelB,360);
                        Auswahl3(j,6)=WinkelB;  
                    else
                        %disp('Anschlusskante wird zwischen StartPunkt noch Endpunkt touchiert');
                        VektorB1=EndPunktB-Intersect;
                        WinkelB1=atand(VektorB1(2)/VektorB1(1))+(VektorB1(1)>=0)*180+90;
                        WinkelB1=mod(540+WinkelA-WinkelB1,360);
                        VektorB2=StaPunktB-Intersect;
                        WinkelB2=atand(VektorB2(2)/VektorB2(1))+(VektorB2(1)>=0)*180+90;
                        WinkelB2=mod(540+WinkelA-WinkelB2,360);
                        if WinkelB1>WinkelB2
                            %disp('Neuer Vektor ist VektorB1');
                            Auswahl3(j,6)=WinkelB1;
                        else
                            %disp('Neuer Vektor ist VektorB2');
                            Auswahl3(j,6)=WinkelB2;
                            Auswahl3(j,1:2)=[Auswahl3(j,2),Auswahl3(j,1)]; %Indexeinträge vertauschen
                        end
                    end
                end
                [~,IndMaxW]=max(Auswahl3(:,6)); %Vektor mit grösstem Winkel auswählen 
                Intersect=Auswahl3(IndMaxW,4:5);
                StaPunktA=Intersect;
                EndPunktA=Liste3(Auswahl3(IndMaxW,2),1:2);
                VektorA=EndPunktA-Intersect;
                IndexA=min(Auswahl3(IndMaxW,1:2));
            end
        end  
        Innenkontur(InnenkonturIndex:end,:)=[]; %Resteinträge löschen       

        if ~isempty(Innenkontur)
            %Separation Nutgrundkontur und Nutdeckelkontur
            Start=1;
            MaxLength=0;
            for j=2:size(Innenkontur,1)
                if Innenkontur(j-1,3)<=1 && Innenkontur(j,3)>1 %StartPunkt gefunden
                    Start=j;
                elseif Innenkontur(j-1,3)>1 && Innenkontur(j,3)<=1 %EndPunkt gefunden
                    Ende=j;
                    if Ende-Start>MaxLength
                        MaxLength=Ende-Start;
                        StaIndex=Start;
                        EndIndex=Ende;
                    end
                end
            end
            Kontur=Innenkontur(StaIndex:EndIndex,1:2);
            Deckel=[Innenkontur(EndIndex:end,1:2);Innenkontur(1:StaIndex,1:2)];
            %figure
            %hold on
            %axis equal
            %plot(Kontur(:,1),Kontur(:,2),'k');
             
            %Fehlschlaufen Deckel entfernen
            Deckel(:,4)=1:size(Deckel,1);
            Deckel2=sortrows(Deckel,[1,2]); %Kontur nach koordinaten sortieren
            Delete=zeros(size(Deckel,1),1);
            for j=1:size(Deckel,1)-1
                if Deckel2(j,1)==Deckel2(j+1,1)&&Deckel2(j,2)==Deckel2(j+1,2)
                    Delete(Deckel2(j,4):Deckel2(j+1,4)-1)=1;
                end
            end
            Deckel3=Deckel(~Delete,1:2);
            Deckels{i,1}=Deckel3;
            %plot(Deckel3(:,1),Deckel3(:,2),'c');

            %Reihenfolge der Punkte anordnen
            if ~isempty(Kontur)
                if Rechtslaufend==1
                    %KontrOffset geht nach unten
                    if Kontur(1,1)<Kontur(end,1)
                        Kontur=flipud(Kontur);
                    end
                else %Linkslaufend
                    %KontrOffset geht nach oben
                    if Kontur(1,1)>Kontur(end,1)
                        Kontur=flipud(Kontur);
                    end
                end
            end
            Konturs{i,1}=Kontur;

            %Konturoffset Berechnen  
            OffsetEndMax=max([Deckel(:,2);Kontur(:,2)])-min([Deckel(:,2);Kontur(:,2)]);
            if OffsetEndMax<OffsetEnd
                OffsetEnd2=OffsetEndMax;
            else
                OffsetEnd2=OffsetEnd; 
            end
            KonturAbstand=OffsetStart:OffsetLength:OffsetEnd2; %Konturabstände definieren
            if ~isempty(KonturAbstand)
                Hatch1=F20_KonturOffset(Kontur,KonturAbstand);
                %Darstellen der Konturoffsets
                %for j=1:size(Hatch1,2)
                %    if ~isempty(Hatch1{1,j})
                %        plot(Hatch1{1,j}(:,1),Hatch1{1,j}(:,2),'r'); %Hatch1 darstellen
                %    end
                %end
                
                %Hatchenden verlängern oder verkürzen 
                Hatch2=Hatch1;
                Hatch3=Hatch1;
                Deckel4=Deckel3;
                for j=size(Hatch2,2):-1:1
                    if ~isempty(Hatch2{1,j})
                        %plot(Hatch1{1,j}(:,1),Hatch1{1,j}(:,2),'r'); %Hatch1 darstellen
                        %HatchEnden verlängern damit sie sicher mit Deckel überlagern
                        ErweiterungHatch=1;
                        StaVektor=Hatch2{1,j}(1,1:2)-Hatch2{1,j}(2,1:2);
                        StaVektor=StaVektor/(StaVektor(1)^2+StaVektor(2)^2)^0.5; 
                        Hatch2{1,j}(1,1:2)=Hatch2{1,j}(1,1:2)+StaVektor*ErweiterungHatch;
                        EndVektor=Hatch2{1,j}(end,1:2)-Hatch2{1,j}(end-1,1:2);
                        EndVektor=EndVektor/(EndVektor(1)^2+EndVektor(2)^2)^0.5;
                        Hatch2{1,j}(end,1:2)=Hatch2{1,j}(end,1:2)+EndVektor*ErweiterungHatch;
                        %plot(Hatch2{1,j}(:,1),Hatch2{1,j}(:,2),'m'); %Hatch2 darstellen
                        %DeckelEnden verlängern
                        ErweiterungDeckel=0.005;
                        StaVektor=Deckel3(1,1:2)-Deckel3(2,1:2);
                        StaVektor=StaVektor/(StaVektor(1)^2+StaVektor(2)^2)^0.5; 
                        Deckel4(1,1:2)=Deckel3(1,1:2)+StaVektor*ErweiterungDeckel;
                        EndVektor=Deckel3(end,1:2)-Deckel3(end-1,1:2);
                        EndVektor=EndVektor/(EndVektor(1)^2+EndVektor(2)^2)^0.5;
                        Deckel4(end,1:2)=Deckel3(end,1:2)+EndVektor*ErweiterungDeckel;
                        %plot(Deckel4(:,1),Deckel4(:,2),'g'); %Deckel4 darstellen
                        %HatchEnde bei Deckel abschneiden und um HatchVerlaengerung verlängern
                        [PosX,PosY,Pos]=polyxpoly(Hatch2{1,j}(:,1),Hatch2{1,j}(:,2),Deckel4(:,1),Deckel4(:,2));
                        %scatter(PosX,PosY,30,'k'); %Schnittpunkte darstellen
                        Schnittpunkte=size(Pos,1);
                        if Schnittpunkte==0
                            %disp('Keine Überschneidung'); 
                            Hatch3(:,j)=[];
                        elseif Schnittpunkte==1
                            %warndlg(['Nur eine Überschneidung in Hatch: ',num2str(i)]);
                            warning(['Nur eine Überschneidung in Hatch: ',num2str(i)]);
                            Hatch3(:,j)=[];
                            %{
                            if PosY>Hatch2{1,j}(Pos(1,1),2) %Überschneidung beim HatchStart
                                if Pos(1,1)>1
                                    Hatch3{1,j}(1:Pos(1,1)-1,:)=[]; %Unnötige Startpunkte entfernen
                                end
                                StaVektor=Hatch3{1,j}(1,1:2)-Hatch3{1,j}(2,1:2);
                                StaVektor=StaVektor/(StaVektor(1)^2+StaVektor(2)^2)^0.5;
                                Hatch3{1,j}(1,1:2)=[PosX(1),PosY(1)]+StaVektor*HatchVerlaengerung;
                            else %Überschneidung beim HatchEnde
                                if Pos(end,1)<size(Hatch3{1,j},1)-1
                                    Hatch3{1,j}(Pos(end,1)+2:end,:)=[]; %Unnötige Endpunkte entfernen
                                end
                                EndVektor=Hatch3{1,j}(end,1:2)-Hatch3{1,j}(end-1,1:2);
                                EndVektor=EndVektor/(EndVektor(1)^2+EndVektor(2)^2)^0.5;
                                Hatch3{1,j}(end,1:2)=[PosX(end),PosY(end)]+EndVektor*HatchVerlaengerung;
                            end
                            %}
                            %plot(Hatch3{1,j}(:,1),Hatch3{1,j}(:,2),'b'); %Hatch3 darstellen    
                        elseif Schnittpunkte>=2
                            %disp('Zwei oder mehr Überschneidungen');
                            if Pos(end,1)<size(Hatch3{1,j},1)-1
                                Hatch3{1,j}(round(Pos(end,1))+2:end,:)=[]; %Unnötige Endpunkte entfernen
                            end
                            if Pos(1,1)>1
                                Hatch3{1,j}(1:round(Pos(1,1))-1,:)=[]; %Unnötige Startpunkte entfernen
                            end
                            StaVektor=Hatch3{1,j}(1,1:2)-Hatch3{1,j}(2,1:2);
                            StaVektor=StaVektor/(StaVektor(1)^2+StaVektor(2)^2)^0.5;
                            Hatch3{1,j}(1,1:2)=[PosX(1),PosY(1)]+StaVektor*HatchVerlaengerung;
                            EndVektor=Hatch3{1,j}(end,1:2)-Hatch3{1,j}(end-1,1:2);
                            EndVektor=EndVektor/(EndVektor(1)^2+EndVektor(2)^2)^0.5;
                            Hatch3{1,j}(end,1:2)=[PosX(end),PosY(end)]+EndVektor*HatchVerlaengerung;
                            %plot(Hatch3{1,j}(:,1),Hatch3{1,j}(:,2),'b'); %Hatch3 darstellen
                        end
                    end
                end

                %kurze Hatchlängen von Punkten die nahe aufeinanderfolgen entfernen
                Hatch4=Hatch3;
                for j=1:size(Hatch4,2)
                    if ~isempty(Hatch4{1,j})
                        Delete=zeros(size(Hatch4{1,j},1),1);
                        E0=Hatch4{1,j}(1,1:2);
                        for m=2:size(Hatch4{1,j},1)-1
                            E1=Hatch4{1,j}(m,1:2);
                            Dist=((E1(1)-E0(1))^2+(E1(2)-E0(2))^2)^0.5; %Segmentlänge berechnen
                            if Dist<MinimalLaenge %Distanz zu kurz
                                %disp(['Kurzes Hatchsegment entfernt ',int2str(i),' ',int2str(j),' ',int2str(m)]);
                                Delete(m)=1;
                            else %Distanz genug lang
                                E0=E1;
                            end
                        end
                        if any(Delete)
                            Hatch4{1,j}(logical(Delete),:)=[];
                            %plot(Hatch4{1,j}(:,1),Hatch4{1,j}(:,2),'r'); %Hatch4 darstellen
                        end
                    end
                end
                Hatches(i,1:size(Hatch3,2))=Hatch4;
            end
        end
    else
        %disp('Kein Schattenwurf existiert')
        %BahnPunkte berechnen
        %Drehen um C-Achse
        WinkelC=HelixZyl(i,2);
        if Rechtslaufend==1
            winkel1=90-WinkelC;
        else %Linkslaufend
            winkel1=270-WinkelC;
        end
        winkel1=winkel1*pi/180; %Umrechnung Grad in Bogenmass
        BahnPunkt=HelixKar(i,1:3);
        BahnPunkt=[BahnPunkt(1),BahnPunkt(2)*cos(winkel1)-BahnPunkt(3)*sin(winkel1),BahnPunkt(2)*sin(winkel1)+BahnPunkt(3)*cos(winkel1)];
        %Drehen um B-Achse
        WinkelB=betas(i);
        winkel2=90-WinkelB;
        winkel2=winkel2*pi/180; %Umrechnung Grad in Bogenmass
        BahnPunkt=[BahnPunkt(1)*cos(winkel2)+BahnPunkt(3)*sin(winkel2),BahnPunkt(2),BahnPunkt(1)*-sin(winkel2)+BahnPunkt(3)*cos(winkel2)];
        BahnPunkte(i,1:3)=BahnPunkt;
    end
    if mod(i,round(iterationen/50))==0 %Ladebalken nicht bei jedem Schleifendurchlauf aktualisieren (Rechenleistung sparen)
        waitbar(i/iterationen) %Aktualisierung Ladebalken
    end
end
close(bar) %Ladebalken schliessen

end
