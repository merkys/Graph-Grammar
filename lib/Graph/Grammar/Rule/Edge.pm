package Graph::Grammar::Rule::Edge;

# ABSTRACT: Rule to be evaluated on graph edges
# VERSION

use strict;
use warnings;

sub new
{
    my( $class, $code ) = @_;
    return bless { code => $code }, $class;
}

sub matches
{
    my( $self, $a, $b ) = @_;
    return $self->{code}->( $a, $b );
}

1;
