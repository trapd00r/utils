#!/usr/bin/perl
# git-pull-all - pull git repos recursively
use strict;

my $basedir = shift // "$ENV{HOME}/devel";
my $branch  = shift // 'master';

pull($basedir);

sub pull {
  my $dir = shift;
  $dir =~ s;/$;;;

  my @content = grep{! /(?:\.\.?$|forks)/ }<$dir/.* $dir/*>;

  for(@content) {
    if(-d $_) {
      if($_ =~ /\.git$/) {
        my ($basename) = $_ =~ m;(.+)/\.git;;
        my ($project)  = $_ =~ m;.+/(.+)/\.git;;

        chomp(my $status = `cd $basename && git pull origin $branch 2> /dev/null`);
        if($status =~ /Already up-to-date\./) {
          printf("\e[1m%20.30s\e[0m:\e[38;5;82m Up to date!\e[0m\n",
            $project);
          next;
        }
        else {
          print "\n\e[1m---\e[38;5;208m$project\e[0m\e[1m---\e[0m\n";
          print "$status\n";
          next;
        }
      }
      else {
        pull($_);
      }
    }
  }
  return 0;
}

