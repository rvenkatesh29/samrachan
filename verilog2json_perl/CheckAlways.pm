package CheckAlways;

use strict;
use warnings;
use utf8;

sub check_always {
    my ($orig_line_no) = @_;
    my $line_no = $orig_line_no;
    my $line1 = $VerilogParser::verilog_file[$line_no];
    chomp($line1);
    while ($line1 !~ /begin|;/) {
        $line_no = $line_no+1;
        if ($line_no > $VerilogParser::max_line) {

            die "Max line reached at check_module";
        }
        $line1 .= $VerilogParser::verilog_file[$line_no];
        chomp($line1);
    }
    $line1 =~ s/\s*//g;
    if ($line1 =~ /always_comb/) {
        $line_no=CombAlways::check_always_comb($orig_line_no);
    } elsif ($line1 =~ /always@\(\*\)/ || $line1 =~ /always@*/) {
        $line_no=CombAlways::check_always_comb($orig_line_no);

    } else {
        die " Error from check_always in matching always line";
    }
    return $line_no;

}
1;
