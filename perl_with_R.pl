<<<<<<< HEAD
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
=======
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
>>>>>>> eacc51d2f104772e85b7be1f83255eb81980999b
