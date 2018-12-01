#!/usr/bin/perl
use warnings;

package main;
main();

sub main {
    my $total = 0;
    foreach $line (<>) {
        $total += int($line);
    }
    print("total: $total\n");
}
