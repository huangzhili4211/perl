<<<<<<< HEAD
#!/usr/bin/perl -w
use Bio::tools:pIcalculator;
use Bio::SeqIO;
my $in = Bio::SeqIO->new(-fh=>\*STDIN, -format => 'Fasta');
my $calc = Bio::Tools::pICalculator->new(-places => 2, -pKset => 'EMBOSS');

=======
#!/usr/bin/perl -w
use Bio::tools:pIcalculator;
use Bio::SeqIO;
my $in = Bio::SeqIO->new(-fh=>\*STDIN, -format => 'Fasta');
my $calc = Bio::Tools::pICalculator->new(-places => 2, -pKset => 'EMBOSS');

>>>>>>> eacc51d2f104772e85b7be1f83255eb81980999b
