# Convenience.pm
#   Description
#
#   Started by Mike Cramer
#   Started on DATE

package Convenience ;

# use 5.18.0;
use strict ;

our ( @ISA, @EXPORT, @EXPORT_OK, %EXPORT_TAGS, $VERSION ) ;

use Exporter ;
$VERSION = 1.00 ;
@ISA     = qw(Exporter) ;

@EXPORT = qw(say) ;    # Symbols to autoexport (:DEFAULT tag)

# @EXPORT_OK   = qw(say);       # Symbols to export on request
# %EXPORT_TAGS = (              # Define names for sets of symbols
#     TAG1 => [say],
#     TAG2 => [say],
#     ...
# );

############################################
############################################
############################################

sub say($) {
    my ( $inputString ) = @_ ;
    print $inputString . "\n" ;
}

1 ;
