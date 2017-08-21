function [] = FD3StlObjekt( v,skalierung )
%Funktion, die das Stl-objekt darstellt

    farben=[0.7,0.7,0.7];

    n=size(v,1);
    %f=zeros(n/3,3);
    %f(:,1)=1:3:n;
    %f(:,2)=2:3:n;
    %f(:,3)=3:3:n;
    f=[[1:3:n]',[2:3:n]',[3:3:n]'];
    fv.vertices=v; %v enthält die Koordinaten der Eckpunkte
    fv.faces=f;  %f sagt, welche drei Eckpunkte aus v ein Dreieck bilden
    %figure %Darstellung des STL-Objekts in neuem Grafikfenster
    %hold on %Schreibe folgende Grafikbefehle in das geöffnete Grafikfenster
    alpha(patch(fv,'FaceColor',farben,'EdgeColor','none','FaceLighting','gouraud','AmbientStrength',1),0.5);
    %patch(fv,'FaceColor',farben,'EdgeColor','none','FaceLighting','gouraud','AmbientStrength',1);
    material('dull'); %Obeflächen matt
    camlight(0,0); %Lichtquelle hinzufügen
    axis tight %DarstellungsFeld so nahe am 3d Objekt wie möglich
    if skalierung==0
        %axis equal
        daspect([1 1 1]) %Achsenskalierung von X- und Y-Achse
    else %skalierung==1
        %set (gca,'Ydir','reverse');
        daspect([1 (360/(2*pi)) 1]) %Achsenskalierung von X- und Y-Achse
    end
    versiontext=version;
    if str2double(versiontext(1:3))>=7.9 %ab 2014b neue Grafikplots
        %set(gcf, 'color', [1 1 1]) %figure color (gcf->figure settings)
        %set(gca, 'color', [1 1 1]) %axis color (gca->axis settings)
        %set(gca, 'Clipping', 'off');
        setAxes3DPanAndZoomStyle(zoom(gca),gca,'camera');
    end
    
end