#!/usr/bin/perl -w
use strict;
use Bio::SeqIO;
my $in = Bio::SeqIO -> new(-file => "A.fa",-format => "fasta");
my $out = Bio::SeqIO -> new(-file => ">B.fa",-format => "fasta");

while(my $seq=$in -> next_seq){
    my $id = $seq -> id;
    my $desc = $seq -> desc;
    my $sequence = $seq -> seq;
    my $out_obj = Bio::Seq->new(-id=>"$id",-seq=>"$sequence",-desc=>"$desc");
    $out->write_seq($out_obj);
}
