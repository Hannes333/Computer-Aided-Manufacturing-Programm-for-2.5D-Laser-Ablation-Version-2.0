function [ crossp ] = F23( S,b,I )
%F23 entscheidet, ob der Punkt I links, rechts oder auf dem Vektor b liegt.
%Vektor b startet im Punkt S
%Diese Funktion, wird von Funktion F20_Strahlkomp aufgerufen

r=(-b(1)*(S(1)-I(1))-b(2)*(S(2)-I(2)))/(b(1)^2+b(2)^2);
d=S+r*b-I;
crossp=b(1)*d(2)-b(2)*d(1);

end