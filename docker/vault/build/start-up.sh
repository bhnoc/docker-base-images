#!/bin/sh


echo "System is Ready"
start_vault() {
  /usr/bin/vault server -config=/etc/vault/config.hcl 2>/dev/null
  while [[ $RESULT != *"already in use"* ]]; do
    RESULT=$(/usr/bin/vault server -config=/etc/vault/config.hcl 2>/dev/null)
    echo $RESULT
    sleep 10
  done
}
start_vault

tail -f /dev/null
