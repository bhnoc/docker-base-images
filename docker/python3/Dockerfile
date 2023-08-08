FROM ghcr.io/bhnoc/rocky9:latest

#Python setup

RUN dnf -y update && \
        dnf -y install findutils python3.11

WORKDIR /opt/env/
RUN python3.11 -m venv live
RUN source live/bin/activate && pip install --upgrade pip
WORKDIR /
RUN rm -rf /etc/localtime
RUN ln -s /usr/share/zoneinfo/America/Denver /etc/localtime

RUN yum install -y cronie && crond -V

COPY start-up.sh start-up.sh
RUN chmod +x start-up.sh

CMD ["/start-up.sh"]
