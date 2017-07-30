#!/usr/bin/env perl

# Join the last 2 lines of the log file.
# 2017-07-30 07:18
# by Ian D Brunton <iandbrunton at gmail dawt com>

use Modern::Perl;
use Pod::Usage;
use Text::Wrap;
use Log;

my $VERSION = '0.1';

if (! $ARGV[0]) { pod2usage (-exitval => 1, -verbose => 1); }

my $log = Log->new();

$log->parse_rc;

my $input = join (' ', @ARGV);

my $opts = {
    'a' => 'no_newline',
    'c' => 'comment',
    'n' => 'append_time',
    's' => 'no_write',
    'w' => 'no_wrap',
};

$log->getopts ($opts, \$input);

if ($log->opt ('help')) { pod2usage (-exitstatus => 0, -verbose => 2); }

$Text::Wrap::columns = $log->line_length;
