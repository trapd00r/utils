#!/usr/bin/perl
open(my $pp, 'pacman -Qq|');
chomp(my @all_pkg = <$pp>);
close($pp);

open(my $fh, 'pacman -Qqs "^perl-"|');
chomp(my @perl_pkg = <$fh>);
close($fh);

open(my $fh, 'pacman -Qe|');
chomp(my @expl_pkg = <$fh>);
close($fh);

my $percent_perl = sprintf("%.2f", scalar(@perl_pkg) / scalar(@all_pkg));
($percent_perl) = $percent_perl =~ m/0\.(.+)$/;

printf("%d installed packages (%d installed explicitly), %d installed perl modules (%d%% of all installed packages)\n",
  scalar(@all_pkg), scalar(@expl_pkg), scalar(@perl_pkg), $percent_perl
);
