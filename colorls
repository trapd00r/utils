#!/usr/bin/perl
use strict;
use Data::Dumper;

my $CPERM = "\033[38;5;131m";
my $CFNO  = "\033[38;5;132m";
my $CDATE = "\033[38;5;149m";
my $CDIM  = "\033[38;5;100m";
my $CPIPE = "\033[38;5;197m";

@ARGV = './' unless  @ARGV;

# -halv ?
my $ls = "ls -hAov --indicator-style=file-type --color=always --group-directories-first --time=ctime \"@ARGV\"";
open(my $ph, "-|", $ls) or die $!;

my @arr = <$ph>;

my $i=-1;
my %seen;
for(@arr) {
  ++$i;
  next if(/^total/);
  #s/->/▪▶/g;
  m/^([drwxsT-]+)\s+([0-9]+)\s+([A-Za-z0-9]+)\s+([0-9KMGT\.]+)\s+([A-Za-z]{3})\s+([0-9]{1,3})\s+([0-9:]+)(.+)(->)?(.+)?$/;

  my $perm = $1;
  my $fno  = $2;
  my $user = $3;
  my $size = $4;
  my $month = $5;
  my $dinmon = $6;
  my $time = $7;
  my $file = $8;
  my $sym = $9;
  my $sym_t = $10;

  $seen{$file}++;
  next if($seen{$file} > 1);
  next if(!$file);


  printf("$CPERM%s$CDIM%3d\033[0m $CDATE%2s\033[0m $CFNO%s\033[0m$CPIPE▕\033[0m%s\n",
    $perm, $dinmon,$month,sprintf("%4d",$fno), $file);
  print $sym,$sym_t;
}
print "\033[38;5;160m$i\033[0m Files\n";

#print Dumper @arr;
