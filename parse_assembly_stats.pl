#!/usr/bin/perl -w

####################################################################################################
#
#		Sarah B. Kingan
#		Pacific Biosciences
#		29 March 2018
#
#		Title: parse_assembly_stats.pl
#
#		Project: humanMarketing
#	
#		Input: 	1. accession_assembly_stats.txt
#
#		Output: relevant DB fields
#			
#
####################################################################################################

use strict;
use POSIX qw(ceil);

my $usage = "parse_assembly_stats.pl accession_assembly_stats.txt\n";

# infile
my $infile = shift(@ARGV) or die $usage;


open (IN, $infile);
my %hash;
while (my $line = <IN>) {
        chomp$line;
	if (($line =~ /^#/) && ($line =~ /:/)) {
		my @entry = splitColon($line);
		$hash{$entry[0]} = $entry[1];
	}
	elsif ($line =~ /^all/) {
		my @count = ($line =~ /all/g);
		if (scalar@count == 4) {
			if ($line =~ /[all\s]{4}(\S+)\s([0-9]+)/) {
				$hash{$1} = $2;
			}
		}	
	}
}


#foreach my $key (sort keys %hash) {
#	print $key, "\t", $hash{$key}, "\n";
#}

my @colNames = ('GenBank assembly accession', 'Assembly name', 'Sequencing technology', 'Genome coverage', 'Assembly level', 'total-length', 'total-gap-length', 'scaffold-count', 'scaffold-N50', 'contig-count', 'contig-N50', 'Date');
#print join(",", @colNames), "\n";
my @colValues = ('NA') x scalar(@colNames);
for (my $i = 0; $i < scalar(@colNames); $i++) {
	if (exists $hash{$colNames[$i]}) {
		$colValues[$i] = $hash{$colNames[$i]};
	}
}
print join(",", @colValues), "\n";


sub splitColon {
	my ($string) = @_;
	my @array = split(":", $string);
	for (my $i = 0; $i < scalar(@array); $i++) {
		$array[$i] =~ s/#//g;
		$array[$i] =~ s/^\s+|\s+$//g;
	}
	return @array;
}
