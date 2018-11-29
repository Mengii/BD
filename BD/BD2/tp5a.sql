
create table archive(
    ids int,
    idc int,
    idv int,
    jour int,
    avoir int
);

create or replace trigger exo1 
    before delete
    on sejour
    for each row
declare 
    l_avoir client.avoir%type;
begin
    select avoir 
        into l_avoir
        from client
        where idc = :old.idc;
    insert into archive 
        values(:old.ids, :old.idc, :old.idv, :old.jour, l_avoir);
end;
/

-------------------------------------------------------------------------
create or replace trigger contrainte_depenses
    after insert
    on sejour
    

