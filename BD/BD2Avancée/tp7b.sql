-------------------------------------------------------------------------------------------------------------
-- tp7b
-------------------------------------------------------------------------------------------------------------

-- 1.(a)

create or replace procedure detruire (t varchar2) is
    texte varchar2(100);
begin
    texte := 'drop table '||t;
    dbms_output.put_line(texte);
    execute immediate texte;
end;
/

drop table t;
create table t (a int, b int);
insert into t values(1,2);

select * from t;

set serveroutput on
exec detruire('t');
select * from t; -- table or view does not exist

--------------------------------------------------------------------------------------
-- 1.(b)
-- bloc ephemere

begin
    detruire ('a');
    detruire ('b');
    detruire ('c');
end;
/

drop table a;
create table a (a int, b int);
insert into a values(1,2);

drop table b;
create table b (a int, b int);
insert into b values(3,4);

drop table c;
create table c (a int, b int);
insert into c values(5,6);

select * from a;
select * from b;
select * from c;

--------------------------------------------------------------------------------------
-- 2.(a)

create or replace procedure generique1 (p varchar2, n int) is
    texte varchar2(100);
begin
    texte := 'begin '||p||'('||n||'); end;';
    dbms_output.put_line(texte);
    execute immediate texte;
end;
/

set serveroutput on
exec  generique1('consulter_information',1);

--------------------------------------------------------------------------------------
-- 3.

create or replace procedure affiche_gen (t varchar2, a varchar2, b varchar2) is 
    texte varchar2(100);
    out_a varchar2(10);
    out_b varchar2(10);
    c sys_refcursor;
begin
    texte := 'select '||a||','||b||' from '||t;
    dbms_output.put_line(texte);
    open c for texte;
    loop
        fetch c into out_a, out_b;
        exit when c%notfound;
        dbms_output.put_line(out_a||' '||out_b);
    end loop;
end;
/

exec affiche_gen('client', 'nom', 'age');
exec affiche_gen('village', 'ville', 'prix'); -- executable mais error : ville varchar2(12) 
                                              -- describe village 
exec affiche_gen('village','activite','prix'); -- no problem car activite varchar2(10) == out_a varchar2(10)
    
--------------------------------------------------------------------------------------
-- 4. creer une table avec deux colonnes de type int

create or replace procedure creer_table (t varchar2, a varchar2, b varchar2) 
authid current_user is 
    texte varchar2(100);
begin
    texte := 'create table '||t||'('||a||' int, '||b||' int)';
    dbms_output.put_line(texte);
    execute immediate texte;
end;
/

set serveroutput on
exec creer_table ('tab','a','b');



































