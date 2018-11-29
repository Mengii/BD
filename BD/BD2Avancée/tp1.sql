-- tp1.sql

drop table sejour;
drop table client;
drop table village;

create table client(
    idc int,
    nom varchar2(10),
    age int,
    avoir int default 2000
);

create table village(
    idv int,
    ville varchar2(12),
    activite varchar2(10),
    prix int,
    capacite int
);

create table sejour(
    ids int,
    idc int,
    idv int,
    jour int
);

create table archive(
    ids int,
    idc int,
    idv int,
    jour int,
    avoir int
);


