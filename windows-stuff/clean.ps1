###############################################################################
## NOTES
## This is more about removing cruft than removing telemetry components.
## I like to think it's all fairly reasonable. These are personal taste things
## that I've been modifying in Windows for years and am tired of repeating
## by hand.

###############################################################################
## PREREQS
## TODO: how much can we do with choco?
## install: Git, gpg4win, WinSCP 
## install: Chrome, Firefox, VLC, AltDrag, Gpg4Win, Git
## install: 7zip, Spotify, Uplay, Steam

###############################################################################
## MANUAL STEPS AFTERWARD
## 1. Firefox:
##   - fix UI
##   - login to sync the two whole fucking settings that Firefox Sync syncs
##   - reset search providers leaving only DDG
##   - probably more
## 2. Gopass/GPG:
##   - get GOPASS onto PATH
##   - clone gitlab/colemickes/secrets to $HOME/.password-store
##   - gopass jsonapi configure
##   - gpg --import colemickens.pub.asc
##   - gpg --expert --edit-key ... (trust -> ultimate)

###############################################################################
## COLE USER STUFF
$logPath = $PSCommandPath.Replace(".ps1", ".log")
Start-Transcript -Path $logPath -Force

# clear start menu
(New-Object -Com Shell.Application).
  NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').
  Items() |
  %{ $_.Verbs() } |
  ?{$_.Name -match 'Un.*pin from Start'} |
  %{$_.DoIt()}

& git config --global user.name "Cole Mickens"
& git config --global user.email "cole.mickens@gmail.com"

New-Item -TypeDirectory -Path "C:\\Users\\Cole Mickens\\code"

###############################################################################
## ELEVATE TO ROOT
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
  Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs -Wait;
  Exit
}
$rootLogPath = $PSCommandPath.Replace(".ps1", ".root.log")
Start-Transcript -Path $rootLogPath -Force

Get-Process | Where-Object {$_.Path -like "*explorer.exe*"} | Stop-Process -Force

###############################################################################
## GENERAL
# TODO: disable Windows Hello
# TODO: disable Your Phone
# TODO: disable services: HomeGroup (+ others)

###############################################################################
## GENERAL UX CLEANUP
# active legacy windows photo viewer (we disable Photos)
& reg import ($PSScriptRoot + '\regedit\howtogeek\Activate-Windows-Photo-Viewer-on-Windows-10\Activate Windows Photo Viewer on Windows 10.reg' )

# remove 3d objects folder
& reg import ($PSScriptRoot + '\regedit\howtogeek\Remove-3D-Objects-Folder\Remove 3D Objects Folder (64-bit Windows).reg' )

# remove library folders from this PC
& reg import ($PSScriptRoot + '\regedit\howtogeek\Remove-Folders-From-This-PC-on-Windows-10\64-bit versions of Windows 10\Remove All User Folders From This PC 64-bit.reg' )

# remove any git entries in explorer context menu
& reg import ($PSScriptRoot + '\regedit\stackoverflow\remove-git-explorer.reg' )

& reg import ($PSScriptRoot + '\regedit\customization.reg' )

###############################################################################
## REMOVE PACKAGES (TODO: reduce duplication, use a couple lists)
# ref: https://github.com/MicrosoftDocs/windows-itpro-docs/blob/master/windows/application-management/apps-in-windows-10.md
$extraApps = @( "Microsoft.XboxOneSmartGlass", "Windows.MiracastView" ) # extras not included in the list
$maybeApps = @( "Microsoft.MSPaint" ) # eh... we have GIMP and Windows Image Viewer
$provisionedApps = @(
  "Microsoft.3DBuilder", "Microsoft.BingWeather", "Microsoft.GetHelp", "Microsoft.Getstarted",
  "Microsoft.Messaging", "Microsoft.Microsoft3DViewer", "Microsoft.MicrosoftSolitaireCollection",
  "Microsoft.MicrosoftStickyNotes", "Microsoft.Office.OneNote", "Microsoft.People",
  "Microsoft.Windows.Photos", # includes spammy Video Editor
  "Microsoft.Wallet", "Microsoft.WindowsMaps", "microsoft.windowscommunicationsapps", "Microsoft.YourPhone",
  "Microsoft.ZuneMusic", "Microsoft.ZuneVideo"
)
$systemApps = @(
  "HoloCamera", "HoloItemPlayerApp", "HoloShell",
  # "Microsoft.Windows.Cortana", # must be disabled with GPO first # TODO
  # "Microsoft.Windows.PeopleExperienceHost", # can't be disabled ?
  "Windows.Print3D"
)
$allApps = $extraApps + $maybeApps + $provisionedApps + $systemApps

foreach ( $app in $allApps ) {
  Get-AppxPackage -Name $app | Remove-AppxPackage
}

Get-Process | Where-Object {$_.Path -like "*explorer.exe*"} | Stop-Process -Force
