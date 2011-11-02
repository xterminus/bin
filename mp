#!/bin/bash
touch ~/.shiftpause
weather.perl
mplayer -vo gl -fs -zoom -stop-xscreensaver -nobps -alang en -input file=/tmp/mplayer.fifo "$@"
rm ~/.shiftpause
weather.perl
