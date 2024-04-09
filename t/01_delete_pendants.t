#!/usr/bin/perl

use strict;
use warnings;

use Graph::Grammar;
use Graph::Undirected;
use Test::More;

my @delete_pendants = (
    [ sub { $_[0]->degree( $_[1] ) == 1 }, sub { $_[0]->delete_vertex( $_[1] ) } ],
);

plan tests => 3;

my $g = Graph::Undirected->new;
$g->add_cycle( 1..6 );

parse_graph( $g, @delete_pendants );
is scalar $g->vertices, 6;

for (1..6) {
    $g->add_edge( $_, 10 + $_ );
}
is scalar $g->vertices, 12;

parse_graph( $g, @delete_pendants );
is scalar $g->vertices, 6;
