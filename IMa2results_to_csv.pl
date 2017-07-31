#!/usr/bin/perl

use strict;
use IO::File;

my $infile = IO::File->new("$ARGV[0]", "<");


my $write = 0;
my $outfile;
my $histogroup = 0;
my $countl = 0;

READFILE:while(my $line = <$infile>){
    if($line =~ /^HISTOGRAM GROUP [0-4]/){
        $line =~ s/^HISTOGRAM GROUP ([0-9])/$1/;
        $histogroup = $1;
        print $histogroup;
        $write = 1;
        next READFILE;
    }

    if($write == 0){
        next READFILE;
    }

    if($line =~ /^ Summaries/ && $write == 1){
        print "opening $ARGV[0]\_group_$histogroup.csv\n";
        $outfile = IO::File->new("$ARGV[0]\_group_$histogroup.csv", ">") or die "Can't open file $!";
        $write = 2;
        $countl = 1018;
        next READFILE;
    }

    if ($countl == 0 && $write == 2){
        print $write."\n";
        $outfile->close();
        $write = 1;
        next READFILE;
    }

    if($write == 1){
        next READFILE;
    }

    if($write == 2 && $countl > 0){
        $outfile->write($line);
        $countl -= 1;
    }

    if($line =~ /^ASCII Curves/){
        $write = 0;
        last READFILE;
    }
}
