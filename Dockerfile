FROM phusion/baseimage:0.9.16

ENV DEBIAN_FRONTEND noninteractive

# Set correct environment variables

ENV HOME /root
ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV TERM xterm


# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# Add local files
ADD edge.sh /root/edge.sh
ADD sickbeard.sh /root/sickbeard.sh

# Fix a Debianism of the nobody's uid being 65534
RUN usermod -u 99 nobody && \
usermod -g 100 nobody && \

add-apt-repository "deb http://us.archive.ubuntu.com/ubuntu/ trusty universe multiverse" && \
add-apt-repository "deb http://us.archive.ubuntu.com/ubuntu/ trusty-updates universe multiverse" && \
apt-get update -q && \

# Install Dependencies
apt-get install -qy python mc python-cheetah openssl libssl-dev python-dev build-essential python-pip ca-certificates wget unrar git-core && \
pip install setuptools && \
pip install pyopenssl==0.13.1 && \
 
# Install Sickrage
git clone https://github.com/SiCKRAGETV/SickRage.git /opt/sickrage && \
chown -R nobody:users /opt/sickrage  && \

# Install SickBeard
git clone https://github.com/midgetspy/Sick-Beard.git /opt/sickbeard && \
chown -R nobody:users /opt/sickbeard && \


# Downloads and TV Directories
mkdir /mnt/XBMC-Media && \

# Add edge.sh to execute during container startup
mkdir -p /etc/my_init.d && \
mv /root/edge.sh /etc/my_init.d/edge.sh && \
chmod +x /etc/my_init.d/edge.sh && \

# Add Sickbeard to runit
mkdir /etc/service/sickbeard && \
mv /root/sickbeard.sh /etc/service/sickbeard/run && \
chmod +x /etc/service/sickbeard/run

ADD  gui/ /root/
ADD sickragedits.sh /root/sickragedits.sh
ADD  gui/ /opt/sickrage/gui/
RUN chmod +x /root/sickragedits.sh

EXPOSE 8081

# SickBeard Configuration
VOLUME /config
