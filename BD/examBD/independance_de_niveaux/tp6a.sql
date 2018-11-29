-- a) exemple concret complet de pbm d'independance niv. (chronologie, acteurs impliques, reactions concretes)
      
      -- table CC avec contenu
	village(11, 'NY', 'MOMA', 60, 300)
      -- reorganisation SPI :
	nomVille(idvn, ville)
	village(idv, idvn, activite, prix, capacite), ou idvn fk nomVille
      -- les lignes correspondant au contenu donne
	village(11, 101, 'MOMA', 60, 300)
	nomVille(101, 'NY')
      -- traitement 2 :
	select idv, prix, activite from village where ville = 'NY' order by prix desc;
	insert ...
	update ...
      -- erreur execution : colonne village.ville n'existe pas

-- b) ordres SQL concrets pour gerer le pbm preci (chronologie, acteurs impliques, reactions concretes)

      -- une vue pour la table village :
	create view vue_village as
	  select idv, ville, activite, prix, capacite
		from village;
      -- traitement 2 :
	select idv, prix, activite from vue_village where ville = 'NY' order by prix desc;
	insert ...
	update ...
      -- reorganisation SPI
      -- changement de vue seulement :
	create or replace view vue_village as
	  select idv, ville, activite, prix, capacite
		from village, nomVille
		   where village.idvn = nomVille.idvn;
