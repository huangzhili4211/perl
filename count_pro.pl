#!/usr/bin/perl -w
use Bio::SeqIO;
use Bio::Tools::SeqStats;

my $num = 0;
my $in = Bio::SeqIO->new(-file => 'PR1-19110041_uniprot-taxonomy_Homo_sapiens_reviewed.fasta' , -format => 'Fasta');
while(my $seq = $in->next_seq){
   $num++; 
}
print $num,'\n';
