------------------------------------------------------------------
-- corr_contraintes.sql
-- tourne le 23 janvier 2018
------------------------------------------------------------------

/* Contraintes SQL et non SQL (partiels)

Contraintes SQL  (bonus en partiel/examen si presentation comme suit) :

client :
    idc pk
    nom not null
    age not null check 16<=age<=120
    avoir not null check 0<=avoir<=2000

village ;
    idv pk
    ville not null
    activite -- null possible
    prix not null check 0<prix<=2000
    capacite not null check 1<=capacite<=1000

sejour :
    ids pk
    idc fk client not null -- rappel : fk n'implique pas not null
    idv fk village not null
    jour not null check 1<=jour<=365
    (idc, jour) unique

creer sequences pour client, village, sejour

Contraintes non SQL :

1. le nombre de sejours pour un centre pour un jour ne peut pas depasser sa capacite :

    pour tout idv i de capacite n dans village,
    il y a au plus n lignes avec idv i pour chaque jour j dans sejour

2. l'avoir d'un client plus la somme des prix de ses séjours ne peut pas exceder 2000 :
    
    pour tout idc i dans client : avoir + s <= 2000
    en effet, un client part de 2000 et achete des séjours, donc :
    avoir + somme des prix de ses séjours presents + somme des prix de ses séjours détuits = 2000;
    donc avoir + somme des prix de ses séjours presents <= 2000;
    commenr obtient-on s : considerons toutes les lignes d'idc i dans séjour, et pour pour chacune, 
    à partir de sa colonne idv dans séjou, son prix dans village identiie par idv : on note s la somme 
    de tous ces prix
*/

/* Rappel :
Null :
Peuvent etre "null" les valeurs intuitivement non indispensable au fonctionnement de l'application. De plus,
par convention dans le module les colonnes utilisées en parametres ou à l'intérieur d'un traitement ne peuvent
etre "null", mais il n'est pas imposé que celles en sortie d'un traitement ne le soient pas.
Rappel : fk et check n'impliquent pas not null.
Contraintes non SQL :
en général, il s'agit de compter un ensemble de lignes d'une table, ou de comparer des valeurs dans deux tables, ou des variantes de ces situations (ex : somme d'un ensemble de lignes).
*/

----------------------------------------------------------------------------------------------------------------
-- Ordres SQL et modèles d'ordre : compléter avec nouveaux outils TD précédent
----------------------------------------------------------------------------------------------------------------
-- Ordree tapés par le programmeur :

drop table sejour cascade constraints;
drop table client cascade constraints;
drop table village cascade constraints;

create table client (
    idc int primary key,
    nom varchar2(10) not null,
    age int not null, check (0<=age and age<120),
    avoir int default 2000 not null, check (0<=avoir and avoir<=2000) 
);

create table village (
    idv int primary key,
    ville varchar2(12) not null,
    activite varchar2(10),
    prix int not null, check (0<prix and prix<=2000),
    capacite int not null, check (1<=capacite and capacite<=1000)
);

create table sejour (
    ids int primary key,
    idc int not null, foreign key (idc) references client,
    idv int not null, foreign key (idv) references village,
    jour int not null, check (1<=jour and jour<=365),
    unique (idc, jour)
);

drop sequence seq_client;
drop sequence seq_village;
drop sequence seq_sejour;

create sequence seq_client start with 1;
create sequence seq_village start with 10;
create sequence seq_sejour start with 100;

-------------------------------------------------------------------------------------------------------------------
-- employes :
-------------------------------------------------------------------------------------------------------------------
-- 1.
insert into village values (seq_village.nextval, 'NY', 'resto', 50, 200);
insert into village values (seq_village.nextval, 'NY', 'MOMA', 60, 300);
insert into village values (seq_village.nextval, 'Chatelaillon', 'kitesurf', 100, 20);

/* modele d'ordre :
creer_village(v, a, p, c) :
    insert into village values(seq_village.nextval, v, a, p, c);
    -- rem : pas de retour
*/

-------------------------------------------------------------------------------------------------------------------
-- 2. (inchangé)
select * from village;

-------------------------------------------------------------------------------------------------------------------
-- 3. (inchangé)
update village 
  set capacite = capacite + 10, 
      activite = 'kitesurf'
  where activite = 'resto';

/* modele d'ordre : ignore pour simplifier
parametres possibles : colonne et valeur de selection, valeur de modification
pour capacite et activite ; pas de retour ; 
colonne de selection en parametre est informel, mais on pourrait si on 
voulait coder par un entier chaque colonne et faire un switch
*/

-------------------------------------------------------------------------------
-- 4. (inchangé)
select * from sejour ;

-------------------------------------------------------------------------------
-- 5. (inchangé)
-- traitement 3 :
-- exemple sur le jour 100 :
select count(*) 
  from sejour 
  where jour<100;
delete sejour where jour<100;

/* modele d'ordre :
traitement3(le_jour) :
    select count(*)
        from sejour
        where jour < le_jour
        renvoie resultat dans : le_nombre;
    delete sejour 
        where jour < le_jour;
   retour traitement3 : le_nombre;

(variante possible : compter lignes, detruire, recompter et faire difference)
*/

-------------------------------------------------------------------------------
-- clients :
-------------------------------------------------------------------------------
-- 6.
-- traitement 1 : 

-- exemple sur Rita, age 22 :
insert into client(idc, nom, age) values(seq_client.nextval, 'Rita', 22);

-- exemple sur Riton, age 23 :
insert into client(idc, nom, age) values(seq_client.nextval, 'Riton', 23);

/* modele d'ordre :
traitement1(le_nom, l_age) :
    l_idc := seq_client.nextval; -- rem : variante par rapport à action 1
    insert into client(idc, nom, age) 
        values(l_idc, le_nom, l_age);
    retour traitement1 : l_idc;
*/

-------------------------------------------------------------------------------
-- 7.
-- traitement 2 :

-- exemple sur Rita, identifiant 1, achete pour NY le jour 45 :
select idv, prix, activite 
  from village 
  where ville = 'NY' 
    order by prix;
  -- renvoie : idv 11, prix 60, activite MOMA
update client 
  set avoir = avoir - 60 
  where idc = 1
    and nom = 'Rita';
insert into sejour values(seq_sejour.nextval, 1, 11, 45);

-- exemple sur Riton, identifiant 2, pour Chatelaillon le jour 365 :
select idv, prix, activite 
  from village 
  where ville = 'Chatelaillon'  
    order by prix;
  -- renvoie : idv 12, prix 90, activite kitesurf
update client 
  set avoir = avoir - 90 
  where idc = 2
    and nom = 'Riton';
insert into sejour values(seq_sejour.nextval, 2, 12, 365);

/* modele d'ordre :
traitement2(l_idc, la_ville, le_jour) :
    select idv, prix, activite 
        from village 
        where ville = la_ville
        order by prix decresc
        renvoie resultat dans : l_idv, le_prix, l_activite;
    si resultat existe alors 
        l_ids := seq_sejour.nextval; -- rem : il faut le renvoyer
        insert into sejour 
            values(l_ids, l_idc, l_idv, le_jour);
        update client 
            set avoir = avoir - le_prix
            where idc = l_idc;
    sinon 
        l_idv := -1; 
        l_ids = -1; 
        l_activite := 'neant';
    retour traitement2 : l_idv, l_ids, l_activite;
*/

-------------------------------------------------------------------------------
-- 8. (inchangé)
select idv, ville, activite, prix 
  from village 
  where idv not in (select idv 
                      from sejour);

-------------------------------------------------------------------------------
-- 9. (inchangé)

-- authentification (consultation client) : 
-- exemple sur Rita, identifiant 1 :
select *
 from client
 where idc = 1
   and nom = 'Rita';

-- consultation autres tables : 

select ids, sejour.idc, idv, jour 
  from sejour, client
  where sejour.idc = client.idc
    and client.idc = 1
    and client.nom = 'Rita';

select village.idv, ville, activite, prix, capacite
  from village, sejour, client
  where sejour.idc = client.idc
    and client.idc = 1
    and client.nom = 'Rita'
    and village.idv = sejour.idv;

/* modeles d'ordre : 
authentification(l_idc, le_nom) :
    select *
        from client
        where idc = l_idc
          and nom = le_nom
        resultat dans le_client;
    si resultat existe alors
        print('bienvenue'||le_client);
    sinon
        print('desole, erreur identifiant/nom');

consulter_informations(l_idc) :
    select ids, idv, jour
        from sejour
        where sejour.idc = l_idc
        afficher toutes les lignes resultat;
    select village.idv, ville, activite, prix, capacite
        from village, sejour
        where sejour.idc = l_idc
          and village.idv = sejour.idv
        afficher toutes les lignes resultat;
*/

-------------------------------------------------------------------------------
-- 10. (action faite par le systeme) (inchangé)

-- on suppose que le programmeur a cree dans l'action 0 la table
-- archive(ids, idc, idv, jour, avoir)

/* modele d'ordre : 
traitement 4(l_ids, l_idc, l_idv, le_jour)) : 
    -- ligne detruite supposee en parametre a ce stade du cours
    select avoir 
        from client 
        where idc = l_idc
        renvoie resultat dans : l_avoir
    insert into archive values(l_ids, l_idc, l_idv, le_jour, l_avoir);
*/

-------------------------------------------------------------------------------
/*
Ex. 2.c (violations de contraintes)
- non complet, à compléter, si possible en donnant pour chaque catégorie de 
  contraintes SQL toutes les manières de faire une violation

creer une violation pk et une fk :
  pk : 2 manières :
    insert un deuxieme client avec meme idc
    modifier un client existant en lui modifiant idc en idc déjà existant
    (meme chose possible sur village ou sejour)
  fk :  2 manières :
    supprimer  dans client une ligne dont l'idc apparait dans sejour
    inserer un sejour avec un idc n'apparaissant pas dans client
    (meme chose possible sur idv fk village)  

insert into client(idc, nom, age) values (2, 'Rita', 22);
insert into client(idc, nom, age) values (2, 'Jeanne', 21);
insert into client(idc, nom, age) values (3, 'Jeanne', 21);
update client set idc = 2 where idc = 3;

insert into village values (11, 'NY', 'MOMA', 60, 300);
insert into sejour values (100, 2, 11, 45);
delete from client where idc = 2;
insert into sejour values (101, 4, 11, 45);
*/

-------------------------------------------------------------------------------
-- the end --------------------------------------------------------------------
-------------------------------------------------------------------------------





 
     

