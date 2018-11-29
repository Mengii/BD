-------------------------------------------------------------------------
-- refcurseur
-------------------------------------------------------------------------
-- PL/SQL 
-- consultation sejour

create or replace function renvoyer_sejours(l_idc client.idc%type)
    return sys_refcursor
is
    c sys_refcursor;
begin
    open c for 
        select ids, idv, jour from sejour where idc=l_idc;
    return c;
end;
/

create or replace procedure consulter_sejours_refcurseur(l_idc client.idc%type)
is 
    c sys_refcursor;
    l_ids sejour.ids%type;
    l_idv sejour.idv%type;
    le_jour sejour.jour%type;
begin
    c := renvoyer_sejours(l_idc);
    loop
        fetch c into l_ids,l_idv,le_jour;
        exit when c%notfound;
        dbms_output.put_line(l_ids||' '||l_idv||' '||le_jour);
    end loop;
end;
/

set serveroutput on
exec consulter_sejours_refcurseur(2);

