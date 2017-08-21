function []=FDSchraffur(DSchraffur,d,Schraffuren)
%Funktion, die die Schraffuren darstellt

if DSchraffur==1
    hold on %Schreibe folgende Grafikbefehle in das geöffnete Grafikfenster
    k=d; %Von dieser Ebene werden die Konturen dargestellt
    
    yellowlines=zeros(2,size(Schraffuren{k},1),3);
    yellowlinesindex=1;
    bluelines=zeros(2,size(Schraffuren{k},1),3);
    bluelinesindex=1;
    greenlines=zeros(2,size(Schraffuren{k},1),3);
    greenlinesindex=1;
    redlines=zeros(2,size(Schraffuren{k},1),3);
    redlinesindex=1;
    for h=1:size(Schraffuren{k},1)-1
        if Schraffuren{k}(h,4)==0 %Eilgang
            yellowlines(1:2,yellowlinesindex,:)=Schraffuren{k}(h:h+1,1:3);
            yellowlinesindex=yellowlinesindex+1;
            %plot3(Schraffuren{k}(h:h+1,1),Schraffuren{k}(h:h+1,2),Schraffuren{k}(h:h+1,3),'y')
        elseif Schraffuren{k}(h,4)==1 || Schraffuren{k}(h,4)==4 %Lasering
            bluelines(1:2,bluelinesindex,:)=Schraffuren{k}(h:h+1,1:3);
            bluelinesindex=bluelinesindex+1;            
            %plot3(Schraffuren{k}(h:h+1,1),Schraffuren{k}(h:h+1,2),Schraffuren{k}(h:h+1,3),'b')
        elseif Schraffuren{k}(h,4)==2 %SkywriteStartLength
            greenlines(1:2,greenlinesindex,:)=Schraffuren{k}(h:h+1,1:3);
            greenlinesindex=greenlinesindex+1; 
            %plot3(Schraffuren{k}(h:h+1,1),Schraffuren{k}(h:h+1,2),Schraffuren{k}(h:h+1,3),'g')
        elseif Schraffuren{k}(h,4)==3 %SkywriteEndLength
            redlines(1:2,redlinesindex,:)=Schraffuren{k}(h:h+1,1:3);
            redlinesindex=redlinesindex+1;
            %plot3(Schraffuren{k}(h:h+1,1),Schraffuren{k}(h:h+1,2),Schraffuren{k}(h:h+1,3),'r')
        end
    end
    yellowlines(:,yellowlinesindex:end,:)=[];
    plot3(yellowlines(:,:,1),yellowlines(:,:,2),yellowlines(:,:,3),'y');
    bluelines(:,bluelinesindex:end,:)=[];
    plot3(bluelines(:,:,1),bluelines(:,:,2),bluelines(:,:,3),'b');
    greenlines(:,bluelinesindex:end,:)=[];
    plot3(greenlines(:,:,1),greenlines(:,:,2),greenlines(:,:,3),'g');
    redlines(:,redlinesindex:end,:)=[];
    plot3(redlines(:,:,1),redlines(:,:,2),redlines(:,:,3),'r');

    %view([0 90]); %Set a nice view angle
    axis tight %DarstellungsFeld so nahe am Objekt wie möglich
    axis('image'); %Skalierung der Achsen fix
    %set(gcf, 'visible', 'on')
    versiontext=version;
    if str2double(versiontext(1:3))>=9.1 %ab 2014b neue Grafikplots
        %set(gcf, 'color', [1 1 1]) %figure color (gcf->figure settings)
        %set(gca, 'color', [1 1 1]) %axis color (gca->axis settings)
        %set(gca, 'Clipping', 'off');
        setAxes3DPanAndZoomStyle(zoom(gca),gca,'camera');
    end
end

end

