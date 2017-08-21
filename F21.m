function [ k,I ] = F21( S1,b1,S2,b2 )
%F21 berechnet den Schnittpunkt I zweier Vektoren b1 und b2 
%b1 startet bei S1, b2 startet bei S2
%k ist der Faktor, um den b1 und b2 multipliziert werden müssen, um
%Schnittpunkt I zu erhalten
%Diese Funktion wird von der Funktion F20_Strahlkomp und F20_KonturOffset aufgerufen

%if b1(1)/b2(1)==b1(2)/b2(2)
%   error('b1 und b2 sind parallel');
%   k=Inf;
%   I=[Inf,Inf];
%end

k=(b2(1)*(S1(2)-S2(2))+b2(2)*(S2(1)-S1(1)))/(b1(1)*b2(2)-b1(2)*b2(1));
I=S1+k*b1;

end

