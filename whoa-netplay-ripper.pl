#!/usr/bin/perl
# vim: ft=perl:fdm=marker:fmr=#<,#>:fen:et:sw=2:
# abstract: download all netplays from whoa.nu
use strict;
use warnings FATAL => 'all';
use vars     qw($VERSION);
use autodie  qw(:all);

use utf8;
use open qw(:std :utf8);

my $APP  = 'whoa-netplay-ripper';
$VERSION = '0.001';

use Data::Dumper;

{
  package Data::Dumper;
  no strict 'vars';
  $Terse = $Indent = $Useqq = $Deparse = $Sortkeys = 1;
  $Quotekeys = 0;
}

use Mojo::UserAgent;

my $ua = Mojo::UserAgent->new->max_redirects(3);

$|++;
my $save_urls_to_file = "$ENV{HOME}/netplays.txt";
open(my $fh, '>>', $save_urls_to_file) or die $!;

my $netplay_main_url = 'http://blog.whoa.nu/netplay-arkivet/';
my @netplays;
for my $href(@{ $ua->get($netplay_main_url)->result->dom->find('a')->map(attr => 'href')->to_array }) {
	if(defined $href  and $href !~ m{^[.]{2}[/]}) {
		push(@netplays, $href);
	}
  else {
    next unless defined $href;
    $href =~ s{^[.]{2}[/]}{http://blog.whoa.nu/};
    grab_dl_link($href);
  }
}

sub grab_dl_link {
  my $netplay_url = shift;
  my $downloader = Mojo::UserAgent->new;
  for my $u($downloader->get($netplay_url)->result->dom->find('a')->map(attr => 'href')) {
    for my $vafan(@{$u}) {
      if(defined $vafan and $vafan =~ m{[.]zip}i) {
        print STDOUT "$vafan\n";
        print $fh "$vafan\n";
      }
    }
  }
}

# eftersom inga fler updates kommer ske på whoa så kan vi lika gärna lägga
# extracted urls här.

__DATA__
http://audio.whoa.nu/whoabattlearkivet/whoa_crewbattle_2004.zip
http://audio.whoa.nu/whoabattlearkivet/whoa_mama_2008.zip
http://audio.whoa.nu/whoabattlearkivet/whoa_tag_team_2006.zip
http://media.onelifepublishing.com/download/on-ree-ep-2011.zip
http://netplay.whoa.nu/academics-the_journal_vol_2-whoa.nu.zip
http://netplay.whoa.nu/acke-javligt_akta_mixtape-whoa.nu.zip
http://netplay.whoa.nu/adoo-goteborg_mixtape_2010-whoa.nu.zip
http://netplay.whoa.nu/alex-j-ljudet_fran_orten-whoa.nu.zip
http://netplay.whoa.nu/allyawan-blu_duk_tales_vol_2-whoa.nu.zip
http://netplay.whoa.nu/allyawan-blu_duk_tales_vol_3-whoa.nu.zip
http://netplay.whoa.nu/almost_good-det_tappade_arkivet_mixtape-whoa.nu.zip
http://netplay.whoa.nu/almost_good-varghunger-whoa.nu.zip
http://netplay.whoa.nu/anxious-long_live_the_short_lived-whoa.nu.zip
http://netplay.whoa.nu/ariise-new_europe-the_mixtape-whoa.nu.zip
http://netplay.whoa.nu/ays_n_beez-escapades-whoa.nu.zip
http://netplay.whoa.nu/bildsprak_den_tyngre_och_nevahmind-mina_bilder_ep-whoa.nu.zip
http://netplay.whoa.nu/bjarne_b_presenterar_10-arsjubileum_like_whoa-whoa.nu.zip
http://netplay.whoa.nu/budji-eldsjalar_och_bananskal-whoa.nu.zip
http://netplay.whoa.nu/carlito-guldburen-whoa.nu.zip
http://netplay.whoa.nu/chipchoppin-fuck_your_mixtape_mixtape_vol_4-whoa.nu.zip
http://netplay.whoa.nu/contrahesive-reflection_is_relative-whoa.zip
http://netplay.whoa.nu/critical-critical_minded-whoa.nu.zip
http://netplay.whoa.nu/critical-resejournalen-whoa.nu.zip
http://netplay.whoa.nu/crome-devil_wears_newera_mixtape-whoa.nu.zip
http://netplay.whoa.nu/daltone-feat_daltone-whoa.nu.zip
http://netplay.whoa.nu/daltone-sa_ni_vet_remixed-whoa.nu.zip
http://netplay.whoa.nu/dc-fran_grimsta-whoa.nu.zip
http://netplay.whoa.nu/dc_grimsta-min_melodi-whoa.nu.zip
http://netplay.whoa.nu/denapa-bakom_spakarna_mixtape-whoa.nu.zip
http://netplay.whoa.nu/de_omutbara-atomvinter-whoa.nu.zip
http://netplay.whoa.nu/de_omutbara-dodsskvadronen-whoa.nu.zip
http://netplay.whoa.nu/diggi_dave-pa_vag_hem_mixtape-whoa.nu.zip
http://netplay.whoa.nu/dj_akilles-2008-whoa.nu.zip
http://netplay.whoa.nu/eldhee-1_love-whoa.nu.zip
http://netplay.whoa.nu/ellda-hybris-whoa.nu.zip
http://netplay.whoa.nu/format-full_igen_ep-whoa.nu.zip
http://netplay.whoa.nu/format-nazipolis-whoa.nu.zip
http://netplay.whoa.nu/frisprakarn-whoa_netplay-whoa.nu.zip
http://netplay.whoa.nu/futuretro-when_seasons_change-whoa.nu.zip
http://netplay.whoa.nu/fyra_och_ribbs-frackis_skiva-whoa.nu.zip
http://netplay.whoa.nu/goon4s-the_goontape-whoa.nu.zip
http://netplay.whoa.nu/gubb-psalm_23-whoa.nu.zip
http://netplay.whoa.nu/henry_bowers-the_tv_od_lp-whoa.nu.zip
http://netplay.whoa.nu/houman_sebghati-hembrant_3-whoa.nu.zip
http://netplay.whoa.nu/icetail-best_of_the_instrumentals-whoa.nu.zip
http://netplay.whoa.nu/indianen-dimholjet_vol_2-whoa.nu.zip
http://netplay.whoa.nu/industrin-perez_netplay-whoa.nu.zip
http://netplay.whoa.nu/iron_african-my_own_little_war-whoa.nu.zip
http://netplay.whoa.nu/jaqe-232-whoa.nu.zip
http://netplay.whoa.nu/jesus_malverde_black_ghost-blod_pa_mikrofonen-whoa.nu.zip
http://netplay.whoa.nu/jimmy_pistol-pistoler_och_rosor_ep-whoa.nu.zip
http://netplay.whoa.nu/kap_och_drrock-420-whoa.nu.zip
http://netplay.whoa.nu/kryptonite_och_spakur-dubbel_dos-whoa.nu.zip
http://netplay.whoa.nu/k_sluggah_och_kg_boom-antivirus-whoa.nu.zip
http://netplay.whoa.nu/labyrint-2009_mixtape-whoa.nu.zip
http://netplay.whoa.nu/lagbudgetfunk-lagbudgetfunk_del_2-whoa.nu.zip
http://netplay.whoa.nu/lilerik-digga_min_skit_ep-whoa.nu.zip
http://netplay.whoa.nu/lilerik-tid-whoa.nu.zip
http://netplay.whoa.nu/majistern-visionar_ep-whoa.nu.zip
http://netplay.whoa.nu/maqs-anda_sen_barnsben_ep-whoa.nu.zip
http://netplay.whoa.nu/maqs-mangfald-whoa.nu.zip
http://netplay.whoa.nu/maqs-stjarnfall-whoa.nu.zip
http://netplay.whoa.nu/marc_swing-global_grind_vol_1-whoa.nu.zip
http://netplay.whoa.nu/marke-det_gar_som_det_gar-whoa.zip
http://netplay.whoa.nu/masse-gott_och_blandat_1-whoa.zip
http://netplay.whoa.nu/masse-gott_och_blandat_2-whoa.zip
http://netplay.whoa.nu/meta_four-iatistb-whoa.nu.zip
http://netplay.whoa.nu/mfs_that_hustla-sonder_mixtape-whoa.nu.zip
http://netplay.whoa.nu/m.i.n.d-kapitel_2-whoa.nu.zip
http://netplay.whoa.nu/mofeta_och_jerre-vad_dom_an_sager_ep-whoa.nu.zip
http://netplay.whoa.nu/mohammed_ali-processen-whoa.nu.zip
http://netplay.whoa.nu/mufakka-a_blast_from_the_past-whoa.nu.zip
http://netplay.whoa.nu/narkimic_och_genius-enis-jag_och_min_dj-whoa.nu.zip
http://netplay.whoa.nu/narkimic__phunk2-gar_ut_till-whoa.nu.zip
http://netplay.whoa.nu/nody_and_phyro-practice_made_perfect-whoa.nu.zip
http://netplay.whoa.nu/nody_and_phyro-the_footprint-whoa.nu.zip
http://netplay.whoa.nu/noname-en_del_av_allt-whoa.nu.zip
http://netplay.whoa.nu/noname-lugnet_fore_normen-whoa.nu.zip
http://netplay.whoa.nu/obnoxiuz-mellan_gott_och_ont-whoa.nu.zip
http://netplay.whoa.nu/oliver_def_och_bjarne_b-stockholm_jumanji_mixtape-whoa.nu.zip
http://netplay.whoa.nu/olsepp_och_den_som_e_den-elefantbajs-whoa.nu.zip
http://netplay.whoa.nu/pap-en_javligt_bra_anledning_till_att_leva-whoa.nu.zip
http://netplay.whoa.nu/parham-fotspar_mixtape-whoa.nu.zip
http://netplay.whoa.nu/pase-pase_your_self_vol_1-whoa.nu.zip
http://netplay.whoa.nu/pato_pooh-the_i_work_hard_chronicles-whoa.nu.zip
http://netplay.whoa.nu/popularmusik-gomorron_sverige-whoa.nu.zip
http://netplay.whoa.nu/progress_evolution-the_light_above-whoa.nu.zip
http://netplay.whoa.nu/prop_dylan-boombox_of_lost_and_found-whoa.nu.zip
http://netplay.whoa.nu/rebell-morkret-whoa.nu.zip
http://netplay.whoa.nu/rebell-tankar_under_tiden-whoa.nu.zip
http://netplay.whoa.nu/ri-fa-at_the_movies_vol_4.zip
http://netplay.whoa.nu/ri-fa-det_femte_elementet_addendum-whoa.nu.zip
http://netplay.whoa.nu/sabotage-har_och_nu-whoa.nu.zip
http://netplay.whoa.nu/sabotage_vs_nevahmind-dubbelmord-whoa.nu.zip
http://netplay.whoa.nu/shazaam_och_proclaimer-forgatmigej-whoa.nu.zip
http://netplay.whoa.nu/s_holmberg-nu_ska_vi_bli-2013.zip
http://netplay.whoa.nu/sircuz-ar_du_nara_elden_for_lange_slutar_du_kanna_den-whoa.nu.zip
http://netplay.whoa.nu/skane-alltid-oppet-whoa.nu.zip
http://netplay.whoa.nu/skrytmans-moment_22-whoa.nu.zip
http://netplay.whoa.nu/smojo-smojosolo-whoa.nu.zip
http://netplay.whoa.nu/spakur_och_henry_bowers-tag_oss_till_er-ledare-whoa.nu.zip
http://netplay.whoa.nu/staden-boombox_historier_volym_1-whoa.nu.zip
http://netplay.whoa.nu/stockholmssyndromet-underhundar_ep-whoa.nu.zip
http://netplay.whoa.nu/stor-nya_skolans_ledare-whoa.nu.zip
http://netplay.whoa.nu/sven_holmberg-apollo_11-whoa.nu.zip
http://netplay.whoa.nu/system1-ett_halvt_steg_ur_trasket-whoa.nu.zip
http://netplay.whoa.nu/the_basement_mixtape_vol_2-whoa.nu.zip
http://netplay.whoa.nu/tinitus_och_ted-det_tredje_konet-whoa.nu.zip
http://netplay.whoa.nu/trainspotters-dirty_north-whoa.nu.zip
http://netplay.whoa.nu/tredje_linjen-levande-whoa.nu.zip
http://netplay.whoa.nu/trofast-wanna_feel_your_love_ep-whoa.nu.zip
http://netplay.whoa.nu/tunggung-baxade_beats_vol_2-whoa.nu.zip
http://netplay.whoa.nu/wyatt_yurp-the_wyatt_yurp_and_pat_swayz_ep-whoa.nu.zip
http://netplay.whoa.nu/xavier-x_marks_the_spot-whoa.nu.zip
http://www35.zippyshare.com/v/9675178/file.html
http://www.lassefabel.se/lassefabel.zip
http://www.randomsidewalk.com/downloads/Balkan_Brigaden_-_Morda_Dom_Vol_2.zip
http://www.skankmassive.com/format/format_barn_av_en_forlorad_tid_2009.zip
http://www.teamgalagowear.com/downloads/TGR-Mixtape-Versioner.zip
http://www.toffer.se/Diggi_Dave_-_Sessions_&_Shiznix_Netplay.zip
http://www.toffer.se/Toffer_-_Hur_Gar_Det_Med_Musiken_Mixtape.zip
