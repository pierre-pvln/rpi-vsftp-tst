FROM resin/rpi-raspbian

MAINTAINER Pierre Veelen <pierre@pvln.nl>

# ==========================================
# START OF INSTALLING UTILITIES AND DEFAULTS
# ==========================================

RUN sudo apt-get update && sudo apt-get install -y \
    apt-utils \
    nano \
    ssh && \
	sudo apt-get upgrade && \
    sudo apt-get clean && \ 
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
	 
# =============================
# END OF UTILITIES AND DEFAULTS
# =============================

# =======================
# START OF INSTALLING FTP
# =======================
# Install vsftp and cleanup afterwards
#
RUN sudo apt-get update &&  sudo apt-get install -y \
	 vsftpd && \
    sudo apt-get upgrade && \
	sudo apt-get clean && \ 
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Update the default vsftp configuration file with this one.
#
ADD ./configs/vsftpd-config.conf /etc/vsftpd.conf
	
# Expose ftp on port 20 and 21
#
EXPOSE 20 21

# Create user
#
# SET PASSWORD: echo username:new_password | chpasswd
#
RUN sudo useradd -m vsftp_user -c "VSFTP User" && echo vsftp_user:vsftp_pw | chpasswd

#TEST
#====
# Copy vsftp test scripts to home directory
#
ADD ./server/scripts/vsftp /home/vsftp_user/vsftp
RUN chmod -R +x /root/vsftp/*.sh


# =======================
# END OF INSTALLING FTP
# =======================

#
# ENTRYPOINT & CMD
# ======
# Cancel pre-defined start-up instruction and allow us to use our own.
#ENTRYPOINT []

ADD ./entrypoint.sh /usr/local/bin/
ENTRYPOINT ["/bin/bash","entrypoint.sh"]
 
CMD /bin/bash
