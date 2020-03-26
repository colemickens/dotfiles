rclone.exe mount `
    --config ".\rclone.conf" `
    --allow-other `
    --read-only `
    --rc `
    --fast-list `
    --drive-skip-gdocs `
    --vfs-read-chunk-size=64M `
    --vfs-read-chunk-size-limit=2048M `
    --buffer-size=64M `
    --max-read-ahead=256M `
    --poll-interval=1m `
    --dir-cache-time=168h `
    --timeout=10m `
    --transfers=16 `
    --checkers=12 `
    --drive-chunk-size=64M `
    --fuse-flag=sync_read `
    --fuse-flag=auto_cache `
      googdrv:media G:
