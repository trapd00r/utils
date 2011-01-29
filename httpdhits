#!/usr/bin/perl
# httpdhits
use strict;
use Data::Dumper;

my $color = 1;
my $cmd = shift // 'f';
my $log = shift // '/var/log/lighttpd/access.log';

my $noc  = "\033[0m";
my $clr1 = "\033[38;5;100m";
my $clr2 = "\033[38;5;197m";
$clr1 = $noc unless $color == 1;
$clr2 = $noc unless $color == 1;

open(my $fh, '<', $log) or die "Cant open $log: $!";

my(%ips, %reqfiles);

while(my $line = <$fh>) {
  my $re = '(.+?)';
  $line =~ /^$re $re $re \[$re:$re $re\] "$re $re $re" $re $re/;

  my $ip   = $1;
  my $ref  = $2;
  my $name = $3;
  my $date = $4;
  my $time = $5;
  my $gmt  = $6;
  my $req  = $7;
  my $file = $8;
  my $ptcl = $9;
  my $code = $10;
  my $size = $11;

  $ips{$ip}++;
  $reqfiles{$file}++;
}

my %opts = (
  f => sub { popfiles(); },
  i => sub { popips(); },
  h => sub { print "f\trequested files\ni\tIP adresses making the requests\n";},
);

defined($opts{$cmd}) && $opts{$cmd}->();

sub popips {
  my $sum;
  for my $ip(sort {$ips{$a} <=> $ips{$b}} keys(%ips)) {
    printf("$clr1% 5d$noc %s\n", $ips{$ip}, $ip);
    $sum += $ips{$ip};
  }
  printf("$clr2%6d$noc IP Adresses\n", $sum);
}

sub popfiles {
  my $sum;
  for my $file(sort {$reqfiles{$a}<=> $reqfiles{$b}} keys(%reqfiles)) {
    printf("$clr1% 5d$noc %s\n", $reqfiles{$file}, $file);
    $sum += $reqfiles{$file};
  }
  printf("$clr2%6d$noc requests\n", $sum);
}

