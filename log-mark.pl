#!/usr/bin/env perl

# log
# 2016-11-22 12:41
# by Ian D Brunton <iandbrunton at gmail dawt com>

use Modern::Perl;
use Pod::Usage;

use Log;

my $VERSION = '0.1';

if (! $ARGV[0]) { pod2usage (-exitval => 1, -verbose => 1); }

my $log = Log->new();

$log->parse_rc;

my $pattern = '#+MARK';

if ($ARGV[0] =~ m/^\+\w+/) {
    $pattern .= shift (@ARGV);
}
$pattern =~ s/\#/\\\#/g;
$pattern =~ s/\+/\\\+/g;

my $input = join (' ', @ARGV);
my $cmd = $ENV{HOME} . '/bin/llg';
my $flags = ' -a -f -m -s ';

$log->parse_datetime (\$input);

my $new = `$cmd $flags $input`;

my $file_path = $log->file_path;

if (! -e $file_path && ! $log->opt ('file_path')) {
    print "File $file_path does not exist.\n\n";
    exit (0);
}

open (FILE, "<", $file_path) or die ("Can't open file $file_path: $!");
my @lines = <FILE>;
close (FILE);

my $found = 0;
foreach (@lines) {
    $found = $_ =~ s/$pattern/$new/;
    last if ($found == 1);
}

if ($found == 0) {	# no #+MARK found, so just add input as is.
    exec ($cmd . ' ' . $input);
}

open (FILE, ">", $file_path) or die ("Can't open file $file_path: $!");
foreach (@lines) {
    print FILE $_;
}
close (FILE);

exit (0);

__END__

=head1 NAME

log-mark

=head1 VERSION

0.1

=head1 SYNOPSIS

log-mark.pl [OPTIONS] [DATE] [TEXT]

=head1 DESCRIPTION

=head1 OPTIONS

See documentation for log.pl

=head1 AUTHOR

Written by Ian D. Brunton

=head1 REPORTING BUGS

Report bugs to iandbrunton at gmail dot com

=head1 COPYRIGHT

Copyright 2016 Ian D. Brunton.

This file is part of Log.

Log is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public Licence as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Log is distrubuted in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Log.  If not, see <http://www.gnu.org/licenses/>.

=cut
