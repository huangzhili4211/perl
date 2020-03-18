#!/usr/bin/perl -w
use strict;
use Cwd;
my $outpath = getcwd; 
sub draw_R {
	my ($file, $fn, $fc) = @_;
	my $pngName = $fn .".png";
	my $pdfName = $fn . ".pdf";
	#open ROUT,">draw_ggplot_volcano.R" or die;
	#$outpath =~ s/\\/\//g;
	#print "$outpath/$pdfName\n";
	my $R_code = <<RVOL;
	setwd("$outpath")
	All <-read.delim("$file", header =T,row.names=2)
	#View(All)
	library(ggplot2)
	#library(ggrepel)
	adjustP = 0.05
	logFoldChange = log2($fc)
	xMax=max(abs(log2(All\$FC)))
	yMax=max(-log10(All\$Pvalue))
	#xlim=c(-xMax,xMax),ylim=c(0,yMax),yaxs="i",pch=20, cex=0.8
	par(mar=c(4,4,3,3),mgp=c(2.5,0.7,0))
	vol <- ggplot(All, aes(x=log2(FC), y =-log10(Pvalue),color =Significant)) +
	geom_point(alpha=0.8, size=1.2)+ xlim(-xMax,xMax) + ylim(0,yMax)+  #若需要重叠部分颜色渐变，透明度设置小一点alpha=0.5
	scale_color_manual(values =c("blue","gray12","red"))+
	geom_hline(yintercept = -log10(adjustP),lty=2,lwd=0.6,alpha=0.8)+
	geom_vline(xintercept = c(logFoldChange,-logFoldChange),lty=2,lwd=0.6,alpha=0.8)+
	theme_bw()+
	theme(panel.border = element_blank(),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),   
        axis.line = element_line(colour = "black"))+
	labs(title="$fn", x=expression(Log[2](FC)),y=expression(-Log[10](Pval)))+
	theme(axis.text=element_text(face="plain",size=11,angle=0,color="black"),
        plot.title = element_text(face="bold",size=14,hjust = 0.5,vjust=2),
        axis.title.x=element_text(face="bold",size=12,angle=0,color="black",vjust=0),
        axis.title.y=element_text(face="bold",size=12,angle=90,color="black",vjust=3))+
	theme(legend.position='none')
	#geom_point(data=subset(All, Gene != "NA"),alpha=0.8, size=2,col="black")+
	#geom_text_repel(data=subset(All, Gene != "NA"),aes(label=Gene),size=3,col="black",alpha = 0.9)
	ggsave("$pdfName",plot=vol,dpi=300,width=5,height=4)
	ggsave("$pngName",plot=vol,dpi=300,width=5,height=4)
RVOL
	#print ROUT "$R_code";
	#system("Rscript draw_ggplot_volcano.R");
	open R,"| R --vanilla --slave";
	print R $R_code;
	close R;
}

draw_R("adult-5th_Volcano.txt","a","1.3")
