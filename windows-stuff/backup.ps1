# copy important user folders to the external drive

$backupLocation = "D:\BACKUPS\SLY"

robocopy "C:\Users\colem\Documents" "$backupLocation\COLEM\Documents" /MIR
robocopy "C:\Users\budpe\Documents" "$backupLocation\BUDPE\Documents" /MIR
robocopy "C:\Users\budpe\Downloads" "$backupLocation\BUDPE\Downloads" /MIR
