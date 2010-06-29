package Deparse::Syntax;
require Exporter;
@ISA = qw(Exporter);
@EXPORT_OK = qw(deparse);

use strict;
use warnings;
use Carp;
use B::Deparse;
use Data::Dumper;

my $fname = "/tmp/@{[time()]}.pl";
my $body  = undef;

sub deparse {
  my $coderef = shift;
  my $dp = B::Deparse->new('q', '-si2');
  $body = $dp->coderef2text($coderef);

  mktemp();

  exec("v $fname && rm -v $fname") or die($!);
}


sub mktemp {
  open(my $tmp, '>', "$fname") or croak($!);
  print $tmp $body;
  close($tmp);
}

1;
