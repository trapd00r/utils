#!/usr/bin/perl
# dmesg.pl
use strict;

chomp(my @dmesg = `dmesg`);

my %c = (
  def    => "\033[0m",
  bold   => "\033[1m",
  italic => "\033[3m",

  blue   => "\033[38;5;29m",
  green  => "\033[38;5;148m",
  red    => "\033[38;5;196m",
  grey   => "\033[38;5;240m",
);


for(@dmesg) {
  if(/(.+: \[)(sd[a-z])(\].+)/) {
    print "$1$c{bold}$c{green}$2$c{def}$3\n";
  }
  elsif(/((?:wlan|eth))([0-9])(.+)/) {
    printf("$c{bold}$c{grey}%4s$c{blue}$2$c{def}$3\n",
      $1);
  }
  elsif(/^usb/) {
    print $_ = "\033[38;5;106m$_\033[0m", "\n";;
  }
  elsif(/^TCP/) {
    print $_ = "\033[38;5;202m$_\033[0m", "\n";
  }
  elsif(/^ACPI/) {
    print $_ = "\033[38;5;80m$_\033[0m", "\n";
  }
  elsif(/^ata[0-9+]/) {
    print $_ = "\033[38;5;99m$_\033[0m", "\n";
  }
  elsif(/^(input:)(.+)/) {
    print "\033[38;5;196m\033[1m$1\033[0m\033[38;5;202m$2\033[0m", "\n";
  }
  elsif(/^(.+): (segfault)( .+)/) {
    print "\033[38;5;160m$1\033[0m\033[1m:\033[48;5;160m$2\033[1m$3\033[0m\n";
  }
#  elsif(/(.+not.+)/) {
#    print "$c{red}$1$c{def}\n";
#  }
  else {
    print "$_\n";
  }
}
