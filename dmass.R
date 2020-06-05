library(ggplot2)
library(grid)
rt=read.table("dmass",sep="\t",header=T)
bks <- pretty(range(-10,10), 8)
p<-ggplot(rt,aes(dMass)) +
  geom_density(fill="#FF4500",colour = "white",alpha=0.6)
  p<- p + scale_y_continuous(expand = c(0.008,0))  #去掉X轴与图形的间隙
  p<- p + scale_x_continuous(limits = c(-10,10),breaks=bks,expand = c(0,0)) #+  #去掉Y轴与图形的间隙
q<-p+theme(
        axis.text.x=element_text(face="plain",size=7,angle=0,color="black",margin=margin(2,0,0,0)),
        axis.line = element_line(colour = "black",size=0.4),
        panel.border=element_rect(fill='transparent',color='gray80',size=0.1),
        axis.text.y=element_text(face="plain",size=7,angle=0,color="black"),
        axis.title.x=element_text(face="plain",size=8,angle=0,color="black",margin = margin(5,0,0,0)),
        axis.title.y=element_text(face="plain",size=8,angle=90,color="black",margin=margin(0,5,0,0)),
        axis.ticks = element_line(size = 0.3),
        axis.ticks.length = unit(0.1,'cm'),
        legend.position="none", # 隐藏图例
       legend.key.size=unit(0.9,'cm'),
        legend.text = element_text(size=17),
        panel.background = element_rect(fill="white" )
    )
ggsave("dmass2.png",plot = q,dpi=300,width = 12,height = 8,units = 'cm')
ggsave("dmass2.pdf",plot=q,width = 12,height = 8,units = 'cm')

