<<<<<<< HEAD
#!/usr/bin/perl -w
use Bio::SeqIO;
use Bio::Tools::SeqStats;
use Getopt::Long;
my $database;
GetOptions (
    'f=s'  => \$database,
);
my $num = 0;
my $in = Bio::SeqIO->new(-file => $database , -format => 'Fasta');
while(my $seq = $in->next_seq){
   $num++; 
}
print $num,'\n';
=======
#!/usr/bin/perl -w
use Bio::SeqIO;
use Bio::Tools::SeqStats;
use Getopt::Long;
my $database;
GetOptions (
    'f=s'  => \$database,
);
my $num = 0;
my $in = Bio::SeqIO->new(-file => $database , -format => 'Fasta');
while(my $seq = $in->next_seq){
   $num++; 
}
print $num,'\n';
>>>>>>> eacc51d2f104772e85b7be1f83255eb81980999b
