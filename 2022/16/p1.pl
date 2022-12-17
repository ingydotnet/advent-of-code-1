use v5.36;
use FindBin '$Bin';
use lib $Bin . '/../../perl5/lib';
use AoC;

sub main ( $input = "input" ) {
    my $vg = buildValveGraph( $input );

    my $i = 0;
    my $rate = $vg->{"rate"};
    my $max = 0;
    # [current valve, minutes left, eventual-releases, opened valves, count of open valvels]

    my @openableValves =  grep { $rate->{$_} > 0 } @{$vg->{"nodes"}};
    my $opened = { map { $_ => 0 } @openableValves };
    my @Q = (["AA", '', 30, 0, $opened, 0+@openableValves]);

    while (@Q) {
        my $now = pop @Q;
        my ($valve, $prevValve, $minutesLeft, $eventualReleases, $openedValves, $openableValves) = @$now;

        if ($minutesLeft <= 0) {
            if ($eventualReleases > $max) {
                $max = $eventualReleases;
                say gist $max, $minutesLeft, [map {@$_} rev_nsort_by { $_->[1] } grep { $_->[1] > 0 } pairs %$openedValves];
            }
            next;
        }

        if ($openableValves == 0) {
            push @Q, [$valve, $prevValve, 0, $eventualReleases, $openedValves, $openableValves];
            next;
        }

        my @nextValves = (slip $vg->{"connection"}{$valve});

        if (@nextValves > 1) {
            @nextValves = grep { $prevValve ne $_ } @nextValves;
        }

        my $rate = $vg->{"rate"}{$valve};

        if ($rate > 0 && $openedValves->{$valve} == 0) {
            push @Q, [
                $valve, $prevValve, $minutesLeft - 1,
                $eventualReleases + $rate * ($minutesLeft - 1),
                { %$openedValves, $valve => $minutesLeft },
                $openableValves - 1
            ];
        }

        for my $v (@nextValves) {
            push @Q, [ $v, $valve, $minutesLeft - 1, $eventualReleases, $openedValves, $openableValves ];
        }
    }

    say $max;
}

main(@ARGV);
exit();

sub buildValveGraph ( $input ) {
    my $G = {
        "nodes" => [],
        "rate" => {},
        "connection" => {},
    };

    for my $row (map { [ comb qr/(?:[A-Z]{2}|[0-9]+)/, $_ ] } slurp($input)) {
        my ($src, $rate, @dest) = @$row;
        push @{ $G->{"nodes"} }, $src;
        $G->{"rate"}{$src} = $rate;
        $G->{"connection"}{$src} = \@dest;
    }

    return $G;
}
