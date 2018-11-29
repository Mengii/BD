------------------------------------------------------------------------
-- corr_pl_bases.sql
-- tourne le 26 janvier 2017 sur le corrigé du TD2
------------------------------------------------------------------------
-- traitement 3.
-- on adapte le modèle d'ordre à la syntaxe PL/SQL

create or replace function traitement3 (
    le_jour sejour.jour%type)
    return integer
is
    le_nombre integer;
begin
    select count(*)
        into le_nombre
        from sejour
        where jour < le_jour;
    delete sejour
        where jour < le_jour;
    return le_nombre;
end;
/

-- tester :
set serveroutput on
-- deux select suivants inutiles dans cet exercice mais visualise la base :
select * from client;
select * from village;
select * from sejour;
exec dbms_output.put_line(traitement3(364));
select * from sejour;
exec dbms_output.put_line(traitement3(365));
select * from sejour;

------------------------------------------------------------------------
-- traitement 3 par procedure avec variables out :
-- on adapte la version ci-dessus par procedure :

create or replace procedure traitement3_out (
    le_jour sejour.jour%type,
    le_nombre out integer)
is
begin
    select count(*)
        into le_nombre
        from sejour
        where jour < le_jour;
    delete sejour
        where jour < le_jour;
end;
/

select * from sejour;
set serveroutput on
declare 
    n int;
begin
    traitement3_out(56,n); 
    dbms_output.put_line('Nombre de sejours detruits :'||n);
end;
/

select * from sejour;

------------------------------------------------------------------------
-- traitement 1

create or replace function traitement1 (
    le_nom client.nom%type,
    l_age client.age%type)
    return client.idc%type
is
    l_idc client.idc%type;
begin
    l_idc := seq_client.nextval;
    insert into client(idc, nom, age)
        values (l_idc, le_nom, l_age);
    return l_idc;
end;
/

set serveroutput on
select * from client;
exec dbms_output.put_line('nouvel identifiant : '||traitement1('Jeanne',23));
select * from client;
exec dbms_output.put_line('nouvel identifiant : '||traitement1('Paul',24));
select * from client;

------------------------------------------------------------------------
-- traitement 4 : non fourni mais y a pas de piege

------------------------------------------------------------------------
-- creerVillage

create or replace procedure creerVillage (
    la_ville village.ville%type,
    l_activite village.activite%type,
    le_prix village.prix%type,
    la_capacite village.capacite%type)
is 
    l_idv village.idv%type;
begin
    l_idv := seq_village.nextval;
    insert into village 
        values(l_idv, la_ville, l_activite, le_prix, la_capacite);
end;
/

select * from village order by idv;
set serveroutput on
exec creerVillage('Lyon', 'tour', 70, 150);
select * from village order by idv;




