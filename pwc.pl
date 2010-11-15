#!/usr/bin/perl
use strict;
# pwc - perl weather client
use Weather::Google;
use String::Utils 'longest';

my @towns;
if(!@ARGV) {
  push(@ARGV, qw(norrkoping
                 finspang
                 linkoping
                 motala
                 eskilstuna
                 stockholm
                 goteborg
                 malmo
                 lund
                 ronneby
                 svedala
                 kiruna
                 jokkmokk
                 ystad
                 berlin
                 paris
                 copenhagen
                 oslo
                 helsingfors
                 baghdad
                 )
               );
  push(@ARGV, ('Los Angeles', 'New York', 'Seattle',));
}

@towns = @ARGV;

my @gobjects;

my %data;
for my $town(@towns) {
  push(@{$data{$town}},
    Weather::Google->new($town)->current(
      'temp_c',
      'condition',
      'humidity',
      'wind_condition',
    )
  );
}


my @data = ();
my $town = undef;

for my $town(sort(keys(%data))) {
  @data = @{$data{$town}};
  for(@data) {
    $_ = 'undef' if(!defined($_));
  }
}


my $len = longest(@towns);
for(@towns) {
  printf("\e[38;5;208m%${len}s\e[0m\e[1m: %3d\e[38;5;244m°\e[38;5;197mC \e[38;5;240m//\e[0m\e[38;5;38m %s\e[0m\n",
    ucfirst($_), $data{$_}->[0], $data{$_}->[1], $data{$_}->[2]);
}
