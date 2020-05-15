#!/usr/bin/perl -w
use strict;
open(FH_A,"<CLX-CLC.txt") or die "$!\n";
open(FH_B,"<WTX-WTC.txt") or die "$!\n";
open(RESULT,">venn_result.txt") or die "$!\n";
print RESULT "Identified by\tTotal\tAccession\n";
my @a;
my @b;
my @a_b;
my @a_only;
my @b_only;
my %a_b;

while(<FH_A>){
    chomp;
    push(@a,$_);
}
while(<FH_B>){
    chomp;
    push(@b,$_);
}
foreach(@a){
    my $a = $_;
    foreach(@b){
	my $b = $_;
	if($a eq $b){
	    push(@a_b,$b);
	    $a_b{$b} = 1;
	}
    }
}
my $jiaoji = @a_b;
foreach(@a){
    if(! exists $a_b{$_}){
	push(@a_only, $_);
    }
}
my $a_only = @a_only;
foreach(@b){
    if(! exists $a_b{$_}){
	push(@b_only, $_);
    }
}
my $b_only = @b_only;
my $i = 0;
foreach(@a_b){
    if($i == 0){
	print RESULT "CLX-CLC&&WTX-WTC\t$jiaoji\t$_\n";
	$i++;
    }else{
	print RESULT " \t \t$_\n";
	$i++;
    }
}
my $ii = 0;
foreach(@a_only){
    if($ii == 0){
	print RESULT "CLX-CLC_only\t$a_only\t$_\n";
	$ii++;
    }else{
	print RESULT " \t \t$_\n";
	$ii++;
    }
}
my $iii = 0;
foreach(@b_only){
    if($iii == 0){
	print RESULT "WTX-WTC_only\t$b_only\t$_\n";
	$iii++;
    }else{
	print RESULT " \t \t$_\n";
	$iii++;
    }
}
