#!/usr/bin/perl -w
use strict;
my $R = 'R';
my $cp = $ARGV[0];
my %r_up_par = &parameter($cp,"up");
my %r_down_par = &parameter($cp,"down");
my $temp_pdf = "$cp\_pathway_compare_stat.pdf";
my $Rcode=<<TEST;
pdf("$temp_pdf", width=13,height=11)
par(mfrow=c(1,2),mar=c(20,3.5,2,3.5),mgp=c(1,0.8,0),cex.axis=1,cex.lab=1.5,font.lab=2)
UP <- read.delim(file="for_stat_$cp\_up_ID.txt",sep="\t",header=T)
col=rainbow(10)
bar<-barplot(UP\$Num,axes=FALSE,xlim=c(0,$r_up_par{'1'}),ylim=c(0,$r_up_par{'3'}),width=1,space=0.2,col="red",border=NA,main="Statistics of Up-Regulated Proteins",cex.main=1)
axis(2,col ="black",col.axis = "black",cex=0.5,tck=-0.02)
mtext("Number of Proteins", side=2,line=2,col="black",cex=1,font=2)
text(x=seq(0.7,$r_up_par{'2'},by=1.2),y= -0.1, srt = 75, adj = 1, labels = UP\$Pathway,xpd=TRUE,font=2,cex=0.8)
par(new=T,cex.axis=1,yaxs='i')
plot(bar,UP\$percent,axes=FALSE,xlab="",ylab="",col="black",type="l",lwd=3,xlim=c(0,$r_up_par{'1'}),ylim=c(0,$r_up_par{'4'}))
axis(4,col ="black", col.axis = "black",cex=0.5,tck=-0.02)
mtext("Percent (%)", side=4,line=2,col="black",cex=1,font=2)
text(bar+0.6,y=UP\$percent+2,adj=1,labels=UP\$per,cex=0.7,xpd = TRUE,font=2)
box(lwd=1)

DOWN <- read.delim(file="for_stat_$cp\_down_ID.txt",sep="\t",header=T)
col=rainbow(10)
bar<-barplot(DOWN\$Num,axes=FALSE,xlim=c(0,$r_down_par{'1'}),ylim=c(0,$r_down_par{'3'}),width=1,space=0.2,col="blue",border=NA,main="Statistics of Down-Regulated Proteins",cex.main=1)
axis(2,col ="black",col.axis = "black",cex=0.5,tck=-0.02)
mtext("Number of Proteins", side=2,line=2,col="black",cex=1,font=2)
text(x=seq(0.7,$r_down_par{'2'},by=1.2),y=-0.1, srt = 75, adj = 1, labels = DOWN\$Pathway,xpd=TRUE,font=2,cex=0.8)
par(new=T,cex.axis=1,yaxs='i')
plot(bar,DOWN\$percent,axes=FALSE,xlab="",ylab="",col="black",type="l",lwd=3,xlim=c(0,$r_down_par{'1'}),ylim=c(0,$r_down_par{'4'}))
axis(4,col ="black", col.axis = "black",cex=0.5,tck=-0.02)
mtext("Percent (%)", side=4,line=2,col="black",cex=1,font=2)
text(bar+0.6,y=DOWN\$percent+1.5,adj=1,labels=DOWN\$per,cex=0.7,xpd = TRUE,font=2)
box(lwd=1)
dev.off()
TEST
   
    open R, "| $R --vanilla --slave" or die "$!\n";
    print R $Rcode;
   
    close R;


sub parameter() {    
    my $cp =shift;
    my $state = shift;
    print "$cp\n$state\n";
    open(PH,"<for_stat_$cp\_$state\_ID.txt") or die "$!\n";
    my %headhash;
    my %r_parameter;
    my @array_percent;
    my @array_num;
    my $line = 0;
    while(<PH>){
	chomp;
	my @items = split/\t/;
	$line++;
	if($line==1){
	    for(my $i=0;$i<=$#items;$i++){
		$headhash{$items[$i]} = $i;
	    }
	}else{
	    push(@array_num,$items[$headhash{'Num'}]);	    
	    push(@array_percent,$items[$headhash{'percent'}]);	    
	}
    }
    @array_num = sort {$b <=> $a} @array_num;
    @array_percent = sort {$b <=> $a} @array_percent;
    my $max_num = $array_num[0];
    my $max_percent = $array_percent[0];
    my $number = $#array_percent + 1;
    $r_parameter{'1'} = 1.2 * $number;
    # print $r_parameter{'1'}."\n";
    $r_parameter{'2'} = 11.5 - (10 - $number) * 1.2;
    # print $r_parameter{'2'}."\n";
    if($max_num <= 10){
        $r_parameter{'3'} = 3 + $max_num;
    }elsif($max_num <= 50){
        $r_parameter{'3'} = 15 + $max_num;
    }elsif($max_num <= 100){
        $r_parameter{'3'} = 30 + $max_num;
    }
    # print $r_parameter{'3'}."\n";
    if($max_num <= 10){
        $r_parameter{'4'} = 3 + $max_percent;
    }elsif($max_num <= 50){
        $r_parameter{'4'} = 15 + $max_percent;
    }elsif($max_num <= 100){
        $r_parameter{'4'} = 30 + $max_percent;
    }
    # print $r_parameter{'4'}."\n";
    return %r_parameter;
}
