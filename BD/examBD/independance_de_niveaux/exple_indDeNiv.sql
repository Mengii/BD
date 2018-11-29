drop table billet cascade constraints;
create table billet (client varchar2(10), dest varchar2(10), prix integer);
insert into billet values ('Riton', 'Rio', 100);
insert into billet values ('Rita', 'Saint Trop', 50);
select * from billet;

grant select on billet to c##zzhang4_a;

--c##zzhang4_a
select client from c##mduan_a.billet where dest = 'Saint Trop';

-------------------------------------------------------------------------------------
-- pbm :
----------

-- confidentialite :
--c##zzhang4_a
select * from c##mduan_a.billet where dest <> 'Saint Trop';
select * from c##mduan_a.billet where dest = 'Saint Trop';
select * from c##mduan_a.billet;

-- independance des niveaux : 
--c##mduan_a
drop table billet;
drop table voyage;
drop table train;

create table voyage(client varchar2(10), idt integer);
create table train(idt integer, dest varchar2(10), prix integer);

insert into voyage values('Riton',1);
insert into voyage values('Rita',2);

insert into train values(1, 'Rio', 100);
insert into train values(2, 'Saint Trop', 50);

select * from voyage;
select * from train;

grant select on voyage to c##zzhang4_a;
grant select on train to c##zzhang4_a;

--c##zzhang4_a
select client from c##mduan_a.billet where dest = 'Saint Trop'; -- erreur

-------------------------------------------------------------------------------------
-- gestion parfaite :
----------------------

revoke select on billet from c##zzhang4_a;

create or replace view billetsainttrop as
select client from billet where dest = 'Saint Trop';
grant select on billetsainttrop to c##zzhang4_a;

-- confidentialite parfaite :
select * from c##mduan_a.billetsainttrop;
--ok

-- independance des niveaux parfaite : 
--c##mduan_a
drop table billet;
drop table voyage;
drop table train;

create table voyage(client varchar2(10), idt integer);
create table train(idt integer, dest varchar2(10), prix integer);

insert into voyage values('Riton',1);
insert into voyage values('Rita',2);

insert into train values(1, 'Rio', 100);
insert into train values(2, 'Saint Trop', 50);

select * from voyage;
select * from train;

-- ici pendant qlq ms vue indefinie
select * from c##mduan_a.billetsainttrop; --ERROR at line 1:
					  --ORA-04063: view "C##MDUAN_A.BILLETSAINTTROP" has errors

-- mais redevient accessible des que c##mduan_a a tape :
create or replace view billetsainttrop as
select client from voyage,train 
	where voyage.idt = train.idt
		and dest = 'Saint Trop';
-- rem : inutile refaire grant

--c##zzhang4_a
select * from c##mduan_a.billetsainttrop;
--ok

