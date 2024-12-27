#!/bin/bash
DELAY=$(uptime -s | awk -F ':' '{print $2%10*60+$3}')
sleep $DELAY
