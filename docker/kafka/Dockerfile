FROM

EXPOSE 22
EXPOSE 9092
EXPOSE 2181

EXPOSE 2888
EXPOSE 3888

ENV ADMIN_USERNAME=""
ENV ADMIN_PASSWORD=""

ENV ZOOKEEPER_ID=""

RUN useradd -M -s /sbin/nologin kafka
RUN useradd -M -s /sbin/nologin zookeeper
RUN usermod -L kafka
RUN usermod -L zookeeper

COPY jdk-8u131-linux-x64.rpm jdk-8u131-linux-x64.rpm

RUN rpm -Uvh /jdk-8u131-linux-x64.rpm

RUN rm /jdk-8u131-linux-x64.rpm

RUN echo 'JAVA_HOME=/usr/java/jdk1.8.0_131/' > /etc/profile.d/jre.sh
RUN echo 'JRE_HOME=$JAVA_HOME/jre' >> /etc/profile.d/jre.sh
RUN echo 'PATH=$PATH:$JAVA_HOME/bin:$JRE_HOME/bin' >> /etc/profile.d/jre.sh
RUN echo 'export JAVA_HOME' >> /etc/profile.d/jre.sh
RUN echo 'export JRE_HOME' >> /etc/profile.d/jre.sh
RUN echo 'export PATH' >> /etc/profile.d/jre.sh

RUN alternatives --install /usr/bin/java java /usr/java/jdk1.8.0_131/bin/java 1000
RUN alternatives --install /usr/bin/javac javac  /usr/java/jdk1.8.0_131/bin/javac 1000
RUN alternatives --install /usr/bin/jre jre /usr/java/jdk1.8.0_131/jre 1000

RUN mkdir -p /usr/local/zookeeper

RUN mkdir -p /var/zookeeper/data

COPY zookeeper-3.4.10.tar.gz /zookeeper-3.4.10.tar.gz
RUN tar -C /usr/local/zookeeper/ -xzvf /zookeeper-3.4.10.tar.gz
RUN rm /zookeeper-3.4.10.tar.gz

RUN cp /usr/local/zookeeper/zookeeper-3.4.10/conf/zoo_sample.cfg /usr/local/zookeeper/zookeeper-3.4.10/conf/zoo.cfg

RUN sed -i  's/dataDir=.*/dataDir=\/var\/zookeeper\/data/' /usr/local/zookeeper/zookeeper-3.4.10/conf/zoo.cfg

RUN chown -R zookeeper:zookeeper /var/zookeeper
RUN chown -R zookeeper:zookeeper /usr/local/zookeeper

RUN mkdir -p /usr/local/kafka

COPY kafka_2.11-0.10.2.2.tgz kafka_2.11-0.10.2.2.tgz
RUN tar -C /usr/local/kafka -xzvf /kafka_2.11-0.10.2.2.tgz
RUN rm /kafka_2.11-0.10.2.2.tgz

RUN echo 'export ZK_HOME=/usr/local/zookeeper/zookeeper-3.4.9' >> /etc/profile.d/kafka.sh
RUN echo 'export KAFKA_HOME=/usr/local/kafka/kafka_2.11-0.10.2.2' >> /etc/profile.d/kafka.sh
RUN echo 'export PATH=$ZK_HOME/bin:$KAFKA_HOME/bin:$PATH' >> /etc/profile.d/kafka.sh

RUN echo 'export PATH=$ZK_HOME/bin:$KAFKA_HOME/bin:$PATH' >> /etc/profile.d/kafka.sh

RUN echo "[Unit]" >> /etc/systemd/system/kafka.service
RUN echo "Description=Apache Kafka server (broker)" >> /etc/systemd/system/kafka.service
RUN echo "Documentation=http://kafka.apache.org/documentation.html" >> /etc/systemd/system/kafka.service
RUN echo "Requires=network.target remote-fs.target" >> /etc/systemd/system/kafka.service
RUN echo "After=network.target remote-fs.target zookeeper.service" >> /etc/systemd/system/kafka.service
RUN printf "\n\n" >> /etc/systemd/system/kafka.service
RUN echo "[Service]" >> /etc/systemd/system/kafka.service
RUN echo "Type=simple" >> /etc/systemd/system/kafka.service
RUN echo "User=kafka" >> /etc/systemd/system/kafka.service
RUN echo "Group=kafka" >> /etc/systemd/system/kafka.service
RUN echo "Environment=JMX_PORT=5000" >> /etc/systemd/system/kafka.serviceRUN echo "" >> /etc/systemd/system/kafka.service
RUN echo "ExecStart=/usr/local/kafka/kafka_2.11-0.10.2.2/bin/kafka-server-start.sh /usr/local/kafka/kafka_2.11-0.10.2.2/config/server.properties" >> /etc/systemd/system/kafka.service
RUN echo "ExecStop=/usr/local/kafka/kafka_2.11-0.10.2.2/bin/kafka-server-stop.sh" >> /etc/systemd/system/kafka.service
RUN printf "\n\n" >> /etc/systemd/system/kafka.service
RUN echo "[Install]" >> /etc/systemd/system/kafka.service
RUN echo "WantedBy=multi-user.target" >> /etc/systemd/system/kafka.service

RUN echo "[Unit]" >> /etc/systemd/system/zookeeper.service
RUN echo "Description=Apache Zookeeper server" >> /etc/systemd/system/zookeeper.service
RUN echo "Documentation=http://zookeeper.apache.org" >> /etc/systemd/system/zookeeper.service
RUN echo "Requires=network.target remote-fs.target" >> /etc/systemd/system/zookeeper.service
RUN echo "After=network.target remote-fs.target" >> /etc/systemd/system/zookeeper.service
RUN printf "\n\n" >> /etc/systemd/system/zookeeper.service
RUN echo "[Service]" >> /etc/systemd/system/zookeeper.service
RUN echo "Type=forking" >> /etc/systemd/system/zookeeper.service
RUN echo "User=zookeeper" >> /etc/systemd/system/zookeeper.service
RUN echo "Group=zookeeper" >> /etc/systemd/system/zookeeper.service
RUN echo "Environment=JAVA_HOME=/etc/alternatives/jre" >> /etc/systemd/system/zookeeper.service
RUN echo "ExecStart=/usr/local/zookeeper/zookeeper-3.4.10/bin/zkServer.sh start" >> /etc/systemd/system/zookeeper.service
RUN echo "ExecStop=/usr/local/zookeeper/zookeeper-3.4.10/bin/zkServer.sh stop" >> /etc/systemd/system/zookeeper.service
RUN echo "ExecReload=/usr/local/zookeeper/zookeeper-3.4.10/bin/zkServer.sh restart" >> /etc/systemd/system/zookeeper.service
RUN echo "WorkingDirectory=/var/zookeeper" >> /etc/systemd/system/zookeeper.service
RUN printf "\n\n" >> /etc/systemd/system/zookeeper.service
RUN echo "[Install]" >> /etc/systemd/system/zookeeper.service
RUN echo "WantedBy=multi-user.target" >> /etc/systemd/system/zookeeper.service

COPY start-up.sh start-up.sh

CMD ["/start-up.sh"]
