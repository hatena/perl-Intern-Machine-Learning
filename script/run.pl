use strict;
use warnings;

use Path::Tiny qw(path);
use Module::Load qw(load);

my $Root = path(__FILE__)->parent->parent->absolute;
unshift @INC, glob $Root->child(qw(modules * lib));
unshift @INC, $Root->child(qw(lib)).q();

my $CLI = 'Intern::ML::CLI';

my $subcommand = shift @ARGV
    or &help;
my $module = join '::', $CLI, ucfirst $subcommand;

eval { load $module };
$@ and do {
    my $err = $@;
    $err =~ /compilation aborted/ and warn $err;
    &help;
};

$module->run(@ARGV);

sub help () {
    load $CLI;
    printf "Commands:\n  %s\n", join "\n  ", $CLI->commands;
    exit;
}
