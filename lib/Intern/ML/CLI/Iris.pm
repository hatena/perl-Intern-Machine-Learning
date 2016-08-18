package Intern::ML::CLI::Iris;
use strict;
use warnings;

use Intern::ML::Model::Label;
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
        $class->_with_data_set($training_set, sub {
            my ($data) = @_;
            push @training_set, $data if !defined($n) || $t++ < $n;
        });

        $classifier->train(@training_set) for 1..ITERATION;
        $class->_evaluate($classifier, \@training_set, $eval_training);
    };

    do {
        my @test_set;
        $class->_with_data_set($test_set, sub {
            my ($data) = @_;
            push @test_set, $data;
        });

        $class->_evaluate($classifier, \@test_set, $eval_test);
    };

    printf "%f %f\n", $eval_training->accuracy, $eval_test->accuracy;
}

sub _label_of {
    my ($class, $label) = @_;
    return $label eq TARGET_LABEL
        ? Intern::ML::Model::Label::Positive
        : Intern::ML::Model::Label::Negative;
}

sub _with_csv {
    my ($class, $file, $handler) = @_;
    open my $fh, '<', $file
        or die "Cannot open '$file': $!";
    while (my $line = <$fh>) {
        chomp $line;
        next unless $line;
        $handler->(split ',', $line);
    }
    close $fh;
}

sub _with_data_set {
    my ($class, $file, $handler) = @_;
    $class->_with_csv($file, sub {
        my (@features) = @_;
        my $label = pop @features;
        $handler->({
            features => \@features,
            label => $class->_label_of($label)
        });
    });
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
