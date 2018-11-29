drop table t;

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

