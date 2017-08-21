function []=FDUmrandung(DUmrandung,d,UmrandungKonturen)
%Darstellung der Umrandungskonturen in neuem Grafikfenster

if DUmrandung==1
    hold on %Schreibe folgende Grafikbefehle in das geöffnete Grafikfenster
    k=d; %Von dieser Ebene werden die Konturen dargestellt
    for i=1:size(UmrandungKonturen,2)
        if ~isempty(UmrandungKonturen{k,i})
            for h=1:size(UmrandungKonturen{k,i},1)-1
                if UmrandungKonturen{k,i}(h,4)==0 %Eilgang
                    plot3(UmrandungKonturen{k,i}(h:h+1,1),UmrandungKonturen{k,i}(h:h+1,2),UmrandungKonturen{k,i}(h:h+1,3),'y')
                elseif UmrandungKonturen{k,i}(h,4)==1 || UmrandungKonturen{k,i}(h,4)==4 %Lasering
                    plot3(UmrandungKonturen{k,i}(h:h+1,1),UmrandungKonturen{k,i}(h:h+1,2),UmrandungKonturen{k,i}(h:h+1,3),'b')
                elseif UmrandungKonturen{k,i}(h,4)==2 %SkywriteStartLength
                    plot3(UmrandungKonturen{k,i}(h:h+1,1),UmrandungKonturen{k,i}(h:h+1,2),UmrandungKonturen{k,i}(h:h+1,3),'g')
                elseif UmrandungKonturen{k,i}(h,4)==3 %SkywriteEndLength
                    plot3(UmrandungKonturen{k,i}(h:h+1,1),UmrandungKonturen{k,i}(h:h+1,2),UmrandungKonturen{k,i}(h:h+1,3),'r')
                end
            end
        end
    end
    %view([0 90]); %Set a nice view angle
    axis('image'); %Skalierung der Achsen fix
    axis tight %DarstellungsFeld so nahe am Objekt wie möglich
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

