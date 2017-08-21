function [ status,b,Sstatus ] = F24( E0,E1,E2,Sstatus )
%F24 berechnet die Winkelhalbierende b und den Status von Eckpunkt E1
%Diese Funktion, wird von Funktion F20_Strahlkomp aufgerufen
%E0 ist der linke benachbarte Eckpunkt von E1
%E2 ist der rechte benachbarte Eckpunkt von E1
%Falls ein Eckpunkt vom Status 2 gefunden wird, wird Sstatus auf 2 gesetzt

%if isequal(round(E0*1000000)/1000000,round(E1*1000000)/1000000)
%    warning('E0 und E1 sind indentisch in F26');
%end
%if isequal(round(E1*1000000)/1000000,round(E2*1000000)/1000000)
%    warning('E1 und E2 sind identisch in F26');
%end    
    
v1=E1-E0;
v1=v1/norm(v1);
v2=E2-E1;
v2=v2/norm(v2);
crossp=v1(1)*v2(2)-v1(2)*v2(1); %Kreuzprodukt der aufeinanderfolgenden Vektoren

if crossp>0.000001
    status=1;
    b=(-v1+v2)*status;                
    b=b/norm(b); 
elseif crossp<-0.000001
	status=-1;
	b=(-v1+v2)*status;
    b=b/norm(b); 
else
    if ((v1(1)>=0&&v2(1)>=0)||(v1(1)<=0&&v2(1)<=0))&&((v1(2)>=0&&v2(2)>=0)||(v1(2)<=0&&v2(2)<=0))
        %v1 und v2 zeigen in die selbe Richtung
        status=0;
        b=[-v2(2),v2(1)];
    else
        %v1 und v2 zeigen in entgegengesetzte Richtung 
        status=2;
        b=v2;
        Sstatus=2;
    end
end

end