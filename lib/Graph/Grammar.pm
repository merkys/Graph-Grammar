package Graph::Grammar;

use strict;
use warnings;

use parent Exporter::;

our @EXPORT = qw( NO_MORE_VERTICES );

use ChemOnomatopist::Util::Graph qw( graph_replace );
use Clone qw( clone );
use Graph::Grammar::Rule::NoMoreVertices;
use List::Util qw( first );
use Set::Object qw( set );

sub parse
{
    my( $graph, @rules ) = @_;

    my $changes = 1;

    MAIN:
    while( $changes ) {
        $changes = 0;

        for my $i (0..$#rules) {
            my $rule = $rules[$i];
            my @rule = @$rule;
            my $self_rule = shift @rule;
            my $action = pop @rule;

            VERTEX:
            for my $vertex ($graph->vertices) {
                next unless $self_rule->( $graph, $vertex );

                my @matching_neighbours;
                my $matching_neighbours = set();
                for my $i (0..$#rule) {
                    my $neighbour_rule = $rule[$i];
                    
                    if( ref $neighbour_rule eq 'CODE' ) {
                        my $match = first { !$matching_neighbours->has( $_ ) &&
                                            $neighbour_rule->( $graph, $_ ) }
                                          $graph->neighbours( $vertex );
                        next VERTEX unless $match;
                        push @matching_neighbours, $match;
                        $matching_neighbours->insert( $match );
                    } else {
                        next VERTEX unless $graph->degree( $vertex ) == @matching_neighbours;
                    }
                }

                print STDERR "apply rule $i\n";

                if( ref $action eq 'CODE' ) {
                    $action->( $graph, $vertex, @matching_neighbours );
                } else {
                    graph_replace( $graph, clone( $action ), $vertex );
                }
                $changes++;
            }
        }
    }

    return $graph;
}

sub NO_MORE_VERTICES { return Graph::Grammar::Rule::NoMoreVertices->new }

1;
