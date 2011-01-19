#!/usr/bin/perl
package Net::Google::TLD;

use vars qw($VERSION);
$VERSION = '0.001';

BEGIN {
  require Exporter;
  our @ISA = 'Exporter';
  our @EXPORT_OK = qw(get_url_by_tld);
}

use strict;
#use Data::Dumper;
#
#{
#  package Data::Dumper;
#  no strict 'vars';
#  $Terse = $Indent = $Useqq = $Deparse = $Sortkeys = 1;
#  $Quotekeys = 0;
#}

my $google = {
  ad => {
    url => "google.ad"
  },
  ae => {
    url => "google.ae"
  },
  af => {
    url => "google.com.af"
  },
  ag => {
    url => "google.com.ag"
  },
  ai => {
    url => "google.com.ai"
  },
  am => {
    url => "google.am"
  },
  ao => {
    url => "google.co.ao"
  },
  ar => {
    url => "google.com.ar"
  },
  as => {
    url => "google.as"
  },
  at => {
    url => "google.at"
  },
  au => {
    url => "google.com.au"
  },
  az => {
    url => "google.az"
  },
  ba => {
    url => "google.ba"
  },
  bd => {
    url => "google.com.bd"
  },
  be => {
    url => "google.be"
  },
  bf => {
    url => "google.bf"
  },
  bg => {
    url => "google.bg"
  },
  bh => {
    url => "google.com.bh"
  },
  bi => {
    url => "google.bi"
  },
  bj => {
    url => "google.bj"
  },
  bn => {
    url => "google.com.bn"
  },
  bo => {
    url => "google.com.bo"
  },
  br => {
    url => "google.com.br"
  },
  bs => {
    url => "google.bs"
  },
  bw => {
    url => "google.co.bw"
  },
  by => {
    url => "google.by"
  },
  bz => {
    url => "google.com.bz"
  },
  ca => {
    url => "google.ca"
  },
  cat => {
    url => "google.cat"
  },
  cd => {
    url => "google.cd"
  },
  cf => {
    url => "google.cf"
  },
  cg => {
    url => "google.cg"
  },
  ch => {
    url => "google.ch"
  },
  ci => {
    url => "google.ci"
  },
  ck => {
    url => "google.co.ck"
  },
  cl => {
    url => "google.cl"
  },
  cm => {
    url => "google.cm"
  },
  cn => {
    url => "google.cn"
  },
  co => {
    url => "google.com.co"
  },
  com => {
    url => "google.com"
  },
  cr => {
    url => "google.co.cr"
  },
  cu => {
    url => "google.com.cu"
  },
  cz => {
    url => "google.cz"
  },
  de => {
    url => "google.de"
  },
  dj => {
    url => "google.dj"
  },
  dk => {
    url => "google.dk"
  },
  dm => {
    url => "google.dm"
  },
  do => {
    url => "google.com.do"
  },
  dz => {
    url => "google.dz"
  },
  ec => {
    url => "google.com.ec"
  },
  ee => {
    url => "google.ee"
  },
  eg => {
    url => "google.com.eg"
  },
  es => {
    url => "google.es"
  },
  et => {
    url => "google.com.et"
  },
  fi => {
    url => "google.fi"
  },
  fj => {
    url => "google.com.fj"
  },
  fm => {
    url => "google.fm"
  },
  fr => {
    url => "google.fr"
  },
  ga => {
    url => "google.ga"
  },
  ge => {
    url => "google.ge"
  },
  gg => {
    url => "google.gg"
  },
  gh => {
    url => "google.com.gh"
  },
  gi => {
    url => "google.com.gi"
  },
  gl => {
    url => "google.gl"
  },
  gm => {
    url => "google.gm"
  },
  gp => {
    url => "google.gp"
  },
  gr => {
    url => "google.gr"
  },
  gt => {
    url => "google.com.gt"
  },
  gy => {
    url => "google.gy"
  },
  hk => {
    url => "google.com.hk"
  },
  hn => {
    url => "google.hn"
  },
  hr => {
    url => "google.hr"
  },
  ht => {
    url => "google.ht"
  },
  hu => {
    url => "google.hu"
  },
  id => {
    url => "google.co.id"
  },
  ie => {
    url => "google.ie"
  },
  il => {
    url => "google.co.il"
  },
  im => {
    url => "google.im"
  },
  in => {
    url => "google.co.in"
  },
  is => {
    url => "google.is"
  },
  it => {
    url => "google.it"
  },
  je => {
    url => "google.je"
  },
  jm => {
    url => "google.com.jm"
  },
  jo => {
    url => "google.jo"
  },
  jp => {
    url => "google.co.jp"
  },
  ke => {
    url => "google.co.ke"
  },
  kg => {
    url => "google.kg"
  },
  kh => {
    url => "google.com.kh"
  },
  ki => {
    url => "google.ki"
  },
  kr => {
    url => "google.co.kr"
  },
  kw => {
    url => "google.com.kw"
  },
  kz => {
    url => "google.kz"
  },
  la => {
    url => "google.la"
  },
  lb => {
    url => "google.com.lb"
  },
  li => {
    url => "google.li"
  },
  lk => {
    url => "google.lk"
  },
  ls => {
    url => "google.co.ls"
  },
  lt => {
    url => "google.lt"
  },
  lu => {
    url => "google.lu"
  },
  lv => {
    url => "google.lv"
  },
  ly => {
    url => "google.com.ly"
  },
  ma => {
    url => "google.co.ma"
  },
  md => {
    url => "google.md"
  },
  me => {
    url => "google.me"
  },
  mg => {
    url => "google.mg"
  },
  mk => {
    url => "google.mk"
  },
  ml => {
    url => "google.ml"
  },
  mn => {
    url => "google.mn"
  },
  ms => {
    url => "google.ms"
  },
  mt => {
    url => "google.com.mt"
  },
  mu => {
    url => "google.mu"
  },
  mv => {
    url => "google.mv"
  },
  mw => {
    url => "google.mw"
  },
  mx => {
    url => "google.com.mx"
  },
  my => {
    url => "google.com.my"
  },
  mz => {
    url => "google.co.mz"
  },
  na => {
    url => "google.com.na"
  },
  ne => {
    url => "google.ne"
  },
  nf => {
    url => "google.com.nf"
  },
  ng => {
    url => "google.com.ng"
  },
  ni => {
    url => "google.com.ni"
  },
  nl => {
    url => "google.nl"
  },
  no => {
    url => "google.no"
  },
  np => {
    url => "google.com.np"
  },
  nr => {
    url => "google.nr"
  },
  nu => {
    url => "google.nu"
  },
  nz => {
    url => "google.co.nz"
  },
  om => {
    url => "google.com.om"
  },
  pa => {
    url => "google.com.pa"
  },
  pe => {
    url => "google.com.pe"
  },
  ph => {
    url => "google.com.ph"
  },
  pk => {
    url => "google.com.pk"
  },
  pl => {
    url => "google.pl"
  },
  pn => {
    url => "google.pn"
  },
  pr => {
    url => "google.com.pr"
  },
  ps => {
    url => "google.ps"
  },
  pt => {
    url => "google.pt"
  },
  py => {
    url => "google.com.py"
  },
  qa => {
    url => "google.com.qa"
  },
  ro => {
    url => "google.ro"
  },
  rs => {
    url => "google.rs"
  },
  ru => {
    url => "google.ru"
  },
  rw => {
    url => "google.rw"
  },
  sa => {
    url => "google.com.sa"
  },
  sb => {
    url => "google.com.sb"
  },
  sc => {
    url => "google.sc"
  },
  se => {
    url => "google.se"
  },
  sg => {
    url => "google.com.sg"
  },
  sh => {
    url => "google.sh"
  },
  si => {
    url => "google.si"
  },
  sk => {
    url => "google.sk"
  },
  sl => {
    url => "google.com.sl"
  },
  sm => {
    url => "google.sm"
  },
  sn => {
    url => "google.sn"
  },
  st => {
    url => "google.st"
  },
  sv => {
    url => "google.com.sv"
  },
  td => {
    url => "google.td"
  },
  tg => {
    url => "google.tg"
  },
  th => {
    url => "google.co.th"
  },
  tj => {
    url => "google.com.tj"
  },
  tk => {
    url => "google.tk"
  },
  tl => {
    url => "google.tl"
  },
  tm => {
    url => "google.tm"
  },
  to => {
    url => "google.to"
  },
  tr => {
    url => "google.com.tr"
  },
  tt => {
    url => "google.tt"
  },
  tw => {
    url => "google.com.tw"
  },
  tz => {
    url => "google.co.tz"
  },
  ua => {
    url => "google.com.ua"
  },
  ug => {
    url => "google.co.ug"
  },
  uk => {
    url => "google.co.uk"
  },
  uy => {
    url => "google.com.uy"
  },
  uz => {
    url => "google.co.uz"
  },
  vc => {
    url => "google.com.vc"
  },
  ve => {
    url => "google.co.ve"
  },
  vg => {
    url => "google.vg"
  },
  vi => {
    url => "google.co.vi"
  },
  vn => {
    url => "google.com.vn"
  },
  vu => {
    url => "google.vu"
  },
  ws => {
    url => "google.ws"
  },
  za => {
    url => "google.co.za"
  },
  zm => {
    url => "google.co.zm"
  },
  zw => {
    url => "google.co.zw"
  }
};

sub get_url_by_tld {
  my @d = @_;

  my @tld;
  if(ref($d[0]) eq 'ARRAY') {
    push(@tld, @{$d[0]});
  }
  else {
    push(@tld, @d);
  }

  map { $_ = $google->{$_}->{url} } @tld;
  return @tld;
}

1;

__END__

=pod

=head1 NAME

Net::Google::TLD - Get Google URI from its TLD

=head1 SYNOPSIS

  use Net::Google:TLD qw(get_url_by_tld);

  my $url = get_url_by_tld('se'); # google.se

=head1 EXPORTS

None by default.

=head1 FUNCTIONS 

=head2 get_url_by_tld()

Parameters: $tld | \@tlds

Returns:    @tlds

=head1 AUTHOR

  Magnus Woldrich
  CPAN ID: WOLDRICH
  magnus@trapd00r.se
  http://japh.se

=head1 REPORTING BUGS

Report bugs on rt.cpan.org or to magnus@trapd00r.se

=head1 COPYRIGHT

Copyright (C) 2011 Magnus Woldrich. All right reserved.
This program is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

=cut
