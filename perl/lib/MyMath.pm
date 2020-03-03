# MyMath.pm
#   Description


package MyMath;

use feature ':5.16';

use strict;
use warnings;
use English;

use Carp;
use Data::Dumper::Concise;

our $VERSION = 0.001001;

require Exporter;
our @ISA    = qw(Exporter);
our @EXPORT = qw(
    __sign
    quant
    int_root
    int_pow
    pow
    
);

sub __sign {
    my ($x) = @_;
    if    ( $x eq 0 ) { return 0; }
    elsif ( $x lt 0 ) { return -1; }
    elsif ( $x gt 0 ) { return 1; }
}

sub quant {
    my ($x)           = @_;
    my $numerator     = 1;
    my $denominator   = 1;
    my $threshold     = 0.00000001;
    my $accuracy      = 1;
    my $safety_limit  = 1000000;
    my $safety_count  = 0;
    my $calc_accuracy = sub {
        $accuracy = $x - ( $numerator / $denominator );
    };
    while ( $safety_count < $safety_limit ) {
        $safety_count++;
        ## do guess
        if ( $accuracy < -$threshold ) {
            $denominator++;
        }
        elsif ( $accuracy > $threshold ) {
            $numerator++;
        }
        else {
            return ( $numerator, $denominator );
        }
        $calc_accuracy->();
    }
    return ( $numerator, $denominator );
}

sub int_root {
    my ( $x, $n ) = @_;
    $n = int($n);
    
    my $result        = 1;
    my $accuracy      = 1;
    my $safety_count  = 0;
    my $safety_limit  = 1000000;
    my $threshold     = 0.000000000001;
    my $calc_accuracy = sub {
        my $shot = int_pow( $result, $n );
        $accuracy = $x - $shot;
    };
    while (abs($accuracy)
        && $threshold < abs($accuracy)
        && $safety_count < $safety_limit )
    {
        $safety_count++;
        carp("Exceeded safety ") unless ( $safety_count < $safety_limit );
        $calc_accuracy->();
        $result += $accuracy / ( $n * $x );
    }
    say "count $safety_count";

    return $result;
}

sub int_pow {
    my ( $x, $n ) = @_;
    $n = int($n);
    my $result = 1;
    while ( $n > 0 ) {
        $result *= $x;
        $n--;
    }
    return $result;
}

sub pow {
    my ( $x, $n ) = @_;
    my ( $a, $b ) = quant($n);
    return int_pow( int_root( $x, $b ), $a );
}

1;
