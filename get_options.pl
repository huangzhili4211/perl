#!/usr/bin/perl -w
use strict;
use Getopt::Long;
use Cwd;
our $file = "";
my $help;
GetOptions (
    'f=s'       => \$file,
    'help|h'	=> \$help,
);
my $usage = <<USAGE;
    reference:
    -f <string> specify the file
    -h <string> help 
USAGE
die "$usage" if $help;
open(my $FH,"<$file");
while(<$FH>){
    print $_;
}
