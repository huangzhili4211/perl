#!/usr/bin/perl -w
$R = "R";

$data =<<RCODE;
 x <- c(1,5,3)
 barplot(x)
 png("a.png")
RCODE
open R, "| $R --vanilla --slave" or die "$!\n";
print R $data;
close R;
