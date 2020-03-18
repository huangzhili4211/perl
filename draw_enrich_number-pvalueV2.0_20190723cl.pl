#!/usr/bin/perl -w
use strict;
use Getopt::Long;
use File::Basename;
use Statistics::R;
####----GO和KEGG富集气泡图----####
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
	my $pictureName = $mark.'-bubble.png';
	my $pdf = $mark.'-bubble.pdf';
	my $pictureTitle = '';
	my $formatedEnrichFile = '';
	if ($enrichType eq 'go') {
		$formatedEnrichFile = readGOenrichFile($name);
		my $m = $1 if $formatedEnrichFile =~ /._([A-Z])\.txt/;
		$pictureTitle = $functionTypeHash{$m};
		$pictureTitle = $pictureTitle . "(Top20)";
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
		next if /^\s*$/;
		my @items = split /\t/;
		my $term = $items[1];
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
		next if /^\s*$/;
		next if /^#/;
		my @items = split /\t/;
		my $term = $items[0];
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
=pod
sub draw_R {
	my ($file,$pngName,$title,$pdfName) = @_;
	open ROUT,">draw_go_enrich_bubblePlot.R" or die;
	my $R_code = <<POINT;
library(ggplot2)
library(grid)
#only top20 terms showed
rt <- read.delim(file="$path/$file",sep='\t',header=T,quote="")
rt <- rt[1:20,]
# 绘制pathway/GO富集散点图paste(substr(Term, 1,40),"..",sep = ".")
pr = ggplot(rt,aes(EnrichFactor,reorder(paste(substr(Term, 1,40),"..",sep = "."),Number))) + geom_point(aes(size=Number,color=Pvalue))
#geom_point()改变点的大小
# 四维数据的展示
# 自定义渐变颜色
pr = pr + scale_colour_gradient(low="red",high="blue")
pr = pr + labs(color="-log[2](Pvalue)",size="Protein Number",x="Enrich factor",y="Term Name",title="$title",font=2)
# 改变图片的样式（主题）
pr=pr + theme_bw()
pr=pr + theme(plot.title=element_text(face="bold", color=rgb(0,0,0),size=12, hjust=0.5,vjust=1.2, angle=360,lineheight=113),
	axis.text.x=element_text(face="plain",size=9,angle=0,color="black"),
	axis.text.y=element_text(face="plain",size=9,angle=0,color="black"),
	axis.title.x=element_text(face="bold",size=10,angle=0,color="black",vjust=0),
	axis.title.y=element_text(face="bold",size=10,angle=90,color="black",hjust=0.5),
	#panel.border=element_rect(fill='transparent',color='black',size=0.1),
	panel.spacing = unit(2, "lines"),
	legend.key.size=unit(0.5,'cm'),
	panel.grid.minor = element_blank(),panel.grid.major =element_line(colour="white", size=0.5),
	#plot.margin = unit(c(0.1,1,2,2), "lines"), complete = F,
	legend.text = element_text(size=8),
	panel.background = element_rect(fill = "gray95")
	)
ggsave("$path/$pngName",plot=pr,dpi=300,width = 7,height=6)
ggsave("$path/$pdfName",plot=pr,width = 7,height = 6)

POINT
	print ROUT "$R_code";
	system("Rscript draw_go_enrich_bubblePlot.R");
}
=cut
sub draw_R {
	my ($file,$pngName,$title,$pdfName) = @_;
	#open ROUT,">draw_go_enrich_bubblePlot.R" or die;
	my $R_code = Statistics::R->new();
$R_code -> run(qq'
library(ggplot2)
library(grid)
#only top20 terms showed
rt <- read.delim(file="$path/$file",sep="\t",header=T,quote="")
rt <- rt[1:20,]
# 绘制pathway/GO富集散点图
pr = ggplot(rt,aes(EnrichFactor,reorder(paste(substr(Term, 1,40),"..",sep = "."),Number))) + geom_point(aes(size=Number,color=Pvalue))
#geom_point()改变点的大小
# 四维数据的展示
# 自定义渐变颜色
pr = pr + scale_colour_gradient(low="red",high="blue")
pr = pr + labs(color="-log[2](Pvalue)",size="Protein Number",x="Enrich factor",y="Term Name",title="$title",font=2)
# 改变图片的样式（主题）
pr=pr + theme_bw()
pr=pr + theme(plot.title=element_text(face="bold", color=rgb(0,0,0),size=12, hjust=0.5,vjust=1.2, angle=360,lineheight=113),
	axis.text.x=element_text(face="plain",size=9,angle=0,color="black"),
	axis.text.y=element_text(face="plain",size=9,angle=0,color="black"),
	axis.title.x=element_text(face="bold",size=10,angle=0,color="black",vjust=0),
	axis.title.y=element_text(face="bold",size=10,angle=90,color="black",hjust=0.5),
	#panel.border=element_rect(fill="transparent",color="black",size=0.1),
	panel.spacing = unit(2, "lines"),
	legend.key.size=unit(0.5,"cm"),
	panel.grid.minor = element_blank(),panel.grid.major =element_line(colour="white", size=0.5),
	#plot.margin = unit(c(0.1,1,2,2), "lines"), complete = F,
	legend.text = element_text(size=8),
	panel.background = element_rect(fill = "gray95")
	)
ggsave("$path/$pngName",plot=pr,dpi=300,width = 7,height=6)
ggsave("$path/$pdfName",plot=pr,width = 7,height = 6)
');
	#print ROUT "$R_code";
	#system("Rscript draw_go_enrich_bubblePlot.R");
}