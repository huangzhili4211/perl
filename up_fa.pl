#!/usr/bin/perl -w
use strict;
use Bio::SeqIO;
open(my $up_id, "<up_id.txt") || die "$!";
my $in = Bio::SeqIO -> new(-file => 'PR1-19110032-uniprot-taxonomy__Maize_4targetPRO.fasta', -format => 'Fasta');
#my $All_fa = Bio::SeqIO -> new(-file => '>All_ID.fa', -format => 'Fasta');
my $Up_fa = Bio::SeqIO -> new(-file => '>combine_up_ID.fa', -format => 'Fasta');
#my $Down_fa = Bio::SeqIO -> new(-file => '>P-N_down_ID.fa', -format => 'Fasta');
my @up_id;
while(<$up_id>){
    chomp;
    push(@up_id, $_);
}
while(my $seq = $in->next_seq){
    my $id = $seq->id;
    foreach(@up_id){
        my $allid = $_;
        if($id eq $allid){
            print "$allid---$id\n";
            $Up_fa->write_seq($seq);
        }
    }
}
