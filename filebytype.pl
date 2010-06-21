#!/usr/bin/perl
# fbft - move files to fts compelling to actual file-type
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

my @files = @ARGV or yell("I need files!") and die;
my $magic = File::LibMagic->new;

my $unwanted = 0;
for my $file(@files) {
  my $ft = $magic->checktype_filename($file);
  $ft =~ s/([a-z\/]+);.+/$1/;

  if($ft eq 'application/x-directory') {
    $unwanted++;
    next;
  }

  #if($ft =~ /^a ([\/[a-zA-z_-]+)/) {
  #  $ft =~ s/.+([\/]+)(\S+).+/$2/g;
  #}
  ##$ft =~ s/^(\w+)\s+(\w+).+$/$1\/$2/g;
  #$ft =~ s/^(\S+)\s+(\S+).+$/$1\/$2/g;
  #$ft =~ s/\s+/_/g;
  #if($ft =~ /^directory/) {
  #  $unwanted++;
  #  next;
  #}
  if(!-d $ft) {
    make_path($ft) or die;
  }
  move($file, $ft);
  printf("%30s => %s\n", $file, $ft);

}
print "$unwanted files were skipped.\n";

sub yell {
  my $msg = shift;
  print "\033[1m$msg\033[0m\n";
}
