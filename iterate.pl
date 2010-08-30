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
      my $foo = (eval($cmd));
      if($@) {
        # :D
        system("$cmd")==0 or print"$cmd: \e[1mJUNK args\e[0m\n" and exit(-1);
      }
      else {
        print $foo, "\n";
      }
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
