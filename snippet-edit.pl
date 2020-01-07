#!/usr/bin/env perl

# log
# 2017-03-25 07:54
# by Ian D Brunton <iandbrunton at gmail dawt com>

use Modern::Perl;
use Pod::Usage;
use Log;

my $VERSION = '0.1a';

if (! $ARGV[0]) { pod2usage (-exitval => 1, -verbose => 1); }

my $log = Log->new ();

$log->parse_rc;

my $opts = {
};
