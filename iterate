#!/usr/bin/perl
use strict;
use Getopt::Long;
use Pod::Usage;

usage() if(!@ARGV);

our ($opt_count, $opt_perl, $opt_newline) = (10, 0, 0);
GetOptions(
  'count:i' => \$opt_count,
  'perl'    => \$opt_perl,
  'newline' => \$opt_newline,
  'help'    => sub { pod2usage(verbose => 1); },
);

my $torun = shift // undef;

iterate($opt_count, $torun);

sub iterate {
  my $count = shift;
  my $cmd = join(' ', @_);

  my $i;
  my @foo;

  my $error = 0;
  PERL_CMD:
  if($opt_perl) {
    if($error) {
      print "\e[1m\e[38;5;160m> \e[38;5;197m";
    }
    else {
      print "\e[1m\e[36m> \e[38;5;197m";
    }
    chomp($cmd = <STDIN>);
    print "\e[0m";
  }
  for($i=0; $i<$count; ++$i) {
    if($opt_perl) {
      my $foo = (eval($cmd));
      if($@) {
        print $@;
        $error = 1;
        goto  PERL_CMD;
      }
      else {
        $error = 0;
        print $foo, "\n";
        goto  PERL_CMD;
      }
    }
    else {
      system("$cmd");
      print "\n" unless(!$opt_newline);
    }
  }
  return(0);
}

sub usage {
  printf("iterate -c count (-pe perl code | command)\n");
  exit(0);
}

=pod

=head1 OPTIONS

  -c,   --count   number of iterations
  -n,   --newline append newline to every line (default: OFF)
  -p,   --perl    evaluate perl code
  -h,   --help    show help and exit

=cut
