#!/usr/bin/perl -w
use strict;
my $line = 0;
my @head;
my %pro_body;
my $id_col;
my $bv_col;
my $bs_col;
my $vs_col;
open(PST,"<Proteins_Summary_Result.txt") || die "$!";
while(<PST>){
    if($line==0){
        @head  = split/\t/;
        $id_col = get_index(\@head,'Accession');
        $bs_col = get_index(\@head,'B:S');
        $bv_col = get_index(\@head,'B:V');
        $vs_col = get_index(\@head,'V:S');
        $line++;
    }else{
        my @items = split/\t/;
        my $id = $items[$id_col]; 
        $pro_body{$id} = \@items;
    }

}
print $pro_body{'tr|B9EKJ1|B9EKJ1_MOUSE'}[$bv_col];
sub get_index{
    my ($arr, $elem) = @_;
    my @arra = @$arr;
    my $size = @arra;
    for(my $i=0;$i<$size;$i++){
        if($arra[$i] eq $elem){
            return $i;
        }
    }
}