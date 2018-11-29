SQL> drop table t;

create table t (
	a integer, primary key (a),
	b integer not null,
	c integer,
	unique (b, c),
	check (a+b>4)
);

insert into t values (1,4,9);

select * from t;

drop table s;

create table s (
	a integer,
	c integer,
	foreign key (a) references t
); 

insert into s values (1,4);

drop sequence td;

create sequence td;

insert into t values (td.nextval, 9, 1);
insert into s values (td.currval, 99);

select * from t;
select * from s;
drop table t
           *
ERROR at line 1:
ORA-02449: unique/primary keys in table referenced by foreign keys


SQL> SQL>   2    3    4    5    6    7  create table t (
             *
ERROR at line 1:
ORA-00955: name is already used by an existing object


SQL> SQL> insert into t values (1,4,9)
*
ERROR at line 1:
ORA-00001: unique constraint (C##MDUAN_A.SYS_C0062418) violated


SQL> SQL> 
	 A	    B	       C
---------- ---------- ----------
	 1	    4	       9

SQL> SQL> 
Table dropped.

SQL> SQL>   2    3    4    5  
Table created.

SQL> SQL> 
1 row created.

Commit complete.
SQL> SQL> 
Sequence dropped.

SQL> SQL> 
Sequence created.

SQL> SQL> insert into t values (td.nextval, 9, 1)
*
ERROR at line 1:
ORA-00001: unique constraint (C##MDUAN_A.SYS_C0062418) violated


SQL> 
1 row created.

Commit complete.
SQL> SQL> 
	 A	    B	       C
---------- ---------- ----------
	 1	    4	       9

SQL> 
	 A	    C
---------- ----------
	 1	    4
	 1	   99

SQL> 
SQL> 
SQL> create table essai (     
  2  a integer,
  3  b integer 
  4  );

Table created.

SQL> select * from essai;

no rows selected

SQL> insert into essai values (2,10);

1 row created.

Commit complete.
SQL> select * from essai;

	 A	    B
---------- ----------
	 2	   10

SQL> create sequence tt;

Sequence created.

SQL> insert into essai values(tt.nextval,20);

1 row created.

Commit complete.
SQL> select * from essai;

	 A	    B
---------- ----------
	 2	   10
	 1	   20

SQL> insert into essai values(tt.currval, 55);

1 row created.

Commit complete.
SQL> select * from essai;

	 A	    B
---------- ----------
	 2	   10
	 1	   20
	 1	   55

SQL> insert into essai values(tt.nextval, 88);

1 row created.

Commit complete.
SQL> select * from essai;

	 A	    B
---------- ----------
	 2	   10
	 1	   20
	 1	   55
	 2	   88

SQL> insert into essai values(tt.nextval, 250);

1 row created.

Commit complete.
SQL> select * from essai;

	 A	    B
---------- ----------
	 2	   10
	 1	   20
	 1	   55
	 2	   88
	 3	  250

SQL> create table seqtt (
  2  a integer,
  3  b integer);

Table created.

SQL> insert into seqtt values(2,55);

1 row created.

Commit complete.
SQL> create sequence curr;

Sequence created.

SQL> insert into seqtt values(curr.currval, 20);
insert into seqtt values(curr.currval, 20)
                         *
ERROR at line 1:
ORA-08002: sequence CURR.CURRVAL is not yet defined in this session


SQL> insert into seqtt values(curr.nextval,50);

1 row created.

Commit complete.
SQL> select * from seqtt;

	 A	    B
---------- ----------
	 2	   55
	 1	   50

SQL> insert into seqtt values(curr.nextval, 80);

1 row created.

Commit complete.
SQL> select * from seqtt;

	 A	    B
---------- ----------
	 2	   55
	 1	   50
	 2	   80

SQL> insert into seqtt values(curr.currval,66);

1 row created.

Commit complete.
SQL> select * from seqtt;

	 A	    B
---------- ----------
	 2	   55
	 1	   50
	 2	   80
	 2	   66

