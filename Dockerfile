FROM ubuntu:14.04 
MAINTAINER seven10Builder "leeroyjenkins@seven10storage.com" 

# Set the env variables to non-interactive 
ENV DEBIAN_FRONTEND 			noninteractive 
ENV DEBIAN_PRIORITY 			critical 
ENV DEBCONF_NOWARNINGS 			yes 


# ----  Installing the build environment -----

# Install Oracle Java 8
RUN \
  echo "deb http://archive.ubuntu.com/ubuntu trusty main universe" > /etc/apt/sources.list && \
  apt-get update -q && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y software-properties-common python-software-properties && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update -q && \
  echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y oracle-java8-installer maven git openssh-server && \
  rm -rf /var/cache/oracle-jdk8-installer && \
# clean up tmp install files
  rm -rf /var/lib/apt/lists/*  && \  
  apt-get clean

RUN sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd
RUN mkdir -p /var/run/sshd

# Add user jenkins to the image 
RUN adduser --quiet jenkins && \
# Set password for the jenkins user (you may want to alter this). 
	echo "jenkins:jenkins" | chpasswd
# generate a default locale to keep certain warnings at bay
	locale-gen en_US.UTF-8 && \

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
