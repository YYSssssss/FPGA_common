#! /usr/bin/perl -w
use strict;

############################################################
#
#	dupCsvFiles
#	Part of the conversion tool set that converts the multi sheet xlsx into a single sheet
#	xlsx. This script duplicates a few of the csv files generated from the input xlsx that 
#	are needed when the target is a dual band radio.
#	The csv's that are duplicated are
#	TOP_CTRL_ORAN_LPHY
#	TOP_CTRL_DL_DFE
#	TOP_CTRL_UL_DFE
#
#	As part of the duplication, the names have to be changed into the ones needed for the second
#	band. This entails changing the carrier, path, and band numbering from 0-1 or 0-3 to 2-3 or 4-7
#	depending on whether we are converting band and carrier (0-1) or path (0-3).
#
#	This script runs after the script to generate all the csv files. We run this script to created
#	the extra csv files that are needed and then run the main builder tool
#

######################################################################


######################################################################
#
#		-- convertFile --
#
#	Converts a csv file from band 0 naming to band 1 naming. The naming
#	is consistent across the files so this works for all files that 
#	need to be converted. IN is the original file, OUT is the band 1 file
#	converts 
#	c0 -> c2
#	c1 -> c3
#	p0 -> p4
#	p1 -> p5
#	p2 -> p6
#	p3 -> p7
#	b0 -> b1
#
######################################################################

sub convertFile
{

	my $line;
	my @parts;
	my $first;
	my $second;
	my $num;
	my $count = 0;
	my $skipcount = 0;
	#parts are the csv parts of the line
	#0 = register base, convert B0 to B1
	#1 = register name, convert Cx, Px, Bx
	#5 = field name, same conversions as register name
	while($line = <IN>)
	{
		$count++;
		if(!($line =~ /^FPGA_/))
		{
			#line does not define a register
			$skipcount++;
			next;
		}
		@parts = split( /,/ , $line);
		if(@parts < 7)
		{
			#not enough data to be able to convert this line
			printf "Line $count: $line";
			$skipcount++;
			next;
		}
	 	printf OUT0 "$parts[0],$parts[1],$parts[2],CALC,$parts[4],$parts[5],$parts[6],$parts[7]\n";
		#register base
		if($parts[0] =~ /(\S*)_B0/)
		{
			$parts[0] = "$1_B1";
		}
	
		#register name
		if($parts[1] =~ /(\S*)C(\d)(\S*)/)
		{
			$first = $1;
			$num = $2 + 2;
			$second = $3;
			$parts[1] = $first."C".$num.$second;
		}
		if($parts[1] =~ /(\S*)P(\d)(\S*)/)
		{
			$first = $1;
			$num = $2 + 4;
			$second = $3;
			$parts[1] = $first."P".$num.$second;
		}
		if($parts[1] =~ /(\S*)B(\d)(\S*)/)
		{
			$first = $1;
			$num = $2 + 1;
			$second = $3;
			$parts[1] = $first."B".$num.$second;
		}

		#field name
		if($parts[5] =~ /(\S*)c(\d)(\S*)/)
		{
			$first = $1;
			$num = $2 + 2;
			$second = $3;
			$parts[5] = $first."c".$num.$second;
		}
		if($parts[5] =~ /(\S*)p(\d)(\S*)/)
		{
			$first = $1;
			$num = $2 + 4;
			$second = $3;
			$parts[5] = $first."p".$num.$second;
		}
		if($parts[5] =~ /(\S*)b(\d)(\S*)/)
		{
			$first = $1;
			$num = $2 + 1;
			$second = $3;
			$parts[5] = $first."b".$num.$second;
		}
	 	printf OUT1 "$parts[0],$parts[1],$parts[2],CALC,$parts[4],$parts[5],$parts[6],$parts[7]\n";
	}
}

######################################################################
#
#		--  MAIN --
#
######################################################################

my $origDir;

#check the input data
if(@ARGV < 1)
{
	print "usage: dupCsvFiles.pl <srcDirectory> \n";
	exit;
}

$origDir = `pwd`;
chdir ($ARGV[0]);

#the files to duplicate are supposed to be here, try to open them and convert them
print "**********************************\n";
printf "Processing TOP_CTRL_ORAN_LPHY\n";
if(open(IN, "TOP_CTRL_ORAN_LPHY.csv"))
{
	if(!(open(OUT0, ">TOP_CTRL_ORAN_LPHY0.csv")))
	{
		print "Failed to open TOP_CTRL_ORAN_LPHY0.csv\n";
		close(IN);
	}
	elsif(open(OUT1, ">TOP_CTRL_ORAN_LPHY1.csv"))
	{
		convertFile();
		#system("rm TOP_CTRL_ORAN_LPHY.csv");
		close(IN);
		close(OUT1);
		close(OUT0);
	}
	else
	{
		printf "Failed to open TOP_CTRL_ORAN_PHY1.csv for output\n";
		close(IN);
	}
}
else
{
	printf "Can't open TOP_CTRL_ORAN_LPHY.csv\n";
}

print "**********************************\n";
print "Processing TOP_CTRL_DL_DFE\n";
if(open(IN, "TOP_CTRL_DL_DFE.csv"))
{
	if(!(open(OUT0, ">TOP_CTRL_DL_DFE0.csv")))
	{
		print "Failed to open TOP_CTRL_DL_DFE0.csv\n";
		close(IN);
	}
	if(open(OUT1, ">TOP_CTRL_DL_DFE1.csv"))
	{
		convertFile();
		#system("rm TOP_CTRL_DL_DFE.csv");
		close(IN);
		close(OUT0);
		close(OUT1);
	}
	else
	{
		printf "Failed to open TOP_CTRL_DL_DFE1.csv for output\n";
		close(IN);
	}
}
else
{
	printf "Can't open TOP_CTRL_DL_DFE.csv\n";
}


print "**********************************\n";
print "Processing TOP_CTRL_UL_DFE\n";
if(open(IN, "TOP_CTRL_UL_DFE.csv"))
{
	if(!(open(OUT0, ">TOP_CTRL_UL_DFE0.csv")))
	{
		print "Failed to open TOP_CTRL_UL_DFE0.csv\n";
		close(IN);
	}
	if(open(OUT1, ">TOP_CTRL_UL_DFE1.csv"))
	{
		convertFile();
		#system("rm TOP_CTRL_UL_DFE.csv");
		close(IN);
		close(OUT0);
		close(OUT1);
	}
	else
	{
		printf "Failed to open TOP_CTRL_UL_DFE1.csv for output\n";
		close(IN);
	}
}
else
{
	printf "Can't open TOP_CTRL_UL_DFE.csv\n";
}
	
chdir($origDir);

