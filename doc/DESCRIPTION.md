Yuno Archive application integration allows you to easily back up your server to several destination types:
- A local directory
- An external hard drive (mounted and unmounted during the process)
- An rclone repository
- A copy throught SSH (using SCP)

This is a basic application that sends the contents of a compressed folder to another destination (no incremental backup management)

### Features

- Choose the backup target (local YunoHost archives, external drive, Rclone repository, ...)
- Schedule backups at regular intervals
- Choose the items and applications to back up
- Send email alerts at the end of the backup
- Prune automatically old backups