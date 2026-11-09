## Structure

J'ai créer un projet flutter pour les question 1 et 2. Le projet se trouve dans le dossier my_app. A la racine de ce dossier se trouve un README qui permet d'installer le plus rapidement possible l'environnement Flutter pour à la fois lancer le projet et pouvoir parcourir facilement le code.

## Exercice 1 — Rapport client

### Choix d'implémentation et hypothèses

**Période d'analyse**

- Les données fournies ne contenant aucune commande sur les 6 derniers mois, la date d'analyse a été positionnée au 15 novembre 2024

**Calcul des indicateurs**

- Le montant moyen d'une période correspond à la **moyenne des montants totaux des commandes**, et non à une moyenne pondérée par le nombre d'articles.
- L'évolution est calculée par rapport à la période précédente disponible. Lorsqu'aucune période précédente n'existe ou que sa valeur est nulle, l'évolution en pourcentage n'est pas calculable.

**Gestion des données**

- Les dates fournies dans les fichiers JSON sont exprimées en UTC. Les dates de référence utilisées pour les regroupements et les comparaisons sont donc également construites en UTC, afin d'éviter les décalages liés aux fuseaux horaires. 
- Les dates contenant une information de fuseau horaire sont converties en UTC. Les dates calendaires sans heure ni fuseau (format YYYY-MM-DD) sont interprétées conventionnellement à minuit UTC, afin de préserver leur jour d'origine.
- Les conversions des données JSON prennent en compte certaines variations de format lorsque leur interprétation est possible sans ambiguïté. En revanche, les données manquantes ou invalides ne sont pas remplacées arbitrairement par des valeurs par défaut, afin de préserver leur intégrité.
- Les objets métier sont séparés des DTO et de la logique de lecture des données. Les repositories assurent notamment la récupération et l'association des commandes avec les produits, tandis que les calculs métier sont effectués indépendamment de l'interface.

### Limites connues et améliorations possibles

**Historisation des prix**

Les données fournies ne permettent pas de connaître le prix d'un produit au moment de chaque commande. Les calculs utilisent donc les prix disponibles dans le catalogue, en faisant l'hypothèse qu'ils n'ont pas évolué.

Dans une application réelle, le prix unitaire devrait être enregistré dans chaque ligne de commande au moment de l'achat. Sans cette information, les montants historiques peuvent être inexacts si les prix du catalogue ont changé.

**Gestion des périodes sans commandes**

Les périodes vides ne sont pas représentées dans le rapport. Par conséquent, une évolution peut comparer deux périodes non consécutives. Une amélioration consisterait à générer explicitement les périodes vides, selon le comportement métier attendu.

**Qualité des données**

La lecture des données pourrait être enrichie par une gestion plus détaillée des erreurs (données invalides, références de produits inexistantes, etc.), permettant de distinguer les données rejetées des véritables absences de résultats et de faciliter le diagnostic.

**Architecture globale** 
L'injection de dépendance est faite au travers de toutes les couches depuis le main.dart. C'est peu problématique dans notre cas car il y a peu de dépendance mais dans un plus gros projet, il convient d'utiliser une solution d'injection de dépendance globale, qui permette de récupérer les classes à utiliser (getIt en flutter par exemple)

## Exercices 2 

### choix d'interprétation

- Les catégories de règles sont définies et ordonnées
- Les règles d'une catégorie sont appliquées les unes à la suite des autres dans leur ordre de priorité (ordre de lecture dans l'exercice), sauf mention contraire
	- La règles des 8% est avant la règles des 5%
	- Les règles de bases s'appliquent toutes sur le prix brut de base (pas à la chaine)
	- Les règles finales s'appliquent en cascade dans leur ordre de déclaration (de priorité)
- Les règles conditionnelles ne sont pas nécessairement exclusives
- Si deux règles sont exclusives entre elles, la première règle dans la liste d'exécution empêches celles avec lesquelles elle est incompatible de s'exécuter. 
- Les réduction globales sont répercutés sur chaque lignes qui composent la commande afin de pouvoir appliquer des règles ciblés après des réductions globales
- Les règles de seuil cumulatif doivent expliciter les recalculs qu'elles provoquent. Dans le cas déclaré, si le montant descend en dessous de 500€, on provoque une annulation de la règles de 500€ et donc un recalcul, mais la chose n'est pas vrai pour le seuil des 1000€ car ce n'est pas explicité
- Les règle conditionnelles s'appliquent sur le prix après les réduction de base mais dans l'ordre de déclaration si plusieurs ne sont pas incompatible (dans le scénario où de nouvelles règles serait rajoutées). Cela est plus cohérent avec le comportement des règles de seuil cumulatif qui implique un recalcul de la règle sur un prix courant plutôt que sur un prix fixe après les règles de base
- Lorsqu'une règle est invalidé, elle ne peut pas être réintroduite par une autre règle. 

### améliorations à apporter

- Rendre dynamique la gestion des catégorie de règles sans passer par une énum
- Permettre la création dynamique de règle via un fichier json
- Gérer le recalcule lorsqu'une règle qui en exclue une autre est exécutée après la règle qu'elle doit exclure
