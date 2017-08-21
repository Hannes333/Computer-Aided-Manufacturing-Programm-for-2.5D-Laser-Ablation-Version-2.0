function []=FD2Schnittkontur(D,d,Konturen,RadiusMax)
%Funktion, die die Konturen darstellt

if D==1
    hold on %Schreibe folgende Grafikbefehle in das geöffnete Grafikfenster
    %for k=1:size(Konturen,1)
    k=d;
    for i=1:size(Konturen,2)
        if ~isempty(Konturen{k,i})
            plot3(Konturen{k,i}(:,1),Konturen{k,i}(:,2),Konturen{k,i}(:,3),'k')
        end
    end
    %end
    %axis('image'); %Skalierung der Achsen fix
    daspect([1 (360/(2*pi*RadiusMax)) 1]) %Achsenskalierung von X- und Y-Achse
    axis tight %DarstellungsFeld so nahe am 3d Objekt wie möglich
    %set(gcf, 'visible', 'on');
    versiontext=version;
    if str2double(versiontext(1:3))>=7.9 %ab 2014b neue Grafikplots
        %set(gcf, 'color', [1 1 1]) %figure color (gcf->figure settings)
        %set(gca, 'color', [1 1 1]) %axis color (gca->axis settings)
        %set(gca, 'Clipping', 'off');
        setAxes3DPanAndZoomStyle(zoom(gca),gca,'camera');
    end
end

end

