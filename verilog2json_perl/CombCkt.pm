package CombCkt;

use strict;
use warnings;
use utf8;

sub check_assign;
sub create_instance_assign;

sub check_assign {
    my ($line_no) = @_;
    my $line1 = $VerilogParser::verilog_file[$line_no];
    chomp($line1);
    while ($line1 !~ /;/) {
        if ($line_no > $VerilogParser::max_line) {
            die "Max line reached at check_module";
        }
        $line_no++;
        $line1 .= $VerilogParser::verilog_file[$line_no];
        chomp($line1);
    }
    $line1 =~ s/assign//;
    $line1 =~ s/\s+//g;
    create_instance_assign($line1);
    return $line_no;

}

sub create_instance_assign {
    my ($expr)  = @_;
    $expr =~ /([A-Za-z0-9_]*)=/;
    my $out_var = $1;
    $expr =~ s/$out_var=//;
    my @post_fix = CheckExpr::create_postfix($expr);
    my $instance_name = "${out_var}_comb";
    if ( exists $JsonOutput::module_json{$VerilogParser::module_name}{$instance_name}) {
        die "Same wire two times driven";
    } else {
        $JsonOutput::module_json{$VerilogParser::module_name}{$instance_name}{"प्रकारः"} = "अवस्थापनम्";
        if (exists $JsonOutput::module_json{$VerilogParser::module_name}{$out_var}) {
            push @{$JsonOutput::module_json{$VerilogParser::module_name}{$out_var}{"अवस्थित-घटकस्य निर्गमः"}},$instance_name;
            $JsonOutput::module_json{$VerilogParser::module_name}{$out_var}{"निश्चितवर्गः"} = "स्मृतिरहितम्";
            $JsonOutput::module_json{$VerilogParser::module_name}{$instance_name}{"निर्गमः"} = "$out_var";
            $JsonOutput::module_json{$VerilogParser::module_name}{$instance_name}{"प्रवेशः"} = [];
        } else {
            die "Undeclared wire from create_instance_assign";
        }
    }
    my $post_fix_expr;
    foreach my $i (@post_fix) {
        if (!CheckExpr::is_operator($i)) {
            if (exists $JsonOutput::module_json{$VerilogParser::module_name}{$i}) {
                push @{$JsonOutput::module_json{$VerilogParser::module_name}{$instance_name}{"प्रवेशः"}},$i;
                push @{$JsonOutput::module_json{$VerilogParser::module_name}{$i}{"अवस्थित-घटकस्य प्रवेशः"}},$instance_name;
                
            } else {
                die "$i is not defined from create_instance_assign";
            }
        } 
        $post_fix_expr .= $i . " ";
    }
    $JsonOutput::module_json{$VerilogParser::module_name}{$instance_name}{"उत्तरपदव्यञ्जनम्"} = $post_fix_expr; 
}

1;