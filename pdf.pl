#!/usr/bin/perl 
# pdf

use strict;

use Filesys::DiskFree;

my $df = Filesys::DiskFree->new;
my @disks = glob('/mnt/*');
push(@disks, '/');

my (@total, @free, @used);

printf("\033[31;1m%11s %11s %12s %9s\033[0m\n",
      'MOUNTPOINT', 'TOTAL', 'WASTED', 'FREE');
foreach my $drive(@disks) {
  $df->df();
  printf("%-13s | %6.2f GB | %6.2f GB | %6.2f GB\n",
        $drive, &btogb($df->total($drive)), &btogb($df->used($drive)),
        &btogb($df->avail($drive)));

  push(@total, $df->total($drive));
  push(@free,  $df->avail($drive));
  push(@used,  $df->used($drive));
}

printf '-' x 50;
my $c  = "\033[34;1m";
my $c0 = "\033[0m"; 
printf("$c\nSUMMARY$c0\n FREE: %-5.2f  GB\n USED: %.2f GB\nTOTAL: %.2f GB\n",
       &calculate(@free), &calculate(@used), &calculate(@total));

sub calculate {
  my @total = @_;
  my $sum;
  foreach my $total(@total) {
    $sum += $total;
  }
  return &btogb($sum);
}

sub btogb {
  my $foo = shift;
  return $foo/1024/1024/1024;
}
