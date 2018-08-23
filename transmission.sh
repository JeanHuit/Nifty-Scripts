#!/bin/bash

cd

sudu apt-get update && sudo apt-get upgrade -y

sudo apt install transmission-cli transmission-common transmission-daemon -y

sleep 5

sudo service transmission-daemon stop

sleep 5

curl http://termbin.com/q2v3 > settings.json

sudo mv settings.json /var/lib/transmission-daemon/info/settings.json

sudo usermod -a -G debian-transmission root

sudo service transmission-daemon start