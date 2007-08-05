#!perl -T
use strict;
use warnings;
use Test::More tests => 7;

tie my $tot => 'Tie::Scalar::ThisOrThat', 'this', 'that';

my %seen;
for (1..100)
{
    $seen{$tot} = 1;
}
ok($seen{this}, "saw 'this'");
ok($seen{that}, "saw 'that'");
is(keys %seen, 2, "saw ONLY 'this' and 'that'");

$tot = 'the other';
for (1..100)
{
    $seen{$tot} = 1;
}
ok($seen{this}, "saw 'this'");
ok($seen{that}, "saw 'that'");
ok($seen{'the other'}, "saw 'the other'");
is(keys %seen, 3, "saw ONLY 'this', 'that', and 'the other'");

package Tie::Scalar::ThisOrThat;
use parent 'Tie::Scalar::AsArray';

sub BUILD {
    my $self = shift;
    @$self = @_;
}
sub FETCH {
    my ($self) = @_;
    $self->[rand 2]
}
sub STORE {
    my ($self, $value) = @_;
    $self->[rand 2] = $value;
}

