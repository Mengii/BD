----------------------------------------------------------------------
----------
-- bibiotheque
-- contraintes SQL
-- ssh1
----------------------------------------------------------------------
----------

create table livre(
	idl integer primary key,
	titre varchar(24), -- null possible dans CC
	auteur varchar(13) not null, -- null possible?
	unique (titre,auteur)
);

/*
livre :
idl pk
titre not null
auteur not null
unique (titre, auteur)
*/

----------------------------------------------------------------------

create table exemplaire(
	ide integer primary key,
	idl integer, foreign key (idl) references livre,
	etat varchar(5),
	check (etat = 'neuf' or etat = 'bon' or etat = 'vieux')
);

/*
idl fk livre
check etat in (neuf, bon, vieux)
check age < 120
*/

----------------------------------------------------------------------

create table emprunt(
	ide integer unique, foreign key (ide) references exemplaire, -- ide null?
	idc integer, foreign key (idc) references client
);

