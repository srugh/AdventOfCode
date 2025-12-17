#!/usr/bin/env raku

# Read the engine schematic as an array of lines
my @grid = 'Inputs/day-03.txt'.IO.lines;

my $total = 0;

# @grid.kv gives (row-index, line) pairs
for @grid.kv -> $row, $line {

    # Find all numbers in this line
    NUMBER: for $line.match(/\d+/, :g) -> $m {
        my $start = $m.from;  # starting column index of the number
        my $last   = $m.to - 1;    # ending column index of the number

        # Scan neighbors in a bounding box around the number
        my $row-min = $row - 1;
        my $row-max = $row + 1;
        my $col-min = $start - 1;
        my $col-max = $last  + 1;

        for $row-min .. $row-max -> $r {
            # skip out-of-bounds rows
            next if $r < 0 || $r > @grid.end;

            my $row-str = @grid[$r];

            for $col-min .. $col-max -> $c {
                # skip out-of-bounds columns
                next if $c < 0 || $c >= $row-str.chars;

                my $ch = $row-str.substr($c, 1);

                # ignore dots and digits; we're only interested in "symbols"
                next if $ch eq '.' || $ch ~~ /\d/;

                # Found an adjacent symbol → this number is a part number
                $total += +$m;   # +$m coerces the match to an Int
                
                next NUMBER;     # move to the next number in the line
            }
        }
    }
}
say "part 1: " ~ $total;

$total = 0;

for @grid.kv -> $row, $line {

    # Find all * in this line
    STAR: for $line.match(/\*/, :g) -> $m {
        my $col = $m.from;  # starting column index of the number
        #my $last   = $m.to - 1;    # ending column index of the number

        # Scan neighbors in a bounding box around the number
        my $row-min = $row - 1;
        my $row-max = $row + 1;
        my $col-min = $col - 1;
        my $col-max = $col  + 1;

        my @found;
        for $row-min .. $row-max -> $r {
            # skip out-of-bounds rows
            next if $r < 0 || $r > @grid.end;

            my $row-str = @grid[$r];

            # find all numbers in that row
            for $row-str.match(/\d+/, :g) -> $nm {
                my $start = $nm.from;
                my $last  = $nm.to - 1;

                # does this number's span touch the star's column range?
                next unless $last >= $col-min && $start <= $col-max;

                @found.push( +$nm );  # here +$nm is fine: it's digits
            }
        }
        if @found == 2 {
             $total+= [*] @found;
        }        
        
    }
}
say "part 2: " ~ $total;