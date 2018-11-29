-- a) exemple concret complet de pbm d'independance niv. (chronologie, acteurs impliques, reactions concretes)
      
      -- table CC avec contenu
	(10, 'Ferrari', 2)
      -- reorganisation SPI :
	voitureMarque(idvm, marque)
	typeVoiture(idt, idvm, nbSieges), ou idvm fk voitureMarque
      -- les lignes correspondant au contenu donne
	voitureMarque(40, 'Ferrari')
	typeVoiture(10, 40, 2)
      -- traitement 4 :
	select idt from typeVoiture
		where marque = 'Ferrari' and nbSieges = 2;
	insert ...
	insert ...
	insert ...
      -- erreur execution : colonne typeVoiture.marque n'existe pas

-- b) ordres SQL concrets pour gerer le pbm preci (chronologie, acteurs impliques, reactions concretes)

      -- une vue pour la table village :
	create view vue_typeVoiture as
	  select idt, marque, nbSieges
		from voitureMarque;
      -- traitement 4 :
	select idt from vue_typeVoiture
		where marque = 'Ferrari' and nbSieges = 2;
	insert ...
	insert ...
	insert ...
      -- reorganisation SPI
      -- changement de vue seulement :
	create or replace view vue_typeVoiture as
	  select idt, marque, nbSieges
		from voitureMarque, typeVoiture;
-------------------------------------------------------------------------------------------------------
drop table cliente;
create table cliente(idc int, nom varchar2(20), tel varchar2(10));
create table typeVoiture(idt int, marque varchar2(50), nbSieges varchar2(10));
create table offre(ido int, idc int, idt int, dest varchar2(20));
create table demande(idd int, idc int, dest varchar2(20), marque varchar2(50), statut varchar2(10));
create table covoiturage(idco int, ido int, idc int);

insert into cliente values (1, 'Riton', '0612345678');
insert into typeVoiture values (10, 'Ferrari', 2);
insert into offre values (20, 1, 10, 'SaintTrop');
insert into demande values (30, 3, 'Berlin', 'Porsche', 'pieton');
insert into covoiturage values (100, 20, 4);

select * from cliente;
select * from typeVoiture;
select * from offre;
select * from demande;
select * from covoiturage;

drop seq_cliente;
create sequence seq_cliente start with 2;
create sequence seq_offre start with 21;
create sequence seq_demande start with 31;
create sequence seq_type start with 11;

create or replace procedure traitement4(
    le_nom cliente.nom%type,
    la_dest varchar2,
    la_marque typeVoiture.marque%type,
    le_nbPlace typeVoiture.nbSieges%type,
    l_idc out cliente.idc%type,
    l_id out int)
is
    cursor c is
	select idt from typeVoiture
		where marque = la_marque and nbSieges = le_nbPlace;
    l_idt typeVoiture.idt%type;
begin
    l_idc := seq_cliente.nextval;
    insert into cliente(idc, nom)
        values (l_idc, le_nom);
    dbms_output.put_line('une ligne insere dans client');
    if le_nbPlace = -1 then
	l_id := seq_demande.nextval;
	insert into demande values (l_id, l_idc, la_dest, la_marque, 'pieton');
	dbms_output.put_line('une ligne insere dans demande');
    else
	open c;
    	fetch c into l_idt;
    	if c%found then 
		l_id := seq_offre.nextval;
		l_idt := seq_type.nextval;
		insert into offre values (l_id, l_idc, l_idt, la_dest);
		dbms_output.put_line('une ligne insere dans offre');
	else
		l_idt := seq_type.nextval;
		insert into typeVoiture values (l_idt, la_marque, le_nbPlace);
		dbms_output.put_line('une ligne insere dans typeVoiture');
		l_id := seq_offre.nextval;
		insert into offre values (l_id, l_idc, l_idt, la_dest);
		dbms_output.put_line('une ligne insere dans offre');
	end if;
	close c;
    end if;
end;
/

set serveroutput on

declare -- demande
    idcc cliente.idc%type; 
    id int;
begin 
    traitement4('Duan','Lille', 'Bezz', -1, idcc, id);
    dbms_output.put_line('nv idc : '||idcc||' nv idd : '||id);
end;
/
select * from cliente;
select * from demande;

declare -- offre avec type trouve
    idcc cliente.idc%type; 
    id int;
begin 
    traitement4('Boulkhir','Paris', 'Ferrari', 2, idcc, id);
    dbms_output.put_line('nv idc : '||idcc||' nv ido : '||id);
end;
/
select * from cliente;
select * from offre;

declare -- offre avec type non trouve
    idcc cliente.idc%type; 
    id int;
begin 
    traitement4('He','Rome', 'Mini Cooper', 1, idcc, id);
    dbms_output.put_line('nv idc : '||idcc||' nv ido : '||id);
end;
/


select * from cliente;
select * from typeVoiture;
select * from offre;





















