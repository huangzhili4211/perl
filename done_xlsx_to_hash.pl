#!/usr/bin/perl -w
use 5.010;
use strict;
print "请输入要读取的蛋白质XLSX文件：\n";
chomp(my $protein_xlsx=<STDIN>);
print "请输入读取的FASTA文件：\n";
chomp(my $protein_fasta=<STDIN>);
print "请输入要保存的XLSX文件：\n";
chomp(my $result_xlsx=<STDIN>);
#-------------------------------------------------蛋白质信息保存顺序----------------------------------------
my @result_head_array = (
    'Protein Index',
    'Protein ID',
    'Samesets',
    'Des.',
    'Mass',
    'Coverage',
    '#Peptide',
    '#Unique Peptide',
    'Unique PepSeq',
    '#Uniq Spectrum',
    'Unique Spectrum',
    'Identified by',
    'A_Abund',
    'B_Abund',
    'C_Abun',
    'B/A',
    'C/A',
    'C/B',
    'PI',
    'GRAVY',
    'Mass_fa',
    'Seq',
    'Des_fa'
);

#------------------------------------------------计算等电点和分子量亲疏水性---------------------------------
use Bio::SeqIO;
use Bio::Tools::pICalculator;
use Bio::Tools::SeqStats;
my %pro_id_pI;
my %pro_id_mass;
my %pro_id_seq;
my %pro_id_gravy;
my %pro_id_desc;
my $in = Bio::SeqIO->new(-file => $protein_fasta , -format => 'Fasta');
my $calc = Bio::Tools::pICalculator->new(-places => 2, -pKset => 'EMBOSS');
while(my $seq = $in->next_seq){
    $calc->seq($seq);
    my $iep = $calc->iep;
    $pro_id_pI{$seq->id} = $iep;
    my $mass = Bio::Tools::SeqStats ->get_mol_wt($seq);
    $pro_id_mass{$seq->id} = $$mass[0];
    $pro_id_desc{$seq->id} = $seq->desc;
    my $sequence = $seq->seq;
    $sequence =~ s/[^AVLIFWMPGSTCYNQHKRDE]//ig;
    $pro_id_seq{$seq->id} = $sequence;
    my $seqobj = Bio::PrimarySeq->new(-seq => $sequence, -alphabet => 'protein', -id => 'test');
    my $gravy = Bio::Tools::SeqStats->hydropathicity($seqobj);
    $pro_id_gravy{$seq->id} = $gravy;
    
    
}

#-------------------------------------------------读取蛋白质表格信息到嵌套哈希-----------------------------
use Spreadsheet::XLSX;
use Excel::Writer::XLSX;
my %Pro_Body;
my $id = '';
sub Save_to_hash {
   my($protein_xlsx) = @_; 
   my $excel= Spreadsheet::XLSX -> new ($protein_xlsx);

   foreach my $sheet (@{$excel -> {Worksheet}}) {
	$sheet -> {MaxRow} ||= $sheet -> {MinRow};
   
        foreach my $col ($sheet -> {MinCol} ..  $sheet -> {MaxCol}) {    
               $sheet -> {MaxRow} ||= $sheet -> {MinRow};
               foreach my $row ($sheet -> {MinRow} .. $sheet -> {MaxRow}) { 
				   my $cell = $sheet -> {Cells} [$row] [$col];
				   my $head_val = $sheet -> {Cells} ["0"] [$col] -> {Val}; 
				   $Pro_Body{$head_val}{$row} = $cell -> {Val};
				   $id = $sheet -> {Cells} [$row] [13] -> {Val};  
				   $Pro_Body{'Seq'}{$row} = $pro_id_seq{$id};
				   $Pro_Body{'PI'}{$row} = $pro_id_pI{$id};
				   $Pro_Body{'GRAVY'}{$row} = $pro_id_gravy{$id};
				   $Pro_Body{'Mass_fa'}{$row} = $pro_id_mass{$id};
				   $Pro_Body{'Des_fa'}{$row} = $pro_id_desc{$id};
		}
         
        }

    }
    $Pro_Body{'Seq'}{0} = 'Seq';
    $Pro_Body{'PI'}{0} = 'PI';
    $Pro_Body{'GRAVY'}{0} = 'GRAVY';
    $Pro_Body{'Mass_fa'}{0} = 'Mass_fa';
    $Pro_Body{'Des_fa'}{0} = 'Des_fa';
    return %Pro_Body;	
}


#------------------------------------------------读取哈希中的信息并保存到XLSX------------------------------------------------------- 

sub Save_hash_to_XLSX {
	my($result_xlsx) = @_;
	my $workbook = Excel::Writer::XLSX -> new($result_xlsx);
	my $worksheet = $workbook -> add_worksheet("sheet1");
	my %protein_hash = Save_to_hash($protein_xlsx);
	my @protein_head_array = keys %protein_hash;
	my $col = 0;
	foreach(@result_head_array){
	    my $result_head = $_;
	    foreach(@protein_head_array){ 
		my $head_val = $_;
		if($result_head eq $head_val){
		for (my $line_num = 0; $line_num < 2852; $line_num++){
			my $protein_val = $protein_hash{$head_val}{$line_num};
			$worksheet ->write($line_num, $col,$protein_val);
		}
		$col++;
		}   
			
	    }
	}
} 

my %protein_hash = Save_to_hash($protein_xlsx);
Save_hash_to_XLSX($result_xlsx);

