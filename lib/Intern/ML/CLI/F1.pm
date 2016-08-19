package Intern::ML::CLI::F1;
use strict;
use warnings;

use parent qw(Intern::ML::CLI);
use Intern::ML::Model::Label;
use Intern::ML::Evaluation::F1;

sub run {
    my ($class) = @_;
    my $eval = Intern::ML::Evaluation::F1->new;

    my $dh = \*DATA;
    for my $line (<$dh>) {
        chomp $line;
        last unless $line;

        my ($predicted, $supervised) = map {
            $_ eq 'Positive'
                ? Intern::ML::Model::Label::Positive
                : Intern::ML::Model::Label::Negative;
        } split ',', $line;
        $eval->add($predicted, $supervised);
    }

    printf "%f\n", $eval->accuracy;
}

1;
__DATA__
Positive,Positive
Negative,Positive
Positive,Positive
Negative,Positive
Positive,Negative
Positive,Positive
Positive,Negative
Negative,Negative
Negative,Positive
