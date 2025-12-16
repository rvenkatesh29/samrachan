#This script created Verilog to JSON for schematic drawing
#perl verilog2json.pl <Verilog_module>
no locale;
use strict;
use warnings;
use utf8;
use FindBin;
use lib "$FindBin::Bin/verilog2json_perl";   # tells Perl where to find .pm files

use CheckAlways;
use CheckExpr;
use CheckExprInitialBlock;
use CombAlways;
use CombAlwaysElseIf;
use CombAlwaysElseOnly;
use CombAlwaysIf;
use CombCkt;
use InitialBlock;
use InitialBlockElseIf;
use InitialBlockIf;
use InitialBlockElseOnly;
use JsonOutput;
use ModulePort;
use VerilogParser;



#संस्कृते मुद्रणाय
binmode(STDOUT, ":utf8"); 
use JSON;

# Always - $
# If - #
#initial - !


# To clean all_functions.txt

#फाइलं उद्घाटयतु
if ($ARGV[0] eq "") {
    die "Cannot open empty file"
}
VerilogParser::parse_verilog($ARGV[0]);



#die $error_msg1;


JsonOutput::write_json();
