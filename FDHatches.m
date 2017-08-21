function FDHatches(HelixZyl,HelixKar,betas,v1,Nutgrund,Konturs,Deckels,Hatches,Rechtslaufend,d)

    i=d;
    WinkelC=HelixZyl(i,2);
    if Rechtslaufend==1
        winkel1=90-WinkelC;
    else %Linkdslaufend
        winkel1=270-WinkelC;
    end
    winkel1=winkel1*pi/180; %Umrechnung Grad in Bogenmass
    vv=v1(Nutgrund==1,:); %Flächeneckpunkte des Nutgrunds
    vv2=[vv(:,1),vv(:,2).*cos(winkel1)-vv(:,3).*sin(winkel1),vv(:,2).*sin(winkel1)+vv(:,3).*cos(winkel1)]; %Gedreht um x-Achse
    HelixKar2=[HelixKar(:,1),HelixKar(:,2).*cos(winkel1)-HelixKar(:,3).*sin(winkel1),HelixKar(:,2).*sin(winkel1)+HelixKar(:,3).*cos(winkel1)]; %Gedreht um x-Achse
    WinkelB=betas(i);
    winkel2=90-WinkelB;
    winkel2=winkel2*pi/180; %Umrechnung Grad in Bogenmass
    vv3=[vv2(:,1).*cos(winkel2)+vv2(:,3).*sin(winkel2),vv2(:,2),vv2(:,1).*-sin(winkel2)+vv2(:,3).*cos(winkel2)]; %Gedreht um y-Achse
    HelixKar3=[HelixKar2(:,1).*cos(winkel2)+HelixKar2(:,3).*sin(winkel2),HelixKar2(:,2),HelixKar2(:,1).*-sin(winkel2)+HelixKar2(:,3).*cos(winkel2)]; %Gedreht um y-Achse
    FD3StlObjekt(vv3,0); %Gedrehte Geometrie darstellen
    plot3(HelixKar3(:,1),HelixKar3(:,2),HelixKar3(:,3),'r'); %Aufgerollte Helix darstellen
    scatter3(HelixKar3(i,1),HelixKar3(i,2),HelixKar3(i,3),25,'r','filled'); %Aktueller Helixpunkt darstellen
    plot3(Konturs{i,1}(:,1),Konturs{i,1}(:,2),ones(size(Konturs{i,1},1),1)*HelixKar3(i,3),'k'); %Schattenwurf darstellen
    plot3(Deckels{i,1}(:,1),Deckels{i,1}(:,2),ones(size(Deckels{i,1},1),1)*HelixKar3(i,3),'c'); %Schattenwurfdeckel darstellen
    for j=1:size(Hatches(i,:),2)
        if ~isempty(Hatches{i,j})
            plot3(Hatches{i,j}(:,1),Hatches{i,j}(:,2),ones(size(Hatches{i,j},1))*HelixKar3(i,3),'b'); %Konturoffset darstellen
        end
    end
    versiontext=version;
    if str2double(versiontext(1:3))>=7.9 %ab 2014b neue Grafikplots
        %set(gcf, 'color', [1 1 1]) %figure color (gcf->figure settings)
        %set(gca, 'color', [1 1 1]) %axis color (gca->axis settings)
        %set(gca, 'Clipping', 'off');
        setAxes3DPanAndZoomStyle(zoom(gca),gca,'camera');
    end

end

