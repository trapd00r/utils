#!/usr/bin/perl
# Prettier git diff
use strict;
use Syntax::Highlight::Engine::Kate;
use Term::ExtendedColor qw(:attributes);

local $ENV{GIT_PAGER} = '';
open(my $popen, '-|', qq{git diff @ARGV}) or die($!);
chomp(my @input = <$popen>);

if(scalar(@input) == 0) {
  print "No changes made.\n" and exit;
}

my $h = Syntax::Highlight::Engine::Kate->new(
  language      => 'Diff',
  substitutions => {
    #'+' => fg('green20', bold('+')),
    #'-' => fg('red1',     bold('+')),
    #'@' => fg('blue4', '@'),
  },
  format_table => {
    Alert        => [ fg(148), clear() ],
    BaseN        => [ fg(196), clear() ],
    BString      => [ fg(100), clear() ],
    Char         => [ fg(111), clear() ],
    Comment      => [ fg(137). italic(), clear() ],
    DataType     => [ fg(148), clear() ],
    DecVal       => [ fg(240), clear() ],
    Error        => [ fg(160), clear() ],
    Float        => [ fg(135). bold(), clear() ],
    Function     => [ fg(202), clear() ],
    IString      => [ fg(179), clear() ],
    Keyword      => [ fg(244). bold(), clear() ],
    Normal       => [      "", ""      ],
    Operator     => [ fg(148), clear() ],
    Others       => [ fg(225), clear() ],
    RegionMarker => [ fg(246), clear() ],
    Reserved     => [ fg(178), clear() ],
    String       => [ fg(143), clear() ],
    Variable     => [ fg(148), clear() ],
    Warning      => [ fg(160), clear() ],
  },
);


for(@input) {
  s{^([+])(.+)}{fg('green26', [ bold($1), $2 ])}e;
  s{^([-])(.+)}{fg('red3',    [ bold($1), $2 ])}e;
  s{
    ^(@@)\s+([-,0-9]+)\s+([+,0-9]+)\s+(@@)
  }
  {
    "\n" . fg('dodgerblue1', $1) . fg('deeppink4', bold(" $2 "))
         . fg('yellow18', bold($3))
  }ex;
  print $h->highlightText( $_ ), "\n";
}
