-------------------------------------------------------------------
-- corr_pl_curseurs.sql
-------------------------------------------------------------------
-- authentification

create or replace procedure authentification(
    l_idc client.idc%type,
    le_nom client.nom%type)
is
    cursor c is
        select *
            from client
            where idc = l_idc
                and nom = le_nom;
    le_client c%rowtype;
    message varchar2(50);
begin
    open c;
    fetch c into le_client;
    if c%found then 
        message := 'bienvenue '||le_client.nom||', '||le_client.age
                    ||' ans, avoir '||le_client.avoir;
    else 
        message := 'desole, erreur identifiant/nom';
    end if;
    close c;
    dbms_output.put_line(message);
    dbms_output.put_line('Fin de procedure');
end;
/

set serveroutput on
exec authentification(2, 'Rita');  -- client existe
exec authentification(1, 'Rita');  -- client existe pas
select * from client;

-------------------------------------------------------------------
-- consulter informations client :
-- forme curseurs generale :

create or replace procedure consulter_sejours1(l_idc client.idc%type)
is
    cursor c is
        select ids, idv, jour
            from sejour
            where sejour.idc = l_idc;
    l_ids sejour.ids%type;
    l_idv sejour.idv%type;
    le_jour sejour.jour%type;
begin
    open c;
    fetch c into l_ids, l_idv, le_jour;
    while c%found loop
        dbms_output.put_line('sejour '||l_ids||', '||l_idv||', '||le_jour);
        fetch c into l_ids, l_idv, le_jour;
    end loop;
    dbms_output.put_line('Fin affichage');
end;
/

select * from sejour;
select * from village;

set serveroutput on
exec consulter_sejours1(1);
exec consulter_sejours1(5);

-- forme curseurs plus elegante :

create or replace procedure consulter_sejours2(l_idc client.idc%type)
is
    cursor c is
        select ids, idv, jour
            from sejour
            where sejour.idc = l_idc;
    l_ids sejour.ids%type;
    l_idv sejour.idv%type;
    le_jour sejour.jour%type;
begin
    open c;
    loop
        fetch c into l_ids, l_idv, le_jour;
        exit when c%notfound;
        dbms_output.put_line('sejour '||l_ids||', '||l_idv||', '||le_jour);
    end loop;
    dbms_output.put_line('Fin affichage');
end;
/

select * from sejour;
select * from village;

set serveroutput on
exec consulter_sejours1(1);
exec consulter_sejours1(5);

-- forme curseur simplifiee :

create or replace procedure consulter_sejours3(l_idc client.idc%type)
is
    for x in (
        select ids, idv, jour
            from sejour
            where sejour.idc = l_idc)
    loop
        dbms_output.put_line('sejour '||x.ids||', '||x.idv||', '||x.jour);
    end loop;
    dbms_output.put_line('Fin affichage');
end;
/

select * from sejour;
select * from village;

set serveroutput on
exec consulter_sejours1(1);
exec consulter_sejours1(5);

-- forme curseur avec variable rowtype curseur (rowtype sejour pas adapte) :

create or replace procedure consulter_sejours4(l_idc client.idc%type)
is
    cursor c is
        select ids, idv, jour
            from sejour
            where sejour.idc = l_idc;
    le_client c%rowtype;
begin
    open c;
    fetch c into le_client;
    while c%found loop
        dbms_output.put_line(
            'sejour '||le_client.ids||', '||le_client.idv||', '
            ||le_client.jour);
        fetch c into le_client;
    end loop;
    dbms_output.put_line('Fin affichage');
end;
/

select * from sejour;
select * from village;

set serveroutput on
exec consulter_sejours1(1);
exec consulter_sejours1(5);

-- rem : consulter_indormations avec for-x-in; autres formes ci-dessus

create or replace procedure consulter_informations(l_idc client.idc%type)
is
    for x in (
        select ids, idv, jour
            from sejour
            where sejour.idc = l_idc)
    loop
        dbms_output.put_line('sejour '||x.ids||', '||x.idv||', '||x.jour);
    end loop;
    dbms_output.put_line('Fin sejours');
    for x in (
        select distinct village.idv, ville, activite, prix, capacite
            from village, sejour
            where sejour.idc = l_idc
                and village.idv = sejour.idv)
    loop
        dbms_output.put_line(
            'village '||x.idv||', a '||x.ville||', '||x.activite||', '
            ||x.prix||' euros/jour, '||x.capacite||' lits');
    end loop;
    dbms_output.put_line('Fin villages');
end;
/

select * from sejour;
select * from village;

set serveroutput on
exec consulter_sejours1(1);
exec consulter_sejours1(5);

-------------------------------------------------------------------
-- traitement 2 :

create or replace procedure traitement2(
    l_idc client.idc%type,
    la_ville village.ville%type,
    le_jour sejour.jour%type,
    l_idv out village.idv%type,
    l_ids out sejour.ids%type,
    l_activite out village.activite%type)
is
    cursor c is 
        select idv, prix, activite
            from village
            where ville = la_ville
            order by prix desc;
    le_prix village.prix%type;
begin
    open c;
    fetch c into l_idv, le_prix, l_activite;
    if c%found then
        l_ids := seq_sejour.nextval;
        insert into sejour
            values(l_ids, l_idc, l_idv, le_jour);
        update client
            set avoir = avoir - le_prix
            where idc = l_idc;
    else
        l_idv := -1;
        l_ids := -1;
        l_activite := 'neant';
    end if;
end;
/

select * from client;
select * from village;
select * from sejour;

declare 
    iv village.idv%type;
    l_ids sejour.ids%type;
    a village.activite%type;
begin
    traitement2(1, 'Chatelaillon',361,iv,l_ids,a);
    dbms_output.put_line('idv '||iv||', ids '||l_ids||', activite '||a);
    traitement2(1, 'Chatelaillon',360,iv,l_ids,a);
    dbms_output.put_line('idv '||iv||', ids '||l_ids||', activite '||a);
end;
/

select * from sejour;

























