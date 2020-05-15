#!/usr/bin/perl
use warnings;
use strict;
#比较两个fasta文件中各自的蛋白序列数和共同的蛋白数和蛋白ACC

my $f1 = $ARGV[0]; # fasta file 1
my $f2 = $ARGV[1]; # fasta file 2




my %hash1 = readFa($f1);
my %hash2 = readFa($f2);

my %revHash1 = reverse %hash1;
my %revHash2 = reverse %hash2;
my $n1 = scalar(keys %hash1);
my $n2 = scalar(keys %hash2);
my $n11 = scalar(keys %revHash1);
my $n22 = scalar(keys %revHash2);
my $comm = 0;my $total = 0;
foreach my $seq (keys %revHash1) {
	$comm ++ if exists $revHash2{$seq};
}
my %combinedHash = (%revHash1,%revHash2);
$total = scalar (keys %combinedHash);
open OUT,">Combined_all.fa" or die;
foreach my $seq (keys %combinedHash) {
	print OUT">$combinedHash{$seq}\n";
	my $formatedSeq = formatSeq($seq);
	print OUT"$seq\n";

}
close OUT;
print STDERR"$f1 number:$n1\n";
print STDERR"$f2 number:$n2\n";
print STDERR"dedundance $f1:$n11\n";
print STDERR"dedundance $f2:$n22\n";
print STDERR"Common number:$comm\n";
print STDERR"Total number after combined:$total\n";

######################################################
sub readFa {
	my $file = shift;
	my $out = 'deduant_'.$file;
	open FA,"$file" or die "cant open $file:$!";
	open OUT,">$out" or die;
	$/='>';<FA>;$/="\n";
	my %hash = ();
	while(<FA>){
		chomp;
		my $name = $_;
		$/='>';
		my $con=<FA>;
		chomp $con;
		$con=~s/\n//g;
        $con=~ s/\s+//g;
		$/="\n";
		next if $con =~ /^$/;
		$hash{$name}=$con;
	}
	close FA;
	my %reHash = reverse %hash;
	foreach my $seq (keys %reHash) {
		print OUT">$reHash{$seq}\n$seq\n";
	}
	close FA;
	close OUT;
	return %hash;
}
######################################################
sub formatSeq {
	my $seq = shift;
	my $length = length $seq;
	my @seqs = ();
	for(my $start = 0;$start < $length;) {
		my $subseq = substr($seq,$start,$start+59);
		$start += 60;
		push(@seqs,$subseq);
	}
	my $formSeq = join "\n",@seqs;
	return $formSeq;
}







