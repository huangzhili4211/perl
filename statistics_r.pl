#!/usr/bin/perl -w
use Statistics::R;
use strict;
my $Rcode = Statistics::R -> new();
$Rcode -> run(qq/
pdf("a.pdf")
x <- c(1,5,3)
barplot(x)
/);
