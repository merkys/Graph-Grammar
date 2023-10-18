package Graph::Grammar;

use strict;
use warnings;

use ChemOnomatopist::Util::Graph qw( graph_replace );

sub parse
{
    my( $graph, @rules ) = @_;

    my $changes = 1;

    MAIN:
    while( $changes ) {
        $changes = 0;

        for my $rule (@rules) {
            my @rule = @$rule;
            my $self_rule = shift @rule;
            my $action = pop @rule;

            VERTEX:
            for my $vertex ($graph->vertices) {
                next unless $self_rule->( $graph, $vertex );

                my @matching_neighbours;
                for my $i (0..$#rule) {
                    my $neighbour_rule = $rule[$i];
                    
                    if( ref $neighbour_rule eq 'CODE' ) {
                        my @matches = grep { $neighbour_rule->( $graph, $_ ) } $graph->neighbours( $vertex );
                        next VERTEX unless @matches;
                        die "more than one hit\n" if @matches > 1;
                        push @matching_neighbours, @matches;
                    } else {
                        next VERTEX unless $graph->degree( $vertex ) == @matching_neighbours;
                    }
                }

                if( ref $action eq 'CODE' ) {
                    $action->( $graph, $vertex, @matching_neighbours );
                } else {
                    graph_replace( $graph, $action, $vertex );
                }
                $changes++;
            }
        }
    }

    return $graph;
}

1;
