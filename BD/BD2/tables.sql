drop table sejour cascade constraints;
drop table client cascade constraints;
drop table village cascade constraints;

create table client(
    idc int primary key, 
    nom varchar2(10) not null,  -- on ignore la vérification des caractères bizarres
    age int not null, check (age >= 18 and age <= 120),
    avoir int default 2000 not null,
    check (avoir >= 0 and avoir <= 2000)
);

create table village(
    idv int primary key,
    ville varchar2(12) not null,  -- pas unique
    activite varchar2(10),  -- null possible (jamais utilisé + pas de param pour aucune action)
    prix int not null, check (prix >= 10 and prix <= 2000),
    capacite int not null,
    check (capacite >= 5 and capacite <= 5000)
);

create table sejour(
    ids int primary key,
    idc int not null,foreign key (idc) references client,
    idv int not null,foreign key (idv) references village,
    jour int not null,check (jour >= 1 and jour <= 365),
    unique (idc, jour)
);

drop sequence seq_client;
drop sequence seq_village;
drop sequence seq_sejour;

create sequence seq_client start with 1;
create sequence seq_village start with 10;
create sequence seq_sejour start with 100;
-----------------------------------------------------------------------------------------
insert into village values (seq_village.nextval, 'NY', 'resto', 50, 200);
insert into village values (seq_village.nextval, 'NY', 'MOMA', 60, 300);
insert into village values (seq_village.nextval, 'Chatelaillon', 'kitesurf', 100, 20);

select * from village;
---------------------------------------------------------------------------------------
insert into client(idc, nom, age) values(seq_client.nextval, 'Rita', 22);
insert into client(idc, nom, age) values(seq_client.nextval, 'Riton', 23);

select * from client;
----------------------------------------------------------------------------
select idv, prix, activite from village where ville = 'NY' order by prix;
update client set avoir = avoir - 60 where idc = 1 and nom = 'Rita';
select * from client;
insert into sejour values(seq_sejour.nextval, 1,11,45);
select * from sejour;

