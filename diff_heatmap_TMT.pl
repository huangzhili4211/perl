#!/usr/bin/perl -w
use strict;
use Cwd;
use File::Basename;
my $path = getcwd;
my $diffpath = $path . "/before_combined_diff_Result";
my @fs = glob "$diffpath/*_diff.txt";
my $num = @fs;
my %Hash;
foreach my $f (@fs) {
	my $fn = basename ($f);
	$fn = $1 if $fn =~ /([^_]+)/;
	open IN, "<$f" or die;
	my $l;
	my %headHash;
	while (<IN>) {
		chomp;
		$l ++;
		my @items = split /\t/;
		if ($l == 1) {
			for (my $i = 0; $i <= $#items; $i++) {
				$headHash{$items[$i]} = $i;
			}
		}else {
			my $acc = $items[$headHash{"Accession"}];
			$Hash{$acc}{$fn} ++;
		}
	}
}
my %prots;
my ($jiao, $bing) = (0,0);
my $jf = "jiaoji_difflist.txt";
my $bf = "bingji_difflist.txt";
open JF, ">$diffpath/$jf";
open BF, ">$diffpath/$bf";
foreach my $acc (keys %Hash) {
	my @cps = keys %{$Hash{$acc}};
	$prots{$acc} ++;                                                     #选择并集蛋白做热图
	print BF "$acc\n";
	print JF "$acc\n" if @cps == $num;
	#$prots{$acc} ++ if @cps == $num;               #选择交集蛋白做热图，两者二选一
	$bing ++;
	$jiao ++  if @cps == $num;
}
print "diff交集蛋白质数：$jiao\n";
print "diff并集蛋白质数：$bing\n";
close BF;
close JF;

my $protpath = $path . "/iTRAQ_Report";
my $in = "proteinAbund.txt";
my $out = "for_heatmap.txt";
open IN, "<$protpath/$in" or die;
open OUT, ">$diffpath/$out" or die;
my $l = 0;
my @items = ();
my %headHash = ();
my @compare = ();
while (<IN>) {
	chomp;
	$l ++;
	@items = split /\t/;
	if ($l == 1) {
		print OUT "$_\n";
	}else {
		my $acc = $items[0];
		print OUT "$_\n" if exists $prots{$acc};
	}
}