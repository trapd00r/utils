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
  push(@episodes, $release) if $release =~ /(S[0-9]+)?(E[0-9]+)?(.*TV)/;
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

printf("%30s\n",'TV TODAY');
printf("%30s\n", "--------" ); 
foreach my $rel(sort(@episodes)) {

  chomp($rel);
  $rel = "\033[38;5;196m$rel \033[0m" if $rel =~ /$reNew/;
  $rel = "\033[38;5;114m       $rel\033[0m" if $rel =~ /$reDocu/i;
  $rel = "\033[38;5;245mSPORT\033[0m: $rel" if $rel =~ /$reSport/i;
  $rel = "\033[38;5;104m  SWE\033[0m: $rel" if $rel =~ /$reSwe/i;
  $rel = "\033[38;5;208m$rel\033[0m" if $rel =~ /$reWanted/i;
  $rel = "\033[38;5;131m$rel \033[0m" if $rel !~ /$reRecurring/i;
  $rel = "       $rel" if $rel !~ /$reNew|$reDocu|$reSport|$reSwe/i;

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
