## Basic networking commands

/sbin/ifconfig -a (linux only)<br />
ipconfig /all (windows only)<br />
/sbin/arp -a (linux only) [to arp ping all devices in current network]<br />
netstat<br />
netstat -ano<br />
cat /etc/hosts (linux only)<br />
cat /etc/resolv.conf (linux only)<br />
/sbin/route (linux only) <br />

## FTP

check to see if anonymous ftp is allowed or not<br />

## SSH

check in the configuration files that public and private key authentication is allowed or not<br />

## SMB

enum4linux -a -d -v "ip"<br />
smbclient -L //"ip"<br />
smbmap -H "ip" -L -v <br />

**Note**: If smb password has been changed you can use *smbpasswd* tool to change the passwd<br />


crackmap smb <IP> - Prints the domain name
crackmap smb <IP> --shares - Prints the shares

**Note**: Sometime you can specify blank username and password, to check if there are any shares. which u don't enum with above commands

crackmap smb <IP> -u " " -p " " 


## LDAP

ldapsearch tool is used, you also require dc name. 

#### To find DC name 

ldapsearch -x -h <IP> -s base namingcontexts

The above command will you give you the dc name.

now, ldapsearch -x -h <IP> -b "dc= <name> , dc=<name>"

you get information of the domains,ldap-users,password etc...


## RPC

rpc tool can be accessed with same credentials of smb. 

rpcclient -U "<Username>"

* enumdomusers    - To enumerate domain users
* enumprivs       - To enumerate privileges
* netshareenumall - To enumerate all shares
* enumprinters    - To enumerate printers
* setuserinfo2   - To reset the password of the user

### Usage example 

setuserinfo2 <Username> <Level> <password> <br />

To know more about the [rpcclient commands](https://www.samba.org/samba/docs/current/man-html/rpcclient.1.html)<br />
To know more about windows [user level](https://docs.microsoft.com/en-us/openspecs/windows_protocols/ms-samr/6b0dff90-5ac0-429a-93aa-150334adabf6?redirectedfrom=MSDN)<br /> 
