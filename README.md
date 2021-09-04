# docker_imapgrab

[![Build Status](https://github.ci.maxkratz.com/api/badges/maxkratz/docker_imapgrab/status.svg)](https://github.ci.maxkratz.com/maxkratz/docker_imapgrab)

*Unofficial* imapgrab Dockerfile for backing up all folders of an imap server.

## Quickstart
After installing docker, just run the following command:

```sh
docker pull maxkratz/imapgrab:latest
```

## Environment variables
You can use the following environment variables for customization of this container:

```sh
MAILHOST # Hostname of the imap server
MAILUSER # Login-Name (mailbox)
MAILPASSWORD # Password (mailbox)
MAILFOLDER # Subfolder for creating the backup
MAILLOG # If set to true, container will create a log instead of using console output
```

## Mount volumes or bind folders
One may mount a folder of the host to **/mnt** within the container to enable persistent backups of imap servers.

* **/mnt/mail** will be used as backup target.
* **/mnt/log** will be used as log target (if environment variable is set).

## Full example command
```sh
docker run -it -e "MAILHOST=mail.example.net" -e "MAILUSER=user@example.net" -e "MAILPASSWORD=secure123" -e "MAILFOLDER=mybackup" -e "MAILLOG=TRUE" -v /home/maxkratz/email-backups/:/mnt maxkratz/imapgrab:latest
```

Creates a backup of all files and folders of the mailbox **user@example.net** with password **secure123** at host **mail.example.net** inclusive logs into subfolder **mybackup**.

## Dockerfile
The Dockerfile can be found at:
[https://github.com/maxkratz/docker_imapgrab/blob/master/Dockerfile](https://github.com/maxkratz/docker_imapgrab/blob/master/Dockerfile)

## What gets installed in this container?
The following packages are installed within this docker container:

* Some utility packages like git, curl, getmail etc.
* [IMAPbackup by ralbear](https://github.com/ralbear/IMAPbackup) (thats the whole point ...)