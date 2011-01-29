use strict;
use Text::VimColor;
use Getopt::Long;

our ($optXML,$optColor, $optVimrc);
$optColor = 'molokai';
$optVimrc = "$ENV{HOME}/.vimrc";
GetOptions(xml         => \$optXML,
           colorscheme => \$optColor,
           vimrc       => \$optVimrc,
         );

my $file = shift or die "Need file";
my $output = 'html';
if($optXML) {
  $output = 'xml';
}


my @options = qw(-RXZ -i NONE -u NONE -N);
my $vim = Text::VimColor->new(
  file           => $file,
  html_full_page => 1,
  vim_options    => \@options,
);





print $vim->html;
