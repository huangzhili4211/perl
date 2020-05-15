#!/usr/bin/perl -w
use strict;
use Bio::SeqIO;
use Cwd;
use Getopt::Long;
our $comparegroup;
my $path = getcwd;
GetOptions (
    '-cp=s'     =>\$comparegroup,
);
my $up_f = "$path/up_id.txt";
my $up_fa_out = "$path/$comparegroup\_up_ID.fa";
my $down_f = "$path/down_id.txt";
my $down_fa_out = "$path/$comparegroup\_down_ID.fa";
#open(my $All_id, "<All_id.txt") || die "$!";
open(my $up_id, "<$up_f") || die "$!";
open(my $down_id, "<$down_f") || die "$!";
my $in = Bio::SeqIO -> new(-file => 'PR1-19110039uniprot_swissprot-Homosapiens+contaminants190115.fasta', -format => 'Fasta');
#my $All_fa = Bio::SeqIO -> new(-file => '>All_ID.fa', -format => 'Fasta');
my $Up_fa = Bio::SeqIO -> new(-file => ">$up_fa_out", -format => 'Fasta');
my $Down_fa = Bio::SeqIO -> new(-file => ">$down_fa_out", -format => 'Fasta');
my @up_id;
while(<$up_id>){
    chomp;
    push(@up_id, $_);
}
my @down_id;
while(<$down_id>){
    chomp;
    push(@down_id, $_);
}
my @All_id;
#while(<$All_id>){
#    chomp;
#    push(@All_id, $_);
#}
while(my $seq = $in->next_seq){
    my $id = $seq->id;
    foreach(@up_id){
        my $allid = $_;
        if($id eq $allid){
            $Up_fa->write_seq($seq);
        }
    }
    foreach(@down_id){
        my $allid = $_;
        if($id eq $allid){
            $Down_fa->write_seq($seq);
        }
    }
#    foreach(@All_id){
#        my $allid = $_;
#        if($id eq $allid){
#            $All_fa->write_seq($seq);
#        }
#    }
}
