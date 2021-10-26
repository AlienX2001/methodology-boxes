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
1. We can even change password of a user account in an AD environment without an OS shell if our current user has sufficient permissions with the use of rpc using `net rpc <TARGET USERNAME> -W <DOMAIN> -U <CURRENT USER> -S <SERVERIP>`.
2. If we dont have a password for an account but we have their NTLM hash then we can use impacket's smbclient.py to get in through smb using `smbclient.py <DOMAIN>/<USERNAME>@IP -hashes 00000000000000000000000000000000:<NTLM HASH> -dc-ip <DOMAIN CONTROLLER IP>`. This types of attack using only NTLM hash is called PassTheHash attack

## explore
### notes
1. With adb enabled, we can easily escalalte privelages to root by doing the following `adb connect <IP>:<PORT usually 5555 for adb>` then `adb shell` and if it says more than 1 device then `adb devices`, it will list all the devices then `adb -s <device name, could be some random ascii or some IP:PORT> shell` and then simply `su root`.
