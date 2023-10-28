# Installateur Universel de Driver Nvidia (NUDI)

## Description

NUDI (Installateur Universel de Driver Nvidia) est un script Bash polyvalent conçu pour simplifier l'installation des pilotes Nvidia sur diverses distributions Linux. Il prend en charge Ubuntu, Debian, Fedora, Arch Linux, openSUSE, et leurs dérivés. Cet outil est particulièrement utile pour les utilisateurs cherchant un moyen facile et automatisé d'installer les pilotes Nvidia sans devoir naviguer à travers les complexités de gestion de paquets et les méthodes d'installation de pilotes de chaque distribution.

## Statut : ALPHA

Veuillez noter que NUDI est actuellement en phase ALPHA, ce qui signifie qu'il est en développement actif et pourrait être sujet à des changements significatifs. Bien que nous nous efforcions d'assurer la stabilité et une large compatibilité, veuillez utiliser ce script avec prudence et à vos propres risques.

## Avertissement

Ce script est fourni sans aucune garantie ou assurance de fonctionnalité. Il est important de sauvegarder votre système et vos données avant de procéder à l'installation, surtout parce que l'installation de pilotes peut impacter significativement la stabilité et la performance du système.

## Note de Compatibilité

NUDI est destiné à être utilisé avec des cartes graphiques Nvidia compatibles avec les **derniers pilotes Nvidia**. Si votre carte Nvidia n'est pas compatible avec les derniers pilotes, ce script pourrait ne pas fonctionner pour votre configuration. Vérifiez toujours le modèle de votre carte graphique et la compatibilité des pilotes Nvidia avant d'utiliser ce script.

## Distributions Supportées

- Ubuntu
- Debian
- Fedora
- Arch Linux
- openSUSE Leap
- openSUSE Tumbleweed

## Installation

Pour utiliser NUDI, suivez ces étapes :


   ```bash
   git clone https://github.com/Cardiacman13/NUDI.git
   cd NUDI
   chmod +x ./nvidiainstaller.sh
   sudo ./nvidiainstaller.sh
   ```


## Utilisation

Une fois le script démarré, il vous guidera à travers le processus.

## Contributions

Les contributions à NUDI sont les bienvenues ! Si vous avez des suggestions, des rapports de bugs, ou des contributions, veuillez ouvrir un problème ou une demande de tirage dans le dépôt.
