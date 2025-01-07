# Application Météo 🌤️

Une application simple et intuitive développée avec Flutter. Elle fournit des informations météorologiques en temps réel pour votre position actuelle et permet aux utilisateurs de rechercher d'autres villes. Vous pouvez également enregistrer vos villes favorites pour y accéder rapidement.

## Fonctionnalités

- **Météo de la position actuelle** : Récupère et affiche automatiquement les informations météorologiques pour votre position actuelle.
- **Recherche de ville** : Recherchez n'importe quelle ville pour consulter les détails de sa météo actuelle.
- **Favoris** : Enregistrez les villes que vous consultez fréquemment et accédez rapidement à leurs données météorologiques.
- **Stockage persistant** : Vos villes favorites sont stockées localement et restent disponibles même après un redémarrage de l'application.

## Installation

Pour exécuter ce projet en local, suivez ces étapes :

1. **Clonez le dépôt** :
   ```bash
   git clone https://github.com/fyras-selmen/meteo.git
   cd meteo
2. **Installez les dépendances** :
   ```bash
   flutter pub get
4. **Lancez l'application** :
   ```bash
   flutter run
## API

Cette application utilise l'API Open Weather Map pour récupérer les données météorologiques en temps réel. Elle fournit des informations telles que la température, l'humidité, la vitesse du vent, et bien plus encore. Pour plus d'informations sur l'API, visitez [Open Weather Map](https://openweathermap.org/api/one-call-api).
