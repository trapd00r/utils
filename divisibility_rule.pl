#!/usr/bin/perl
use strict;

my $foo = shift // 1024;

div_one($foo);
div_two($foo);
div_three($foo);
div_five($foo);
div_six($foo);
div_seven($foo);
div_eight($foo);
div_nine($foo);
div_ten($foo);

sub div_one {
  $_ = shift;
  printf("%d/1: \e[1mpositive\e[0m\n", $_);
}

sub div_two {
  $_ = shift;
  if(($_ =~ m/.*(\d)/) and ($1 % 2 == 0)) {
    printf("%d/2: \e[1mpositive\e[0m\n", $_);
  }
}

sub div_three {
  $_ = shift;
  (my @c = $_) =~ /(\d)/g;
  my $m = 0;
  for(@c) {
    $m += $_;
  }
  if($m % 3 == 0) {
    printf("(%s)/3: \e[1mpositive\e[0m\n", join('+', @c));
  }
}

sub div_five {
  $_ = shift;
  if((m/.*(\d)$/) and ($1 == 5) or ($1 == 0)) {
    printf("%d/5: \e[1mpositive\e[0m\n", $_);
  }
}

sub div_six {
  $_ = shift;
  if(($_ % 3 == 0) and ($_ % 2 == 0)) {
    printf("%d/6: \e[1mpositive\e[0m\n", $_);
  }
}

sub div_seven {
  $_ = shift;
  my $x = substr($_, -1, 1);
  $_ =~ s/$x$//;
  $_ = ($_ + $x);
  if($_ % 7 == 0) {
    printf("($_+$x)/7: \e[1mpositive\e[0m\n");
  }
}

sub div_eight {
  $_ = shift;
  my $x = substr($_, -1, 1);
  $_ =~ s/$x$//;
  $_ = ($_ * 2) + $x;
  if($_ % 8 == 0) {
    printf("($_*2)+$x/8: \e[1mpositive\e[0m\n");
  }
}

sub div_nine {
  $_ = shift;
  my @c = $_ =~ /(\d)/g;
  my $m = 0;
  for(@c) {
    $m += $_;
  }
  if($m % 9 == 0) {
    printf("(%s)/9: \e[1mpositive\e[0m\n", join('+', @c));
  }
}

sub div_ten {
  $_ = shift;
  if((m/.*(\d)$/) and ($1 == 5) or ($1 == 0)) {
    printf("%d/10: \e[1mpositive\e[0m\n", $_);
  }
}
