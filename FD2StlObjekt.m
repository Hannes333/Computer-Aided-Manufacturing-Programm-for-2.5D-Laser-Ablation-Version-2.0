function [] = FD2StlObjekt( DStlObjekt,fv,farben,RadiusMax)
%Funktion, die das Stl-objekt darstellt

if DStlObjekt==1
    hold on %Schreibe folgende Grafikbefehle in das ge�ffnete Grafikfenster
    alpha(patch(fv,'FaceColor',farben,'EdgeColor','none','FaceLighting','gouraud','AmbientStrength',0.15),0.35);
    %patch(fv,'FaceColor',farben,'EdgeColor','none','FaceLighting','gouraud','AmbientStrength', 0.15,'FaceAlpha',0.35)
    set (gca,'Ydir','reverse');
    %camlight(0,180); %Lichtquelle hinzuf�gen
    material('dull'); %Obefl�chen matt
    daspect([1 (360/(2*pi*RadiusMax)) 1]) %Achsenskalierung von X- und Y-Achse
    axis tight %DarstellungsFeld so nahe am 3d Objekt wie m�glich
    %set(gcf, 'color', [1 1 1]) %figure color (gcf->figure settings)
    %set(gca, 'color', [1 1 1]) %axis color (gca->axis settings)
    %set(gca, 'Clipping', 'off');
    setAxes3DPanAndZoomStyle(zoom(gca),gca,'camera')
end
    
end

