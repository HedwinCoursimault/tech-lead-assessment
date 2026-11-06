## Utilisation de l'intelligence artificielle

L'IA a été utilisée comme outil d'accompagnement et de réflexion durant le développement du projet, principalement pour les usages suivants.

### 1. Réflexion technique et architecturale

Échanges autour des choix de conception, de la modélisation métier et de la répartition des responsabilités dans une architecture Clean Architecture. L'objectif était de confronter différentes approches et d'évaluer leurs avantages et inconvénients.

**Exemple de prompt :**
> L'évolution par rapport à la période précédente est un comportement métier, mais elle dépend de deux périodes. Pour moi, elle n'a donc pas forcément sa place directement dans l'objet Period, qui doit pouvoir exister indépendamment. Est-ce qu'il serait plus pertinent de gérer ce calcul dans un service métier ?

### 2. Aide à la résolution de problèmes

Analyse de cas particuliers et de problématiques techniques, notamment concernant la manipulation des données, les calculs métier et la gestion des dates.

**Exemple de prompt :**
> Et sinon le toUtc n'est pas à envisager pour être sûr de ne pas faire de merde et gérer tous les cas facilement, tout en incluant une remarque là-dessus dans le README ?

### 3. Bonnes pratiques et qualité du code

Échanges sur la lisibilité, la maintenabilité et les conventions Dart/Flutter, avec une attention particulière portée à la simplicité des implémentations.

**Exemple de prompt :**
> Dans ce cadre-là, quel est l'avantage de créer une nouvelle liste et utiliser le spread `...` plutôt que de modifier la liste initiale ?

### 4. Relecture et documentation

Aide à la structuration du README, à la formulation des décisions techniques et à l'identification des limites fonctionnelles ou des hypothèses retenues.

**Exemple de prompt :**
> J'aimerais maintenant intégrer une partie au README global, concernant cet exercice 1, une liste de remarques concernant le projet, pour aider à la compréhension de ma réalisation. Si tu en vois d'autres qu'on a mentionné ajoute-les à la réflexion. Voici ce que j'ai noté de mon côté

### 5. Compréhension et utilisation du langage Dart

Questions ponctuelles sur les fonctionnalités du langage et les outils disponibles afin de choisir des solutions simples et idiomatiques.

**Exemple de prompt :**
> Comment je peux faire ça plus simplement mathématiquement ? En gros je veux vérifier que le nombre n'est pas trop proche de 0, qu'à deux décimales ça n'affiche pas 0.00.
