#!/bin/bash
TIMESTAMP=$(ls -tU ./current/*.json | tail -1 | xargs stat -f '%SB' | awk -F'[ .]' '{print $1":"$2}')
 
echo $TIMESTAMP
