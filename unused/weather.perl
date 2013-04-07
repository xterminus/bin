#!/usr/bin/perl
# $Id$

# -- AUTHOR & COPYRIGHT -------
# weather perl script
# Copyright 2011 Charles Mauch (cmauch@gmail.com)
# Licensed under the GPLv3

# -- DESCRIPTION --------------
# Sets Monitor temperature based on local weather conditions
# Calls a small bash script which invokes proper X environment, dbus settings
# and calls redshift to alter monitor temperature based on time of day as well

# -- RELATED ------------------
# see weather.bash and redshift man page
#


use Weather::Underground;
use Data::Dumper;

my $clearconditions = "Clear|Scattered\ Clouds|Partly\ Sunny|Partly\ Cloudy";
my $weathercache    = "/tmp/weathercache";
my $localcache      = "/home/cmauch/.weather";
my $usecache        = "no";
my $update          = "no";
my $weather         = "Clear";
my $localtime       = time;
my $wunderground;
my $cacheage;
my $cached;
my $output;


if ( -e "$localcache" ) {
    my (
        $dev,  $ino,   $mode,  $nlink, $uid,     $gid, $rdev,
        $size, $atime, $mtime, $ctime, $blksize, $blocks
    ) = stat($localcache);
    $cacheage = $localtime - $mtime;
    if ( $cacheage > 1800 ) {
        $update = "yes";
    }
}
else {
    $update = "yes";
}

if ( $update eq "yes" ) {
    print "Trying to update Weather Cache\n";

    # Cache_max_age is seconds, (4 hours)
    $wunderground = Weather::Underground->new(
        place => "Tacoma, Washington",
        debug => 0,
    ) || die "Error, could not create new weather object: $@\n";

    # Get the weather, if offline, just set it "Clear"
    $arrayref = $wunderground->get_weather() or $usecache = "yes";
}
else {
    $usecache = "yes";
}

# If we are using cached data, check for a cache, read it in
# otherwise, update cached data.
if ( $usecache eq "yes" ) {
    if ( -e "$localcache" ) {
        print "Using Cache instead of live data\n";
        open( ORIG, "$localcache" ) || die("Could not open $localcache!");
        my $input = <ORIG>;
        close ORIG;
        if ($input) {
            $weather = $input;
        }
        else {
            print "No known weather data, something is wrong\n";
            $weather = "Unknown";
        }
    }
}
else {
    print "Storing new Weather data\n";
    $weather = $arrayref->[0]->{conditions};
    open( ORIG, ">$localcache" ) || die("Could not open $localcache!");
    print ORIG $arrayref->[0]->{conditions};
    close ORIG;
}

#print "$weather\n";


if ( $weather =~ /$clearconditions/ ) {
    print "$weather".", executing Clear configuration\n";
    $output = `/home/cmauch/bin/weather.bash Clear`;
}
else {
    print "$weather".", executing Cloudy/Overcast configuration\n";
    $output = `/home/cmauch/bin/weather.bash $weather`;
}
print $output;
