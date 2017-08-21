function [Schnitthoehen,Zoben,Zunten,Schichtdicke]=F05_Schnitthoehen(v,Schichtdicke,Auswahlhoehen,Auswahlhoeheoben,Auswahlhoeheunten)
%F05_Schnitthoehen berechnet den Vektor Schnitthoehen
%Dieser definiert, auf welchen Höhen (z-Koordinaten) später ein Schnitt 
%durch die Stl-Datei gemacht werden soll
%Imput Auswahlhoehen gibt an ob nur auf einem bestimmten Auswahlhöhenbereich 
%Schnitthöhen berechnet werden sollen. (1=ja) (0=nein)
%Falls Auswahlhoehen=1 werden die Schnitthöhen zwischen Auswahlhoeheunten
%bis Auswahlhoeheoben berechnet
%Zusätzlich werden in dieser Funktion die Imputs Schnichtdicke
%Auswahlhoeheoben und Auswahlhoeheunten auf Korrektheit überprüft

Zoben=max(v(:,3)); %Z-Koordinate des höchstgelegensten Stl-Objekt Punktes
Zunten=min(v(:,3)); %Z-Koordinate des tiefstgelegensten Stl-Objekt Punktes

if Auswahlhoehen==0
    if ((Zoben-Zunten)<Schichtdicke) %Ist Schichtdicke kleiner als STL-Objekt?
        %warndlg('Schichtdicke grösser als das 3D Objekt');
        Schichtdicke=Zoben-Zunten;
    end
    if isnan(Schichtdicke)
        Schichtdicke=Zoben-Zunten;
    end
    %Die Einträge (z-Koordinaten) müssen aufsteigende Reihenfolge habe
    %Schnitthoehen=[(Zunten+Schichtdicke/2):Schichtdicke:(Zoben-Schichtdicke/2)]'; %besser für Selective Laser Melting
    Schnitthoehen=flipud([-(Zoben-Schichtdicke/2):Schichtdicke:(-Zunten-Schichtdicke/2)]'*-1); %besser für Laser Ablation
end
if Auswahlhoehen==1
    if Auswahlhoeheoben>Zoben
        %warndlg('Auswahlhoeheoben liegt höher als der höchste Punkt des Stl-Objekts');
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
            %warndlg('Auswahlhoeheoben liegt höher als der höchste Punkt des Stl-Objekts');
            Zoben=max(v(:,3));
        end
        if Zunten<min(v(:,3))
            %warndlg('Auswahlhoeheunten liegt tiefer als der tiefste Punkt des Stl-Objekts');
            Zunten=min(v(:,3));
        end
    end
    if Auswahlhoeheoben==Auswahlhoeheunten
        warndlg('Die Auswahlhöhen dürfen nicht identisch sein');
        Zoben=max(v(:,3));
        Zunten=min(v(:,3));
    end     
    if (Zoben-Zunten)<Schichtdicke %Ist Schichtdicke kleiner als die Auswahlhöhen?
        %warndlg('Die Auswahlhöhen sind näher zusammen als eine Schichtdicke');
        Schichtdicke=Zoben-Zunten;
    end
    %Die Einträge (z-Koordinaten) müssen aufsteigende Reihenfolge habe
    %Schnitthoehen=[(Zunten+Schichtdicke/2):Schichtdicke:(Zoben-Schichtdicke/2)]'; %besser für Selective Laser Melting
    Schnitthoehen=flipud([Zoben-Schichtdicke/2:-Schichtdicke:Zunten+Schichtdicke/2]'); %besser für Laser Ablation
end

end

