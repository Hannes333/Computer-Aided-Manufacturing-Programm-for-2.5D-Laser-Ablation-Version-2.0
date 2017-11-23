function F51_NCCode( Schraffuren,Titelpfad,NCText,VorschubDominant )
%F51_NCCode berechnet aus den Schraffuren den NC-Code
%Imput dieser Funktion ist das Cell Array Schraffuren. Jede Zeile in
%diesem Cell Array enthält die berechneten Schraffuren einer Schnittebene.
%In den ersten drei Spalten sind die x-, y- und z-Koordinaten der einzelnen
%Schraffurpunkte enthalten. In der vierten Spalte ist definiert um was für
%einen Linietyp es sich handelt. 
%0=Eilganglinie, die mit ausgeschaltetem Laser so schnell wie möglich 
%abgefahren werden kann (G00)
%1=Linie, die mit eingeschaltetem Laser mit Scangeschwindigkeit abgefahren
%werden kann  (G01)
%2=Skywritestartlinie, die mit ausgeschaltetem Laser mit
%Scangeschwindigkeit abgefahren werden kann (G01)
%3=Skywriteendlinie, die mit ausgeschaltetem Laser mit
%Scangeschwindigkeit abgefahren werden kann (G01)
%5=Linie, die mit ausgeschaltetem Laser abgefahren wird (Zwischenlinie)
%7=Linie, die mit ausgeschaltetem Laser abgefahren wird (Jumplinie)
%Der Imput Titelpfad gibt an, wo das erstellte Textfile gespeichert wird.
%Der Imput NCText ist ein Struct und enhält die CodeSchnipsel, aus denen
%sich der NC-Code zusammensetzt. Diese sind alle als Strings gespeichert.
%Der Imput VorschubDominant ist ein Array in dem die Drehgeschwindigkeit
%für jede Ebene gespeichert ist [°/s].

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

%CodeZeilen um die Bearbeitungshöhe anzusteuern wird zusammengesetzt
FokusString=[NCText.Fokus1,'%4.4f',NCText.Fokus2,'%4.4f',NCText.Fokus3,'%4.4f',NCText.Fokus4,'\r\n'];
%CodeZeilen um den Vorschub der Dominanten Achse anzugeben wird zusammengesetzt
VorschubString=[NCText.Vorschub1,'%4.4f',NCText.Vorschub2,'\r\n'];
%CodeZeilen für den Eilgang wird zusammengesetzt
EilgangString=[NCText.Eilgang1,'%4.4f',NCText.Eilgang2,'%4.4f',NCText.Eilgang3,'\r\n']; 
%CodeZeilen für den Laseraus wird zusammengesetzt
LaserausString=[NCText.Laseraus1,'%4.4f',NCText.Laseraus2,'%4.4f',NCText.Laseraus3,'\r\n']; 
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

bar = waitbar(0,'NC-Code wird berechnet...'); %Ladebalken erstellen
for k=1:size(Schraffuren,1) %Index, der durch die Ebenen iteriert
    if ~isempty(Schraffuren{k}) %Es gibt Schraffuren auf dieser Höhe
        %KommentarString1 einfügen
        fprintf(fid,KommentarString1,k);
        
        %Benutzerdefinierte Befehle zu Beginn der Ebene einfügen
        if ~isempty(NCText.EbeneSta1)
            fprintf(fid,[NCText.EbeneSta1,'\r\n']);
        end
        if ~isempty(NCText.EbeneSta2)
            fprintf(fid,[NCText.EbeneSta2,'\r\n']);
        end
        
        %CodeZeile zum Einstellen des Vorschubs der Dominanten Drehachse
        fprintf(fid,VorschubString,VorschubDominant(k));
     
        %Mit der Z-Achse den Fokus einstellen
        SchnittHoehe=Schraffuren{k}(1,3);
        Korrekturwert=abs(SchnittHoehe); %Bei zylindrischer Bearbeitung

        %Erster Punkt der Schraffur wird angefahren inklusive Fokuseinstellung
        fprintf(fid,LaseroffString);
        fprintf(fid,FokusString,[Schraffuren{k}(1,1:2),Korrekturwert]); 

        for h=2:size(Schraffuren{k},1)
            if Schraffuren{k}(h,4)==0 %Eilgang
                fprintf(fid,EilgangString,Schraffuren{k}(h,1:2)); 
            elseif Schraffuren{k}(h,4)==1 %Lasering without Skywrite
                fprintf(fid,LaseronString);
                fprintf(fid,LaserString,Schraffuren{k}(h,1:2)); 
                fprintf(fid,LaseroffString);
            elseif Schraffuren{k}(h,4)==2 %SkywriteStartLength
                fprintf(fid,SkywriteStartString,Schraffuren{k}(h,1:2)); 
            elseif Schraffuren{k}(h,4)==3 %SkywriteEndLength
                fprintf(fid,SkywriteEndString,Schraffuren{k}(h,1:2)); 
            elseif Schraffuren{k}(h,4)==5 %Laserauslinie (Zwischenlinie)
                fprintf(fid,LaserausString,Schraffuren{k}(h,1:2)); 
            elseif Schraffuren{k}(h,4)==7 %Laseauslinie (Eilgang)
                %fprintf(fid,'CRITICAL END \r\n');
                fprintf(fid,LaserausString,Schraffuren{k}(h,1:2));
                %fprintf(fid,'CRITICAL START \r\n');
            end     
        end
        
        %Benutzerdefinierte Befehle am Ende der Ebene einfügen
        if ~isempty(NCText.EbeneEnd1)
            fprintf(fid,[NCText.EbeneEnd1,'\r\n']);
        end
        if ~isempty(NCText.EbeneEnd2)
            fprintf(fid,[NCText.EbeneEnd2,'\r\n']);
        end
    end
    waitbar(k/size(Schraffuren,1)) %Aktualisierung Ladebalken
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