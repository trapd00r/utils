#!/usr/bin/perl
use strict;
# flexget parser

my $flexlog = "/home/scp1/.flexget.log";

open(LOG,$flexlog) || die "$flexlog does not exist?!\n";
my @releases = <LOG>;
close(LOG);

my (@episodes, @floss, @music);

foreach my $release(@releases) {
  next unless($release =~ /Downloading:/);
  $release =~ s/(?:\w+\s+){2}\w+: //;
  if($release =~ /(S[0-9]+)?(E[0-9]+)?(.*TV)|VHS|SWEDISH/i) {
    push(@episodes, $release);
  }
  elsif($release =~ /FLOSS/) {
    push(@floss, $release);
  }
  else {
    push(@music, $release);
  }
}

my $reRecurring = 'S[0-9]{2}E[0-9]{2}';
my $reWanted    = 'fringe|house$|smallville|blasningen|the\.real\.hustle|
                   |mythbusters|simpsons|talang|uppdrag\.granskning';
my $reNew       = 'S01E01';
my $reDocu      = 'do(c|k?)u(ment.+)?|(discovery|history)\.(channel)?
                   |national\.geographic|colossal\..+';
my $reSport     = 'EPL|WWE|UFC|UEFA|Rugby|La\.Liga|Superleague
                   |Allsvenskan|Formula\.Ford';
my $reSwe       = 'swedish';

my $rePsy       = 'PsyCZ|MYCEL|UPE|HiEM|PSi';
my $reRap       = '.+-(H3X|wAx|CMS|BFHMP3|WHOA|RNS|C4|UMT|0MNi.+)$';
my $reRock      = 'LzY|qF';
my $reHS        = 'TALiON|HB';
my $reVA        = 'VA(-|_-_).+';
my $reWEB       = '.+(-WEB-)';
my $reCDS       = '.+(-CDS-)';
my $reCDM       = '.+(-CDM-)';
my $reCDA       = '.+(-CDA-)';
my $reDAB       = '.+(-DAB-)';
my $reVLS       = '.+(-VLS-)';
my $reCABLE     = '.+(-CABLE-)';
my $reLIVE      = 'Live_(on|at)';

my $colorNone   = "\033[0m";
my $colorWanted = "\033[38;5;202m";
my $suffixNew   = "\033[38;5;196mNew Show\033[0m";
my $suffixDocu  = "\033[38;5;100mDocumentary\033[0m";
my $suffixSwe   = "\033[38;5;44mSwedish\033[0m";
my $suffixSport = "\033[38;5;144mSport\033[0m";
my $suffixRe    = "\033[38;5;198mNew Episode\033[0m";

my $suffixPsy   = "\033[38;5;111mPsychedelic\033[0m";
my $suffixRap   = "\033[38;5;129mHip-Hop\033[0m";
my $suffixRock  = "\033[38;5;192mRock\033[0m";
my $suffixHS    = "\033[38;5;83mmHardstyle\033[0m";
my $suffixVA    = "\033[38;5;149mVA\033[0m";
my $suffixWEB   = "\033[38;5;199mWEB\033[0m";
my $suffixCDS   = "\033[38;5;212mSingle\033[0m";
my $suffixCDM   = "\033[38;5;232mMaxi\033[0m";
my $suffixCDA   = "\033[38;5;132mAlbum\033[0m";
my $suffixDAB   = "\033[38;5;22mAlbum\033[0m";
my $suffixVLS   = "\033[38;5;220mVinyl\033[0m";
my $suffixCABLE = "\033[38;5;130mCable\033[0m";
my $suffixLIVE  = "\033[38;5;79mLive\033[0m";

printf("\033[38;5;154m%40s\033[0m\n",'TV TODAY');
foreach my $rel(sort(@episodes)) {
  chomp($rel);
  $rel = sprintf("%60s", $rel);
  $rel = sprintf("%.60s",$rel);
  $rel = sprintf("%s $suffixRe", $rel) if $rel =~ /$reRecurring/ix;
  $rel = sprintf("%s $suffixDocu", $rel) if $rel =~ /$reDocu/ix;
  $rel = sprintf("%s $suffixSwe", $rel) if $rel =~ /$reSwe/ix;
  $rel = sprintf("%s $suffixSport", $rel) if $rel =~ /$reSport/ix;
  $rel = sprintf("%s $suffixNew", $rel) if $rel =~ /$reNew/ix;
  $rel = sprintf("$colorWanted%s$colorNone",$rel) if $rel =~ /$reWanted/i;


  print $rel, "\n";
}
print '=' x 80, "\n";
printf("\033[38;5;154m%40s\033[0m\n", "MUSIC TODAY");
foreach my $rel(@music) {
  chomp($rel);
  $rel = sprintf("%60s", $rel);
  $rel = sprintf("%.60s", $rel);
  $rel = sprintf("%s $suffixPsy", $rel)   if $rel =~ /$rePsy/;
  $rel = sprintf("%s $suffixRap", $rel)   if $rel =~ /$reRap/;
  $rel = sprintf("%s $suffixRock", $rel)  if $rel =~ /$reRock/;
  $rel = sprintf("%s $suffixHS", $rel)    if $rel =~ /$reHS/;
  $rel = sprintf("%s $suffixVA", $rel)    if $rel =~ /$reVA/;
  $rel = sprintf("%s $suffixWEB", $rel)   if $rel =~ /$reWEB/;
  $rel = sprintf("%s $suffixCDS", $rel)   if $rel =~ /$reCDS/;
  $rel = sprintf("%s $suffixCDM", $rel)   if $rel =~ /$reCDM/;
  $rel = sprintf("%s $suffixCDA", $rel)   if $rel =~ /$reCDA/;
  $rel = sprintf("%s $suffixDAB", $rel)   if $rel =~ /$reDAB/;
  $rel = sprintf("%s $suffixVLS", $rel)   if $rel =~ /$reVLS/;
  $rel = sprintf("%s $suffixCABLE", $rel) if $rel =~ /$reCABLE/;
  $rel = sprintf("%s $suffixLIVE", $rel)  if $rel =~ /$reLIVE/;


  print "$rel\n";
}
print "\n";
if(@floss) {
  printf("%30s\n", 'FLOSS WEEKLY');
  printf("%30s\n", '------------');
  foreach my $floss(@floss) {
    printf("       %s", $floss);
  }
}
