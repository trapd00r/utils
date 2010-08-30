#!/usr/bin/perl
use strict;
use Getopt::Long;

usage() if(!@ARGV);

our ($opt_count, $opt_perl) = (10, 0);
GetOptions(
  'count:i' => \$opt_count,
  'perl'    => \$opt_perl,
);

my @cmd = @ARGV;
iterate($opt_count, @cmd);

sub iterate {
  my $count = shift;
  my $cmd   = join(/ /,@_);

  my $i;
  for($i=0; $i<$count; ++$i) {
    if($opt_perl) {
      print(eval($cmd));
      print "\n";
      print $@;
    }
    else {
      system("$cmd");
    }
  }
  return(0);
}

sub usage {
  printf("iterate -c count (-pe perl code | command)\n");
  exit(0);
}
