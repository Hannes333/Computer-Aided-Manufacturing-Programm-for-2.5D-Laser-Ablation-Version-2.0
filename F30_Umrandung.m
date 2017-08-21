function [ UmrandungKonturen,Bearbeitungszeit ] = F30_Umrandung( Konturen,UmrandungBreakangle,Skywritestart,Skywriteend,Scangeschw,Jumpgeschw)
%F30_Umrandung, berechnet aus den geschlossenen Konturen den Umrandungsweg
%der später vom Laser abgefahren wird.
%Imput ist das Cell Array Konturen. In diesem Cell
%Array enthält jede Zeile die geschlossenen Konturen einer Schnittebene.
%Jedes einzelnes Array vom Cell Array Konturen hat vier Spalten.
%In den ersten drei Spalten sind die x-, y- und z-Koordinaten der einzelnen
%Eckpunkte der geschlossenen Kontur. Werden diese Zeile für Zeile
%miteinander verbunden, entsteht eine geschlossene Kontur. 
%In der vierten Spalte jedes Arrays, ist die Dreiecksnummer der
%Stl-Datei gespeichert aus dem der Eckpunkt auf dieser Zeile entstanden
%ist.
%Der Imput UmrandungSkywrite gibt an, ob bei der Umrandung Skywrite
%berechnet werden soll (1=ja, 0=nein)
%Der Imput UmrandungBreakangle gibt an, ab welchem Winkel zwischen zwei
%Konturkanten Skywritelinien eingefügt werden sollen. 
%Skywritestart ist die Länge [mm], die die Skywritestarlinien haben sollen.
%Skywriteend ist die Länge [mm], die die Skywriteendlinien haben sollen.
%Der Output UmrandugKonturen ist ein Cell Array mit den berechenten
%Umrandungswegen. Jede Zeile in diesem Cell Array enthält die Umrandungen
%in der entsprechenden Schnittebene. Jedes einzelnes Array vom Cell Array 
%UmrandungKonturen hat vier Spalten.
%In den ersten drei Spalten sind die x-, y- und z-Koordinaten der einzelnen
%Punkte des Umrandungspfads gespeichert. Werden diese Zeile für Zeile
%miteinander verbunden, entsteht die Umrandung, die später abgefahren wird. 
%In der vierten Spalte ist definiert um was für einen Linietyp es sich handelt. 
%0=Eilganglinie, die mit ausgeschaltetem Laser so schnell wie möglich 
%abgefahren werden kann (G00)
%1=Linie, die mit eingeschaltetem Laser mit Scangeschwindigkeit abgefahren
%werden kann  (G01) (Skywrite ist nicht aktiv)
%2=Skywritestartlinie, die mit ausgeschaltetem Laser mit
%Scangeschwindigkeit abgefahren werden kann (G01)
%3=Skywriteendlinie, die mit ausgeschaltetem Laser mit
%Scangeschwindigkeit abgefahren werden kann (G01)
%4=Linie, die mit eingeschaltetem Laser mit Scangeschwindigkeit abgefahren
%werden kann (G01) (Skywrite ist aktiv)

UmrandungKonturen=cell(size(Konturen));
bar = waitbar(0,'Umrandungskonturen werden berechnet...'); %Ladebalken erstellen
Bearbeitungszeit=0;            
VorangehenderEndPunkt=[0,0];
for k=1:size(Konturen,1)
    for i=1:size(Konturen,2)
        if ~isempty(Konturen{k,i})
            if Skywritestart==0&&Skywriteend==0 %if UmrandungSkywrite==0
                UmrandungKonturen{k,i}=[[Konturen{k,i}(:,1:3);Konturen{k,i}(1,1:3)] ones(size(Konturen{k,i},1)+1,1)];
            else
                UmrandungKonturen{k,i}=[[Konturen{k,i}(:,1:3);Konturen{k,i}(1,1:3)] ones(size(Konturen{k,i},1)+1,1)];
                %Am Ende kommt sicherheitshalber ein Skywrite rein
                E1=UmrandungKonturen{k,i}(end-1,1:2);
                E2=UmrandungKonturen{k,i}(end,1:2);
                v2=E2-E1;
                v2=v2/norm(v2);
                E=E2+v2*Skywriteend;
                UmrandungKonturen{k,i}(end,4)=3;
                UmrandungKonturen{k,i}(end+1,[1:4])=[E,UmrandungKonturen{k,i}(1,3),0];
                %Am Anfang kommt sicherheitshalber ein Skywrite rein
                E1=UmrandungKonturen{k,i}(1,1:2);
                E2=UmrandungKonturen{k,i}(2,1:2);
                v2=E2-E1;
                v2=v2/norm(v2);
                S=E1-v2*Skywritestart;
                UmrandungKonturen{k,i}(2:end+1,:)=UmrandungKonturen{k,i}(1:end,:); %Block aufschieben
                UmrandungKonturen{k,i}(1,[1:2,4])=[S,2];
                p=3;
                while p<size(UmrandungKonturen{k,i},1)-1
                    v1=v2;
                    E0=E1;
                    E1=UmrandungKonturen{k,i}(p,1:2);
                    if p==size(UmrandungKonturen{k,i},1)
                        E2=UmrandungKonturen{k,i}(1,1:2);
                    else
                        E2=UmrandungKonturen{k,i}(p+1,1:2);
                    end
                    v2=E2-E1;
                    v2=v2/norm(v2);
                    alpha=180-acosd((-v1(1)*v2(1)-v1(2)*v2(2))/(norm(v1)*norm(v2)));
                    if alpha>UmrandungBreakangle
                        %scatter3(E1(1),E1(2),1,10,'r');
                        UmrandungKonturen{k,i}(p+3:end+3,:)=UmrandungKonturen{k,i}(p:end,:); %Block aufschieben
                        UmrandungKonturen{k,i}(p,4)=3;
                        E=E1+v1*Skywriteend;
                        UmrandungKonturen{k,i}(p+1,[1:2,4])=[E,0];
                        S=E1-v2*Skywritestart;
                        UmrandungKonturen{k,i}(p+2,[1:2,4])=[S,2];
                        p=p+3;
                    end
                    p=p+1;
                end
            end
            
            %Bearbeitungszeit abschätzen
            if Scangeschw~=0
                Bearbeitungszeit
                %Bearbeitungszeit Eilganglinie zwischen Linie berechnen
                DeltaX=VorangehenderEndPunkt(1)-UmrandungKonturen{k,i}(1,1);
                DeltaY=VorangehenderEndPunkt(2)-UmrandungKonturen{k,i}(1,2);
                Bearbeitungszeit=Bearbeitungszeit+(DeltaX^2+DeltaY^2)^0.5/Jumpgeschw;
                %Bearbeitungszeit auf der XLinie berechnen
                LengthTypTime=zeros(size(UmrandungKonturen{k,i},1)-1,4);
                LengthTypTime(:,1)=((UmrandungKonturen{k,i}(2:end,1)-UmrandungKonturen{k,i}(1:end-1,1)).^2+(UmrandungKonturen{k,i}(2:end,2)-UmrandungKonturen{k,i}(1:end-1,2)).^2).^0.5;
                LengthTypTime(:,2)=UmrandungKonturen{k,i}(1:end-1,4);
                LengthTypTime(LengthTypTime(:,2)==0,3)=Jumpgeschw;
                LengthTypTime(LengthTypTime(:,2)~=0,3)=Scangeschw;
                LengthTypTime(:,4)=LengthTypTime(:,1)./LengthTypTime(:,3);
                Bearbeitungszeit=Bearbeitungszeit+sum(LengthTypTime(:,4));
                VorangehenderEndPunkt=UmrandungKonturen{k,i}(end,1:2);
            end
            
        end
    end
    waitbar(k/size(Konturen,1)) %Aktualisierung Ladebalken
end
close(bar) %Ladebalken schliessen

end

