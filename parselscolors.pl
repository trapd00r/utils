#!/usr/bin/perl
use strict;

my $i = 0;
for(split(/:/, $ENV{LS_COLORS})) {
  my($ft,$color) = $_ =~ /\*\.(.+)=(.+)/;
  if(!@ARGV) {
    my $end;
    if($i % 6 == 0) {
      $end = "\n";
    }
    else {
      $end = "\t";
    }
    printf("\e[$color%s %10s\e[0m $end", 'm', $ft) 
      unless((!$ft)
          or($ft =~ /^(?:symlink|ow|tw|di|fi|ln|do|pi|bd|cd|su|sg|st|ex|mi|lc|rc|ec)$/));
    $i++;
  }
  else {
    open(my $fh, '>', ".$ft");
    close($fh);
  }
}
print "\n";
