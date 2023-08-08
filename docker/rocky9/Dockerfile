FROM rockylinux:9

RUN dnf -y install epel-release
RUN dnf -y update
RUN dnf -y install wget vim mlocate net-tools htop sudo gcc man

RUN echo "alias ll='ls -lahrt'" >> ~/.bashrc
RUN updatedb

WORKDIR /
COPY start-up.sh start-up.sh
RUN chmod +x start-up.sh
CMD ["/start-up.sh"]
