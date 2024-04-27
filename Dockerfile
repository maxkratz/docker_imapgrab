# Use ubuntu 24.04
FROM ubuntu:24.04
LABEL maintainer="Max Kratz <account@maxkratz.com>"
ENV DEBIAN_FRONTEND=noninteractive

# Update and install various packages
RUN apt-get update -q && \
    apt-get upgrade -yq && \
    apt-get install -yq wget curl git build-essential lsb-release locales bash-completion tzdata sudo

# Create a user and give it sudo permissions
RUN useradd -m -d /home/imapgrab imapgrab -p $(perl -e 'print crypt("imapgrab", "salt"),"\n"') && \
    echo "imapgrab ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER imapgrab

# Use en utf8 locales
RUN sudo locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

# Install specific packages
RUN sudo apt-get install -y getmail6 python2
RUN sudo git clone https://github.com/ralbear/IMAPbackup.git

# Remove apt lists (for storage efficiency)
RUN sudo rm -rf /var/lib/apt/lists/*

# Run list command
# RUN cd IMAPbackup && sudo python imapgrab.py -l -s $MAILHOST -u $MAILUSER -p $MAILPASSWORD

# Assuming that folder is mount to /mnt, create mail-output folder
RUN sudo mkdir -p /mnt/mail

# Check if logging is enabled
CMD if [ "${MAILLOG}" = "TRUE" ]; \
    then sudo mkdir -p /mnt/log && cd IMAPbackup && sudo python2 imapgrab.py -L imapgrab -d -v -M -f /mnt/mail/$MAILFOLDER -s $MAILHOST -u $MAILUSER -p $MAILPASSWORD -m "_ALL_" >> /mnt/log/$(date +'%Y-%m-%d_%H-%M-%S')_mail-backup.log; \
    else cd IMAPbackup && sudo python2 imapgrab.py -L imapgrab -d -v -M -f /mnt/mail/$MAILFOLDER -s $MAILHOST -u $MAILUSER -p $MAILPASSWORD -m "_ALL_"; \
    fi
