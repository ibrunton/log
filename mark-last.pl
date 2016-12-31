#!/usr/bin/env perl

# log
# 2016-12-31 18:02
# by Ian D Brunton <iandbrunton at gmail dawt com>

use Modern::Perl;
use Pod::Usage;

use Log;

my $VERSION = '0.1';

#if (! $ARGV[0]) { pod2usage (-exitval => 1, -verbose => 1); }

my $log = Log->new();

$log->parse_rc;

my $pattern = ' #+MARK';

if ($ARGV[0] && $ARGV[0] =~ m/^\+\w+/) {
    $pattern .= shift (@ARGV);
}

my $input = join (' ', @ARGV);

$log->parse_datetime (\$input);

my $file_path = $log->file_path;

if (! -e $file_path && ! $log->opt ('file_path')) {
    print "File $file_path does not exist.\n\n";
    exit (0);
}

open (FILE, "<", $file_path) or die ("Can't open file $file_path: $!");
my @lines = <FILE>;
close (FILE);

$lines[$#lines] =~ s/(.*)$/$1$pattern/;

open (FILE, ">", $file_path) or die ("Can't open file $file_path: $!");
foreach (@lines) {
    print FILE $_;
}
close (FILE);

exit (0);

__END__
