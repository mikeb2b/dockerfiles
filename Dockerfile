## DOCKER CONTAINER TO PUSH PACKAGES TO SUSE MANAGER ##

FROM opensuse:latest
MAINTAINER Mike Byrne <mbbyrne@yahoo.com>

RUN zypper install -y java-1_8_0-openjdk
RUN zypper install -y sudo


# Install a basic SSH server
RUN zypper install -y openssh
RUN sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd
RUN mkdir -p /var/run/sshd
RUN /usr/bin/ssh-keygen -A

# Add user sumapusher to the image
RUN mkdir /home/sumapusher/.ssh
RUN mkdir /home/sumapusher/rpmbuild
