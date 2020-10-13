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

## smtp

try connecting it via telnet and then do the following:-
- VRFY "email address"

and then refer this https://en.wikipedia.org/wiki/List_of_SMTP_server_return_codes for the return codes
- try sending mail to everyone in your mailing list by maliciosly crafting your content from which they can connect back to you (via http)[no need to setup an http server] and listen for any reply responses via netcat (basics of phishing!!)

If we get credentials somehow of any email address then we can use evolution app to check inboxes,send mail,etc. (cuz evolution is basically an email client :P)
