#!/usr/bin/perl
use strict;
use Term::ExtendedColor; # 256 colors

=for environment

There's no reliable way of setting environment variables for the parent process.
This  means that

  system("export LS_COLORS=\$EXPORT");

will happily change the LS_COLORS environment variable for the B<child> process,
and then exit.

A solution would be to write the command ( export ... ) to a file, and source
that from within a shellscript:

  print $fh $EXPORT

and later, in the shell:

  source my_file.sh

Or use B<eval> (or backticks, or $()):

  eval `perl this_script.pl`

The problem here is that we output a colored square along with instructions as
well.

I 'solved' this by printing everything except the actual export command to
STDERR - $() will only take input from STDOUT, so we can simply do this:

  $(perl this_script.pl)

A further improvement would probably be to put that into a shellscript, and let
the shellscript execute this program, so the user can simply do

  sh foobar.sh

instead.

It's ugly. But it works!

=cut

my $EXPORT;
my %ls_colors = (
  normal                  => 'no',
  file                    => 'fi',
  dir                     => 'di',
  link                    => 'ln',
  pipe                    => 'pi',
  door                    => 'do',
  block                   => 'bd',
  char                    => 'cd',
  orphan                  => 'or',
  socket                  => 'so',
  setuid                  => 'su',
  setgid                  => 'sg',
  sticky_other_writable   => 'tw',
  other_writeable         => 'ow',
  sticky                  => 'st',
  exec                    => 'ex',
  missing                 => 'mi',
  leftcode                => 'lc',
  rightcode               => 'rc',
  encode                  => 'ec', # non-filename tet

);

set_ls_color();

sub color_square {
  select(STDERR);
  for(0 .. 255) {
    if($_ % 8 == 0) {
      print "\n";
    }
    else {
      printf ("%s%s", bg($_, sprintf(" %03d ", $_)));
    }
  }
  print "\n";
}

sub set_ls_color {
  select(STDERR);
  print "> ";

  $ENV{LS_COLORS} = '';
  for my $f(keys(%ls_colors)) {
    color_square();
    printf("Color for %s: ", $f);
    chomp(my $answer = <STDIN>);
    #my $answer = 197;

    if(valid_color($answer)) {
      $EXPORT .= "$ls_colors{$f}=38;5;$answer:";
    }
  }
  $EXPORT =~ s/^(.+):$/"$1"/;
  $EXPORT =~ s/^/export LS_COLORS=/;


  select(STDOUT);
  print $EXPORT;

}

sub valid_color {
  my $color = shift;
  return 1 if ( ($color =~ m/^\d+$/) and ($color < 256) and ($color > -1) );
  return;
}
