#!/usr/bin/perl -w
use strict;
use File::Copy;
my $dir = "/hzl/perlcode/Pictures";
mkdir($dir);
my @pic_path = ();
open(my $PIC, "<path_of_pictures.txt") || die "$!";
foreach(<$PIC>){
    if($_ eq "\n") {next;}
    push(@pic_path,$_);
}
print "@pic_path\n";

my %rename_hash = (
    'cv'			    => 'Figure3.1',
    'CVbox'			    => 'Figure3.2',
    'uniqP'			    => 'Figure3.3',
    'pepSeq.pepLength'		    => 'Figure3.4',
    'coverage_pie'		    => 'Figure3.5',
    'proRatiodistribution'	    => 'Figure4.1',
    'Volcano'			    => 'Figure4.2',
    'fun_stat'			    => 'Figure5.1',
    'biological_process'	    => 'Figure5.2',
    'cellular_component'	    => 'Figure5.2',
    'molecular_function'	    => 'Figure5.2',
    'go_compare_stat'		    => 'Figure5.3',
    'All_ID.fa.cog'		    => 'Figure5.4',
    'Pathway_compare_stat'	    => 'Figure5.6',
    'C-barchart'		    => 'Figure6.1',
    'F-barchart'		    => 'Figure6.1',
    'P-barchart'		    => 'Figure6.1',
    'path-bubble'		    => 'Figure6.3'    

);
my @old_name = keys %rename_hash;
foreach(@old_name){
    my $old_pic_name = $_;
    foreach(@pic_path){
	if(/($old_pic_name).pdf$/){
	    my $new_pic_name = $_ =~ s/$1/$rename_hash{$old_pic_name}_$old_pic_name/r;
	    print $new_pic_name,"\n";
	    
	}
      
    }
}
