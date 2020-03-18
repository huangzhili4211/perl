#!/usr/bin/perl -w
#$R = "R";

$data =<<RCODE;
 png("a.png")
 x <- c(1,5,3)
 barplot(x)
RCODE
open R, "| R --vanilla --slave" or die "$!\n";
print R $data;
close R;
