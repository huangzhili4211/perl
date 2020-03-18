#!/usr/bin/perl -w
use strict;
use Getopt::Long;
use File::Basename;

my $R_code = Statistics::R->new();
$R_code -> run(qq'
library(ggplot2)
library(grid)
#only top20 terms showed
rt <- read.delim(file="$file",sep="\t",header=T,quote="")
#rt <- rt[1:20,]
# 绘制pathway/GO富集散点图
pr = ggplot(rt,aes(EnrichFactor,reorder(Term,Number))) + geom_point(aes(size=Number,color=Pvalue))
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
ggsave("$pngName",plot=pr,dpi=300,width = 7,height=6)
ggsave("$pdfName",plot=pr,width = 7,height = 6)
');
	#print ROUT "$R_code";
	#system("Rscript draw_go_enrich_bubblePlot.R");
}
