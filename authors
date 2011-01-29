{
  package Retriever;
  use strict;
  use warnings;
  use URI;
  use LWP::UserAgent;
  use File::Spec::Unix;

  my @times = qw(1h 6h 1d 1W 1M 1Q 1Y);

  sub retrieve {
    my $class = shift;
    my %opts = @_;
    $opts{lc $_} = delete $opts{$_} for keys %opts;
    my $self = bless \%opts, $class;
    $self->{uri} = URI->new( $self->{mirror} || 'http://cpan.hexten.net/' );
    die "Unknown scheme\n"
      unless $self->{uri} and $self->{uri}->scheme and
             $self->{uri}->scheme =~ /^(http|ftp)$/i;
    $self->{time} = '6h'
        unless $self->{time}
           and grep { $_ eq $self->{time} } @times;
    $self->{uri}->path( File::Spec::Unix->catfile( $self->{uri}->path, 'authors', 'RECENT-' . $self->{time} . '.yaml' ) );
    return $self->fetch();
  }

  sub fetch {
    my $self = shift;
    open my $fooh, '>', \$self->{foo} or die "$!\n";
    my $ua = LWP::UserAgent->new();
    $ua->get( $self->{uri}->as_string, ':content_cb' => sub { my $data = shift; print {$fooh} $data; } );
    close $fooh;
    return $self->{foo};
  }
}

package main;

use strict;
use warnings;
use YAML::Syck;
use File::Spec;
use CPAN::DistnameInfo;

$!=1;

my @times = qw(1h 6h 1d 1W 1M 1Q 1Y);

my $time = shift || '1Y';
$time = '6h' unless grep { $_ eq $time } @times;

my $mirror = 'http://cpan.hexten.net/';
my $path = 'authors';
my %data;
my %authors;
my $finished;
while( !$finished ) {
  my $foo = shift @times;
  $finished = 1 if $foo eq $time;
  my $yaml = Retriever->retrieve( time => $foo, mirror => $mirror );
  my @yaml;
  eval { @yaml = YAML::Syck::Load( $yaml ); };
  die unless @yaml;
  my $record = shift @yaml;
  die unless $record;
  foreach my $recent ( reverse @{ $record->{recent} } ) {
    next unless $recent->{path} =~ /\.(tar\.gz|tgz|tar\.bz2|zip)$/;
    next unless $recent->{type} eq 'new';
    next     if $recent->{path} =~ /withoutworldwriteables/;
    ( my $foo = $recent->{path} ) =~ s#^id/##;
    $data{ $foo } = $recent->{epoch};

  }
}

my $longest = 0;

foreach my $path ( keys %data ) {
  my $d = CPAN::DistnameInfo->new( $path );
  my $id = $d->cpanid;
  my $len = length( $id );
  $longest = $len if $len > $longest;
  $authors{ $id }++;
}

print "Number of CPAN Uploads grouped by author for the past 12 months: ( Generated ", scalar localtime, " )\n\n";
print join(' ' x ( $longest - length($_) + 4 ), $_, $authors{$_}), "\n" for sort { $authors{$b} <=> $authors{$a} || $a cmp $b } keys %authors;
