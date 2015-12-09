#!/bin/bash

########################################################
# T-Pot                                                #
# Container and services status script                 #
#                                                      #
# v0.04 by mo, DTAG, 2015-08-20                        #
########################################################
myCOUNT=1
myIMAGES=$(cat /data/images.conf)
while true
do
  if ! [ -a /var/run/check.lock ];
    then break
  fi
  sleep 0.1
  if [ $myCOUNT = 1 ];
    then
      echo -n "Waiting for services "
    else echo -n .
  fi
  if [ $myCOUNT = 300 ];
    then
    echo
    echo "Services are busy or not available. Please retry later."
    exit 1
  fi
  myCOUNT=$[$myCOUNT +1]
done
echo
echo
echo "======| System |======"
echo Date:"     "$(date)
echo Uptime:"  "$(uptime)
echo CPU temp: $(sensors | grep "Physical" | awk '{ print $4 }')
echo
for i in $myIMAGES
do
  echo "======| Container:" $i "|======"
  docker exec $i supervisorctl status | GREP_COLORS='mt=01;32' egrep --color=always "(RUNNING)|$" | GREP_COLORS='mt=01;31' egrep --color=always "(STOPPED|FATAL)|$"
  echo
done