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

## LDAP

ldapsearch tool is used, you also require dc name. 

#### To find DC name 

ldapsearch -x -h <IP> -s base namingcontexts

The above command will you give you the dc name.

now, ldapsearch -x -h <IP> -b "dc= <name> , dc=<name>"

you get information of the domains,ldap-users,password etc...


## RPC

