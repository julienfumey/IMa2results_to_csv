#!/usr/bin/perl

use strict;
use IO::File;

my $infile = IO::File->new("$ARGV[0]", "<");


my $write = 0;
my $outfile;
READFILE:while(my $line = <$infile>){
    my $histogroup = 0;
    if($line =~ s/^HISTOGRAM GROUP ([0-4])/$1/){
        $write = 1;
        $histogroup = $1;
    }

    if($write == 0){
        next READFILE;
    }

    if($line =~ /^Summaries/){
        $outfile = IO::File->next("$ARGV[0]\_group_$histogroup\_summaries.csv", ">");
        $write = 2;
        next READFILE;
    }

    if($line =~ /^Parameter/){
        $outfile = IO::File->next("$ARGV[0]\_group_$histogroup\_parameter.csv", ">");
        $write = 2;
        next READFILE;
    }

    if ($line =~ /^$/){
        $outfile->close();
        $write = 1;
        next READFILE;
    }

    $outfile->write($line);


    if($write == 1){
        next READFILE;
    }


    if($line =~ /^ASCII Curves/){
        $write = 0;
        last READFILE;
    }
}
