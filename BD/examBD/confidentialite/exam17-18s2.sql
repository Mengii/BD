--programmeur : p
--employes : e1, ..., en
--client : c
--c'est p qui tape sur son compte ce qui suit
q1 = select grantee, table_name, privilege
	from user_tab_privs
	where table_name in ('CLIENT', 'TYPEVOITURE', 'OFFRE', 'DEMANDE', 'COVOITURAGE')
q2 = select grantee, procedure_name
	from user_proc_privs
	where procedure_name in ('TRAITEMENT2', 'TRAITEMENT3', 'TRAITEMENT4')
-- Pour chaque u dans q1 faire :
revoke u.privilege on client, typeVoiture, offre, demande, covoiturage from u.grantee
-- Pour chaque u dans q2 faire :
revoke execute on traitement2, traitement3, traitement4 from u.grantee

-- employes:
1.traitement3
  create procedure traitement3
  grant execute on traitement3 to e1,...,en
2.traitement4
  create procedure traitement4
  grant execute on traitement4 to e1,...,en
3.consulter tout :
  grant select on client, typeVoiture, offre, demande, covoiturage to e1,...,en
4.creer des types de voiture (insert typeVoiture)
  grant insert on typeVoiture to e1,...,en
5.modifier num de tel (update num)
  grant update(telephone) on client to e1,...,en

-- client :
6.traitement2
  create procedure traitement2
  grant execute on traitement2 to c
7.consulter demande non encore traite
  create procedure demande_non_traite(dest, mar) =
	select * from demande where destination = dest and marque = mar and statut = 'pieton'
  grant execute on demande_non_traite to c
8.rajouter une demande quand demandeur encore pieton
  create procedure rajout_demande(id,dest,mar) =
	cursor c is 
		select * from demande where idc = id and statut = 'pieton'
	if c%found then
		insert into demande(idd, id, dest, mar, 'pieton')
  grant execute on rajout_demande to c
