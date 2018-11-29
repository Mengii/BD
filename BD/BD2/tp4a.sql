---------------------------------------------------------------------

create or replace procedure authentification(
    l_idc client.idc%type,
    le_nom client.nom%type)
is
    cursor c is
        select *
            from client
            where idc = l_idc
            and nom = le_nom;
    le_client client%rowtype;
begin
    open c;
    fetch c into le_client;
    if c%found then 
        dbms_output.put_line('bienvenue '||le_client.nom);
    else 
        dbms_output.put_line('desole, erreur identifiant/nom');
    end if;
    close c;
    dbms_output.put_line('Fin de procedure');
end;
/

set serveroutput on
exec authentification(1, 'Duan');  -- client existe
exec authentification(2, 'Duang');  -- client existe pas
select * from client;

-------------------------------------------------------------------

create or replace procedure consulter_information(
    l_idc client.idc%type)
is 
    cursor c is
        select village.idv, ville, activite, prix, capacite
            from village, sejour
            where sejour.idc = l_idc
            and village.idv = sejour.idv;
    l_idv village.idv%type;
    la_ville village.ville%type;
    l_activite village.activite%type;
    le_prix village.prix%type;
    la_capacite village.capacite%type;
begin 
    for x in(
        select ids, idv, jour
            from sejour
            where sejour.idc = l_idc)
    loop 
        dbms_output.put_line('ids : '||x.ids||' idv : '||x.idv||' jour : '||x.jour);
    end loop;
    
    open c;
    fetch c into l_idv, la_ville, l_activite, le_prix, la_capacite;
    while c%found loop
        dbms_output.put_line('J''ai une activite '||l_activite||' sous le prix de '||le_prix||' euros, a '||la_ville);
        fetch c into l_idv, la_ville, l_activite, le_prix, la_capacite;
    end loop;
    close c;

    dbms_output.put_line('Fin de procedure');
end;
/

set serveroutput on
exec consulter_information(1);
select * from sejour;
select * from client;



