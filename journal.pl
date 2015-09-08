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
    $action .= ' ' . $log->file_path;
    exec($action);
}
