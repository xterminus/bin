#!/usr/bin/perl

my $sleepduration = 1;
my $rfcheck       = 30;
my $counter       = 1;
my $checkstatus;

while () {

    # Check rfkill status every $rfcheck seconds
    if ( $counter < $rfcheck ) {
        $checkstatus = &rfkill;
    } else {
        $counter = 1;
    }

    # Set led status us8ing iwpriv
    if ( $checkstatus eq "no" ) {
        sleep $sleepduration;
        `sudo iwpriv eth1 set_leddc 1`;
        sleep $sleepduration;
        `sudo iwpriv eth1 set_leddc 0`;
    } else {
        sleep $sleepduration;
        `sudo iwpriv eth1 set_leddc 0`;
    }
    $counter++;
}

sub rfkill {
    my $command = `rfkill list`;
    $command =~ /Hard\ blocked:\ (.*)/go;
    my $status = $1;
    $status =~ s/\n//g;
  return $status;
}
