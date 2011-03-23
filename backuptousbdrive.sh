#!/bin/bash
. /home/cmauch/.Xdbus

RSYNCOPTIONS="-a --no-o --no-p --no-g --safe-links --modify-window 1"

{
mount_point=$(grep CMBACKUP /etc/mtab)
attempts=1
while [ -z "$mount_point" ] && [ "$attempts" -le 30 ]; do
    # $mount_point has not been found
    # quit if this fails more than 30 times. 
    # This should not be necessary, but it better to be safe
    # than have the script trapped in this loop forever for
    # some unforeseen reason.
    sleep 1
    mount_point=$(grep CMBACKUP /etc/mtab)
    attempts=$(($attempts+1))
done

 
if [ -n "$mount_point" ]; then
    cd ~
    /home/cmauch/bin/alt-notify-send "Backup Message" "USB Backup device detected" 1
    rsync $RSYNCOPTIONS /home/cmauch/Pictures/* /media/CMBACKUP/Pictures
    rsync $RSYNCOPTIONS /home/cmauch/Documents/Fanfiction/Universe/* /media/CMBACKUP/Documents/Fanfiction
    rsync $RSYNCOPTIONS /home/cmauch/Documents/Resumes/* /media/CMBACKUP/Documents/Resumes
    rsync $RSYNCOPTIONS /home/cmauch/Documents/Jist\ Cards/* /media/CMBACKUP/Documents/Jist\ Cards
    /home/cmauch/bin/alt-notify-send "Backup Message" "Your USB Backup has completed" 1
    echo "Completed backup on `date`" >> /home/cmauch/backup.log
fi
} &
