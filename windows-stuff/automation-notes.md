# notes

## creating the automated installer

1. Install ADK & PE Addon: https://docs.microsoft.com/en-us/windows-hardware/get-started/adk-install
2. Download Win10 Media Creation Tool
3. Create ISO with it.
4. Extract ISO.
5. dism /Export-Image /SourceImageFile:install.esd /SourceIndex:6 /DestinationImageFile:install.wim /Compress:Max /CheckIntegrity


## disk layout

01-  512 MB  ESP      FAT32
02-  512 GB  NixOS    BTRFS
03-  512 MB  WinRE    NTFS
04-   16 MB  MSR      unformatted
05-  256 GB  Windows  NTFS
