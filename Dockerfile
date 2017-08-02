## DOCKER CONTAINER TO PUSH PACKAGES TO SUSE MANAGER ##

FROM centos:latest
MAINTAINER Mike Byrne <michael.byrne@officedepot.com>

# Make sure the package repository is up to date.
RUN yum -y update
RUN yum -y upgrade
RUN yum install -y java-1.8.0-openjdk
RUN yum install -y sudo
RUN yum install -y openssh-clients

COPY /files/Spacewalk-Tools.repo /etc/yum.repos.d/
RUN yum makecache fast

# Install rhnpush
RUN yum install -y rhnpush

# Install a basic SSH server
RUN yum install -y openssh-server
RUN sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd
RUN mkdir -p /var/run/sshd
RUN /usr/bin/ssh-keygen -A

# Add user sumapusher to the image
RUN adduser sumapusher -m -s /bin/bash
RUN mkdir /home/sumapusher/.ssh
RUN mkdir /home/sumapusher/rpmbuild
COPY /files/authorized_keys /home/sumapusher/.ssh/authorized_keys
COPY /files/buildsvr-filepush /home/sumapusher/.ssh/buildsvr-filepush
RUN chown -R sumapusher.sumapusher /home/sumapusher
RUN chmod 600 /home/sumapusher/.ssh/authorized_keys
RUN chmod 700 /home/sumapusher/.ssh
RUN echo "sumapusher ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# expose ssh
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
