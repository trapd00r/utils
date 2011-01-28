#!/usr/bin/perl
use strict;
use Parallel::ForkManager;

my @u = qw(
  http://www.youtube.com/watch?v=37OyPr6ulcw
  http://www.youtube.com/watch?v=0wtiNzci1Wc
  http://www.youtube.com/watch?v=tkJNyQfAprY
  http://www.youtube.com/watch?v=iJZYG5qwHHI
  http://www.youtube.com/watch?v=gs3lQVyZPVg
  http://www.youtube.com/watch?v=4ADh8Fs3YdU

  http://www.youtube.com/watch?v=U1C-Bwvn8jk
  http://www.youtube.com/watch?v=T2fVajpG62U
  http://www.youtube.com/watch?v=fUxZapn9Dc0
  http://www.youtube.com/watch?v=iYcqBM0KhxM
  http://www.youtube.com/watch?v=OeEhLRPenxU
  http://www.youtube.com/watch?v=8W5aSFUy-8Q
  http://www.youtube.com/watch?v=qPApRO8vGUw
  http://www.youtube.com/watch?v=VV24HYEr-wQ
  http://www.youtube.com/watch?v=WpbVvHRuTRA
  http://www.youtube.com/watch?v=J648qeb5Gko
  http://www.youtube.com/watch?v=WlgXiz8HTwg
  http://www.youtube.com/watch?v=ZAHTu7Pc5Nw
  http://www.youtube.com/watch?v=rkKndHzsYtM
  http://www.youtube.com/watch?v=yXmaBOhl_2A
  http://www.youtube.com/watch?v=xWD-TR3OHeE
  http://www.youtube.com/watch?v=iGlb7CGNbd0
  http://www.youtube.com/watch?v=90bSpkC6nWo
  http://www.youtube.com/watch?v=90bSpkC6nWo
  http://www.youtube.com/watch?v=TY3KBtxb0VM
  http://www.youtube.com/watch?v=as6HmNQ-d10
  http://www.youtube.com/watch?v=DHR3abSX8I4
  http://www.youtube.com/watch?v=PyKHR3CoPqg
  http://www.youtube.com/watch?v=d7hxEC_2c7o
  http://www.youtube.com/watch?v=w-ivLDk0FgA
  http://www.youtube.com/watch?v=vQN2jycUTGs
  http://www.youtube.com/watch?v=O1MrL3W9ZPc
  http://www.youtube.com/watch?v=56RBT21N4T4
  http://www.youtube.com/watch?v=qIJJn2TzdQM

  http://www.youtube.com/watch?v=yp4LQhEF6jM

  http://www.youtube.com/watch?v=41pWIABFFI8

  http://www.youtube.com/watch?v=doSBk3Kovu0
  http://www.youtube.com/watch?v=ITlOV13wCLc
  http://www.youtube.com/watch?v=rC0zTsYLnrQ
  http://www.youtube.com/watch?v=cLdnNbTiCns

  http://www.youtube.com/watch?v=DjVdEbJUv44
  http://www.youtube.com/watch?v=rn9c_GnbdM0

  http://www.youtube.com/watch?v=p1dXKz8vymY
  http://www.youtube.com/watch?v=nUmqh0OQPYM
  http://www.youtube.com/watch?v=Wz68EU5NCms
  http://www.youtube.com/watch?v=6HuolueEVpU
  http://www.youtube.com/watch?v=cqMYz151M2w
  http://www.youtube.com/watch?v=z5BBFCkfp_Q
  http://www.youtube.com/watch?v=174aB1joMJw
  http://www.youtube.com/watch?v=nYSzzU0KTRc
  http://www.youtube.com/watch?v=IPhvoZFSIDM
  http://www.youtube.com/watch?v=3NfhkS4MKWw

  http://www.youtube.com/watch?v=rTBjzcCtxo0
  http://www.youtube.com/watch?v=dWaMoPT3zx4
  http://www.youtube.com/watch?v=0NYBrl2pGZc
  http://www.youtube.com/watch?v=G4C6vni8zyQ
  http://www.youtube.com/watch?v=QrtYdOBmLfw
  http://www.youtube.com/watch?v=l7IB8zYOqfc
  http://www.youtube.com/watch?v=uoKhtrI9jg8
  http://www.youtube.com/watch?v=EzAxz0SXPVw
  http://www.youtube.com/watch?v=p29RRWNIQTc
  http://www.youtube.com/watch?v=xZDNd5ErHqw
  http://www.youtube.com/watch?v=fWYeu1Mup9w
  http://www.youtube.com/watch?v=MzmxI_5ih4U
  http://www.youtube.com/watch?v=xSQX0IkiwPM
  http://www.youtube.com/watch?v=GIJkpGDJqoM
  http://www.youtube.com/watch?v=Go0T6i7vo58
  http://www.youtube.com/watch?v=G7v9pUwERlE
  http://www.youtube.com/watch?v=HJaccTuDHSc
  http://www.youtube.com/watch?v=6VU29vCj-EM
  http://www.youtube.com/watch?v=XL5QnO1Ljlo
  http://www.youtube.com/watch?v=U_80-XgdIM0
  http://www.youtube.com/watch?v=w_qjOcAeqwc
  http://www.youtube.com/watch?v=wJJhpuKJGPk
  http://www.youtube.com/watch?v=eCzMQYcdjRg
  http://www.youtube.com/watch?v=6amLNIiTiNg
  http://www.youtube.com/watch?v=VfG2VnsOlAY
  http://www.youtube.com/watch?v=Dri7LgxcZQE
  http://www.youtube.com/watch?v=35AjzR1u-1w
  http://www.youtube.com/watch?v=plAC1FaZKzk
  http://www.youtube.com/watch?v=g2u83WdPtIw
  http://www.youtube.com/watch?v=7l_Qdj-0eCI
  http://www.youtube.com/watch?v=EkPGvFE0yz4
  http://www.youtube.com/watch?v=G2I4i3hDI5k
  http://www.youtube.com/watch?v=d_35VeVm9lY

  http://www.youtube.com/watch?v=N6zEFv0A4Jo

  http://www.youtube.com/watch?v=M1lYgQe739o

  http://www.youtube.com/watch?v=HTHEyI-1uHk

  http://www.youtube.com/watch?v=Et874Dh7f1g

  http://www.youtube.com/watch?v=C1E5iY6n1xk

  http://www.youtube.com/watch?v=KMRQ6mwqYo8
  http://www.youtube.com/watch?v=6XfQroGTvV0
  http://www.youtube.com/watch?v=yRtD6QuwUm4
  http://www.youtube.com/watch?v=VNYqOIbotc0
  http://www.youtube.com/watch?v=RG9Dqaq4vio
  http://www.youtube.com/watch?v=QIJ0Mlb_tDE
  http://www.youtube.com/watch?v=i38GW6QOFHA
  http://www.youtube.com/watch?v=9fttAEhDD_4

  http://www.youtube.com/watch?v=-W9V_u2ZU-A
  http://www.youtube.com/watch?v=xzTE28wiOjA

  http://www.youtube.com/watch?v=EZkm6VsDyBk
  http://www.youtube.com/watch?v=ajuXxoJJZXA
  http://www.youtube.com/watch?v=NAgUf_55GVE
  http://www.youtube.com/watch?v=iOQbjxl4LKo

  http://www.youtube.com/watch?v=NqB5m_XHyQQ
  http://www.youtube.com/watch?v=2U4MJjII3x8
  http://www.youtube.com/watch?v=UbcycIyb-uk
  http://www.youtube.com/watch?v=cnvfBI3pTHk
  http://www.youtube.com/watch?v=cucDLTuzqfk

  http://www.youtube.com/watch?v=Kt6FjsSbJ1E
  http://www.youtube.com/watch?v=8uP8BIykKls
  http://www.youtube.com/watch?v=nsWZKm-s-xY
  http://www.youtube.com/watch?v=oMaVQa8IwzU
  http://www.youtube.com/watch?v=JgLipYm0Mwk

  http://www.youtube.com/watch?v=_MKgk8n4DZA


);

my $pm = Parallel::ForkManager->new( scalar(@u) );

for my $url(@u) {
  $pm->start and next;
  exec('clive', '-q',  $url);
  $pm->finish;
}
$pm->wait_all_children;





=pod

=head1 NAME

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 OPTIONS

=head1 AUTHOR

  Magnus Woldrich
  CPAN ID: WOLDRICH
  magnus@trapd00r.se
  http://japh.se

=head1 REPORTING BUGS

Report bugs on rt.cpan.org or to magnus@trapd00r.se

=head1 COPYRIGHT

Copyright (C) 2011 Magnus Woldrich. All right reserved.
This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;


# vim: set ts=2 et sw=2:

