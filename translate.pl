#!/usr/bin/perl -w
use strict;
use Bio::SeqIO;
my $in = Bio::SeqIO->new(-file=>"10dna.fasta",-format=>"fasta");
my $out = Bio::SeqIO->new(-file=>">result.fasta",-format=>"fasta");
while(my $seq=$in->next_seq){
    my $out_obj = $seq->translate;
    $out->write_seq($out_obj);
	
}
