use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Net::Google::TLD',,
    AUTHOR              => q{Magnus Woldrich <trapd00r@trapd00r.se>},
    VERSION_FROM        => 'lib/Net/Google/TLD.pm',
    ABSTRACT_FROM       => 'lib/Net/Google/TLD.pm',

    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),

    PL_FILES            => {},

    PREREQ_PM           => {
    },


    MAN1PODS            => {
    },

    MIN_PERL_VERSION    => 0,

    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Net-Google-TLD-*' },
);
