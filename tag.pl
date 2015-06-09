#!/usr/bin/env perl

# log2
# 2011-12-31 11:14
# by Ian D Brunton <iandbrunton at gmail dawt com>

use Modern::Perl;
use Pod::Usage;
use Log;

my $VERSION = '1.0.2';

#if (! $ARGV[0]) { pod2usage (-exitval => 1, -verbose => 1); }

my $log = Log->new ();

$log->parse_rc;

my $input = join (' ', @ARGV);

my $opts = {
    'h' => 'help',
    'l' => 'list',
    'r' => 'remove',
    'y' => 'year',
};

$log->getopts ($opts, \$input);

if ($log->opt ('help')) {
    pod2usage (-exitstatus => 0, -verbose => 2);
}

# because I often miss the - when intending -l
if ($input =~ /(\bl\b)/) {
    $input =~ s/$1//;
    $log->set_opt ('list');
}

$log->parse_datetime (\$input);
my %files = ( "total" => $log->log_dir . 'tags',
    	      "year"  => $log->log_dir . $log->year . '/tags',
);

my $used_tags;
foreach my $file (keys %files) {
    if (-e $files{$file}) {
    	open (TAGFILE, "<", $files{$file}) or die ("Cannot open tag file: $!");
    	my @tags = <TAGFILE>;
    	close (TAGFILE);

    	foreach (@tags) {
	    $_ =~ s/\n//;
	    if ($_ =~ m/^(\#[\w-]+)\t(\d+)$/) {
	    	$used_tags->{$file}->{$1} = $2;
	    }
	    else { next; }
    	}
    }
}

if ($input) {
    $input =~ s/\n//;

    my @newtags = split (/ /, lc ($input));
    foreach (@newtags) {
	$_ = '#' . $_;
    }

    my $logfile = $log->file_path;
    open (LOGFILE, "<", $logfile) or die ("Cannot open log file: $!");
    my @lines = <LOGFILE>;
    close (LOGFILE);

    # removing a tag:
    if ($log->opt('remove')) {
	foreach my $t (@newtags) {
	    if ($lines[2] =~ m/$t/) {
		$lines[2] =~ s/$t//;
		$lines[2] =~ s/  / /g;
		$lines[2] =~ s/ $//;
	    }
	}

	if ($lines[2] =~ m/^$/) {
	    splice(@lines, 2, 1);
	}

    	open (LOGFILE, ">", $logfile) or die ("Cannot open log file: $!");
    	foreach (@lines) {
	    print LOGFILE $_;
    	}
    	close (LOGFILE);

	foreach my $f (keys %files) {
	    foreach my $t (@newtags) {
	    	$used_tags->{$f}->{$t} -= 1;
		if ($used_tags->{$f}->{$t} <= 0) {
		    delete $used_tags->{$f}->{$t};
		}
	    }

	    open(TAGFILE, ">", $files{$f}) or die ("Cannot open tag file: $1");
	    foreach (sort keys %{$used_tags->{$f}}) {
		print TAGFILE $_, "\t", $used_tags->{$f}->{$_}, "\n";
	    }
	    close(TAGFILE);
	}
    }
    else {
    	# check for duplicates:
    	foreach (@newtags) {
	    if ($lines[2] =~ m/$_/) {
	    	my $nt = join (' ', @newtags);
	    	$nt =~ s/$_//;
	    	@newtags = split (/ /, $nt);
	    }
    	}

    	if ($#newtags >= 0) {	# still new tags left after removing duplicates
	    foreach my $f (keys %files) {
    	    	foreach my $t (@newtags) {
	    	    $used_tags->{$f}->{$t} += 1;
    	    	}

    	    	open (TAGFILE, ">", $files{$f}) or die ("Cannot open tag file: $!");
    	    	foreach (sort keys %{$used_tags->{$f}}) {
	    	    print TAGFILE $_, "\t", $used_tags->{$f}->{$_}, "\n";
    	    	}
    	    	close (TAGFILE);
    	    }
       	   
    	    if ($lines[2] =~ m/^(\#[-a-z]+ ?){1,}$/) {
	    	$lines[2] =~ s/\n//;
	    	$lines[2] .= ' ' . join (' ', @newtags) . "\n";
    	    } else {
	    	splice (@lines, 2, 0, join (' ', @newtags), "\n\n");
    	    }

    	    open (LOGFILE, ">", $logfile) or die ("Cannot open log file: $!");
    	    foreach (@lines) {
	    	print LOGFILE $_;
    	    }
    	    close (LOGFILE);
    	}
    }
} elsif ($log->opt ('list')) {	# list all used tags, from most to least often used
    my $f;
    if ($log->opt ('year')) { $f = "year"; } else { $f = "total"; }

    my $tag; my $count;
    format STDOUT = 
@<<<<<<<<<<<<<<<<<<<< @>>>>
$tag,            $count
.
    foreach (sort {$used_tags->{$f}->{$b} <=> $used_tags->{$f}->{$a}} keys %{$used_tags->{$f}}) { 
	$tag = $_;
	$count = $used_tags->{$f}->{$_};
	write;
    }
} else {			# just return tags for given date
    my $tags_printed = 0;
    open (FILE, "<", $log->file_path) or die ("Cannot open log file: $!");
    my @lines = <FILE>;
    close (FILE);

    if ($lines[0] =~ m/^\w+, \d{2} \w+, \d{4}$/) {
	print $log->date_markup ($lines[0]);
    }
		
    if ($lines[2] =~ m/^(\#[-a-z]+ ?){1,}$/) {
	print $log->comment_markup ($lines[2]);
    } else {
	say "No tags"
    }
}
