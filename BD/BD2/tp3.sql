------------------------------------------------------------------------
tp 3a + tp 4b
------------------------------------------------------------------------

create sequence seq_village start with 10;

create or replace procedure creerVillage(
    v varchar2, a varchar2, p int, c int)
is 
begin
    insert into village values(
        seq_village.nextval, v, a, p ,c);
end;
/
show errors

-------------------------------------------------------------------------

create or replace function traitement3(
    le_jour sejour.jour%type)
    return int
is 
    le_nombre int;
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

set serveroutput on
exec dbms_output.put_line(traitement3(10)||' jours ont été suprimé');
select * from sejour;

execute traitement3(30);  ------ pour exécuter la procédure
select * from sejour;

-------------------------------------------------------------------------

-- traitement3 par procedure avec variable out :

create or replace procedure traitement3_out(
    le_jour sejour.jour%type,
    le_nombre out int)
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

declare
    n int;
begin 
    traitement3_out(10, n);
    dbms_output.put_line(n||' jours ont été suprimé');
end;
/
select * from sejour;

-------------------------------------------------------------------------------

create or replace function traitement1(
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


