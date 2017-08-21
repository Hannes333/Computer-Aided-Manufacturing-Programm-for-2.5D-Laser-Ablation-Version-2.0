function [ Abstand ] = F22( E1,E2,I )
%F22 berechnet die kürzeste Abstand zwischen der Gerade von Punkt E1 nach E2
%und dem Punkt I und gibt den berechneten Abstand zurück
%Diese Funktion wird von der Funktion F20_Strahlkomp und F20_KonturOffset aufgerufen

e=E2-E1;
r=(-e(1)*(E1(1)-I(1))-e(2)*(E1(2)-I(2)))/(e(1)^2+e(2)^2);
d=E1+r*e-I;
Abstand=norm(d);
if isnan(Abstand)
    Abstand=Inf;
end

end

