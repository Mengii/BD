-- a) exemple concret complet de pbm d'independance niv. (chronologie, acteurs impliques, reactions concretes)
      
      -- table CC avec contenu
	(101, 'SGBD sans peine', 'BD', 48, 2, 11)
      -- reorganisation SPI :
	coursSep(idcs, specialite)
	cours(idc, idcs, titre, volume, semestre, ide), ou idcn fk nomCours
      -- les lignes correspondant au contenu donne
	cours(101, 1, 'SGBD sans peine', 48, 2, 11)
	coursSep(1, 'BD')
      -- traitement 2 :
	select count(*) from cours where specialite = 'BD';
	insert ...
      -- erreur execution : colonne cours.specialite n'existe pas

-- b) ordres SQL concrets pour gerer le pbm preci (chronologie, acteurs impliques, reactions concretes)

      -- une vue pour la table village :
	create view vue_cours as
	  select idc, titre, specialite, volume, semestre, ide
		from cours;
      -- traitement 2 :
	select count(*) from vue_cours where specialite = 'BD';
	insert ...
      -- reorganisation SPI
      -- changement de vue seulement :
	create or replace view vue_cours as
	  select idc, titre, specialite, volume, semestre, ide
		from cours, coursSep
		   where cours.idcs = coursSep.idcs;

-------------------------------------------------------------------------------------------------------

create table enseignant(ide int, nom varchar2(20), specialite varchar2(10), serviceMax int);
create table cours(idc int, titre varchar2(50), specialite varchar2(10), volume int, semestre int, ide int);
create table limiteService(valeur int);

insert into enseignant values (11, 'Bruce Willis', 'BD', 175);
insert into enseignant values (12, 'Angelina Jolie', 'BD', 150);

insert into cours values (101, 'SGBD sans peine', 'BD', 48, 2, 11);
insert into cours values (102, 'Theorie des BD avec le sourire', 'BD', 60, 1, null);
insert into cours values (103, 'algo', 'algo', 45, 1, null);

insert into limiteService values (192);

select * from enseignant;
select * from cours;
select * from limiteService;

create sequence seq_enseignant start with 13;

create or replace procedure traitement2(
    le_nom enseignant.nom%type,
    la_sep enseignant.specialite%type,
    l_ide out enseignant.ide%type,
    le_nombre out int)
is
begin
    l_ide := seq_enseignant.nextval;
    insert into enseignant
        values (l_ide, le_nom, la_sep, 192);
    select count(*) into le_nombre from cours where cours.specialite = la_sep;
end;
/

set serveroutput on

declare
    idee enseignant.ide%type; 
    n int;
begin 
    traitement2('Duan','BD', idee, n);
    dbms_output.put_line('nv ide : '||idee||'nb de cours ds votre specialite : '||n);
end;
/

select * from enseignant;





















