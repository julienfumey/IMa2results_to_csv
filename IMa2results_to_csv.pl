#!/usr/bin/perl

use strict;
use IO::File;

my $infile = IO::File->new("$ARGV[0]", "<");


my $write = 0;
while(my $line = <$infile>){
    if($line =~ /^HISTOGRAM/){
        print "toto";
    }
}
