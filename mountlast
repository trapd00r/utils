use strict;

my $mount_point = shift // '/mnt/tmp';

open(my $dmesg, '-|', 'dmesg') or die($!);
for(reverse(<$dmesg>)) {
  if(/^sd .+ \[(sd.+)\]/) {
    system('mount', "/dev/$1", $mount_point);
    last;
  }
}
