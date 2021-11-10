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

## privesc via an SUID binary(provided we have access to its coredump)
If we have an SUID binary, which read data from arbitary files. Then we have a read primitive. As since the program read data from file, it stores it in memory, and getting a memory dump is what will give us the contents of the memory. So to do that first, if we know that coredump creation is allowed, then we will have to somehow invoke the SIGSEGV or SIGABRT signals to get a memory dump. These can be done internally via memory corruption, or if there is no memory corruption then we can use kill command as follows, `kill -SIGABRT <PID>` or `kill -11 <PID>` for sigabrt and sigsev respectively, after that we'll see a message pop up that we have a core dump. The coredump should be available in the current working directory as core.PID but if it isnt there then, we can check /var/crash for ubuntu systems. There we will have a .crash file. Now the crash file has a lot of info like, UID, PID, and much more but to our interest is the CoreDump which is base64 enocded. So we use apport to unpack it as follow `apport-unpack <path to .crash file> <directory to which the crash file will get unpacked>` then cding to the directory we find a CoreDump file which is our target coredump file. We can strings it to get ascii stuff or load it into gdb to analyze it better using `gdb <path to binary> CoreDump`
## priv esc via sudo -l
If you have any of the permission listed to below to run as root then you can follow the steps to get a priv esc
### 1. npm:-
npm is a package manager for the JavaScript programming language. It is the default package manager for the JavaScript runtime environment Node.js. A malicious package is created which contains prerequisite script to run. The npm command is run with “–unsafe-perm”

![](https://hakin9.org/wp-content/uploads/2018/09/image37.png)

### 2. pip:-
Pip (Python package installer) is used to install Python packages as several packages are required to be installed with elevated privileges. This can be exploited with malicious Python package or setup.py script.

![](https://hakin9.org/wp-content/uploads/2018/09/image41.png)

and then execute pip install .

![](https://hakin9.org/wp-content/uploads/2018/09/image40.png)

and listen in netcat to get shell

![](https://hakin9.org/wp-content/uploads/2018/09/image43.png)

### 3. find:-
Find command is used to find files. Find command run as sudo can be exploited with -exec argument.

![](https://hakin9.org/wp-content/uploads/2018/09/image42.png)

### 4. mount:-
Mount command is used to mount drives. Mount command run as sudo can be used to spawn shell and escalate the privilege.

![](https://hakin9.org/wp-content/uploads/2018/09/image46.png)

![](https://hakin9.org/wp-content/uploads/2018/09/image45.png)

### 5. man:-
The Man command is used for viewing manual pages for a command. Running a man command using SUDO can be exploited and a shell can be spawned.

![](https://hakin9.org/wp-content/uploads/2018/09/image49.png)

![](https://hakin9.org/wp-content/uploads/2018/09/image47.png)

### 6. awk:-
AWK is a programming language designed for text processing and typically used as a data extraction and reporting tool. AWK run on SUDO can be exploited as below.

![](https://hakin9.org/wp-content/uploads/2018/09/image48.png)

### 7. nmap:-
Nmap is program used for scanning ports and services. NMAP run as sudo can be exploited with lua online script and saved as .nse.

![](https://hakin9.org/wp-content/uploads/2018/09/image50.png)

### 8. wget:-
Wget is a command used to download files. Get running on SUDO can be exploited as follows.
 
![](https://hakin9.org/wp-content/uploads/2018/09/image51.png)

![](https://hakin9.org/wp-content/uploads/2018/09/image52.png)
 
Also, Wget can be used to replace file with -O argument. 
### 9.  gdb:-
GDB (Gnu Debugger) is a command used to debug applications. GDB run with SUDO can be exploited as follows.

![](https://hakin9.org/wp-content/uploads/2018/09/image53.png)

### 10. vi:-
Vi is text editor.vi used as SUDO can be used to spawn shell and elevate privilege.

When vi is opened type “:” which will make it in command mode then type "!/bin/bash"

![](https://hakin9.org/wp-content/uploads/2018/09/image54.png)

### 11. ftp:-
FTP command is used as FTP client to connect to FTP. FTP with sudo permission can be exploited as below.

![](https://hakin9.org/wp-content/uploads/2018/09/image55.png)

### 12. less:-
Less command is used to view contents of a file.

Running with SUDO privileges can be exploited as below.
When less is opened type “!/bin/bash” since it is already in command mode 
![](https://hakin9.org/wp-content/uploads/2018/09/image56.png)

### 13. more:-
More command is also similar to less command used to view the contents of the file. More command running with SUDO privileges can be used to spawn an elevated shell.

![](https://hakin9.org/wp-content/uploads/2018/09/image57.png)

### 14. tar:-
tar is generally used to compress or decompress files

![](https://hakin9.org/wp-content/uploads/2018/09/image28.png)

### 15. composer:-
composer is used to install, update and run php frameworks and projects and stuff

![](https://hakin9.org/wp-content/uploads/2018/09/image30.jpeg)

![](https://hakin9.org/wp-content/uploads/2018/09/image31.jpeg)
 
