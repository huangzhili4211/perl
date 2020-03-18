#!/usr/bin/perl -w
use strict;
use Getopt::Long;
use File::Basename;
use Statistics::R;
my $path = './';
my $enrichType = 'go';
my $help;
GetOptions (
	'path|p=s'	=> \$path,
	'type|t=s'	=> \$enrichType,
	'help|h'	=> \$help
);
$path =~ s/\\/\//g;
$path =~ s/(.*)\/$/$1/;
print "$path\n";

my $usage = <<USAGE;
perl $0 -p go_enrich_file.txt -t go
-p <string>  Required. enrichment file folder path.
-t <string>  Required. enrichment type. go or kegg
USAGE
die $usage if $help;
my %functionTypeHash = (
	'C' => 'Cellular Component',
	'F' => 'Molecular Function',
	'P' => 'Biological Process',
	'path' => 'KEGG Pathway',
);

my @suffixlist = qw(.exe .txt);
our $R = "R";
#our $path = dirname($file,@suffixlist);
#our $name = basename($file);
#our $mark = basename($file,@suffixlist);
my @files = $enrichType eq 'go'? glob "$path/*.txt" : glob "$path/*.path";
foreach my $file (@files) {
	my $name = basename($file); # file name 
	my $mark = basename($file,@suffixlist); # file perfix
	my $pictureName = $mark.'-barchart.png';
	my $pdf = $mark.'-barchart.pdf';
	my $pictureTitle = '';
	my $formatedEnrichFile = '';
	if ($enrichType eq 'go') {
		$formatedEnrichFile = readGOenrichFile($name);
		my $m = $1 if $formatedEnrichFile =~ /._([A-Z])\.txt/;
		$pictureTitle = $functionTypeHash{$m};
		$pictureTitle = 'Top20 of '.$pictureTitle;
	}elsif($enrichType eq 'kegg') {
		$formatedEnrichFile = readPathEnrichFile($name);
		$pictureTitle = "Pathway Enrichment(Top20)";
	}else {
		die"FATEL EROOR:Wrong entichmen type!\n";
	}
	draw_R($formatedEnrichFile,$pictureName,$pictureTitle,$pdf);
	unlink "$path/$formatedEnrichFile";
}



###########---- SUB Routine -----################
sub readGOenrichFile {
	my $file = shift;
	my $out = 'formated-'.$file;
	open ENRICH,"$path/$file" or die;
	open OUT,">$path/$out" or die;
	print OUT"Term\tNumber\tEnrichFactor\tPvalue\tSignificant\n";
	while (<ENRICH>) {
		chomp;
		s/\"//g;
		next if /^\s*$/;
		my @items = split /\t/;
		my $term = $items[1];
		my $len = length($term);
		$term = substr($term,0,43) . "…" if $len > 45;
		my $diffNum = $items[2];
		$diffNum = $1 if $diffNum =~ /(.*) of.*/;
		my $totalNum = $items[3];
		$totalNum = $1 if $totalNum =~ /(.*) of.*/;
		my $enrichFactor = sprintf("%.2f",$diffNum/$totalNum);
		my $pvalue = $items[4];
		my $prots = $items[5];
		my @protA = split /,/,$prots;
		my $protNum = @protA;
		my $sigMark = $pvalue <= 0.05? 'Yes':'No';
		my $pvalue2 = -1* log($pvalue)/log(2);
		print OUT"$term\t$protNum\t$enrichFactor\t$pvalue2\t$sigMark\n";
	}
	close ENRICH;
	close OUT;
	return $out;
}
sub readPathEnrichFile {
	my $file = shift;
	my $out = 'formated-'.$file;
	open ENRICH,"$path/$file" or die "cant open $path/$file:$!";
	open OUT,">$path/$out" or die "cant open $out:$!\n";
	print OUT"Term\tNumber\tEnrichFactor\tPvalue\tSignificant\n";
	while (<ENRICH>) {
		chomp;
		s/\"//g;
		next if /^\s*$/;
		next if /^#/;
		my @items = split /\t/;
		my $term = $items[0];
		my $len = length($term);
		$term = substr($term,0,43) . "…" if $len > 45;
		my $diffNum = $items[1];
		my $totalNum = $items[2];
		my $enrichFactor = sprintf("%.2f",$diffNum/$totalNum);
		my $pvalue = $items[3];
		my $prots = $items[5];
		my @protA = split /;/,$prots;
		my $protNum = @protA;
		my $sigMark = $pvalue <= 0.05? 'Yes':'No';
		my $pvalue2 = -1* log($pvalue)/log(2);
		print OUT"$term\t$protNum\t$enrichFactor\t$pvalue2\t$sigMark\n";
	}
	close ENRICH;
	close OUT;
	return $out;
}

sub draw_R {
	my ($file,$pngName,$title,$pdfName) = @_;
	#open ROUT,">draw_go_enrich_barchart.R" or die;
	my $R_code = Statistics::R->new();
$R_code -> run(qq'
library(ggplot2)
library(grid)
#only top20 terms showed
rt <- read.delim(file="$path/$file",sep="\t",header=T,quote="")
rt <- rt[1:20,]
# 绘制pathway/GO富集条形图
pr = ggplot(rt,aes(x=reorder(Term,Number), y=Number,fill=Pvalue)) + geom_bar(stat="identity", width=0.8)
#geom_point()改变条形的宽度
# 自定义渐变颜色和将纵轴柱状图转成横置
pr = pr + scale_fill_gradient(low="red",high="green") + coord_flip()
pr = pr + labs(fill=expression(-Log[2](Pvalue)),x="Term Name",y="Proteins Number",title="$title",font=2)
# 改变图片的样式（主题）
pr=pr + theme_bw()
pr=pr + theme(plot.title=element_text(face="bold", color=rgb(0,0,0),size=12, hjust=0.5,vjust=1.2, angle=360,lineheight=113),
	axis.text.x=element_text(face="plain",size=9,angle=0,color="black"),
	axis.text.y=element_text(face="plain",size=9,angle=0,color="black"),
	axis.title.x=element_text(face="bold",size=10,angle=0,color="black",vjust=0),
	axis.title.y=element_text(face="bold",size=10,angle=90,color="black",hjust=0.5),
	legend.text = element_text(size=8)
	)
ggsave("$path/$pngName",plot=pr,dpi=300,width = 7,height=5)
ggsave("$path/$pdfName",plot=pr,width = 7,height = 5)
');
	#print ROUT "$R_code";
	#system("Rscript draw_go_enrich_barchart.R");
}
