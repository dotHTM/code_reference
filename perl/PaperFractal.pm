# PaperFractal.pm
#
#   Started by Mike Cramer
#   Started on 2017-05-22

package PaperFractal ;

# use 5.18.0;
use strict ;

use parent 'PaperFoldedStrip' ;

sub nextIteration() {
    my $self     = shift ;
    my @newFolds = ( 1 ) ;

    push @{ $self->foldLists }, \@newFolds ;
}    ## nextIteration

sub iterationUpTo ($) {
    my $self = shift ;
    my ( $someIteration ) = @_ ;
    while ( $self->currentIteration < $someIteration ) {
        $self->nextIteration ;
    }
}    ## iterationUpTo

1 ;
