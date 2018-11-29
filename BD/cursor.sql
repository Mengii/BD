-- while (sans test vide)
-- juste while peut + if --> voir aff6
create or replace procedure aff1(age_max personne.age%type) is
	cursor c is select nom, age from personne where age <= age_max;
	le_nom personne.nom%type;
	l_age personne.age%type;
begin
	open c;
	fetch c into le_nom, l_age;
	while c%found loop
	    dbms_output.put_line(le_nom||' a '||l_age||' ans');
	    fetch c into le_nom, l_age;
	end loop;
	close c;
	dbms_output.put_line('Fin de procedure');
end;
/

set serveroutput on
exec aff1(30);
select * from personne;
exec aff1(20);
exec aff1(19);  -- ne fait rien lors que personne non trouvee
----------------------------------------------------------------------------
-- loop exit when c%notfound
create or replace procedure aff2(age_max personne.age%type) is
	cursor c is select nom, age from personne where age <= age_max;
	le_nom personne.nom%type;
	l_age personne.age%type;
begin
	open c;
	loop				-- sorte de do-while 
	    fetch c into le_nom, l_age; -- fetch unique, avant le print
	    exit when c%notfound;	-- test de sortie de boucle
	    dbms_output.put_line(le_nom||' a '||l_age||' ans');
	end loop;
	close c;
	dbms_output.put_line('Fin de procedure');
end;
/

exec aff2(30);
select * from personne;
exec aff2(20);
exec aff2(19);
-----------------------------------------------------------------------------
-- for x in + requete (sans cursor)
create or replace procedure aff3(age_max personne.age%type) is
	-- pas de declaration de vatiables
begin
	for x in (select nom, age from personne where age <= age_max) loop
		-- requete a l'interieur du code => pas de declaration de cursor
	    dbms_output.put_line(x.nom||' a '||x.age||' ans');
	end loop;
	dbms_output.put_line('Fin de procedure');
	-- variante : declarer cursor c, puis: for x in c loop
end;
/

exec aff3(30);
select * from personne;
exec aff3(20);
exec aff3(19);
--------------------------------------------------------------------------------
-- for x in + cursor
create or replace procedure aff32(age_max personne.age%type) is
	cursor c is select nom, age from personne where age <= age_max;
begin
	for x in c loop  -- pas de open c
	    dbms_output.put_line(x.nom||' a '||x.age||' ans');
	end loop;        -- ni close c
	dbms_output.put_line('Fin de procedure');
end;
/

set serveroutput on

exec aff32(30);           
select * from personne;
exec aff32(20);
exec aff32(19);
--------------------------------------------------------------------------------
-- rowtype
create or replace procedure aff4(age_max personne.age%type) is
	cursor c is select *  -- toutes les colonnes
		from personne 
		where age <= age_max;
	la_personne personne%rowtype;  -- rowtype
begin
	open c;
	loop
	    fetch c into la_personne;
	    exit when c%notfound;
	    dbms_output.put_line(la_personne.nom||' a '||la_personne.age||' ans');
	end loop;
	close c;
	dbms_output.put_line('Fin de procedure');
end;
/

exec aff4(30);
exec aff4(20);
exec aff4(19);
----------------------------------------------------------------------------------------
-- if (test si vide)
-- une seule ligne possible (order by nom par exemple)
create or replace procedure aff5(age_max personne.age%type) is
	cursor c is select nom, age from personne where age <= age_max order by nom;
	le_nom personne.nom%type;
	l_age personne.age%type;
begin
	open c;
	fetch c into le_nom, l_age;
	if c%found then
		dbms_output.put_line(le_nom||' a '||l_age||' ans');
	else
		dbms_output.put_line('Il n''y a personne de moins de '||(age_max+1)||' ans');
	end if;
	close c;
	dbms_output.put_line('Fin de procedure');
end;
/

exec aff5(30);
select * from personne;
exec aff5(20);
exec aff5(19);
-------------------------------------------------------------------------------------------------
-- while + if 
create or replace procedure aff6(age_max personne.age%type) is
	cursor c is select nom, age from personne where age <= age_max;
	le_nom personne.nom%type;
	l_age personne.age%type;
begin
	open c;
	fetch c into le_nom, l_age;
	if c%found then
		while c%found loop
	    	      dbms_output.put_line(le_nom||' a '||l_age||' ans');
	    	      fetch c into le_nom, l_age;
		end loop;
	else
		dbms_output.put_line('Il n''y a personne de moins de '||(age_max+1)||' ans');
	end if;
	close c;
	dbms_output.put_line('Fin de procedure');
end;
/

set serveroutput on

exec aff6(30);
select * from personne;
exec aff6(20);
exec aff6(19); 

drop procedure aff1;
drop procedure aff2;
drop procedure aff3;
drop procedure aff4;
drop procedure aff5;
drop procedure aff6;
------------------------------------------------------------------------------------
-- authentification
-- utilise if/then/else car une seule ligne possible
create or replace procedure authentification(
       l_idc client.idc%type,
       le_nom client.nom%type)
is
       cursor c is
	   select * 
		from client
		where idc = l_idc
		    and nom = le_nom;
       le_client c%rowtype;  -- == client%rowtype;
       msg varchar2(50);
begin
       open c;
       fetch c into le_client;
       if c%found then
	  msg := 'Bienvenue '||le_client.nom||', '||le_client.age
		 ||' ans, avoir '||le_client.avoir;
       else
	  msg := 'Desole, erreur identifiant/nom';
       end if;
       dbms_output.put_line(msg);
end;
/

select * from client;
set serveroutput on
exec authentification(1, 'Pierre');
exec authentification(2, 'Duan');
exec authentification(3, 'Duan');
-------------------------------------------------------------------------------
-- forme curseur avec variable rowtype curseur (rowtype sejour pas adapte)
create or replace procedure consulter_sejour4(l_idc client.idc%type) is
	cursor c is select ids,idv,jour from sejour where sejour.idc = l_idc;
	le_client c%rowtype; -- lignes ds table sejour mais sejour%rowtype marche pa
begin
	open c;
	fetch c into le_client;
	while c%found loop
		dbms_output.put_line(
		     'sejour '||le_client.ids||', '||le_client.idv||', '
                      ||le_client.jour);
		fetch c into le_client;
	end loop;
	dbms_output.put_line('fin affichage');
end;
/

select * from sejour;
set serveroutput on
exec consulter_sejour4(1);
-------------------------------------------------------------------------
-- conso_infos avec 2 for-x-in (sejour+village)
create or replace procedure conso_infos(l_idc client.idc%type) is
begin
   for x in (select ids,idv,jour from sejour where sejour.idc = l_idc) loop
      dbms_output.put_line('sejour '||x.ids||', '||x.idv||', '||x.jour);
   end loop;
   dbms_output.put_line('fin sejour');
   for x in (
	select distinct village.idv, ville, activite, prix, capacite
	     from village, sejour
	     where sejour.idc = l_idc
		and village.idv = sejour.idv) loop
	dbms_output.put_line(
		'village '||x.idv||', a '||x.ville||', '||x.activite||', '
		||x.prix||' euros/jour, '||x.capacite||' lits');
   end loop;
   dbms_output.put_line('fin village');
end;
/

select * from sejour;
select * from village;
set serveroutput on
exec conso_infos(1);
-------------------------------------------------------------------------
-- t2 : l'achat d'un sejour
-- proc avec param out pour val de retour
create or replace procedure t2(
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

set serveroutput on

declare 
	iv village.idv%type;
	l_ids sejour.ids%type;
	a village.activite%type;
begin
	t2(1, 'Chatelaillon', 361, iv, l_ids, a);
	dbms_output.put_line(' idv '||iv||', ids '||l_ids||', activite '||a);	
	t2(2, 'Chatelaillon', 49, iv, l_ids, a);
	dbms_output.put_line(' idv '||iv||', ids '||l_ids||', activite '||a);
	t2(3, 'NY', 52, iv, l_ids, a);
	dbms_output.put_line(' idv '||iv||', ids '||l_ids||', activite '||a);
end;
/

select * from sejour;
-----------------------------------------------------------------------------
-- t1: inscription du client
create or replace function t1(
	le_nom client.nom%type,
	l_age client.age%type)
	return client.idc%type
is 
	l_idc client.idc%type;
begin
	l_idc := seq_client.nextval;
	insert into client(idc, nom, age)
		values(l_idc, le_nom, l_age);
	return l_idc;
end;
/

select * from client;
set serveroutput on
exec dbms_output.put_line('nouvel identifiant : '||t1('Jules',23));
select * from client;














