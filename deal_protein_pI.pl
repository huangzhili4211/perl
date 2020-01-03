#!/usr/bin/perl -w
use Bio::tools:pIcalculator;
use Bio::SeqIO;
my $in = Bio::SeqIO->new(-fh=>\*STDIN, -format => 'Fasta');
my $calc = Bio::Tools::pICalculator->new(-places => 2, -pKset => 'EMBOSS');

