#!/usr/bin/perl -w
use strict;
use Bio::SeqIO;
open(my $down_id, "<down_id.txt") || die "$!";
my $in = Bio::SeqIO -> new(-file => 'PR1-19110032-uniprot-taxonomy__Maize_4targetPRO.fasta', -format => 'Fasta');
#my $All_fa = Bio::SeqIO -> new(-file => '>All_ID.fa', -format => 'Fasta');
#my $Up_fa = Bio::SeqIO -> new(-file => '>P-N_up_ID.fa', -format => 'Fasta');
my $Down_fa = Bio::SeqIO -> new(-file => '>combine_down_ID.fa', -format => 'Fasta');
my @down_id;
while(<$down_id>){
    chomp;
    push(@down_id, $_);
}
close $down_id;
while(my $seq = $in->next_seq){
    my $id = $seq->id;
    foreach(@down_id){
        my $allid = $_;
        if($id eq $allid){
            print "$allid---$id\n";
            $Down_fa->write_seq($seq);
        }
    }
}
