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

printf("%30s\n",'DAGENS AVSNITT');
printf("%30s\n", "--------------" ); 
foreach my $rel(sort(@episodes)) {
  chomp($rel);
 # $rel = "\033[38;5;077m$rel \033[0m" if $rel !~ /S[0-9]{2}E[0-9]{2}/i;
 if($rel =~ /fringe|house|smallville|blasningen|the\.real\.hustle|
             mythbusters|simpsons/ix) {
   $rel = "\033[31m$rel\033[0m";
 }
  if($rel =~ /S01E01/i) {
    $rel = "\033[38;5;196m  NEW\033[0m: $rel";
  }
  elsif($rel =~ /do(c|k?)u(ment.+)?|
    (discovery|history)\.(channel)?|
               national\.geographic|
               colossal\./ix) {
    $rel = "\033[38;5;154m DOCU\033[0m: $rel";
  }
  elsif($rel =~ /swedish/i) {
    $rel = "\033[38;5;104m  SWE\033[0m: $rel";
  }
  elsif($rel =~ /EPL|WWE|UFC|UEFA|Rugby|La\.Liga|Superleague/) {
    $rel = "\033[38;5;245mSPORT\033[0m: $rel";
  }
  else {
    $rel = "       $rel";
  }

  print $rel, "\n";
}
print "\n";
if(@floss) {
  printf("%30s\n", 'DAGENS FLOSS');
  printf("%30s\n", '------------');
  foreach my $floss(@floss) {
    printf("       %s", $floss);
  }
}
