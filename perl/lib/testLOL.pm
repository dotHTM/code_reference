#!/usr/bin/env perl
# testLOL.pm
#   Description

use feature ':5.16';

use strict;
use warnings;
use English;

use Carp;
use Data::Dumper::Concise;

use lib "./";
use ListOfLists;
use MyMath;

my $a = [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 0 ];

my $incrementor = 1;

# say Dumper chain_ex(
#     $a,
#     map_cc( sub { $incrementor += 1.1; return pow( shift, $incrementor ) } ),
#     filter_cc( sub { (shift) > 100 } ),
#     filter_cc( sub { (shift) < 10000 } ),
# );

# say pow( 45.123, 134.2348 );

# my $b = [];
# foreach my $i ( 1 ... 100 ) {
#     push @{$b}, int( rand(10) );
# }

# say Dumper count_seen($b);

my $list        = {};
my $listTwoChar = {};

foreach my $i ( 1 ... 10000 ) {

    my $shuffled_deck = chain_ex( $a, shuffle_cc() );

    my $position_hash = chain_ex(
        $shuffled_deck,
        reduce_cc(
            sub {
                my ( $r, $e ) = @_;
                foreach my $k ( keys %{$r} ) {
                    $r->{$k} += 1;
                }
                $r->{$e} = 0;
                return $r;
            },
            {}
        )
    );

    foreach my $element ( @{$a} ) {
        push @{ $list->{$element} }, $position_hash->{$element};
    }

    my $pack = join '', @{$shuffled_deck};
    foreach my $index ( 1 ... ( scalar @{$a} ) ) {
        $listTwoChar->{  substr $pack, $index, 2 } += 1;
    }

}

foreach my $element ( @{$a} ) {
    say $element . " at position ";
    say Dumper count_seen( $list->{$element} );
}

say Dumper $listTwoChar;

