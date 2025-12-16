package VerilogParser;
use strict;
use warnings;
use utf8;

# Subroutines
sub parse_verilog;
sub check_module;

my $line1;
my @split_line;
my $module_defined=0;
our @verilog_file = ();
our $statement_line=0;
our $statement_order=0;
our $module_name;

my @verilog_file_temp1 = ();
our $verilog_file_lines=0;
my @parts;
our $max_line=0;
my $i;

sub parse_verilog {
    my ($verilog_file_name) = @_;
    $ModulePort::port_ordering =1;
    open(VERILOG_FILE, "<", $verilog_file_name) or die "Cannot open file: $verilog_file_name";
    my @verilog_file_temp = <VERILOG_FILE>;
    close(VERILOG_FILE);
    foreach $line1 (@verilog_file_temp) {
        @parts = split (";", $line1);
        for ($i=0; $i < scalar @parts; $i++) {
            if ($i != scalar @parts -1) {
                $parts[$i] .=";";
            }
        }
        push @verilog_file, @parts;
    }
   $max_line = scalar @verilog_file;
   
    for ($i=0; $i < $max_line ; $i++) {
        $line1 = $VerilogParser::verilog_file[$i];
        chomp($line1);
        
        if ($module_defined == 0) {
            $i = check_module($i);
            open (MODULE_FILE, ">>:encoding(UTF-8)","all_modules.txt") or die "Cannot open all_modules.txt file";
            print MODULE_FILE "${module_name}\n";
            close(MODULE_FILE);
            $ModulePort::port_ordering =1;
        } elsif ($VerilogParser::verilog_file[$i] =~ /^\s*wire/) {
            $i = ModulePort::populate_interconnect($i);
        } elsif ($VerilogParser::verilog_file[$i] =~ /^\s*reg/) {
            $i = ModulePort::populate_interconnect($i);
        } elsif ($VerilogParser::verilog_file[$i] =~ /^\s*input/) {
            $i = ModulePort::populate_port_afterwards($i);
            
        } elsif ($VerilogParser::verilog_file[$i] =~ /^\s*output/) {
            $i = ModulePort::populate_port_afterwards($i);
        } elsif ($VerilogParser::verilog_file[$i] =~ /^\s*inout/) {
            $i = ModulePort::populate_port_afterwards($i);
        } elsif ($VerilogParser::verilog_file[$i] =~ /^\s*assign/) {
           $i = CombCkt::check_assign($i);
        } elsif ($VerilogParser::verilog_file[$i] =~ /^\s*always/) {
           $i = CheckAlways::check_always($i);
        } elsif ($VerilogParser::verilog_file[$i] =~ /^\s*initial/) {

           $i = InitialBlock::initial_block($i);


        } elsif ($VerilogParser::verilog_file[$i] =~ /^\s*$/) {
            
        } elsif ($VerilogParser::verilog_file[$i] =~ /^\s*endmodule/) {
            last;
        } else {
            die "Unknown bareword $VerilogParser::verilog_file[$i]";
        }
    }
   $verilog_file_lines = scalar @verilog_file;
}

#मॉड्यूलं परीक्ष्यताम्
sub check_module {
    my ($line_no) = @_;
    my $line1 = $verilog_file[$line_no];
    chomp($line1);
    while ($line1 !~ /\(/) {
        $line_no++;
        if ($line_no > $max_line) {
            die "Max line reached at VerilogParser::check_module";
        }
        $line1 .= $verilog_file[$line_no];
        chomp($line1);

    }
    $line1 =~ s/module/module_/g;
    $line1 =~ s/\s+//g;
    $line1 =~ /module_([A-Za-z0-9_]+)\(/;
    $VerilogParser::module_name = $1;
    $module_defined  = 1;
    #$JsonOutput::module_json{"नामन्"} = $1;
    $JsonOutput::module_json{$VerilogParser::module_name}{"रेखाङ्कः"} = $line_no+1;
    $JsonOutput::module_json{$VerilogParser::module_name}{"सञ्चिकानाम"} = "sample.v";
    $JsonOutput::module_json{$VerilogParser::module_name}{"प्रकारः"}="घटकः";
    my $module_line_no= ModulePort::get_ports($line_no);
    return $line_no;

}
1;