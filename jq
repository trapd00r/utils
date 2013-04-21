#!/bin/zsh
# vim: ft=zsh smc&:
setopt -L nonomatch extendedglob
f="${@:-crpd}"
du -h (#i)/porn{8/{,jav2},7/{in,done,jav2},2/{,+done,+in,jav/new,jav,idol,.new}}/*${f}* 2>/dev/null \
  | sort  -bfrdk 2  \
  | perl -MFile::LsColor=ls_color_internal -MFile::Basename -ne \
'($s,$f) = split/\t/, $_;
$f =~ s{/+}{/}g;
$offset = 8 - length($s);
if($s eq "4.0K") {
  $s = "\e[38;5;030m$s\e[m";
}
elsif($s =~ s/K$//) {
  $s = "\b\b\b\e[38;5;196;1m!! \e[38;5;124;3m$s\e[38;5;160;1mK\e[m";
}
elsif($s =~ s/M$//) {
  $s = "\e[38;5;106;3m$s\e[1mM\e[m";
}
elsif($s =~ s/G$//) {
  $s = "\e[38;5;208;1m$s\e[3mG\e[m";
}
$s =~ s/^/ / while --$offset;

($base, $dir) = (basename($f), "\e[38;5;030;1;3m" . sprintf("% 11s", dirname($f)) . "\e[m ");
printf "%s %s\n",$s, $dir . ls_color_internal($base)'
