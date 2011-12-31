#!/bin/bash
killall redshift
sleep 1
#mplayer -vo gl -fs -zoom -stop-xscreensaver -nobps -alang en -input file=/tmp/mplayer.fifo "$@"
mplayer -fs -zoom -stop-xscreensaver -nobps -alang en -input file=/tmp/mplayer.fifo "$@"
sleep 1
redshift -l 47.2530556:-122.4430556 -t 6500:3800 &
