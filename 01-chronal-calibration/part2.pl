#!/usr/bin/perl
use warnings;
use Set::Light;

package main;
main();

sub main {
    my $seen = Set::Light->new();
    my $total = 0;
    my @numbers = map(int, <>);
    my $i = 0;
    while($seen->insert($total)) {
        $total += $numbers[$i];
        if(scalar(@numbers) - 1 > $i) {
            $i++;
        } else {
            $i = 0;
        }
    }
    print("first reoccurring value: $total\n");
}
