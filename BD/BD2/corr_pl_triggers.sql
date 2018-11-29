---------------------------------------------------------------------------------------
-- tourne le 16 mars 2018
-- tp5a
-- utilise ../pl_bases/corr_pl.sql corrige de tout jusqu'à présent
---------------------------------------------------------------------------------------
-- trigger archivage niveau ligne :
-- pour simplifier on ignore les contraintes sur la table d'archivage

drop table archive_sejour;
create table archive_sejour(
    ids int,
    idc int,
    idv int,
    jour int,
    avoir int
);

create or replace trigger traitement4 
    before delete
    on sejour
    for each row
declare 
    l_avoir client.avoir%type;
begin
    select avoir 
        into l_avoir
        from client
        where idc = :old.idc;
    insert into archive_sejour 
        values(:old.ids, :old.idc, :old.idv, :old.jour, l_avoir);
    dbms_output.put_line(
        'archivage de la ligne supprimé : ('||:old.ids||' , '||:old.idc||
        ' , '||:old.idv||' , '||:old.jour||' , '||l_avoir||')');
end;
/

show errors;
-- rem : compte lignes dans show errors commence au declare

set serveroutput on
-- rappel : drop table fait implicitement drop trigger sur cette table
delete from archive_sejour;
insert into sejour values(100,2,11,45);
insert into sejour values(101,3,12,365);
select * from archive_sejour;
select * from sejour;
select * from client;

-- 2 lignes, direct ou depuis programme :
delete from sejour where jour < 365;
exec dbms_output.put_line(traitement4(365));
-- 1 ligne :
delete from sejour where jour <= 50;
-- 0 ligne :
delete from sejour where jour <= 1;

---------------------------------------------------------------------------------------
-- trigger niveau table :
-- rappel : on ne gere que le cas de la mise a jour : insertion sejour (cas general vu ult.)

-- necessaire sinn se declenche avant celui ci-dessous (before avant after) :
drop trigger contrainte_depenses_ligne;

drop trigger contrainte_depenses_table;
create or replace trigger contrainte_depenses_table
    after insert
    on sejour
declare 
    cursor c is 
        select client.idc, nom, avoir, sum(prix) as depenses
            from client, sejour, village
            where client.idc = sejour.idc
                and sejour.idc = village.idv
            group by client.idc, nom, avoir
                having avoir + sum(prix) > 2000;
    le_client c%rowtype;
begin
    open c;
    fetch c into le_client;
    if c%found then
        raise_application_error(
            -20001, 'violation contrainte depenses '||
            '(avoir '||le_client.avoir||
            ', depenses '||le_client.depenses||')');
    end if;
end;
/

select * from client;
select * from village;
select * from sejour;
delete sejour;
insert into sejour values(110,1,12,364);
insert into sejour values(111,3,12,363);
insert into sejour values(112,1,12,362);

−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−
−− trigger niveau ligne : 
−− Rem : pas necessaire dropper trigger table (cf ci−dessus). 
drop trigger contrainte_depenses_ligne;
create or replace trigger contrainte_depenses_ligne
    before insert −− before necessaire sinon probleme "mutating table" :
                  −− le trigger doit s’executer AVANT que la table mute
                  −− (faire lien avec exemples cours)
    on sejour
    for each row 
declare
    l_avoir client.avoir%type;
    depenses_precedentes int;
    le_prix village.prix%type;
begin
    select avoir
        into l_avoir
from client
where idc = :new.idc; −− :old impossible cause before (no data found)
    select sum(prix)
        into depenses_precedentes −− rem : vide sans erreur si idc n’existe pas 
        from sejour, village
        where idc = :new.idc
          and village.idv = sejour.idv;
    select prix
        into le_prix
        from village
        where idv = :new.idv;
    dbms_output.put_line(
        'debug : avoir '||l_avoir||
', depenses precedentes −'||depenses_precedentes||'−'||
        ', prix nouveau sejour '||le_prix);
    if l_avoir+depenses_precedentes+le_prix > 2000 then
        raise_application_error(
    −20002, 'violation contrainte depenses pour client '||:old.idc||
    '(avoir '||l_avoir||
    ', depenses '||(depenses_precedentes+le_prix)||')');
    end if;
end;
/
show errors
select * from client;
select * from village;
select * from sejour;
delete sejour;
−− rem : ordres hors CC, mais le but est de verifier des erreurs :
insert into sejour values(110, 1, 12, 364);
insert into sejour values(111, 1, 12, 363);
insert into sejour values(112, 1, 12, 362);

−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−
−− archives pour corriges futurs :
/* 
Pour generaliser il faudrait traiter aussi udpate avoir, update prix, 
update idv ou idc dans sejour.
Du coup tout est dans le trigger (sinon il faudrait factoriser dans fonction 
ce qui serait duplique dans differents triggers sur les differentes tables). 
*/
select client.idc, nom, avoir, sum(prix)
    from client, sejour, village
    where client.idc = sejour.idc
      and sejour.idv = village.idv
    group by client.idc, nom, avoir
      having avoir + sum(prix) > 2000;

select * from client;
select * from village;
select * from sejour;

select *
    from client c
    where 
        (select sum(prix)
            from village, sejour
            where sejour.idc = c.idc
             and village.idv = sejour.idv
        ) + avoir > 2000;

create or replace function verifier_depenses_boolean
    return boolean
is
    cursor c is
        select client.idc, nom, avoir, sum(prix)
            from client, sejour, village
            where client.idc = sejour.idc
              and sejour.idv = village.idv
            group by client.idc, nom, avoir
              having avoir + sum(prix) > 2000;
    le_client c%rowtype;
begin
    open c;
    return c%found;
end;
/

begin
    if verifier_depenses_boolean then
        dbms_output.put_line('contrainte verifiee');
    else
        dbms_output.put_line('violation contrainte');
    end if;
end;
/

create or replace procedure verifier_depenses
is
begin
    if not(verifier_depenses_boolean) then
        raise_application_error(−20001, 'contrainte verifie');
    end if;
end;
/

create or replace trigger contrainte_depenses_global
    after insert
    on sejour
declare
begin
    verifier_depenses;
end;
/


















































































