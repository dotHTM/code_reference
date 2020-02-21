#!/usr/bin/env perl
# dragon_do.pl
#   Description

use feature ':5.16';

use strict;
use warnings;

use Carp qw{croak};
use Data::Dumper::Concise;
$Data::Dumper::Sortkeys = 1;

use lib "./";
use DragonFractal;

my $worker = DragonFractal->new();

my $maxiteration = 25;

my $startTime = 0;

say "Calculating up to $maxiteration";
$startTime = time();
$worker->iteration_up_to( $maxiteration );
say "Calculated in " . (time() - $startTime);
say "----";
say "currentIteration";
$startTime = time();
say "  " . $worker->current_iteration ;
say "Accessed in " . (time() - $startTime);
say "----";
say "lastFoldListLength";
$startTime = time();
say $worker->last_fold_list_length();
say "Accessed in " . (time() - $startTime);
say "----";
say "2^N";
$startTime = time();
say "  " . (2 ** $worker->current_iteration);
say "Accessed in " . (time() - $startTime);

