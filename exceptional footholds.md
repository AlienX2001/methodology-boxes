## SPOILERS!! DO NOT CONTINUE...might have spoilers for active boxes

### sneakymailer
1. Since the smtp and imap servers were running so tried phishing by sending a mail to the email addresses mentioned in the team.php in the webpage via a tool caled sendemail
2. Reading through forums and nudges it seems as the box has been made such that to implement as if actual users are clicking on links sent over thr mail so  for getting a response we try to send http link in the mail and set up a nc listener to get any possible response
3. In the response we get creds for one email address so we use evolution and set it up to check inbox of the email we got and see 2 mails giving us a pair of creds
4. This pair works on ftp and gives is read/wrtie/execute access to files but ftp doesnt allow execution of code so we can read and write files
5. Taking nudges again seems we need to fuzz vhosts this time (which is a obvious thing to do like dirbusting and all) so we add the vhost to out /etc/hosts and go to the page and see a similar looking website but now we can control its contents via ftp server
6. We try uploading a php reverse shell and executing it via a browser and hence finally get a shell
