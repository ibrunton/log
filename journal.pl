#!/usr/bin/env perl

# log
# 2015-09-08 13:10
# by Ian D Brunton <iandbrunton at gmail dawt com>

use Modern::Perl;
use Pod::Usage;
use Log;

my $VERSION = '0.1';

my $log = Log->new();
$log->parse_rc;
my $input = join(' ', @ARGV);

my $opts = {
    'a' => 'alternate_editor',
    'h' => 'help',
    'i' => 'indent',
};

$input = '-J ' . $input;
$log->getopts($opts, \$input);
#$log->set_opt('J');

if ($log->opt('help')) { pod2usage (-exitstatus => 0, -verbose => 2); }
$log->parse_datetime(\$input);

if ($input =~ /\w+/) {
    my $action = $ENV{HOME} . '/bin/llg -Jtfb "' . $input . '"';
    exec($action);
}
else {
    my $action = $log->{editor} // $ENV{EDITOR} // '/usr/bin/env vim';
    my $alternate = $log->{alternate_editor} // 'emacsclient';

    if ($log->opt('alternate_editor')) {
	$action = $alternate;
    }
    my $file = $log->file_path;
    $action .= ' ' . $file;
    if (-e $file) {
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
	    	my $X = uc($x);
	    	$x =~ s/\.//;
	    	$cmd =~ s/%e/$x/x;
	    	$cmd =~ s/%E/$X/x;
	    	$cmd =~ s/%d/$date/x;
	    	system ($cmd);
    	    }

    	    exec ($action);
    	} else {
    	    print "File `$file' does not exist.\n";
    	}
    }
}
