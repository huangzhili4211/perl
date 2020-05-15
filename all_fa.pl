#!/usr/bin/perl -w
use strict;
use Bio::SeqIO;
my $id = $ARGV[0];
my $outID_fa = "All_ID";
$outID_fa = $id =~ s/^(.*?).txt$/$1/r if $ARGV[2];
my $db = $ARGV[1];
open(my $up_id, "<$id") || die "$!";
my $in = Bio::SeqIO -> new(-file => "$db", -format => 'Fasta');
#my $All_fa = Bio::SeqIO -> new(-file => '>All_ID.fa', -format => 'Fasta');
my $fa = Bio::SeqIO -> new(-file => ">$outID_fa\.fa", -format => 'Fasta');
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
            $fa->write_seq($seq);
        }
    }
}
