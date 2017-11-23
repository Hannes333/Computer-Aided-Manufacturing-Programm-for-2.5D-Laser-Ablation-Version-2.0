function F54_NCCodeSynchron(Hatches2,BahnPunkte,Titelpfad,NCText,Vorschub,Umfangsabtrag,LaserOnOffalle)
%F54_NCCode berechnet aus den Hatches den NC-Code und erstellt ein Textfile
%Imput dieser Funktion ist das Cell Array Hatches2. 
%Der Imput Titelpfad gibt an, wo das erstellte Textfile gespeichert wird.
%Der Imput NCText ist ein Struct und enhält die CodeSchnipsel, aus denen
%sich der NC-Code zusammensetzt. Diese sind alle als Strings gespeichert.

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
if ~isempty(NCText.Header12)
    fprintf(fid,[NCText.Header12,'\r\n']);
end

%CodeZeilen um den ersten Bahnpunkt anzufahren wird zusammengesetzt
BahnPunktString=[NCText.BahnPunktSta,NCText.C,'%4.4f',NCText.X,'%4.4f',NCText.Y,'%4.4f',NCText.Z,'%4.4f',NCText.B,'%4.4f',NCText.BahnPunktEnd,'\r\n']; 
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
KommentarString1=[NCText.Kommentar1,'############# Hatchreihe %1.0f #############',NCText.Kommentar2,'\r\n'];
KommentarString2=[NCText.Kommentar1,'##### Hatch %1.0f-%1.0f #####',NCText.Kommentar2,'\r\n'];

%CodeZeilen um den Vorschub der Dominanten Achse anzugeben wird zusammengesetzt
VorschubString=[NCText.Vorschub1,'%4.4f',NCText.Vorschub2,'\r\n'];
%Teilstrings zusammensetzten 
StringSta=[NCText.LaserSta,NCText.C,'%4.4f'];
Stringu=[NCText.u,'%4.4f'];
Stringv=[NCText.v,'%4.4f'];
StringB=[NCText.B,'%4.4f'];
StringX=[NCText.X,'%4.4f'];
StringY=[NCText.Y,'%4.4f'];
StringZ=[NCText.Z,'%4.4f'];
StringEnd=[NCText.LaserEnd,'\r\n'];

bar = waitbar(0,'NC-Code wird erstellt...'); %Ladebalken erstellen
if Umfangsabtrag==1
    fprintf(fid,BahnPunktString,[BahnPunkte(1,5)+360,BahnPunkte(1,1:4)]); %Erster BahnPunktString
end
for j=size(Hatches2,2):-1:1 %Durch Hatchreihen (Kolonen) iterieren
    set(get(findobj(bar,'type','axes'),'title'),'string',['NC-Code Hatchreihe ',int2str(j),' wird erstellt']); %Text des Ladebalken aktualisieren
    fprintf(fid,KommentarString1,j); %KommentarZeile1
    if ~isempty(NCText.EbeneSta1)
        fprintf(fid,[NCText.EbeneSta1,'\r\n']); %Benutzerbefehl 1 zu Beginn
    end
    if ~isempty(NCText.EbeneSta2)
        fprintf(fid,[NCText.EbeneSta2,'\r\n']); %Benutzerbefehl 2 zu Beginn
    end
    Hatchreihenstart=1;
    iterationen=size(Hatches2,1);
    for i=1:iterationen %Durch Hatches (Zeilen) iterieren
        if ~isempty(Hatches2{i,j})
            if Hatchreihenstart==1 %Hatchreihenstart
                Hatchreihenstart=0;
                if Umfangsabtrag==0
                    fprintf(fid,BahnPunktString,[BahnPunkte(i,5),BahnPunkte(i,1:4)]); %Erster BahnPunktString
                    PosXalt=BahnPunkte(i,1);
                    PosYalt=BahnPunkte(i,2);
                    PosZalt=BahnPunkte(i,3);
                    PosBalt=BahnPunkte(i,4);
                end
                if LaserOnOffalle==0 %Laser beim Hatchreihenstart einschalten
                    fprintf(fid,LaseronString); %Laserein
                end 
            end
            fprintf(fid,KommentarString2,[j,i]); %KommentarZeile2 
            fprintf(fid,VorschubString,Vorschub{i,j}(1,5)); %Vorschub Drehachse
            for h=1:size(Hatches2{i,j},1) %Durch HatchLinien iterieren
                if Hatches2{i,j}(h,3)==0 && h~=1 %Vor Laserauslinie Laser ausschalten
                    if LaserOnOffalle==1
                        fprintf(fid,LaseroffString); %Laseraus
                    end
                end
                fprintf(fid,StringSta,Hatches2{i,j}(h,11)); %Anfangstring und C-Achse
                fprintf(fid,Stringu,Hatches2{i,j}(h,1)); %u-Achse
                fprintf(fid,Stringv,Hatches2{i,j}(h,2)); %v-Achse
                if Umfangsabtrag==0
                    PosBneu=Hatches2{i,j}(h,10);
                    if PosBalt~=PosBneu
                        fprintf(fid,StringB,Hatches2{i,j}(h,10)); %B-Achse
                        PosBalt=PosBneu;
                    end
                    PosXneu=Hatches2{i,j}(h,7);
                    if PosXalt~=PosXneu
                        fprintf(fid,StringX,Hatches2{i,j}(h,7)); %X-Achse
                        PosXalt=PosXneu;
                    end
                    PosYneu=Hatches2{i,j}(h,8);
                    if PosYalt~=PosYneu
                        fprintf(fid,StringY,Hatches2{i,j}(h,8)); %Y-Achse
                        PosYalt=PosYneu;
                    end
                    PosZneu=Hatches2{i,j}(h,9);
                    if PosZalt~=PosZneu
                        fprintf(fid,StringZ,Hatches2{i,j}(h,9)); %Z-Achse
                        PosZalt=PosZneu;
                    end
                end
                fprintf(fid,StringEnd); %Endstring
                if Hatches2{i,j}(h,3)==0 %Hinter Laserauslinie Laser einschalten
                    if LaserOnOffalle==1
                        fprintf(fid,LaseronString); %Laserein
                    end
                end
            end
            if LaserOnOffalle==1 %Laser beim Hatchende ausschalten
                fprintf(fid,LaseroffString); %Laseraus
            end
        end
        if mod(i,round(iterationen/50))==0 %Ladebalken nicht bei jedem Schleifendurchlauf aktualisieren (Rechenleistung sparen)
            waitbar(i/iterationen) %Aktualisierung Ladebalken
        end
    end
    if LaserOnOffalle==0 %Laser beim Hatchreihenende ausschalten
        fprintf(fid,LaseroffString); %Laseraus
    end
    if ~isempty(NCText.EbeneEnd1)
        fprintf(fid,[NCText.EbeneEnd1,'\r\n']); %Benutzerbefehl 1 am Ende
    end
    if ~isempty(NCText.EbeneEnd2)
        fprintf(fid,[NCText.EbeneEnd2,'\r\n']); %Benutzerbefehl 2 am Ende
    end
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