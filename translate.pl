#!/usr/bin/perl -w
use Bio::SeqIO;
my $file = $ARGV[0];
my $in = Bio::SeqIO -> new(-file=>"$file",-format=>"fasta");
my @dna;
while(my $seq =$in->next_seq){
    my $sequence = $seq -> seq;
    push(@dna,$sequence);
}
open(FH,">pro.txt");
foreach(@dna){
    my $pep=&TranslateDNASeq($_);
    print FH "$pep\n";
}


sub TranslateDNASeq{
    use Bio::Seq;
    (my $dna)=@_;
    my $seqobj=Bio::Seq->new(-seq =>$dna, -alphabet =>'dna');
    return $seqobj->translate()->seq();
}
