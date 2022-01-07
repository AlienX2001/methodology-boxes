# SPOILERS!! DO NOT CONTINUE...might have spoilers for active boxes

## sneakymailer
1. Since the smtp and imap servers were running so tried phishing by sending a mail to the email addresses mentioned in the team.php in the webpage via a tool caled sendemail
2. Reading through forums and nudges it seems as the box has been made such that to implement as if actual users are clicking on links sent over thr mail so  for getting a response we try to send http link in the mail and set up a nc listener to get any possible response
3. In the response we get creds for one email address so we use evolution and set it up to check inbox of the email we got and see 2 mails giving us a pair of creds
4. This pair works on ftp and gives is read/wrtie/execute access to files but ftp doesnt allow execution of code so we can read and write files
5. Taking nudges again seems we need to fuzz vhosts this time (which is a obvious thing to do like dirbusting and all) so we add the vhost to out /etc/hosts and go to the page and see a similar looking website but now we can control its contents via ftp server
6. We try uploading a php reverse shell and executing it via a browser and hence finally get a shell
### notes
1. To make a python package we need only a setup.py in a folder and build a pkg by running "python3 setup.py sdist bdist_wheel" and then uploading it by following this link https://pypi.org/project/pypiserver/#upload-with-setuptools (ofc this is only for our malicious paylaod.....to make a proper python package follow this link)
2. If PHP gets a serialized object directly from user controlled input then it can be leveraged by using an object of the class exisitng in the source code, changing the variables for our intention and then serialize it to make a payload which can be passed so as to get our untrusted unsanitized input in the server which can also be leveraged to get code exec
3. If while creating a support ticket for any online issue we either get a unique support email address or anything which gives away that the inbox of the support mail might be connected to the support ticket, then the newly generated support mail can be leveraged to impersonate as an already exisitng internal user on any server/platform, which can further be levreaged to get any internal information resulting in major info disclosure or possible entry to internal user only interaces, like admin panel, etc.
## time
### notes
1. To have a look at what type of content is parsed and how it is parsed by the website (in this case content was treated as json objects[by the error code we received]) like this if we can identify this then we can try to leverage it to get rce/ce 

## tenet
### notes
1. If PHP gets a serialized object directly from user controlled input then it can be leveraged by using an object of the class exisitng in the source code, changing the variables for our intention and then serialize it to make a payload which can be passed so as to get our untrusted unsanitized input in the server which can also be leveraged to get code exec

## academy
### notes
1. If we have the adm group then it means we can check logs and even audit logs, and retrieving sensitive info here is an article https://www.redsiege.com/blog/2019/05/logging-passwords-on-linux/

## buff
### notes
1. If we cant somehow send data to some service due to lack of software then we can use a tunnel or reverse tunnel to tunnel the data through one machine to the other

## delivery
### notes
1. If while creating a support ticket for any online issue we either get a unique support email address or anything which gives away that the inbox of the support mail might be connected to the support ticket, then the newly generated support mail can be leveraged to impersonate as an already exisitng internal user on any server/platform, which can further be levreaged to get any internal information resulting in major info disclosure or possible entry to internal user only interaces, like admin panel, etc.

## luanne
### notes
1. bozotic http server which is default http server of open bsd has a vuln which only locks the html root folder's index.html, users can access any existing file by mentioning it in the URL
2. It also has a feature according to which if the -u flag enabled then it transforms URL which contain URL/~user/ to URL/~user/public_html
3. It also has a feature that if -X flag is enabled, it enables directory listing of the whole folder when the index.html is not present

## proper
1. The sql parameters were dyanamic in nature (first time encountering dyanamic params) hence used --eval with sqlmap. It evaluates python 1 liner thereby changing payloads dyanamically. We can refer to the parameters directly in the 1 liner.

## blackfield
### notes
1. We can even change password of a user account in an AD environment without an OS shell if our current user has sufficient permissions with the use of rpc using `net rpc <TARGET USERNAME> -W <DOMAIN> -U <CURRENT USER> -S <SERVERIP>` or using rpclient as follows `setuserinfo2 "TARGET USER" 23 "NEW PASSWORD"`
2. If we dont have a password for an account but we have their NTLM hash then we can use impacket's smbclient.py to get in through smb using `smbclient.py <DOMAIN>/<USERNAME>@IP -hashes 00000000000000000000000000000000:<NTLM HASH> -dc-ip <DOMAIN CONTROLLER IP>`. This types of attack using only NTLM hash is called PassTheHash attack

## explore
### notes
1. With adb enabled, we can easily escalalte privelages to root by doing the following `adb connect <IP>:<PORT usually 5555 for adb>` then `adb shell` and if it says more than 1 device then `adb devices`, it will list all the devices then `adb -s <device name, could be some random ascii or some IP:PORT> shell` and then simply `su root`.

## reel
### notes
1. Always check metadata of files downloaded from any source like ftp, smb, etc. like this `exiftool "filename here"`.
2. HTA apps are html applications which are ran as "fully trusted app" meaning browser restrictions dont apply on them, no sandbox, nothing. They are native to IE, but can also be accessed by mshta.exe so it can be used to to get a client side RCE

## sizzle
### notes
1. Just like how ssh pvt keys allow passwordless authentication for ssh service, in active directory environment, certificates also can be used for more secure way authenticating to winrms(ssl version of winrm over port 5986) the cons are that its pretty rough to set it up everytime u need to winrm session. According to this blog https://www.hurryupandwait.io/blog/certificate-password-less-based-authentication-in-winrm this kind of authentication is mostly done by services/service accounts hence this overhead can simply be coded in their scripts. But to do it manually what we need to do is, first we need to make ourselves a certificate signing request(crs) file which can be done using openssl using the following commands: `openssl genrsa -aes256 -out "USERNAME.key" 2048` this will generate a key file, which during its making will ask for a password (4 to 1023 characters long), so for convinience we can just type "password" or whatever we want. After that we will make the crs using the key with `openssl req -new -key "USERNAME.key" -out "USERNAME.csr"` and now we have our csr file. After that we will just copy the contents of the newly generated csr file and paste it into the saved request parameter of AD CS web enrollment form that is "https://DOMAINNAME/certsrv/certrqxt.asp" and click on submit, this will generate our newly signed certificate which we need to download in base64 format, now ready to integrate into evilwinrm to get shell. We can use the SSL mode of winrm to use these certs via `evil-winrm -i "IP" -u "USERNAME" -p "PASSWORD" -S -k USERNAME.key -c certnew.cer` here the certnew.cer is the certificate downloaded from the ADCS web enrollment website and then when asking for the password we need to enter the  password we used when making the .key file which was  "password"
