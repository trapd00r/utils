#!/usr/bin/perl
our $APP      = 'git-rec';
our $VERSION  = 0.1;

use strict;
use Getopt::Long;
use Pod::Usage;

usage() if !@ARGV;

our($cmd, $dir, $branch) = (undef) x 3;
GetOptions(
  'cmd:s'    => \$cmd,
  'dir:s'    => \$dir,
  'branch:s' => \$branch,
);

($cmd)    = $cmd    ? $cmd    : 'pull';
($dir)    = $dir    ? $dir    : "$ENV{HOME}/devel";
($branch) = $branch ? $branch : 'origin master';


cmd($dir, $cmd);

sub cmd {
  my($start, $operation) = @_;
  $start =~ s;/$;;;

  my @content = grep{! /(?:\.\.?)$/ }<$start/.* $start/*>;

  for(@content) {
    if(-d $_) {
      if($_ =~ /\.git$/) {
        my ($basename) = $_ =~ m;(.+)/\.git;;
        my ($project)  = $_ =~ m;.+/(.+)/\.git;;

        my $status = undef;

        if($operation eq 'pull') {
          chomp($status = `cd $basename && git $cmd $branch 2> /dev/null`);

          if($status =~ /Already up-to-date\./) {
            printf("\e[1m::\e[38;5;178m %s\e[0m\n\e[38;5;34m   Up to date\e[0m\n", $project);
            next;
          }
          else {
            printf("\e[1m::\e[38;5;178m %s\e[0m - \e[38;5;162mPulling\e[0m\n", $project);
            print "$status\n";
            next;
          }
        }
        elsif($operation eq 'status') {
          my @records;
          chomp(@records = `cd $basename && git status -s`);
          @records = git_status(@records);
          printf("\e[1m::\e[38;5;178m %s\e[0m\n", $project);
          printf("   %s\n", $_) for @records;
        }

        elsif($operation eq 'log') {
          my @records;
          chomp(@records = `cd $basename && git --no-pager log`);
          @records = git_log(@records);
          print "$_\n" for @records;
        }
        else {
          print $operation;
        }
      }
      else {
        cmd($_, $operation);
      }
    }
  }
  return 0;
}

sub git_status {
  for(@_) {
    s/^\?\? (.+)$/\e[38;5;137m\e[1mUntracked: \e[0m$1/gms;
    s/^ M (.+)$/\e[38;5;34m\e[1m Modified: \e[0m$1\e[0m/gms;
    s/^ D (.+)$/\e[38;5;244m\e[1m  Deleted: \e[1m$1\e[0m/gms;
  }
  return(@_);
}

sub git_log {
  for(@_) {
    s/^(commit) (.+)$/\e[1m$1 \e[0m\e[3m\e[38;5;197m$2\e[0m/;
    s/^(Author:) (.+) <(.+)>$/$1 \e[1m\e[38;5;65m$2\e[0m < \e[38;5;208m$3\e[0m >\e[0m/;
    s/^(Date) (.+)$/\e[1m$1 \e[0m\e[3m$2\e[0m/;
    s/^\s+ (.+)/\e[38;5;249m\t$1\e[0m/;
  }
  return(@_);
}

sub usage {
  print "$APP $VERSION\n";
  pod2usage(verbose => 1);
  exit(0);
}

=pod

=head1 NAME

git-rec - do git stuff recursively

=head1 DESCRIPTION

=head1 OPTIONS

  -c,   --cmd     git cmd
  -d,   --dir     start dir
  -b,   --branch  branch

=head1 AUTHOR

Written by Magnus Woldrich

=head1 REPORTING BUGS

Report bugs to trapd00r@trapd00r.se

=head1 COPYRIGHT

Copyright (C) 2010 Magnus Woldrich

License GPLv2

=cut
