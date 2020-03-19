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
    'f=s'	        => \$database,
    'm=s'	        => \$marker,
);
my $usage = <<USAGE;
USAGE:
perl deal_parameter.pl <options>
OPTIONS:
    Required:
    -f	<string>    Required. Specify the database
    -cp <string>    Required. Specify the ratio pair name, something like RIF:Ctrl
    -fc <float>	    Required. Specify the FC cutoff.The optional value is 1.2, 1.5, 2   Default is 1.5
    -m	<string>    Required. Specify the marker. for example:113,114,116;117,118,121
    -h		    Optional. Type this help information.
USAGE
die "$usage" if $help;
print "Please input the path of readme file, press ENTER to skip:\n";
our $readmePath = <STDIN>;
chomp $readmePath;
$readmePath = $readmePath eq ''? 'E:\itraq\readme':"$readmePath";
print "Please input the path of itraq script or press ENTER to use the default path'E:\\iTRAQ\\Figure_pipeline':\n";
our $scriptPath = <STDIN>;
chomp $scriptPath;
$scriptPath = $scriptPath eq ''? 'E:\\iTRAQ\\Figure_pipeline':"$scriptPath"; 
print "scriptPath---$scriptPath\nreadmePath---$readmePath\n";
our $compareGroup2 = $compareGroup =~ s/:/-/r;
our $compareGroup3 = $compareGroup =~ s/:/;/r;
our $path = getcwd;
print "The parameter you set are as follows:\nFold Change---$fc_cut\nCompare Group---$compareGroup\nDatabase---$database\n";
$path =~ s/\//\\/g;
our $GoEnrichPath = $path."\\Project_data\\Enrichment\\GO_enrichment\\$compareGroup2\_GO_enrichment";
our $PathwayEnrichPath = $path."\\Project_data\\Enrichment\\Pathway_enrichment\\$compareGroup2\_Pathway_enrichment";
our $GO_comparePath = $path."\\Project_data\\GO_compare";
our $Pathway_comparePath = $path."\\Project_data\\Pathway_compare";
our $HeatmapPath = $path."\\Project_data\\Heatmap\\Heatmap_Abund";
our $Ident_Quant_resultPath = $path."\\Project_data\\Ident_Quant_result";
our $PicturesPath = $path."\\Project_data\\Pictures";
our $VolcanoPath = $path."\\Project_data\\Volcanos";
our @FunctionDirArray = ("ALL_ID_COG","ALL_ID_GO","ALL_ID_Pathway","$compareGroup2\_down_ID_GO","$compareGroup2\_down_ID_Pathway","$compareGroup2\_up_ID_GO","$compareGroup2\_up_ID_Pathway");
foreach(@FunctionDirArray){
    mkpath($path."\\Project_data\\Function\\$_");
}
mkpath($GoEnrichPath); 
mkpath($PathwayEnrichPath);
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
perl $scriptPath\\iTRAQ_pipeline_v2.3.pl -ef expDesign.txt -i pp_in -nprort 0 -na 1 -fc $fc_cut -pval 0.05 -f $database  -cp $compareGroup
CODE
print $FH $run_code;
#-----I_beforblast.bat-----------------
open(my $FHI, ">$path\\I_beforblast.bat") || die "$!";
#-----fc1.5----------------------------
my $i_code_1 = <<CODE_I_1;
perl $scriptPath\\ratio\\combined_new_raio_v-proteinpilot.pl -cp $compareGroup 

perl $scriptPath\\ratio\\norm_final_ratio.pl -cp $compareGroup -type com

perl $scriptPath\\diff\\Diff_fa.pl

perl $scriptPath\\peptide_filted_v2.pl

perl $scriptPath\\Figure\\all_figure.pl

perl $scriptPath\\Figure\\for_cvbox.pl $marker $compareGroup3 

perl $scriptPath\\Figure\\for_cvdis.pl $marker $compareGroup3

perl $scriptPath\\volcano\\For_volcanos_ggplot.pl -cp $compareGroup -fc $fc_cut
CODE_I_1
#-----fc1.2----------------------------
my $i_code_2 = <<CODE_I_2;
perl $scriptPath\\ratio\\ratio\\combined_new_raio_v-proteinpilot.pl -cp $compareGroup 

perl $scriptPath\\ratio\\ratio\\norm_final_ratio.pl -cp $compareGroup -type com

perl $scriptPath\\diff\\Diff_fa.pl

perl $scriptPath\\peptide_filted_v2.pl

perl $scriptPath\\Figure\\all_figure.pl

perl $scriptPath\\Figure\\for_cvbox.pl $marker $compareGroup3 

perl $scriptPath\\Figure\\for_cvdis.pl $marker $compareGroup3

perl $scriptPath\\volcano\\For_volcanos_ggplot.pl -cp $compareGroup -fc $fc_cut
CODE_I_2
#-----fc2-------------------------------
my $i_code_3 = <<CODE_I_3;
perl $scriptPath\\ratio\\ratio2\\combined_new_raio_v-proteinpilot.pl -cp $compareGroup 

perl $scriptPath\\ratio\\ratio2\\norm_final_ratio.pl -cp $compareGroup -type com

perl $scriptPath\\diff\\Diff_fa.pl

perl $scriptPath\\peptide_filted_v2.pl

perl $scriptPath\\Figure\\all_figure.pl

perl $scriptPath\\Figure\\for_cvbox.pl $marker $compareGroup3 

perl $scriptPath\\Figure\\for_cvdis.pl $marker $compareGroup3

perl $scriptPath\\volcano\\For_volcanos_ggplot.pl -cp $compareGroup -fc $fc_cut
CODE_I_3
if($fc_cut==1.5){
	print $FHI $i_code_1;
}elsif($fc_cut==1.2){
	print $FHI $i_code_2;
}elsif($fc_cut==2){
	print $FHI $i_code_3;
}
#-----II_afterblast.bat----------------
open(my $FHII, ">$path\\II_afterblast.bat") || die "$!";

my $ii_code = <<CODE_II;
perl $scriptPath\\Function\\function_stat.pl

python $scriptPath\\Function\\pie.py

perl $scriptPath\\Function\\GO_compare.pl -fi $compareGroup2 -n1 up -n2 down

perl $scriptPath\\Function\\pathway_stat_pie.pl -fi $compareGroup2 -n1 up -n2 down

perl $scriptPath\\Function\\Enrichment_barchart.pl -cp $compareGroup2

perl $scriptPath\\Function\\draw_enrich_number-pvalueV2.1.pl -cp $compareGroup2 -t kegg
CODE_II
print $FHII $ii_code;

#-----III_diffunctenrich.bat----------
open(my $FHIII, ">$path\\III_diffunctenrich.bat") || die "$!";
my $iii_code = <<CODE_III;
perl $scriptPath\\diff\\Diff_function_enrichment.pl
CODE_III
print $FHIII $iii_code;

#-----run_function.sh-----------------
open(my $FHF, ">$path\\run_function.sh") || die "$!";
my $function_code = <<CODE_FUN;
sh /home/zhaohaiyi/workPipeline/b2g4pipe/function_all.sh -i All_ID -n animal -k animal -u -v
sh /home/zhaohaiyi/workPipeline/b2g4pipe/function_all.sh -i $compareGroup2\_up_ID -n animal -k animal -u -v
sh /home/zhaohaiyi/workPipeline/b2g4pipe/function_all.sh -i $compareGroup2\_down_ID -n animal -k animal -u -v


sh /home/zhaohaiyi/workPipeline/b2g4pipe/function_all.sh -i All_ID -d $compareGroup2 -n animal -k animal -c -g -w
CODE_FUN
print $FHF $function_code;

#-----v.bat---------------------------
open(my $V, ">$path\\v.bat") || die "$!";
my $v_code = <<CODE_V;
perl $scriptPath\\excel\\project_data_excel_change_V1.2.pl
CODE_V
print $V $v_code;

#-----path_of_picture-----------------
open(my $PIC, ">$path\\picture_path.txt") || die "$!";

my $pic_path = <<PIC_PATH;
$path\\cv.pdf

$path\\CVbox.pdf

$path\\uniqP.pdf

$path\\pepSeq.pepLength.pdf

$path\\coverage_pie.pdf

$path\\ratio\\normprotRatiodistribution.pdf

$path\\Project_data\\Volcanos\\$compareGroup2\_Volcano.pdf
$path\\Project_data\\Volcanos\\$compareGroup2\_Volcano.png

$path\\function_stat\\fun_stat.pdf

$path\\biological_process.pdf

$path\\cellular_component.pdf

$path\\molecular_function.pdf

$path\\function_stat\\$compareGroup2\_go_compare_stat.pdf

$path\\function_stat\\$compareGroup2\_Pathway_compare_stat.pdf

$path\\Project_data\\Function\\All_ID_COG\\All_ID.fa.cog.pdf

$path\\Project_data\\Enrichment\\GO_enrichment\\$compareGroup2\_GO_enrichment\\$compareGroup2\_BP-barchart.pdf
$path\\Project_data\\Enrichment\\GO_enrichment\\$compareGroup2\_GO_enrichment\\$compareGroup2\_BP-barchart.png
$path\\Project_data\\Enrichment\\GO_enrichment\\$compareGroup2\_GO_enrichment\\$compareGroup2\_MF-barchart.pdf
$path\\Project_data\\Enrichment\\GO_enrichment\\$compareGroup2\_GO_enrichment\\$compareGroup2\_MF-barchart.png
$path\\Project_data\\Enrichment\\GO_enrichment\\$compareGroup2\_GO_enrichment\\$compareGroup2\_CC-barchart.pdf
$path\\Project_data\\Enrichment\\GO_enrichment\\$compareGroup2\_GO_enrichment\\$compareGroup2\_CC-barchart.png

$path\\Project_data\\Enrichment\\Pathway_enrichment\\$compareGroup2\_Pathway_enrichment\\$compareGroup2\.path-bubble.png
$path\\Project_data\\Enrichment\\Pathway_enrichment\\$compareGroup2\_Pathway_enrichment\\$compareGroup2\.path-bubble.pdf
PIC_PATH
print $PIC $pic_path;
#-----expDesign.txt--------------------
open(my $EXP, ">$path\\expDesign.txt") || die "$!";
my ($group1,$group2) = split(":",$compareGroup);
my ($marker1,$marker2) = split(";",$marker);
print "$group1---$marker1\n$group2---$marker2";
my @markerArray1 = split(",",$marker1);
my @markerArray2 = split(",",$marker2);
my $size = @markerArray1;
if($size == 2){
my $exp_code2 =<<CODE_EXEP2;
Marker\tExperiment Name
$markerArray1[0]\t$group1
$markerArray1[1]\t$group1
$markerArray2[0]\t$group2
$markerArray2[1]\t$group2
CODE_EXEP2
print $EXP $exp_code2;
}elsif($size == 3){
my $exp_code3 =<<CODE_EXP3;
Marker\tExperiment Name
$markerArray1[0]\t$group1
$markerArray1[1]\t$group1
$markerArray1[2]\t$group1
$markerArray2[0]\t$group2
$markerArray2[1]\t$group2
$markerArray2[2]\t$group2
CODE_EXP3
print $EXP $exp_code3;
}
