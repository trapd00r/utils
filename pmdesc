use strict;
use CPANPLUS::Backend;

my $cp = CPANPLUS::Backend->new;



foreach my $mod($cp->installed()) {
  my $package = $mod->details->{Package};
  $package =~ s/\.tar.gz//;
  printf("%-35.35s %42s\n",
    $package,$mod->details->{Description});
}
