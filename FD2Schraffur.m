function []=FD2Schraffur(DSchraffur,d,Schraffuren,RadiusMax)
%Funktion, die die Schraffuren darstellt

if DSchraffur==1
    k=d; %Von dieser Ebene werden die Konturen dargestellt
    if ~isempty(Schraffuren{k,1})
        %bar = waitbar(0,'Schraffur wird dargestellt...'); %Ladebalken erstellen
        hold on %Schreibe folgende Grafikbefehle in das geöffnete Grafikfenster
        Heigth=Schraffuren{k}(1,3);
        SizeH=size(Schraffuren{k},1);
        yellowlines=zeros(2,size(Schraffuren{k},1),3);
        yellowlinesindex=1;
        bluelines=zeros(2,size(Schraffuren{k},1),3);
        bluelinesindex=1;
        greenlines=zeros(2,size(Schraffuren{k},1),3);
        greenlinesindex=1;
        redlines=zeros(2,size(Schraffuren{k},1),3);
        redlinesindex=1;
        orangelines=zeros(2,size(Schraffuren{k},1),3);
        orangelinesindex=1;
        yellowishlines=zeros(2,size(Schraffuren{k},1),3);
        yellowishlinesindex=1;
        tic
        for h=2:SizeH
            E1x=Schraffuren{k}(h-1,1); %X-Koordinate von Eckpunkt 1
            E1y=Schraffuren{k}(h-1,2); %Y-Koordinate von Eckpunkt 1
            E2x=Schraffuren{k}(h,1);   %X-Koordinate von Eckpunkt 2
            E2y=Schraffuren{k}(h,2);   %Y-Koordinate von Eckpunkt 2
            %Darstellung ohne Rolloverpunkte
            %RPxN=[E1x;E2x];
            %RPyN=[E1y;E2y];
            %RPzN=[Heigth;Heigth];        
            %Darstellung mit Rolloverpunkte
            RPy=[ceil(E1y/360)*360:360:floor(E2y/360)*360];
            if ~isempty(RPy) %Rolloverpunkte existieren und werden durch Interpolation berechnet
                RPx=E1x+(RPy-E1y)*(E2x-E1x)/(E2y-E1y);
                RPxN=zeros(2,length(RPx)+1);
                RPxN(1,2:end)=RPx;
                RPxN(2,1:end-1)=RPx;
                RPxN(1,1)=E1x;
                RPxN(2,end)=E2x;            
                RPyN=zeros(2,length(RPx)+1);
                RPyN(2,1:end-1)=360;
                RPyN(1,1)=mod(E1y,360);
                RPyN(2,end)=mod(E2y,360);
                RPzN=ones(2,length(RPx)+1)*Heigth;
            else %keine Rolloverpunkte exisiteren
                RPxN=[E1x;E2x];
                RPyN=[mod(E1y,360);mod(E2y,360)];
                RPzN=[Heigth;Heigth];
            end        
            if Schraffuren{k}(h,4)==0 %Eilgang
                yellowlines(1:2,yellowlinesindex:yellowlinesindex+size(RPxN,2)-1,1)=RPxN;
                yellowlines(1:2,yellowlinesindex:yellowlinesindex+size(RPyN,2)-1,2)=RPyN;
                yellowlines(1:2,yellowlinesindex:yellowlinesindex+size(RPzN,2)-1,3)=RPzN;
                yellowlinesindex=yellowlinesindex+size(RPxN,2);
                %plot3(RPxN,RPyN,RPzN,'y');
            elseif Schraffuren{k}(h,4)==1 || Schraffuren{k}(h,4)==4 %Laserlinie
                bluelines(1:2,bluelinesindex:bluelinesindex+size(RPxN,2)-1,1)=RPxN;
                bluelines(1:2,bluelinesindex:bluelinesindex+size(RPyN,2)-1,2)=RPyN;
                bluelines(1:2,bluelinesindex:bluelinesindex+size(RPzN,2)-1,3)=RPzN;
                bluelinesindex=bluelinesindex+size(RPxN,2);
                %plot3(RPxN,RPyN,RPzN,'b');
            elseif Schraffuren{k}(h,4)==2 %SkywriteStartLength
                greenlines(1:2,greenlinesindex:greenlinesindex+size(RPxN,2)-1,1)=RPxN;
                greenlines(1:2,greenlinesindex:greenlinesindex+size(RPyN,2)-1,2)=RPyN;
                greenlines(1:2,greenlinesindex:greenlinesindex+size(RPzN,2)-1,3)=RPzN;
                greenlinesindex=greenlinesindex+size(RPxN,2);
                %plot3(RPxN,RPyN,RPzN,'g');
            elseif Schraffuren{k}(h,4)==3 %SkywriteEndLength
                redlines(1:2,redlinesindex:redlinesindex+size(RPxN,2)-1,1)=RPxN;
                redlines(1:2,redlinesindex:redlinesindex+size(RPyN,2)-1,2)=RPyN;
                redlines(1:2,redlinesindex:redlinesindex+size(RPzN,2)-1,3)=RPzN;
                redlinesindex=redlinesindex+size(RPxN,2);
                %plot3(RPxN,RPyN,RPzN,'r');
            elseif Schraffuren{k}(h,4)==5 %Laserauslinie (Zwischenlinie)
                orangelines(1:2,orangelinesindex:orangelinesindex+size(RPxN,2)-1,1)=RPxN;
                orangelines(1:2,orangelinesindex:orangelinesindex+size(RPyN,2)-1,2)=RPyN;
                orangelines(1:2,orangelinesindex:orangelinesindex+size(RPzN,2)-1,3)=RPzN;
                orangelinesindex=orangelinesindex+size(RPxN,2);
                %plot3(RPxN,RPyN,RPzN,'Color',[1,0.65,0]);
            elseif Schraffuren{k}(h,4)==7 %Laserauslinie (Eilgang)
                yellowishlines(1:2,yellowishlinesindex:yellowishlinesindex+size(RPxN,2)-1,1)=RPxN;
                yellowishlines(1:2,yellowishlinesindex:yellowishlinesindex+size(RPyN,2)-1,2)=RPyN;
                yellowishlines(1:2,yellowishlinesindex:yellowishlinesindex+size(RPzN,2)-1,3)=RPzN;
                yellowishlinesindex=yellowishlinesindex+size(RPxN,2);
                %plot3(RPxN,RPyN,RPzN,'Color',[1,0.9,0]);
            end
            %if mod(h,round(SizeH/10))==0 %Ladebalken nicht bei jedem Schleifendurchlauf aktualisieren (Rechenleistung sparen)
            %    waitbar(h/SizeH); %Aktualisierung Ladebalken
            %end
        end
        toc
        tic
        yellowlines(:,yellowlinesindex:end,:)=[];
        plot3(yellowlines(:,:,1),yellowlines(:,:,2),yellowlines(:,:,3),'y');
        bluelines(:,bluelinesindex:end,:)=[];
        plot3(bluelines(:,:,1),bluelines(:,:,2),bluelines(:,:,3),'b');
        greenlines(:,greenlinesindex:end,:)=[];
        plot3(greenlines(:,:,1),greenlines(:,:,2),greenlines(:,:,3),'g');
        redlines(:,redlinesindex:end,:)=[];
        plot3(redlines(:,:,1),redlines(:,:,2),redlines(:,:,3),'r');
        orangelines(:,orangelinesindex:end,:)=[];
        plot3(orangelines(:,:,1),orangelines(:,:,2),orangelines(:,:,3),'color',[1,0.65,0]);
        yellowishlines(:,yellowishlinesindex:end,:)=[];
        plot3(yellowishlines(:,:,1),yellowishlines(:,:,2),yellowishlines(:,:,3),'color',[1,0.9,0]);
        %close(bar); %Ladebalken schliessen
        %view([0 90]); %Set a nice view angle
        %axis('image'); %Skalierung der Achsen fix
        daspect([1 (360/(2*pi*RadiusMax)) 1]) %Achsenskalierung von X- und Y-Achse
        axis tight %DarstellungsFeld so nahe am 3d Objekt wie möglich
        %set(gcf, 'visible', 'on');
        versiontext=version;
        if str2double(versiontext(1:3))>=9.1 %ab 2014b neue Grafikplots
            %set(gcf, 'color', [1 1 1]) %figure color (gcf->figure settings)
            %set(gca, 'color', [1 1 1]) %axis color (gca->axis settings)
            %set(gca, 'Clipping', 'off');
            setAxes3DPanAndZoomStyle(zoom(gca),gca,'camera');
        end
    end
end


end
