#!/usr/bin/tclsh

#
# sl - usefully organize directories and point out interesting files
#	Invented by Tom Phelps on December 30, 2011.
#
# home site: http://www.PracticalThought.com/
#
# Copyright (c) 2011-2012  Thomas A. Phelps
# Licensed under the GNU Public License version 3 (http://www.gnu.org/licenses/).
# NO WARRANTY.
#
# 
# $Revision: 1.82 $ $Date: 2012/02/13 14:08:07 $
#

if {[package vcompare [info patchlevel] 8.5] < 0} { puts stderr "ERROR: requires Tcl 8.5"; exit 1 }


if { ![catch {set tty [exec stty -a]}] && [regexp {(\d+)\s+columns} $tty all TERMINFO(width)]} {
} elseif {[info exists env(COLUMNS)]} {set TERMINFO(width) $env(COLUMNS)
} else {set TERMINFO(width) 80}

array set TIME [list SECOND 1 MINUTE [expr 60] HOUR [expr 60*60] DAY [expr 60*60*24] MONTH [expr 60*60*24*30] YEAR [expr 60*60*24*365]]
array set TIME [list now [clock seconds]]
set TIME(epsilon) $TIME(MINUTE)	;# amount that times must differ to be considered different, due to different clocks, delays in file system and network, ...


# groups: by suffix, by exact name (modulo compression wrapper), by regexp
# This is not intended to be a complete database -- add more and reassign in your ~/.sl.tcl startup file.
# are archives like dir (and sorted together)? both labelled collections
# tosort: maybe psd/ai/TODO in dev for artist?
# group names short so when used as title also separate groups by whitespace
# conflicts: .asf audio/video, .iso data/video, .xml doc/usually data, .raw and .bin can be anything
set GROUP {
    special	{byascii} {}
    dir		{title prefix by1} {}

    build	{byascii} { Makefile GNUmakefile build.xml -build.number configure INSTALL README }
    app		{bysuffix} { -.so -.a .jar .exe .dll -core }
    dev		{} { .c .cpp .cc .m -.h  -.o .java -.class .scala .f
			.tcl .sh .py -.pyc .pl .scpt .m4 .lua
			.nib .y
			-CVS -RCS -TAGS -tags .el -.elc }
    A2		{title} { .dsk .do .po .2mg .2img .shk .sdk .sea .bsq .bxy .bny .bsc .dc }

    WWW		{} { .html .htm .shtml .php .php3 .ars }
    aux		{bysuffix} { .css .js .url .webloc robots.txt .json }

    doc		{prefix} { .txt .man .1 .3 .dox .chm .tex .bib .sty .dvi .texi .info .nfo .readme Index }
    book	{title} { .ps .pdf .djvu .epub .mobi .cbr .cbz }
    document	{title} { .indd .odt .doc .rtf .docx .ppt .pptx .xls .xlsx }
    image	{title nosfx prefix} { .jpg .jpeg .jp2 .png .gif .tiff .tif .dng .psd .xbm .xpm .pbm .pgm .ppm .ico .bmp .raw Thumbs.db }
    vector	{title} { .ai .svg .wmf .emf }
    audio	{title nosfx prefix} { .mp3 .m4a .m4b .m4p .aif .aiff .snd .flac .ogg .oga .mid .wav .wma .ra .mod }
    video	{title nosfx prefix} { .mpg .mpeg .avi .mov .wmv .mkv .mp4 .m4v .flv .f4v .asf .ram .rm .rmvb .divx .vob .iso }
    font	{title nosfx prefix} { .pfb .pfa -.afm -.pfm .ttf .ttc .dfont .otf .otc .woff -fonts.dir -fonts.list -fonts.scale -encodings.dir }

    data	{} { .xml .plist .strings .data .dat .sfv .md5 .bin }
    other	{byascii} {}
    archive	{title prefix} { .zip .tar .tgz .xz .rar .sit .sitx .cpt .dmg }

    dotfile	{} {}
    Mac		{} { -.DS_Store "-Desktop DB" "-Desktop DF" }
    ignore	{} { .bak bkup .bkup .bup tmp .tmp -old .old -obsolete ignore }
}
if {([llength $GROUP]%3) != 0} {puts stderr "GROUP: some line missing field"; exit 1}
foreach {group flags entries} $GROUP {
    set G2F($group) $flags
    foreach x $entries {
	if {"-" == [string index $x 0]} {set EQ([string range $x 1 end]) -$group
	} else {set EQ($x) $group}
    }
}
set tmp "(?i)README"
append tmp {|TODO$|notes|TOSORT}
append tmp {|Makefile$|configure$|build.xml} ;#|INSTALL
append tmp "|index.html?";	 # HTML
set EQ(NOTABLE) $tmp
array set EQ {
    WRAPPER {\.(gz|Z|bz2|uu|hqx)$}
    AUTOBKUP {(.*?)(\.~\d+\.\d+\.)?~$}
    DEV {(?i)notes|^todo|changelog}
    MANDIR {/man/man[^/]+$}  MANPAGE {^.+\.[1-9oln][^/]*$}
}

array set STYLE {
    group ";01;35;4" file "" dir ";34" special ";36" link ";35"
    notable ";7" autosearch ";36"
    recent,file ";31" recent,dir ";31"  relrec,file ";33" relrec,dir ";33"
    relsize ";36"
    warning ";1;01;31"
    OFF ";0"
}

# 0 means off, else some value (maybe useful, not necessarily 1)
# filter - data - presentation - control - ls options
array set SWITCH {
    version "v1.1.1 of February 13, 2012"  site "http://www.PracticalThought.com/"
    ignore 3  only 0
    notable 1  autosearch {\W(urgent|password|pw|live)\W}  relsize 5  relchange 10  relread 10  atime 0  vc 1
    group 1  grouptitle 1  series 5  prefix 0  shorten 10  nosfx 0  title 0  maxcol 0  summary 2
    startup "~/.sl.tcl"  expando 2  log 0
    F 1  1 0  B {~$|^#.*#$|^\.#}
}
set SWITCH(abschange) [expr $TIME(DAY)*2]
set SWITCH(TAP) [file exists "~/prj/Multivalent"]	;# experimental/aggressive


# i18n for words shown every time (but not for error messages)
foreach word {
    file files directory directories ignored
    second minute hour day month year
} { set I18N($word) $word }
foreach {key val} {
    ... '
    pre0 "  "

    type-file ""  type-directory "/"  type-link "->"  type-link-external "-->"  type-special "_"

    warn-link-broken "X"  warn-empty "0"  warn-single "1"
    warn-box "!"
    warn-link-hard-multiple "<-"
    warn-bit-setUID "u"  warn-bit-setGID "g"  warn-bit-sticky "s"  warn-world-writable "W"
    warn-not-readable-by-user "r"  warn-dir-not-searchable-by-user "x"
    warn-vc-need "^"  warn-vc-stale "v"  warn-vc-other "v"
} { set I18N($key) $val }

# mount points of external drives (that might spin down and would be slow spin up)
set MOUNTS {/Volumes}



# control
proc sl {dir files {level 0}} {
    if {[llength $files]==0} return
    global SWITCH GROUP G2F EQ STYLE LOG
    set LOG {}; array set stats {series 0 pfx 0 pfxch 0}

    set f [file normalize ~]; file stat $f home; set home(at) [string equal $f [file normalize $dir]]

    # 1. build up data record for each file
    log "*collect* [llength $files]"
    set fcnt 0; set dcnt 0; set igcnt 0; set igl {}
    set totalsize 0; set totaldir 0; set dotcnt 0
    set l {}
    foreach f $files {
	set tail [file tail $f]; if {"."==$tail || ".."==$tail} continue
	file lstat $f stat	;# sometimes we care if it's a link and other times not
	set type $stat(type); set typec ""
	set size 0; set mtime $stat(mtime); set atime $stat(atime)
	lassign [groupbyname $dir $tail $type] group iglevel ts t sfx

	set warning ""
	if {[regexp $EQ(AUTOBKUP) $tail all base] && [file join $dir $base] ni $files} {append warning [l10n warn-link-broken]	;# abandoned backup (emacs~, CVS.~<ver>.~)
	} elseif {$SWITCH(ignore) >= $iglevel} {
	    if {$iglevel >= 3} {lappend igl $tail}
	    if {$iglevel==2} {incr dotcnt} else {incr igcnt}
	    continue
	}

	set style ""; set pre "  "; set post ""

	# a. general
	if {($stat(mode) & 04000) != 0} {append warning [l10n warn-bit-setUID]}
	if {($stat(mode) & 02000) != 0} {append warning [l10n warn-bit-setGID]}
	if {($stat(mode) & 01000) != 0} {append warning [l10n warn-bit-sticky]}
	append post [peculiar $stat(mode) $type]
	if {"link"==$type} {set typec [l10n type-link]; set style $STYLE(link)}
	if {$SWITCH(TAP) && $home(at) && $stat(uid) != $home(uid) && $stat(nlink)==1} {append post " [color warning owner]=" [uid2name $stat(uid)]}	;# sometimes root

	# b. by type
	if {"link"==$type && [external $dir $f]} {
	    # if symbolic link to another disk, don't stat b/c may be very slow (spin up drive or network)
	    # in UNIX can mount volumes anywhere just like directory, so go with OS X convention of /Volumes
	    set typec [l10n type-link-external]
	    # assume dir if not suffix?  test on "[file link $f]"?
	    if {$sfx==""} {set style $STYLE(dir); set group dir; incr dcnt} else {incr fcnt}
	} elseif {![file exists $f]} {
	    append warning [l10n warn-link-broken]

	} elseif {[file isfile $f]} {
	    set typec [l10n type-file]
	    set style $STYLE(file)
	    if {[file executable $f]} {
		if {"other"==$group} {set group app}
		set warning "*$warning"	;#append post "*"
	    }

	    if {$type!="link"} {
		if {![file readable $f]} {append warning [l10n warn-not-readable-by-user]}
		set size $stat(size)
		if {$size==0} {
		    set attrs [file attributes $f]	;# we don't use "file attributes $f -rsrclength" b/c error on non-Mac
		    if {[set x [lsearch -exact $attrs -rsrclength]] >= 0} {set size [lindex $attrs $x+1]}
		}		
		incr totalsize $size
		if {$size==0} {append warning [l10n warn-empty]}
		if {$stat(nlink) > 1} {
		    append warning [l10n warn-link-hard-multiple]	;# or "$stat(nlink)", which is distinct from '0'-length file and '1' file in dir, but less mnemonic
		    #append post $stat(ino)
		}

		if {".nib"==$sfx && $size==232960} {set group A2}	;# special cases
		if {".doc"==$sfx && $size < 22000} {set group doc}
	    }
	    incr fcnt

	} elseif {[file isdirectory $f]} {
	    #set sfx ".directory" ?
	    set content {}
	    set fread [file readable $f]
	    if {$fread} {
		set content [glob -nocomplain -directory $f -tails -- "*"]
		# try to reset atime -- treat read above as metadata read just like stat()
		set touchfmt [clock format $stat(atime) -format "%Y%m%d%H%M.%S"]	;# [[CC]YY]MMDDhhmm[.SS]
		catch { exec touch -f -a -t $touchfmt $f }	;# changes ctime, but we value atime over ctime
	    }
	    lassign [classifydir $f $tail $content] group size
	    set style $STYLE(dir)

	    if {"link"==$type} {
		set size 0
	    } else {
		set typec [l10n type-directory]
		incr totaldir [expr $size]
		if {!$fread} {append warning [l10n warn-not-readable-by-user]
		} elseif {$size==0} {append warning [l10n warn-empty]
		} elseif {$size==1 && [file exists "$f/Contents/Info.plist"]} {	;# "*.app" not reliable
		    #set group app -- in /Applications don't split app vs dir-w/app and other, just avoid warning due to single directory
		} elseif {0 && $size==1} {set tail [file join $tail [lindex $content 0]]	;# inline singleton file, want to recurse here to a "proc maketuple {file}", probably make name too long as dirname + filename
		} elseif {$size==1} {append warning [l10n warn-single]
		} else {
		    append post $size
		    #if {$stat(nlink) < [llength $content]} {append warning "K"}	;# on UFS nlink = . + .. + #files, but on HFS+ external often wrong -- but in HFS+?  no aux file for hard links?
		}

		if {($stat(mode) & 2) != 0} {append warning [l10n warn-world-writable]}
		if {![file executable $f]} {append warning [l10n warn-dir-not-searchable-by-user]}
	    }
	    incr dcnt
	} else {
	    set group "special"; set style $STYLE(special); set typec [l10n type-special]
	    incr fcnt
	}

	# c. appearance
	set display $tail	;# default to faithful so no surprises
	set sortkey [normalizekey $t $sfx]
	if {$SWITCH(title)} {
	    set display $t	;# "title" implies strip wrapper for every group
	    if {"title" in $G2F($group)} {set display [prettyname $display $type $group]}
	    # if chop suffix may get dups, which are zapped in lsort -unique
	    if {$SWITCH(nosfx) && "nosfx" in $G2F($group) && "file"==$type} {set sortkey [file rootname $sortkey]
	    } else {append display $sfx}
	}
	if {$SWITCH(F)} {append display $typec}
	if {$SWITCH(notable) && [regexp $EQ(NOTABLE) $ts]} {append style $STYLE(notable)}

	#                  0    1     2      3      4         5     6     7        8       9      10    11     12   ... could use a struct here
	lappend l [list $tail $sfx  $type $group $sortkey  $style $pre $display $warning $post  $size $mtime $atime]
    }
    if {[llength $igl]>0} {log "ignored ($igl)"}

    # comparison w/ls after ignore and before reindeer games
    set maxlen 0; set cnt [expr $fcnt+$dcnt+[llength $igl]]
    foreach tuple $l { set len [displaylen [lindex $tuple 0]]; if {$len > $maxlen} {set maxlen $len} }
    global TERMINFO
    set cols [expr $TERMINFO(width)/($maxlen+1+1)]; if {$cols==0} {set cols 1}	;# maxlen + 1 for trailing char + 1 for gap
    log "cf ls -B $TERMINFO(width)/($maxlen+1+1) for $cnt = ${cols}x[iceil $cnt $cols]"


    # 2. mark up data
    log "*mark* [llength $l]"
    if {$SWITCH(vc)} { foreach p [info commands "vc-*"] {set l [$p $dir $l]} }
    set l [relative $l]

    set datalen 0; set tuplelen [llength [lindex $l 0]]; set reported 0
    foreach tuple $l {
	if {[catch {set user [perfile $dir $tuple]} info]} {
	    if {!$reported} {puts stderr "$SWITCH(startup): $info"; set reported 1}
	} elseif {[llength $user] == 0} {	;# NOT [lindex $user 2]=="ignore" b/c show orphaned ~ files
	} elseif {[llength $user] != $tuplelen} {
	    if {!$reported} {puts stderr "$SWITCH(startup) returned bad list: $user"; set reported 1}
	} elseif {$SWITCH(only) && ![distinctive $user]} {
	} else {
	    #puts "[lindex $user 0] -> [lindex $user 4]"
	    lappend ga([lindex $user 3]) $user
	    incr datalen
	}
    }
    if {$datalen == 0} return	;# possible after user processing and -only


    # 3. display
    # a. prepare display list: sort, groups
    # lsort doesn't support a secondary key (we need group then dictionary within group), so custom sort
    set l {}; set lastgroup "dir"
    foreach {g flags ignore} $GROUP {
	if {![info exists ga($g)]} continue
	set gl $ga($g)

	# "lsort command uses the merge-sort algorithm which is a stable sort" -- hooray!
	set sortl [lsort -index 4 -dictionary -unique $gl]	;# only sort, or sets order for elements that are equal in subsequent sort
	if {[set by [lsearch -glob -inline $flags "by*"]] != ""} {
	    if {"bysuffix"==$by} {set sortl [lsort -index 1 -ascii $sortl]
	    } else {set sortl [lsort -index 0 -command $by $sortl]}
	}

	# used to make series here, but better to treat series as a unit for proc relative
	if {$SWITCH(series) && [llength $sortl] >= $SWITCH(series)} {lassign [series $sortl] sortl cnt; incr stats(series) $cnt}	;# series before prefix
	if {$SWITCH(prefix) && "prefix" in $flags} {lassign [prefix $sortl] sortl cnt1 cnt2; incr stats(pfx) $cnt1; incr stats(pfxch) $cnt2}

	if {$SWITCH(grouptitle) && $g != $lastgroup} {
	    lappend l [list "" "" "GROUP" "" ""  $STYLE(group) "  " $g "" ""  0 0 0] ;# "$name ([llength $ga($g)])" like dir?  didn't like it
	    set lastgroup $g
	}

	set l [concat $l $sortl]
    }
    if {$stats(series) > 0} {log "series -$stats(series)"}
    if {$stats(pfx) > 0} {log "prefix $stats(pfx) ($stats(pfxch) chars)"}
    if {!$SWITCH(group)} {set l [lsort -index 4 -dictionary $l]}


    # b. display: table, summary line, log
    log "*display* [llength $l]"
    column $l

    if {$SWITCH(summary) && $datalen >= $SWITCH(summary)} {
	puts -nonewline "  [plural $fcnt file files]"
	if {$fcnt>0} {puts -nonewline " ([kmg $totalsize])"}
	if {$dotcnt > 0} {puts -nonewline " + [plural $dotcnt dotfile dotfiles [color warning .]]"}
	if {$igcnt>0} {puts -nonewline " + [plural $igcnt ignored ignored]"}
	if {$dcnt>0} {puts -nonewline ", [plural $dcnt directory directories] ([plural $totaldir file files])"}
	#if {$dir!="/"} {puts -nonewline ", .. ([plural [llength [glob $dir/../*]] file files])"}
	puts ""
    }

    if {$SWITCH(log) && [llength $LOG] > 0} {puts "log: [join $LOG {, }]"}


    if {$SWITCH(expando) && $fcnt<=$SWITCH(expando) && $dcnt==1 && $level < 10} {
	foreach tuple $l {
	    if {"directory"==[lindex $tuple 2] && [lindex $tuple 10]>0} {	;# && [lindex $tuple 10] < ? ... this is in place of original anemic dir
		set subdir [lindex $tuple 0]
		puts [format "\nautoexpand [color dir %s/]:" $subdir]
		sl $dir [glob -nocomplain -directory [file join $dir $subdir] -- "*"] [expr $level+1]
		break
	    }
	}
    }
}



#
# organization: grouping
#

proc groupbyname {dir tsw type} {
    global EQ SWITCH

    # distinguish types from wrappers, so doc.txt and photo.jpg are different groups, but doc.txt and doc2.txt.gz are same group
    #if [catch { set tail [file tail $f] }] {return "other"}	;# "home.insightbb.com/~fourcolorheros" as a path
    if {[regexp -nocase $EQ(WRAPPER) $tsw]} {set ts [file rootname $tsw]} else {set ts $tsw}
    if {"file"==$type && [set t [file rootname $ts]]!=""} {set sfx [string tolower [file extension $ts]]} else {set t $ts; set sfx ""}

    if {[info exists EQ($ts)]} {set g $EQ($ts)	;# can't beat exact
    } elseif {[regexp $SWITCH(B) $ts]} {set g ignore	;# regex take precedence over suffix since reclassifying to more specific, ignore first
    } elseif {"."==[string index $ts 0]} {set g dotfile
    } elseif {[regexp $EQ(DEV) $ts] && ($sfx=="" || $sfx==".txt")} {set g dev
    } elseif {[regexp $EQ(MANDIR) $dir] && [regexp $EQ(MANPAGE) $ts]} {set g doc
    } elseif {[info exists EQ($sfx)]} {set g $EQ($sfx)
    } else {set g other}

    if {"-"==[string index $g 0]} { set g [string range $g 1 end]; set iglevel 3
    } elseif {"dotfile" == $g} { set iglevel 2
    } elseif {"ignore" == $g} { set iglevel 1
    } else { set iglevel 4 }

    return [list $g $iglevel $ts $t $sfx]
}

proc external {dir f} {
    global MOUNTS
    set link [file link $f]
    if {[string equal -length [string length $dir] $dir $link]} { return 0 }
    foreach d $MOUNTS {
	if {[string equal -length [string length $d] $d $link]} { return 1 }
    }
    return 0
}

proc classifydir {f tail l} {
    global EQ GROUP SWITCH
    set MAXEXT [string length ".torrent"]
    # 1. by content
    # a. counts
    foreach {g ignore1 ignore2} $GROUP {set cc($g) 0}
    set llen 0; set softignore 0
    foreach c $l {
	lassign [groupbyname $f $c "file"] g iglevel ts t sfx
	if {$iglevel <= 2} continue elseif {$iglevel==3} {incr softignore}
	if {$g=="other"} {	;# guess at dir w/o stat (which would be slow on sometimes 1000s of files)
	    set extlen [string length $sfx]
	    if {$extlen==0 || $extlen > $MAXEXT} {set g dir}
    	}
	incr cc($g); incr llen
    }

    # b. analyze
    set known [expr $llen - $cc(other)]	;# within types that we can identify (though id by suffix is weak)
    set max 0; set maxg "dir"
    unset cc(other) cc(A2) cc(ignore)
    foreach g [array names cc] {
	set len $cc($g)
	if {$len > $max} {set max $len; set maxg $g}
    }
    set relen 0; foreach c {video audio image WWW} {incr relen $cc($c)}

    # c. reclassify
    set g "dir"
#puts "[array names cc] $cc(video) + $cc(audio) + $cc(image) + $cc(WWW) > $llen/2"
    if {"."==[string index $tail 0]} {set g dotfile
    } elseif {[lsearch -nocase -glob $l "VIDEO_TS*"] >= 0} {set g video	;# VIDEO_TS/ or VIDEO_TS.VOB
    } elseif {$cc(dir) >= 3} {
	# hierarchy
    } elseif {$relen>0 && ($relen >= $llen/2 || $llen<=4)} {	;# media special case
	if {$cc(video) > 0} {set g video
	} elseif {$cc(audio) > $cc(image)} {set g audio
	} elseif {$cc(WWW) >= 2 || ($cc(WWW)==1 && $relen<=2) || ($cc(WWW)>=1 && [lsearch -nocase -glob $l "index.htm*"]>=0)} {
	    #set g WWW -- keep as a group so not image/, but don't reclassify b/c gets mixed in with other .html in site
	} else {set g image}
    } elseif {$max >= [expr $known/2]} {	;# other groups
	if {$maxg!="WWW"} {set g $maxg}
    }

    # 2. by name
    if {[regexp "^lib$|^src|(^|\[ _-])test|jar|dump" $tail]} {set g dev}
    # Xelseif {"doc"==$tail || "man"==$tail} {set g doc} => by content

#puts "$tail -> $g $cc($g) of $known/$llen"
    set size [expr $llen-$softignore]; if {$SWITCH(TAP) && $g!="dir" && 0 < $cc($g)&&$cc($g) < $size} {set size "$cc($g)+[expr $size-$cc($g)]"}
    return [list $g $size]
}

proc normalizekey {t sfx} {
    # Xset s [string tolower $s] => no, some sorts case sensitive
    set s $t
    if {[regexp {^(\.)} $s all pfx]} {set s [string range $s [string length $pfx] end]} {set pfx ""}
    regsub -all {#(\d)} $s {\1} s;	;# "#<number>" vs plain "<number>"
    regsub -all {(\D)(\d+)} $s {\1~\2} s	;# if compare something w/number vs something without put number afterward, because first movie in series not given a number
    regsub -all {[-\. _\t]+} $s { } s	;# normalize word separators into single space -- maybe all punctuation?
    regsub -all -nocase {(^| )(the|a|an) } $s {\1} s	;# "a" and "an" may be too aggressive, but try it and let experience guide

    if {$s==""} {set s $t} else {set s "$pfx$s$sfx"}	;# oops, we were too aggressive
#puts "$t -> $s"
    return $s
}



#
# data: relatively recent, relatively large, version control
#

proc relative {l} {
    global STYLE TIME SWITCH

    # recent, both absolute and relative
    set abscutoff [expr $TIME(now)-$SWITCH(abschange)]
    set sizel {}; set mtimel {}; set atimel {}
    foreach tuple $l {
	lappend sizel [expr [lindex $tuple 10]]	 ;# yeah compares sizes of files and dirs, but works out OK
	lappend mtimel [lindex $tuple 11]
	if {[lindex $tuple 2]!="directory"} {lappend atimel [lindex $tuple 12]}
    }
    log "NOW = $TIME(now)"
    lassign [cutoff relsize $sizel 1] cutoffsize repz
    lassign [cutoff relchange $mtimel [expr 5*$TIME(MINUTE)]] cutoffm repm	;# e.g., time to rip a CD
    lassign [cutoff relread $atimel [expr 5*$TIME(MINUTE)]] cutoffa repa

    set l2 {}
    foreach tuple $l {
	lassign $tuple tail sfx type group sortkey  style pre display warning post  size mtime atime; set size [expr $size]
	#if {$size > $cutoffsize} {set style "[lindex $tuple 5];1"}
	#if {$mtime >= $abscutoff} {set pre " " ;# 	# other chars like "*" and '^" blend in too much, colorize too much
	#} elseif {$mtime > $cutoffm} {set pre "."} ;# ">" so run of same across border ignores all (prefer few to too many)
	# bold visually stronger than indent and recent more important than largest, so bold on recent... but bold unreliable?
	# often recent also notable (index.html), bold dir blend in with groups
	set sub [expr {$type=="directory"?"dir":"file"}]
	if {$SWITCH(relsize) && ($size > $cutoffsize || ($size==$cutoffsize && $repz))} {
	    set pre "   " ;# indent, could also outdent if single space char
	    if {"file"==$type} {append post " " [kmg $size]}	;# dir already has size
	    set repz 0	;# choose only one as the representative
	}

	if {$SWITCH(abschange) && $mtime >= $abscutoff} {
	    append style $STYLE(recent,$sub)
	    if {$mtime > $cutoffm || $TIME(now)-$mtime < $TIME(HOUR)} {append post " <" [ago $mtime]; set repm 0}
	} elseif {$SWITCH(relchange) && ($mtime > $cutoffm || ($mtime==$cutoffm && $repm))} {
	    append style $STYLE(relrec,$sub); append post " <" [ago $mtime]; set repm 0
	}

	# can't do absolute (last day, say) due to OS X Spotlight, access since last mod, not dir b/c we do a glob our own damn selves
	# Spotlight: no benefit b/c continuously touching and not resetting, but doesn't cause bad results b/c touches everything so no few most recent and if <=4 files we don't mark anyhow
	if {"directory"==$type} {
	    # don't do dirs -- always being touched
	} elseif {$SWITCH(atime) > 0} {	;# if explicitly turned on absolute, don't confuse with relative
	    if {$TIME(now) - $atime <= $SWITCH(atime)} {
		set pre "->[string range $pre 2 end]"; append post " -" [ago $atime]; set repa 0	;# "=>" so different than relative? no, won't have both kinds at the same time, string range in case also relsize
	    }
	} elseif {$SWITCH(relread) && ($atime > $cutoffa || ($atime==$cutoffa && $repa)) && $atime > $mtime + $TIME(MINUTE)} {
	    set pre "->[string range $pre 2 end]"; append post " -" [ago $atime]; set repa 0
	}	

	lappend l2 [list $tail $sfx $type $group $sortkey  $style $pre $display $warning $post  $size $mtime $atime]
    }
    return $l2
}

proc cutoff {what l by} {
    global SWITCH
    set pct $SWITCH($what)
    set llen [llength $l]; if {$llen==0 || $pct==0} return elseif {$llen==1} {return [list [lindex $l 0] 1]}
    set l [lsort -command bybignum -decreasing $l]; set max [lindex $l 0]
    set cut [expr (($llen*$pct)/100)+1]; if {$cut>$pct} {set cut $pct}
    set val [lindex $l $cut]; set rep 0
    if {$llen > 4} { ;# have to differ by a meaningful amount -- if all downloaded within a couple minutes a year ago, that's just random
	set median [expr $llen/2]
	set beat [expr [lindex $l $median] + $by]
	if {$val < $beat} {set val $beat}
    }
    if {$max <= $val} {
	set val $max
	if {!$SWITCH(only)} {set rep 1; log "$what rep=$val"}	;# single representative value to characterize, but if -only prefer nothing
    } else {log "$what > $val @ $cut"}
    return [list $val $rep]
}


proc peculiar {mode type} {
    # 1. anything peculiar?
    # zots
    if {($mode & 0777) == 0} { return [color warning "---------"] }

    set h 0
    set powner [expr ($mode>>6)&0x7]; set pgroup [expr ($mode>>3)&0x7]; set pothers [expr $mode&0x7]

    # owner/w/x but no r
    if {($powner&4)==0} {set h [expr $h|(4<<6)]}
    if {(1 <= $pgroup&&$pgroup <= 3)} {set h [expr $h|(4<<3)]}
    if {(1 <= $pothers&&$pothers <= 3)} {set h [expr $h|4]}

    # more important but lower perm
    set p [expr $powner & $pgroup]; if {$p != $pgroup} {set h [expr $h|(($pgroup - $p)<<6)]}
    set p [expr $powner & $pothers]; if {$p != $pothers} {set h [expr $h|(($pothers - $p)<<6)]}
    set p [expr $pgroup & $pothers]; if {$p != $pothers} {set h [expr $h|(($pothers - $p)<<3)]}

    # r,w but not x
    if {"directory"==$type} {
	if {($powner&6)!=0 && ($powner&1)==0} {set h [expr $h|(1<<6)]}
	if {($pgroup&6)!=0 && ($pgroup&1)==0} {set h [expr $h|(1<<3)]}
	if {($pothers&6)!=0 && ($pothers&1)==0} {set h [expr $h|1]}
    }
    if {$h==0} {return ""}

    # 2. if so, then highlight that bit
    set post " "; set rwx [perm $mode]
    for {set bit 8} {$bit>=0} {incr bit -1} {
	set c [string index $rwx [expr 8-$bit]]
	if {((1<<$bit)&$h) != 0} {append post [color warning $c]
	} else {append post $c}
    }
    return $post
}



# version control

proc vc-rcs {dir l} {
    set rep "$dir/RCS"; if {![file readable $rep]} {return $l}

    set l2 {}
    foreach tuple $l {
	lassign $tuple tail sfx type group sortkey  style pre display warning post  size mtime atime

	set fv [file join $rep "$tail,v"]
	if {[file exists $fv] && [file mtime $fv] < $mtime} {append warning [l10n warn-vc-need]}
	# RCS repository is local, so theoretically can't have stale local copy

	lappend l2 [list $tail $sfx  $type $group $sortkey  $style $pre $display $warning $post  $size $mtime $atime]
    }
    return $l2
}

proc vc-cvs {dir l} {
    global TIME

    set cvs "$dir/CVS"; if {![file readable $cvs] || ![file readable $cvs/Root]} {return $l}

    set fid [open "$cvs/Root"]; set root [read -nonewline $fid]; close $fid
    set fid [open "$cvs/Repository"]; set rep [read -nonewline $fid]; close $fid
    set fid [open "$cvs/Entries"]; set entries [read $fid]; close $fid
    set data {}
    foreach line [split $entries "\n"] {
	lassign [split $line "/"] pre name ver date options tagdate
	lappend data [list $name $ver $date]
    }
    set rep [file join $root $rep]
    if {![file exists $rep]} {puts [color warning "can't find CVS repository: $rep"]} ;# maybe even blink

    set l2 {}
    foreach tuple $l {
	lassign $tuple tail sfx type group sortkey  style pre display warning post  size mtime atime

	set rec [lsearch -exact -index 0 -inline $data $tail]
	if {$rec==""} {
	    # not under version control
	} elseif {[regexp {^[-0]} [set civer [lindex $rec 1]]]} {
	    # locally added (version 0) or removed (negative version number), not yet checked in
	    append warning [l10n warn-vc-need]
	} else {
	    # repository updated, local stale
	    set citime [clock scan [lindex $rec 2] -gmt true]
	    if {![file exists [set fv [file join $rep "$tail,v"]]]} {
		#append warning [l10n warn-link-broken] -- maybe not local
	    } elseif {[file mtime $fv] > $citime+$TIME(epsilon)} {	;# preliminary check to reduce #files that have to read
		set fid [open $fv]; set head [read $fid 4096]; close $fid
		if {[regexp {head\s[(\d\.)]+;} all repver] && $civer != $repver} {
		    append warning [l10n warn-vc-stale]
		}
	    }
	    # local changed since last
	    if {$mtime > $citime+$TIME(epsilon)} {
		append warning [l10n warn-vc-need]
	    }
	}

	lappend l2 [list $tail $sfx  $type $group $sortkey  $style $pre $display $warning $post  $size $mtime $atime]
    }
    return $l2
}



#
# display: filter, series, prefix, layout
#


proc distinctive {tuple} {
    global STYLE
    lassign $tuple tail sfx type group sortkey  style pre display warning post  size mtime atime
    set show 0
    if {$type=="file"} {
	if {$style!=$STYLE(file) || $pre!="  " || ($warning!="" && $warning!="*" && $warning!="*<-") || $post!=""} {set show 1}
    } elseif {$type=="directory"} {
	if {$style!=$STYLE(dir)  || $pre!="  " || ($warning!="" && $warning!="1") || [llength $post]>1} {set show 1}
    }
    return $show
}


proc prettyname {d type group} {
    # SWITCH(title) is not on by default because you have type the exact name in,
    # but it's OK if you use file completion and are aware that the filename display may not be exactly the same.

    regsub -all {([a-z])([A-Z])} $d {\1 \2} d	;# camelCase -> camel Case
    regsub -all {[\._ ]+} $d { } d

    return $d
}


# requires list sorted in dictionary order
proc series {l} {
    global SWITCH
    set KEY 0	;# 0=tail, 4=sortkey, 7=displayname
    set RX_RELZ { [\.\d]{1,4}[BKMGTPEZY]}
    set seriesl {}; set cnt 0
    for {set i 0; set imax [llength $l]} {$i<$imax} {} {
	set tuple [lindex $l $i]
	set relz 0
	for {set j $i} {$j<$imax} {incr j} {
	    set tuple2 [lindex $l $j]
	    if {[lindex $tuple2 2]=="directory"} {break	;# dir already kind of a series
	    } elseif {$j==$i} {
	    } elseif {![serieseq [lindex $t $KEY] [lindex $tuple2 $KEY]]} {break
	    } elseif {[lindex $tuple2 8] != ""} {break	;# keep warnings
	    } elseif {[set post2 [lindex $tuple2 9]] != ""} {
		if {[regexp $RX_RELZ $post2 all] && [string length $post2]==[string length $all]} {incr relz} else break
	    }
	    set t $tuple2	;# progressive
	}
	set slen [expr $j-$i]
	if {$slen >= 3} {
	    set post [lindex $tuple 9]
	    if {$relz && ![regexp $RX_RELZ $post]} {append post " " [kmg [lindex $tuple 10]]}	;# maybe also do this if length of series >100 or would qualify by relsize percentage (set zlen [expr 100/$SWITCH(relsize)]), size of first tuple is representative but maybe instead show largest in series or sum
	    append post "..." $slen
	    lset tuple 9 $post
	    set i $j	;# j at first mismatch, which is next start
	    incr cnt [expr $slen-1]
	} else {incr i}
	lappend seriesl $tuple
    }
    return [list $seriesl $cnt]
}

proc serieseq {f1 f2} {
    set len [string length $f1]
    if {[string length $f2] != $len} {return 0}

    set i 0
    # if [string length [file rootname]] >= 10 then assume must be a common prefix
    if {$len >= 6+4} { ;# [string length "999999"]==6 + 4 for suffix (though some groups have no suffix)
	for {} {$i < 4} {incr i} {
	    if {[string index $f1 $i] != [string index $f2 $i]} { return 0 }
	}
    }

    set alphaseries 0
    for {} {$i<$len} {incr i} {
	set c1 [string index $f1 $i]; set c2 [string index $f2 $i]
	if {$c1==$c2} {
	} elseif {[string is integer $c1] && [string is integer $c2]} {
	} elseif {$alphaseries} {break
	} elseif {[string is alpha $c1] && [string is alpha $c2]} {
	    #scan $c1 "%c" v1; scan $c2 "%c" v2
	    #X if {$v1+1==$v2} {set alphaseries 1} else {return 0} => too strict
	    set alphaseries 1
	} elseif {[string is integer $c1] && [string is alpha $c2]} {	;# 0..9 over to a..z
	    set alphaseries 1
	} else break
    }
    return [expr $i==$len]
}

# requires list in display order
proc prefix {l} {
    global SWITCH
    set l2 {}; set lastd ""; set lastlen 0
    set cnt 0; set cntch 0
    foreach tuple $l {
	set d [lindex $tuple 7]; set len [string length $d]
	set pfx 0
	set i 0; set imax [expr $lastlen<$len?$lastlen:$len]
	for {set lastc ""} {$i<$imax} {incr i; set lastc $c2} {
	    set c1 [string index $lastd $i]; set c2 [string index $d $i]
	    # breakpoints -- computed on text to be elided not on base
	    if {$c2==" "} {set pfx [expr $i+1]	;# not A-Za-z0-9
	    } elseif {[string is punct $c2]} {set pfx $i	;# not A-Za-z0-9
	    } elseif {$lastc==""} {
	    } elseif {[string is lower $lastc] && [string is upper $c2]} {set pfx $i	;# camelCase
	    } elseif {[string is alpha $lastc] && [string is digit $c2]} {set pfx $i	;# letter->number
	    }
	    # elseif >=3 chars x >= 4 names ?

	    if {$c1 != $c2} break
	}
	if {$i==$imax && ![string is digit $lastc]} {set pfx $i}
	if {$pfx >= $SWITCH(prefix)} {
	    lset tuple 7 "[format {%*s} $pfx { }][string range $d $pfx end]"	;# $pfx-1 spaces and ~ not appealing
	    incr cnt; incr cntch $pfx
	}
	lappend l2 $tuple
	set lastd $d; set lastlen $len
    }
    return [list $l2 $cnt $cntch]
}


# sorting comparators
proc byascii {f1 f2} { return [string compare $f1 $f2] }
proc by1 {f1 f2} { return [string compare -length 1 $f1 $f2] }
# would like to use lsort -integer but handle a file size larger than 4GB on 32-bit machines, (return non-bignum result!)
proc bybignum {n1 n2} { return [expr {$n1<$n2?-1:[expr $n1==$n2?0:1]}] }


# "[l10n file]" vs "$l10n(file)" -- same number of chars
proc l10n {word} {
    global I18N
    if {[info exists I18N($word)]} {set word $I18N($word)}
    return $word
}


set COLSEP 1	;# min space between columns, but effectively +2=3 from 'pre', almost always appears to be much more due to different name lengths and markings.  ls is 1
set NAMEMIN 40	;# so 2 cols on 80-col screen

proc column {l} {
    global TERMINFO NAMEMIN COLSEP SWITCH

    # 1. compute widths needed by tuples, with max that allows >=COLSMIN
    set llen [llength $l]
    set width [expr $TERMINFO(width)-1]	;# right margin (get left margin for free with pre=="  ")
    if {$SWITCH(1)} {set width 1}
    set colsmin [expr $width / $NAMEMIN]
    if {$colsmin <= 1 || !$SWITCH(shorten) || $llen < $SWITCH(shorten)} {set namemax 1000000	;# if few to show give them what they want
    } else {set namemax [expr ($width - $COLSEP * ($colsmin-1)) / $colsmin]}

    set ll {}	;# "ll" = list + lengths
    set maxlen 0
    foreach tuple $l {
	lassign $tuple tail sfx type group sortkey  style pre display warning post  size mtime atime
	set len [expr [displaylen $display]+[string length $pre]+[displaylen $post]+[string length $warning]]	
	if {$len > $maxlen} {set maxlen $len}
	if {$len > $namemax} {set lenx $namemax} {set lenx $len}
	lappend ll [list $tail $sfx $type $group $sortkey  $style $pre $display $warning $post  $size $mtime $atime $len $lenx]
    }
    if {$maxlen > $namemax} {log "|cell| $maxlen->$namemax"}
    set maxw [expr $maxlen<$namemax?$maxlen:$namemax]; set colsuni [expr $width/($maxw+$COLSEP)]; if {$colsuni==0} {set colsuni 1}
    log "uni $width/$maxw=${colsuni}x[iceil $llen $colsuni]"

    # 2. compute col x row, and cols widths
    # a. max out columns
    set rows $llen	;# possible that tail > screen width, in which case wraparound
    for {set c $colsuni} {1} {set c [iceil $llen [expr $r-1]]} {
	set r [iceil $llen $c]
	lassign [tailor $ll 0 $llen $r] sumx wxl
	if {$sumx > $width} { log "X[llength $wxl]x$r = $sumx"; break }
	set rows $r; if {$r==1} break
    }

    # b. aesthetic refinements
    # if title at bottom then bump, swap +1 row for -1 col (easier to read, but don't drastically reshape)
    lassign [bump $ll $rows $width] ll1 bot1; set cols1 [iceil [llength $ll1] $rows]
    log "tailored ${cols1}x$rows bot=$bot1"
    if {$rows >= 2 && $cols1 >= 2 && !$SWITCH(maxcol)} {	;# single row quite readable so keep, need a col to take away or bump into
	set rows2 [expr $rows+1]; lassign [bump $ll $rows2 $width] ll2 bot2; set cols2 [iceil [llength $ll2] $rows2]
	if {$bot2 < $bot1} {set ll $ll2; incr rows; log "row+1 ${cols2}x$rows2 (< bot=$bot1->$bot2)"
	} elseif {$bot2==$bot1 && $cols2+1==$cols1 && $cols2>=4} {set ll $ll2; incr rows; log "row+1 ${cols2}x$rows2 (< cols)"
	} else {set ll $ll1; log "X${cols2}x[expr $rows2] bot=$bot2"}
    } else {set ll $ll1}

    # if extra space, give to maxed out columns (only -- don't space out columns across screen like ls)
    set llen [llength $ll]; lassign [tailor $ll 0 $llen $rows] sumx wxl wl; set cols [llength $wxl] ;# final #cols based on #rows
    set slack [expr $width - $sumx]; set slack0 $slack
    for {set ate 1} {$ate} {} {
	set ate 0
	for {set i 0} {$i<$cols && $slack>0} {incr i} {
	    if {[set x [lindex $wxl $i]] < [lindex $wl $i]} {lset wxl $i [expr $x+1]; incr slack -1; incr ate}
	}
    }
    if {$slack < $slack0} {log "+[expr $slack0-$slack] widths"}

    # if extra space, space out columns a little more (but not a lot)
    set gut [expr $cols-1]
    if {$slack >= $gut} { log "+1*$gut gutter"	;# just +1 space, not until exhaust slack
	for {set i 0} {$i<$gut} {incr i} {
	    lset wxl $i [expr [lindex $wxl $i]+1]
	}
    }

    # if prefix on and all names in column have prefix, then close up gap
    set pfxl {}
    for {set i 0; set j 0; set pfx 1000} {$i<$llen} {incr i} {
	if {![string is space -failindex p [lindex $ll $i 7]] && $p < $pfx} {set pfx $p}
	if {$j+1==$rows || $i+1==$llen} {lappend pfxl $pfx; set j 0; set pfx 1000} else {incr j}
    }
#puts "col pfx: $pfxl for ${cols}x$rows <= $llen"

    # 3. display
    if {$SWITCH(1)} {set wxl [list $namemax]}
    set shortened 0
    for {set i 0} {$i<$rows} {incr i} {
	for {set j 0; set n $i} {$n<$llen} {incr j; incr n $rows} {
	    set tuple [lindex $ll $n]
	    set w [lindex $wxl $j]; set hasnextcol [expr $n+$rows < $llen]	;# stricter than $j+1<$cols
	    if {[llength $tuple]==0} {
		set gap [expr $w-$COLSEP]
	    } else {
		lassign $tuple tail sfx type group sortkey  style pre display warning post  size mtime atime len lenx
		puts -nonewline $pre
		if {$style!=""} {puts -nonewline [color $style]}

		set availw $w
		if {$hasnextcol} {incr availw -$COLSEP} elseif {$j+1<$cols} {incr availw [lindex $wxl [expr $j+1]]} ;# spill into next column
		if {$availw >= $len} {set show $display; set gap [expr $availw-$len]
		} else {
		    incr availw -[expr [string length $pre]+[displaylen $post]+[string length $warning]]
		    set show [shorten $display $availw]; set gap [expr $availw-[displaylen $show]]; incr shortened
		}
		# have to do autosearch at the last second, possible that proc shorten stripped text that would have matched
		set auto $SWITCH(autosearch); if {$auto!="" && $auto!=0 && [regexp -nocase -indices $auto $show num]} {
		    lassign $num n1 n2
#puts "$show: $num -> $n1 $n2"
		    set a [string range $show 0 $n1-1]; set b [string range $show $n1 $n2]; set c [string range $show $n2+1 end]
		    set show "$a[color autosearch $b][color $style]$c"
		}

		#puts -nonewline [string range $show [lindex $pfxl $j] end]
		puts -nonewline $show

		if {$style!=""} {puts -nonewline [color OFF]}
		if {$warning!=""} {puts -nonewline [color warning $warning]}
		puts -nonewline $post
	    }

	    if {$hasnextcol} {puts -nonewline [format "%-*s" [expr $gap+$COLSEP] " "]}
	}
	puts ""
    }
    if {$shortened>0} {log "$shortened names shortened"}
}

proc tailor {l i llen  rows} {
    log "tailor"
    global COLSEP 
    # width of cols = width of widest cell
    set sumx 0; set wl {}; set wxl {}
    for {} {$i<$llen} {incr i $rows} {
	set max 0; set maxx 0
	for {set j $i; set jmax [expr $i+$rows]} {$j<$jmax && $j<$llen} {incr j} {
	    set len [lindex $l $j 13]; set lenx [lindex $l $j 14]
	    if {$len > $max} {set max $len}
	    if {$lenx > $maxx} {set maxx $lenx}
	}
	if {$i+$rows < $llen} {incr max $COLSEP; incr maxx $COLSEP}
	incr sumx $maxx; lappend wl $max; lappend wxl $maxx
    }

    # X if have extra space, give to maxed out columns => premature.  Maybe could bump title, but can't b/c allowed to expand.

    return [list $sumx $wxl $wl]	;# #cols == [llength $wl]
}

# if group title at bottom of column, bump to next column, if we can (free cell, widths OK)
proc bump {ll rows width} {
    set llen [llength $ll]; set bot 0
    for {set i [expr $rows-1]; set imax [expr $rows>1?$llen:0]} {$i<$imax} {incr i $rows} {
	if {"GROUP"==[lindex $ll $i 2]} {incr bot}
    }
    if {$bot==0} {return [list $ll $bot]}

    lassign [tailor $ll 0 $llen $rows] sumx wxl
    set bumpl {}; set botbump 0
    for {set i 0; set c 0; set r 0; set left 0} {$i<$llen} {incr i} {
	set tuple [lindex $ll $i]
	if {$r==0} {incr left [lindex $wxl $c]}

	if {$r+1==$rows && "GROUP"==[lindex $tuple 2]} {
	    # bump?
	    lassign [tailor $ll $i $llen $rows] sumx wxl2
	    if {$left + $sumx <= $width} {
		lappend bumpl {}
		set wxl $wxl2; set c 0; set r 0; incr left [lindex $wxl 0]
	    } else {incr botbump}	;# puts "can't: [lindex $tuple 0] $left + $sumx !<= $width"
	}
	lappend bumpl $tuple
	if {$r+1 < $rows} {incr r} else {incr c; set r 0}
    }

    # possible that bumping gives more titles at bottom
    # (unimplmented: edge case where first bumps OK then if stop would win)
    if {$botbump < $bot} {
	log "bot $bot->$botbump after bump @ rows=$rows"
	set ll $bumpl; set bot $botbump
    }

    return [list $ll $bot]
}



#
# generally useful utility procs: color, pretty print (size, time, shorten text)
#


# (color info gleaned from GNU ls.c)
#	0=end, 1=bold, 2=?, 3=?, 4=underline, 5=flash, 6=?, 7=rev, 8=hidden
#	01=next color brighter, 02=bright off?
#	3x=foreground, 4x=background, where x is 0=black, 1=red, 2=green, 3=yellow, 4=blue, 5=magenta, 6=cyan, 7=white
set COLORIZE 1; #if {![info exists env(TERM)] || ![string match "*color*" $env(TERM)]} {set colorize 0} -- assume color
proc color {style {txt ""}} {
    global COLORIZE; if {!$COLORIZE || $style==""} {return $txt}
    if {[string index $style 0]!=";"} {global STYLE; set style $STYLE($style)}
    set c "\u001b\[[string range $style 1 end]m"
    if {$txt==""} {return $c}
    return "$c$txt\u001b\[0m"
}


proc plural {n singular plural {pfx ""}} {
    if {$n<=0} {set txt "---"
    } elseif {$n==1} {set txt "$n $pfx[l10n $singular]"	;# set txt "a $singular" ?
    } else {set txt "$n $pfx[l10n $plural]"}
    return $txt
}


proc displaylen {s} {
    set len 0
    for {set i 0; set imax [string length $s]} {$i<$imax} {incr i} {
	scan [string index $s $i] "%c" c
	if {(0x300 <= $c&&$c <= 0x36f) || (0x1dc0 <= $c&&$c <= 0x1dff)} {
	    # combining (accent)
	} elseif {0x1b==$c} {
	    # color code
	    while {[string index $s $i] != "m"} { incr i }
	} else {
	    incr len
	}
    }
    return $len
}


set K 1024 ;# maybe you prefer 1000

proc kmg {size} {
    global K
    set SFX "BKMGTPEZY"

    if {$size < $K} {return "${size}B"}
    set pretty "(too big)"
    for {set po2 1.0; set i 0} {$i<5} {set po2 $next; incr i} {
	set next [expr $po2*$K]
	if {$size < $next} {
	    set dsize [expr $size/$po2]
	    set fmt [expr {$dsize<10? "%.1f": "%.0f"}]
	    set pretty [format $fmt $dsize]; if {[string match "*.0" $pretty]} {set pretty [string range $pretty 0 end-2]}	;# e/f/g not right
	    #append pretty [string index $SFX $i]
	    append pretty [color relsize [string index $SFX $i]]
	    break
	}
    }
    return [string trim $pretty]
}


proc ago {time} {
    global TIME
    set s ""; set u ""
    set age [expr $TIME(now) - $time]
    if {[expr abs($age)] < 10} {set s "NOW"
    } elseif {$age < 0} {set s "FUTURE"
    } elseif {$age < 2*$TIME(MINUTE)} {set s $age; set u "second"
    } elseif {$age < 2*$TIME(HOUR)} {set s [expr $age/$TIME(MINUTE)]; set u "minute"
    } elseif {$age < 2*$TIME(DAY)} {set s [expr $age/$TIME(HOUR)]; set u "hour"
    } elseif {$age < $TIME(YEAR)} {set s [expr $age/$TIME(DAY)]; set u "day"
    } elseif {$age < 3*$TIME(YEAR)} {set s [expr ($age+2*$TIME(MONTH))/$TIME(YEAR)]; set u "year"	;# format "%3.1f" would be too precise
    } else {set s [clock format $time -format "%Y"]}
    if {$u != ""} {append s [string index [l10n $u] 0]}
    return $s
}


proc perm {mode} {
    set txt ""
    for {set s 6} {$s >= 0} {incr s -3} {
	set m [expr $mode>>$s]
	append txt [expr ($m & 4)?"r":"-"]
	append txt [expr ($m & 2)?"w":"-"]
	append txt [expr ($m & 1)?"x":"-"]
    }
    return $txt
}

proc shorten {txt w} {
    set len [displaylen $txt]; if {$len <= $w} { return $txt }

    # throw out articles and prepositions
    regsub -nocase -all {(^|\W)(a|an|the)\W} $txt " " txt	;# can't remove from start of word b/c have to type in
    regsub -nocase -all {\W(of|from|for|in|to|and|volume|vol)\W} $txt "/" txt	;# [l10n "..."] ?
    set len [displaylen $txt]; if {$len <= $w} { return $txt }

    # short name: <start>...<num or long suffix>.<sfx><typec> <warning> <post>.  8 chars at end take care of yyyy.sfx
    # most important: files (start of name, numbers, suffix), dirs (start of name, numbers, end / and little more)
    # could give up a couple of chars of gutter in this case... or not now that down to 3 and ->, pass in slack? how different than w?
    global SWITCH
    set e [l10n "..."]; set elen [string length $e]	;# don't use three character "..." b/c already space constrained and may use twice
    set mid $e; set tail 3	;# three-letter suffix not four to double count '.' for ellipsis and sfx
    if {$w <= 10} {	;# emergency mode, usually have NAMEMIN==38 so even with COLSEP/pre/post/warning don't execute very short cases (here and below)
	set tail 0
    } elseif {[regexp -indices {(\d+)} $txt all num]} {
	lassign $num n1 n2; set num [string range $txt $n1 $n2]; set numlen [string length $num]
	if {5+1+$numlen+1+$tail > $w} {
	    # number too many digits, give up showing number
	} else {
	    if {8+$numlen+8 <= $w} {set tail 8}
	    if {$n2 <= $w-$elen-$tail-1} {
	    } elseif {[set x [expr $len-$tail-$elen-$numlen-1]] <= $n1} {set tail [expr $len-($x>$n1?$x:$n1)]
	    } else {	;# no overlap
		set mid "$e$num$e"
		if {$len-$tail-1 <= $n2} {set tail [expr $len-($n2+1)]}	;# don't show number and again partially when could make head longer
	    }
	}
    } else {
	if {$w >= 20} {set tail 8}
    }

    if {$tail>0 && ([set c [string index $txt end-[expr $tail-1]]]==" " || $c==".")} {incr tail -1}	;# space char not informative, give real estate to head
    # if chop on combining accent then should +1, but I'm not going to worry about that
    set head [expr $w-[string length $mid]-$tail]
    set a [string range $txt 0 $head-1]
    if {[string last "\u001b\[" $a] > [string last "\u001b\[0m" $a]} {global STYLE; append a [color $STYLE(OFF)]}
    #if {[string index $txt $a]==" "} {incr tail}--tail may be trying to stay away from number
    return "$a$mid[string range $txt end-[expr $tail-1] end]"
}

# map numeric user id to symbolic
proc uid2name {uid} {
    global n2scache
    if {![info exists n2scache($uid)]} {
	catch { regexp {uid=\d+\(([^)]+)\)} [exec id $uid] all sym }
    	if {![info exists sym]} {set sym $uid}	;# can't resolve
	set n2scache($uid) $sym
    }
    return $n2scache($uid)
}

# integer ceiling function
proc iceil { num den } {
    return [expr ($num + $den - 1) / ($den)]
}



#
# execution
#

proc log {ev} {
    global LOG
    #if {$ev ni $LOG} ...
    lappend LOG $ev
}

proc commandline {argv} {
    global TERMINFO SWITCH

    set argi 0; set argc [llength $argv]
    for {} {$argi<$argc} {incr argi} {
	set opt [lindex $argv $argi]
	if {[string match "--?*" $opt]} {set opt [string range $opt 1 end]}
	switch -glob -- $opt {
	    -only {array set SWITCH { only 1  relsize 0 series 0 prefix 0  title 0 summary 0 } }
	    -atime {set SWITCH(atime) [lindex $argv [incr argi]]}
	    -a {set SWITCH(ignore) 0}
	    -1 {set SWITCH(1) 1}

	    -startup {set SWITCH(startup) [lindex $argv [incr argi]]}
	    -help {puts "see $SWITCH(site)"; exit 0}
	    -version {puts "sl  $SWITCH(version)"; exit 0}

	    -width {set TERMINFO(width) [lindex $argv [incr argi]]}
	    -log {set SWITCH(log) 1}
	    -- { incr argi; break }
	    -* { puts stderr "sl: no such option: $opt"; exit 1 }
	    default { break }
	}
    }
    return $argi
}

proc main {argv {argi 0}} {
    set l [lrange $argv $argi end]; if {[llength $l]==0} {set l [list .]}

    # validate, group together files by dir
    set g(0) 1; unset g(0)	;# make 0-length array
    set dirl {}
    foreach f $l {
	if {![file exists $f]} {puts stderr "$f: no such file or directory"
	} elseif {![file readable $f]} {puts stderr "$f: not readable"
	} elseif {[file isdirectory $f]} {lappend dirl $f
	} else {lappend g([file dirname $f]) $f}
    }
    set fl [array names g]
    # OK if empty b/c all invalid

    # iterate
    set fcnt [expr [llength $fl]+[llength $dirl]]; set first 1
    foreach dir [lsort $fl] {
	if {!$first} {puts ""}
	if {$fcnt > 1} {puts "$dir:"}
	sl $dir $g($dir)
	set first 0
    }
    foreach dir $dirl {
	if {!$first} {puts ""}
	if {$fcnt > 1} {puts "$dir:"}
	sl $dir [glob -nocomplain -directory $dir -- "*" ".*"]
	set first 0
    }
}



#
# extensions: change global variables, per-file property control, redefine procs (like vc, shorten, even main)
#

proc perfile {dir tuple} { return $tuple }



if {![info exists META] || $META(sl)=="run"} {
    set argi [commandline $argv]
    if {[file readable $SWITCH(startup)]} {source $SWITCH(startup)}
    main $argv $argi
}
