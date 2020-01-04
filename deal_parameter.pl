#!/usr/bin/perl -w
use strict;
use Getopt::Long;
use Cwd;
my $compareGroup;
my $fc_cut;
my $database;
our $project_name;
my $help;
my @items = ();
my $marker;
my $project = 'Project_iTraq_2019';
GetOptions (
    'cp=s'	    => \$compareGroup,
    'fc=f'	    => \$fc_cut,
    'help|h'	    => \$help,
    'f=s'	    => \$database,
    'pj=s'	    => \$project_name,
    'p=s'	    => \$project,
    'm=s'	    => \$marker,
);

our $compareGroup2 = $compareGroup =~ s/:/-/r;
my $usage = <<USAGE;
USAGE:
perl deal_parameter.pl <options>
OPTIONS:
    Required:
    -cp <string> Required. Specify the ratio pair name, something like 115:114,116:115
    -fc <float>	Required. Specify the FC cutoff. Default is 1.5
    -f <string> Required. Specify the database
    -h Optional. Type this help information.
USAGE
die "$usage" if $help;


#-----run.sh---------------------------
open(my $FH, ">run.sh") || die "$!";
my $run_code = <<CODE;
perl /ifs1/WORKDIR/huangzhili/Figure_pipeline/iTRAQ_pipeline_v2.3.pl -ef expDesign.txt -i pp_in -nprort 0 -na 1 -fc $fc_cut -pval 0.05 -f $database  -cp $compareGroup
CODE
print $FH $run_code;

#-----I_beforblast.bat-----------------
open(my $FHI, ">I_beforblast.bat") || die "$!";
my $compareGroup3 = $compareGroup =~ s/:/;/r;
print $compareGroup3;
my $I_code = <<CODE_I;
::汇总结果，仅带重复项目需要！
perl E:\\iTRAQ\\Figure_pipeline\\ratio\\combined_new_raio_v-proteinpilot.pl -cp $compareGroup 

perl E:\\iTRAQ\\Figure_pipeline\\ratio\\norm_final_ratio.pl -cp $compareGroup -type com
::这两个脚本调用了脚本iTRAQ_first_diff_0713.pl，所以需更改相应路径

::获取差异蛋白fasta文件用于blast（注释富集）
perl E:\\iTRAQ\\Figure_pipeline\\diff\\Diff_fa.pl

::生成可信肽段数目信息
perl E:\\iTRAQ\\Figure_pipeline\\peptide_filted_v2.pl

::作三个肽段统计图
perl E:\\iTRAQ\\Figure_pipeline\\Figure\\all_figure.pl

::以下多批次用，重复性分析CV分布
perl E:\\iTRAQ\\Figure_pipeline\\Figure\\for_cvbox.pl $marker $compareGroup3 

perl E:\\iTRAQ\\Figure_pipeline\\Figure\\for_cvdis.pl $marker $compareGroup3

perl E:\\iTRAQ\\Figure_pipeline\\volcano\\For_volcanos_ggplot.pl -cp $compareGroup -fc $fc_cut
CODE_I

#-----II_afterblast.bat----------------
open(my $FHII, ">II_afterblast.bat") || die "$!";

print $compareGroup2,"\n",$compareGroup;

my $II_code = <<CODE_II;
perl E:\\iTRAQ\\Figure_pipeline\\Function\\function_stat.pl

python E:\\iTRAQ\\Figure_pipeline\\Function\\pie.py

perl E:\\iTRAQ\\Figure_pipeline\\Function\\GO_compare.pl -fi $compareGroup2 -n1 up -n2 down

perl E:\\iTRAQ\\Figure_pipeline\\Function\\pathway_stat_pie.pl -fi $compareGroup2 -n1 up -n2 down

perl E:\\iTRAQ\\Figure_pipeline\\Function\\Enrichment_barchart.pl -cp $compareGroup2

perl E:\\iTRAQ\\Figure_pipeline\\Function\\draw_enrich_number-pvalueV2.1.pl -cp $compareGroup2 -t kegg
CODE_II
print $FHII $II_code;

#-----III_diffunctenrich.bat----------
open(my $FHIII, ">III_diffunctenrich.bat") || die "$!";
my $III_code = <<CODE_III;
III_diffunctenrich.bat
CODE_III
print $FHIII $III_code;

#-----run_function.sh-----------------
open(my $FHF, ">run_function.sh") || die "$!";
my $function_code = <<CODE_FUN;
sh /home/zhaohaiyi/workPipeline/b2g4pipe/function_all.sh -i All_ID -n animal -k animal -u -v
sh /home/zhaohaiyi/workPipeline/b2g4pipe/function_all.sh -i $compareGroup\_up_ID -n animal -k animal -u -v
sh /home/zhaohaiyi/workPipeline/b2g4pipe/function_all.sh -i $compareGroup\_down_ID -n animal -k animal -u -v


sh /home/zhaohaiyi/workPipeline/b2g4pipe/function_all.sh -i All_ID -d $compareGroup -n animal -k animal -c -g -w
CODE_FUN
print $FHF $function_code;



#-----path_of_picture-----------------
open(my $PIC, ">picture_path.txt") || die "$!";

my $picture_path = <<PIC_PATH;
E:\\$project\\$project_name\\cv.pdf

E:\\$project\\$project_name\\CVbox.pdf

E:\\$project\\$project_name\\uniqP.pdf

E:\\$project\\$project_name\\pepSeq.pepLength.pdf

E:\\$project\\$project_name\\coverage_pie.pdf

E:\\$project\\$project_name\\ratio\\normprotRatiodistribution.pdf

E:\\$project\\$project_name\\Project_data\\Volcanos\\$compareGroup2\_Volcano.pdf

E:\\$project\\$project_name\\function_stat\\fun_stat.pdf

E:\\$project\\$project_name\\biological_process.pdf

E:\\$project\\$project_name\\cellular_component.pdf

E:\\$project\\$project_name\\molecular_function.pdf

E:\\$project\\$project_name\\function_stat\\$compareGroup2\_go_compare_stat.pdf

E:\\$project\\$project_name\\function_stat\\$compareGroup2\_Pathway_compare_stat.pdf

E:\\$project\\$project_name\\Function\\All_ID_COG\\All_ID.fa.cog.pdf

E:\\$project\\$project_name\\Enrichment\\$compareGroup2\_GO_enrichment\\$compareGroup2\_P-barchart.pdf
E:\\$project\\$project_name\\Enrichment\\$compareGroup2\_GO_enrichment\\$compareGroup2\_P-barchart.png
E:\\$project\\$project_name\\Enrichment\\$compareGroup2\_GO_enrichment\\$compareGroup2\_F-barchart.pdf
E:\\$project\\$project_name\\Enrichment\\$compareGroup2\_GO_enrichment\\$compareGroup2\_F-barchart.png
E:\\$project\\$project_name\\Enrichment\\$compareGroup2\_GO_enrichment\\$compareGroup2\_C-barchart.pdf
E:\\$project\\$project_name\\Enrichment\\$compareGroup2\_GO_enrichment\\$compareGroup2\_C-barchart.png

E:\\$project\\$project_name\\$compareGroup2\_Pathway_enrichment\\$compareGroup2\.path-bubble.png
PIC_PATH

print $PIC $picture_path;



