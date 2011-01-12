#!/usr/bin/perl
use vars qw($VERSION);
$VERSION = '0.02';

use strict;
use File::Copy;
use File::Path qw(make_path);
use Term::ExtendedColor;

my $remote_host   = '192.168.1.100';
my $remote_port   = '19216';
my $remote_user   = 'scp1';
my $remote_dest   = 'http/japh.se/perl/devel';

pass_on(@ARGV);

sub pass_on {
  if( ($_[0] eq 'rebuild') or (!@_) ) {
    my ($makefile, $make_command);
    if(-f 'Build.PL') {
      $makefile     = 'Build';
      $make_command = 'perl ./Build';
    }
    elsif(-f 'Makefile.PL') {
      $makefile     = 'Makefile';
      $make_command = '/usr/bin/make';
    }
    else {
      print "Nothing to rebuild!\n";
      exit 1;
    }

    if(-f $makefile) {
      system($make_command, 'realclean');
    }

    system("perl $makefile.PL && $make_command && $make_command test") == 0
      and system("su -c '/usr/bin/make install'");
    exit;
  }

  elsif($_[0] eq 'dist') {
    system("/usr/bin/make", 'dist');
    for(glob('*.tar.gz')) {
      print "\n>> " . fg('orange3', fg('bold', $_)) . " <<\n\n";
      scp($remote_host, $remote_port, $remote_dest, $_);
      make_path("$ENV{HOME}/devel/Distributions");
      move($_, "$ENV{HOME}/devel/Distributions")  or die("move $_: $!");
    }
  }
  elsif($_[0] eq 'test') {
    system("prove", qw(--count --timer -j 9 -f -o));
    #system("/usr/bin/make", 'test');
  }
  else {
    system("/usr/bin/make", @_);
  }
}

sub scp {
  my($host, $port, $dest, $target) = @_;
  $port or $port = 22;
  return system("scp -P $remote_port $target $remote_user\@$remote_host:$dest");
}
