#!/bin/zsh
# vim: ft=zsh smc&:
setopt -L nonomatch extendedglob
f="${@:-crpd}"
du -h (#i)/mnt/porn{1/{.new,_Trans,javdl},2/{jav,idol,tmp,.new},[35]/{.new,tmp}}/*${f}* 2>/dev/null \
  | sort -t \/ -k4 -g \
  | perl -MFile::LsColor=ls_color_internal -MFile::Basename -ne \
'($s,$f) = split/\t/, $_;if($s eq "4.0K") {
  $s = "\e[38;5;30m $s\e[m";
}
elsif($s =~ /M$/) {
  $s = "\e[38;5;106m $s\e[m";
}
elsif($s =~ m/G$/) {
  $s = " \e[38;5;208m$s\e[m";
}
($base, $dir) = (basename($f), "\e[38;5;30m" . dirname($f) . "/\e[m ");
printf "% 5s %s\n",$s, $dir . ls_color_internal($base)'
