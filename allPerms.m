
function P = allPerms(v) %123
[row ,cols]=size(v); % o linie 3 coloane => nr=3
nr = row*cols; %daca nr de coloane si de linii este 1 atunci inseamna ca avem un element deci p va fi acel element
if nr == 1 
    P = v
else
    P = zeros(factorial(nr),nr); %initializare matrice permutari |||||| ---P=zeros(6,3)
    F = 1:factorial(nr-1); %stim ca la nr elemente avem nr! permutari |||||---F=1:2 -> 1 2
    for ii = 1:nr %luam pe rand pt fiecare element 
        % ii=1 
        % ii=2 
        % ii=3
        P(F,1) = v(ii) %punem in matrice valoarea pe pozitia ei 
        % P(1,1)=v(1)=1 
        % P(2,1)=v(2)=2
        % P(3,1)=v(3)=3
         newVparam=setdiff(1:nr,ii) %verifica ca valorile sa nu se repete 
         % newVparam= [2 3]
         % newVparam= [1 3]
         % newVparam = [1 2]
        P(F,2:nr) = allPerms(v(newVparam))
        % P(1,2)=[2 3] && P(1,3)=[3 2] recursiv => 1 2 3 && 1 3 2
        % P(2,2)=[1 3] P(2,3)=[3 1]recursiv => 2 1 3 && 2 3 1
        % P(3,2)=[1 2] && P(3,3)=[2 1] => 3 1 2 && 3 2 1 
        F = F + factorial(nr-1); %% F= 2 %% F=3
    end
end

