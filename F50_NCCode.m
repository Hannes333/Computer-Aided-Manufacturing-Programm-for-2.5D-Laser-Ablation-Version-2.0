function F50_NCCode(  Schraffuren,Titelpfad,UmrandungKonturen,NCText )
%F51_NCCode berechnet aus den Schraffuren den NC-Code
%Imput dieser Funktion ist das Cell Array Schraffuren. Jede Zeile in
%diesem Cell Array enthält die berechneten Schraffuren einer Schnittebene.
%In den ersten drei Spalten sind die x-, y- und z-Koordinaten der einzelnen
%Schraffurpunkte enthalten. In der vierten Spalte ist definiert um was für
%einen Linietyp es sich handelt. 
%0=Eilganglinie, die mit ausgeschaltetem Laser so schnell wie möglich 
%abgefahren werden kann (G00)
%1=Linie, die mit eingeschaltetem Laser mit Scangeschwindigkeit abgefahren
%werden kann (G01) (Skywrite ist nicht aktiv)
%2=Skywritestartlinie, die mit ausgeschaltetem Laser mit
%Scangeschwindigkeit abgefahren werden kann (G01)
%3=Skywriteendlinie, die mit ausgeschaltetem Laser mit
%Scangeschwindigkeit abgefahren werden kann (G01)
%4=Linie, die mit eingeschaltetem Laser mit Scangeschwindigkeit abgefahren
%werden kann (G01) (Skywrite ist aktiv)
%Der Input UmrandugKonturen ist ein Cell Array mit den berechenten
%Umrandungswegen. Jede Zeile in diesem Cell Array enthält die Umrandungen
%in der entsprechenden Schnittebene, die vom Laser abgefahren wird.
%Der Imput Zoben ist der Höchste Punkt der Stl-Datei
%Der Imput Schichtdicke gibt an, welchen Abstand die einzelnen Schichten
%zueinander haben.
%Zoben und Schichtdicke werden benötigt um den Fokuspunkt im NC-Code zu
%berechnen
%Der Imput Titelpfad gibt an, wo das erstellte Textfile gespeichert wird.
%Der Imput NCText ist ein Struct und enhält die CodeSchnipsel, aus denen
%sich der NC-Code zusammensetzt. Diese sind alle als Strings gespeichert

%fid = fopen(Titelpfad, 'w'); %Ein neues txt-file wird geöffnet
fid = fopen(Titelpfad, 'W'); %Ein neues txt-file wird geöffnet

%Header wird ins Textfile eingefügt
if ~isempty(NCText.Header1)
    fprintf(fid,[NCText.Header1,'\r\n']);
end
if ~isempty(NCText.Header2)
    fprintf(fid,[NCText.Header2,'\r\n']);
end 
if ~isempty(NCText.Header3)
    fprintf(fid,[NCText.Header3,'\r\n']);
end        
if ~isempty(NCText.Header4)
    fprintf(fid,[NCText.Header4,'\r\n']);
end
if ~isempty(NCText.Header5)
    fprintf(fid,[NCText.Header5,'\r\n']);
end
if ~isempty(NCText.Header6)
    fprintf(fid,[NCText.Header6,'\r\n']);
end
if ~isempty(NCText.Header7)
    fprintf(fid,[NCText.Header7,'\r\n']);
end 
if ~isempty(NCText.Header8)
    fprintf(fid,[NCText.Header8,'\r\n']);
end        
if ~isempty(NCText.Header9)
    fprintf(fid,[NCText.Header9,'\r\n']);
end
if ~isempty(NCText.Header10)
    fprintf(fid,[NCText.Header10,'\r\n']);
end
if ~isempty(NCText.Header11)
    fprintf(fid,[NCText.Header11,'\r\n']);
end

%CodeZeilen um die Bearbeitungshöhe anzusteuern wird zusammengesetzt
FokusString=[NCText.Fokus1,'%4.4f',NCText.Fokus2,'\r\n'];
%CodeZeilen für den Eilgang wird zusammengesetzt
EilgangString=[NCText.Eilgang1,'%4.4f',NCText.Eilgang2,'%4.4f',NCText.Eilgang3,'\r\n']; 
%CodeZeilen für eine Startskywritelinie wird zusammengesetzt
SkywriteStartString=[NCText.StartSky1,'%4.4f',NCText.StartSky2,'%4.4f',NCText.StartSky3,'\r\n']; 
%CodeZeilen für eine Laserbearbeitungslinie wird zusammengesetzt
LaserString=[NCText.Laser1,'%4.4f',NCText.Laser2,'%4.4f',NCText.Laser3,'\r\n']; 
%CodeZeilen für eine Endskywritelinie wird zusammengesetzt
SkywriteEndString=[NCText.EndSky1,'%4.4f',NCText.EndSky2,'%4.4f',NCText.EndSky3,'\r\n']; 
%CodeZeilen um den Laser einzuschalten wird zusammengesetzt
if isempty(NCText.Laseron)
    LaseronString='';
else
    LaseronString=[NCText.Laseron,'\r\n'];
end
%CodeZeilen um den Laser auszuschalten wird zusammengesetzt
if isempty(NCText.Laseroff)
    LaseroffString='';
else
    LaseroffString=[NCText.Laseroff,'\r\n'];
end
%CodeZeilen für die Auskommentierung wird zusammengesetzt
KommentarString1=[NCText.Kommentar1,'################### Ebene %1.0f ####################',NCText.Kommentar2,'\r\n'];
KommentarString2=[NCText.Kommentar1,'######## Ebene %1.0f Kontur %1.0f ########',NCText.Kommentar2,'\r\n'];
KommentarString3=[NCText.Kommentar1,'######## Ebene %1.0f Schraffuren ########',NCText.Kommentar2,'\r\n'];

bar = waitbar(0,'NC-Code wird berechnet...'); %Ladebalken erstellen
for k=1:size(UmrandungKonturen,1) %Index, der durch die Ebenen iteriert
    if isempty(UmrandungKonturen{k,1}) && isempty(Schraffuren{k})
        %Es gibt weder UmrandungKonturen noch Schraffuren auf dieser Höhe
    else
        fprintf(fid,KommentarString1,k);
        %Mit der Z-Achse den Fokus einstellen
        if isempty(UmrandungKonturen{k,1})
            SchnittHoehe=Schraffuren{k}(1,3);
        else
            SchnittHoehe=UmrandungKonturen{k,1}(1,3);
        end
        %Korrekturwert=abs(SchnittHoehe+Schichtdicke/2-Stloben);
        Korrekturwert=SchnittHoehe;
        %CodeZeile zur Asteuerung der Bearbeitungshöhe
        fprintf(fid,FokusString,Korrekturwert); 
            
        %NC-Code für UmrandungKonturen wird erstellt
        for i=1:size(UmrandungKonturen,2)
            if ~isempty(UmrandungKonturen{k,i})
                fprintf(fid,KommentarString2,[k,i]);
                
                %Erster Punkt der Umrandungskontur wird angefahren, normaler Eilgang
                fprintf(fid,LaseroffString);
                fprintf(fid,EilgangString,UmrandungKonturen{k,i}(1,1:2)); 
                
                %Erster Punkt der Umrandungskontur wird angefahren (Bei Aerotech teils besser)
                %fprintf(fid,LaseroffString);
                %fprintf(fid,LaserString,UmrandungKonturen{k,i}(1,1:2)); 
                
                if UmrandungKonturen{k,i}(1,4)==1 %Beim ersten Punkt muss schon gelasert werden 
                    fprintf(fid,LaseronString);
                end
                for h=2:size(UmrandungKonturen{k,i},1)
                    if UmrandungKonturen{k,i}(h-1,4)==0 %Eilgang
                        fprintf(fid,EilgangString,UmrandungKonturen{k,i}(h,1:2)); 
                    elseif UmrandungKonturen{k,i}(h-1,4)==1 %Lasering
                        fprintf(fid,LaserString,UmrandungKonturen{k,i}(h,1:2)); 
                    elseif UmrandungKonturen{k,i}(h-1,4)==2 %SkywriteStartLength
                        fprintf(fid,SkywriteStartString,UmrandungKonturen{k,i}(h,1:2)); 
                        fprintf(fid,LaseronString);
                    elseif UmrandungKonturen{k,i}(h-1,4)==3 %SkywriteEndLength
                        fprintf(fid,LaseroffString);
                        fprintf(fid,SkywriteEndString,UmrandungKonturen{k,i}(h,1:2)); 
                    end    
                end
                fprintf(fid,LaseroffString);
            end
        end
        
        % NC-Code für Schraffuren wird erstellt
        if ~isempty(Schraffuren{k})
            fprintf(fid,KommentarString3,k);
            
            %Erster Punkt der Schraffur wird angefahren, normaler Eilgang 
            fprintf(fid,LaseroffString);
            fprintf(fid,EilgangString,Schraffuren{k}(1,1:2)); 
            
            %Erster Punkt der Schraffur wird angefahren (Bei Aerotech teils besser)
            %fprintf(fid,LaseroffString);
            %fprintf(fid,LaserString,Schraffuren{k}(1,1:2));
            
            for h=2:size(Schraffuren{k},1)
                if Schraffuren{k}(h-1,4)==0 %Eilgang
                    fprintf(fid,EilgangString,Schraffuren{k}(h,1:2)); 
                elseif Schraffuren{k}(h-1,4)==1 %Lasering without Skywrite
                    fprintf(fid,LaseronString);
                    fprintf(fid,LaserString,Schraffuren{k}(h,1:2)); 
                    fprintf(fid,LaseroffString);
                elseif Schraffuren{k}(h-1,4)==2 %SkywriteStartLength
                    fprintf(fid,SkywriteStartString,Schraffuren{k}(h,1:2)); 
                elseif Schraffuren{k}(h-1,4)==3 %SkywriteEndLength
                    fprintf(fid,SkywriteEndString,Schraffuren{k}(h,1:2)); 
                elseif Schraffuren{k}(h-1,4)==4 %Lasering with Skywrite
                    fprintf(fid,LaseronString);                    
                    fprintf(fid,LaserString,Schraffuren{k}(h,1:2)); 
                    fprintf(fid,LaseroffString);
                end    
            end
        end
    end
    waitbar(k/size(UmrandungKonturen,1)) %Aktualisierung Ladebalken
end
close(bar) %Ladebalken schliessen

%Abschluss des NC-Codes
if ~isempty(NCText.Finish1)
    fprintf(fid,[NCText.Finish1,'\r\n']);
end
if ~isempty(NCText.Finish2)
    fprintf(fid,[NCText.Finish2,'\r\n']);
end 
if ~isempty(NCText.Finish3)
    fprintf(fid,[NCText.Finish3,'\r\n']);
end        
if ~isempty(NCText.Finish4)
    fprintf(fid,[NCText.Finish4,'\r\n']);
end
if ~isempty(NCText.Finish5)
    fprintf(fid,[NCText.Finish5,'\r\n']);
end

fclose(fid); %txt-file wird geschlossen

end