
create or replace view vue_village_sans_sejour as
select idv, ville, activite, prix 
  from village 
  where idv not in (select idv 
                      from sejour);

select * from vue_village_sans_sejour order by idv;
