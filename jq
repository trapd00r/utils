#!/bin/zsh
# vim: ft=zsh smc&:
setopt -L nonomatch extendedglob
f="${@:-crpd}"
du -h (#i)/mnt/porn{7/{in,done,jav2},2/{+done,+in,jav/new,jav,idol,tmp,.new},[35]/{.new,tmp}}/*${f}* 2>/dev/null \
  | sort  -k 2  \
  | perl -MFile::LsColor=ls_color_internal -MFile::Basename -ne \
'($s,$f) = split/\t/, $_;
$offset = 8 - length($s);
if($s eq "4.0K") {
  $s = "\e[38;5;030m$s\e[m";
}
elsif($s =~ /M$/) {
  $s = "\e[38;5;106m$s\e[m";
}
elsif($s =~ m/G$/) {
  $s = "\e[38;5;208m$s\e[m";
}
$s =~ s/^/ / while --$offset;

($base, $dir) = (basename($f), "\e[38;5;030m" . sprintf("%.14s", dirname($f)) . "\e[m ");
printf "%s %s\n",$s, $dir . ls_color_internal($base)'
