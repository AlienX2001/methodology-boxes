## First and foremost
To start enumerating the active directory forest we need to have some kind of shell in the network, which can be claimed by any means. Web, SSH, etc.

But if all fails then what we have is kerberos.

If a user in the AD setting has the setting "Do not require Kerberos preauthentication" or UF_DONT_REQUIRE_PREAUTH set to true and we have its username then we can ask the kdc for a TGT which is encrpyted with the user's NTLM hash, which we can then crack in offline mode to get the user's password.
So, in order to get usernames we can use rpcclient to enumerate groups and users in the domain using a null rpc session using `rpcclient -U "" -N IP` and then doing `enumdomusers` for enumerating users and `enumdomgroups` to enumerate groups.

After we do get list of usernames, we can make a wordlist out of it and use GETNPUsers.py from impacket to get TGT's of the users having the misconfig using `GETNPUsers.py DOMAIN NAME -dc-ip DOMAIN CONTROLLER IP -no-pass -userfile WORDLIST`
