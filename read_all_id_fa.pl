#!/usr/bin/perl -w
use strict;
use Bio::SeqIO;
use Bio::Seq;
my @all_id;
my @all_seq;
my @up_id;
my @down_id;
my %all_hash;
my %up_hash;
my %down_hash;
my $up_seqout= Bio::SeqIO->new( -format => 'Fasta', -file => '>E:\\Project_iTraq_2019\\0104-PR1-19100003\\shouhou\\Project_data_new\\Ident_Quant_result\\up_id.fa');
my $down_seqout= Bio::SeqIO->new( -format => 'Fasta', -file => '>E:\\Project_iTraq_2019\\0104-PR1-19100003\\shouhou\\Project_data_new\\Ident_Quant_result\\down_id.fa');
my $in = Bio::SeqIO->new(-file => "E:\\Project_iTraq_2019\\0104-PR1-19100003\\shouhou\\Project_data_new\\Ident_Quant_result\\All_ID.fa" , -format => 'Fasta');
my $seqobj = $in->next_seq;



open(my $UP, "<E:\\Project_iTraq_2019\\0104-PR1-19100003\\shouhou\\Project_data_new\\Ident_Quant_result\\up_id.txt") || die "$!";
while(<$UP>){
    chomp;
    push(@up_id, $_);

}

open(my $DOWN, "<E:\\Project_iTraq_2019\\0104-PR1-19100003\\shouhou\\Project_data_new\\Ident_Quant_result\\down_id.txt") || die "$!";
while(<$DOWN>){
    chomp;
    push(@down_id, $_);

}

    while(my $seq = $in->next_seq){
	my $id = $seq->id;
	foreach(@up_id){
	    my $upid = $_;
	    
	    if($upid eq $id){
	    $up_seqout->write_seq($seq);	
	    }
	}

	foreach(@down_id){
	    my $downid = $_;
	    
	    if($downid eq $id){
	    $down_seqout->write_seq($seq);	
	    }
	}
    }



