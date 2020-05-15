#!/usr/bin/perl
use warnings;
use strict;
my $R="R";
#use Statistics::Descriptive;
use Cwd;
my $path=getcwd;
my $ppath=$path."/iTRAQ_Report";
open IN,"<$ppath/proteinAbund.txt",or die "can't open the file";
open OUT,">$path/for_cvbox.txt";
my $markArray=$ARGV[0];###113,114;115,116
my @markArray=split";",$markArray;
my $num=scalar @markArray;
my $pair=($markArray=~s/;//g)+1;
my $title=$ARGV[1];#####C,N
my @title=split";",$title;
my $line;
my @items;
my %headHash;
my %cvHash;
while(<IN>)
{
	chomp;
	$line++;
	@items=split/\t/;
	if ($line==1)
	{
		for (my $i=0;$i<=$#items;$i++)
		{
		$headHash{$items[$i]}=$i;
	    }
     }else
     {
     	my @ctrlarea;
     	my @f1;
     	my @f2;
     	my @f3;
     	my @f4;
     	my $i;
     	foreach my $Array(@markArray){
     		my @area;
     		$i++;
     		my @Array=split",",$Array;
     		map{my $area=$items[$headHash{$_}];push(@area,$area)} @Array;
     		my $ctrlcv=cvfun(@area);
     		next if($ctrlcv eq"--");
     		push(@{$cvHash{$title[$i-1]}},$ctrlcv);
     		print OUT"$title[$i-1]\t$ctrlcv\n";
     		}       	        	
	}
}
open CVM,">$path/cv_summary.txt";
foreach my $head(keys %cvHash)
{
	my $cv=$cvHash{$head};
	my @cv=@$cv;
	my $mediancv=&median(\@cv);	
	print CVM"$head\t$mediancv\n";
	}
	sub median{
		my $area=shift;
		my @area=@$area;
		my $num=scalar @area;
		print"$num\n";
		my @sorted=sort {$a <=>$b}@area;
		my $n = @sorted;
		my $value = 0;
		 if ($n == 0) {
	                $value=0;
                }elsif ($n %2 == 1) {
	                $value = $sorted[int($n/2)];	            
                }elsif ($n%2 == 0) {
	                 $value = ($sorted[$n/2] + $sorted[($n/2) - 1])/2;
                }
                return 100*$value;
		}
=pod
sub cvfun{
	my $area=shift;
	my $stat = Statistics::Descriptive::Full->new();
        $stat->add_data($area);
        my $mean = $stat->mean();
         my $variance = $stat->standard_deviation();
        my $CV=($variance/$mean) if ($mean);
        return $CV;
	}
=cut	
sub cvfun{
	my @ratio=@_;
	my @finalratio;
	my $sum;
	map{push(@finalratio,$_) if($_!=0)} @ratio;
	map{$sum+=$_} @finalratio;
	my $meanRatio;
	if(@finalratio>=1){
           $meanRatio=$sum/@finalratio;
      }else{
      	$meanRatio="--";
      	}
      	
     my @finalratio1=sort{$a <=>$b} @finalratio;
	my $n=scalar @finalratio1;
	my $median;
	if($n==0){
		$median="--";
		}else{
	if($n%2==0){
		$median=($finalratio1[($n/2)-1]+$finalratio1[($n/2)])/2;		
	}elsif($n%2==1){
		$median=$finalratio1[($n-1)/2];		
		}
	}	
	#print"@finalratio---$median\n";
	my $sumsd;
	map{my  $sum1=($_-$meanRatio)*($_-$meanRatio);$sumsd+=$sum1;} @finalratio;
	my $sd;
	if(@finalratio>1){
			$sd=sqrt($sumsd/((@finalratio)-1));	
    } else{
	     $sd="--";
	}
	#print"$ret\n";
	my $cv;
	if(@finalratio>1){
			$cv=$sd/$meanRatio;	
       } else{
	     $cv="--";
	}
	my @result=($meanRatio,$median,$sd,$cv);
	#print"$meanRatio\n";
	return $cv;
	}


my $CV_dis=<<DIS;
library(ggplot2)
cv<-read.table(file='for_CVbox.txt',header=F,sep="\t")
lev=levels(cv[,1])
cv[,2]<-cv[,2]*100
print(lev)
for(i in 1:length(lev)){
  cv1=cv[cv[,1]==lev[i],2]
  med=median(cv1)
  out=paste(lev[i],med,sep="---")
  print (out)
}

#png(file = 'CVbox.png',width=500,height=400,res=72*2)
par(mar=c(4,6,2,2),mgp=c(2.5,0.7,0),pty='m',yaxs="i",xaxs="i")
ggplot(cv,aes(x=cv[,1],y=cv[,2]))+geom_boxplot(aes(fill=cv[,1]))+labs(title="CV Box",x='',y='CV Value(%)')+scale_y_continuous(breaks=seq(0, 140, 20))+geom_hline(yintercept = 30,lty=2,lwd=0.6,alpha=0.8)+theme(axis.text=element_text(face="plain",size=8,angle=0,color="black"),
        plot.title = element_text(face="bold",size=12,hjust = 0.5,vjust=2),
        axis.title.x=element_text(face="bold",size=10,angle=0,color="black",vjust=0),
        axis.title.y=element_text(face="bold",size=10,angle=90,color="black",vjust=3),
	legend.position='none')

       

#text(x=1:3,y=-5,cex=1.3,srt=0,
#     labels=levels(cv[,1])
 #    )
     
ggsave("CVbox2.png",dpi=300,width=4,height=4)     
ggsave("CVbox2.pdf",dpi=300,width=4,height=4)     
  dev.off()
  
#  library(devEMF)
#emf(file = 'CVbox.emf',width=4.5,height=3.5,family="Times New Roman")
#par(mar=c(2,4,2,2),mgp=c(1.8,0.7,0),pty='m',yaxs="i",xaxs="i",cex.main=1.2,font.lab=2,font.axis=2)
#boxplot(cv[,2]~cv[,1],main='CV Box',ylab='CV Value(%)',col=rainbow("$num"),pch=4,cex.lab=0.8,cex.axis=0.8,
#       ylim=c(-10,140),tck=-0.01)
       
#require(showtext)
#font.add("times", "C://Windows//Fonts//times.ttf")
#font.add("TIMES", "C://Windows//Fonts//TIMESBD.TTF")
#showtext.auto()
pdf(file = 'CVbox.pdf',width=4.5,height=3.5)
par(mar=c(4,6,2,2),mgp=c(2.5,0.7,0),pty='m',yaxs="i",xaxs="i",cex.main=0.8,font.lab=2,font.axis=2)
boxplot(cv[,2]~cv[,1],main='CV Box',ylab='CV Value(%)',xlab='',col=rainbow("$num"),pch=4,cex.lab=0.7,cex.axis=0.6,
       ylim=c(-10,140)
       )
       
#text(x=1:3,y=-5,cex=1.3,srt=0,
#     labels=levels(cv[,1])
 #    )
  abline(h=30,lty=2)
  dev.off()
  
#png(file = 'CVdistribution.png',width=880,height=420)
#par(mar=c(4,6,2,2),mgp=c(2.5,0.7,0),mfrow=c(1,3),pty='m',yaxs="i",xaxs="i",cex.lab=1.5,cex.axis=1.5,cex.main=1.6)
data<-read.table("$ppath/proteinAbund.txt",head=T)
head(data)
cv<-c(length=length(data[,1]))
fun<-function(x)
{
  sd<-sd(x)
  mean<-mean(x)
  cv<-sd/mean*100
  return(cv) 
}
attach(data)
ctrl<-cbind(X114,X113)
datax<-cbind(X116,X115)
datay<-cbind(X117,X118)
#z<-cbind(X119,X121)
cvctrl<-apply(ctrl,1,fun)
cvx<-apply(datax,1,fun)
cvy<-apply(datay,1,fun)
#cvz<-apply(z,1,fun)
#histfun<-function(x,main,cut)
#{
#hist(x,breaks=cut,col='gray',main='',xlab='CV',
#     xaxt='n',cex.axis=1.5,font.axis=2,font.lab=2,
#     cex.lab=1.5,freq =F,right = F,xlim=c(0,100))
#axis(1,at=seq(0,100,10),labels=seq(0,100,10),las=1.4,cex=2,font=2)
#title(main,cex=1.6,font=2)
#}
#histfun(cvctrl,"OV1 Sample CV Distribution",cut=50)
#histfun(cvx,"OV5 Sample CV Distribution",cut=50)
#histfun(cvy,"OV9 Sample CV Distribution",cut=50)
#histfun(cvz,"MI Sample CV Distribution",cut=40)
dev.off()


DIS
open R,"| $R --vanilla --slave" or die "$!\n";
	print R $CV_dis;
	close R;


