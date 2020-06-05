#!/usr/bin/perl -w
use strict;
use Getopt::Long;
use Cwd;
use File::Path;
use File::Copy;
our $compareGroup;
my $fc_cut;
my $database;
my $help;
my @items = ();
my $marker;
GetOptions (
    'cp=s'	        => \$compareGroup,
    'fc=f'	        => \$fc_cut,
    'help|h'	        => \$help,
    'm=s'	        => \$marker,
);
my $usage = <<USAGE;
USAGE:
perl deal_parameter.pl <options>
OPTIONS:
    Required:
    -cp <string>    Required. Specify the ratio pair name, something like RIF_1:Ctrl_1;RIF_2:Ctrl_2
    -fc <float>	    Required. Specify the FC cutoff.The optional value is 1.2, 1.5, 2   Default is 1.5
    -m	<string>    Required. Specify the marker. for example:113,114,116;117,118,121
    -h		    Optional. Type this help information.
USAGE
die "$usage" if $help;
print "Please input the database which is in fasta format:\n";
$database = <STDIN>;
chomp $database;
print "Please input the path of readme file, press ENTER to skip:\n";
our $readmePath = <STDIN>;
chomp $readmePath;
$readmePath = $readmePath eq ''? 'E:\itraq\readme':"$readmePath";
print "Please input the path of itraq script or press ENTER to use the default path'E:\\iTRAQ\\Figure_pipeline':\n";
our $scriptPath = <STDIN>;
chomp $scriptPath;
$scriptPath = $scriptPath eq ''? 'E:\\iTRAQ\\Figure_pipeline':"$scriptPath"; 
my @cp = split/;/,$compareGroup;
my $first_cp = $cp[0];
our $compareGroup2 = $first_cp =~ s/:/-/r;
our $compareGroup3 = $first_cp =~ s/:/;/r;
our $path = getcwd;
print "The parameter you set are as follows:\nFold Change---$fc_cut\nCompare Group---$compareGroup\nDatabase---$database\n";
$path =~ s/\//\\/g;
our $EnrichPath = $path."\\Project_data\\Enrichment\\GOPath_enrichment\\compareGroup2\_GOPath_enrichment";
our $GO_comparePath = $path."\\Project_data\\GO_compare";
our $Pathway_comparePath = $path."\\Project_data\\Pathway_compare";
our $HeatmapPath = $path."\\Project_data\\Heatmap";
our $Ident_Quant_resultPath = $path."\\Project_data\\Ident_Quant_result";
our $PicturesPath = $path."\\Project_data\\Pictures";
our $VolcanoPath = $path."\\Project_data\\Volcanos";
our @FunctionDirArray = ("ALL_ID_COG","ALL_ID_GO","ALL_ID_Pathway","compareGroup2\_down_ID_GO","compareGroup2\_down_ID_Pathway","compareGroup2\_up_ID_GO","compareGroup2\_up_ID_Pathway");
foreach(@cp){
    my $cp = $_;
    $cp =~ s/:/-/;
    foreach(@FunctionDirArray){
	my $funcPath = $path."\\Project_data\\Function\\$_"; 
	$funcPath =~ s/compareGroup2/$cp/;
	mkpath($funcPath) unless -e $funcPath;
    }
    foreach("GO","Pathway"){
	my $enrich = $_;
	my $enrichPath = $EnrichPath =~ s/GOPath/$_/rg;
	$enrichPath =~ s/compareGroup2/$cp/g;
	mkpath($enrichPath) unless -e $enrichPath;
    }
}
mkpath($GO_comparePath);
mkpath($Pathway_comparePath);
mkpath($HeatmapPath);
mkpath($Ident_Quant_resultPath);
mkpath($PicturesPath);
mkpath($VolcanoPath);
our %readmeHash = (
    'readme.txt'                        =>  "$path/Project_data",
    'readme-Enrichment.txt'             =>  "$path/Project_data/Enrichment",
    'readme-Function.txt'               =>  "$path/Project_data/Function",
    'readme-GO_enrichment.txt'          =>  "$path/Project_data/Enrichment/GO_enrichment",
    'readme-Heatmap.txt'                =>  "$path/Project_data/Heatmap/Heatmap_Abund",
    'readme-Ident_Quant_result.txt'     =>  "$path/Project_data/Ident_Quant_result",
    'readme-Pathway_enrichment.txt'     =>  "$path/Project_data/Enrichment/Pathway_enrichment"
);

foreach my $readme ( keys %readmeHash){
    copy("$readmePath/$readme", "$readmeHash{$readme}");
}

#-----run.bat---------------------------
open(my $FH, ">$path\\run.bat") || die "$!";
my $run_code = <<CODE;
perl $scriptPath\\iTRAQ_pipeline_v2.3.pl -ef expDesign.txt -i pp_in -nprort 0 -na 1 -fc $fc_cut -pval 0.05 -f $database  -cp $first_cp
CODE
print $FH $run_code;

#-----I_beforblast.bat-----------------
open(my $FHI, ">$path\\I_beforblast.bat") || die "$!";
my $ratio;
if($fc_cut==1.5){
    $ratio = "ratio";
}elsif($fc_cut==1.2){
    $ratio = "ratio\\ratio";
}elsif($fc_cut==2){
    $ratio = "ratio\\ratio2";
}
my $i_code = <<i_code;
perl $scriptPath\\$ratio\\combined_new_raio_v-proteinpilot.pl -cp $compareGroup 

perl $scriptPath\\$ratio\\norm_final_ratio.pl -cp $compareGroup -type com

perl $scriptPath\\diff\\Diff_fa.pl

perl $scriptPath\\peptide_filted_v2.pl

perl $scriptPath\\Figure\\all_figure.pl

perl $scriptPath\\Figure\\for_cvbox.pl $marker $compareGroup3 

perl $scriptPath\\Figure\\for_cvdis.pl $marker $compareGroup3

perl $scriptPath\\volcano\\For_volcanos_ggplot.pl -cp $compareGroup -fc $fc_cut
i_code
print $FHI $i_code;

#-----II_afterblast.bat----------------
open(my $FHII, ">$path\\II_afterblast.bat") || die "$!";

my $ii_code1 = "perl $scriptPath\\Function\\function_stat.pl";
print $FHII "$ii_code1\n\n";
my $ii_code2 = "python $scriptPath\\Function\\pie.py";
print $FHII "$ii_code2\n\n";
foreach(@cp){
    my $cp = $_;
    $cp =~ s/:/-/;
    my $ii_code3 = "perl $scriptPath\\Function\\GO_compare.pl -fi $cp -n1 up -n2 down\n";
    my $ii_code4 = "perl $scriptPath\\Function\\pathway_stat_pie.pl -fi $cp -n1 up -n2 down\n";
    my $ii_code5 = "perl $scriptPath\\Function\\Enrichment_barchart.pl -cp $cp\n";
    my $ii_code6 = "perl $scriptPath\\Function\\draw_enrich_number-pvalueV2.1.pl -cp $cp -t kegg\n\n";
    my @ii = ("$ii_code3","$ii_code4","$ii_code5","$ii_code6");
    foreach(@ii){
	my $line = $_;
	print $FHII "$line";
    }
}

#-----III_diffunctenrich.bat----------
open(my $FHIII, ">$path\\III_diffunctenrich.bat") || die "$!";
my $iii_code = <<CODE_III;
perl $scriptPath\\diff\\Diff_function_enrichment.pl
CODE_III
print $FHIII $iii_code;

#-----run_function.sh-----------------
open(my $FHF, ">$path\\run_function.sh") || die "$!";
my $function_code = "sh /home/zhaohaiyi/workPipeline/b2g4pipe/function_all.sh -i All_ID -n animal -k animal -u -v\n";
print $FHF $function_code;
foreach(@cp){
    my $cp = $_;
    $cp =~ s/:/-/;
    my $function_up = "sh /home/zhaohaiyi/workPipeline/b2g4pipe/function_all.sh -i $cp\_up_ID -n animal -k animal -u -v\n";
    my $function_down = "sh /home/zhaohaiyi/workPipeline/b2g4pipe/function_all.sh -i $cp\_down_ID -n animal -k animal -u -v\n";
    my $enrich_code = "sh /home/zhaohaiyi/workPipeline/b2g4pipe/function_all.sh -i All_ID -d $cp -n animal -k animal -c -g -w\n";
    print $FHF $function_up;
    print $FHF $function_down;
    print $FHF "$enrich_code\n\n";
}

#-----v.bat---------------------------
open(my $V, ">$path\\v.bat") || die "$!";
my $v_code = <<CODE_V;
perl $scriptPath\\excel\\project_data_excel_change_V1.2.pl
CODE_V
print $V $v_code;

#-----expDesign.txt--------------------
open(my $EXP, ">$path\\expDesign.txt") || die "$!";
my ($group1,$group2) = split(":",$first_cp);
my ($marker1,$marker2) = split(";",$marker);
print "$group1---$marker1\n$group2---$marker2";
my @markerArray1 = split(",",$marker1);
my @markerArray2 = split(",",$marker2);
my $size = @markerArray1;
my $i = 0;
for(my $s=0;$s<2*$size;$s++){
    if($s==0){
	my $head = "Marker\tExperiment Name\n$markerArray1[$s]\t$group1\n";
	print $EXP "$head";
    }elsif($s<$size){
	my $item = "$markerArray1[$s]\t$group1\n";
	print $EXP "$item";
    }else{
	my $item = "$markerArray2[$i]\t$group2\n";
	print $EXP "$item";
	$i++;
    }
}
