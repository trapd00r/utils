#!/usr/bin/perl

use strict;
use Storable;
use Getopt::Long;
use Time::localtime;
use Term::ExtendedColor;

#use Data::Dumper;
#
#$Data::Dumper::Terse     = 1;
#$Data::Dumper::Indent    = 1;
#$Data::Dumper::Useqq     = 1;
#$Data::Dumper::Deparse   = 1;
#$Data::Dumper::Quotekeys = 0;
#$Data::Dumper::Sortkeys  = 1;

my $history = "$ENV{HOME}/configs/time_wasted_in_vim";

my $opt_get_stats;
GetOptions(
  'total|stats' => \$opt_get_stats,
  'h|help'      => sub { print "--total\n--help\n\n" and exit 0; },
);

my @files = @ARGV;
my @vim_args;

for my $file(@files) {
  if($file =~ m/^[ls]et /) {
    system('/usr/bin/vim', @files);
    exit;
  }
  if( (! -e $file) and ($file =~ /^-/) ) {
    push(@vim_args, $file);
    undef($file);
  }
}

if($opt_get_stats)  {
  get_statistics( @files );
  exit 0;
}

my $elapsed_time = vim();
write_struct( get_struct(), $elapsed_time, @files );

output_term( format_time($elapsed_time), join(' ', @files) );

get_statistics(@files);

sub get_statistics {
  my @f = @_;

  my $s = get_struct();

  my $counter = 0;
  if(!@f) {
    for my $file(sort{ $s->{$b} <=> $s->{$a} } keys(%{$s})) {
      my($d, $h, $m, $s) = format_time( $s->{$file} );
      output_term($d, $h, $m, $s, $file, $counter);
      $counter++;
    }
    return;
  }

  for my $file(@f) {
    my($d, $h, $m, $s) = format_time( $s->{$file} );
    output_term($d, $h, $m, $s, $file, $counter);
    $counter++;
  }
}


sub format_time {
  my $time = shift;
  my $t = localtime($time);

  my($d, $h, $m, $s) = ($t->yday, $t->hour -1, $t->min, $t->sec);

  return ($d, $h, $m, $s);
}

sub color_by_value {
  my $value = shift;

  return fg('bold', fg('grey20',  $value)) if $value < 2;
  return fg('bold', fg('yellow4', $value)) if $value < 4;
  return fg('bold', fg('yellow9', $value)) if $value < 6;
  return fg('bold', fg('orange4', $value)) if $value < 8;
  return fg('bold', fg('red1',    $value)) if $value < 10;

  return $value;
}


sub vim {
  my $time_start = time();

  system('/usr/bin/vim', '-p', @vim_args, @files);

  my $time_end   = time();
  my $time_spent = ($time_end - $time_start);

  return $time_spent;
}


sub write_struct {
  my($struct, $time, @files) = @_;
  my $struct = shift;

  croak("'$struct' is not a valid HASH ref") if ref($struct) ne 'HASH';

  for my $file(@files) {
    if( ($file =~ /^\s+$/)
        or (!$file)
        or (!defined($file))
        or $file eq ''
        or $file =~ m/^(?:[sl]et)\s+/
        or $file =~ m/^[:-]+ ?/
        or $file =~ m/^bufdo/
    ) {
      next;
    }
    #my $basename = basename($file); # NOTE ..?
    $struct->{$file} += $time;
    store($struct, $history);
  }
}

sub get_struct {
  my $struct;
  -f $history and $struct = retrieve($history);
  return $struct;
}


sub output_term {
  my($d, $h, $m, $s, $f, $counter) = @_;

  my(undef, undef, undef, $who) = caller(1);


  if($d == 0) {
    print " " x 12;
  }
  else {
    printf("%s day%s,",
      color_by_value( sprintf("% 3d", $d)),
      #fg('grey7', fg('bold', sprintf("% 3d", $d))),
      ( ($d > 1) or ($d == 0) ) ? 's' : ' ',
    );
  }

  if($h == 0) {
    print " " x 10;
  }
  else {
    printf("%s hour%s,",
      color_by_value( sprintf("% 3d", $h)),
      #fg('grey10', fg('bold', sprintf("% 3d", $h))),
      ( ($h > 1) or ($h == 0) ) ? 's' : ' ',
    );
  }

  if($m == 0) {
    print " " x 10;
  }
  else {
    printf("%s minute%s",
      #color_by_value( sprintf("% 3d", $m)),
      fg('grey14', fg('bold', sprintf("% 3d", $m))),
      ( ($m > 1) or ($m == 0) )  ? 's' : ' ',
    );
  }

  printf(" %s %s second%s",
    #color_by_value( sprintf("% 3d", $s)),
    ($m == 0) ? '    ' : 'and',
    fg('grey17', fg('bold', sprintf("% 3d", $s))),
    ( ($s > 1 ) or ($s == 0) ) ? 's' : ' ',
  );

  if($who eq __PACKAGE__ . '::get_statistics') {
    printf(" of total hacking time on %s\n", fg('bold', fg('orange2', $f)));
  }
  else {
    printf(" spent hacking on %s\n", $f);
  }

}

sub basename {
  return map { -f $_ && $_ =~ s|.+/(.+)$|$1|; $_ } @_;
}
