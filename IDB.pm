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

1;
