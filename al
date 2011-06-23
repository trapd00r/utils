#!/usr/bin/perl

my $links_file = "$ENV{HOME}/usr/share/doc/links";

die( &usage ) if @ARGV <= 1;

my($link, $tag) = @ARGV;
if($link !~ m{^https?:}) {
  die( &usage );
}


open(my $fh, '>>', $links_file) or die($!);
print $fh sprintf("[%25.25s] %s\n", $tag, $link);
close $fh;

sub usage {
  return "Usage: $0 link [description]\n";
}
