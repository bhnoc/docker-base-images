
#https://github.com/dockerfile/redis/blob/master/Dockerfile

FROM .dkr.ecr.us-east-1.amazonaws.com/rockylinux8.5:latest
RUN dnf -y update && \
        dnf -y install findutils

RUN dnf install curl gcc openssl-devel bzip2-devel libffi-devel zlib-devel wget make passwd -y 

RUN rm -rf /etc/localtime
RUN ln -s /usr/share/zoneinfo/America/Denver /etc/localtime

RUN yum install -y yum-utils
RUN yum install -y cronie && crond -V


#Redis Setup
RUN \
  cd /tmp && \
  wget http://download.redis.io/redis-stable.tar.gz && \
  tar xvzf redis-stable.tar.gz && \
  cd redis-stable && \
  make && \
  make install && \
  cp -f src/redis-sentinel /usr/local/bin && \
  mkdir -p /etc/redis && \
  cp -f *.conf /etc/redis && \
  rm -rf /tmp/redis-stable* && \
  sed -i 's/^\(bind .*\)$/# \1/' /etc/redis/redis.conf && \
  sed -i 's/^\(daemonize .*\)$/# \1/' /etc/redis/redis.conf && \
  sed -i 's/^\(dir .*\)$/# \1\ndir \/data/' /etc/redis/redis.conf && \
  sed -i 's/^\(logfile .*\)$/# \1/' /etc/redis/redis.conf

# Define mountable directories.
VOLUME ["/data"]
VOLUME ["/etc/redis/"]
# Define working directory.
WORKDIR /data

RUN groupadd -r redis && useradd -r -g redis redis
USER redis:redis
#RUN chmod +x start-up.sh
#CMD ["/start-up.sh"]
CMD ["redis-server", "/etc/redis/redis.conf"]
EXPOSE 6379
