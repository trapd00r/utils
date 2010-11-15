#!/usr/bin/perl
# All functions from the List::MoreUtils module ported using map
use strict;
use List::Util 'shuffle';

$\ = "\n";
my @foo = map{ sprintf("%03d", $_) } (0..200);


{
  # List::MoreUtils::all
  my $i = 0;
  map { /\d+/ and $i++; } @foo;
  print 'all: yes' if($i == scalar(@foo));
}


# List::MoreUtils::none
print 'none: no' if ! map {my $i = 0; /\d{4}/ and $i++; $i } @foo;



# List::MoreUtils::any
print 'any: yes' if map { my $i = 0; /^19\d/ and $i++; $i } @foo;


{
  # List::MoreUtils::true
  my $i = 0;
  print "true: $i" if map { $_ and $i++; } @foo;
}

{
  # List::MoreUtils::false
  push(@foo, (0) x sprintf("%.d", rand(128)));
  my $i = 0;
  print "false: $i" if map { !$_ and $i++; } @foo;
}

{
  # List::MoreUtils::lastidx
  sub lastidx {
    my %map;
    my $i;
    for(shuffle(@_)) {
      if(/^1(?:3|9)/) {
        $map{$i} = $_;
      }
      $i++;
    }
    for(sort { $a <=> $b } (keys(%map))) {
      return($_);
    }
  }
  print "lastidx: " . lastidx(@foo);
}

{
  # List::MoreUtils::firstidx

  sub firstidx {
    my %map;
    my $i;
    for(shuffle(@_)) {
      if(/^1(?:3|9)/) {
        $map{$i} = $_;
      }
      $i++;
    }
    for(sort { $map{$a} <=> $map{$b} } (keys(%map))) {
      return($_);
    }
  }
  print "firstidx: " . firstidx(@foo);
}

{
  # List::MoreUtils::insert_after
  my $i = 0;
  my $n = sprintf("%.d", rand(9));
  map{ $_ =~ /$n/ and $_ .= ' foobar'; } @foo;
  print "insert_after: $i" if map { / foobar$/ and $i++; $i; } @foo;
}
