drop table t;
create table t(a integer, b integer);

delete t; --ex1 : un delete sur t a eu lieu
	--ex2 : un delete sur une ligne de t a eu lieu
	--ex2 : un delete sur une ligne de t a eu lieu
	--ex2 : un delete sur une ligne de t a eu lieu

insert into t values (1,2);
insert into t values (2,2);
insert into t values (3,2);
insert into t values (4,5);
insert into t values (4,7);

select * from t;

-------------------------------------------------------------------------------------

set serveroutput on

create or replace trigger ex1
	before delete
	on t
begin
	dbms_output.put_line('ex1 : un delete sur t a eu lieu');
end;
/

delete t where a = 1;  --ex1 : un delete sur t a eu lieu
insert into t values (9,9);
update t set b = 11 where a = 9;
delete t where a = 2;  --ex1 : un delete sur t a eu lieu
delete t where a = 4;  --ex1 : un delete sur t a eu lieu
		       --2 rows deleted.
delete t where a = 17; --ex1 : un delete sur t a eu lieu
		       --0 rows deleted.
drop trigger ex1;

-------------------------------------------------------------------------------------

create or replace trigger ex2
	after delete
	on t
	for each row
begin
	dbms_output.put_line('ex2 : un delete sur une ligne de t a eu lieu');
end;
/

delete t where a = 4;  --ex1 : un delete sur t a eu lieu
			--ex2 : un delete sur une ligne de t a eu lieu
			--ex2 : un delete sur une ligne de t a eu lieu
			--2 rows deleted.

delete t where a = 17; --ex1 : un delete sur t a eu lieu
		       --0 rows deleted.

-------------------------------------------------------------------------------------

create or replace trigger ex3
	before delete
	on t
	for each row
begin
	dbms_output.put_line('ex3 : ligne de t detruit : '||:old.a||','||:old.b);
end;
/

delete t where a = 4;   --ex1 : un delete sur t a eu lieu
			--ex3 : ligne de t detruit : 4,5
			--ex2 : un delete sur une ligne de t a eu lieu
			--ex3 : ligne de t detruit : 4,7
			--ex2 : un delete sur une ligne de t a eu lieu
			--2 rows deleted.

-------------------------------------------------------------------------------------

create or replace trigger ex4
	after update
	on t
	for each row
		when(old.b>new.b)
begin
	dbms_output.put_line('ancien b : '||:old.b||',nouveau b :'||:new.b);
end;
/

update t set b=11 where a=1; --1 rows updated.
update t set b=6 where a=4;  --ancien b : 7,nouveau b :6
			     --2 rows updated.

-------------------------------------------------------------------------------------

drop table old_t_b;
create table old_t_b(old_b int);

create or replace trigger ex4bis
	after update
	on t
	for each row
		when(old.b>new.b)
begin
	insert into old_t_b values(:old.b);
	dbms_output.put_line('insert '||:old.b||' dans old_t_b');
end;
/

update t set b=11 where a=1;
update t set b=6 where a=4;  --insert 7 dans old_t_b
			     --ancien b : 7,nouveau b :6
select * from old_t_b;

-------------------------------------------------------------------------------------
-- =/= entre before et after

create or replace trigger ex5
	before insert
	on t
declare 
	n integer;
begin
	select count(*) into n from t;
	dbms_output.put_line('taille t before (ex5): '||n);
end;
/

create or replace trigger ex6
	after insert or update of a
	on t
declare 
	n integer;
begin
	select count(*) into n from t;
	dbms_output.put_line('taille t after (ex6): '||n);
end;
/

create or replace trigger ex6bis --un trigger for each row ne peut pas acceder a une table 					   en cours de motification
	after insert or update of a
	on t
	for each row
declare 
	n integer;
begin
	select count(*) into n from t;
	dbms_output.put_line('taille t after + for each row(ex6bis): '||n);
end;
/
drop trigger ex6bis;


insert into t values(11,11);  --taille t before (ex5): 5
			      --taille t after (ex6): 6
			      --1 row created.
update t set a=110 where a=2;  --taille t after (ex6): 6
			       --1 row updated.

-------------------------------------------------------------------------------------

drop trigger ex5;
drop trigger ex6;

create or replace trigger ex7
	after insert
	on t
declare 
	n integer;
begin
	select sum(a) into n from t;
	dbms_output.put_line('ex7 : declenchement, sum t.a: '||n);
	if n>20	
	   then dbms_output.put_line('constraint violated : taille t>20: '||n);
	end if;
end;
/

select * from t;
insert into t values(1,1); --ex7 : declenchement, sum t.a: 15
			   --1 row created.
insert into t values(11,11); --ex7 : declenchement, sum t.a: 26
			     --constraint violated : taille t>20: 26
			     --1 row created.








