#!/bin/sh

if [[ $ZOOKEEPER_ID = '' ]]; then
	echo "Must set enviromental variable ZOOKEEPER_ID"
	exit
fi

if [[ $ADMIN_USERNAME != '' && $ADMIN_PASSWORD != '' && ! -d "/home/$ADMIN_USERNAME" ]]; then
  # Setup User
  echo "Creating user: $ADMIN_USERNAME"
  useradd $ADMIN_USERNAME -g wheel
  echo $ADMIN_PASSWORD | passwd $ADMIN_USERNAME --stdin
else
  echo "User $ADMIN_USERNAME already exists"
fi

if [[ ! -f "/root/.one-time-setup" ]]; then
	echo $ZOOKEEPER_ID > /var/zookeeper/data/myid
	
	printf "\n\n" >> /usr/local/zookeeper/zookeeper-3.4.10/conf/zoo.cfg
	echo "server.1=0.0.0.0:2888:3888" >> /usr/local/zookeeper/zookeeper-3.4.10/conf/zoo.cfg || echo "server.1=kafka$ZOOKEEPER_ID:2888:3888" >> /usr/local/zookeeper/zookeeper-3.4.10/conf/zoo.cfg

	
	sed -i  "s/broker\.id=.*/broker\.id=$ZOOKEEPER_ID/" /usr/local/kafka/kafka_2.11-0.10.2.2/config/server.properties
	
	sed -i  "s/#listeners=.*/listeners=PLAINTEXT:\/\/0\.0\.0\.0:9092/" /usr/local/kafka/kafka_2.11-0.10.2.2/config/server.properties
	
	declare -i n
	n=9091+$ZOOKEEPER_ID
	
	sed -i  "s/#advertised\.listeners.*/advertised\.listeners=PLAINTEXT:\/\/kafka$ZOOKEEPER_ID:$n/" /usr/local/kafka/kafka_2.11-0.10.2.2/config/server.properties
	
	sed -i  "s/zookeeper\.connect=.*/zookeeper\.connect=127\.0\.0\.1:2181/" /usr/local/kafka/kafka_2.11-0.10.2.2/config/server.properties
	
	
	touch "/root/.one-time-setup"
fi

echo "Starting SSH"
/usr/sbin/sshd

echo "Starting zookeepr service"
/usr/local/zookeeper/zookeeper-3.4.10/bin/zkServer.sh start

start_zookeeper() {

	/usr/local/zookeeper/zookeeper-3.4.10/bin/zkServer.sh restart 2>/dev/null
	while [[ $RESULT != "Mode"* ]] ; do
		RESULT=$(/usr/local/zookeeper/zookeeper-3.4.10/bin/zkServer.sh status 2>/dev/null)
		echo $RESULT
		sleep 10
	done
	
}

start_zookeeper

sleep 5


echo "Starting kafka service"
/usr/local/kafka/kafka_2.11-0.10.2.2/bin/kafka-server-start.sh /usr/local/kafka/kafka_2.11-0.10.2.2/config/server.properties &

while [[ 1 != 0 ]] ; do
	RESULT=$(/usr/local/zookeeper/zookeeper-3.4.10/bin/zkServer.sh status 2>/dev/null)
	echo $RESULT
	sleep 10
done

tail -f /dev/null
