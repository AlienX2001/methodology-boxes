## basic networking commands

/sbin/ifconfig -a (linux only)<br />
ipconfig /all (windows only)<br />
/sbin/arp -a (linux only) [to arp ping all devices in current network]<br />
netstat<br />
netstat -ano<br />
cat /etc/hosts (linux only)<br />
cat /etc/resolv.conf (linux only)<br />
/sbin/route (linux only) <br />

## ftp

check to see if anonymous ftp is allowed or not<br />

## ssh

check in the configuration files that public and private key authentication is allowed or not<br />

## smb

enum4linux -a -d -v "ip"<br />
smbclient -L //"ip"<br />
smbmap -H "ip" -L -v <br />

**Note**: If smb password has been changed you can use *smbpasswd* tool to change the passwd
