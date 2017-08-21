function [f2,v2] = F03_Transformation(f,v)
%F03_Transformation transformiert eine zylindrische Stl-Datei in eine
%kartesische (Abrollen)
%Imput Array v, enthält die Koordinaten der Eckpunkt der Dreiecke, aus
%denen das Stl-Objekt aufgebaut ist.
%imput Array f, enthält die Informationen, welche drei Eckpunkte vom Array
%v zu einem Dreieck verbunden werden müssen.
%Output Array v2, enthält die Koordinaten der transformierten Eckpunkt der 
%Dreiecke, aus denen das neue Stl-Objekt aufgebaut ist.
%Output Array f2, enthält die Informationen, welche drei Eckpunkte vom Array
%v2 zu einem Dreieck verbunden werden müssen.

%Koordinaten die nahe bei 0 oder 360Grad liegen runden
v(v(:,2)>-0.000001&v(:,2)<0.000001,2)=0;
v(v(:,2)>359.999999&v(:,2)<360.000001,2)=360;
v(v(:,1)>-0.000001&v(:,1)<0.000001,1)=0;

bar = waitbar(0,'Transformation wird durchgeführt...'); %Ladebalken erstellen
%Schritt 0: abschätzen wie viele Einträge das neue Array v2 braucht
%disp('Schritt 0');
%tic
AnzahlDreiecke=0;
for i=1:size(f,1)
    Dr=[v(f(i,1),:);v(f(i,2),:);v(f(i,3),:)]; %aktuelles Dreieck wir in Dr zwischengespeichert
    [~,ind]=sort(Dr(:,2),'descend');
    Dr=Dr(ind,:); %die drei Eckpunktkoordinaten sind nun absteigend nach den Y einträgen sortiert 
    if (Dr(1,2)>=0)&&(Dr(3,2)<=0) && max(Dr(:,3))>0 %Dreieck wird von y=0 Ebene gespalten und hat ein Eckpunkt mit positiven Z-Koordinaten
        if min(Dr(:,3))<=0 %Dreieck wird von z=0 Ebene gespalten
            %AnzahlDreiecke=AnzahlDreiecke;
        else
            %Spezielle Transformation mit Dreieckspaltung
            AnzahlDreiecke=AnzahlDreiecke+3;
        end
    else
        %Normale Transformation
        AnzahlDreiecke=AnzahlDreiecke+1;
    end
end
%toc

%Schritt 1: Koordinatentransformation und Dreiecke die die y=0 Ebene schneiden spalten
%disp('Schritt 1');
%tic
v2=zeros(AnzahlDreiecke*3,3);
iv2=[1 2 3];
for i=1:size(f,1) %Index, der durch die Dreiecke iteriert
    Dr1=[v(f(i,1),:);v(f(i,2),:);v(f(i,3),:)]; %aktuelles Dreieck wir in Dr2 zwischengespeichert
    [~,ind]=sort(Dr1(:,2),'descend');
    Dr2=Dr1(ind,:); %die drei Eckpunktkoordinaten sind nun absteigend nach den Y-Koordinaten sortiert 
    if (Dr2(1,2)>=0)&&(Dr2(3,2)<=0) && max(Dr2(:,3))>0 %Dreieck wird von y=0 Ebene gespalten und hat ein Eckpunkt mit positiven Z-Koordinaten
        if min(Dr2(:,3))<=0 %Dreieck wird von z=0 Ebene gespalten
            warning('Dreieck wird von z=0 und y=0 Ebene gespalten');
        else
            %Spezielle Transformationen
            hold on
            Dr3=[Dr2(:,1),atand(Dr2(:,3)./Dr2(:,2))+(Dr2(:,2)>=0).*-180+90,sqrt(Dr2(:,2).^2+Dr2(:,3).^2)];
            %plot3([Dr3(1,1),Dr3(2,1),Dr3(3,1),Dr3(1,1)],[Dr3(1,2),Dr3(2,2),Dr3(3,2),Dr3(1,2)],[Dr3(1,3),Dr3(2,3),Dr3(3,3),Dr3(1,3)],'k');
            if Dr2(2,2)<0 && Dr2(1,2)==0
                %disp('Fall A')
                Dr11=Dr3;
                %plot3([Dr11(1,1),Dr11(2,1),Dr11(3,1),Dr11(1,1)],[Dr11(1,2),Dr11(2,2),Dr11(3,2),Dr11(1,2)],[Dr11(1,3),Dr11(2,3),Dr11(3,3),Dr11(1,3)],'r');
                v2(iv2,:)=Dr11; %erstes Dreieck speichern
                iv2=iv2+3;
            elseif Dr2(3,2)<0 && Dr2(2,2)==0 && Dr2(1,2)==0
                %disp('Fall B')
                Dr11=Dr3;
                %plot3([Dr11(1,1),Dr11(2,1),Dr11(3,1),Dr11(1,1)],[Dr11(1,2),Dr11(2,2),Dr11(3,2),Dr11(1,2)],[Dr11(1,3),Dr11(2,3),Dr11(3,3),Dr11(1,3)],'r');
                v2(iv2,:)=Dr11; %erstes Dreieck speichern
                iv2=iv2+3;
            elseif Dr2(2,2)<0 && Dr2(1,2)>0 
                %disp('Fall C')
                E12=[Dr3(1,1)+((Dr3(2,1)-Dr3(1,1))*(-Dr3(1,2)))/(Dr3(2,2)-Dr3(1,2)),0,Dr3(1,3)+((Dr3(2,3)-Dr3(1,3))*(-Dr3(1,2)))/(Dr3(2,2)-Dr3(1,2))];
                E13=[Dr3(1,1)+((Dr3(3,1)-Dr3(1,1))*(-Dr3(1,2)))/(Dr3(3,2)-Dr3(1,2)),0,Dr3(1,3)+((Dr3(3,3)-Dr3(1,3))*(-Dr3(1,2)))/(Dr3(3,2)-Dr3(1,2))];
                Dr11=[[Dr3(1,1),Dr3(1,2)+360,Dr3(1,3)];[E13(1),360,E13(3)];[E12(1),360,E12(3)]];
                %plot3([Dr11(1,1),Dr11(2,1),Dr11(3,1),Dr11(1,1)],[Dr11(1,2),Dr11(2,2),Dr11(3,2),Dr11(1,2)],[Dr11(1,3),Dr11(2,3),Dr11(3,3),Dr11(1,3)],'r');
                v2(iv2,:)=Dr11; %erstes Dreieck speichern
                Dr22=[Dr3(3,:);Dr3(2,:);E13];
                %plot3([Dr22(1,1),Dr22(2,1),Dr22(3,1),Dr22(1,1)],[Dr22(1,2),Dr22(2,2),Dr22(3,2),Dr22(1,2)],[Dr22(1,3),Dr22(2,3),Dr22(3,3),Dr22(1,3)],'g');
                v2(iv2+3,:)=Dr22; %zweites Dreieck speichern
                Dr33=[Dr3(2,:);E12;E13];
                %plot3([Dr33(1,1),Dr33(2,1),Dr33(3,1),Dr33(1,1)],[Dr33(1,2),Dr33(2,2),Dr33(3,2),Dr33(1,2)],[Dr33(1,3),Dr33(2,3),Dr33(3,3),Dr33(1,3)],'b');
                v2(iv2+6,:)=Dr33; %drittes Dreieck speichern
                iv2=iv2+9;
            elseif Dr2(3,2)<0 && Dr2(2,2)==0 && Dr2(1,2)>0
                %disp('Fall D')
                E13=[Dr3(1,1)+((Dr3(3,1)-Dr3(1,1))*(-Dr3(1,2)))/(Dr3(3,2)-Dr3(1,2)),0,Dr3(1,3)+((Dr3(3,3)-Dr3(1,3))*(-Dr3(1,2)))/(Dr3(3,2)-Dr3(1,2))];
                Dr11=[Dr3(1,1),Dr3(1,2)+360,Dr3(1,3);Dr3(2,1),360,Dr3(2,3);E13(1),360,E13(3)];
                %plot3([Dr11(1,1),Dr11(2,1),Dr11(3,1),Dr11(1,1)],[Dr11(1,2),Dr11(2,2),Dr11(3,2),Dr11(1,2)],[Dr11(1,3),Dr11(2,3),Dr11(3,3),Dr11(1,3)],'r');
                v2(iv2,:)=Dr11; %erstes Dreieck speichern
                Dr22=[E13;Dr3(2,:);Dr3(3,:)];
                %plot3([Dr22(1,1),Dr22(2,1),Dr22(3,1),Dr22(1,1)],[Dr22(1,2),Dr22(2,2),Dr22(3,2),Dr22(1,2)],[Dr22(1,3),Dr22(2,3),Dr22(3,3),Dr22(1,3)],'g');
                v2(iv2+3,:)=Dr22; %zweites Dreieck speichern
                iv2=iv2+6;
            elseif Dr2(3,2)<0 && Dr2(2,2)>0
                %disp('Fall E')
                E13=[Dr3(1,1)+((Dr3(3,1)-Dr3(1,1))*(-Dr3(1,2)))/(Dr3(3,2)-Dr3(1,2)),0,Dr3(1,3)+((Dr3(3,3)-Dr3(1,3))*(-Dr3(1,2)))/(Dr3(3,2)-Dr3(1,2))];
                E23=[Dr3(2,1)+((Dr3(3,1)-Dr3(2,1))*(-Dr3(2,2)))/(Dr3(3,2)-Dr3(2,2)),0,Dr3(2,3)+((Dr3(3,3)-Dr3(2,3))*(-Dr3(2,2)))/(Dr3(3,2)-Dr3(2,2))];
                Dr11=[[Dr3(1,1),Dr3(1,2)+360,Dr3(1,3)];[E13(1),360,E13(3)];[Dr3(2,1),Dr3(2,2)+360,Dr3(2,3)]];
                %plot3([Dr11(1,1),Dr11(2,1),Dr11(3,1),Dr11(1,1)],[Dr11(1,2),Dr11(2,2),Dr11(3,2),Dr11(1,2)],[Dr11(1,3),Dr11(2,3),Dr11(3,3),Dr11(1,3)],'r');
                v2(iv2,:)=Dr11; %erstes Dreieck speichern
                Dr22=[[E13(1),360,E13(3)];[E23(1),360,E23(3)];[Dr3(2,1),Dr3(2,2)+360,Dr3(2,3)]];
                %plot3([Dr22(1,1),Dr22(2,1),Dr22(3,1),Dr22(1,1)],[Dr22(1,2),Dr22(2,2),Dr22(3,2),Dr22(1,2)],[Dr22(1,3),Dr22(2,3),Dr22(3,3),Dr22(1,3)],'g');
                v2(iv2+3,:)=Dr22; %zweites Dreieck speichern
                Dr33=[Dr3(3,:);E23;E13];
                %plot3([Dr33(1,1),Dr33(2,1),Dr33(3,1),Dr33(1,1)],[Dr33(1,2),Dr33(2,2),Dr33(3,2),Dr33(1,2)],[Dr33(1,3),Dr33(2,3),Dr33(3,3),Dr33(1,3)],'b');
                v2(iv2+6,:)=Dr33; %drittes Dreieck speichern
                iv2=iv2+9;
            elseif Dr2(3,2)==0 && Dr2(2,2)==0 && Dr2(1,2)>0
                %disp('Fall F')
                Dr11=[Dr3(1,1),Dr3(1,2)+360,Dr3(1,3);Dr3(2,1),360,Dr3(2,3);Dr3(3,1),360,Dr3(3,3)];
                %plot3([Dr11(1,1),Dr11(2,1),Dr11(3,1),Dr11(1,1)],[Dr11(1,2),Dr11(2,2),Dr11(3,2),Dr11(1,2)],[Dr11(1,3),Dr11(2,3),Dr11(3,3),Dr11(1,3)],'r');
                v2(iv2,:)=Dr11; %erstes Dreieck speichern
                iv2=iv2+3;
            elseif Dr2(3,2)==0 && Dr2(2,2)>0
                %disp('Fall G')
                Dr11=[Dr3(1,1),Dr3(1,2)+360,Dr3(1,3);Dr3(2,1),Dr3(2,2)+360,Dr3(2,3);Dr3(3,1),360,Dr3(3,3)];
                %plot3([Dr11(1,1),Dr11(2,1),Dr11(3,1),Dr11(1,1)],[Dr11(1,2),Dr11(2,2),Dr11(3,2),Dr11(1,2)],[Dr11(1,3),Dr11(2,3),Dr11(3,3),Dr11(1,3)],'r');
                v2(iv2,:)=Dr11; %erstes Dreieck speichern
                iv2=iv2+3;
            else
                disp('Fall X')
            end
        end
    else
        %Normale Transformation
        v2(iv2,:)=[v(f(i,:),1), atand(v(f(i,:),3)./v(f(i,:),2))+(v(f(i,:),2)>=0).*180+90, sqrt(v(f(i,:),2).^2+v(f(i,:),3).^2)];
        iv2=iv2+3;
    end
    if mod(i,round(AnzahlDreiecke/50))==0 %Ladebalken nicht bei jedem Schleifendurchlauf aktualisieren (Rechenleistung sparen)
        waitbar((i/AnzahlDreiecke)) %Aktualisierung Ladebalken
    end
end
v2(iv2(1):end,:)=[];
f2=[[1:3:iv2(1)-1]',[2:3:iv2(1)-1]',[3:3:iv2(1)-1]'];
%toc
%close(bar); %Ladebalken schliessen
delete(bar);

end