package Intern::ML::CLI;
use strict;
use warnings;

use Intern::ML::Model::Label;
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

sub with_csv {
    my ($class, $file, $handler) = @_;
    my $fh;
    if (ref $file) {
        $fh = $file;
    } else {
        open $fh, '<', $file
            or die "Cannot open '$file': $!";
    }
    while (my $line = <$fh>) {
        chomp $line;
        next unless $line;
        $handler->(split ',', $line);
    }
    close $fh;
}

sub with_data_set {
    my ($class, $file, $target_label, $handler) = @_;
    $class->with_csv($file, sub {
        my (@features) = @_;
        my $label = pop @features;
        $handler->({
            features => [ 1, @features ],
            label => ($label eq $target_label
                      ? Intern::ML::Model::Label::Positive
                      : Intern::ML::Model::Label::Negative),
        });
    });
}

1;
__END__
