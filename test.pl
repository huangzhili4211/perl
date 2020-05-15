#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';

sub draw_R() {
    my $R = 'R';
    my $h1 = shift; # 由handler_file方法提供 annotation 中  *_up_ID_Pathway *_up_ID.path文件
    my $h2 = shift; # 由handler_file方法提供annotation 中  *_down_ID_Pathway *_down_ID.path文件
    my %r_up_par = %{$h1};
    my %r_down_par = %{$h2};
    my $temp_up_list = 路径 =~ s/\\/\/\//rg; # 由handler_file方法生成
    my $temp_down_list = 路径 =~ s/\\/\/\//rg; # 由handler_file方法生成
    my $temp_png = 路径 =~ s/\\/\/\//rg; # 图片名称
    my $temp_pdf = 路径 =~ s/\\/\/\//rg; # 图片名称
    my $R_STR_PDF = <<TEST;
    pdf("$temp_pdf", width=13,height=11)
    par(mfrow=c(1,2),mar=c(20,3.5,2,3.5),mgp=c(1,0.8,0),cex.axis=1,cex.lab=1.5,font.lab=2)
    UP <- read.delim(file="$temp_up_list",sep="\t",header=T)
    col=rainbow(10)
    bar<-barplot(UP\$Num,axes=FALSE,xlim=c(0,$r_up_par{'1'}),ylim=c(0,$r_up_par{'3'}),width=1,space=0.2,col="red",border=NA,main="Statistics of Up-Regulated Proteins",cex.main=1)
    axis(2,col ="black",col.axis = "black",cex=0.5,tck=-0.02)
    mtext("Number of Proteins", side=2,line=2,col="black",cex=1,font=2)
    text(x=seq(0.7,$r_up_par{'2'},by=1.2),y= -0.1, srt = 75, adj = 1, labels = UP\$Pathway,xpd=TRUE,font=2,cex=0.8)
    par(new=T,cex.axis=1,yaxs='i')
    plot(bar,UP\$percent,axes=FALSE,xlab="",ylab="",col="black",type="l",lwd=3,xlim=c(0,$r_up_par{'1'}),ylim=c(0,$r_up_par{'4'}))
    axis(4,col ="black", col.axis = "black",cex=0.5,tck=-0.02)
    mtext("Percent (%)", side=4,line=2,col="black",cex=1,font=2)
    text(bar+0.6,y=UP\$percent+2,adj=1,labels=UP\$per,cex=0.6,xpd = TRUE,font=2)

    DOWN <- read.delim(file="$temp_down_list",sep="\t",header=T)
    col=rainbow(10)
    bar<-barplot(DOWN\$Num,axes=FALSE,xlim=c(0,$r_down_par{'1'}),ylim=c(0,$r_down_par{'3'}),width=1,space=0.2,col="blue",border=NA,main="Statistics of Down-Regulated Proteins",cex.main=1)
    axis(2,col ="black",col.axis = "black",cex=0.5,tck=-0.02)
    mtext("Number of Proteins", side=2,line=2,col="black",cex=1,font=2)
    text(x=seq(0.7,$r_down_par{'2'},by=1.2),y=-0.1, srt = 75, adj = 1, labels = DOWN\$Pathway,xpd=TRUE,font=2,cex=0.8)
    par(new=T,cex.axis=1,yaxs='i')
    plot(bar,DOWN\$percent,axes=FALSE,xlab="",ylab="",col="black",type="l",lwd=3,xlim=c(0,$r_down_par{'1'}),ylim=c(0,$r_down_par{'4'}))
    axis(4,col ="black", col.axis = "black",cex=0.5,tck=-0.02)
    mtext("Percent (%)", side=4,line=2,col="black",cex=1,font=2)
    text(bar+0.6,y=DOWN\$percent+1.5,adj=1,labels=DOWN\$per,cex=0.6,xpd = TRUE,font=2)
    dev.off()
TEST
    my $R_STR_PNG = <<TEST;
    png("$temp_png", width=13,height=11,units='in',res=300)
    par(mfrow=c(1,2),mar=c(20,3.5,2,3.5),mgp=c(1,0.8,0),cex.axis=1,cex.lab=1.5,font.lab=2)
    UP <- read.delim(file="$temp_up_list",sep="\t",header=T)
    col=rainbow(10)
    bar<-barplot(UP\$Num,axes=FALSE,xlim=c(0,$r_up_par{'1'}),ylim=c(0,$r_up_par{'3'}),width=1,space=0.2,col="red",border=NA,main="Statistics of Up-Regulated Proteins",cex.main=1)
    axis(2,col ="black",col.axis = "black",cex=0.5,tck=-0.02)
    mtext("Number of Proteins", side=2,line=2,col="black",cex=1,font=2)
    text(x=seq(0.7,$r_up_par{'2'},by=1.2),y= -0.1, srt = 75, adj = 1, labels = UP\$Pathway,xpd=TRUE,font=2,cex=0.8)
    par(new=T,cex.axis=1,yaxs='i')
    plot(bar,UP\$percent,axes=FALSE,xlab="",ylab="",col="black",type="l",lwd=3,xlim=c(0,$r_up_par{'1'}),ylim=c(0,$r_up_par{'4'}))
    axis(4,col ="black", col.axis = "black",cex=0.5,tck=-0.02)
    mtext("Percent (%)", side=4,line=2,col="black",cex=1,font=2)
    text(bar+0.6,y=UP\$percent+2,adj=1,labels=UP\$per,cex=0.6,xpd = TRUE,font=2)

    DOWN <- read.delim(file="$temp_down_list",sep="\t",header=T)
    col=rainbow(10)
    bar<-barplot(DOWN\$Num,axes=FALSE,xlim=c(0,$r_down_par{'1'}),ylim=c(0,$r_down_par{'3'}),width=1,space=0.2,col="blue",border=NA,main="Statistics of Down-Regulated Proteins",cex.main=1)
    axis(2,col ="black",col.axis = "black",cex=0.5,tck=-0.02)
    mtext("Number of Proteins", side=2,line=2,col="black",cex=1,font=2)
    text(x=seq(0.7,$r_down_par{'2'},by=1.2),y=-0.1, srt = 75, adj = 1, labels = DOWN\$Pathway,xpd=TRUE,font=2,cex=0.8)
    par(new=T,cex.axis=1,yaxs='i')
    plot(bar,DOWN\$percent,axes=FALSE,xlab="",ylab="",col="black",type="l",lwd=3,xlim=c(0,$r_down_par{'1'}),ylim=c(0,$r_down_par{'4'}))
    axis(4,col ="black", col.axis = "black",cex=0.5,tck=-0.02)
    mtext("Percent (%)", side=4,line=2,col="black",cex=1,font=2)
    text(bar+0.6,y=DOWN\$percent+1.5,adj=1,labels=DOWN\$per,cex=0.6,xpd = TRUE,font=2)
    dev.off()
TEST
    open R, "| $R --vanilla --slave" or die "$!\n";
    print R $R_STR_PDF;
    print R $R_STR_PNG;
    close R;
}

sub handler_file() {
    my %r_parameter = ();
    my $temp_name = shift;
    my $state = shift;
    open IN, '<', 路径 or die "Can't open file " . 路径 . " : $!\n";
    my $index = 0;
    my %hash_head_index = ();
    my %hash_num_pathway = ();
    my %hash_accession = ();
    while (<IN>) {
        chomp;
        my @items = split "\t", $_;
        if ($index == 0) {
            $index++;
            foreach (0 .. $#items) {
                $hash_head_index{$items[$_]} = $_;
            }
        }
        else {
            my $pathway = $items[$hash_head_index{'#Pathway'}];
            my $accessions = $items[$hash_head_index{'Proteins'}];
            my @array_accession = split ';', $accessions;
            my $accession_num = scalar @array_accession;
            map {$hash_accession{$_}++} @array_accession;
            $hash_num_pathway{$accession_num}{$pathway} = 0;
        }
    }
    close IN;
    my $total = keys %hash_accession;
    open OUT, '>', 路径 or die "Can't open file " . 路径 . " : $!\n";
    print OUT "Pathway\tNum\tpercent\tper\n";
    my $out_index = 0;
    my @array_percent = ();
    my @array_num = ();
    foreach my $num (sort {$b <=> $a} keys %hash_num_pathway) {
        foreach my $pathway (sort {$a cmp $b} keys %{$hash_num_pathway{$num}}) {
            $out_index++;
            my $percent = sprintf("%.2f", $num * 100 / $total);
            my $percent2 = $num . '(' . $percent . ')';
            last if ($out_index > 10);
            push(@array_percent, $percent);
            push(@array_num,$num);
            print OUT "$pathway\t$num\t$percent\t$percent2\n";
        }
    }
    close OUT;
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
    return \%r_parameter;
}

sub _change_name() {
    my $name = shift;
    my $name1;
    if ($name =~ /All/i && $name =~ /Diff/i) {
        $name1 = $name;
    }
    else {
        $name1 = ucfirst($name);
        $name1 = $name1 . "-Regulated";
    }
    return $name1;
}