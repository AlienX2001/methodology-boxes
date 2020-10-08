## usually you just find services worth exploiting and then exploit them do priv esc but for a reference and as a compilation of my past experiences here is the notes
- first enumerate and gather all info
- after gathering look at ur perms and see which files can you read/write or execute keep your main focus on log files and backup files
- look at all the proccess and see if you can leverage any of them
- u can use the inbuilt tools like ps (ps aux) or tools like pspy, etc. to have a look 
- u can also have a look at the services which u found in the nmap scan but havent really used it for anything
## now lets start with in depth steps to exploit the services I have encountered till now (WARNING!!:- These may contain spoilers to some active htb boxes, proceed on your own risk)
- Check if root has copied any files from an sensitive location to backups or logs via pspy tool and read them and research about it via google (or any search engine of your choice)
- Try to go deep enough and see if you have permissions to read/write or execute any of the following files which are invoked via certain actions which are done as suid by default (such as invoking login shells since those are by default run by root)
- If you are in special groups or groups u dont know about then better to google to get what all things you can do/access with that group and leverage them
- Also check for any outdated software which you have access to (which includes stuff like the linux kernel or even sudo!![If you have the required permissions to access sudo or you have required permissions to read/write or execute any file as any other user...maybe root])
- Check if you have any permissions to run any program as root and then try hijacking any function of any module in use 
