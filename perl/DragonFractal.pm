# dragonBrain.pm
#   Dragon Fractal Model
#
#   Started by Mike Cramer
#   Started on 2017-05-19

package DragonFractal ;

# use 5.18.0;
use strict ;

use parent 'PaperFractal' ;

sub nextIteration() {
    my $self     = shift ;
    my @newFolds = ( 1 ) ;

    foreach
        my $subFoldItem ( reverse $self->flatFoldList ( $self->currentIteration () ) )
    {
        if   ( $subFoldItem == 1 ) { push @newFolds, 0 ; }
        else                       { push @newFolds, 1 ; }
    }

    push @{ $self->foldLists }, \@newFolds ;
}    ## nextIteration

1 ;
