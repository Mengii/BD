--programmeur : p
--employes : e1, ..., en
--client : c
--c'est p qui tape sur son compte ce qui suit
q1 = select grantee, table_name, privilege
	from user_tab_privs
	where table_name in ('CLIENT', 'PRODUIT', 'COMMANDE', 'RETOUR')
q2 = select grantee, procedure_name
	from user_proc_privs
	where procedure_name in ('TRAITEMENT2', 'TRAITEMENT3', 'TRAITEMENT4')
-- Pour chaque u dans q1 faire :
revoke u.privilege on client, produit, commande, retour from u.grantee
-- Pour chaque u dans q2 faire :
revoke execute on traitement2, traitement3, traitement4 from u.grantee

-- employes:
1.ajouter des produits (insert)
  grant insert on produit to e1,...,en
2.augmenter leur stock (update stock)
  create procedure augmanter_stock(q) = update produit set stock = stock + q
  grant execute on augmanter_stock to e1,...,en
3.consulter ce qui dont le stock est epuise (select where epuise)
  create view stock_epuise as
     select * from produit where stock = 0
  grant select on stock_epuise to e1,...,en
4.consulter les commandes (select commande)
  grant select on commande to e1,...,en
5.traitement2
  create procedure traitement2
  grant execute on traitement2 to e1,...,en
6.traitement3
  create procedure traitement3
  grant execute on traitement3 to e1,...,en
-- client :
7.consulter les produits sans le stock (select sans stock)
  create view produit_sans_stock as
     select idp, nompr, prix from produit 
  grant select on produit_sans_stock to c
8.traitement4
  create procedure traitement4
  grant execute on traitement4 to c
9.consulter infos dans
	client (select avec nom)
	commande sans la date (select avec nom sans date)
  create procedure consulter_client(n) = select * from client where nomcl = n
  create procedure consulter_commande(n) = 
	select idco,idcl,idp,quantite from client,commande
	 where nomcl = n and client.idcl = commande.idcl
  grant execute on consulter_client, consulter_commande to c
10.ajouter un retour d'une de leur commande (insert where idco)
   create procedure ajout_retour(idc) =
	select idco into l_idco from commande where idcl = idc
	insert into retour values (idr, l_idco, jour, 'a_traiter') 
