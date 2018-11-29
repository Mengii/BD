declare
   z varchar2(15);
begin
   z:='Hello world';
   dbms_output.put_line(z);
end;
/

-----------------------------------------------------------------------------------

drop table personne;
create table personne(
    nom varchar2(10),
    age int,
    activite varchar2(10)
);

insert into personne values('Riton', 22, 'SGBD');
insert into personne values('Rita', 21, 'tango');
insert into personne values('Jeanne', 20, 'sieste');
select * from personne;

--procedure annif : augmente age 1, toutes les personnes mm age: mm activite

/* modele d'ordre :
anniversaire(le_nom)
	update personne
	    set age = age +1
	    where nom = le_nom;
	select age, activite
	    from personne
	    where nom = le_nom;
	    renvoie resultat dans : l_age, l_activite
	update personne
	    set activite = l_activite
	    where age = l_age;
	retour anniversaire : neant --> procedure
*/
create or replace procedure anniversaire(
	le_nom personne.nom%type)
is 
	l_age personne.age%type;
	l_activite personne.activite%type;
begin
	update personne
	    set age = age +1
	    where nom = le_nom;
	select age, activite
	    into l_age, l_activite
	    from personne
	    where nom = le_nom;
	update personne
	    set activite = l_activite
	    where age = l_age;
end;
/

execute anniversaire('Rita');
select * from personne;

-- fonction age : age d'une personne a partir de son nom

create or replace function age(
	le_nom personne.nom%type)
	return personne.age%type  
is
	l_age personne.age%type;
begin
	select age 
	   into l_age
	   from personne
	   where nom = le_nom;
	return l_age;
end;
/

set serveroutput on
exec dbms_output.put_line('Rita a '||age('Rita')||' ans');
select * from personne;

-- procedure avec parametre out : transformer fct age en proc avec param out
create or replace procedure age_out(
	le_nom personne.nom%type,
	l_age out personne.age%type) -- remplace return + declaration variable
is
begin
	select age 
	   into l_age
	   from personne
	   where nom = le_nom;
	-- pas de return ici non plus
end;
/

set serveroutput on

declare 
	a personne.age%type;
begin
	age_out('Rita',a);
	dbms_output.put_line('Rita a '||a||' ans');
end;
/

----------------------------------------------------------------------------------
create or replace procedure incr(n integer, res out integer) is
begin
	res:= n+1;
end;
/

set serveroutput on

declare
   k integer;
begin
   incr(4,k);
   dbms_output.put_line('le successeur de 4 est '||k);
end;
/

------------------------------------------------------------------------------------------

-- fonction sans param : 
create or replace function age_max
	return personne.age%type
is
	l_age personne.age%type;
begin
	select max(age)
           into l_age
           from personne;
        return l_age;
end;
/

set serveroutput on

exec dbms_output.put_line(age_max);  -- n'oublie pas exec != a l'interieur d'une procedure
				     -- == execute une procedure
select * from personne;

------------------------------------------------------------------------------------------------

-- utilisation sequence :
drop table t cascade constraints;
drop sequence seq;
create table t(a int primary key, b int);
create sequence seq;
select * from t;

set serveroutput on

create or replace procedure proc_seq is
	id t.a%type;
begin
	id:= seq.nextval;
	insert into t values(id, 11);
/* variante :
        insert into t values(seq.nextval, 11);
        id := seq.currval;
*/
	dbms_output.put_line('valeur generee : '||id);
end;
/

exec proc_seq;  -- == execute proc_seq
select * from t;
exec proc_seq;
select * from t;

drop procedure anniversaire;
drop function age;
drop procedure age_out;
drop function age_max;
drop procedure proc_seq;










