package JsonOutput;
use strict;
use warnings;
use utf8;
binmode(STDOUT, ":utf8"); 
use JSON;

sub write_json;
our %module_json;

sub write_json {

    open (JSON_OUTPUT ,">:encoding(UTF-8)","$VerilogParser::module_name.json") or die "Cannot open output file for $VerilogParser::module_name JSON file";
    my $json = to_json(\%module_json, { pretty => 1 });
    print JSON_OUTPUT $json, "\n";
    
    close (JSON_OUTPUT);
}
1;