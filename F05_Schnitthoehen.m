function [Schnitthoehen,Zoben,Zunten,Schichtdicke]=F05_Schnitthoehen(v,Schichtdicke,Auswahlhoehen,Auswahlhoeheoben,Auswahlhoeheunten)
%F05_Schnitthoehen berechnet den Vektor Schnitthoehen
%Dieser definiert, auf welchen H�hen (z-Koordinaten) sp�ter ein Schnitt 
%durch die Stl-Datei gemacht werden soll
%Imput Auswahlhoehen gibt an ob nur auf einem bestimmten Auswahlh�henbereich 
%Schnitth�hen berechnet werden sollen. (1=ja) (0=nein)
%Falls Auswahlhoehen=1 werden die Schnitth�hen zwischen Auswahlhoeheunten
%bis Auswahlhoeheoben berechnet
%Zus�tzlich werden in dieser Funktion die Imputs Schnichtdicke
%Auswahlhoeheoben und Auswahlhoeheunten auf Korrektheit �berpr�ft

Zoben=max(v(:,3)); %Z-Koordinate des h�chstgelegensten Stl-Objekt Punktes
Zunten=min(v(:,3)); %Z-Koordinate des tiefstgelegensten Stl-Objekt Punktes

if Auswahlhoehen==0
    if ((Zoben-Zunten)<Schichtdicke) %Ist Schichtdicke kleiner als STL-Objekt?
        %warndlg('Schichtdicke gr�sser als das 3D Objekt');
        Schichtdicke=Zoben-Zunten;
    end
    if isnan(Schichtdicke)
        Schichtdicke=Zoben-Zunten;
    end
    %Die Eintr�ge (z-Koordinaten) m�ssen aufsteigende Reihenfolge habe
    %Schnitthoehen=[(Zunten+Schichtdicke/2):Schichtdicke:(Zoben-Schichtdicke/2)]'; %besser f�r Selective Laser Melting
    Schnitthoehen=flipud([-(Zoben-Schichtdicke/2):Schichtdicke:(-Zunten-Schichtdicke/2)]'*-1); %besser f�r Laser Ablation
end
if Auswahlhoehen==1
    if Auswahlhoeheoben>Zoben
        %warndlg('Auswahlhoeheoben liegt h�her als der h�chste Punkt des Stl-Objekts');
    else
        Zoben=Auswahlhoeheoben;
    end
    if Auswahlhoeheunten<Zunten
        %warndlg('Auswahlhoeheunten liegt tiefer als der tiefste Punkt des Stl-Objekts');
    else
        Zunten=Auswahlhoeheunten;
    end
    if Auswahlhoeheoben<Auswahlhoeheunten
        %warndlg('Auswahlhoeheoben liegt tiefer als Auswahlhoeheunten');
        Zoben=Auswahlhoeheunten;
        Zunten=Auswahlhoeheoben;
        if Zoben>max(v(:,3))
            %warndlg('Auswahlhoeheoben liegt h�her als der h�chste Punkt des Stl-Objekts');
            Zoben=max(v(:,3));
        end
        if Zunten<min(v(:,3))
            %warndlg('Auswahlhoeheunten liegt tiefer als der tiefste Punkt des Stl-Objekts');
            Zunten=min(v(:,3));
        end
    end
    if Auswahlhoeheoben==Auswahlhoeheunten
        warndlg('Die Auswahlh�hen d�rfen nicht identisch sein');
        Zoben=max(v(:,3));
        Zunten=min(v(:,3));
    end     
    if (Zoben-Zunten)<Schichtdicke %Ist Schichtdicke kleiner als die Auswahlh�hen?
        %warndlg('Die Auswahlh�hen sind n�her zusammen als eine Schichtdicke');
        Schichtdicke=Zoben-Zunten;
    end
    %Die Eintr�ge (z-Koordinaten) m�ssen aufsteigende Reihenfolge habe
    %Schnitthoehen=[(Zunten+Schichtdicke/2):Schichtdicke:(Zoben-Schichtdicke/2)]'; %besser f�r Selective Laser Melting
    Schnitthoehen=flipud([Zoben-Schichtdicke/2:-Schichtdicke:Zunten+Schichtdicke/2]'); %besser f�r Laser Ablation
end

end

