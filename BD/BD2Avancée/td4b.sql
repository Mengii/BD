create sequence	seq_village start with 10;

create or replace procedure creerVillage(
    v varchar2, a varchar2, p int, cap int)
is
begin
    insert into village values(
      	   seq_village.nextval, v, a, p, cap);
end;
/
show errors

-------------------------------------------------------------------------------
create or replace function traitement3(le_jour sejour.jour%type)
    return integer
is
begin
    return -1;
end;
/

-------------------------------------------------------------------------------
create or replace procedure traitement3_out(
    le_jour sejour.jour%type,
    le_nombre out integer)
is
begin
    le_nombre := -1;
end;
/
