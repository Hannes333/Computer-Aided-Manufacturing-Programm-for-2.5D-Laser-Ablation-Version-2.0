function [ V ] = F26( E1,b,v,L )
%F25 versetzt den Eckpunkt E1 entlang der Winkelhalbierenden so weit, bis
%er zu beiden angrenzenden Kanten den Abstand L hat.
%Dieser berechnete Punkt wird als neuer Eckpunkt V berechnet
%Eine Kante wird von E0 und E1 aufgespannt
%Die zweite Kante wird von E1 und E2 aufgespannt
%Diese Funktion, wird von Funktion F20_Strahlkomp aufgerufen

%if isequal(round(E0*1000000)/1000000,round(E1*1000000)/1000000)
%    warning('E0 und E1 sind indentisch in F26');
%end
%if isequal(round(E1*1000000)/1000000,round(E2*1000000)/1000000)
%    warning('E1 und E2 sind identisch in F26');
%end   

if L==0
    V=E1;
else
    %alpha=acos((v(1)*b(1)+v(2)*b(2))/(v(1)^2+v(2)^2)^0.5);
    %V=E1+b*L/sin(alpha);
    V=E1+b*L/(1-((v(1)*b(1)+v(2)*b(2))/(v(1)^2+v(2)^2)^0.5)^2)^0.5;
    %if ((v(1)>=0&&b(1)>=0)||(v(1)<=0&&b(1)<=0))&&((v(2)>=0&&b(2)>=0)||(v(2)<=0&&b(2)<=0))
    %    error('v und b zeigen in selbe Richtung');
    %    V=E1+b*L;
    %end
    
    
    %{
    v1=E1-E0;
    v1=v1/norm(v1);
    v2=E2-E1;
    v2=v2/norm(v2);
    crossp=v1(1)*v2(2)-v1(2)*v2(1); %Kreuzprodukt der aufeinanderfolgenden Vektoren

    if crossp>0.000001
        status=1;
        b=(-v1+v2)*status;                
        b=b/norm(b); 
        alpha=0.5*acos((-v1(1)*v2(1)-v1(2)*v2(2))/(norm(v1)*norm(v2)));
        h=L/sin(alpha);
        V=E1+b*h;
    elseif crossp<-0.000001
        status=-1;
        b=(-v1+v2)*status;
        b=b/norm(b); 
        alpha=0.5*acos((-v1(1)*v2(1)-v1(2)*v2(2))/(norm(v1)*norm(v2)));
        h=L/sin(alpha);
        V=E1+b*h;
    else
        if ((v1(1)>=0&&v2(1)>=0)||(v1(1)<=0&&v2(1)<=0))&&((v1(2)>=0&&v2(2)>=0)||(v1(2)<=0&&v2(2)<=0))
            %warning('v1 und v2 zeigen in selbe Richtung');
            b=[-v2(2),v2(1)];
            V=E1+b*L;
        else %v1 und v2 zeigen in entgegengesetzte Richtung 
            %warning('v1 und v2 zeigen in entgegengesetzte Richtung');
            b=v2;
            V=E1+b*L;
        end
    end
    %}
end

end

