## usually you just find services worth exploiting and then exploit them do priv esc but for a reference and as a compilation of my past experiences here is the notes
- first enumerate and gather all info
- using winpeas look for files/folders owned by system and we also have perms to read/write or execute refer to winpeas docs for the full form of codes displayed by winpeas over files/folders
- we can leverage services which create proccess with system privs and hence get a system shell
