package Intern::ML::Evaluation::F1;
use strict;
use warnings;

use Class::Accessor::Lite (
    new => 1,
);

sub add {
    my ($self, $predicted, $supervised) = @_;
    # ここでtrue/false positive/negativeを集計
}

sub accuracy {
    my ($self) = @_;
    # ここを変更してF1スコアを計算
    return 0;
}

1;
__END__
