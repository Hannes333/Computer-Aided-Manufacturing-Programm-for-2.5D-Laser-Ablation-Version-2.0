function [Hatches2,BahnPunkte2,Vorschub]=F53_NCCodeBerechnung(Hatches,BahnPunkte,...
    Umfangsabtrag,Zickzack,Zusammenfassen,Scangeschw,Jumpgeschw,VorschubCmax)
%Diese Funktion führt Berechnungen zum NC-Code durch. Für jedes
%Kontursegment wird die Länge und anhand der Scangeschwindigkeit die
%Bearbeitungszeit berechnet. Durch aufsummieren dieser Zeiten kann die
%Bearbeitungszeit für den gesammten Hatch berechnet werden. Wird der
%Maximale Vorschub der C-Achse überschritten, wird die erste Bahnstrecke
%langsamer abgefahren. Die Vorschübe für die Bearbeitung der mechanischen
%Achsen wird anhand der gegebenen Scangeschwindigkeiten und Scanlängen
%berechnet. Zudem werden für die mechanischen Achsen Interpolationspunkte
%zwischen den Bahnpunkten berechnet.

%NC-Code Berechnungen
bar = waitbar(0,'NC-Code wird berechnet...'); %Ladebalken erstellen
Hatches2=cell(size(Hatches));
%Zickzackarray=zeros(size(Hatches));
for i=1:size(Hatches,1)
    for j=1:size(Hatches,2)
        if ~isempty(Hatches{i,j})
            Hatches2{i,j}=zeros(size(Hatches{i,j},1),11);
            %Hatches in den optischen Nullpunkt verschieben 
            Hatches2{i,j}(:,1:2)=[Hatches{i,j}(:,1)-BahnPunkte(i,1),Hatches{i,j}(:,2)-BahnPunkte(i,2)];
            %Hatches auf 4 Nachkomastellen runden (NC-Code hat nur 4 Nachkommastellen)
            Hatches2{i,j}=round(Hatches2{i,j}*10000)/10000;
            %Bei Zickzackmodus wird die Scanrichtung bei jedem zweiten Hatch umgedreht
            if Zickzack==1 && mod(i+j,2)==1
                Hatches2{i,j}=flipud(Hatches2{i,j}); %Reihenfolge ändern
                %Zickzackarray(i,j)=1;           
            end
            %Linientyp hinzufügen
            Hatches2{i,j}(2:end,3)=1;
        end
    end
end
%BahnPunkte auf 4 Nachkommastellen runden (NC-Code hat nur 4 Nachkommastellen)
BahnPunkte2=round(BahnPunkte*10000)/10000;
%Hatches zusammenfassen
if size(Hatches2,2)>Zusammenfassen 
    for i=1:size(Hatches2,1)
        if ~isempty(Hatches2{i,Zusammenfassen})
            Hatches2{i,Zusammenfassen}=cell2mat(flipud(Hatches2(i,Zusammenfassen:end)'));
        end
    end
    Hatches2(:,Zusammenfassen+1:end)=[];
end
%Hatchlängen und Bearbeitungszeiten berechnen für Bahninterpolation
Vorschub=cell(size(Hatches2));
VorangehenderEndPunkt=[0,0];
iterationen=size(Hatches2,2);
for j=size(Hatches2,2):-1:1
    for i=1:size(Hatches2,1)
        if ~isempty(Hatches2{i,j})
            %Hatchsegmentlängen berechnen
            DeltaX=Hatches2{i,j}(2:end,1)-Hatches2{i,j}(1:end-1,1);
            DeltaY=Hatches2{i,j}(2:end,2)-Hatches2{i,j}(1:end-1,2);
            Hatches2{i,j}(2:end,4)=(DeltaX.^2+DeltaY.^2).^0.5;
            %Erste Hatchsegmentlänge vom vorangehenden HatchEndpunkt berechnen
            DeltaX=Hatches2{i,j}(1,1)-VorangehenderEndPunkt(1);
            DeltaY=Hatches2{i,j}(1,2)-VorangehenderEndPunkt(2);
            Hatches2{i,j}(1,4)=(DeltaX^2+DeltaY^2)^0.5;
            VorangehenderEndPunkt=Hatches2{i,j}(end,1:2);
            %Bearbeitungszeiten pro Hatchsegment
            Selection=Hatches2{i,j}(:,3);
            Hatches2{i,j}(Selection==1,5)=Hatches2{i,j}(Selection==1,4)./Scangeschw;
            Hatches2{i,j}(Selection==0,5)=Hatches2{i,j}(Selection==0,4)./Jumpgeschw;
            %Zwischenzeiten berechnen
            Hatches2{i,j}(1,6)=Hatches2{i,j}(1,5);
            for m=2:size(Hatches2{i,j},1)
                Hatches2{i,j}(m,6)=Hatches2{i,j}(m-1,6)+Hatches2{i,j}(m,5);
            end
            %Dominante Drehgeschwindigkeit berechnen
            TimeHatch=Hatches2{i,j}(end,6);
            TimeC=(BahnPunkte2(i+1,5)-BahnPunkte2(i,5))/VorschubCmax;
            Vorschub{i,j}=zeros(1,5);
            if TimeC>=TimeHatch
                %disp(['optischen Achsen schneller als Drehachse, Hatch: ',int2str(i),' ',int2str(j)])
                Hatches2{i,j}(:,6)=Hatches2{i,j}(:,6)+(TimeC-Hatches2{i,j}(end,6));
                Vorschub{i,j}(1,5)=VorschubCmax;
                Vorschub{i,j}(1,1)=abs(BahnPunkte2(i+1,1)-BahnPunkte2(i,1))/TimeC;
                Vorschub{i,j}(1,2)=abs(BahnPunkte2(i+1,2)-BahnPunkte2(i,2))/TimeC;
                Vorschub{i,j}(1,3)=abs(BahnPunkte2(i+1,3)-BahnPunkte2(i,3))/TimeC;
                Vorschub{i,j}(1,4)=abs(BahnPunkte2(i+1,4)-BahnPunkte2(i,4))/TimeC;
            else
                Vorschub{i,j}(1,5)=abs(BahnPunkte2(i+1,5)-BahnPunkte2(i,5))/TimeHatch;
                Vorschub{i,j}(1,1)=abs(BahnPunkte2(i+1,1)-BahnPunkte2(i,1))/TimeHatch;
                Vorschub{i,j}(1,2)=abs(BahnPunkte2(i+1,2)-BahnPunkte2(i,2))/TimeHatch;
                Vorschub{i,j}(1,3)=abs(BahnPunkte2(i+1,3)-BahnPunkte2(i,3))/TimeHatch;
                Vorschub{i,j}(1,4)=abs(BahnPunkte2(i+1,4)-BahnPunkte2(i,4))/TimeHatch;
            end
            %Bahninterpolation berechnen
            Interpolation=Hatches2{i,j}(:,6)/Hatches2{i,j}(end,6);
            Hatches2{i,j}(:,7)=BahnPunkte2(i,1)+Interpolation*(BahnPunkte2(i+1,1)-BahnPunkte2(i,1));
            Hatches2{i,j}(:,8)=BahnPunkte2(i,2)+Interpolation*(BahnPunkte2(i+1,2)-BahnPunkte2(i,2));
            Hatches2{i,j}(:,9)=BahnPunkte2(i,3)+Interpolation*(BahnPunkte2(i+1,3)-BahnPunkte2(i,3));
            Hatches2{i,j}(:,10)=BahnPunkte2(i,4)+Interpolation*(BahnPunkte2(i+1,4)-BahnPunkte2(i,4));
            Hatches2{i,j}(:,11)=BahnPunkte2(i,5)+Interpolation*(BahnPunkte2(i+1,5)-BahnPunkte2(i,5));
            %Bahninterpolationspunkte auf 4 Nachkommastellen runden
            Hatches2{i,j}(:,7:11)=round(Hatches2{i,j}(:,7:11)*10000)/10000;
        end
    end
    waitbar((iterationen-j)/iterationen) %Aktualisierung Ladebalken
end
close(bar)
%Bei Umfangsabtrag Werte für Drehachse nach jeder Umdrehung um 360° erhöhen
if Umfangsabtrag==1
    Rotationen=360;
    for j=size(Hatches2,2):-1:1
        for i=1:size(Hatches2,1)
            if ~isempty(Hatches2{i,j})
                Hatches2{i,j}(:,11)=Hatches2{i,j}(:,11)+Rotationen;
            end
        end
        Rotationen=Rotationen+360;    
    end
end
%Vorschübe auf 4 Nachkommastellen runden
for i=1:size(Vorschub,1)
    for j=1:size(Vorschub,2)
        if ~isempty(Vorschub{i,j})
            Vorschub{i,j}=round(Vorschub{i,j}*10000)/10000;
        end
    end
end


end