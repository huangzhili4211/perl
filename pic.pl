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
    -cp		    specify the comparegroup,something like RIF1:Ctrl1;RIF2:Ctrl2
    -p		    process pictures only
    h|help	    help
USAGE
die "$usage" if $help;	
$compareGroup =~ s/:/-/g;
my @cp = split/;/,$compareGroup;
$compareGroup2 = $cp[0]; 
my $dir = "$path\\Project_data\\Pictures";
system("mkdir $dir") unless(-e $dir);
pic_path();
my @pic_path;
open(my $fh, "<$path\\picture_path.txt") || die "$!";
while(<$fh>){
    chomp;
    if($_ eq "\n") {next;}
    push(@pic_path,$_);
}
close $fh;
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
foreach(('GO','Pathway')){
    my $function = $_;
    foreach(@cp){
	my $cp = $_;
	copy("$path/function_stat/$cp\_$function\_compare_stat.pdf", "$path/Project_data/$function\_compare") unless (! -e "$path/function_stat/");
    }
}
if($ext){exit;}


copy("$path/iTRAQ_Report/All_ID.fa","$path/Project_data/Ident_Quant_result");
copy("$path/Function_enrichment_summary/all_express_diff.xlsx", "$path/Project_data/Ident_Quant_result");
our @FunctionDirArray = ("ALL_ID_COG","ALL_ID_GO","ALL_ID_Pathway","compareGroup2_down_ID_GO","compareGroup2_down_ID_Pathway","compareGroup2_up_ID_GO","compareGroup2_up_ID_Pathway");
foreach(@cp){
    my $cp = $_;
    foreach(@FunctionDirArray){
	our $annotationFile = $_;
	$annotationFile =~ s/compareGroup2/$cp/;
	dircopy("$path\\Annotation\\$annotationFile", "$path\\Project_data\\Function\\$annotationFile");
    }
    foreach(('GO','Pathway')){
	dircopy("$path\\Annotation\\$cp\_$_\_enrichment", "$path\\Project_data\\Enrichment\\$_\_enrichment\\$cp\_$_\_enrichment");
    }
}


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
    my $max_index = $#Arr;
    foreach(0..$max_index){
        $indx = $_;
        if($Arr[$indx] eq $elem){
            return $indx;
        }
    }
}

#-----path_of_picture-----------------
sub pic_path{
open(my $PIC, ">$path\\picture_path.txt") || die "$!";
my $go_enrich_path = $path."\\Project_data\\Enrichment\\GO_enrichment\\$compareGroup2\_GO_enrichment";
my $pathway_enrich_path = $path."\\Project_data\\Enrichment\\Pathway_enrichment\\$compareGroup2\_Pathway_enrichment";
my $pic_path = <<PIC_PATH;
$path\\cv.pdf
$path\\cv.png
$path\\CVbox.pdf
$path\\CVbox.png
$path\\uniqP.pdf
$path\\uniqP.png
$path\\pepSeq.pepLength.pdf
$path\\pepSeq.pepLength.png
$path\\coverage_pie.pdf
$path\\coverage_pie.png
$path\\ratio\\normprotRatiodistribution.pdf
$path\\ratio\\normprotRatiodistribution.png
$path\\Project_data\\Volcanos\\$compareGroup2\_Volcano.pdf
$path\\Project_data\\Volcanos\\$compareGroup2\_Volcano.png
$path\\function_stat\\fun_stat.pdf
$path\\function_stat\\fun_stat.png
$path\\biological_process.pdf
$path\\cellular_component.pdf
$path\\molecular_function.pdf
$path\\function_stat\\$compareGroup2\_go_compare_stat.pdf
$path\\function_stat\\$compareGroup2\_go_compare_stat.png
$path\\function_stat\\$compareGroup2\_Pathway_compare_stat.pdf
$path\\function_stat\\$compareGroup2\_Pathway_compare_stat.png
$path\\Project_data\\Function\\All_ID_COG\\All_ID.fa.cog.pdf
$path\\Project_data\\Function\\All_ID_COG\\All_ID.fa.cog.png
$go_enrich_path\\$compareGroup2\_BP-barchart.pdf
$go_enrich_path\\$compareGroup2\_BP-barchart.png
$go_enrich_path\\$compareGroup2\_MF-barchart.pdf
$go_enrich_path\\$compareGroup2\_MF-barchart.png
$go_enrich_path\\$compareGroup2\_CC-barchart.pdf
$go_enrich_path\\$compareGroup2\_CC-barchart.png
$pathway_enrich_path\\$compareGroup2\.path-bubble.png
$pathway_enrich_path\\$compareGroup2\.path-bubble.pdf
PIC_PATH
print $PIC $pic_path;
close $PIC;
}

