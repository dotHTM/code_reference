#!/usr/local/bin/perl
# dragonDo.pl
#   Description
#
#   Written by Mike Cramer
#   Started on 2017-05-19

use 5.6.0 ;
use strict ;
use warnings ;

use Data::Dumper ;

use lib './';
use Convenience ;
use DragonFractal ;

# my $someDragonFractal = PaperFractal->new () ;
my $someDragonFractal = DragonFractal->new () ;

my $maxiteration = 25;

my $startTime = 0;

say "Calculating up to $maxiteration";
$startTime = time();
$someDragonFractal->iterationUpTo($maxiteration) ;
say "Calculated in " . (time() - $startTime);
say "----";
say "currentIteration";
$startTime = time();
say "  " . $someDragonFractal->currentIteration ;
say "Accessed in " . (time() - $startTime);
say "----";
# say "flatFoldList = " . join ( "", $someDragonFractal->flatFoldList ) ;

say "lastFoldListLength";
$startTime = time();
say "  " . $someDragonFractal->lastFoldListLength;
say "Accessed in " . (time() - $startTime);
say "----";
say "2^N";
$startTime = time();
say "  " . (2 ** $someDragonFractal->currentIteration);
say "Accessed in " . (time() - $startTime);

# say Dumper($someDragonFractal);