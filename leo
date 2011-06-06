#!/usr/local/bin/perl -l

# leo (leonardo script) - reverse input to ʇndʇno
# 
# Tom Christiassen
# tchrist@perl.com

use 5.010_000;

use utf8;
use strict;
use autodie;
use warnings qw[  FATAL all  ];
use open     qw[ :std  :utf8 ];

use autouse 
   "Unicode::Normalize" => qw[ NFD NFC NFKD NFKC ];

use constant BOTH_WAYS => 0;


#################################################################

sub flip_diacriticals($); 

# heredoc beaᵘtification routines
sub dequeue($$);
sub strip_qq($);
sub  strip_q($);

sub xbrace_quote(@);
sub reverse_mark_flip($);

sub main();

#################################################################

main();
exit();

#################################################################

sub main() {                                       sub 
                                                   uʍopəpᴉƨdn($);
    for my $input (reverse <>) {
        chomp $input;
        my    $ʇndʇno = uʍopəpᴉƨdn($input);
        say   $ʇndʇno;
    }
}

#################################################################

sub uʍopəpᴉƨdn($) {
    my $_ = shift();

    $_ = /[^\x00-\x7F]/   # Unicode?
       ? reverse_mark_flip($_)
       : reverse          ($_);             

    # this is the best we can do for either case
    0 and s/[Jj]/ſ\x{323}/g;   # long s + combining dot below

# Placeholders below indicated by □ for chars I haven't
# yet found an upside-down version of. This can be deceptive
# if you don't have one of the normal things in your font set!

    if (BOTH_WAYS) { 

        tr [abcdefghijklmnopqrstuvwxyzɐqɔpəɟ⅁ɥᴉ□ʞlɯuodbɹƨʇnʌʍxλ□]
           [ɐqɔpəɟ⅁ɥᴉ□ʞlɯuodbɹƨʇnʌʍxλ□abcdefghijklmnopqrstuvwxyz];

        tr [ABCDEFGHIJKLMNOPQRSTUVWXYZɐqƆpƎℲ⅁ɥI□ʞ⅂ƜИOdbᴚƨʇnɅMX⅄□]
           [ɐqƆpƎℲ⅁ɥI□ʞ⅂ƜИOdbᴚƨʇnɅMX⅄□ABCDEFGHIJKLMNOPQRSTUVWXYZ];

    } else { 

        tr [abcdefghijklmnopqrstuvwxyz]
           [ɐqɔpəɟƃɥᴉɾʞlɯuodbɹƨʇnʌʍxλz];    # punt to other case
           #[ɐqɔpəɟ⅁ɥᴉ□ʞlɯuodbɹƨʇnʌʍxλ□];    # punt to other case
         # [ɐqɔpəɟ□ɥᴉ□ʞlɯuodbɹƨʇnʌʍxλ□];    # missing in the casing

        tr [ABCDEFGHIJKLMNOPQRSTUVWXYZ]
           [ɐqƆpƎℲ⅁ɥI□ʞ⅂ƜИOdbᴚƨʇnɅMX⅄□];    # punt to other case
         # [□□Ɔ□ƎℲ⅁□I□□⅂ƜИO□□ᴚ□□□ɅMX⅄□];    # missing in the casing

    }

    tr [-¯_#&'"“”‘’!¡?¿,.] 
       [-_¯#⅋'"„□□,¡!¿?ʻ˙];

    tr [0123456789]
       [0□□ʕ□□9□86] if 0;

    # sure wish these next two looked better

    tr [()<>{}[]]
       [)(><}{\]\[];  

    tr#/\\#\\/#;

    # NFC unlikely to be of much help, 
    # but one is "supposed" to do this
    return NFC($_);
}

#   reverse string by graphemes, inverting all the marks 
sub reverse_mark_flip($) {
    my $string = shift();

    # first decompose to pull out grapheme units
    my $nfd = NFD($string);

    # reverse the string by grapheme units
    my @graphemes = $nfd =~ /\X/g;

    # put it back together reversed
    $string = join q[] => reverse @graphemes;

    # if there are marks, we have hard work to do
    if ($string =~ /\pM/) {
        $string = flip_diacriticals($string);
    } 

    return $string;
}  

# This autoloading stub replaces itself with the real function,
# then jumps directly into its replacement via magic goto.
# 
#     HEY LIKE I'M SORRY ALREADY, OK! It's just too hard to get 
#     this right—and look ok—any other way.  Really, I *tried*.
#
sub flip_diacriticals($) {

    binmode(DATA, ":utf8");
    local $/ = q[];
    my $_;
    my($lhs, $rhs) = ( q[], q[] );
    while (<DATA>) {

        next if m{ \A \s* \# }x;

        my @pair = m{ < ( \p{HexDigit} + ) > }gmx;

        next unless @pair == 2;

        $lhs .= xbrace_quote(        @pair);
        $rhs .= xbrace_quote(reverse @pair);
    } 
    my $redefinition =  strip_q <<'END_OF_START'
            |Q| 
            |Q| no warnings "redefine";
            |Q| 
            |Q| sub flip_diacriticals($) {
            |Q|     # haven't touched @_ yet
            |Q|     my $string = shift();
            |Q|     $string =~ 
            |Q|                
END_OF_START
                     . strip_qq <<"END_OF_TRANSLITERATION"
           |QQ|                 
           |QQ|                 tr[$lhs]
           |QQ|                   [$rhs];
           |QQ|                 
END_OF_TRANSLITERATION
                     .  strip_q <<'END_OF_FUNCTION' 
            |Q| 
            |Q|     return $string;
            |Q| } 
            |Q| 
            |Q| 1;  # eval happiness
            |Q| 
END_OF_FUNCTION

     # this  ̬  is the end of the eval string build up
            ;   # DO NOT DELETE
     # that  ̂ was the end of the eval string build up

    ##say  $redefinition;
      eval $redefinition || die;
      goto \&flip_diacriticals;
} 

sub dequeue($$) {
    my($leader, $body) = @_;
    $body =~ s/^\s*\Q$leader\E ?//gm;
    return $body;
}

sub strip_q($) {
    my $body = shift();
    return dequeue('|Q|', $body);
} 

sub strip_qq($) {
    my $body = shift();
    return dequeue("|QQ|", $body);
} 

sub xbrace_quote(@) {
    return join q[] => map { q[\x{] . $_ . q[}] }  @_;
} 

__END__
 ̈  776	<0308>	COMBINING DIAERESIS
 ̤  804	<0324>	COMBINING DIAERESIS BELOW

 ̃  771	<0303>	COMBINING TILDE
 ̰  816	<0330>	COMBINING TILDE BELOW

 ́  769	<0301>	COMBINING ACUTE ACCENT
 ̗  791	<0317>	COMBINING ACUTE ACCENT BELOW

 ̀  768	<0300>	COMBINING GRAVE ACCENT
 ̖  790	<0316>	COMBINING GRAVE ACCENT BELOW

 ̆  774	<0306>	COMBINING BREVE
 ̯  815	<032F>	COMBINING INVERTED BREVE BELOW

 ̑  785	<0311>	COMBINING INVERTED BREVE
 ̮  814	<032E>	COMBINING BREVE BELOW

 ̭  813	<032D>	COMBINING CIRCUMFLEX ACCENT BELOW
 ̌  780	<030C>	COMBINING CARON

 ̂  770	<0302>	COMBINING CIRCUMFLEX ACCENT
 ̬  812	<032C>	COMBINING CARON BELOW

 ̧  807	<0327>	COMBINING CEDILLA
̉  777	<0309>	COMBINING HOOK ABOVE

 ̇  775	<0307>	COMBINING DOT ABOVE
 ̣  803	<0323>	COMBINING DOT BELOW

 ̳  819	<0333>	COMBINING DOUBLE LOW LINE
 ̿  831	<033F>	COMBINING DOUBLE OVERLINE

 ̅  773	<0305>	COMBINING OVERLINE
 ̲  818	<0332>	COMBINING LOW LINE

 ̄  772	<0304>	COMBINING MACRON
 ̱  817	<0331>	COMBINING MACRON BELOW

 ̍  781	<030D>	COMBINING VERTICAL LINE ABOVE
 ̩  809	<0329>	COMBINING VERTICAL LINE BELOW
