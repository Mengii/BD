------------------------------------------------------------------------------------------------------------------------------
-- tp8b
------------------------------------------------------------------------------------------------------------------------------
-- 8.0.a

create or replace procedure ex0 (f varchar2, n int) is
    texte_ordre varchar2(100);
    y int;
begin
    texte_ordre := 'begin :1 := '||f||'('||n||'); end;';
    dbms_output.put_line(texte_ordre);
    execute immediate texte_ordre using out y;
    dbms_output.put_line('nombre de jour detruit : '||y);
end;
/

select * from sejour;

set serveroutput on
execute ex0 ('traitement3', 20);

select * from sejour;

-- 8.0.b

create or replace procedure ex02 (p varchar2, n int) is -- n -> jour dans traitement3
    texte_ordre varchar2(100);
    y int; -- variable out de traitement3
begin
    texte_ordre := 'begin '||p||'('||n||', :1); end;'; -- begin traitement3_out(20, :1); end;
    dbms_output.put_line(texte_ordre);
    execute immediate texte_ordre using out y;
    dbms_output.put_line('nombre de jour detruit : '||y);
end;
/

select * from sejour;

set serveroutput on
execute ex02 ('traitement3_out', 20);

select * from sejour;

------------------------------------------------------------------------------------------------------------------------------
-- 8.1 t(a,b,c,d) -> t2(a2,b2,c2,d2)

create or replace procedure duplique_gen (t varchar2, a varchar2, b varchar2, c varchar2, d varchar2) authid current_user is
    texte_ordre varchar2(100);
    cur sys_refcursor;
    x1 int;
    x2 varchar2(10);
    x3 int;
    x4 int;
begin
    texte_ordre := 'create table '||t||'2('||a||'2 int, '||b||'2 varchar2(10), '||c||'2 int, '||d||'2 int)';
    execute immediate texte_ordre;
    open cur for 'select * from '||t;
    texte_ordre := 'insert into '||t||'2 values (:1, :2, :3, :4)';
    loop
        fetch cur into x1, x2, x3, x4;
        exit when cur%notfound;
        execute immediate texte_ordre using x1, x2, x3, x4;
    end loop;
end;
/

select * from client;
execute duplique_gen ('client', 'idc', 'nom', 'age', 'avoir');
select * from client2;

------------------------------------------------------------------------------------------------------------------------------
-- 8.2

create or replace procedure traitement2_gen (l varchar2, 
    l_idc client.idc%type,
    la_ville village.ville%type,
    le_jour sejour.jour%type,
    l_idv out village.idv%type,
    l_ids out sejour.ids%type,
    l_activite out village.activite%type) 
is
    texte_ordre varchar2(100);
begin
    texte_ordre := 'begin c##'||l||'.traitement2('||l_idc||', '''||la_ville||''', '||le_jour||', :1, :2, :3); end;';
    dbms_output.put_line(texte_ordre);
    execute immediate texte_ordre using out l_idv, out l_ids, out l_activite;
end;
/

-- chez c##zzhang4
grant execute on traitement2 to c##mduan_a;

-- chez moi

declare 
    iv village.idv%type;
    l_ids sejour.ids%type;
    a village.activite%type;
begin 
    traitement2_gen ('zzhang4_a', 3, 'Chatelaillon',361,iv,l_ids,a); -- grant droit execution à moi
    dbms_output.put_line('idv '||iv||', ids '||l_ids||', activite '||a);
end;
/

-- chez c##zzhang4
select * from sejour;
select * from client;

------------------------------------------------------------------------------------------------------------------------------
-- 8.3

create or replace function traitement1_gen( 
    u varchar2, 
    le_nom client.nom%type,
    l_age client.age%type)
    return client.idc%type
is
    l_idc client.idc%type;
    texte_ordre varchar2(100);
begin
    texte_ordre := 'begin :1 := c##'||u||'.traitement1('''||le_nom||''', '||l_age||'); end;';
    dbms_output.put_line(texte_ordre);
    execute immediate texte_ordre using out l_idc;
    return l_idc;
end;
/

exec dbms_output.put_line(traitement1_gen('zzhang4_a','Zhang',60));
        












