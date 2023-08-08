#!/bin/sh

echo "Starting SSH"
/usr/sbin/sshd


echo "Starting HTTPD"
rm -rf /run/httpd/httpd.pid
start_httpd()
{
/usr/sbin/httpd -k start
while [[ $RESULT != *"already runnin"* ]] ; do
        RESULT=$(/usr/sbin/httpd -k start 2>/dev/null)
        echo $RESULT
        sleep 10
        done
}
start_httpd

echo "System is Ready"
tail -f /dev/null
