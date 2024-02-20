

function out=genQ(M,m)
g=size(M,2);
Mexp = zeros(1,g);
% generam o matrice care contine toate combinatiile de exponenti ale regresorilor
for k=1:m
    for i=1:m
        v=[k zeros(1,g-1)];
        for j=1:length(v)
                if (j>1)
                    v(j)=i;
                end
                if(sum(v)<=m)
                    [C,ia,ic] = unique(perms(v),'rows');
                    [Mexp,ia,ic]=unique([Mexp; C],'rows');
                   end
        end
        end
end
% calculam matricea Phi, folosind matricea exponentilor si setul de iesiri si intrari intarziate
k=1;
for i=1:size(Mexp,1)
    Mprod=1;
    for j=1:size(Mexp,2)
        Mprod=Mprod.*M(:,j).^(Mexp(i,j));
    end
    Q(:,k)=Mprod;
    k=k+1;
end
out=Q;
end


