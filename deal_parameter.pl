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
GetOptions (
    'cp=s'	    => \$compareGroup,
    'fc=f'	    => \$fc_cut,
    'help|h'	    => \$help,
    'f=s'	    => \$database,
    'pj=s'	    => \$project_name,
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

=head
#-----run.sh---------------------------
open(my $FH, ">run.sh") || die "$!";
my $run_code = <<CODE;
perl /ifs1/WORKDIR/huangzhili/Figure_pipeline/iTRAQ_pipeline_v2.3.pl -ef expDesign.txt -i pp_in -nprort 0 -na 1 -fc $fc_cut -pval 0.05 -f $database  -cp $compareGroup
CODE
print $FH $run_code;

#-----II_afterblast.bat----------------
open(my $FHI, ">II_afterblast.bat") || die "$!";

print $compareGroup2,"\n",$compareGroup;

my $I_code = <<CODE;
perl E:\\iTRAQ\\Figure_pipeline\\Function\\function_stat.pl

python E:\\iTRAQ\\Figure_pipeline\\Function\\pie.py

perl E:\\iTRAQ\\Figure_pipeline\\Function\\GO_compare.pl -fi $compareGroup2 -n1 up -n2 down

perl E:\\iTRAQ\\Figure_pipeline\\Function\\pathway_stat_pie.pl -fi $compareGroup2 -n1 up -n2 down

perl E:\\iTRAQ\\Figure_pipeline\\Function\\Enrichment_barchart.pl -cp $compareGroup2

perl E:\\iTRAQ\\Figure_pipeline\\Function\\draw_enrich_number-pvalueV2.1.pl -cp $compareGroup2 -t kegg
CODE
print $FHI $I_code;
=cut

#-----path_of_picture-----------------
open(my $PIC, ">picture_path.txt") || die "$!";

my $picture_path = <<PIC_PATH;
E:\\Project_iTraq_2019\\$project_name\\cv.pdf

E:\\Project_iTraq_2019\\$project_name\\CVbox.pdf

E:\\Project_iTraq_2019\\$project_name\\uniqP.pdf

E:\\Project_iTraq_2019\\$project_name\\pepSeq.pepLength.pdf

E:\\Project_iTraq_2019\\$project_name\\coverage_pie.pdf

E:\\Project_iTraq_2019\\$project_name\\ratio\\normprotRatiodistribution.pdf

E:\\Project_iTraq_2019\\$project_name\\Project_data\\Volcanos\\$compareGroup2\_Volcano.pdf

E:\\Project_iTraq_2019\\$project_name\\function_stat\\fun_stat.pdf

E:\\Project_iTraq_2019\\$project_name\\biological_process.pdf

E:\\Project_iTraq_2019\\$project_name\\cellular_component.pdf

E:\\Project_iTraq_2019\\$project_name\\molecular_function.pdf

E:\\Project_iTraq_2019\\$project_name\\function_stat\\$compareGroup2\_compare_stat.pdf

E:\\Project_iTraq_2019\\$project_name\\function_stat\\$compareGroup2\_Pathway_compare_stat.pdf

E:\\Project_iTraq_2019\\$project_name\\Function\\All_ID_COG\\All_ID.fa.cog.pdf

E:\\Project_iTraq_2019\\$project_name\\Enrichment\\$compareGroup2\_GO_enrichment\\$compareGroup2\_{PFC}_barchart.{'pdf''png'}

E:\\Project_iTraq_2019\\$project_name\\$compareGroup2\_Pathway_enrichment\\$compareGroup2\_path-bubble.png
PIC_PATH

print $PIC $picture_path;



