clear all;
close all;
clc;
load('iddata-09.mat')
%% ARX NELINIAR- PROIECT 2
%% grafice cu date primite

figure,plot(id)
figure,plot(val)

%eficientizare timp de executie
u_id=id.u;
u_val=val.u;
y_id=id.y;
y_val=val.y;

%lungimi utilizate
N=length(u_id);
N1=length(y_id);
Nval=length(u_val);

%% selectare valori
n_ab=1; %na=nb
m_max=3; %gradul maxim al polinomului, gradul va fi configurabil
t=1;
%% generare matrice

for m=1:m_max %grad configurabil
    for na=1:n_ab %na configurabil
        for nb=1:n_ab %nb configurabil
n=na+nb;
%% &&&&&&&&&&&&&& PREDICTIE &&&&&&&&&&&&&&
%      M=zeros(N,n);
%      M_val=zeros(Nval, n);
%      %na
%      for i=1:N1
%          el=[];
%          el_val=[];
%          for j=1:na   
%                 if ((i-j)>0)
%            M(i,j)=-y_id(i-j);
%            M_val(i,j)=-y_val(i-j);
%                 end
%          end
%    %nb
%          for j=1:nb   
%                 if ((i-j)>0)
%            M(i,na+j)=u_id(i-j);
%            M_val(i,na+j)=u_val(i-j);
%                 end
%          end
%      end

M=[];
M_val=[];
for i=1:length(y_id)
el=[];
el_val=[];
    for j=1:na
        if((i-j)<=0)
        el=[el 0];
        el_val=[el_val 0];
        elseif((i-j)>0)
        el=[el -y_id(i-j)];
        el_val=[el_val -y_val(i-j)];
        end
    end
     for j=1:nb
         if((i-j)<=0)
         el=[el 0];
        el_val=[el_val 0];
        elseif((i-j)>0)
        el=[el u_id(i-j)];
        el_val=[el_val u_val(i-j)];
        end
     end
M=[M;el];
M_val=[M_val;el_val];
end

%% generare matrice regresori Q
%dorim aproximarea iesirii de predictie

Q_id=genQ(M,m);
Q_val=genQ(M_val,m);

%% calcul vector parametrii O
O=Q_id\y_id; %vom folosi acelasi theta si pt validare

%% calcul iesire predictie aproximata

yp_id=Q_id*O;
yp_val=Q_val*O;
%%  MSE 
MSEp(t)=1/N*sum((y_id-yp_id).^2);
MSEpv(t)=1/N*sum((y_val-yp_val).^2);

%% &&&&&&&&&&&&&& SIMULARE &&&&&&&&&&&&&& 
%% iesirea de simulare

ys_id=zeros(1,length(n));
ys_val=zeros(1,length(n));


% % na


M=[];
M_val=[];
for i=1:length(y_id)
el=[];
el_val=[];
    for j=1:na
        if((i-j)<=0)
        el=[el 0];
        el_val=[el_val 0];
        elseif((i-j)>0)
        el=[el -ys_id(i-j)];
        el_val=[el_val -ys_val(i-j)];
        end
    end
     for j=1:nb
         if((i-j)<=0)
         el=[el 0];
        el_val=[el_val 0];
        elseif((i-j)>0)
        el=[el u_id(i-j)];
        el_val=[el_val u_val(i-j)];
        end
     end
M=[M;el];
M_val=[M_val;el_val];
% end
%% generare matrice regresori Q
% if i= 1:N
Qs_id=genQ(M(i,:),m);
Qs_val=genQ(M_val(i,:),m);

 %vom folosi acelasi theta si pt simulare

%% calcul iesire predictie aproximata
ys_id(i)=Qs_id*O;
ys_val(i)=Qs_val*O;
     end
     ys_id=ys_id';
     ys_val=ys_val';

%%  MSE 

MSEs(t)=1/N*sum((y_id-ys_id).^2);
MSEsv(t)=1/N*sum((y_val-ys_val).^2);

%% cautam mse minim pt fiecare iesire
MSEpv_min=intmax;
MSEp_min=intmax;
MSEsv_min=intmax;
MSEs_min=intmax;

%predictie
%identificare
if(MSEp(t)<MSEp_min)
    MSEp_min=MSEp(t);
    yp_id_min=yp_id;
end

MSEpmin=min(MSEp);
index0=find(MSEp==MSEpmin,1);
ypidmin=yp_id(index0)

%validare
if(MSEpv(t)<MSEpv_min)
    MSEpv_min=MSEpv(t);
    yp_val_min=yp_val;
end

%%asta e doar minimul nu minimul pt fiecare intrare
MSEpvmin=min(MSEpv)
index1=find(MSEpv==MSEpvmin,1);
ypvalmin=yp_val(index1)

%simulare
%identificare
if(MSEs(t)<MSEs_min)
    MSEs_min=MSEs(t);
    ys_id_min=ys_id;
end

%%am incercat nu merge
MSEsmin(t)=min(MSEs);
index2=find(MSEs==MSEsmin(t),1);
ysidmin=ys_id(index2)


%validare
if(MSEsv(t)<MSEsv_min)
    MSEsv_min=MSEsv(t);
    ys_val_min=ys_val;
end
MSEsvmin=min(MSEsv);
index3=find(MSEsv==MSEsvmin,1);
ysvalmin=ys_val(index3)

%% valori pt tabel
        mt(t)=m;
       nat(t)=na;
        nbt(t)=nb;
%% 
      t=t+1;

      
        end        
    end
end


%% GRAFICE
%predictie
plot(y_id) ;hold on; plot(yp_id_min); 
title('Iesirea de predictie aproximata pe datele de identificare');
figure
 plot(y_val,yp_val_min); 
title('Iesirea de predictie aproximata pe datele de validare');
% figure
%simulare
plot(y_id); hold on; plot(ys_id_min); 
title('Iesirea de simulare aproximata pe datele de identificare');
figure
plot(y_val);hold on;plot(ys_val_min); 
title('Iesirea de simulare aproximata pe datele de validare');


%% tabel

%&&&&&&&&&&&&&& m na nb &&&&&&&&&&&&&&& 

mt=mt';
nat=nat';
nbt=nbt';
MSEpv=MSEpv';
MSEp=MSEp';
MSEsv=MSEsv';
MSEs=MSEs';
Table=table(mt,nat,nbt,MSEp, MSEpv, MSEs,MSEsv);





%% FUNCTIE




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



