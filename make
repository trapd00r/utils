#!/usr/bin/perl
use vars qw($VERSION);
$VERSION = '0.02';

use strict;
use Cwd;
use File::Copy;
use File::Path qw(make_path);
use Term::ExtendedColor ':attributes';
use File::LsColor qw(ls_color);


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
    my ($project) = cwd() =~ m|.*/(.+)$|m;
    $project =~ s/::/-/g;


    if(-f 'Makefile') {
      system("/usr/bin/make clean");
    }
    system('perl Makefile.PL');
    system("/usr/bin/make", 'dist');
    for(glob('*.tar.gz')) {
      print "\n>> " . fg('orange3', fg('bold', $_)) . " <<\n\n";
      system("ssh -p $remote_port $remote_user\@$remote_host 'mkdir -p http/japh.se/perl/devel/$project'")
        == 0 or die($!);
      $remote_dest .= "/$project";

      printf("\n\nSending %s to %s\n\n",
        ls_color($_), fg('green14', bold($remote_dest)),
      );

      scp($remote_host, $remote_port, $remote_dest, $_);
      print "\n\nContent in @{[fg('blue4', bold($remote_dest))]}:\n\n";

      system("ssh -p $remote_port $remote_user\@$remote_host '/bin/ls -1 http/japh.se/perl/devel/$project'");

      print "\n\n";
      print "http://perl.japh.se/devel/$project\n";
      make_path("$ENV{HOME}/devel/Distributions");
      move($_, "$ENV{HOME}/devel/Distributions")  or die("move $_: $!");
    }
  }
  elsif($_[0] eq 'test') {
    $ENV{RELEASE} = 1;
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
