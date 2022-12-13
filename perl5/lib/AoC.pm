use v5.36;
use strict;
use warnings;
use builtin ();
use feature ':5.36';

package AoC {
    use List::Util ();
    use List::MoreUtils ();
    use List::UtilsBy ();
    use File::Slurp ();

    use Exporter ();
    our @EXPORT = qw( count rotor windowed chunked chars parse_2d_map_of_chars );

    sub import {
        my $caller = shift;
        strict->import;
        warnings->import;
        feature->import(":5.36");

        # All new builtin functions
        warnings->unimport('experimental::builtin');
        builtin->import(
            qw(
                  true false is_bool
                  weaken unweaken is_weak
                  blessed refaddr reftype
                  created_as_string created_as_number
                  ceil floor
                  trim
          )
        );

        # Hack: Tweak ExportLevel to make Exporter::import() inject
        # those symbols, not into here, but into the caller package.
        do {
            local $Exporter::ExportLevel = 2;
            List::Util->import( @List::Util::EXPORT_OK );
            List::MoreUtil->import( @List::MoreUtil::EXPORT_OK );
            List::UtilsBy->import( @List::UtilsBy::EXPORT_OK );
            File::Slurp->import(qw(slurp));
        };
        do {
            local $Exporter::ExportLevel = 1;
            Exporter::import(__PACKAGE__, @EXPORT);
        };
    }

    sub count :prototype(&@) {
        my $predicate = shift;
        my $count = 0;
        for (@_) {
            $count++ if $predicate->($_);
        }
        return $count;
    }

    sub rotor ( $size = 1, $skip = 0, @xs ) {
        my @ys;
        my $end = $size - 1;
        while ($end < @xs) {
            push @ys, [ @xs[ ($end - $size + 1) .. $end ] ];
            $end += $size + $skip;
        }
        return @ys;
    }

    sub windowed ( $size, @xs ) {
        rotor $size => -1 * ($size-1), @xs
    }

    sub chunked ( $size, @xs ) {
        rotor $size => 0, @xs
    }

    sub chars ( $s ) {
        wantarray ? split("", $s) : length($s);
    }

    sub parse_2d_map_of_chars ($s) {
        map { [split ""] } split "\n", $s
    }
};

1;
