# Use ubuntu 18.04
FROM ubuntu:18.04
LABEL maintainer="Max Kratz <account@maxkratz.com>"
ENV DEBIAN_FRONTEND=noninteractive

# Update and install various packages
RUN apt-get update -q && \
    apt-get upgrade -yq && \
    apt-get install -yq wget curl git build-essential lsb-release locales bash-completion tzdata

# Use en utf8 locales
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

# Install specific packages
RUN apt install -y getmail python
RUN git clone https://github.com/ralbear/IMAPbackup.git

# Remove apt lists (for storage efficiency)
RUN rm -rf /var/lib/apt/lists/*

# Run list command
RUN cd IMAPbackup && python imapgrab.py -l -s $MAILHOST -u $MAILUSER -p $MAILPASSWORD

# Assuming that folder is mount to /mnt, create mail-output folder
RUN mkdir -p /mnt/mail

# Check if logging is enabled
CMD if [ "${MAILLOG}" = "TRUE" ]; \
    then mkdir -p /mnt/log && cd IMAPbackup && python imapgrab.py -d -v -M -f /mnt/mail/$MAILFOLDER -s $MAILHOST -u $MAILUSER -p $MAILPASSWORD -m "_ALL_" >> /mnt/log/$(date +'%Y-%m-%d_%H-%M-%S')_mail-backup.log; \
    else cd IMAPbackup && python imapgrab.py -d -v -M -f /mnt/mail/$MAILFOLDER -s $MAILHOST -u $MAILUSER -p $MAILPASSWORD -m "_ALL_"; \
    fi
