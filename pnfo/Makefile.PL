#!/usr/bin/perl
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME => 'pnfo',
    DISTNAME => 'pnfo',
    ABSTRACT => 'Perl script to use vim as a NFO viewer',
    AUTHOR => 'Magnus Woldrich <trapd00r@trapd00r.se',
    EXE_FILES => ['pnfo','vimpager-nfo'],
    LICENSE => "GPLv2",
    MIN_PERL_VERSION => 5.000,
);


