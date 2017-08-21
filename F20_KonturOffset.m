function[Hatches]=F20_KonturOffset(Kontur,KonturAbstand)
%Konturoffsets berechnen

%{
%Initialisierung ohne Status2 
Kontur1=Kontur;
if ~isempty(Kontur1)
    %Winkelhalbierende der Zwischenpunkte berechnen
    E0=Kontur1(1:end-2,1:2);
    E1=Kontur1(2:end-1,1:2);
    E2=Kontur1(3:end,1:2);
    v1=E1-E0;
    v1=v1./((v1(:,1).^2+v1(:,2).^2).^0.5*[1,1]);
    v2=E2-E1;
    v2=v2./((v2(:,1).^2+v2(:,2).^2).^0.5*[1,1]);
    crossp=v1(:,1).*v2(:,2)-v1(:,2).*v2(:,1);
    b=(-v1+v2).*(crossp*[1,1]);
    b=b./((b(:,1).^2+b(:,2).^2).^0.5*[1,1]);
    Kontur1(2:end-1,4:5)=b;
    %Winkelhalbierende des Anfangpunktes berechnen
    E1=Kontur1(1,1:2);
    E2=Kontur1(2,1:2);
    v2=E2-E1;
    v2=v2./(v2(1)^2+v2(2)^2)^0.5;
    b11=[-v2(2),v2(1)];
    Kontur1(1,4:5)=b11;
    %Winkelhalbierende des Endpunktes berechnen
    E0=Kontur1(end-1,1:2);
    E1=Kontur1(end,1:2);
    v1=E1-E0;
    v1=v1./(v1(1)^2+v1(2)^2)^0.5;
    b11=[-v1(2),v1(1)];
    Kontur1(end,4:5)=b11;
    %Abstand zum kritischen Punkt mit linkem Nachbar berechnen
    Kontur1(1,6)=Inf;
    for p=2:size(Kontur1,1)
        E0=Kontur1(p-1,1:2);
        E1=Kontur1(p,1:2);
        b00=Kontur1(p-1,4:5);
        b11=Kontur1(p,4:5);
        [k1,K1]=F21(E0,b00,E1,b11);
        if k1>0 %K1 liegt inerhalb des Polygons
            Abstand=F22(E0,E1,K1);
            %if K1(1)<5 && K1(1)>-5 && K1(2)<5 && K1(2)>-5
            %    scatter3(K1(1),K1(2),Abstandmin,20,'b'); %Darstellung Kritischerpunkt
            %end
        else %K1 liegt auserhalb des Polygons
            Abstand=Inf; 
        end
        Kontur1(p,6)=Abstand;
    end
end
%}
%Initialisierung mit Status2
%Kontur=Konturs{1,1}; %Aus Konturs wird nur für das erste Segment ein Offset berechnet
status2=0;
if ~isempty(Kontur)
    %Winkelhalbierende des Anfangpunktes berechnen
    E1=Kontur(1,1:2);
    E2=Kontur(2,1:2);
    v2=E2-E1;
    v2=v2./(v2(1)^2+v2(2)^2)^0.5;
    b11=[-v2(2),v2(1)];
    Kontur(1,4:5)=b11;
    Kontur(1,6)=Inf;
    %Winkelhalbierende des Endpunktes berechnen
    E0=Kontur(end-1,1:2);
    E1=Kontur(end,1:2);
    v1=E1-E0;
    v1=v1./(v1(1)^2+v1(2)^2)^0.5;
    b11=[-v1(2),v1(1)];
    Kontur(end,4:5)=b11;
    for p=2:size(Kontur,1) %Durch die Punkte der Kontur itterieren
        E0=Kontur(p-1,1:2);
        E1=Kontur(p,1:2);
        b00=Kontur(p-1,4:5);
        if p~=size(Kontur,1) %Alle ausser Endpunkt
            %Winkelhalbierende für Zwischenpunkte berechnen
            E2=Kontur(p+1,1:2);
            [ b11,status2 ] = F27( E0,E1,E2,status2 );
            Kontur(p,4:5)=b11;
        else
            b11=Kontur(p,4:5);
        end
        %Intersektionspunkte K1 und Abstand berechnet 
        [k1,K1]=F21(E0,b00,E1,b11);
        if k1>0 %K1 liegt inerhalb des Polygons
            Abstand=F22(E0,E1,K1);
            %if K1(1)<5 && K1(1)>-5 && K1(2)<5 && K1(2)>-5
            %    scatter3(K1(1),K1(2),Abstandmin,20,'b'); %Darstellung Kritischerpunkt
            %end
        else %K1 liegt auserhalb des Polygons
            Abstand=Inf; 
        end
        Kontur(p,6)=Abstand;
    end
end
%Entscheidung Zusammengeschrumpft, Endkontur gefunden, Edge Event
ZwischenAbstand=0;
KonInx=1;
Hatches=cell(1,1);
%Hatches{1,1}=Kontur(:,1:2); %Originalkontur wird im ersten Eintrag gespeichert
%HatchInx=2;
HatchInx=1;
while(1)
%%%%%Winkelhalbierende darstellen
    %%%for p=1:size(Kontur,1)
    %%%    E1=Kontur(p,1:2);
    %%%    b11=Kontur(p,4:5);
    %%%    plot3([E1(1),E1(1)+b11(1)*0.2],[E1(2),E1(2)+b11(2)*0.2],[ZwischenAbstand,ZwischenAbstand],'b') %Darstellung Winkelhalbierenden
    %%%end
    
%%%%%Status 2 vorhanden (Diese Beschädigung in der Kontur kann eventuell zu Problemen führen)
    if status2==2
        warning('Mehrere Punkte liegen auf einer Linie')
    end
    
%%%%%Falls Kontur weniger als 1Punkt enthält, soll abgebrochen werden
    if size(Kontur,1)<=1
        %%%% disp('Konturoffset gefunden');
        break
    end
    
    %Kleinster Abstand suchen
    [Abstandmin,pp]=min(Kontur(:,6));
    
%%%%%Konturoffset gefunden
    if KonturAbstand(KonInx)<=Abstandmin
        %%%disp('Kontur gefunden');
        %Alle Eckpunkte Aufrücken
        Kontur2=Kontur;
        for p=1:size(Kontur,1) %Durch die Punkte der Kontur itterieren
            if p==1 %Anfangspunkt
                E1=Kontur(p,1:2);
                E2=Kontur(p+1,1:2);
                vv=E2-E1;
                b11=Kontur(p,4:5);
            elseif p==size(Kontur,1) %Endpunkt
                E0=Kontur(p-1,1:2);
                E1=Kontur(p,1:2);
                b11=Kontur(p,4:5);
                vv=E0-E1;
            else %Normaler Zwischenpunkt
                E0=Kontur(p-1,1:2);
                E1=Kontur(p,1:2);
                E2=Kontur(p+1,1:2);
                v1=E0-E1;
                v2=E2-E1;
                if (v1(1)^2+v1(2)^2)^0.5>(v2(1)^2+v2(2)^2)^0.5
                    vv=v1;
                else
                    vv=v2;
                end
                b11=Kontur(p,4:5);
            end 
            %Eneu=F26(E1,b11,vv, KonturAbstand(KonInx)-ZwischenAbstand);
            L=KonturAbstand(KonInx)-ZwischenAbstand;
            Eneu=E1+b11*L/(1-((vv(1)*b11(1)+vv(2)*b11(2))/(vv(1)^2+vv(2)^2)^0.5)^2)^0.5;
            Kontur2(p,1:2)=Eneu;
            %Darstellung Skeletonteil
            %plot3([E1(1),Eneu(1)],[E1(2),Eneu(2)],[ZwischenAbstand,KonturAbstand(KonInx)],'b');
        end
        Kontur=Kontur2;
        %Darstellung Kontur
        %%%plot3(Kontur(:,1),Kontur(:,2), KonturAbstand(KonInx)*ones(size(Kontur,1)),'m')
        Hatches{1,HatchInx}=Kontur(:,1:2);
        HatchInx=HatchInx+1;
        if KonInx==length(KonturAbstand)
            %%%% disp('Konturoffset gefunden');
            break;
        end
        ZwischenAbstand=KonturAbstand(KonInx);
        KonInx=KonInx+1;
    end
%%%%%Edge Event
    if KonturAbstand(KonInx)>Abstandmin
        %%%disp('Edge Event');
        %Alle Eckpunkte Aufrücken
        Kontur2=Kontur;
        for p=1:size(Kontur,1) %Durch die Punkte der Kontur itterieren
            if p==1 %Anfangspunkt
                E1=Kontur(p,1:2);
                E2=Kontur(p+1,1:2);
                vv=E2-E1;
                b11=Kontur(p,4:5);
            elseif p==size(Kontur,1) %Endpunkt
                E0=Kontur(p-1,1:2);
                E1=Kontur(p,1:2);
                b11=Kontur(p,4:5);
                vv=E0-E1;
            else %Normaler Zwischenpunkt
                E0=Kontur(p-1,1:2);
                E1=Kontur(p,1:2);
                E2=Kontur(p+1,1:2);
                v1=E0-E1;
                v2=E2-E1;
                if (v1(1)^2+v1(2)^2)^0.5>(v2(1)^2+v2(2)^2)^0.5
                    vv=v1;
                else
                    vv=v2;
                end
                b11=Kontur(p,4:5);
            end 
            %Eneu=F26(E1,b11,vv, Abstandmin-ZwischenAbstand);
            L=Abstandmin-ZwischenAbstand;
            Eneu=E1+b11*L/(1-((vv(1)*b11(1)+vv(2)*b11(2))/(vv(1)^2+vv(2)^2)^0.5)^2)^0.5;
            Kontur2(p,1:2)=Eneu;
            %Darstellung Skeletonteil
            %plot3([E1(1),Eneu(1)],[E1(2),Eneu(2)],[ZwischenAbstand,Abstandmin],'b');
        end
        Kontur=Kontur2;
        %Darstellung Kontur
        %%%plot3(Kontur(:,1),Kontur(:,2),Abstandmin*ones(size(Kontur,1)),'r')
        ZwischenAbstand=Abstandmin;
        %Kollisionen mit noch mehr als nur vorangehender Punkt mit pp
        E1=Kontur(pp,1:2);
        if pp~=size(Kontur,1) %pp nicht der Endpunkt
            E2=Kontur(pp+1,1:2);
            while isequal(round(E1*10000)/10000,round(E2*10000)/10000)
                %disp('Vorangehender Punkt fast identisch');
                Kontur(pp+1,:)=[]; %Vorangehender identischer Punkt vernichten
                if pp==size(Kontur,1) %Alle vorangehenden Punkte bis zum Endpunkt bereits vernichtet 
                    break;
                end
                E2=Kontur(pp+1,1:2);
            end
        end
        if pp~=2 %pp grenzt nicht an den Anfangspunkt
            E0=Kontur(pp-2,1:2);
            while isequal(round(E0*10000)/10000,round(E1*10000)/10000)
                %disp('Vorhergehender Punkt fast identisch');
                Kontur(pp-1,:)=[]; %Vorhergehender identischer Punkt vernichten
                pp=pp-1;
                if pp==2 %Alle vorhergehenden Punkte bis zum Anfangspunkt bereits vernichtet 
                    break;
                end
                E0=Kontur(pp-2,1:2);
            end
        end
        %pp aus Kontur löschen
        if pp==size(Kontur,1) %Kollision mit Endpunkt
            %disp('Kolision mit Endpunkt');
            %%%E1=Kontur(pp,1:2);
            %%%scatter3(E1(1),E1(2),Abstandmin,50,'r'); %Darstellung Endpunkt
            Kontur(pp,:)=[]; %Endpunkt vernichten
        elseif pp==2 %Kollision mit Anfangspunkt
            %disp('Kollision mit Anfangspunkt');
            %%%E1=Kontur(pp,1:2);
            %%%scatter3(E1(1),E1(2),Abstandmin,50,'r'); %Darstellung Endpunkt
            Kontur(1,:)=[]; %Anfangspunkt vernichten
            Kontur(1,6)=Inf; %Absand von Anfangspunkt auf Unendlich
        else %Kollision von zwei Zwischenpunkt
            Kontur(pp,:)=[]; %Minimumspunkt vernichten
            %Winkelhalbierende von vorangehendem Punkt akutalisieren
            pp=pp-1;
            E0=Kontur(pp-1,1:2);
            E1=Kontur(pp,1:2);
            E2=Kontur(pp+1,1:2);
            [b11,status2 ] = F27( E0,E1,E2,status2 );
            Kontur(pp,4:5)=b11;
            %Intersektionspunkte K1 und Abstand von vorangehendem Punkt aktualisieren
            b00=Kontur(pp-1,4:5);
            b11=Kontur(pp,4:5);
            [k1,K1]=F21(E0,b00,E1,b11);
            if k1>0 %K1 liegt inerhalb des Polygons
                Abstand=F22(E0,E1,K1);
                %%%if K1(1)<5 && K1(1)>-5 && K1(2)<5 && K1(2)>-5
                %%%    scatter3(K1(1),K1(2),Abstandmin,20,'g'); %Darstellung Kritischerpunkt
                %%%end
            else %K1 liegt auserhalb des Polygons
                Abstand=Inf; 
            end
            Kontur(pp,6)=Abstand+Abstandmin;
            %Intersektionspunkte K1 und Abstand von folgende Punkt aktualisieren
            b22=Kontur(pp+1,4:5);
            [k1,K1]=F21(E1,b11,E2,b22);
            if k1>0 %K1 liegt inerhalb des Polygons
                Abstand=F22(E1,E2,K1);
                %%%if K1(1)<5 && K1(1)>-5 && K1(2)<5 && K1(2)>-5
                %%%    scatter3(K1(1),K1(2),Abstandmin,20,'g'); %Darstellung Kritischerpunkt
                %%%end
            else %K1 liegt auserhalb des Polygons
                Abstand=Inf; 
            end
            Kontur(pp+1,6)=Abstand+Abstandmin;
        end
    end
end

end

