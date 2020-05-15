#!/usr/bin/perl -w
use strict;
use Cwd;
my $path = getcwd;
open(my $DIFF,"<all_diff_list.txt") or die"$!";
open(my $HM,">for_diff_abund.heatmap") or die"$!";
my @diff;
while(<$DIFF>){
    chomp;
    push(@diff,$_);
}
open(my $FH,"<$path/../iTRAQ_Report/Proteins_Summary-Result.txt" ) or die"$!";
my %head;
my $line = 0;
while(<$FH>){
    chomp;
    $line++;
    my @items = split/\t/;
    if($line==1){
	my $size = @items;
	print $HM "id\tArea 113\tArea 114\tArea 115\tArea 116\tArea 117\tArea 118\tArea 119\tArea 121\n";
	for(my $i=0;$i<$size;$i++){
	    $head{$items[$i]} = $i;
	}
    }else{
	foreach(@diff){
	    my $id = $_;
	    if($id eq $items[$head{"Accession"}]){
		my $abund3 = $items["$head{'Area 113'}"];
		my $abund4 = $items["$head{'Area 114'}"];
		my $abund5 = $items["$head{'Area 115'}"];
		my $abund6 = $items["$head{'Area 116'}"];
		my $abund7 = $items["$head{'Area 117'}"];
		my $abund8 = $items["$head{'Area 118'}"];
		my $abund9 = $items["$head{'Area 119'}"];
		my $abund21 = $items["$head{'Area 121'}"];
		print $HM "$id\t$abund3\t$abund4\t$abund5\t$abund6\t$abund7\t$abund8\t$abund9\t$abund21\n";
	    }
	}	
    }
}
