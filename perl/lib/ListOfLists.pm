# ListOfLists.pm
#   Description

package ListOfLists;

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
    deref clone_ref
    kv_pairs hash_from_kv_pairs arrayref_to_indexed_hashref

    reduce_ref append_arrays_ref push_ref overwrite_hashes_ref
    map_ref map_values
    filter_ref

    map_c
    reduce_c
    filter_c

    map_cc
    reduce_cc
    filter_cc

    result_pass_onto

    chain_cc
    chain_ex
);

sub deref {
    my ($input) = @_;
    my $refType = ref($input);
    for ($refType) {    # switch
        if    ( !$refType ) { }                    # scalar
        elsif (/^array/i)   { return @{$input} }
        elsif (/^hash/i)    { return %{$input} }

        # else                { carp("Warning: Unknown reference type"); }
    }
    return $input;
}    ##    deref

sub clone_ref {
    my ($input) = @_;
    my $result;
    my $refType = ref($input);
    for ($refType) {    # switch
        if ( !$refType ) { }    # scalar
        elsif (/^array/i) { return map_ref( \&clone_ref, $input ); }
        elsif (/^hash/i) { return map_values( \&clone_ref, $input ); }
        elsif (/^code/i) { return \&{$input}; }
        else             { carp("Warning: Unknown reference type"); }
    }
    return $input;
}    ##    clone_ref

sub arrayref_to_indexed_hashref {
    my ( $input ) = @_;
    unit_typecheck("array", $input, "array_to_hash", undef, '$input');
    my $result = {};
    my $index = 0;
    foreach my $e (@{$input}) {
        $result->{$index} = $e;
        $index++;
    }
    return $result;
}    ##  array_to_hash

sub kv_pairs {
    my ($input) = @_;
    unit_typecheck("hash", $input, 'kv_pairs', undef, '$input');
    my $result = [];
    foreach my $key ( keys %{$input} ) {
        push @{$result}, { k => $key, v => $input->{$key} };
    }
    return $result;
}    ##    kv_pairs

sub hash_from_kv_pairs {
    my ($input_kv_pairs) = @_;
    reduce_ref(
        sub {
            my ( $r, $e ) = @_;
            my %tmp = %{$r};
            $tmp{ $e->{k} } = $e->{v};
            return \%tmp;
        },
        $input_kv_pairs,
        {}
    );
}

sub unit_typecheck
{ ## unit_typecheck( $expected, $input, $functionName, $message, $variableName )
    my ( $expected, $input, $functionName, $message, $variableName ) = @_;
    $message = "Unexpected Type or Object" unless $message;
    $message = $variableName . " - " . $message if $variableName;
    unless ( ref($input) =~ /^$expected$/i ) {
        carp(
            $functionName . ": " . $message,
            "\n- expected:   " . uc($expected),
            "\n- actual:     " . ref($input),
            "\n- contents:\n" . Dumper $input
        );
        croak( $functionName . ": " . $message );
    }
}

sub fn_typecheck {
    my ( $codeRef, $arrayRef, $functionName ) = @_;
    unit_typecheck( "code",  $codeRef,  $functionName, undef, '$function' );
    unit_typecheck( "array", $arrayRef, $functionName, undef, '$input' );
}

sub reduce_ref {
    my ( $assemblyFunction, $input, $startingValue ) = @_;
    fn_typecheck( $assemblyFunction, $input, "Reduce" );

    my $result = $startingValue || '';
    foreach my $element ( @{$input} ) {
        $result = $assemblyFunction->( $result, $element );
    }
    return $result;
}    ##    reduce_ref

sub append_arrays_ref {
    my ( $a, $b ) = @_;
    my @temp = @{$a};
    foreach my $e ( @{$b} ) {
        push @temp, $e;
    }
    return \@temp;
}

sub push_ref {
    my ( $a, $e ) = @_;
    return append_arrays_ref( $a, [$e] );
}

sub overwrite_hashes_ref {
    my ( $a, $b ) = @_;
    my %temp = %{$a};
    foreach my $k ( keys %{$b} ) {
        $temp{$k} = $b->{$k};
    }
    return \%temp;
}

sub map_ref {
    my ( $mappingFunction, $input ) = @_;
    fn_typecheck( $mappingFunction, $input, "Map" );

    return reduce_ref(
        sub { my ( $r, $e ) = @_; push_ref( $r, $mappingFunction->($e) ); },
        $input, [] );
}    ##    map_refme

sub map_values {
    my ( $mappingFunction, $input ) = @_;
    return hash_from_kv_pairs(
        map_ref(
            sub {
                my ($e) = @_;
                return { k => $e->{k}, v => $mappingFunction->( $e->{v} ) };
            },
            kv_pairs($input)
        )
    );
}

sub filter_ref {
    my ( $filterFunction, $input ) = @_;
    fn_typecheck( $filterFunction, $input, "Filter" );

    my $result = [];
    foreach my $e ( @{$input} ) {
        push @{$result}, $e if $filterFunction->($e);
    }

    return $result;
}    ##    filter_ref

sub map_c {
    my ( $mappingFunction, $input ) = @_;
    return map_ref( $mappingFunction, clone_ref($input) );
}

sub reduce_c {
    my ( $assemblyFunction, $input, $startingValue ) = @_;
    return reduce_ref( $assemblyFunction, clone_ref($input),
        clone_ref($startingValue) );
}

sub filter_c {
    my ( $filterFunction, $input ) = @_;
    return filter_ref( $filterFunction, clone_ref($input) );
}

sub map_cc {
    my ($mappingFunction) = @_;
    return sub {
        my ($input) = @_;
        return map_c( $mappingFunction, $input );
    }
}

sub reduce_cc {
    my ( $assemblyFunction, $startingValue ) = @_;
    return sub {
        my ($input) = @_;
        return reduce_c( $assemblyFunction, $input, $startingValue );
    }
}

sub filter_cc {
    my ($filterFunction) = @_;
    return sub {
        my ($input) = @_;
        say "DEBUG " . Dumper $input;

        return filter_c( $filterFunction, $input );
    };
}

sub result_pass_onto {
    my ( $r, $f ) = @_;
    fn_typecheck( $f, [], "result_pass_onto" );
    return $f->($r);
}

sub chain_cc {
    my (@functionList) = @_;
    return sub {
        my ($input) = @_;
        return reduce_c( \&result_pass_onto, \@functionList, $input );
    }
}

sub chain_ex {
    my ( $input, @functionList ) = @_;
    return chain_cc(@functionList)->($input);
}

1;
