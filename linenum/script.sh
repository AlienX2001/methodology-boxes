#!/bin/bash
# basic info
echo "----------------------------------------------------"
echo "----------------------------------------------------"
echo "Filing basic info such as whoami, id, kernel etc. now in basicinfo"
echo -e "whoami:- $(whoami)\n" >> basicinfo
echo -e "id:- $(id)\n" >>basicinfo
echo -e "uname -a :- $(uname -a)\n" >> basicinfo
echo -e "history is as follows:-\n $(history)\n" >> basicinfo
echo -e "sudo's version is :- $(sudo --version)\n" >> basicinfo
echo "DONE!!! Retrieve the file 'basicinfo' in this directory into your own machine so that you dont mess up your terminal"
echo "----------------------------------------------------"
# info of the users
echo "----------------------------------------------------"
echo "Extracting info on users in userfile"
echo -e "This is /etc/passwd :-\n----------------------------------------------------\n$(cat /etc/passwd)\n----------------------------------------------------\n" >> userfile
echo -e "This is the /etc/group :-\n----------------------------------------------------\n$(cat /etc/group)\n----------------------------------------------------\n" >> userfile
echo -e "Any logged in users right now are as follows:-\n$(w)\n" >> userfile
echo -e "Any users who have sudoed earlier are as follows :- $(find /home -name .sudo_as_admin_successful 2>/dev/null)" >> userfile
echo -e "DONE!! Retrieve the file 'userfile' in this directory into your own machine so that you dont mess up your terminal"
echo "----------------------------------------------------"
# info on system processes
echo "----------------------------------------------------"
echo "Extracting info of system proccesses in sysinfo"
echo -e "List of available shells:-\n-----------------------\n$(cat /etc/shells 2>/dev/null)\n---------------------------\n" >> sysinfo
echo -e "All running proccesses:-\n-----------------------\n$(ps aux)\n-----------------------\n" >> sysinfo
echo -e "System files(init.d) not belonging to root:-\n$(find /etc/init.d/ ! -uid 0 -type f 2>/dev/null |xargs -r ls -la 2>/dev/null)\n" >>sysinfo
echo -e "System files(system.d) not belonging to root:-\n$(find /lib/systemd/ ! -uid 0 -type f 2>/dev/null |xargs -r ls -la 2>/dev/null)\n" >> sysinfo
echo "DONE!! Retrieve the file 'sysinfo' in this directory into your own machine so that you dont mess up your terminal"
echo "----------------------------------------------------"
# advanced enumeration
echo "----------------------------------------------------"
read -p "Do you want to continue for advanced enumeration??, this may take a while?? (N/n to not continue, anything else to continue) " c
if [ "$c" = "N" ]||[ "$c" = "n" ]
then
  echo "Kindly retrieve 'basicinfo', 'userfile', before viewing them"
else
  echo "You chose to continue so wait for a while"
  i="1000"
  while [ $(cat /etc/passwd | grep $i | cut -d ":" -f 1 | wc -m) -gt "0" ]
  do
  user=$(cat /etc/passwd | grep $i | cut -d ":" -f 1)
  echo -e "$user 'sfiles in which we have read perms are as follows :-\n$(find / -readable ! -user $user -type f ! -path \"/proc/\" ! -path \"/sys/\" 2>/dev/null)\n" >> advancedenum
  echo -e "$user 'sfiles in which we have write perms are as follows :-\n$(find / -writable ! -user $user -type f ! -path \"/proc/\" ! -path \"/sys/\" 2>/dev/null)\n" >> advancedenum
  echo -e "$user 'sfiles in which we have exec perms are as follows :-\n$(find / -executable ! -user $user -type f ! -path \"/proc/\" ! -path \"/sys/\" 2>/dev/null)\n" >> advancedenum
  echo -e "$user 'sfiles which are suid executable are as follows:-\n$(find / -user $user -perm -4000 -executable 2>/dev/null)\n" >>advancedenum
  i=$[$i+1]
  done
  echo "The big stuff has been done and is stored in file 'advancedenum' transfer it into ur own machine to avoid messing up the terminal"
  echo "----------------------------------------------------"
  echo "----------------------------------------------------"
  echo "Checking any files from which we can have some access via ssh"
  find / -name "id_dsa*" -o -name "id_rsa*" -o -name "known_hosts" -o -name "authorized_hosts" -o -name "authorized_keys" 2>/dev/null
  echo "These are the files"
  echo "ENUMERATION COMPLETE !!!!"
  echo "Kindly retrieve 'basicinfo', 'userfile', 'advancedenum' before viewing them"
  echo "----------------------------------------------------"
  echo "----------------------------------------------------"
fi

