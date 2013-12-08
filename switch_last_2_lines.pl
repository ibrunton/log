#!/usr/bin/env perl

# log2
# swaps the last 2 lines of the log file
# 2012-09-29 12:48
# by Ian D Brunton <iandbrunton at gmail dawt com>

use Modern::Perl;
use Log;

my $VERSION = '0.1';

my $log = Log->new();
$log->parse_rc;
my $input = join (' ', @ARGV);
$log->getopts ('h', \$input);
if ($log->opt( 'h' )) { pod2usage (-exitstatus => 0, -verbose => 2); }
$log->parse_datetime (\$input);

my $file = $log->file_path || print "no file path\n";
if (! -e $file) {
    print "File $file does not exist.\n\n";
    exit (0);
}

open (FILE, "<", $file) or die ("Can't open file $file: $!");
my @lines = <FILE>;
close (FILE);

my $tmp = $lines[$#lines];
$lines[$#lines] = $lines[$#lines - 1];
$lines[$#lines - 1] = $tmp;

open (FILE, ">", $file) or die ("Can't open file $file: $!");
foreach (@lines) {
    print FILE $_;
}
close (FILE);

exit (0);
