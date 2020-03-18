<<<<<<< HEAD
#!/usr/bin/perl -w
use 5.010;
use strict;
use Spreadsheet::XLSX;
use Excel::Writer::XLSX;
print "������Ҫ��ȡ�ĵ�����XLSX�ļ���\n";
chomp(my $protein_xlsx=<STDIN>);
print "������Ҫ�����XLSX�ļ���\n";
chomp(my $result_xlsx=<STDIN>);

my @protein_head_array = (
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
);

#-------------------------------------------------��ȡ�����ʱ����Ϣ��Ƕ�׹�ϣ-----------------------------
sub Save_to_hash {
   my %Pro_Body ;  
   my $excel= Spreadsheet::XLSX -> new ($protein_xlsx);

   foreach my $sheet (@{$excel -> {Worksheet}}) {
	$sheet -> {MaxRow} ||= $sheet -> {MinRow};
   
        foreach my $col ($sheet -> {MinCol} ..  $sheet -> {MaxCol}) {    
               $sheet -> {MaxRow} ||= $sheet -> {MinRow};
                
               foreach my $row ($sheet -> {MinRow} .. $sheet -> {MaxRow}) { 
				   my $cell = $sheet -> {Cells} [$row] [$col];
				   my $head_val = $sheet -> {Cells} ["0"] [$col] -> {Val}; 
				   $Pro_Body{$head_val}{$row} = $cell -> {Val};
				   
		}
				
         
        }
    }
    return %Pro_Body;	
}


#------------------------------------------------��ȡ��ϣ�е���Ϣ�����浽XLSX------------------------------------------------------- 
sub Save_hash_to_XLSX {
	my $workbook = Excel::Writer::XLSX -> new($result_xlsx);
	my $worksheet = $workbook -> add_worksheet("sheet1");
	my %protein_hash = Save_to_hash();
	my @head_val = keys %protein_hash;
	my $col = 0;
	foreach(@head_val){
		my $head_val = $_;
		for (my $line_num = 0; $line_num < 2852; $line_num++){
			my $protein_val = $protein_hash{$head_val}{$line_num};
			$worksheet ->write($line_num, $col,$protein_val);
		}
		$col++;
	}
} 

my %protein_hash = Save_to_hash();
Save_hash_to_XLSX();
=======
#!/usr/bin/perl -w
use 5.010;
use strict;
use Spreadsheet::XLSX;
use Excel::Writer::XLSX;
print "������Ҫ��ȡ�ĵ�����XLSX�ļ���\n";
chomp(my $protein_xlsx=<STDIN>);
print "������Ҫ�����XLSX�ļ���\n";
chomp(my $result_xlsx=<STDIN>);

my @protein_head_array = (
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
);

#-------------------------------------------------��ȡ�����ʱ����Ϣ��Ƕ�׹�ϣ-----------------------------
sub Save_to_hash {
   my %Pro_Body ;  
   my $excel= Spreadsheet::XLSX -> new ($protein_xlsx);

   foreach my $sheet (@{$excel -> {Worksheet}}) {
	$sheet -> {MaxRow} ||= $sheet -> {MinRow};
   
        foreach my $col ($sheet -> {MinCol} ..  $sheet -> {MaxCol}) {    
               $sheet -> {MaxRow} ||= $sheet -> {MinRow};
                
               foreach my $row ($sheet -> {MinRow} .. $sheet -> {MaxRow}) { 
				   my $cell = $sheet -> {Cells} [$row] [$col];
				   my $head_val = $sheet -> {Cells} ["0"] [$col] -> {Val}; 
				   $Pro_Body{$head_val}{$row} = $cell -> {Val};
				   
		}
				
         
        }
    }
    return %Pro_Body;	
}


#------------------------------------------------��ȡ��ϣ�е���Ϣ�����浽XLSX------------------------------------------------------- 
sub Save_hash_to_XLSX {
	my $workbook = Excel::Writer::XLSX -> new($result_xlsx);
	my $worksheet = $workbook -> add_worksheet("sheet1");
	my %protein_hash = Save_to_hash();
	my @head_val = keys %protein_hash;
	my $col = 0;
	foreach(@head_val){
		my $head_val = $_;
		for (my $line_num = 0; $line_num < 2852; $line_num++){
			my $protein_val = $protein_hash{$head_val}{$line_num};
			$worksheet ->write($line_num, $col,$protein_val);
		}
		$col++;
	}
} 

my %protein_hash = Save_to_hash();
Save_hash_to_XLSX();
>>>>>>> eacc51d2f104772e85b7be1f83255eb81980999b
