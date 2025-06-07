## Archives Locales

Dans le choix d'une sauvegarde locale, vous pouvez spécifier le répertoire des archives de YunoHost (choix par défaut). Dans ce cas, les archives seront visibles dans le menu sauvegardes du menu d'administration. Ce choix permet simplement de s'assurer qu'une sauvegarde sera réalisée à intervales réguliers.

Vous pouvez aussi spécifier un répertoire local.
**Attention** :  ce répertoire sera utilisé tel quel à pertir du moment où il existe. Assurez-vous que ce répertoire ne contienne que des archives !

### Archives sur disque externe

Ce mode vous permet de brancher un disque externe et reconnu par le système (ex : /dev/sde1).
Vous devez spécifier la partition du disque dur (ex : /dev/sde1) et non le disque en entier (ex: /dev/sde)

Assurez-vous que c'est le bon disque dur en vous connectant en SSH et vérifiant le contenu du disque avec ces commandes :

```bash
sudo mkdir /mnt/test
sudo mount /dev/sdXy -t auto /mnt/test
ls /mnt/test
umount /mnt/test
sudo rm -rf /mnt/test
```
Ce disque sera monté puis démonté lors du backup. **Cela risque de rendre le système inutilisable en cas d'utilisation d'un disque système !**

Comme les lettres des lecteurs sont attribuées à la volée, vous pouvez tenter de fixer ces valeurs en utilisant des règles udev.

Vérification des disques après branchement et de leur path (en supposant que /dev/sdX correspond au disque branché sur le port USB de facade) :
```bash
udevadm info --query=path --name=/dev/sdX
```

Exemple de retour
```bash
devices/pci0000:00/0000:00:1f.2/ata1/host0/target0:0:0/0:0:0:0/block/sdX
```

Créer le fichier **/etc/udev/rules.d/21-usb-disk.rules** :
```bash
# Front USB drive
KERNEL=="sd?", SUBSYSTEM=="block", \
DEVPATH=="*/usb1/1-1/1-1.2/1-1.2:1.0*", \
SYMLINK+="hdd_usb_front", \
RUN+="/usr/bin/logger Disque connecté port USB front du haut KERNEL=$kernel, DEVPATH=$devpath" \
GOTO="END_21_USB_DISK"

# Front USB partitions
KERNEL=="sd?*", SUBSYSTEM=="block", \
DEVPATH=="*/usb1/1-1/1-1.2/1-1.2:1.0*", \
SYMLINK+="hdd_usb_front_%n", \
RUN+="/usr/bin/systemctl --no-block start backup-to-usb-@%k.service"

LABEL="END_21_USB_DISK"
```

Cela crééra des liens symboliques pour le disque connecté sur le port USB de facade :
- /dev/hdd_usb_front -> /dev/sdX pour le disque
- /dev/hdd_usb_front_1 -> /dev/sdX1 pour la première partition
- etc.

Sources : 
- https://linux.die.net/man/8/udev
- https://wiki.debian.org/Persistent_disk_names

### Archive vers Rclone

[Rclone](https://rclone.org/docs/) offre l'énorme avantage de supporter de nombreux services de stockages tel que Google Drive, Pcloud, AWS, etc.
Avant de l'utiliser, assurez-vous qu'il est correctement configuré avec la commande :
```bash
sudo rclone config
```

Pour mettre à jour Rclone :
```bash
sudo -v ; curl https://rclone.org/install.sh | sudo bash
```

### Suppression automatique des anciennes sauvegardes

Lors du processus de backup, s'il n'y a pas assez de place sur la destination, le script peut supprimer automatiquement les anciennes sauvegardes.
Si vous choisissez de conserver toutes les sauvegardes, cette actions sera inhibée.

Sinon, vous pouvez déterminer le nombre de sauvegardes à conserver au minimum.
Dans ce cas, le processus supprimera les anciennes sauvegardes (en commençant par la plus ancienne) jusqu'à ce qu'il y ai suffisamment de place sur la destination tout en s'assurant de garder le nombre minimal de sauvegardes choisies.