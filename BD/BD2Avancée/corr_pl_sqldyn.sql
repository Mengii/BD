-------------------------------------------------------------------------------
-- corr_pl_sqldyn.sql
-- TD 7b et 8b
-- tourne le 29 mars 2017
-------------------------------------------------------------------------------
-- TD 7 :

-------------------------------------------------------------------------------
-- 7.1 :

create or replace procedure detruire (tab varchar2) is
    -- ordre LDD
    texte varchar2(100);
begin
    texte := 'drop table '||tab; 
    dbms_output.put_line(texte);
    execute immediate texte;
end;
/

drop table t;
create table t(a int, b int);
select * from t;
set serveroutput on
exec detruire('t')

-- au lieu repeter trois fois drop table avec parametres differents :
-- on le fait sur deux tables hors CC TD pour eviter tout recreer.
drop table t;
drop table s;
create table t(a int, b int);
create table s(a int, b int);

begin
    detruire('t');
    detruire('s');
end;
/

-------------------------------------------------------------------------------
-- 7.2 :

create or replace procedure generique1 (p varchar2, n int) is
    texte varchar2(100);
begin
    texte := 'begin '||p||'('||n||'); end;';
    dbms_output.put_line(texte);
    execute immediate texte;
end;
/

set serveroutput on
exec generique1('consulter_informations',1)
exec generique1('consulter_informations',2)

-------------------------------------------------------------------------------
-- 7.3

create or replace procedure affiche_gen (
    t varchar2, a varchar2, b varchar2)
is
    texte varchar2(100); 
    cur sys_refcursor;
    x1 varchar2(10);
    x2 int;
begin
    texte := 'select '||a||','||b||' from '||t;
    dbms_output.put_line(texte);
    open cur for texte;
    loop
        fetch cur into x1, x2; 
        exit when cur%notfound;
        dbms_output.put_line(x1||', '||x2);
    end loop;
end;
/

set serveroutput on
select * from client;
select * from village;
exec affiche_gen('client', 'nom', 'age')
exec affiche_gen('village', 'activite', 'prix')

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- TD 8 :

-------------------------------------------------------------------------------
-- 8.1
-- Proc. qui prend f int->int et n et appelle f sur n. Testez avec traitement3.

create or replace procedure ex1 (
    f varchar2, n int)
is
    texte varchar2(100);
    m int;
begin
    texte := 'begin :1 := '||f||'('||n||'); end;'; 
    dbms_output.put_line(texte);
    execute immediate texte using out m;
    dbms_output.put_line(m);
end;
/

set serveroutput on
select * from sejour;
exec ex1('traitement3', 361)

-------------------------------------------------------------------------------
-- 8.2
-- Meme question avec proc. var out. Testez avec traitement3_out. 

create or replace procedure ex2 (
    f varchar2, n int)
is
    texte varchar2(100);
    m int;
begin
    -- seule cette ligne change : 
    texte := 'begin '||f||'('||n||', :1); end;';
    dbms_output.put_line(texte);
    execute immediate texte using out m;
    dbms_output.put_line(m);
end;
/

set serveroutput on
select * from sejour;
exec ex2('traitement3_out', 362)

-------------------------------------------------------------------------------
-- 8.3 
-- ordre DDL (methode 1), select, boucle avec variables

create or replace procedure duplique_gen (
    t varchar2, a varchar2, b varchar2, c varchar2, d varchar2) 
    authid current_user -- voir remarque ci-dessous
is
    texte varchar2(100); 
    texte2 varchar2(100); 
    cur sys_refcursor;
    x1 int;
    x2 varchar2(10);
    x3 int;
    x4 int;
begin
    -- on vise la chaine suivante ou u, v, w, x, y sont les parametres actuels
    -- 'create table u2(v2 int, w2 varchar2(10), x2 int, y2 int)'
    -- methode 1 :
    texte := 'create table '||t||'2('||a||'2 int, '||b|| '2 varchar2(10), '
                            ||c||'2 int, '||d||'2 int)';
    dbms_output.put_line(texte);
    execute immediate texte;
  
    -- on vise la chaine suivante ou u est le parametre actuel nom de la table
    -- insert into u2 values(:1, :2, :3, :4)
    texte := 'insert into '||t||'2 values(:1, :2, :3, :4)';
    dbms_output.put_line(texte);
    -- methode 1 :
    texte2 := 'select * from '||t;
    dbms_output.put_line(texte2);
    open cur for texte2;
    loop
        fetch cur into x1, x2, x3, x4; 
        exit when cur%notfound;
        -- methode 2 :
        execute immediate texte using x1, x2, x3, x4;
    end loop;
end;
/

/* rem : authid current_user permet d'executer une procedure avec les droits de
  celui qui execute le code (definer rights) par opposition au mode par defaut
  ou le code PL/SQL s'execute avec les droits celui qui a compile le code 
  (invoker rights) ; ici la table est creee chez celui qui execute la procedure
  c'est donc lui qui doit avoir les droits. 
*/

set serveroutput on
drop table client2;
select * from client;
exec duplique_gen('client', 'idc', 'nom', 'age', 'avoir');
select * from client;
select * from client2;
-- tester aussi avec table client vide

-------------------------------------------------------------------------------
-- 8.4

create or replace procedure traitement2_gen(
    ic client.idc%type, v village.ville%type, j sejour.jour%type,
    iv out village.idv%type, isej out sejour.ids%type, 
    a out village.activite%type,
    l varchar2)
is
    texte varchar2(100); 
begin
    texte := 
        'begin c##'||l||'.traitement2('||ic||','''||v||''','||j||
	',:1,:2,:3); end;';
    dbms_output.put_line(texte);
    execute immediate texte using out iv, out isej, out a;
end;
/

select * from client;
select * from village;
select * from sejour;
declare
  iv village.idv%type;
  isej sejour.ids%type;
  a  village.activite%type;
begin
  traitement2_gen(1,'NY',46,iv,isej,a,'ewaller_a'); -- tester aussi ewaller2_a
  dbms_output.put_line(iv||', '||isej||', '||a);
end;
/
select * from client;
select * from village;
select * from sejour;

-------------------------------------------------------------------------------
-- 8.5

create or replace function traitement1_gen(
    n client.nom%type, a client.age%type, l varchar2) 
    return client.idc%type
is
    texte varchar2(100); 
    ic client.idc%type;
begin
    texte := 
        'begin :1 := c##'||l||'.traitement1('''||n||''','||a||'); end;';
    dbms_output.put_line(texte);
    execute immediate texte using out ic;
    return ic;
end;
/

select * from client;
exec dbms_output.put_line(traitement1_gen('Jeanne', 21, 'ewaller_a'));
select * from client;

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
