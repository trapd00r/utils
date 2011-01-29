#!/usr/bin/perl
# fbft - move files to dirs compelling to actual file-type
=zup?
                      12-a.mp3 => audio/mpeg
                      12-e.mp3 => audio/mpeg
                      12-j.mp3 => audio/mpeg
                      12-s.mp3 => audio/mpeg
                         a.out => application/x-executable
                       .bashrc => text/plain
                     bubble.pl => text/plain
                     cobalt.pl => text/plain
                  fileident.pl => text/plain
                  filemagic.pl => text/x-perl
                   .fonts.conf => application/xml
                        foobar => text/plain
                         foo.c => text/x-c
                        foo.sh => text/x-shellscript
                    .gtkrc-2.0 => text/plain
                       menu.pl => text/plain
                   menu.pl.tar => application/x-tar
                menu.pl.tar.gz => application/x-gzip
                      menu.png => image/png
                       .muttrc => text/plain
                   .procmailrc => text/plain
                  .ratpoisonrc => text/x-c++; charset=us-ascii
                  .rtorrent.rc => text/plain
                       .sbclrc => text/plain
                     .screenrc => text/plain
                .screenrc-dvdc => text/plain
                    .stumpwmrc => text/x-lisp
                        .toprc => text/plain
                      .urlview => text/plain
                 .vimperatorrc => text/plain
                        .vimrc => text/plain
                      .xinitrc => text/plain
                   .Xresources => text/x-c
0 files were skipped.
=cut

use strict;
use File::LibMagic;
use File::Copy;
use File::Path qw(make_path);
use File::Basename;
use Getopt::Long;
use Data::Dumper;
use Carp;
use Cwd 'abs_path';

my $magic = File::LibMagic->new;

our($opt_symlink,$opt_copy,$opt_move);
GetOptions(
  'symlink|ln'  => \$opt_symlink,
  'copy|cp'     => \$opt_copy,
  'move|mv'     => \$opt_move,
);
my @files = @ARGV or yell("I need files!") and die;

checkft(@files);

sub checkft {
  my @files = @_;
  my $unwanted = 0;

  for my $file(@files) {
    my $ft = $magic->checktype_filename($file);
    $ft =~ s/([a-z\/-]+);.+/$1/;

    if($ft eq 'appliaction/x-directory') {
      $unwanted++;
      next;
    }

    if(!-d $ft) {
      if(!$opt_symlink and !$opt_copy and !$opt_move) {
        print "make_path($ft)\n";
        next;
      }
      # if the mimetype does not exist as a possibly arbitary level of subdirs,
      # We'll have to create it (mostly ./foo/bar)
      make_path($ft);
    }
    if($opt_symlink) {
      symlink(abs_path($file), "$ft/$file") or die $!;
      print "symlink($file, $ft/$file)\n";
    }
    elsif($opt_move) {
      move($file, $ft);
      print "move($file, $ft)\n";
    }
    elsif($opt_copy) {
      copy($file, $ft) or die $!;
      print "copy($file, $ft)\n";
    }
  }
}

sub yell {
  my $msg = shift;
  print "\033[1m$msg\033[0m\n";
}
