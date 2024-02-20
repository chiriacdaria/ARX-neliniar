Pentru a aborda această etapă a proiectului, este necesar să aveți cunoștințe de bază despre modelele ARX liniare, conform materialului din curs, secțiunea Metode ARX. Metoda ARX neliniară este, de asemenea, expusă într-o anexă a aceleiași secțiuni.

Se furnizează un set de date măsurat de la un sistem dinamic cu o intrare și o ieșire. Ordinul sistemului nu depășește 3, iar dinamica poate fi neliniară, în timp ce ieșirea poate fi afectată de zgomot. Vom dezvolta un model de tip cutie neagră pentru acest sistem, folosind o structură ARX neliniară sub formă de polinom pentru semnalele de intrare și ieșire anterioare. Un al doilea set de date, măsurat de la același sistem, este furnizat pentru validarea modelului dezvoltat.

Cele două seturi de date sunt furnizate sub formă de fișier MATLAB, în variabilele "id" și "val," ambele fiind obiecte de tip "iddata" din toolbox-ul de identificare a sistemelor. Intrarea, ieșirea și perioada de eșantionare sunt disponibile în câmpurile "u," "y," și "Ts" ale acestor obiecte. În cazul în care toolbox-ul nu este instalat, aceleași seturi de date sunt furnizate și sub formă vectorială, "id array" și "val array," fiecare matrice având structura: valorile de timp pe prima coloană, intrarea pe a doua, și ieșirea pe ultima coloană.

Un model ARX neliniar, cu ordinele na, nb, și întârzierea nk, utilizând aceeași convenție ca și funcția MATLAB "arx," are structura:

<img width="573" alt="Captură de ecran din 2024-02-20 la 13 40 42" src="https://github.com/chiriacdaria/ARX-neliniar/assets/99746700/fc97c92e-adaa-450c-91e8-1461479804e1">
unde vectorul de ieșiri și intrări întârziate este notat 

d(k)=[y(k−1),...,y(k−na),u(k−nk),u(k−nk−1),...,u(k−nk−nb+1)] '
 , iar 
p este un polinom de gradul m al acestor variabile.

De exemplu, dacă 

na=nb=nk=1, atunci 

d=[y(k−1),u(k−1)]' , și dacă avem gradul 
m=2, putem scrie explicit polinomul:
y(k)=ay(k−1)+bu(k−1)+cy(k−1) ^2  +vu(k−1) ^2 +wu(k−1)y(k−1)+z


Parametrii modelului, reprezentați de a, b, c, v, w, z, sunt coeficienți reali. Notăm că modelul este neliniar și conține termeni pătratici și produse între variabilele întârziate, spre deosebire de ARX-ul standard, care ar include doar termeni liniari în y(k−1) și u(k−1). Un aspect esențial al modelului (1) este că este liniar în parametri, ceea ce înseamnă că parametrii pot fi găsiți folosind metoda regresiei liniare.

Este important să menționăm că forma liniară a ARX reprezintă un caz special al formei generale (1), obținut prin alegerea gradului m = 1, ceea ce conduce la:
(k)=ay(k−1)+bu(k−1)+c
și, în plus, impunând condiția c=0 pentru termenul liber. Fără această condiție, modelul se numește afin.

Cerințele pentru această etapă sunt următoarele. Trebuie să programați o funcție care generează un model ARX neliniar de tip polinomial, cu ordinele na, nb, și gradul m configurabile; nk poate fi lăsat să fie 1. Trebuie, de asemenea, programată procedura de regresie pentru identificarea parametrilor și utilizarea modelului cu intrări noi. Utilizarea acestui model poate fi realizată în două moduri:

Predictie (cu un pas inainte): Utilizând valorile reale ale ieșirilor întârziate ale sistemului. În exemplul (2), la pasul k, s-ar aplica ecuația (2) folosind variabilele  y(k−1) și u(k−1) în partea dreaptă a egalității.

Simulare: Ieșirile precedente ale sistemului nu sunt disponibile, deci pot fi folosite doar ieșirile anterioare ale modelului însuși. În exemplu, y(k−1) ar fi înlocuit cu valoarea simulată precedentă (k−1) în partea dreaptă a ecuației (2).

Identificați un astfel de model ARX neliniar folosind setul de date de identificare și validați-l pe setul de validare. Acordați atenție ordinilor modelului, precum și gradului polinomului, pentru a obține o performanță cât mai bună pe datele de identificare. Pentru a simplifica procedura de căutare, puteți lua 

na=nb. Prezentarea soluției dumneavoastră trebuie să includă cel puțin următoarele elemente:

O introducere care să cuprindă o descriere a problemei.
O scurtă descriere a structurii aproximatoare și a procedurii de găsire a parametrilor.
Orice caracteristici esențiale ale soluției 
