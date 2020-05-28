#!/usr/bin/perl -w
use strict;
my $cp_a = $ARGV[0];
my $cp_b = $ARGV[1];
my $cp_c = $ARGV[2];
my $cp_d = $ARGV[3];

open(FH_A,"<$cp_a.txt") or die "$!\n";
open(FH_B,"<$cp_b.txt") or die "$!\n";
open(FH_C,"<$cp_c.txt") or die "$!\n";
open(FH_D,"<$cp_d.txt") or die "$!\n";
#open(RESULT,">venn_result.txt") or die "$!\n";
my (@a,@b,@c,@d);
my (%a,%b,%c,%d);
my (@a_b,@a_c,@a_d,@b_c,@b_d,@c_d);
my (%a_b,%a_c,%a_d,%b_c,%b_d,%c_d);
my (@a_only,@b_only,@c_only,@d_only);
my (@abc,@abd,@acd,@bcd);
my (@abc_only,@abd_only,@acd_only,@bcd_only);
my (@ab_only,@ac_only,@ad_only,@bc_only,@bd_only,@cd_only);
my @abcd;
while(<FH_A>){
    chomp;
    my $a = $_;
    push(@a,$a);
}
while(<FH_B>){
    chomp;
    push(@b,$_);
}
while(<FH_C>){
    chomp;
    push(@c,$_);
}
while(<FH_D>){
    chomp;
    push(@d,$_);
}
my $a = @a;
my $b = @b;
my $c = @c;
my $d = @d;
print "a---$cp_a---$a\nb---$cp_b---$b\nc---$cp_c---$c\nd---$cp_d---$d\n";
foreach(@a){
    my $a = $_;
    $a{$_} = 1;
    foreach(@b){
	my $b = $_;
	$b{$_} = 1;
	if($a eq $b){
	    push(@a_b,$b);
	    $a_b{$b} = 1;
	}
    }
    foreach(@c){
	my $c = $_;
	$c{$_} = 1;
	if($a eq $c){
	    push(@a_c,$c);
	    $a_c{$c} = 1;
	}
    }
    foreach(@d){
	my $d = $_;
	$d{$_} = 1;
	if($a eq $d){
	    push(@a_d,$d);
	    $a_d{$d} = 1;
	}
    }
}
my $ab = @a_b;
my $ac = @a_c;
my $ad = @a_d;
print "ab---$ab\nac---$ac\nad---$ad\n";
foreach(@b){
    my $b = $_;
    foreach(@c){
	my $c = $_;
	if($b eq $c){
	    push(@b_c,$c);
	    $b_c{$c} = 1;
	}
    }
    foreach(@d){
	my $d = $_;
	if($b eq $d){
	    push(@b_d,$d);
	    $b_d{$d} = 1;
	}
    }
}
my $bc = @b_c;
my $bd = @b_d;
print "bc---$bc\nbd---$bd\n";
foreach(@c){
    my $c = $_;
    foreach(@d){
	my $d = $_;
	if($c eq $d){
	    push(@c_d,$d);
	    $c_d{$d} = 1;
	}
    }
}

my $cd = @c_d;
print "cd---$cd\n";
my %group_id;
foreach(@a){
    if(! exists $a_b{$_} && ! exists $a_c{$_} && ! exists $a_d{$_}){
	push(@a_only, $_);
    }
}
my $a_only = @a_only;
@{$group_id{"a_only"}} = @a_only;
print "a_only---$a_only\n";
foreach(@b){
    if(! exists $a_b{$_} && ! exists $b_c{$_} && ! exists $b_d{$_}){
	push(@b_only, $_);
    }
}
my $b_only = @b_only;
@{$group_id{"b_only"}} = @b_only;
print "b_only---$b_only\n";
foreach(@c){
    if(! exists $a_c{$_} && ! exists $b_c{$_} && ! exists $c_d{$_}){
	push(@c_only, $_);
    }
}
my $c_only = @c_only;
@{$group_id{"c_only"}} = @c_only;
print "c_only---$c_only\n";
foreach(@d){
    if(! exists $a_d{$_} && ! exists $b_d{$_} && ! exists $c_d{$_}){
	push(@d_only, $_);
    }
}
my $d_only = @d_only;
@{$group_id{"d_only"}} = @d_only;
print "d_only---$d_only\n";

foreach(@a_b){
    my $ab = $_;
    if(! exists $c{$ab} && ! exists $d{$ab}){
	push(@ab_only, $ab);
    }
}
my $ab_only = @ab_only;
@{$group_id{"ab_only"}} = @ab_only;
print "ab_only---$ab_only\n";
foreach(@a_c){
    my $ac = $_;
    if(! exists $b{$ac} && ! exists $d{$ac}){
	push(@ac_only, $ac);
    }
}
my $ac_only = @ac_only;
@{$group_id{"ac_only"}} = @ac_only;
print "ac_only---$ac_only\n";
foreach(@a_d){
    my $ad = $_;
    if(! exists $c{$ad} && ! exists $b{$ad}){
	push(@ad_only, $ad);
    }
}
my $ad_only = @ad_only;
@{$group_id{"ad_only"}} = @ad_only;
print "ad_only---$ad_only\n";
foreach(@b_c){
    my $bc = $_;
    if(! exists $a{$bc} && ! exists $d{$bc}){
	push(@bc_only, $bc);
    }
}
my $bc_only = @bc_only;
@{$group_id{"bc_only"}} = @bc_only;
print "bc_only---$bc_only\n";
foreach(@b_d){
    my $bd = $_;
    if(! exists $a{$bd} && ! exists $c{$bd}){
	push(@bd_only, $bd);
    }
}
my $bd_only = @bd_only;
@{$group_id{"bd_only"}} = @bd_only;
print "bd_only---$bd_only\n";
foreach(@c_d){
    my $cd = $_;
    if(! exists $a{$cd} && ! exists $b{$cd}){
	push(@cd_only, $cd);
    }
}
my $cd_only = @cd_only;
@{$group_id{"cd_only"}} = @cd_only;
print "cd_only---$cd_only\n";

foreach(@a_b){
    my $ab = $_;
    foreach(@c){
	my $c = $_;
	if($ab eq $c){
	    push(@abc, $c);
	    if(! exists $d{$c}){
		push(@abc_only, $c);
	    }
	}
    }
}
my $abc_only = @abc_only;
@{$group_id{"abc_only"}} = @abc_only;
print "abc_only---$abc_only\n";
foreach(@a_b){
    my $ab = $_;
    foreach(@d){
	my $d = $_;
	if($ab eq $d){
	    push(@abd, $d);
	    if(! exists $c{$d}){
		push(@abd_only, $d);
	    }
	}
    }
}
my $abd_only = @abd_only;
@{$group_id{"abd_only"}} = @abd_only;
print "abd_only---$abd_only\n";
foreach(@b_c){
    my $bc = $_;
    foreach(@d){
	my $d = $_;
	if($bc eq $d){
	    push(@bcd, $d);
	    if(! exists $a{$d}){
		push(@bcd_only, $d);
	    }
	}
    }
}
my $bcd_only = @bcd_only;
@{$group_id{"bcd_only"}} = @bcd_only;
print "bcd_only---$bcd_only\n";
foreach(@a_c){
    my $ac = $_;
    foreach(@d){
	my $d = $_;
	if($ac eq $d){
	    push(@acd, $d);
	    if(! exists $b{$d}){
		push(@acd_only, $d);
	    }
	}
    }
}
my $acd_only = @acd_only;
@{$group_id{"acd_only"}} = @acd_only;
print "acd_only---$acd_only\n";
foreach(@a_b){
    my $ab = $_;
    foreach(@c_d){
	my $cd = $_;
	if($ab eq $cd){
	    push(@abcd, $cd);
	}
    }
}
@{$group_id{"abcd"}} = @abcd;
my $abcd = @abcd;
print "abcd---$abcd\n";


my @cp = ("$cp_a","$cp_b","$cp_c","$cp_d");
my %express_a = express_to_hash("$cp_a");
my %express_c = express_to_hash("$cp_c");
my %express_d = express_to_hash("$cp_d");
my %express_b = express_to_hash("$cp_b");
my %result;
my %group_cp;
@{$group_cp{"a_only"}} = ("$cp_a");
@{$group_cp{"b_only"}} = ("$cp_b");
@{$group_cp{"c_only"}} = ("$cp_c");
@{$group_cp{"d_only"}} = ("$cp_d");
@{$group_cp{"ab_only"}} = ("$cp_a","$cp_b");
@{$group_cp{"ac_only"}} = ("$cp_a","$cp_c");
@{$group_cp{"ad_only"}} = ("$cp_a","$cp_d");
@{$group_cp{"bc_only"}} = ("$cp_b","$cp_c");
@{$group_cp{"bd_only"}} = ("$cp_b","$cp_d");
@{$group_cp{"cd_only"}} = ("$cp_c","$cp_d");
@{$group_cp{"abc_only"}} = ("$cp_a","$cp_b","$cp_c");
@{$group_cp{"abd_only"}} = ("$cp_a","$cp_b","$cp_d");
@{$group_cp{"bcd_only"}} = ("$cp_b","$cp_c","$cp_d");
@{$group_cp{"acd_only"}} = ("$cp_a","$cp_c","$cp_d");
@{$group_cp{"abcd"}} = ("$cp_a","$cp_b","$cp_c","$cp_d");
open(OUT,">venn_result.txt") or die "$!\n";
my @venn_group = ('a_only','b_only','c_only','d_only','ab_only','ac_only','ad_only','bc_only','bd_only','cd_only','abc_only','abd_only','bcd_only','acd_only',"abcd");
foreach(@venn_group){
    my $group = $_;
    my @id = @{$group_id{$group}};
    my $num = @id;
    my @cp = @{$group_cp{$group}};
    my $cp_n = @cp;
    print "$group---$num---@cp\n";
    my $id_num = 0;
    foreach(@id){
	$id_num++;
	my $id = $_;
	my $line = 0;
	my $id_n = @id;
	foreach(@cp){
	    $line++;
	    my $cp = $_;
	    my $exp;
	    my $exp2;
	    my $out_items;
	    if($cp eq $cp_a){
		$exp = $express_a{$cp_a}{$id};
	    }elsif($cp eq $cp_b){
		$exp = $express_b{$cp_b}{$id};
	    }elsif($cp eq $cp_c){
		$exp = $express_c{$cp_c}{$id};
	    }elsif($cp eq $cp_d){
		$exp = $express_d{$cp_d}{$id};
	    }
	    my $temp_id = $id =~ s/\|/\\|/rg;
	    $exp2 = $exp =~ s/$temp_id//rg;
	    if($line==1 && $id_num==1){
		$out_items = "$cp\t$num\t$exp\n"; 
	    }elsif($line<=4 && $id_num==1){
		$out_items = "$cp\t\t$exp2\n";
	    }elsif($line==1 && $id_num>=2){
		$out_items = "\t\t$exp\n";
	    }elsif($line>=2){
		$out_items = "\t\t$exp2\n";
	    }
	    if($id_num == $id_n && $line == $cp_n){
		print OUT "$out_items\n";
	    }else{
		print OUT "$out_items";
	    }
	}
    }
}
#---------------------------------read *_express_diff.txt--------------------------
sub express_to_hash{
    my $cp = shift;
    my $file = "$cp"."_express_diff.txt";
    print "$file\n";
    open(FH,"<$file") or die "$file:$!\n";
    my %express;
    my %head;
    my $line = 0;
    while(<FH>){
	chomp;
	$line++;
	my @items = split/\t/;
	my $item = $_;
	if($line == 1){
	    for(my $i=0;$i<=$#items;$i++){
		$head{$items[$i]} = $i;
	    }
	}else{
	    my $id = $items[$head{'Accession'}];
	    $express{$cp}{$id} =$item;
	}
    }
    close FH;
    return %express;
}
