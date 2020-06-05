#!/usr/bin/perl -w
use strict;
use Bio::SeqIO;
my $out = Bio::SeqIO->new(-file=>">subSequence.fasta",-format=>"fasta");
    my $id = "targetPRO";
    my $sequence = "MALPKTGKPTAKQVVDWAINLIGSGVDVDGYYGRQCWDLPNYIFNRYWNFKTPGNARDMAWYRYPEGFKVFRNTSDFVPKPGDIAVWTGGNYNWNTWGHTGIVVGPSTKSYFYSVDQNWNNSNSYVGSPAAKIKHSYFGVTHFVRPAYKAEPKPTPPGTPPGTVAQSAPNLAGSRSYRETGTMTVTVDALNVRRAPNTSGEIVAVYKRGESFDYDTVIIDVNGYVWVSYIGGSGKRNYVATGATKDGKRFGNAWGTFK";
    my $len = length($sequence);
    foreach((0..$len)){
	my $start = $_;
	my $max_len = $len - $start;
	my $min_len = 7;
	foreach($min_len..$max_len){
	    my $sub_len = $_;
	    my $end = $start+$sub_len-1;
	    my $sub_id = "$id\_$start\_$end"; 
	    my $sub_seq = substr($sequence,$start,$sub_len);
	    my $sub_desc = "start:"."$start "."end:"."$end";
	    my $outobj = Bio::Seq->new(-id=>"$sub_id",-desc=>"$sub_desc",-seq=>"$sub_seq"); 
	    $out->write_seq($outobj);
	}
    }

