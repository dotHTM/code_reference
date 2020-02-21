# dragonBrain.pm
#   Dragon Fractal Model
#
#   Started by Mike Cramer
#   Started on 2017-05-19

package DragonFractal ;
use Moose;    # automatically turns on strict and warnings

extends 'PaperFractal';

sub next_iteration() {
    my $self     = shift ;
    my @new_folds = ( 1 ) ;

    foreach
        my $sub_fold_item ( reverse $self->flat_fold_list ( $self->current_iteration () ) )
    {
        if   ( $sub_fold_item == 1 ) { push @new_folds, 0 ; }
        else                       { push @new_folds, 1 ; }
    }

    $self->append_fold_lists( \@new_folds );
}    ## nextIteration

1 ;
