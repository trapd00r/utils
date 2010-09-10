#!/usr/bin/perl
use strict;
=head1 NAME

  dynxres - set X color resources dynamically

=head1 DESCRIPTION

  dynxres rocks

=head1 OPTIONS

  -x,   --xres        X resources definations file location
  -p,   --prefix      X resource prefix
  -d,   --darker      darken the current colorscheme by INTEGER
  -b,   --brighter    brighten the current colorscheme by INTEGER
  -t,   --tint        make a new tinted colorscheme with HEX_COLOR as
                      as the starting point
  -s,   --stepping    control how far away from the original color we
                      want to go

=head1 AUTHOR

Written by Magnus Woldrich

License GPLv2

=cut


our $APP      = 'dynxres';
our $VERSION  = '0.2.3';

my  $DEBUG = 0;

use Data::Dumper;
use Getopt::Long;
use Pod::Usage;

our $xres_prefix = 'URxvt.india'; # URxvt is the default
our $xresources  = "$ENV{HOME}/configs/.Xresources";

our($opt_darker, $opt_brighter, $opt_tint);
our($opt_stepping) = 2000;
GetOptions(
  'prefix:s'    => \$xres_prefix,
  'darker:i'    => \$opt_darker,
  'brighter:i'  => \$opt_brighter,
  'tint:s'      => \$opt_tint,
  'stepping:i'  => \$opt_stepping,
  'xres'        => \$xresources,
  'help'        => sub { pod2usage(verbose => 1) && exit(0); },
);

if($opt_darker) {
  set_colorscheme(make_new_colorscheme('', $opt_darker, get_colorscheme($xresources)));
}
if($opt_brighter) { #FIXME
  set_colorscheme(make_new_colorscheme('brighter', $opt_brighter, get_colorscheme($xresources)));
}
if($opt_tint) {
  set_colorscheme(make_new_colorscheme($opt_tint, $opt_stepping));
}

sub make_new_colorscheme {
  #FIXME
  my $tint_start = shift;
  my $stepping    = shift;

  my $modifier; # darken amount, brighten amount, start color
  my @current_colorscheme;

  if(@_ < 2) {
    $modifier = $tint_start;
  }
  else {
    #FIXME 
    $modifier = shift; # how many iterations?
    if($tint_start eq 'brighter') {
      $modifier = "-$modifier"; #FIXME This doesnt work. Or does it?
    }
    @current_colorscheme = @_;
  }

  my @valid_hex = qw(A B C D E F a b c d e f 0 1 2 3 4 5 6 7 8 9);
  print scalar(@current_colorscheme), " in \@current_colorscheme\n---\n" if($DEBUG);
  my $ansi;

  if(@current_colorscheme) { #use the colorscheme 
    for $ansi(@current_colorscheme) {
      $ansi =~ s/\s+//;

      my @chars = split(//, $ansi);
      for my $char(@chars) {
        if($char ~~ @valid_hex) {
          if(($char =~ m/[0-9]/) and ($char < 10 and $char >= 0)) {
            print "\e[1mBEFORE: $char\e[0m\n" if($DEBUG);

            if($modifier =~ /^-/) {
              print $modifier;
              my ($no_iterations) = $modifier =~ s/^-//;
              $DEBUG=1;
              print "Will iterate $no_iterations times\n" if($DEBUG);
              for(0... $no_iterations-1) {
                print $char--;
                $char--
              }
            }

            # no, darker
            else {
              for(0.. $modifier-1) {
                $char++;
              }
            }
            print "\e[38;5;100m   NOW: $char\e[0m\n" if($DEBUG);
          }
        }
      }
      $ansi = sprintf("%.6s", join('', @chars));
    }
  }
  else { # use the single color
    my @tint;
    for my $n(0..15) {
      for(split(//, $modifier)) {
        if($_ ~~ @valid_hex) { # OK
        }
        else {
          print "<$_>\n";
        }
      }

      #FIXME Modify R/G/B in groups
      $modifier = sprintf("%d", hex($modifier));
      if($modifier <= 16588965) { # 16777215 / (15 colors * step)
        $modifier = $modifier + $stepping;
      }
      elsif($modifier < 150) {
        #FIXME
        $modifier = 150000;
      }
      else {
        $modifier = $modifier - $stepping;
      }

      $modifier = sprintf("%06x", $modifier);
      push(@tint, $modifier);
    }
    print "Your \e[1mnew\e[0m colorscheme:\n---\n";
    print Dumper \@tint;
    return(map { lc($_) } @tint);
  }
  return(map { lc($_) } @current_colorscheme);
}

sub set_colorscheme {
  my @new_colorscheme = @_;

  if(@new_colorscheme) {
    my $color_no = 0; # 0..15
    for my $new_color(@new_colorscheme) {
      $new_color = "$xres_prefix.color$color_no: #$new_color";

      system("echo \"$new_color\" | xrdb -merge") == 0
        or warn($!);
      $color_no++;
    }
    #FIXME - We probably want #ffffff as the default fg, but the user should
    #decide, really
    system("echo \"$xres_prefix.color7: #ebf3ff\" | xrdb -merge") == 0
      or warn($!);
  }
}

sub get_colorscheme {
  my $xres_file = shift;
  open(my $fh, '<', $xres_file) or die($!);
  my @data = <$fh>;
  close($fh);

  chomp(my @colors = grep{/$xres_prefix\.color/} @data);
  map { s/.+(?:UL|RV).+\n//; } @colors;
  map { s;(/\*.*\*/);;; } @colors;
  map { s;.+#(.+)$;$1;; } @colors; # grab hex
  #print "$_\n" for @colors;
  return(@colors);
}
