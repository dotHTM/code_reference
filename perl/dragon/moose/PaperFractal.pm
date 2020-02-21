# PaperFractal.pm
#
#   Started by Mike Cramer
#   Started on 2017-05-22

package PaperFractal;
use Moose;    # automatically turns on strict and warnings


extends 'PaperFoldedStrip';

sub next_iteration() {
    my ($self) = @_;
    my @new_folds = (1);
    $self->append_fold_lists( \@new_folds);
}    ## next_iteration

sub iteration_up_to ($) {
    my ($self, $some_iteration) = @_;
    while ( $self->current_iteration < $some_iteration ) {
        $self->next_iteration;
    }
}    ## iteration_up_to

no Moose;
__PACKAGE__->meta->make_immutable;


