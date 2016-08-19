package Intern::ML::CLI::Iris;
use strict;
use warnings;

use parent qw(Intern::ML::CLI);
use Intern::ML::Classification::Perceptron;
use Intern::ML::Evaluation::F1;

use constant TARGET_LABEL => 'Iris-setosa';
use constant ITERATION => 1;

sub show_help {
    my @name = split '::', __PACKAGE__;
    my $name = lc pop @name;
    printf "$name <training data set> <test data set> [<size>]\n";
}

sub run {
    my ($class, @args) = @_;

    if (@args < 2) {
        $class->show_help;
        return;
    }
    my ($training_set, $test_set, $n) = @args;

    my $classifier = Intern::ML::Classification::Perceptron->new;
    my $eval_training = Intern::ML::Evaluation::F1->new;
    my $eval_test = Intern::ML::Evaluation::F1->new;

    do {
        my @training_set;
        my $t = 0;
        $class->with_data_set($training_set, TARGET_LABEL, sub {
            my ($data) = @_;
            push @training_set, $data if !defined($n) || $t++ < $n;
        });

        $classifier->train(@training_set) for 1..ITERATION;
        $class->_evaluate($classifier, \@training_set, $eval_training);
    };

    do {
        my @test_set;
        $class->with_data_set($test_set, TARGET_LABEL, sub {
            my ($data) = @_;
            push @test_set, $data;
        });

        $class->_evaluate($classifier, \@test_set, $eval_test);
    };

    printf "%f %f\n", $eval_training->accuracy, $eval_test->accuracy;
}

sub _evaluate {
    my ($class, $classifier, $dataset, $evaluator) = @_;
    for my $data (@$dataset) {
        my $predicted = $classifier->predict(@{$data->{features}});
        my $supervised = $data->{label};
        $evaluator->add($predicted, $supervised);
    }
}

1;
__END__
