function [ Kontur ] = F20_Strahlkomp( Kontur,n,KonturAbstand )
%F20_Strahlkomp berechnet aus der imput Kontur eine kleinere um 
%einen KonturAbstand nach Innen verschobene Kleinere Kontur
%Imput Kontur ist ein Cell Array.
%Jedes einzelne Array vom Cell Array Kontur hat vier Spalten.
%In den ersten drei Spalten sind die x-, y- und z-Koordinaten der einzelnen
%Eckpunkte der geschlossenen Kontur. Werden diese Zeile für Zeile
%miteinander verbunden, entsteht eine geschlossene Kontur. 
%In der vierten Spalte jedes Arrays, ist die Dreiecksnummer der
%Stl-Datei gespeichert aus dem der Eckpunkt auf dieser Zeile entstanden
%ist.
%Imput Array n enthält die Richtungskoordinaten der Normalenvektoren
%Imput KoturAbstand [mm] ist der Abstand, um der die ursprüngliche Kontur
%verkleinert und jede Kante nach Innen verschoben wird.
%Output Kontur hat genau das selbe format wie Imput Kontur

%{
figure %Darstellung der Aussenkontur vor der Strahlkompensation
hold on %Schreibe folgende Grafikbefehle in das geöffnete Grafikfenster
for i=1:size(Kontur,2) %Index, der durch die Teilkonturen von Kontur geht
    if ~isempty(Kontur{i})
        if ~isempty(Kontur{i})
            plot3([Kontur{i}(:,1);Kontur{i}(1,1)],[Kontur{i}(:,2);Kontur{i}(1,2)],zeros(size(Kontur{i},1)+1),'k')
        end
    end
end
axis('equal'); %Fix the axes scaling
view([0 90]); %Set a nice view angle
%}

% Wenn die geschlossene Kurve nach Innen voll ist, werden die Punkte der
% geschlossenen Kurve im Gegenuhrzeigersinn angeordnet
% Dies muss nur ein einziges mal für alle Strahlkompensationen gemacht
% werden. Falls keine Einträge mehr in Kolone 4 des Imputs Kontur sind
% wird angenommen das dieser erste Schritt bereits in einer vorhergehenden
% Strahlkompensation erledigt wurde
for i=1:size(Kontur,2) %Index, der durch die Teilkonturen von Kontur geht
    if ~isempty(Kontur{i}) && size(Kontur{i},2)>3
        kreuzp=cross([n(Kontur{i}(1,4),1:2),0],Kontur{i}(2,1:3)-Kontur{i}(1,1:3));
        if kreuzp(3)<0
            Kontur{i}=flipud(Kontur{i});
        end
    end
end

%Für jeden Eckpunkt wird Status und Winkelhalbierende berechnet 
Sstatus=0;
for i=1:size(Kontur,2) %Index, der durch die Teilkonturen von Kontur geht
    if ~isempty(Kontur{i}) 
        Kontur{i}=[Kontur{i},zeros(size(Kontur{i},1),2)];
        for p=1:size(Kontur{i},1) %Index, der durch die Zeilen der Teilkonturen geht
            if p==1
                E0=Kontur{i}(end,1:2);
            else
                E0=Kontur{i}(p-1,1:2);
            end
            E1=Kontur{i}(p,1:2);
            if p==size(Kontur{i},1)
                E2=Kontur{i}(1,1:2);
            else
                E2=Kontur{i}(p+1,1:2);
            end
            [ status,b33,Sstatus ] = F24( E0,E1,E2,Sstatus );
            Kontur{i}(p,4)=status; %Status wird in Zeile vier gespeichert
            Kontur{i}(p,5:6)=b33; %Winkelhalbierende wird in Zeile 5 und 6 gespeichert
        end
    end
end

ZwischenAbstand=0;
while 1
    %Eckpunkte mit Status 2 behandeln
    while Sstatus==2 %solange wiederholen bis kein status 2 mehr exisitert
        for i=1:size(Kontur,2) %Index, der durch die Teilkonturen von Kontur geht
            if ~isempty(Kontur{i}) 
                SE1=find(Kontur{i}(:,4)==2,1);
                if ~isempty(SE1) %Eckpunkt mit status 2 gefunden
                    break;
                end
            else
                SE1=[];
            end
        end
        if isempty(SE1) %Es exisitert kein Eckpunkt mehr mit status 2
            Sstatus=0;
            break;
        end
        disp('status 2 wird behandelt');
        if SE1==1
            E0=Kontur{i}(end,1:2);
        else
            E0=Kontur{i}(SE1-1,1:2);
        end
        E1=Kontur{i}(SE1,1:2);
        if SE1==size(Kontur{i},1)
            E2=Kontur{i}(1,1:2);
        else
            E2=Kontur{i}(SE1+1,1:2);
        end
        if isequal(round(E0*10000)/10000,round(E2*10000)/10000)
            % E0 und E2 fast identisch -> verschmeltzen zu einem Eckpunkt EX.
            EX=(E0+E2)/2;
            % Skeletonteil anzeigen
            % plot3([E1(1),EX(1)],[E1(2),EX(2)],[ZwischenAbstand,ZwischenAbstand],'r');
            if size(Kontur{i},1)<=3 %weniger als drei Eckpunkte in aktiver Liste (Zustand A)
                Kontur{i}=[]; %aktive Liste löschen
            end
            if size(Kontur{i},1)>3 %Mehr als drei Eckpunkte in aktiver Liste (Zustand B)
                if SE1==1 %Fall 1 
                    %E1 und E2 aus der Liste löschen, E0 wird Eneu
                    Kontur{i}(SE1:end-2,:)=Kontur{i}(SE1+2:end,:); %Block über E1 und E2 aufrücken
                    Kontur{i}(end-1:end,:)=[]; %letzten zwei Zeilen löschen
                    SEneu=size(Kontur{i},1);
                elseif SE1==size(Kontur{i},1) %Fall 3
                    %E0 und E1 aus der Liste löschen, E2 wird Eneu
                    Kontur{i}(end-1:end,:)=[]; %letzten zwei Zeilen löschen
                    SEneu=1;
                else % Fall 2
                    %E1 und E2 aus der Liste löschen, E0 wird Eneu
                    Kontur{i}(SE1:end-2,:)=Kontur{i}(SE1+2:end,:); %Block über E1 und E2 aufrücken
                    Kontur{i}(end-1:end,:)=[]; %letzten zwei Zeilen löschen
                    SEneu=SE1-1;
                end
                %status und Winkelhalbierende von Eneu aktualisiern (Es kann wieder status 2 auftauchen)
                Kontur{i}(SEneu,1:2)=EX;                
                if SEneu==1
                    E0=Kontur{i}(end,1:2);
                else
                    E0=Kontur{i}(SEneu-1,1:2);
                end
                E1=Kontur{i}(SEneu,1:2);
                if SEneu==size(Kontur{i},1)
                    E2=Kontur{i}(1,1:2);
                else
                    E2=Kontur{i}(SEneu+1,1:2);
                end
                [ status,b33,Sstatus ] = F24( E0,E1,E2,Sstatus );
                Kontur{i}(SEneu,4)=status;
                Kontur{i}(SEneu,5:6)=b33;
                % plot3([E1(1),E1(1)+b33(1)],[E1(2),E1(2)+b33(2)],[ZwischenAbstand,ZwischenAbstand],'b')
            end
        else % E0 und E2 nicht identisch (Zustand C)
            if norm(E0-E1)<norm(E2-E1) %E0 liegt näher (Zustand C1)
                %Skeletonteil anzeigen
                % plot3([E1(1),E0(1)],[E1(2),E0(2)],[ZwischenAbstand,ZwischenAbstand],'r');
                %E1 aus der Liste löschen
                Kontur{i}(SE1:end-1,:)=Kontur{i}(SE1+1:end,:); %Block über E1 aufrücken
                Kontur{i}(end,:)=[]; %letzte Zeile löschen
                %status und winkelhalbierende von SE0 aktualisieren
                if SE1==1
                    SE0=size(Kontur{i},1);
                else
                    SE0=SE1-1;
                end
                if SE0==1
                    E0=Kontur{i}(end,1:2);
                else
                    E0=Kontur{i}(SE0-1,1:2);
                end
                E1=Kontur{i}(SE0,1:2);
                if SE0==size(Kontur{i},1)
                    E2=Kontur{i}(1,1:2);
                else
                    E2=Kontur{i}(SE0+1,1:2);
                end
                [ status,b33,Sstatus ] = F24( E0,E1,E2,Sstatus );
                Kontur{i}(SE0,4)=status;
                Kontur{i}(SE0,5:6)=b33;
                % plot3([E1(1),E1(1)+b33(1)],[E1(2),E1(2)+b33(2)],[ZwischenAbstand,ZwischenAbstand],'b')
            else  %E2 liegt näher (Zustand C2)
                %Skeletonteil anzeigen
                % plot3([E1(1),E2(1)],[E1(2),E2(2)],[ZwischenAbstand,ZwischenAbstand],'r');
                %E1 aus der Liste löschen
                Kontur{i}(SE1:end-1,:)=Kontur{i}(SE1+1:end,:); %Block über E1 aufrücken
                Kontur{i}(end,:)=[]; %letzte Zeile löschen
                %status und winkelhalbierende von E2 aktualisieren
                SE2=SE1;
                if SE2==1
                    E0=Kontur{i}(end,1:2);
                else
                    E0=Kontur{i}(SE2-1,1:2);
                end
                E1=Kontur{i}(SE2,1:2);
                if SE2==size(Kontur{i},1)
                    E2=Kontur{i}(1,1:2);
                else
                    E2=Kontur{i}(SE2+1,1:2);
                end
                [ status,b33,Sstatus ] = F24( E0,E1,E2,Sstatus );
                Kontur{i}(SE2,4)=status;
                Kontur{i}(SE2,5:6)=b33;
                % plot3([E1(1),E1(1)+b33(1)],[E1(2),E1(2)+b33(2)],[ZwischenAbstand,ZwischenAbstand],'b')
            end
        end
    end

    %Durch alle Eckpunkte iterieren und Eckpunkte mit Status 0 löschen
    for i=1:size(Kontur,2) %Index, der durch die Teilkonturen von Kontur geht
        if ~isempty(Kontur{i})
            raster=find(Kontur{i}(:,4));
            if length(raster)~=size(Kontur{i},1)
                Kontur{i}(1:length(raster),:)=Kontur{i}(raster,:);
                Kontur{i}(length(raster)+1:end,:)=[];
            end
        end
    end
    
    %Falls alle Arrays in Kontur leer, soll abgebrochen werden
    A=zeros(size(Kontur,2),1);
    for i=1:size(Kontur,2) %Index, der durch die Teilkonturen von Kontur geht
        if ~isempty(Kontur{i})
            A(i)=1;
        end
    end
    if isequal(zeros(size(Kontur,2),1),A)
        disp('Strahlkompensation fertig (Kontur zusammengeschrumpft)');
        break
    end
    
    %Für Eckpunkte mit Status=1 Kritischer Punkt suchen
    Abstandalt=Inf;
    for i=1:size(Kontur,2) %Index, der durch die Teilkonturen von Kontur geht
        if ~isempty(Kontur{i})
            for p=1:size(Kontur{i},1) %Index, der durch die Zeilen der Teilkonturen geht
                status=Kontur{i}(p,4);
                if status==1 %Abstand für konvexe Eckpunkte berechnen
                    if p==1
                        E0=Kontur{i}(end,1:2);
                        b0=Kontur{i}(end,5:6);
                    else
                        E0=Kontur{i}(p-1,1:2);
                        b0=Kontur{i}(p-1,5:6);
                    end
                    E1=Kontur{i}(p,1:2);
                    b1=Kontur{i}(p,5:6);
                    if p==size(Kontur{i},1)
                        E2=Kontur{i}(1,1:2);
                        b2=Kontur{i}(1,5:6);
                    else
                        E2=Kontur{i}(p+1,1:2);
                        b2=Kontur{i}(p+1,5:6);
                    end
                    %Darstellung Winkelhalbierenden
                    % plot3([E1(1),E1(1)+b1(1)],[E1(2),E1(2)+b1(2)],[ZwischenAbstand,ZwischenAbstand],'b')
                    %Intersektionspunkte K1 und Abstand1 werden berechnet 
                    [k1,K1]=F21(E0,b0,E1,b1);
                    if k1>0 %K1 liegt inerhalb des Polygons
                        Abstand1=F22(E0,E1,K1);
                    else %K1 liegt auserhalb des Polygons
                        Abstand1=Inf; 
                    end
                    %Intersektionspunkte K2 und Abstand2 werden berechnet
                    [k2,K2]=F21(E1,b1,E2,b2);
                    if k2>0 %K2 liegt inerhalb des Polygons
                        Abstand2=F22(E1,E2,K2);
                    else %K2 liegt auserhalb des Polygons
                        Abstand2=Inf;
                    end
                    if Abstand1<=Abstand2 
                        Abstandneu=Abstand1+ZwischenAbstand;
                        if Abstandneu<Abstandalt
                            Abstandalt=Abstandneu;
                            UStatus=status;
                            %UEalt=E1;
                            %UEnachbar=E0;
                            if p==1
                                UEnachbar=size(Kontur{i},1);
                                UEalt=p;
                            else
                                UEnachbar=p-1;
                                UEalt=p-1;
                            end
                            UNear=1;
                            UK=K1;
                            UKonturaktiv=i;
                        end
                        % if K1(1)<5 && K1(2)<5
                        %     scatter3(K1(1),K1(2),ZwischenAbstand,20,'b'); %Darstellung Kritischerpunkt
                        % end
                    end
                    if Abstand1>=Abstand2
                        Abstandneu=Abstand2+ZwischenAbstand;
                        if Abstandneu<Abstandalt
                            Abstandalt=Abstandneu;
                            UStatus=status;
                            %UEalt=E1;
                            %UEnachbar=E2;
                            if p==size(Kontur{i},1);
                                UEnachbar=1;
                                UEalt=p-1;
                            else
                                UEnachbar=p+1;
                                UEalt=p;
                            end
                            UNear=2;
                            UK=K2;
                            UKonturaktiv=i;
                        end
                        % if K2(1)<5 && K2(2)<5
                        %     scatter3(K2(1),K2(2),ZwischenAbstand,20,'b'); %Darstellung Kritischerpunkt
                        % end 
                    end
                end
            end
        end
    end
    % if UK(1)<5 && UK(2)<5
    %     scatter3(UK(1),UK(2),ZwischenAbstand,50,'b'); %Darstellung des kritischsten Punktes
    % end 
    
    %Für Eckpunkte mit Status=-1 Kritischer Punkt suchen
    for i=1:size(Kontur,2) %Index, der durch die Teilkonturen von Kontur geht
        if ~isempty(Kontur{i})
            for p=1:size(Kontur{i},1) %Index, der durch die Zeilen der Teilkonturen geht
                status=Kontur{i}(p,4);
                if status==-1 %Abstand für nicht konvexe Eckpunkte berechnen
                    if p==1
                        E0=Kontur{i}(end,1:2);
                    else
                        E0=Kontur{i}(p-1,1:2);
                    end
                    E1=Kontur{i}(p,1:2);
                    b1=Kontur{i}(p,5:6);
                    if p==size(Kontur{i},1)
                        E2=Kontur{i}(1,1:2);
                    else
                        E2=Kontur{i}(p+1,1:2);
                    end
                    v1=E1-E0;
                    v2=E1-E2;
                    % plot3([E1(1),E1(1)+b1(1)],[E1(2),E1(2)+b1(2)],[ZwischenAbstand,ZwischenAbstand],'y')
                    B=[Inf,Inf];
                    Mstatus=0;
                    for j=1:size(Kontur,2) %Index der durch die Teilkonturen geht
                        if ~isempty(Kontur{j})
                            for q=1:size(Kontur{j},1) %Index der durch die Zeilen der Teilkonturen geht
                                M1=Kontur{j}(q,1:2);
                                if q==size(Kontur{j},1)
                                    M2=Kontur{j}(1,1:2);
                                else
                                    M2=Kontur{j}(q+1,1:2);
                                end
                                w1=M2-M1;
                                if isequal(E1,M1) || isequal(E1,M2)
                                else
                                    %Darstellung aktueller Kante
                                    %if mod(p,2)==1
                                    %plot3([M1(1),M2(1)],[M1(2),M2(2)],[0,0],'m')
                                    %else
                                    %plot3([M1(1),M2(1)],[M1(2),M2(2)],[0,0],'r')
                                    %end
                                    [k8,K8]=F21(E1,v1,M1,w1); %Falls k8 sehr gross ist, ist v1 parallel zu w1->schlecht
                                    [k9,K9]=F21(E1,v2,M1,w1); %Falls k9 sehr gross ist, ist v2 parallel zu w1->schlecht
                                    if abs(k8)<=abs(k9)
                                        k3=k8;
                                        K1=K8;
                                        v1=v1/norm(v1);
                                        w1=w1/norm(w1);
                                        b4=v1+w1;
                                    else
                                        k3=k9;
                                        K1=K9;
                                        v2=v2/norm(v2);
                                        w1=w1/norm(w1);
                                        b4=v2+w1;
                                    end
                                    if (k8>100000000 || k8<-100000000) && (k9>100000000 || k9<-100000000) %v2 und w1 fast parallel
                                        warning('v1 und v2 sind fast parallel zu w1 (schlecht)')
                                    end
                                    b5=[-b4(2),b4(1)];
                                    [k4,B1]=F21(E1,b1,K1,b4);
                                    [k5,B2]=F21(E1,b1,K1,b5);
                                    Abstand3=norm(B1-E1);
                                    Abstand4=norm(B2-E1);
                                    %Darstellung des aktuellen B Punkts
                                    %if B1(1)<10 && B1(2)<10 && B1(1)>-10 && B1(2)>-10
                                    %    scatter3(B1(1),B1(2),ZwischenAbstand,10,'g'); %Darstellung B Punkt
                                    %end
                                    %if B2(1)<10 && B2(2)<10 && B2(1)>-10 && B2(2)>-10
                                    %    scatter3(B2(1),B2(2),ZwischenAbstand,10,'g'); %Darstellung B Punkt
                                    %end
                                    if Abstand3<=Abstand4
                                        if k4>0.00000001
                                            if norm(B1-E1)<norm(B-E1)
                                                b10=Kontur{j}(q,5:6);    
                                                if q==size(Kontur{j},1)
                                                    b20=Kontur{j}(1,5:6);
                                                else
                                                    b20=Kontur{j}(q+1,5:6);
                                                end
                                                %1
                                                %q1=F23(M1,b10,B1)
                                                %q2=F23(M2,b20,B1)
                                                if F23(M1,b10,B1)>=-0.000001 && F23(M2,b20,B1)<=0.000001
                                                    %3
                                                    B=B1;
                                                    K=K1;
                                                    M11=M1;
                                                    M22=M2;
                                                    Mstatus=1;
                                                    J1=j;
                                                    %scatter3(B(1),B(2),ZwischenAbstand,30,'g'); %Darstellung B Punkt
                                                    %plot3([M1(1),M1(1)+b10(1)],[M1(2),M1(2)+b10(2)],[0,0],'m');
                                                    %plot3([M2(1),M2(1)+b20(1)],[M2(2),M2(2)+b20(2)],[0,0],'m');
                                                    %scatter3(K(1),K(2),ZwischenAbstand,10,'g'); %Darstellung K Punkt
                                                    %plot3([K(1),B(1)],[K(2),B(2)],[0,0],'g'); 
                                                    Abstand5=F22(M11,M22,B);
                                                    Abstandneu=Abstand5+ZwischenAbstand;
                                                    if Abstandneu*1.000001<Abstandalt %Wirklich ein Split Event?
                                                        Abstandalt=Abstandneu;
                                                        UStatus=status;
                                                        %UEalt=E1;
                                                        %UNear=3;
                                                        UKK=p;
                                                        UM1=q;
                                                        if q==size(Kontur{j},1)
                                                            UM2=1;
                                                        else
                                                            UM2=q+1;
                                                        end
                                                        %UK=B;
                                                        %UM1=M11;
                                                        %UM2=M22;
                                                        UKonturaktiv=i;
                                                        UKonturgeg=J1;
                                                    end
                                                end
                                            end
                                        end
                                    end
                                    if Abstand4<=Abstand3
                                        if k5>0.00000001
                                            if norm(B2-E1)<norm(B-E1)
                                                b10=Kontur{j}(q,5:6);    
                                                if q==size(Kontur{j},1)
                                                    b20=Kontur{j}(1,5:6);
                                                else
                                                    b20=Kontur{j}(q+1,5:6);
                                                end
                                                %2
                                                %q3=F23(M1,b10,B2)
                                                %q4=F23(M2,b20,B2)
                                                if F23(M1,b10,B2)>=-0.000001 && F23(M2,b20,B2)<=0.000001    
                                                    %4
                                                    B=B2;
                                                    K=K1;
                                                	M11=M1;
                                                    M22=M2;
                                                    Mstatus=1;
                                                    J1=j;
                                                    %scatter3(B(1),B(2),ZwischenAbstand,30,'g'); %Darstellung B Punkt
                                                    %plot3([M1(1),M1(1)+b10(1)],[M1(2),M1(2)+b10(2)],[0,0],'m');
                                                    %plot3([M2(1),M2(1)+b20(1)],[M2(2),M2(2)+b20(2)],[0,0],'m');
                                                    %scatter3(K(1),K(2),ZwischenAbstand,10,'g'); %Darstellung K Punkt
                                                    %plot3([K(1),B(1)],[K(2),B(2)],[0,0],'g');
                                                    Abstand5=F22(M11,M22,B);
                                                    Abstandneu=Abstand5+ZwischenAbstand;
                                                    if Abstandneu*1.000001<Abstandalt %Wirklich ein Split Event?
                                                        Abstandalt=Abstandneu;
                                                        UStatus=status;
                                                        %UEalt=E1;
                                                        %UNear=3;
                                                        UKK=p;
                                                        UM1=q;
                                                        if q==size(Kontur{j},1)
                                                            UM2=1;
                                                        else
                                                            UM2=q+1;
                                                        end
                                                        %UK=B;
                                                        %UM1=M11;
                                                        %UM2=M22;
                                                        UKonturaktiv=i;
                                                        UKonturgeg=J1;
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                    % if B(1)<5 && B(2)<5
                    %     scatter3(B(1),B(2),ZwischenAbstand,60,'g'); %Darstellung des kritischsten B Punktes
                    % end
                    % if Mstatus==1
                    %     plot3([M11(1),M22(1)],[M11(2),M22(2)],[ZwischenAbstand,ZwischenAbstand],'g');
                    % end
                    %scatter3(K(1),K(2),ZwischenAbstand,10,'g'); %Darstellung K Punkt
                    %plot3([K(1),B(1)],[K(2),B(2)],[0,0],'g');    
                end
            end
        end
    end
    % if UK(1)<5 && UK(2)<5
    %     scatter3(UK(1),UK(2),ZwischenAbstand,100,'r'); %Darstellung des kritischsten Punktes
    % end 
    

    if KonturAbstand<=Abstandalt
        %Alle Eckpunkte Aufrücken
        Kontur2=Kontur;
        for i=1:size(Kontur,2) %Index, der durch die Teilkonturen von Kontur geht
            if ~isempty(Kontur{i})
                for p=1:size(Kontur{i},1) %Index, der durch die Zeilen der Teilkonturen geht
                    if p==1
                        E0=Kontur{i}(end,1:2);
                    else
                        E0=Kontur{i}(p-1,1:2);
                    end
                    E1=Kontur{i}(p,1:2);
                    if p==size(Kontur{i},1)
                        E2=Kontur{i}(1,1:2);
                    else
                        E2=Kontur{i}(p+1,1:2);
                    end
                    Eneu=F25(E0,E1,E2,KonturAbstand-ZwischenAbstand);
                    Kontur2{i}(p,1:2)=Eneu;
                    %Darstellung Skeletonteil
                    % plot3([E1(1),Eneu(1)],[E1(2),Eneu(2)],[ZwischenAbstand,KonturAbstand],'r');
                end
            end
        end
        Kontur=Kontur2;
        %Darstellung Kontur
        % for i=1:size(Kontur,2)
        %     if ~isempty(Kontur{i})
        %         plot3([Kontur{i}(:,1);Kontur{i}(1,1)],[Kontur{i}(:,2);Kontur{i}(1,2)],KonturAbstand*ones(size(Kontur{i},1)+1),'m')
        %     end
        % end
        disp('Strahlkompensation fertig (Endkontur gefunden)');
        break;
    end

    
    if KonturAbstand>Abstandalt
        if UStatus==1 %Edge Event
            disp('Edge Event');
            if size(Kontur{UKonturaktiv},1)<3 %Nur noch zwei Eckpunkte in aktueller Liste
                warning('nur noch 2 Eckpunkte in aktueller Liste');
                Kontur{UKonturaktiv}=[];
            end
            if size(Kontur{UKonturaktiv},1)==3 %Noch drei Eckpunkte in aktueller Liste
                %Alle Drei Eckpunkte schrumpfen zu einer Dachspitze hin
                % plot3([Kontur{UKonturaktiv}(1,1),UK(1)],[Kontur{UKonturaktiv}(1,2),UK(2)],[ZwischenAbstand,Abstandalt],'r');
                % plot3([Kontur{UKonturaktiv}(2,1),UK(1)],[Kontur{UKonturaktiv}(2,2),UK(2)],[ZwischenAbstand,Abstandalt],'r');
                % plot3([Kontur{UKonturaktiv}(3,1),UK(1)],[Kontur{UKonturaktiv}(3,2),UK(2)],[ZwischenAbstand,Abstandalt],'r');
                Kontur{UKonturaktiv}=[];
            end
            if size(Kontur{UKonturaktiv},1)>3 %Mehr als drei Eckpunkte in aktueller Liste
                %Alle Eckpunkte Aufrücken
                Kontur2=Kontur;
                for i=1:size(Kontur,2) %Index, der durch die Teilkonturen von Kontur geht
                    if ~isempty(Kontur{i})
                        for p=1:size(Kontur{i},1) %Index, der durch die Zeilen der Teilkonturen geht
                            if p==1
                                E0=Kontur{i}(end,1:2);
                            else
                                E0=Kontur{i}(p-1,1:2);
                            end
                            E1=Kontur{i}(p,1:2);
                            if p==size(Kontur{i},1)
                                E2=Kontur{i}(1,1:2);
                            else
                                E2=Kontur{i}(p+1,1:2);
                            end
                            Eneu=F25(E0,E1,E2,Abstandalt-ZwischenAbstand);
                            Kontur2{i}(p,1:2)=Eneu;
                            %Darstellung Skeletonteil
                            % plot3([E1(1),Eneu(1)],[E1(2),Eneu(2)],[ZwischenAbstand,Abstandalt],'r');
                        end
                    end
                end
                Kontur=Kontur2;
                %Darstellung Kontur
                % for i=1:size(Kontur,2)
                %     if ~isempty(Kontur{i})
                %         plot3([Kontur{i}(:,1);Kontur{i}(1,1)],[Kontur{i}(:,2);Kontur{i}(1,2)],Abstandalt*ones(size(Kontur{i},1)+1),'r')
                %     end
                % end
                ZwischenAbstand=Abstandalt;
                %UEnachbar aus UKonturaktiv löschen
                if UEnachbar==size(Kontur{UKonturaktiv},1)
                    Kontur{UKonturaktiv}(end,:)=[]; %UEnachbar Zeile löschen
                else
                    Kontur{UKonturaktiv}(UEnachbar:end-1,:)=Kontur{UKonturaktiv}(UEnachbar+1:end,:); %Block über UEnachbar aufrücken
                    Kontur{UKonturaktiv}(end,:)=[]; %letzte Zeile löschen
                end
                %Status und Winkelhalbierende von UEalt aktualisieren
                if UEalt==1
                    E0=Kontur{UKonturaktiv}(end,1:2);
                else
                    E0=Kontur{UKonturaktiv}(UEalt-1,1:2);
                end
                E1=Kontur{UKonturaktiv}(UEalt,1:2);
                if UEalt==size(Kontur{UKonturaktiv},1)
                    E2=Kontur{UKonturaktiv}(1,1:2);
                else
                    E2=Kontur{UKonturaktiv}(UEalt+1,1:2);
                end
                [ status,b33,Sstatus ] = F24( E0,E1,E2,Sstatus );
                Kontur{UKonturaktiv}(UEalt,4)=status;
                Kontur{UKonturaktiv}(UEalt,5:6)=b33;
            end
        end
        
        if UStatus==-1 %Split oder Merge Event
            %Alle Eckpunkte Aufrücken
            Kontur2=Kontur;
            for i=1:size(Kontur,2) %Index, der durch die Teilkonturen von Kontur geht
                if ~isempty(Kontur{i})
                    for p=1:size(Kontur{i},1) %Index, der durch die Zeilen der Teilkonturen geht
                        if p==1
                            E0=Kontur{i}(end,1:2);
                        else
                            E0=Kontur{i}(p-1,1:2);
                        end
                        E1=Kontur{i}(p,1:2);
                        if p==size(Kontur{i},1)
                            E2=Kontur{i}(1,1:2);
                        else
                            E2=Kontur{i}(p+1,1:2);
                        end
                        Eneu=F25(E0,E1,E2,Abstandalt-ZwischenAbstand);
                        Kontur2{i}(p,1:2)=Eneu;
                        %Darstellung Skeletonteil
                        % plot3([E1(1),Eneu(1)],[E1(2),Eneu(2)],[ZwischenAbstand,Abstandalt],'r');
                    end
                end
            end
            Kontur=Kontur2;
            %Darstellung Kontur
            % for i=1:size(Kontur,2)
            %     if ~isempty(Kontur{i})
            %         plot3([Kontur{i}(:,1);Kontur{i}(1,1)],[Kontur{i}(:,2);Kontur{i}(1,2)],Abstandalt*ones(size(Kontur{i},1)+1),'r')
            %     end
            % end
            ZwischenAbstand=Abstandalt;
            if UKonturaktiv==UKonturgeg %Split Event
                disp('Split Event');
                i=UKonturaktiv;
                l=size(Kontur,2)+1; %neuer Kolonen Index der neuen Kontur
                if UM1<UKK && UM2<UKK %Zustand 1
                    %UKonturaktiv wird zwischen UM1, UM2 und UKK gespalten. UKK wird verdoppelt in UK1 und UK2
                    Kontur{l}=Kontur{i}(UM2:UKK,:); %Rüberkopieren
                    Kontur{i}(UM2:(end-(UKK-UM2)),:)=Kontur{i}(UKK:end,:); %Restblock aufrücken
                    Kontur{i}((end-(UKK-UM2)+1):end,:)=[]; %Resteinträge löschen
                    UK2=size(Kontur{l},1);
                    UK1=UM2;
                    %Status und Winkelhalbierende von UK1 wird aktualisiert
                    if UK1==1
                        E0=Kontur{i}(end,1:2);
                    else
                        E0=Kontur{i}(UK1-1,1:2);
                    end
                    E1=Kontur{i}(UK1,1:2);
                    if UK1==size(Kontur{i},1)
                        E2=Kontur{i}(1,1:2);
                    else
                        E2=Kontur{i}(UK1+1,1:2);
                    end
                    [ status,b33,Sstatus ] = F24( E0,E1,E2,Sstatus );
                    Kontur{i}(UK1,4)=status;
                    Kontur{i}(UK1,5:6)=b33;
                    %Status und Winkelhalbierende von UK2 wird aktualisiert
                    E0=Kontur{l}(UK2-1,1:2);
                    E1=Kontur{l}(UK2,1:2);
                    E2=Kontur{l}(1,1:2);
                    [ status,b33,Sstatus ] = F24( E0,E1,E2,Sstatus );
                    Kontur{l}(UK2,4)=status;
                    Kontur{l}(UK2,5:6)=b33;
                end
                if UM1>UKK && UM2>UKK %Zustand 2
                    %UKonturaktiv wird zwischen UM1, UM2 und UKK gespalten. UKK wird verdoppelt in UK1 und UK2
                    Kontur{l}=Kontur{i}(UKK:UM1,:); %Rüberkopieren
                    Kontur{i}(UKK+1:(end-(UM1-UKK)),:)=Kontur{i}(UM2:end,:); %Restblock aufrücken
                    Kontur{i}((end-(UM1-UKK)+1):end,:)=[]; %Resteinträge löschen
                    UK2=UKK;
                    UK1=1;
                    %Status und Winkelhalbierende von UK2 wird aktualisiert
                    if UK2==1
                        E0=Kontur{i}(end,1:2);
                    else
                        E0=Kontur{i}(UK2-1,1:2);
                    end
                    E1=Kontur{i}(UK2,1:2);
                    if UK2==size(Kontur{i},1)
                        E2=Kontur{i}(1,1:2);
                    else
                        E2=Kontur{i}(UK2+1,1:2);
                    end
                    [ status,b33,Sstatus ] = F24( E0,E1,E2,Sstatus );
                    Kontur{i}(UK2,4)=status;
                    Kontur{i}(UK2,5:6)=b33;
                    %Status und Winkelhalbierende von UK1 wird aktualisiert
                    E0=Kontur{l}(end,1:2);
                    E1=Kontur{l}(UK1,1:2);
                    E2=Kontur{l}(UK1+1,1:2);
                    [ status,b33,Sstatus ] = F24( E0,E1,E2,Sstatus );
                    Kontur{l}(UK1,4)=status;
                    Kontur{l}(UK1,5:6)=b33;
                end
                if UM1>UKK && UM2<UKK %Zustand 3
                    %UKonturaktiv wird zwischen UM1, UM2 und UKK gespalten. UKK wird verdoppelt in UK1 und UK2
                    Kontur{l}=Kontur{i}(UKK:UM1,:); %Rüberkopieren
                    Kontur{i}(UKK+1:end,:)=[]; %Resteinträge löschen
                    UK2=UKK;
                    UK1=1;
                    %Status und Winkelhalbierende von UK2 wird aktualisiert
                    E0=Kontur{i}(UK2-1,1:2);
                    E1=Kontur{i}(UK2,1:2);
                    E2=Kontur{i}(1,1:2);
                    [ status,b33,Sstatus ] = F24( E0,E1,E2,Sstatus );
                    Kontur{i}(UK2,4)=status;
                    Kontur{i}(UK2,5:6)=b33;
                    %Status und Winkelhalbierende von UK1 wird aktualisiert
                    E0=Kontur{l}(end,1:2);
                    E1=Kontur{l}(UK1,1:2);
                    E2=Kontur{l}(UK1+1,1:2);
                    [ status,b33,Sstatus ] = F24( E0,E1,E2,Sstatus );
                    Kontur{l}(UK1,4)=status;
                    Kontur{l}(UK1,5:6)=b33;
                end
            end

            if UKonturaktiv~=UKonturgeg %Merge Event
                disp('Merge Event');
                i=UKonturaktiv;
                l=UKonturgeg; 
                if UM1>UM2 %Zustand 1
                    %UKonturaktiv wird gespalten und platz für UKonturgeg gemacht, UKK wird verdoppelt in UK1 und UK2
                    Kontur{i}(UKK+size(Kontur{l},1)+1:end+size(Kontur{l},1)+1,:)=Kontur{i}(UKK:end,:);
                    UK2=UKK;
                    UK1=UKK+size(Kontur{l},1)+1;
                    %UKonturgeg wird richtig eingeschoben
                    Kontur{i}(UK2+1:UK1-1,:)=Kontur{l};
                    Kontur{l}=[];
                    %Status und Winkelhalbierende von UK1 wird aktualisiert
                    if UK1==1
                        E0=Kontur{i}(end,1:2);
                    else
                        E0=Kontur{i}(UK1-1,1:2);
                    end
                    E1=Kontur{i}(UK1,1:2);
                    if UK1==size(Kontur{i},1)
                        E2=Kontur{i}(1,1:2);
                    else
                        E2=Kontur{i}(UK1+1,1:2);
                    end
                    [ status,b33,Sstatus ] = F24( E0,E1,E2,Sstatus );
                    Kontur{i}(UK1,4)=status;
                    Kontur{i}(UK1,5:6)=b33;
                    %Status und Winkelhalbierende von UK2 wird aktualisiert
                    if UK2==1
                        E0=Kontur{i}(end,1:2);
                    else
                        E0=Kontur{i}(UK2-1,1:2);
                    end
                    E1=Kontur{i}(UK2,1:2);
                    if UK2==size(Kontur{i},1)
                        E2=Kontur{i}(1,1:2);
                    else
                        E2=Kontur{i}(UK2+1,1:2);
                    end
                    [ status,b33,Sstatus ] = F24( E0,E1,E2,Sstatus );
                    Kontur{i}(UK2,4)=status;
                    Kontur{i}(UK2,5:6)=b33;
                end
                if UM1<UM2 %Zustand 2
                    %UKonturaktiv wird gespalten und platz für UKonturgeg gemacht, UKK wird verdoppelt in UK1 und UK2
                    Kontur{i}(UKK+size(Kontur{l},1)+1:end+size(Kontur{l},1)+1,:)=Kontur{i}(UKK:end,:); 
                    UK2=UKK;
                    UK1=UKK+size(Kontur{l},1)+1;
                    %UKonturgeg wird richtig eingeschoben
                    Kontur{i}(UK2+1:UK2+(size(Kontur{l},1)-UM1),:)=Kontur{l}(UM2:end,:);
                    Kontur{i}(UK2+1+(size(Kontur{l},1)-UM1):UK1-1,:)=Kontur{l}(1:UM1,:);
                    Kontur{l}=[];
                    %Status und Winkelhalbierende von UK1 wird aktualisiert
                    if UK1==1
                        E0=Kontur{i}(end,1:2);
                    else
                        E0=Kontur{i}(UK1-1,1:2);
                    end
                    E1=Kontur{i}(UK1,1:2);
                    if UK1==size(Kontur{i},1)
                        E2=Kontur{i}(1,1:2);
                    else
                        E2=Kontur{i}(UK1+1,1:2);
                    end
                    [ status,b33,Sstatus ] = F24( E0,E1,E2,Sstatus );
                    Kontur{i}(UK1,4)=status;
                    Kontur{i}(UK1,5:6)=b33;
                    %Status und Winkelhalbierende von UK2 wird aktualisiert
                    if UK2==1
                        E0=Kontur{i}(end,1:2);
                    else
                        E0=Kontur{i}(UK2-1,1:2);
                    end
                    E1=Kontur{i}(UK2,1:2);
                    if UK2==size(Kontur{i},1)
                        E2=Kontur{i}(1,1:2);
                    else
                        E2=Kontur{i}(UK2+1,1:2);
                    end
                    [ status,b33,Sstatus ] = F24( E0,E1,E2,Sstatus );
                    Kontur{i}(UK2,4)=status;
                    Kontur{i}(UK2,5:6)=b33;
                end
            end
        end
    end
    
    %Durch alle Eckpunkte iterieren und aufeinanderfolgende Eckpunkte die identisch sind löschen
    for i=1:size(Kontur,2) %Index, der durch die Teilkonturen von Kontur geht
        if ~isempty(Kontur{i})
            p=1;
            while p<=size(Kontur{i},1)
                E1=Kontur{i}(p,1:2);
                if p==size(Kontur{i},1)
                    E2=Kontur{i}(1,1:2);
                else
                    E2=Kontur{i}(p+1,1:2);
                end
                if isequal(round(E1*1000000)/1000000,round(E2*1000000)/1000000)
                    disp('E1 und E2 sind identisch');
                    if p==size(Kontur{i},1)
                        if p==1
                            break;
                        end
                        %E1 aus Liste löschen
                        Kontur{i}(end,:)=[]; %letzte Zeile löschen
                        %E2 erster Eintrag im Array aktualisieren
                        E0=Kontur{i}(end,1:2);
                        E1=Kontur{i}(1,1:2);
                        if p==size(Kontur{i},1)
                            E2=Kontur{i}(1,1:2);
                        else
                            E2=Kontur{i}(2,1:2);
                        end
                        [ status,b33,Sstatus ] = F24( E0,E1,E2,Sstatus );
                        Kontur{i}(1,4)=status;
                        Kontur{i}(1,5:6)=b33;
                    else
                        %E1 aus Liste löschen
                        Kontur{i}(p:end-1,:)=Kontur{i}(p+1:end,:); %Block über E1 aufrücken
                        Kontur{i}(end,:)=[]; %letzte Zeile löschen
                        %E2 (neues E1) aktualisieren
                        if p==1
                            E0=Kontur{i}(end,1:2);
                        else
                            E0=Kontur{i}(p-1,1:2);
                        end
                        E1=Kontur{i}(p,1:2);
                        if p==size(Kontur{i},1)
                            E2=Kontur{i}(1,1:2);
                        else
                            E2=Kontur{i}(p+1,1:2);
                        end
                        [ status,b33,Sstatus ] = F24( E0,E1,E2,Sstatus );
                        Kontur{i}(p,4)=status;
                        Kontur{i}(p,5:6)=b33;
                    end
                else
                    p=p+1;
                end
            end
        end
    end    
end

%Leere Arrays entfernen
Kontur = Kontur(~cellfun(@isempty, Kontur));

%Löscht den Ramsch aus Kolonen 4 bis 6 raus
for i=1:size(Kontur,2) %Index, der durch die Teilkonturen von Kontur geht
    if ~isempty(Kontur{i})
        Kontur{i}=Kontur{i}(:,1:3);
    end
end

end

