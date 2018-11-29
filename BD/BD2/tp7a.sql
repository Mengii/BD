-- 1.(a)

sqlplus c##mduan_a/mduan_a@dbinfo
select * from village;

grant insert 
on village
to c##zzhang4_a;

-- sqlplus c##zzhang4_a/zzhang4_a@dbinfo
-- seq_village marche pas si on a pas donné le droit sur le sequence
insert into c##mduan_a.village values (38, 'ABC', 'CDI', 44,22);

sqlplus c##mduan_a/mduan_a@dbinfo
select * from village;

------------------------------------------------------------------------
-- 1.(b)

sqlplus c##mduan_a/mduan_a@dbinfo

grant execute on traitement2 to c##zzhang4_a;
grant execute on traitement2 to c##ddiouf_a;
revoke execute on traitement2 from c##ddiouf_a;

-- sqlplus c##zzhang4_a/zzhang4_a@dbinfo

declare 
    iv village.idv%type;
    l_ids sejour.ids%type;
    a village.activite%type;
begin
    c##mduan_a.traitement2(4, 'Lille',36,iv,l_ids,a);
    dbms_output.put_line('idv '||iv||', ids '||l_ids||', activite '||a);
    c##mduan_a.traitement2(4, 'Paris',360,iv,l_ids,a);
    dbms_output.put_line('idv '||iv||', ids '||l_ids||', activite '||a);
end;
/

sqlplus c##mduan_a/mduan_a@dbinfo
select * from sejour;

------------------------------------------------------------------------
-- 2. voir feuile td(2)

------------------------------------------------------------------------
-- 3. actions 5,7,8,9

create view v_action8 as
    select idv, ville, activite, prix 
        from village 
        where idv not in (select idv from sejour);

grant select on v_action8 to c1,...,cn;

        ---------------------

create or replace procedure t2 = ...
grant execute on t2 to c1,..,cn;

