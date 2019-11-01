#! usr/bin/perl
use warnings;
use strict;
open TRINITY,$ARGV[0],or die $!;
open TMP,">tmp",or die $!;
my %len;
while (my $line=<TRINITY>){
	if ($line=~/^>(.*)_(.*)len=(\d+)/){
		chomp $line;
		my $id=$1;
		my $len=$3*1;
		if (!exists $len{$id} || $len{$id} <$len ){
			$len{$id}=$len;
		}
	}
}
close TRINITY;
open TRINITY,$ARGV[0],or die $!;
my $flag=0;
while (my $line=<TRINITY>){
	if ($line=~/^>(.*)_(.*)len=(\d+)/){
		my $length =$3*1;
		 if ($len{$1}==$length){ ##this will cause additional unigene
			 $flag=1;
			$len{$1}=0; ##add this line to solve the error
			$line=">$1\n";
		 }else{
			 $flag=0;
		 }
	 }
	if ($flag==1){
		 print TMP "$line";
	 }
}
close TRINITY;
close TMP;

open FH,"tmp",or die $!;
open OUT,">$ARGV[1]",or die $!;
my $i=0;
while (<FH>){
	chomp;
	$i++;
	if ($i eq 1) {
		print OUT "$_\n";
	}else{
		if (/^>/){
			print OUT "\n$_\n";
		}else{
			print OUT "$_";
		}
	}
}
print OUT "\n";

close FH;
close OUT;
