package Graph::Grammar::Rule::NoMoreVertices;

# ABSTRACT: Marker for rules where no more vertices are allowed
# VERSION

use strict;
use warnings;

sub new
{
    my $class = shift;
    return bless {}, $class;
}

1;
