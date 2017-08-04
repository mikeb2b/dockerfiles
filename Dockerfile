## DOCKER CONTAINER TO PUSH PACKAGES TO Satellite/Spacewalk/SUSE Mgr ##

FROM opensuse:latest
MAINTAINER Mike Byrne <mbbyrne@yahoo.com>

RUN zypper install -y java-1_8_0-openjdk
RUN zypper install -y sudo
RUN zypper install -y vim

# Install a basic SSH server
RUN zypper install -y openssh
RUN sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd

