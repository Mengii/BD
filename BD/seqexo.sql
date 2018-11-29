drop table people;
drop table owner;

create table people(
    num int primary key,
    nom varchar2(10),
    age int
);

create table owner(
    num int, foreign key (num) references people,
    voiture varchar2(10)
);

drop sequence sgbd;
create sequence sgbd;
-- insérer dans la base Toto, 21 ans, ayant une Ferrari
insert into people values (sgbd.nextval, 'toto', 21);
insert into owner values (sgbd.currval, 'ferrari');
select * from people;
select * from owner;

---------------------------------------------------------------------------

drop table livre cascade constraints;
drop table exemplaire cascade constraints;

create table livre (
    idl integer primary key,
    titre varchar(24),  -- null possible dans CC
    auteur varchar(13) not null,  -- null possible?
    unique (titre, auteur)
);

/*
livre :
idl pk
titre not null
auteur not null
unique (titre, auteur)
*/

create table exemplaire (
    ide integer primary key,
    idl integer, foreign key (idl) references livre,
    etat varchar(5), 
    check (etat = 'neuf' or etat = 'bon' or etat = 'vieux')
);

/*
exemplaire :
ide pk
idl fk livre,
check etat in ('neuf', 'bon','vieux')
*/

insert into livre values (2, null, 'He');
insert into exemplaire values (1, 2, 'neuf');
insert into exemplaire values (1, 3, 'neuf');  -- err : ide unique
insert into exemplaire values (2, 3, 'neuf');  -- err : integrity constraint - parent key not found
insert into exemplaire values (3, 2, 'po');    -- err : check constraint violated
insert into exemplaire values (4, null, 'bon'); -- fk n'implique pas not null
insert into exemplaire values (5, 2, 'bon'); -- fk n'implique pas unique
select * from exemplaire;

-----------------------------------------------------------------------------
drop table client;
drop table village;

create table client (
     idc int primary key,
     nom varchar2(10) not null,
     age int not null, check (0 <= age and age < 120),
     avoir int default 2000, check (0 <= avoir and avoir <= 2000) -- default/check n'impliquent pas not null
);

insert into client(idc,nom,age) values (1, 'Pierre', 28);
insert into client values (2, 'Duan', 23, null);
select * from client;

create table village (
     ids int primary key,
     ville varchar2(12) not null,
     activite varchar2(10),
     prix int not null, check (0<prix and prix<=2000),
     capacite int not null, check (1<=capacite and capacite<=1000)
);

drop sequence seq_village;
create sequence seq_village start with 10;

insert into village values (seq_village.nextval, 'NY', 'resto', 50, 200);
insert into village values (seq_village.nextval, 'NY', 'MOMA', 60, 300);
insert into village values (seq_village.nextval, 'Chatelaillon', 'kitesurf', 100, 20);

select * from village;


































