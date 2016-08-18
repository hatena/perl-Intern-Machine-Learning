package Intern::ML::CLI;
use strict;
use warnings;

use Path::Tiny qw(path);

sub commands {
    my $path = $INC{(__PACKAGE__ =~ s!::!/!gr) . '.pm'} =~ s/[.]pm$//r;
    my @commands = map {
        lc ($_ =~ s!(?:^.*/|[.]pm$)!!gr);
    } grep {
        $_ =~ /[.]pm$/;
    } path($path)->children;
    return @commands;
}

1;
__END__
