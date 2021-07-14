## First and foremost
To start enumerating the active directory forest we need to have some kind of shell in the network, which can be claimed by any means. Web, SSH, etc.

But if all fails then what we have is kerberos.

If a user in the AD setting has the setting "Do not require Kerberos preauthentication" or UF_DONT_REQUIRE_PREAUTH set to true and we have its username then we can ask the kdc for a TGT which is encrpyted with the user's NTLM hash, which we can then crack in offline mode to get the user's password.
So, in order to get usernames we can use rpcclient to enumerate groups and users in the domain using a null rpc session using `rpcclient -U "" -N IP` and then doing `enumdomusers` for enumerating users and `enumdomgroups` to enumerate groups.

After we do get list of usernames, we can make a wordlist out of it and use GETNPUsers.py from impacket to get TGT's of the users having the misconfig using `GETNPUsers.py DOMAIN NAME -dc-ip DOMAIN CONTROLLER IP -no-pass -userfile WORDLIST`

Then after getting TGT's we try to crack them to get clear text passwords which we can use to get a shell through either winrm, ssh or whatever services enable us to

## Second
We transfer sharphound exe to our victim. Sharphound is a data collector tool for bloodhound. Bloodhound is a visualizer of the AD network and enables us to analyze it better.
If we are using evilwinrm then no need to an external binary, there is already a command in the evilwinrm for dumping the zip for bloodhound, we can find that by using `menu` on the evilwinrm shell.

After transfering the zip to our machine we can import the zip to bloodhound which will make us a graph of the network and will also graph the permissions, groups, everything. It even gives us hints as to what to exploit to reach what target.

## Third
If the Link says MemberOf, then we can disregard it, why? we can read that using right clicking on the link.
If the Link says GenericAll, then we can just add the group to our user by simply doing `net group "GROUP NAME" USERNAME /add /domain` and get the elevated perms given to the group we just added ourselves to
If the Link says WriteDacl and the abuse info says that we can do a dcsync attack then we can simply type this oneliner `Add-DomainGroupMember -Identity 'GROUP NAME' -Members USERNAME; $username = "HOSTNAME\USERNAME"; $password = "PASSWORD"; $secstr = New-Object -TypeName System.Security.SecureString; $password.ToCharArray() | ForEach-Object {$secstr.AppendChar($_)}; $cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $username, $secstr; Add-DomainObjectAcl -Credential $Cred -PrincipalIdentity 'USERNAME' -TargetIdentity 'DOMAINNAME\Domain Admins' -Rights DCSync`.
And after that simply use secretsdump.py from impacket to get kerberos golden tickets of the accounts due to the nature of DCSync attack by using `secretsdump.py USERNAME:PASSWORD@DC IP`

## Lastly
The 2nd part of the golden ticket will be the hash required for a pass the hash attack, which we may use to get access via evilwinrm or we might try to crack it, to get cleartext passwords
