#!/usr/bin/perl -w
use strict;
use File::Copy;
use Getopt::Long;
our $compareGroup;
our $compareGroup2;
my $new_pic_name;
our $project,
our $projectname,
GetOptions ( 
    'cp=s'	    => \$compareGroup,
    'p=s'	    => \$project,
    'pj=s'	    => \$projectname,
);
$compareGroup2 = $compareGroup =~ s/:/-/r;
my $dir = "E:\\$project\\$projectname\\Project_data\\Pictures";
system("mkdir $dir") unless(-e $dir);
my @pic_path = ();
open(my $PIC, "<E:\\$project\\$projectname\\picture_path.txt") || die "$!";
foreach(<$PIC>){
    chomp;
    my $line = $_ =~ s/\r|\n//gr;
    if($_ eq "\n") {next;}
    push(@pic_path,$_);
}

my %rename_hash = (
    'cv'			    => 'Figure3.1',
    'CVbox'			    => 'Figure3.2',
    'uniqP'			    => 'Figure3.3',
    'pepSeq.pepLength'		    => 'Figure3.4',
    'coverage_pie'		    => 'Figure3.5',
    'normprotRatiodistribution'	    => 'Figure4.1',
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
    '.path-bubble'		    => 'Figure6.3'    

);
my @old_name = keys %rename_hash;
foreach(@old_name){
    my $old_pic_name = $_;
    foreach(@pic_path){
	if(/$compareGroup2\_?$old_pic_name\.(png|pdf)$/){
	     $new_pic_name = $& =~ s/$&/$rename_hash{$old_pic_name}_$&/r;
	     print $new_pic_name,"\n";
	     my $cop = File::Spec->catfile($dir,$new_pic_name);
	     my $temp = $_ =~ s/\n$//gr;
	     if(-e $temp){
		 copy($temp,$cop) || die "$temp:$!";
	    }
	}
	elsif(/($old_pic_name)\.pdf$/){
	     $new_pic_name = $& =~ s/$1/$rename_hash{$old_pic_name}_$old_pic_name/r;
	     print $new_pic_name,"\n";
	     my $cop = File::Spec->catfile($dir,$new_pic_name);
	     my $temp = $_ =~ s/\n$//gr;
	     if(-e $temp){
		 copy($temp,$cop) || die "$temp:$!";
	    }
	}
    }
}
