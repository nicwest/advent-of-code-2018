#!/usr/bin/perl
use warnings;

package main;
main();

sub main {
    my @stars = [];
    my $max_x = 0;
    my $max_y = 0;
    my $min_z = 0;
    my $min_y = 0;
    foreach $line (<>) {
        if ($line =~ /position=<\s*([0-9\-]+),\s*([0-9\-]+)> velocity=<\s*([0-9\-]+),\s*([0-9\-]+)>/){
            my $x = int($1);
            my $y = int($2);
            my $vx = int($3);
            my $vy = int($4);
            my @star = ($x, $y, $vx, $vy);
            push(@stars, @star);

            if($max_x < $x) {
                $max_x = $x;
            }
            if($max_y < $y) {
                $max_y = $y;
            }
            if($min_x > $x) {
                $min_x = $x;
            }
            if($min_y > $y) {
                $min_y = $y;
            }
        }
    }

}
