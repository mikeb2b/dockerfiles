## DOCKER CONTAINER TO PUSH PACKAGES TO SUSE MANAGER ##

FROM opensuse:latest
MAINTAINER Mike Byrne <mbbyrne@yahoo.com>

RUN zypper install -y java-1_8_0-openjdk
RUN zypper install -y sudo


# Install a basic SSH server
RUN yum install -y openssh
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
