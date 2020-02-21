# PaperFoldedStrip.pm
#
#   Started by Mike Cramer
#   Started on 2017-05-22

package PaperFoldedStrip ;

# use 5.18.0;
use strict ;

sub new {
    my $inv = shift ;
    my $class = ref ( $inv ) || $inv ;

    my $self = {} ;
    bless ( $self, $class ) ;

    $self->foldLists ( [] ) ;
    return $self ;
}    ## new

sub foldLists {
    my $self = shift ;
    if ( @_ ) {
        $self->{ foldLists } = shift ;
    }
    return $self->{ foldLists } ;
}

sub currentIteration() {
    my $self        = shift ;
    my $arrayLength = @{ $self->foldLists } ;
    return $arrayLength ;
}    ## currentIteration

sub flatFoldList ($) {
    my $self                  = shift ;
    my ( $thruthruIteration ) = @_ ;
    my @result                = () ;

    $thruthruIteration = $self->currentIteration unless $thruthruIteration ;

    if ( $thruthruIteration <= $self->currentIteration ) {
        for ( my $index = 0 ; $index < $thruthruIteration ; $index++ ) {

            my @subFoldList = @{ @{ $self->foldLists }[ $index ] } ;

            push @result, @subFoldList ;
        }
    }
    return @result ;
}    ## flatFoldList

sub lastFoldListLength {
    my $self   = shift ;
    my $length = $self->flatFoldList ;
    return $length;
}

1 ;
