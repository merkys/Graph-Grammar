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
    my $self = shift;
    return $self->{code}->( @_ );
}

1;
