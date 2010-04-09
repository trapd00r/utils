#!/usr/bin/perl 
use strict;
# clfpretty - prettity 
# phailer
# prettify the Common Log Format accesslogs.

use File::Tail;

my $log 	= $ARGV[0];
my $dgreen	= "\033[32;1m";
my $red		= "\033[31m";
my $lred	= "\033[31;1m";
my $blue	= "\033[34m";
my $dblue	= "\033[34;1m";
my $grey	= "\033[30;2m";
my $nc		= "\033[0m";
my $line	= "";
my $tail 	= File::Tail->new(name=>$log, maxinterval=>3, adjustafter=>3, interval=>0, tail=>100);
while(defined($line=$tail->read)) {
	my $e = "(.+?)";
	$line =~ /^$e $e $e \[$e:$e $e\] "$e $e $e" $e $e/;

	my $ip		= $1;
	my $ref		= $2;
	my $name	= $3;
	my $date	= $4;
	my $time	= $5;
	my $gmt		= $6;
	my $request	= $7;
	my $file	= $8;
	my $ptcl	= $9;
	my $code	= $10;
	my $size	= $11;

	printf "%s %s %s %7s %s %s %s %s %s %s %s %-13s %s %80s %s\n",
			$dgreen,$10,$grey,$7,$nc,$3,$blue,$4, $red,$5,$dblue,$1,$lred,$8,$nc;

}

