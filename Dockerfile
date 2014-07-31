# sendgridjp-postfix
#
# VERSION	1.0
#
# use the ubuntu base image provided by dotCloud
#
FROM dockerfile/ubuntu
MAINTAINER awwa, awwa500@gmail.com

#
# make sure the package repository is up to date
#
#RUN echo "deb http://archive.ubuntu.com/ubuntu trusty main universe" > /etc/apt/sources.list
RUN apt-get update

#
# install ssh for maintainance
#
RUN apt-get install -y openssh-client
RUN apt-get install -y ssh-import-id openssh-server
RUN mkdir -p /var/run/sshd
RUN echo root:password | chpasswd
RUN echo 'rootpass ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config
RUN sed -e "s/PermitRootLogin without-password/PermitRootLogin yes/g" /etc/ssh/sshd_config > /etc/ssh/sshd_config
#
# expose ssh port
#
EXPOSE 22
EXPOSE 25

#
# install modules
RUN apt-get install -y telnet postfix 
ADD files/etc/mailname /etc/mailname
ADD files/etc/postfix/main.cf /etc/postfix/main.cf
ADD files/etc/postfix/master.cf /etc/postfix/master.cf

#
# add script form sending mail
ADD files/smtp.sh /root/smtp.sh
