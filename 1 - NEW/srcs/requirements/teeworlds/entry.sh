#!/bin/sh

echo "sv_port 8303" > autoexec.cfg
echo "bindaddr 0.0.0.0" >> autoexec.cfg

./teeworlds-0.7.5-linux_x86_64/teeworlds_srv -f autoexec.cfg
