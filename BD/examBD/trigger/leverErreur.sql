create or replace procedure ex1 (n integer) is
begin
	if n=5
	   then
	     raise_application_error(-20001, 'pb dans ex4 avec : '||n);
	end if;
	dbms_output.put_line('fin normale');
end;
/

set serveroutput on
exec ex1(3); --fin normale
exec ex1(5); --ORA-20001: pb dans ex4 avec : 5
	     --ORA-06512: at "C##MDUAN_A.EX1", line 5
	     --ORA-06512: at line 1

------------------------------------------------------------------------------
create or replace procedure ex2 (n integer) is
begin
	insert into t values (n,n);
	if n=5
	   then
	     raise_application_error(-20001, 'pb dans ex4 avec : '||n);
	end if;
	dbms_output.put_line('fin normale');
end;
/

drop table t;
create table t(a integer, b integer);
select * from t;

exec ex2(3); --fin normale
exec ex2(5); --ERROR at line 1:
	     --ORA-20001: pb dans ex4 avec : 5
	     --ORA-06512: at "C##MDUAN_A.EX2", line 6
	     --ORA-06512: at line 1
select * from t; --(3,3)

