Intégration de l'application Yuno Archive vous permet de sauvegarder de manière simple votre serveur sur plusieurs types de destinations :
- Un répertoire local
- Un disque dur externe (monté et démonté durant le processus)
- Un dépôt Rclone
- Un serveur distant via scp (copie avec SSH)

C'est une application basique qui envoie le contenu d'un dossier en le compressant vers une autre destination (pas de gestion de sauvegarde incrémentale)

### Fonctionnalités

- Choix de la cible de sauvegarde (archives de YunoHost locales, disque externe, dépôt Rclone, etc.)
- Programmation de la sauvegarde à intervales régulières
- Choix des éléments et applications à sauvegarder
- Envoi d'alertes mails à la fin de la sauvegarde
- Suppression automatique des anciennes sauvegardes