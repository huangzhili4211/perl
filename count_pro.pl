#!/usr/bin/perl -w
use Bio::SeqIO;
use Bio::Tools::SeqStats;
use Getopt::Long;
my $database;
GetOptions (
    'f=s'  => \$database,
);
my $num = 0;
my $in = Bio::SeqIO->new(-file => $database , -format => 'Fasta');
while(my $seq = $in->next_seq){
   $num++; 
}
print $num,'\n';
