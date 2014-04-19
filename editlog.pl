#!/usr/bin/env perl

use Modern::Perl;
use Pod::Usage;

use Log;

my $input = join (' ', @ARGV);

my $log = Log->new;
$log->parse_rc;
$log->getopts ('ah', \$input);

if ($log->opt ('h')) {
    pod2usage (-exitstatus => 0, -verbose => 2);
}

my $action = $log->{editor} // $ENV{EDITOR} // '/usr/bin/env vim';
my $alternate = $log->{alternate_editor} // 'emacsclient';

# opt 'a' does something different from other log scripts:
if ($log->opt ('a')) {
    $action = $alternate;
}

$log->parse_datetime (\$input);

my $file = $log->file_path;
if (-e $file) {
    $action .= " $file";
    exec ($action);
} else {
    if ($log->editlog_create_new) {
    	open (FILE, ">>", $file) or die ("Cannot open file `$file': $!");
    	print FILE $log->date_string, "\n\n";
    	close (FILE);
    	if ($log->{extension} ne '' && $log->{extension_hook}) {
	    my $date = $log->date;
	    my $cmd = $log->{extension_hook};
	    my $x = $log->{extension};
	    $x =~ s/\.//;
	    $cmd =~ s/%e/$x/x;
	    $cmd =~ s/%d/$date/x;
	    system ($cmd);
    	}

    	$action .= " $file";
    	exec ($action);
    } else {
    	print "File `$file' does not exist.\n";
    }
}

__END__

=head1 NAME

editlog - command-line log/journal editing

=head1 VERSION

2.1

=head1 SYNOPSIS

 editlog [-a] [YYYY/MM/DD] [diff]
 editlog 10/03
 editlog -J 06 -1

=head1 DESCRIPTION

F<editlog> makes it easy to open files generated by this package's F<log>
program for editing.  Files will be opened in the editor specified by the
F<logrc> file's F<editor> setting, or, if that setting does not exist, in
$EDITOR.  If $EDITOR is not defined, editlog will default to F</usr/bin/vim>.

=head1 OPTIONS

=over 8

=item B<-a>

Opens the file with the program specified as F<alternate_editor> in the
F<logrc> file (see documentation for the main F<log> script).  The default
is F<emacsclient>.

=item B<-h>

Prints this documentation.

=back

=head1 AUTHOR

Written by Ian D. Brunton

=head1 REPORTING BUGS

Report Log bugs to iandbrunton at gmail. com.

=head1 COPYRIGHT

Copyright 2011--13 Ian D. Brunton.

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
