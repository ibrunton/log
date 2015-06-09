#!/usr/bin/env perl

# log2
# swaps the last 2 lines of the log file
# 2012-09-29 12:48
# by Ian D Brunton <iandbrunton at gmail dawt com>

use Modern::Perl;
use Pod::Usage;
use Log;

my $VERSION = '0.2';

my $log = Log->new();
$log->parse_rc;
my $input = join (' ', @ARGV);
$log->getopts ({'h' => 'help'}, \$input);
if ($log->opt( 'help' )) { pod2usage (-exitstatus => 0, -verbose => 2); }
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

__END__

=head1 NAME

switch_last_2_lines.pl

=head1 VERSION

0.2

=head1 SYNOPSIS

switch_last_2_lines.pl [OPTIONS] [YYYY/MM/DD] [DIFFERENTIAL]

=head1 DESCRIPTION

This script simply switches the last two lines of the relevant log file.

=head2 DATES, DIFFERENTIALS

See documentation for log.pl

=head1 AUTHOR

Written by Ian D. Brunton

=head1 REPORTING BUGS

Report bugs to iandbrunton at gmail.com

=head1 COPYRIGHT

Copyright 2011-2015 Ian D. Brunton.

This file is part of Log.

Log is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Log is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Log.  If not, see <http://www.gnu.org/licenses/>.

=cut
