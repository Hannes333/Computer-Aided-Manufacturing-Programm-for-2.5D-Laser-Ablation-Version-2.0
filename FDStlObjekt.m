function [] = FDStlObjekt( DStlObjekt,fv )
%Funktion, die das Stl-objekt darstellt

if DStlObjekt==1
    %figure %Darstellung des STL-Objekts in neuem Grafikfenster
    hold on %Schreibe folgende Grafikbefehle in das geöffnete Grafikfenster
    patch(fv,'FaceColor',[0.2 0.8 0.8],'EdgeColor','none','FaceLighting','gouraud','AmbientStrength', 0.15,'FaceAlpha',0.35);
    camlight('headlight'); %Add a camera light
    material('dull'); %Tone down the specular highlighting
    axis('image'); %Fix the axes scaling
    axis tight %DarstellungsFeld so nahe am Objekt wie möglich
    %view([-40 50]); %Set a nice view angle
    versiontext=version;
    if str2double(versiontext(1:3))>=7.9 %ab 2014b neue Grafikplots
        %set(gcf, 'color', [1 1 1]) %figure color (gcf->figure settings)
        %set(gca, 'color', [1 1 1]) %axis color (gca->axis settings)
        %set(gca, 'Clipping', 'off');
        setAxes3DPanAndZoomStyle(zoom(gca),gca,'camera');
    end
end
    
end

