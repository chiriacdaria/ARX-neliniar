clear all;
close all;
clc;
load('iddata-09.mat')
%% ARX NELINIAR- PROIECT 2

% grafice cu date primite
plot(id)
figure,plot(val)

u_id=id.u;
u_val=val.u;
y_id=id.y;
y_val=val.y;
MSEp_min=1000000;
MSEpv_min=1000000;
MSEs_min=1000000;
MSEsv_min=1000000;

%lungimi utilizate
N=length(u_id);
N1=length(y_id);
Nval=length(u_val);

%% selectare valori
n_ab=2;
m_max=2;
nk=1; % nk este mereu 1 deci nu influenteaza modelul => nu l-am adaugat in cod
t=1;

%% generare matrice
for m=1:m_max
    for na=1:n_ab
        for nb=1:n_ab
            n=na+nb;
            %%  PREDICTIE
            M=[];
            M_val=[];
            for i=1:length(u_id)
                el=[];
                el_val=[];
                for j=1:na
                    if((i-j)<=0)
                        el=[el, 0];
                        el_val=[el_val, 0];
                    elseif((i-j)>0)
                        el=[el, -y_id(i-j)];
                        el_val=[el_val, -y_val(i-j)];
                    end
                end
                for j=1:nb
                    if((i-j)<=0)
                        el=[el, 0];
                        el_val=[el_val, 0];
                    elseif((i-j)>0)
                        el=[el, u_id(i-j)];
                        el_val=[el_val, u_val(i-j)];
                    end
                end
                M=[M;el];
                M_val=[M_val;el_val];
            end

            % generare matrice regresori Q
            Q_id=genQ(M,m);
            Q_val=genQ(M_val,m);

            % calcul vector parametrhelper O
            O=Q_id\y_id; %vom folosi acelasi theta si pt validare

            % calcul iesire predictie aproximata
            yp_id=Q_id*O;
            yp_val=Q_val*O;

            %  MSE
            MSEp(t)=1/N*sum((y_id-yp_id).^2);
            MSEpv(t)=1/N*sum((y_val-yp_val).^2);

            %%  SIMULARE
            % iesirea de simulare
            ys_id=zeros(1,length(n));
            ys_val=zeros(1,length(n));

            Ms=[];
            Ms_val=[];
            for i=1:length(y_id)
                el=[];
                el_val=[];
                for j=1:na
                    if((i-j)<=0)
                        el=[el 0];
                        el_val=[el_val 0];
                    elseif((i-j)>0)
                        el=[el, -ys_id(i-j)];
                        el_val=[el_val, -ys_val(i-j)];
                    end
                end
                for j=1:nb
                    if((i-j)<=0)
                        el=[el, 0];
                        el_val=[el_val, 0];
                    elseif((i-j)>0)
                        el=[el, u_id(i-j)];
                        el_val=[el_val, u_val(i-j)];
                    end
                end
                Ms=[Ms;el];
                Ms_val=[Ms_val;el_val];

                % generare matrice regresori Q
                Qs_id=genQ(Ms(i,:),m);
                Qs_val=genQ(Ms_val(i,:),m);

                % calcul iesire predictie aproximata
                ys_id(i)=Qs_id*O; %folosim acelasi theta
                ys_val(i)=Qs_val*O;
            end
            ys_id=ys_id';
            ys_val=ys_val';

            %%  MSE

            MSEs(t)=1/N*sum((y_id-ys_id).^2);
            MSEsv(t)=1/N*sum((y_val-ys_val).^2);
            % cautam mse minim pt fiecare iesire

            %predictie
            %identificare
            if(MSEp(t)<MSEp_min)
                yp_id_min=yp_id;
                MSEp_min=MSEp(t);
            end

            %validare
            if(MSEpv(t)<MSEpv_min)
                yp_val_min=yp_val;
                MSEpv_min=MSEpv(t);
            end

            %simulare
            %identificare
            if(MSEs(t)<MSEs_min)
                ys_id_min=ys_id;
                MSEs_min=MSEs(t);

            end

            %validare
            if(MSEsv(t)<MSEsv_min)
                ys_val_min=ys_val;
                MSEsv_min=MSEsv(t)
            end

            %% valori pt tabel
            mt(t)=m;
            nat(t)=na;
            nbt(t)=nb;
            t=t+1;
        end
    end
end

%% GRAFICE
%predictie
figure
plot(y_id);hold on; plot(yp_id_min) ,legend('iesire identificare',"iesire identifcare aproximata"),grid
title('Iesirea de predictie aproximata pe datele de identificare.  MSE pred identificare min =',num2str(MSEp_min));

figure
plot(y_val);hold on;plot(yp_val_min),legend("iesire validare", "iesire validare aproximata "),grid;
title('Iesirea de predictie aproximata pe datele de validare. MSE pred validare min =',num2str(MSEpv_min));

figure
%simulare
plot(y_id); hold on; plot(ys_id_min),legend("iesire identificare","iesire identificare aproximata"),grid;
title('Iesirea de simulare aproximata pe datele de identificare. MSE sim identificare min =',num2str(MSEs_min));

figure
plot(y_val);hold on;plot(ys_val_min), legend("iesire validare","iesire validare aproximata"), grid;
title('Iesirea de simulare aproximata pe datele de validare. MSE sim validare min =' ,num2str(MSEsv_min));

%% tabel

mt=mt';
nat=nat';
nbt=nbt';
MSEpv=MSEpv';
MSEp=MSEp';
MSEsv=MSEsv';
MSEs=MSEs';
Table=table(mt,nat,nbt,MSEp, MSEpv, MSEs,MSEsv);
writetable(Table, 'table.xlsx')
Tbl=readmatrix('table.xlsx')

%% FUNCTIE

function P = allPerms(v)
[row ,cols]=size(v);
nr = row*cols;
if nr == 1
    P = v;
else
    P = zeros(factorial(nr),nr); %initializare matrice permutari
    F = 1:factorial(nr-1);
    for ii = 1:nr
        P(F,1) = v(ii);
        newVparam=setdiff(1:nr,ii);
        P(F,2:nr) = allPerms(v(newVparam));
        F = F + factorial(nr-1);
    end
end
end

function fct=genQ(M,m)

k=1;
grade=width(M);
Mexp = zeros(1,grade);
% generam o matrice care contine toate combinatile de exponenti ale regresorilor
for k=1:m
    for i=1:m
        V=zeros(1,grade);
        V(1)=k;
        for j=1:length(V)
            if j>1
                V(j)=i;
            end
            if sum(V)<=m
                C = unique(allPerms(V),'rows');
                Mexp=unique([Mexp; C],'rows');
            end
        end
    end
end
fct = zeros(length(M),width(M));
rows_number=length(Mexp);
cols_number=width(Mexp);
for i=1:rows_number
    Mprod=1;
    for j=1:cols_number
        feature_Exp=M(:,j).^(Mexp(i,j))
        Mprod=Mprod.*feature_Exp;
    end
    Q(:, i)=Mprod;
end
fct=Q;
end
