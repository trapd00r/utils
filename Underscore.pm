package Underscore;
use Carp;
sub TIESCALAR { bless \my $dummy => shift }
sub FETCH { croak 'Read access to $_ forbidden'  }
sub STORE { croak 'Write access to $_ forbidden' }
sub unimport { tie($_, __PACKAGE__) }
sub import   { untie $_ }
tie($_, __PACKAGE__) unless tied $_;
1;
