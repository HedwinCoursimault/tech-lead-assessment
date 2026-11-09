# Installation et exécution

Ce projet a été développé avec **Flutter / Dart** dans le cadre du test technique Hello Pomelo.

L'application propose une interface graphique permettant de tester les fonctionnalités réalisées pour les deux premiers exercices :
- **Exercice 1 — Historique client :** consultation et analyse de l'historique des commandes d'un client.
- **Exercice 2 — Moteur de pricing :** calcul du prix d'une commande avec application des différentes règles métier.

Deux méthodes permettent de tester l'application :
- **Exécuter directement la version Windows compilée**, sans installation de Flutter.
- **Lancer le projet depuis les sources**, pour consulter le code, exécuter l'application et lancer les tests.

## 1. Exécution directe (sans installation)

Une version Windows compilée est fournie séparément, dans une archive ZIP.

1. Télécharger et extraire l'archive contenant l'application.
2. Ouvrir le dossier extrait.
3. Lancer le fichier `my_app.exe`.

Aucune installation de Flutter, Dart ou d'un environnement de développement n'est nécessaire.

**Important :** conserver tous les fichiers et sous-dossiers de l'archive à côté de l'exécutable. L'application nécessite notamment ses bibliothèques DLL et son dossier `data`.

Sur certaines machines, l'installation du Microsoft Visual C++ Redistributable peut être nécessaire.

## 2. Installation de l'environnement de développement

Les instructions suivantes sont destinées à un environnement **Windows 10/11**.

### 2.1. Installer Visual Studio Code

Télécharger et installer Visual Studio Code :

https://code.visualstudio.com/

Ouvrir VS Code, puis accéder aux extensions avec `Ctrl + Shift + X`.

Installer l'extension suivante :

- **Flutter** (éditeur : Dart Code) : https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter

L'extension **Dart** sera automatiquement installée avec Flutter.

Ces extensions permettent notamment la coloration syntaxique, l'autocomplétion, la navigation dans le code, l'analyse statique et le débogage.

### 2.2. Installer Flutter et Dart

Le SDK Flutter comprend directement Dart : aucune installation séparée de Dart n'est nécessaire.

Pour installer Flutter depuis VS Code :

1. Ouvrir la palette de commandes avec `Ctrl + Shift + P`.
2. Rechercher `Flutter: New Project`.
3. Si Flutter n'est pas détecté, sélectionner **Download SDK**.
4. Choisir un dossier d'installation, par exemple `C:\dev`.
5. Sélectionner **Clone Flutter**, puis **Add SDK to PATH**.
6. Redémarrer VS Code et les terminaux ouverts.

Guide officiel : https://docs.flutter.dev/install/with-vs-code

Pour vérifier l'installation, ouvrir un terminal et exécuter :

```bash
flutter doctor
```

La commande indique les éventuels composants manquants.

### 2.3. Installer les outils de compilation Windows

Pour exécuter l'application Flutter en mode natif sous Windows, les outils de compilation C++ de Microsoft sont nécessaires.

1. Installer **Visual Studio Community** : https://visualstudio.microsoft.com/downloads/
2. Dans l'installateur, sélectionner la charge de travail **Développement Desktop en C++** (*Desktop development with C++*).
3. Terminer l'installation.

**Attention :** Visual Studio et Visual Studio Code sont deux logiciels différents. VS Code sert ici à consulter et modifier le projet, tandis que Visual Studio fournit les outils de compilation Windows.

Vérifier ensuite la configuration :

```bash
flutter doctor
```

Les sections concernant Windows et Visual Studio doivent être correctement configurées.

Les avertissements concernant Android Studio ou les autres plateformes peuvent être ignorés pour une exécution uniquement sous Windows.

## 3. Ouvrir et exécuter le projet

### 3.1. Ouvrir les sources

Récupérer le dépôt GitHub ou télécharger son archive ZIP.

Dans VS Code, sélectionner **File > Open Folder** et ouvrir le dossier contenant le fichier `pubspec.yaml`.

### 3.2. Installer les dépendances

Depuis le terminal de VS Code (`Ctrl + ù` sur un clavier AZERTY, selon la configuration), exécuter à la racine du projet :

```bash
flutter pub get
```

Cette commande télécharge les dépendances Dart et Flutter du projet.

### 3.3. Démarrer l'application

Exécuter :

```bash
flutter run -d windows
```
ou
```bash
flutter run -d web
```

Flutter compile et lance l'application dans une fenêtre Windows.

Il est également possible de lancer l'application avec `F5` depuis VS Code, après avoir sélectionné **Windows (desktop)** comme appareil cible.

## 5. Organisation du projet

Le code applicatif est organisé en plusieurs couches :

| Dossier | Responsabilité |
|---|---|
| `lib/config/` | Configuration des règles métier |
| `lib/core/` | Utilitaires et accès aux repositories |
| `lib/data/` | Sources de données, DTO, mappers et implémentations des repositories |
| `lib/domain/` | Modèles métier, services, cas d'utilisation et moteur de pricing |
| `lib/view/` | Interfaces Flutter et gestion des états avec Cubit |
| `test/` | Tests automatisés |

Les points d'entrée principaux sont :
- `lib/main.dart` : initialisation de l'application.
- `lib/view/main_view.dart` : interface principale.
- `lib/domain/use_case/` : cas d'utilisation.
- `lib/domain/items/pricing/` : moteur de calcul des prix.
- `lib/config/pricing_rules.dart` : déclaration et configuration des règles de pricing.
