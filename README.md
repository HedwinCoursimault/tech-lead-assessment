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