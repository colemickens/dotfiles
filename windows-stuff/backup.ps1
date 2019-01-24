$backupLocation = "D:\BACKUPS\SLY"

$dirs = @(
  ".config",
  ".dotfiles",
  ".password-store",
  ".ssh",
  "Documents",
  "code"
);

foreach ($dir in $dirs) {
    robocopy "C:\Users\colem\$dir" "$backupLocation\COLEM\$dir" /MIR
}
