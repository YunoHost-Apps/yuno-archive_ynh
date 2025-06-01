## Local Archives

When choosing a local backup, you can specify the YunoHost archive directory (default option). In this case, the archives will be visible in the Backups section of the administration panel. This option simply ensures that a backup will be performed at regular intervals.

You can also specify a custom local directory.
**Warning: This directory will be used as is once it exists. Make sure that this directory contains only backup archives!**

## Archives on External Drive

This mode allows you to plug in an external drive that is recognized by the system (e.g., /dev/sde1).
You must specify the partition of the hard drive (e.g., /dev/sde1) and not the whole disk (e.g., /dev/sde).

Make sure it’s the correct hard drive by connecting via SSH and checking the disk contents with the following commands:
```bash
sudo mkdir /mnt/test
sudo mount /dev/sdXy -t auto /mnt/test
ls /mnt/test
umount /mnt/test
sudo rm -rf /mnt/test
```

The drive will be mounted and unmounted during the backup process.
This could make the system unusable if you're using a system drive!

As device letters are assigned dynamically, you can try to fix these values using udev rules.

To verify disks and their paths after plugging them in (assuming /dev/sdX is the disk connected to the front USB port), use:
```bash
udevadm info --query=path --name=/dev/sdX
```
Example output:
```bash
devices/pci0000:00/0000:00:1f.2/ata1/host0/target0:0:0/0:0:0:0/block/sdX
```

Create the file **/etc/udev/rules.d/21-usb-disk.rules** :

```bash
# Front USB drive
KERNEL=="sd?", SUBSYSTEM=="block", \
DEVPATH=="*/usb1/1-1/1-1.2/1-1.2:1.0*", \
SYMLINK+="hdd_usb_front", \
RUN+="/usr/bin/logger Disk connected to front upper USB port KERNEL=$kernel, DEVPATH=$devpath" \
GOTO="END_21_USB_DISK"

# Front USB partitions
KERNEL=="sd?*", SUBSYSTEM=="block", \
DEVPATH=="*/usb1/1-1/1-1.2/1-1.2:1.0*", \
SYMLINK+="hdd_usb_front_%n", \
RUN+="/usr/bin/systemctl --no-block start backup-to-usb-@%k.service"

LABEL="END_21_USB_DISK"
```
This will create symbolic links for the disk connected to the front USB port:

- /dev/hdd_usb_front → /dev/sdX for the disk
- /dev/hdd_usb_front_1 → /dev/sdX1 for the first partition
- etc.

Sources:
- https://linux.die.net/man/8/udev
- https://wiki.debian.org/Persistent_disk_names

## Archive to Rclone

[Rclone](https://rclone.org/docs/) offers the great advantage of supporting many storage services like Google Drive, Pcloud, AWS, and more.

Before using it, make sure it is properly configured with the following command:
```bash
sudo rclone config
```

To upgrade rclone:
```bash
sudo -v ; curl https://rclone.org/install.sh | sudo bash
```

### Automatic deletion of old backups

During the backup process, if there is not enough space on the destination, the script can automatically delete old backups.
If you choose to keep all backups, this action will be disabled.

Otherwise, you can determine the minimum number of backups to keep.
In this case, the process will delete old backups (starting with the oldest) until there is enough space on the destination, while ensuring the minimum number of backups chosen is kept.