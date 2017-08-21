package IDB;

=head1 NAME

IDB - contains miscellaneous subs

=cut

sub double_digit {
    my $int = shift;
    return $int < 10 ? '0' . $int : $int;
}

sub year {
    my $int = shift;
    return $int + 1900;
}

sub wkday {
    # Returns the abbreviated weekday.
    my $int = shift;
    my @days = ('Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat');
    return $days[$int];
}

sub weekday {
    # Returns the full weekday.
    my $int = shift;
    my @days = ('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday');
    return $days[$int];
}

sub mon {
    # Returns the abbreviated month name
    my $int = shift;
    my @months = ('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep',
	'Oct', 'Nov', 'Dec');
    return $months[$int];
}

sub month {
    # Returns the full month name
    my $int = shift;
    my @months = ('January', 'February', 'March', 'April', 'May', 'June', 'July',
	'August', 'September', 'October', 'November', 'December');
    return $months[$int];
}

sub filedate {
    # Returns a date string suitable for filenames.
    # Optional arg is the char to join numbers.  Default is `-'.
    my $j = '-';
    if (@_) { $j = shift; }
    return join ($j, &IDB::year ((localtime(time))[5]),
	&IDB::double_digit ((localtime(time))[4] + 1),
	&IDB::double_digit ((localtime(time))[3]));
}

sub nicedate {
    my $s = &IDB::weekday . ', ';
    $s .= &IDB::double_digit ((localtime(time))[3]) . ' ';
    $s .= &IDB::month ((localtime(time))[4] + 1) . ', ';
    $s .= &IDB::year ((localtime(time))[5]);

    return $s;
}

sub shortdate {
    my $s = &IDB::double_digit ((localtime(time))[3]) . ' ';
    $s .=   &IDB::mon ((localtime(time))[4]) . ' ';
    $s .=   &IDB::year ((localtime(time))[5]);

    return $s;
}

1;
