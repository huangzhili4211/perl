#!/usr/bin/perl -w
use strict;
use File::Copy;
use Cwd;
use Getopt::Long;
use File::Copy::Recursive qw(dircopy);
our $compareGroup;
our $compareGroup2;
my $new_pic_name;
our $help;
our $path = getcwd;
GetOptions ( 
    'cp=s'	        => \$compareGroup,
    'h|help'	    => \$help,		    
);
my $usage =<<USAGE;
    -cp		    specify the comparegroup,something like RIF:Ctrl
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
    my $line = $_ =~ s/\r|\n//gr;
    if($_ eq "\n") {next;}
    push(@pic_path,$_);
}

my %rename_hash = (
    'cv'			                    => 'Figure3.1',
    'CVbox'			                    => 'Figure3.2',
    'uniqP'			                    => 'Figure3.3',
    'pepSeq.pepLength'		            => 'Figure3.4',
    'coverage_pie'		                => 'Figure3.5',
    'normprotRatiodistribution'	        => 'Figure4.1',
    'Volcano'			                => 'Figure4.2',
    'fun_stat'			                => 'Figure5.1',
    'biological_process'	            => 'Figure5.2',
    'cellular_component'	            => 'Figure5.2',
    'molecular_function'	            => 'Figure5.2',
    'go_compare_stat'		            => 'Figure5.3',
    'All_ID.fa.cog'		                => 'Figure5.4',
    'Pathway_compare_stat'	            => 'Figure5.6',
    'CC-barchart'		                => 'Figure6.1',
    'MF-barchart'		                => 'Figure6.1',
    'BP-barchart'		                => 'Figure6.1',
    '.path-bubble'		                => 'Figure6.3'    

);
my @old_name = keys %rename_hash;
foreach(@old_name){
    my $old_pic_name = $_;
    foreach(@pic_path){
	if(/$compareGroup2\_?$old_pic_name\.(png|pdf)$/){
	     $new_pic_name = $& =~ s/$&/$rename_hash{$old_pic_name}_$&/r;
	     my $cop = File::Spec->catfile($dir,$new_pic_name);
	     my $temp = $_ =~ s/\n$//gr;
	     if(-e $temp){
		 copy($temp,$cop) || die "$temp:$!";
	    }else{print "$& not found!\n";}
	}
	elsif(/$old_pic_name\.pdf$/){
	     $new_pic_name = $& =~ s/$&/$rename_hash{$old_pic_name}_$&/r;
	     my $cop = File::Spec->catfile($dir,$new_pic_name);
	     my $temp = $_ =~ s/\n$//gr;
	     if(-e $temp){
		 copy($temp,$cop) || die "$temp:$!";
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
