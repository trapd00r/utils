#!/usr/bin/perl
# fbft - move files to dirs compelling to actual file-type
=move shit based on filetype;
:set paste
               a.out => ELF/64
           bubble.pl => ASCII/tex
           cobalt.pl => ASCII/tex
        fileident.pl => ASCII/tex
        filemagic.pl => perl
              foobar => ASCII/tex
               foo.c => ASCII/C
              foo.sh => POSIX/shell
                lala => ELF/64
             menu.pl => ASCII/tex
         menu.pl.tar => POSIX/tar
      menu.pl.tar.gz => gzip/compressed
            menu.png => PNG/image
        movefiles.pl => ASCII/tex
                 rpd => perl
14 files were skipped.
=cut

use strict;
use File::LibMagic ':easy';
use File::Copy;
use File::Path qw(make_path);
use File::Basename;

my @files = @ARGV or yell("I need files!") and die;

my $unwanted = 0;
for my $file(@files) {
  my $dir = MagicFile($file);
  if($dir =~ /^a ([\/[a-zA-z_-]+)/) {
    $dir =~ s/.+([\/]+)(\S+).+/$2/g;
  }
  #$dir =~ s/^(\w+)\s+(\w+).+$/$1\/$2/g;
  $dir =~ s/^(\S+)\s+(\S+).+$/$1\/$2/g;
  $dir =~ s/\s+/_/g;
  if($dir =~ /^directory/) {
    $unwanted++;
    next;
  }
  if(!-d $dir) {
    make_path($dir);
    print "make_path($dir)\n";
  }
  copy($file, $dir);
  printf("%20s => %s\n", $file, $dir);

}
print "$unwanted files were skipped.\n";

sub yell {
  my $msg = shift;
  print "\033[1m$msg\033[0m\n";
}
