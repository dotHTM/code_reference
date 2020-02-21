# PaperFoldedStrip.pm
#
#   Started by Mike Cramer

package PaperFoldedStrip;
use Moose;    # automatically turns on strict and warnings

has 'private_fold_lists' => (
    is      => 'rw',
    isa     => 'ArrayRef[ArrayRef[Int]]',
    reader  => 'fold_lists',
    default => sub { [] },
);

sub append_fold_lists {
    my ( $self, $new_value ) = @_;
    push @{ $self->fold_lists() }, $new_value;
    return $self->fold_lists();
}    ##  fold_lists

sub current_iteration() {
    my ($self) = @_;

    return scalar @{ $self->fold_lists() };
}    ## current_iteration

sub flat_fold_list ($) {
    my ( $self, $thruthru_iteration ) = @_;
    my @result = ();

    $thruthru_iteration = $self->current_iteration unless $thruthru_iteration;

    if ( $thruthru_iteration <= $self->current_iteration ) {
        for ( my $index = 0; $index < $thruthru_iteration; $index++ ) {

            my @sub_fold_list = @{ @{ $self->fold_lists }[$index] };

            push @result, @sub_fold_list;
        }
    }
    return @result;
}    ## flatFoldList

sub last_fold_list_length {
    my ($self) = @_;
    return scalar $self->flat_fold_list;
}

no Moose;
__PACKAGE__->meta->make_immutable;
