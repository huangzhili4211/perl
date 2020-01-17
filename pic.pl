#!/usr/bin/perl -w
use strict;
use File::Copy;
use Cwd;
use Getopt::Long;
use Spreadsheet::XLSX;
use Excel::Writer::XLSX;
use File::Copy::Recursive qw(dircopy);
our $compareGroup;
our $compareGroup2;
my $new_pic_name;
our $help;
our $path = getcwd;
our $ext;
GetOptions ( 
    'cp=s'	        => \$compareGroup,
    'h|help'		=> \$help,	
    'p'			=> \$ext,	    
);
my $usage =<<USAGE;
    -cp		    specify the comparegroup,something like RIF:Ctrl
    -p		    process pictures only
    h|help	    help
USAGE
die "$usage" if $help;	
$compareGroup2 = $compareGroup =~ s/:/-/r;
my $dir = "$path\\Project_data\\Pictures";
system("mkdir $dir") unless(-e $dir);
my @pic_path = ();
open(my $PIC, "<$path\\picture_path.txt") || die "$!";
foreach(<$PIC>){
    chomp;
    if($_ eq "\n") {next;}
    push(@pic_path,$_);
}
my %rename_hash = (
    'cv'			                    => 'Figure3.1',
    'CVbox'			                    => 'Figure3.2',
    'uniqP'			                    => 'Figure3.3',
    'pepSeq.pepLength'				    => 'Figure3.4',
    'coverage_pie'				    => 'Figure3.5',
    'normprotRatiodistribution'			    => 'Figure4.1',
    'Volcano'					    => 'Figure4.2',
    'fun_stat'					    => 'Figure5.1',
    'biological_process'			    => 'Figure5.2',
    'cellular_component'			    => 'Figure5.2',
    'molecular_function'			    => 'Figure5.2',
    'go_compare_stat'				    => 'Figure5.3',
    'All_ID.fa.cog'				    => 'Figure5.4',
    'Pathway_compare_stat'			    => 'Figure5.6',
    'CC-barchart'				    => 'Figure6.1',
    'MF-barchart'				    => 'Figure6.1',
    'BP-barchart'				    => 'Figure6.1',
    '.path-bubble'				    => 'Figure6.3'    
);
my @old_name = keys %rename_hash;
foreach(@old_name){
    my $old_pic_name = $_;
    foreach(@pic_path){
	    if(/$compareGroup2\_?$old_pic_name\.(png|pdf)$/){
	         $new_pic_name = $& =~ s/$&/$rename_hash{$old_pic_name}_$&/r;
	         my $cop = File::Spec->catfile($dir,$new_pic_name);
	         my $pic = $_;
	         if(-e $pic){
	    	 copy($pic,$cop) || die "$pic:$!";
	        }else{print "$& not found!\n";}
	    }
	    elsif(/$old_pic_name\.pdf$/){
	         $new_pic_name = $& =~ s/$&/$rename_hash{$old_pic_name}_$&/r;
	         my $cop = File::Spec->catfile($dir,$new_pic_name);
	         my $pic = $_;
	         if(-e $pic){
	    	 copy($pic,$cop) || die "$pic:$!";
	        }else{print "$& not found!\n";}
	    }
    }
}
copy("$path/iTRAQ_Report/All_ID.fa","$path/Project_data/Ident_Quant_result");
copy("$path/Function_enrichment_summary/all_express_diff.xlsx", "$path/Project_data/Ident_Quant_result");
our @FunctionDirArray = ("ALL_ID_COG","ALL_ID_GO","ALL_ID_Pathway","$compareGroup2\_down_ID_GO","$compareGroup2\_down_ID_Pathway","$compareGroup2\_up_ID_GO","$compareGroup2\_up_ID_Pathway");
foreach(@FunctionDirArray){
    our $annotationFile = $_;
    dircopy("$path\\Annotation\\$annotationFile", "$path\\Project_data\\Function\\$annotationFile");
}
foreach(('GO','Pathway')){
    dircopy("$path\\Annotation\\$compareGroup2\_$_\_enrichment", "$path\\Project_data\\Enrichment\\$_\_enrichment\\$compareGroup2\_$_\_enrichment");
    copy("$path/function_stat/$compareGroup2\_$_\_compare_stat.pdf", "$path/Project_data/$_\_compare");
}
if($ext){exit;}
my $workbook = Excel::Writer::XLSX -> new("$path/Project_data/Ident_Quant_result/Ident&Quant_SummaryResult.xlsx");
my $worksheet = $workbook -> add_worksheet("Proteins");
my $worksheet2 = $workbook -> add_worksheet("Spectra");
my %font_head = (
    font            => 'Times New Roman',
    size            => 11,
    color           => 'white',
    bold            => 1,
    align           => 'center',
    bg_color        => 'purple',
    valign          => 'vcenter',
    text_wrap       => '1', 
);
my %font_body = (
    font            => 'New Times Roman',
    size            => 11,
    pattern         => 0,
    color           => 'black',
);
my $headFont = $workbook -> add_format(%font_head);
my $bodyFont = $workbook -> add_format(%font_body);
print_stat("reading norm_protein_summary.txt...");
open(my $NOR, "<$path/iTRAQ_Report/norm_protein_summary.txt");
our %norm;
our $row = 0;
while(<$NOR>){
   chomp;
   my @items = split/\t/; 
   $norm{$row} = \@items;
   $row++;
}
close $NOR;
foreach(sort keys %norm){
    my $line = $_;
    foreach($norm{$line}){
        my $val = $_;
        if($line==0){
            $worksheet->write($line, 0, $val, $headFont);
        }else{
            $worksheet->write($line, 0, $val, $bodyFont);
        }
    }
}
print_stat("reading Peptides_Summary-Result.txt...");
open(my $PEPT, "<$path/iTRAQ_Report/Peptides_Summary-Result.txt");
our %PEP;
our $rowPep = 0;
our $confCol;
our $line = 0;
while(<$PEPT>){
    chomp;
    my @itemsPep = split/\t/;
    my $items = \@itemsPep;
    $PEP{$line} = $items;
    $line++;
}
close $PEPT;

my $line2 = 1;
my @sort = sort {$a <=> $b} keys %PEP;
my $len = @sort;
print_stat("writting Ident&Quant_SummaryResult.xlsx...");
foreach(@sort){
    my $line = $_;
    foreach($PEP{$line}){
        my $val = $_;
        if($line==0){
            $worksheet2->write($line, 0, $val, $headFont);
            $confCol = getindx($val,'Conf');
        }elsif(@$val[$confCol]>=95){
            $worksheet2->write($line2, 0, $val, $bodyFont);
            $line2++;
        }
    }
}
sub print_stat{
    my ($mess) = @_;
    my $time = localtime;
    print STDOUT "$time\t$mess\n";
}
sub getindx {
    my($arr,$elem) = @_;
    my @Arr = @$arr;
    my $indx;
    my $size = @$arr;
    $size -= 1;
    foreach(0..$size){
        $indx = $_;
        if($Arr[$indx] eq $elem){
            return $indx;
        }
    }
}
