#! /usr/bin/perl -w
use strict;
use Cwd qw(getcwd);

# this script takes the data from the FPGA team and converts it into a
# format that the development team uses to create the header files.
#
# input files
# baseAddr.csv:
# format
# ADDR_NAME,HexAddr
# all ADDR_NAME start with FPGA_BASE, any line that does parse for this is
# not a valid address line
#
# Register Map.csv
# format:
# baseAddr,registername, register offset, reg addr, R/W permissions, field name, bits [msb:lsb], //other fields not of interest for this script
#
# Script outputs
# Registername, registerOffset, registerAddr, fieldName(all Caps), first bit, last bit, mask, read/write access
# addresses and masks are in hex - no '0x'
# first/last bit in dec
# access is READ_WRITE, READ, WRITE, NONE
#

my $dir;
my $outFile;
my $boardName;
my %baseAddrs;
my %bufferAddrs;
my %usedBaseAddrs;
my $line;
my $key;   #for accessing the hash entries
my $regName;
my $file;
my @fields;
my @files;
my $fileList;
my %inputFiles;

#the files in the directory that are *csv are assumed to be the register maps.
#We expect one file to be named *BaseAddr* and the others to be register maps
sub procBaseFile
{
    my $ethNum;
    #find the base address file
    foreach $file (@files)
    {
        if($file =~ /[Bb]ase\S*[Aa]ddr\S+csv/)
        {
            chomp ($file);
            printf "procBaseFile: processing base address file: $file\n";
            open(BASE, "$file") || die "Failed to open '$file'";
            while( $line = <BASE>)
            {
                chomp($line);
                if($line =~ /^FPGA_BASE/)
                {
                    @fields = split(/,/, $line);   #[0] = name [1] = address
                    #need to map ETH1 to ETH0 and ETH2 to ETH1
                    if( $fields[0] =~ /(\S*)_ETH(\d)_(\S*)/)
                    {
                        $ethNum = $2 - 1;
                        $fields[0]=$1."_ETH$ethNum"."_".$3;
                    }
                    if( !exists ($baseAddrs{$fields[0]}))
                    {
                        $baseAddrs{$fields[0]} = $fields[1];
                    }
                    #we also need the buffer addresses
                    if( ($fields[0] =~ /DEBUG_FRONTHAUL/) || ($fields[0] =~ /DEBUG_BUF/))
                    {
                        printf "Found debug buffer '$fields[0]', [1] = $fields[1], [3] = $fields[3]\n";
                        $bufferAddrs{$fields[0]}{'addr'} = $fields[1];
                        $bufferAddrs{$fields[0]}{'size'} = $fields[3];
                    }
                    #the names of the debug buffers were changed in sub6, so try the new names
                    if( ($fields[0] =~ /DEBUG_FH_BUF/) || ($fields[0] =~ /DEBUG_RF_BUF/))
                    {
                        printf "Found debug buffer '$fields[0]', [1] = $fields[1], [3] = $fields[3]\n";
                        $bufferAddrs{$fields[0]}{'addr'} = $fields[1];
                        $bufferAddrs{$fields[0]}{'size'} = $fields[3];
                    }
                }
            }
            last;  #break out of foreach loop
        }
    }
    close BASE;
    printf LOG "Dumping all base addresses\n";
    foreach $key (keys(%baseAddrs))
    {
        printf LOG "$key , $baseAddrs{$key} \n";
        printf "$key , $baseAddrs{$key} \n";
    }
}

sub procRegFile
{
    my $fieldName;
    my $firstBit;
    my $bitWidth;
    my $accessType;
    my $defVal;
    my $output = "";
    my $tmp_output = "";

    #clear the output buffer
    $regName = $_[0];
    printf "Opening Register file = $regName\n";
    open(REG, "$regName") || die "Failed to open '$regName'";

    # this is a hack caused by the removal of most of the GPIO registers. We want to get all the base
    # addresses for the GPIO register sets but if they are not in the register file then they don't get
    # picked up. So we are going to force a pull in of all of them.
    if($regName =~ /gpio/)
    {
        my $key;
        foreach $key (keys(%baseAddrs))
        {
            if($key =~ /GPIO/)
            {
                $usedBaseAddrs{$key} = $baseAddrs{$key};
            }
        }
    }

    while($line = <REG>)
    {
        chomp ($line);
        #only interested in lines that start with 'FPGA_BASE'
        if(!($line =~ /^FPGA_BASE/))
        {
            next;
        }
        #printf "$line\n";
        @fields = split(/,/ , $line);
        #[0] = base name
        #[1] = reg name
        #[2] = reg offset
        #[3] = reg addr   #this may be a real address or 'CALC' if we need to calc on fly
        #[4] = access
        #[5] = bit field name (lower case)
        #[6] = bit field def
        #[7] = default value
        if(@fields == 7)
        {
            $defVal = "NA";
        }
        else
        {
            $defVal = $fields[7];
        }
        #
        #figure out whether we have the base address
        if(exists ($baseAddrs{$fields[0]}))
        {
            $usedBaseAddrs{$fields[0]} = $baseAddrs{$fields[0]};
        }
        else
        {
            printf LOG "Failed to find $fields[0] in set of base addresses\n";
            printf LOG "Line = $line \n";
            printf "WARN: $fields[0] in set of base addresses not found\n";
            #clean out the list
            foreach $key (keys(%usedBaseAddrs))
            {
                delete $usedBaseAddrs{$key};
            }
            #close all the files
            close REG;
            return;
        }
        #no change needed for field 0,1,2
        #FIELD 3  register address
        # if 'CALC' needs to be calculated
        if($fields[3] eq 'CALC')
        {
            #the register address is the base address + the offset in $fields[2]
            # $fields[3] = $baseAddrs{$fields[0]} + $fields[2];
            my $tmp = hex ($baseAddrs{$fields[0]}) + hex $fields[2];
            $fields[3] = sprintf "%x", $tmp;
        }
        #else the field is ok as is
        #
        #FIELD 4
        if($fields[4] eq "RW") { $accessType = "READ_WRITE"; }
        elsif ($fields[4] eq "RO") { $accessType = "READ"; }
        elsif ($fields[4] eq "WO") { $accessType = "WRITE"; }
        else { $accessType = "NONE"; }

        #FIELD 5
        $fieldName = uc $fields[5];

        #FIELD 6
        #format is either [num1] or [num2:num1]
        #num1 = lsb
        #num2 = msb
        $firstBit = 0;
        $bitWidth = 0;
        if($fields[6] =~ /\[(\d+)\]/)
        {
            #single number
            $firstBit = $1;
            $bitWidth = 1;
        }
        elsif($fields[6] =~ /\[(\d+):(\d+)\]/)
        {
            $firstBit = $2;
            $bitWidth = $1 - $2 + 1;
            #printf "$fields[6] : first bit = $firstBit, bitWidth = $bitWidth\n";
        }
        #FIELD 7
        #default value, check to make sure it does not have a '_' in it
        if($defVal =~ /\w+_\w+/)
        {
            $defVal =~ s/_//;
        }
        #
        #write it all out
        $output = $output . "$fields[0], $fields[1], $fields[2], $fields[3], $fieldName, $firstBit, $bitWidth, $accessType, $defVal\n";
    }

    my @splittedName = split('\.',$regName);
    printf OUT "\n ".$splittedName[0]." REGISTERS,,,,,,,,\n\n";
    printf OUT "BASE ADDR NAME, ADDRESS\n";
    #dump the set of used addresses and clean out the list
    #while we dump it
    foreach $key (keys(%usedBaseAddrs))
    {
        printf OUT "$key , $usedBaseAddrs{$key} \n";
        delete $usedBaseAddrs{$key};
    }

    printf OUT "\nBase_addr_name, Register_name, Reg_addr_Offset_hex, Reg_addr_hex, Field_Name, First bit, Bit Width, Access, Def Value\n";
    printf OUT $output;

    #close all the files
    close REG;
}

sub usage
{
    printf "Usage: regMapBuilder.pl -d <tarDir> -f <inputFileList> -n <boardName>\n";
    exit;
}

# *******************************************************************
# ****
# ****
# ********************** main *****************
# ****
# ****
# *******************************************************************

my $parmCount = 0;
my $gotCount = 0;
for($parmCount = 0; $parmCount < @ARGV; $parmCount++)
{
    #directory where all the input files are placed
    if($ARGV[$parmCount] eq "-d")
    {
        $dir = $ARGV[++$parmCount];
        $gotCount++;
    }
    #file with the list of csv files to use for this register map
    elsif($ARGV[$parmCount] eq "-f")
    {
        $fileList = $ARGV[++$parmCount];
        $gotCount++;
    }
    #name of the board, used to build the register map file name
    elsif($ARGV[$parmCount] eq "-n")
    {
        $boardName = $ARGV[++$parmCount];
        $gotCount++;
    }
    else
    {
        usage();
    }
}
if($gotCount < 3)
{
    usage();
}
##############################################################################
#read in the list of files to use
open(FILES, "$fileList") || die "Failed to open the file list";
while($line = <FILES>)
{
    chomp($line);
    if($line =~ /^#/)
    {
        #commented out line, skip
        next;
    }
    #cleanup any empty space
    if($line =~ /\s*(\S+)\s*/)
    {
        $line = $1;
    }
    if($line =~ /Base/)
    {
        #skip the base address file
        next;
    }
    $inputFiles{$line} = 1;
}

printf "File list:\n";
foreach $key (keys(%inputFiles))
{
    printf "$key\n";
}

###############################################################################################
$outFile = $dir."/".$boardName.".csv";
my $baseDir = getcwd();

printf "Processing files in '$dir'\n";
printf "file name = $outFile\n";
opendir(my $dh, $dir) || die "Failed to open directory '$dir'";
@files = readdir $dh;
open(OUT, ">$outFile") ||die "failed to open output file '$outFile'";
open(LOG, ">$dir/log") ||die "failed to open log file";
chdir($dir);

#find and read in the Base Addresses
procBaseFile();
chdir($baseDir);

printf "Processing Input Files\n";
chdir ($dir);
my $tmpFile;
foreach $file (@files)
{
    if($file =~ /\.csv$/)
    {
        $tmpFile =uc($file);
        #see if we need this file
        #
        my $key;
        foreach $key (keys(%inputFiles))
        {
            $key = uc($key);
            if($tmpFile eq $key)
            {
                printf LOG "*************************   Processing input File $file  *************************\n";
                procRegFile($file);
                last;
            }
            else
            {
                # printf "'$tmpFile' != '$key'\n";
            }
        }
    }
}

#add in the debug buffers
printf OUT "\nBUFFER REGISTERS,,,,,,,\n";
printf OUT "\nBASE ADDR NAME,ADDRESS,,,,,\n";
my $regname;
my $fieldname;
my $bufSize;
foreach $key (keys (%bufferAddrs))
{
    printf OUT "$key,$bufferAddrs{$key}{'addr'}\n";
}
printf OUT "\n";

foreach $key (keys (%bufferAddrs))
{
    #calculate the size of the buffer
    $bufSize = 0;
    if($bufferAddrs{$key}{'size'}=~ /(\d+)M/)
    {
        $bufSize = $1 * 1024 * 1024 * 8;
    }
    if($bufferAddrs{$key}{'size'}=~ /(\d+)K/)
    {
        $bufSize = $1 * 1024 * 8;
    }
    #create the name of the buffer
    $regname = "UNKNOWN";
    $fieldname = "UNKNOWN";
    if($key =~ /FPGA_BASE_ADDR_(\S+)/)
    {
        $regname = "FPGA_REG_" . $1;
    }
    if(($key =~ /FRONTHAUL/) ||($key =~ /DEBUG_FH_BUF/))
    {
        $fieldname = "FH_BUFFER";
    }
    elsif(($key =~ /DEBUG_BUF/) || ($key =~ /DEBUG_RF_BUF/))
    {
        $fieldname = "RF_BUFFER";
    }
    printf OUT "$key,$regname,0,$bufferAddrs{$key}{'addr'},$fieldname,0,$bufSize,READ_WRITE\n";
}

close OUT;
