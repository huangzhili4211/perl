#!/usr/bin/perl -w
use strict;
open(FH1,"<Acc-1.txt") || die "$!";
open(FH2,"<Acc-2.txt") || die "$!";
open(FH3,"<Acc-3.txt") || die "$!";
#open(JIAJI,">>jiaoji.txt") || die "$!";
my @id1;
my @id2;
my @id3;
while(<FH1>){
    chomp;
    my $id1 = $_;
    push(@id1,$id1);
}

while(<FH2>){
    chomp;
    my $id2 = $_;
    push(@id2,$id2);
}
while(<FH3>){
    chomp;
    my $id3 = $_;
    push(@id3,$id3);
}
my @id12;
my @jiaoji;
foreach(@id1){
    my $id1 = $_;
    foreach(@id2){
        if($id1 eq $_){
            push(@id12,$_);
        }
    }
}
foreach(@id12){
    my $id12 = $_;
    foreach(@id3){
        if($id12 eq $_){
            push(@jiaoji,$_);
        }
    }
}
my $size = @jiaoji;
print "$size";
#my $num = 0;
#foreach(@id1){
#    my $id1 = $_;
#    foreach(@id2){
#        my $id2 = $_;
#        foreach(@id3){
#            my $id3 = $_;
#            if($id1 eq $id2 && $id1 eq $id3){
#                    $num++;
#                    print "$num\n";
#            }
#        }
#    }
#}
#print "$num";
