drop table cliente;
drop table produit;
drop table commande;
drop table retour;

create table cliente(
	idcl int,
	nomcl varchar2(10),
	tel varchar2(10),
	avoir int
);
insert into cliente values(1, 'Riton', '0698765432', 50);
select * from cliente;

create table produit(
	idp int,
	nompr varchar2(10),
	prix int,
	stock int
);
insert into produit values(10, 'cravate', 15, 157);
select * from produit;

create table commande(
	idco int,
	idcl int,
	idp int,
	quantite int,
	jour int
);
insert into commande values(20, 1, 10, 2, 31);
insert into commande values(21, 1, 10, 5, 35);
insert into commande values(22, 1, 10, 8, 39);
select * from commande;

create table retour(
	idr int,
	idco int,
	jour int,
	statut varchar2(10)
);
insert into retour values(30, 20, 33, 'a_traiter');
insert into retour values(31, 21, 37, 'a_traiter');
select * from retour;

------------------------------------------------------------------------------------------

drop table archive_retour;
create table archive_retour(
	jour int, --date de ce retour
	idcl int, --id du client
	idco int --les id de toutes les commandes de ce client
);
select * from archive_retour;

set serveroutput on

create or replace trigger traitement1
	before update of statut
	on retour
	for each row
declare 
	l_idcl cliente.idcl%type;
	l_idco commande.idco%type;
	cursor c is
		select idco from commande
			where idcl = (select idcl from commande where idco = :old.idco);
begin
	select idcl into l_idcl from commande where idco = :old.idco;
	open c;
	fetch c into l_idco;
	if c%found then
		insert into archive_retour values (:old.jour, l_idcl, l_idco);
		dbms_output.put_line(
		'archivage de retour mis a traite : ('
		||:old.jour||', '||l_idcl||', '||l_idco||')');
	else
		insert into archive_retour values (null, l_idcl, l_idco);
	end if;
	close c;
end;
/

update retour set statut = 'traite' where idr = 30; --archivage de retour mis a traite : (33, 1, 20, 30)
update retour set statut = 'traite' where idr = 31; --archivage de retour mis a traite : (37, 1, 21, 31)

SQL> select * from archive_retour;

      JOUR	 IDCL	    IDCO	IDR
---------- ---------- ---------- ----------
	33	    1	      20	 30
	37	    1	      21	 31

SQL> select * from retour;

       IDR	 IDCO	    JOUR STATUT
---------- ---------- ---------- ----------
	30	   20	      33 traite
	31	   21	      37 traite

