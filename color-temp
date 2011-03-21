#!/bin/bash
# $Id$

# -- AUTHOR & COPYRIGHT -------
# weather bash script
# Copyright 2011 Charles Mauch (cmauch@gmail.com)
# Licensed under the GPLv3

# -- DESCRIPTION --------------
# Sets Monitor temperature based on local weather conditions
# Called a small perl script which figures weather information

# Redshift adjusts the color temperature of your screen according to your
# surroundings. edshift adjusts the color temperature according to the position
# of the sun. A different color temperature is set during night and daytime.
# During twilight and early morning, the color temperature transitions smoothly
# from night to daytime temperature to allow your eyes to slowly adapt. At
# night the color temperature should be set to match the lamps in your room.
# This is typically a low temperature at around 3000K-4000K (default is 3700K).
# During the day, the color temperature should match the light from outside,
# typically around 5500K-6500K (default is 5500K). The light has a higher
# temperature on an overcast day.

# Xcalib fixes a small wierd error on my netbook display by reducing the 
# constast slightly.

# -- RELATED ------------------
# see weather and redshift man page
#


. /home/cmauch/.Xdbus
condition=$*

# Determinite which power mode the system is on: AC or Battery? 
if [[ `awk '/state/ { print $2}' /proc/acpi/ac_adapter/AC/state` == "on-line" ]] 
then 
   # Clear = Normal Bright Gamma
   echo "Tweaking Normal to Normal Gamma"
   GAMMA="1.0 1.0 1.0" 
else
   # Coudy = Less Saturated Gamma 
   echo "Tweaking Normal to Less Saturdated Gamma"
   GAMMA="0.8 0.8 0.8:" 
fi 

if [ "$*" = "" ]; then
        echo "No weather condition given"
        exit 1
elif [ "$*" = "Clear" ]; then
        # Sunny Day
        redshift -l 47.2530556:-122.4430556 -t 5500:3800 -g $GAMMA -o -v 
else
        # Cloudy Day
        redshift -l 47.2530556:-122.4430556 -t 6500:3800 -g $GAMMA -o -v
fi

# Fix Contrast
xcalib -a -co 98
