package Intern::ML::Model::Label;
use strict;
use warnings;

use Class::Accessor::Lite (
    ro => [qw(_value)],
);

sub _new {
    my ($class, %args) = @_;
    return bless \%args, $class;
}

use constant Positive => __PACKAGE__->_new(_value => 1);
use constant Negative => __PACKAGE__->_new(_value => -1);

sub is_positive {
    return $_[0]->_value > 0;
}

sub is_negative {
    return $_[0]->_value < 0;
}

sub equals {
    my ($self, $other) = @_;
    return $self->_value * $other->_value > 0;
}

sub as_int {
    return $_[0]->_value;
}

1;
__END__
