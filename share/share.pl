#!/usr/bin/perl
use strict;
use Socket;
use IO::Socket;
use Cwd 'abs_path';

write_css();

my $port = 8000;
my $user = shift // 'Dude';

defined($port) or die "Usage: $0 portno\n";

my $doc_root =  abs_path();
my $server   = IO::Socket::INET->new(
  Proto     => 'tcp',
  LocalPort => $port,
  Listen    => SOMAXCONN,
  Reuse     => 1,
);

$server or die "Unable to create server socket: $!" ;

# Await requests and handle them as they arrive

while(my $client = $server->accept()) {
  $client->autoflush(1);
  my %request = ();
  my %data    = ();
  {
    local $/ = Socket::CRLF;
    while(<$client>) {
      chomp; # Main HTTP request
      if (/\s*(\w+)\s*([^\s]+)\s*HTTP\/(\d.\d)/) {
        $request{METHOD}       = uc($1);
        $request{URL}          = $2;
        $request{HTTP_VERSION} = $3;
      }
      # Standard headers
      elsif(/:/) {
        my($type, $val) = split(/:/, $_, 2);

        for($type, $val) {
          s/^\s+//;
          s/\s+$//;
        }
        $request{lc($type)} = $val;
      }
      # POST data
      elsif(/^$/) {
        read($client, $request{CONTENT}, $request{'content-length'})
          if(defined($request{'content-length'}));
        last;
      }
    }
  } # end local

  if($request{METHOD} eq 'GET') {
    if($request{URL} =~ /(.*)\?(.*)/) {
      $request{URL}     = $1;
      $request{CONTENT} = $2;
      %data = parse_form($request{CONTENT});
    }
    else {
      %data = (); # :(
    }
    $data{'_method'} = "GET";
  }
  elsif($request{METHOD} eq 'POST') {
    %data = parse_form($request{CONTENT});
    $data{'_method'} = "POST";
  }
  else {
    $data{'_method'} = "ERROR";
  }

  my $localfile = $doc_root . $request{URL};

  if(open(my $fh, '<', $localfile)) {
    print $client "HTP/1.0 200 OK", Socket::CRLF;
    print $client Socket::CRLF;

    my $buffer = undef;
    while(read($fh, $buffer, 4096)) {
      print $client $buffer;
    }
    $data{_status} = 200;
  }

  else {
    print $client '<link rel="stylesheet" type="text/css" href="foobar.css" />';
    print $client '<pre>';
    print $client "<h1 class='green'>Varsego $user...</h2>";

    my $i =0;

    for(glob("*")) {
      print $client sprintf("<strong>% 4d</strong>: <a href='%s'>%s</a><br>", $i, $_, $_);
      $i++;
    }
    print $client "</pre>";
  }
  # Log request
  print $doc_root . $request{URL}, "\n";
  for(keys(%data)) {
    print $_ = "$data{$_}\n";
  }
  close($client);
}

sub parse_form {
  my $d    = shift;
  my %data = ();

  for(split(/&/, $d)) {
    my($k, $v) = split(/=/, $_);
    $v =~ s/\+/ /g;
    $v =~ s/%(..)/chr(hex($1))/ge;
    $data{$k} = $v;
  }
  return(\%data);
}

unlink('./foobar.css');

sub write_css {
  $|++;
  open(my $css, '>', './foobar.css') or die($!);
  print $css "

  body {
  background: #121212;
  color:#e5e5e5;
  font-family: 'lucida grande','lucida sans unicode',Verdana,Tahoma,Arial,sans-serif;
  font-size:0.9em;
  line-height:1.2em;
  margin:0 auto;
  padding:0;
  }

  label {
    margin-left:5px;
  }

  a {
    color:#0383c9;
    font-weight:700;
    text-decoration:none;
  }

  a:hover {
    text-decoration:underline;
    color: #f5a2c6;
  }

  a img {
    border:0;
  }

  p {
    margin:0 0 18px 0px;
  }

  ul,ol,dl {
    font-size:1em;
    margin:1px 0 16px 0px;
    color: #f4ea05;
  }

  ul ul,ol ol {
    margin:4px 0 4px 10px;
  }

  .posts {
    padding:0;
  }

  li {
    padding:0 4px;
    color:#b2b2b2;
    list-style: none;
  }

  ul.posts li span { /* post timestamps */
    float:right;
    font-family:monofur, monaco, courier;
    color:#888;
  }

  ul.posts li a {
    font-weight:200;
  }

  div#post ul li {
    list-style: circle;
  }

  blockquote {
    border-left:8px solid #0383c9;
    background: #474747;
    font-size:1.0em;
    margin:20px 10px;
    padding:10px;
    padding-left:20px;
  }

  blockquote span {
    display: block;
    float: right;
    padding-right:20px;
  }

  pre {
    background: #121212;
    font-family: Terminus, Monaco, Courier, Monospace;
    background: #171717;
    color: #888888;
  }

  .scoot {
    margin:5px 5px 5px 0px;
  }

  .terminal {
    background: #202020;
    color: #ffffff;
    font-family: Terminus, Monaco, Courier, Monospace;
  }

  .im {
    font-size:0.95em;
    line-height: 1.4em;
    width: 650px;
    font-family: 'lucida grande','lucida sans','lucida sans unicode',helvetica,tahoma;
    padding: 5px;
    background-color:#FFB604;
    color:#222;
    border: solid 1px #fff;
  }

  h1 {
    color:#0383c9;
    font-size:4.7em;
    letter-spacing:-5px;
    margin:0 0 30px 0px;
    padding:50px 0 0 0;;
  }

  h1 a {
    color:#0383c9;
    text-transform:none;
  }

  h1 a:hover {
    color:#fba919;
  }

  #logo {
    margin: -110px 0px -80px 50px;
    float:right;
    background: url('/images/archperl.png');
    background-repeat: no-repeat;
    height: 256px; width:256px;
  }

  .publish_date {
    margin-top:-8px;
    margin-bottom:0px;
    text-align:right;
    font-size:0.8em;
    width:490px;
    color: #23af4c;
  }


  .pink { color: #f5a2c6; }
  .green { color: #23af4c; }
  .blue { color: #0383c9; }
  .lightblue { color: #8db4c9; }
  .orange { color: #fba919; }
  .lightgreen { color: #a6ff00; }


  a.pink:hover { border: solid 2px #f5a2c6;padding:1px; text-decoration:none;  }
  a.green:hover { color:#212121; background-color:#23af4c;text-decoration:none; }
  a.blue:hover { color:#212121; background-color:#0383c9;text-decoration:none; }
  a.lightgreen:hover { color:#212121; background-color:#a6ff00;text-decoration:none; }
  a.orange:hover { color:#fba919;  padding:1px; border: solid 2px #fba919; text-decoration:none; }

  .slogan a { padding:3px; }

  .commentslink { margin-bottom: 35px;
    display:block;
    border-bottom:solid 1px #dadada;
    padding-bottom:25px;
  }

  h2 {
    border-bottom:1px solid #e5e5e5;
    color:#0383c9;
    font-size:1.7em;
    font-weight:100;
    letter-spacing:-1px;
    margin:0 0 10px;
    padding:0px 2px 4px 5px;
  }

  .post_title {
    font-size:1.8em;
    font-weight:normal;
    padding-bottom: 6px;
  }

  h3 {
    border-bottom:1px solid #e5e5e5;
    color:#fba919;
    font-size:1.4em;
    font-weight: 100;
    margin:10px 0 8px;
    padding:1px 2px 2px 3px;
  }

  h4 {
    color: #23af4c;
  }

  /*** Main wrap and header ***/

  #wrap {
    color:#f4f4f4;
    margin:10px auto;
    padding:0;
    width:670px;
  }

  #header {
    margin:0;

  }

  #toplinks {
    font-size:0.9em;
    padding:5px 2px 2px 3px;
    text-align:right;
  }

  #toplinks a {
    color:gray;
  }

  div.slogan {
    color:gray;
    font-size:1.2em;
    font-weight:700;
    letter-spacing:-1px;
    line-height:1.2em;
    margin:-15px 0px 30px 0px;
  }

  div.slogan div {
    display:inline;
  }

  /*** Main content ***/

  #content {
    float:left;
    line-height:1.5em;
    margin:0;
    padding:0;
    text-align:left;
    width:500px;
  }

  #contentalt {
    float:left;
    line-height:1.5em;
    margin-right:20px;
    padding:0;
    text-align:left;
    width:750px;
  }

  #content h3, #contentalt h3 {
    margin:10px 0 8px;
  }

  #footer {
    border-top:3px solid #333;
    clear:both;
    color:gray;
    font-size:0.9em;
    line-height:1.6em;
    margin:0 auto;
    padding:8px 0;
    text-align:left;
  }

  #footer p {
    margin:0;
    padding:0;
  }

  #footer a {
    color:#808080;
  }

  /*** Various classes ***/

  .box {
    background:#4088b8;
    border:1px solid #c8c8c8;
    color:#fff;
    font-size:0.9em;
    line-height:1.4em;
    padding:10px 10px 10px 13px;
  }

  .box a {
    color:#f0f0f0;
  }

  .left {
    float:left;
    margin:0 15px 4px 0;
  }

  .right {
    float:right;
    margin:0 0 4px 15px;
  }

  .readmore {
    margin:-10px 10px 12px 0;
    text-align:right;
  }

  .timestamp {
    font-size:4.2em;
    margin:-5px 0 15px 10px;
  }

  .timestamp a {
    font-weight:normal;
  }

  .clear {
    clear:both;
  }

  .fade {
    color:#c5c5c5;
  }
  .mousewings {
    color:#808080;
  }
  .semi {
    color:#d02f00;
  }

  .gray {
    color:gray;
  }

  .photo {
    background:#fff;
    border:1px solid #bababa;
    margin:6px 18px 2px 5px;
    padding:2px;
  }
";
}

__END__
