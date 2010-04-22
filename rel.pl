#!/usr/bin/perl
use strict;
# flexget parser

my $flexlog = "/home/scp1/.flexget.log";

open(LOG,$flexlog) || die "$flexlog does not exist?!\n";
my @releases = <LOG>;
close(LOG);

my (@episodes, @floss);

foreach my $release(@releases) {
  next unless($release =~ /Downloading:/);
  $release =~ s/(?:\w+\s+){2}\w+: //;
  push(@episodes, $release) if $release =~ /(S[0-9]+)?(E[0-9]+)?(.*TV)|VHS/;
  push(@floss, $release) if $release =~ /FLOSS/;
}

my $reRecurring = 'S[0-9]{2}E[0-9]{2}';
my $reWanted    = 'fringe|house$|smallville|blasningen|the\.real\.hustle|
                   |mythbusters|simpsons|talang';
my $reNew       = 'S01E01';
my $reDocu      = 'do(c|k?)u(ment.+)?|(discovery|history)\.(channel)?
                   |national\.geographic|colossal\..+';
my $reSport     = 'EPL|WWE|UFC|UEFA|Rugby|La\.Liga|Superleague
                   |Allsvenskan|Formula\.Ford';
my $reSwe       = 'swedish';

my $colorNone   = "\033[0m";
my $colorWanted = "\033[38;5;202m";
my $suffixNew   = "\033[38;5;196mNew Show\033[0m";
my $suffixDocu  = "\033[38;5;100mDocumentary\033[0m";
my $suffixSwe   = "\033[38;5;44mSwedish\033[0m";
my $suffixSport = "\033[38;5;144mSport\033[0m";
my $suffixRe    = "\033[38;5;198mNew Episode\033[0m";

printf("%30s\n",'TV TODAY');
printf("%30s\n", "--------" ); 
foreach my $rel(sort(@episodes)) {
  chomp($rel);
  $rel = sprintf("%55s", $rel);
  $rel = sprintf("%.55s",$rel);
  $rel = sprintf("%s $suffixRe", $rel) if $rel =~ /$reRecurring/ix;
  $rel = sprintf("%s $suffixDocu", $rel) if $rel =~ /$reDocu/ix;
  $rel = sprintf("%s $suffixSwe", $rel) if $rel =~ /$reSwe/ix;
  $rel = sprintf("%s $suffixSport", $rel) if $rel =~ /$reSport/ix;
  $rel = sprintf("%s $suffixNew", $rel) if $rel =~ /$reNew/ix;
  $rel = sprintf("$colorWanted%s$colorNone",$rel) if $rel =~ /$reWanted/i;


  print $rel, "\n";
}
print "\n";
if(@floss) {
  printf("%30s\n", 'FLOSS WEEKLY');
  printf("%30s\n", '------------');
  foreach my $floss(@floss) {
    printf("       %s", $floss);
  }
}
