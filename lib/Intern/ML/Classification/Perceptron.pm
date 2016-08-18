package Intern::ML::Classification::Perceptron;
use strict;
use warnings;

use Intern::ML::Model::Label;
use Class::Accessor::Lite (
    new => 1,
);

sub train {
    my ($self, @data) = @_;
    # ここに学習アルゴリズムを実装
}

sub predict {
    my ($self, @features) = @_;
    # ここを変更して判別アルゴリズムを実装
    return Intern::ML::Model::Label::Positive;
}

1;
__END__
