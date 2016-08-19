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
    $class->with_data_set($dh, 'Foo', sub {
        my ($data) = @_;
        my $predicted = $data->{features}->[0] == 1
            ? Intern::ML::Model::Label::Positive
            : Intern::ML::Model::Label::Negative;
        my $supervised = $data->{label};
        $eval->add($predicted, $supervised);
    });

    printf "%f\n", $eval->accuracy;
}

1;
__DATA__
1,2,3,4,Foo
5,6,7,8,Foo
1,3,5,7,Foo
2,4,6,8,Foo
1,1,2,3,Bar
1,4,1,4,Foo
1,7,3,2,Bar
3,1,4,1,Bar
2,7,1,8,Foo
