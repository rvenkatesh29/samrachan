package CombAlwaysElseOnly;


use strict;
use warnings;
use utf8;

sub always_comb_elseonly {
    my ($line1,$line_no) = @_;
    my $expect_end =0;
    my $orig_line_no = $line_no;
    my $end_occurred = 0;
    $line1 =~ s/\s*//g;
    
    while ($line1 =~ /^$/) {
        $line_no = $line_no+1;
        if ($line_no > $VerilogParser::max_line) {
            die "Max line reached at check_module";
        }
        $line1 .= $VerilogParser::verilog_file[$line_no];
        chomp($line1);
        $line1 =~ s/\s*//g;        
    }
    #$JsonOutput::module_json{$VerilogParser::module_name}{"${always_count}_सदाङ्ग"}{${if_count}_यद्यङ्ग"}{"प्रकारः"} = "यद्यङ्ग";
    my $elseif_symbol = pop @CombAlways::always_comb_block;
    if ($elseif_symbol ne "#") {
        die "error from always_comb_elseif \@ $line_no";
    }
    my $elseif_count = pop @CombAlways::always_comb_block;
    push @CombAlways::always_comb_block,0;
    push @CombAlways::always_comb_block, "##";
    
    my $json_var = $JsonOutput::module_json{$VerilogParser::module_name};
    my $arr_cnt = scalar @CombAlways::always_comb_block;
    my $arr_trk=0;
    my $statement_type;
    my $statement_count;
    my $json_statement;

    while ($arr_trk < $arr_cnt) {
        $statement_type = $CombAlways::always_comb_block[$arr_trk+1];
        $statement_count = $CombAlways::always_comb_block[$arr_trk];
        $arr_trk= $arr_trk+2;
        
        
        if ($statement_type eq "\$") {
            $json_statement = ${statement_count}."_सदाङ्गम्";
            $json_var = $json_var->{$json_statement};
        } elsif ($statement_type eq "_") {
            $json_statement = ${statement_count}."_यद्यङ्गम्";
            $json_var->{$json_statement} //= {};
            $json_var = $json_var->{$json_statement};
        } elsif ($statement_type eq "#") {
            $json_statement = ${statement_count}."_अन्यथायद्यङ्गम्";
            $json_var->{$json_statement} //= {};
            $json_var = $json_var->{$json_statement};            
        } elsif ($statement_type eq "##") {
            $json_statement = ${statement_count}."_अन्यथाऽङ्गम्";
            $json_var->{$json_statement} //= {};
            $json_var = $json_var->{$json_statement};            
        }
    }

    $json_var->{"प्रकारः"} = "अन्यथाऽङ्गम्";

    if ($line1 =~ /begin/) {
        $expect_end = 1;
        $line1 =~ s/begin//;
    }
    while (1) {

        while ($line1 =~ /^$/) {
            $line_no = $line_no+1;
            if ($line_no > $VerilogParser::max_line) {
                die "Max line reached at always_comb_if";
            }
            $line1 .= $VerilogParser::verilog_file[$line_no];
            chomp($line1);
            $line1 =~ s/\s*//g;        
        } 
        if ($line1 =~ /^end$/) {
            if ($expect_end == 1) {
                $end_occurred = 1
            } else {
                die "Extra end present";
                $end_occurred =1;
            }
        } elsif ($line1 =~ /([a-zA-Z_]+)=/) { #Check for Statement
            my $var_name = $1;
            my $statement;
            my @statement_temp = CheckExpr::create_postfix($line1);
            for (my $temp =0; $temp < scalar @statement_temp; $temp = $temp+1) {
                $statement .= $statement_temp[$temp]." ";
            }
            my $stt = ${VerilogParser::statement_line}."_वाक्यम्";
            $json_var->{$stt} //= {};
            $json_var->{$stt}->{"प्रकारः"} = "वाक्यम्";
            $json_var->{$stt}->{"वाक्यम्"} = $statement;
            $json_var->{$stt}->{"क्रमः"} = $VerilogParser::statement_order;
            $VerilogParser::statement_order = $VerilogParser::statement_order+1;
            $line_no = $line_no+1;
            $line1 = "";
            $VerilogParser::statement_line = $VerilogParser::statement_line+1;
            if ($expect_end == 0) {
                $end_occurred = 1;
            }

        } elsif ($line1 =~ /endmodule|always/) {
            die "Missing end at $line_no with line $line1";
        } else {
            die "Error occured $line1";
        }
        if ($end_occurred) {
            last;
       }
    }
    $orig_line_no=$line_no;
    while ($line1 =~ /^$/) {
        $line_no = $line_no+1;
        if ($line_no > $VerilogParser::max_line) {
            die "Max line reached at always_comb_elseif";
        }
        $line1 .= $VerilogParser::verilog_file[$line_no];
        chomp($line1);
        $line1 =~ s/\s*//g;        
    }
    pop @CombAlways::always_comb_block;
    pop @CombAlways::always_comb_block;
    pop @CombAlways::always_comb_block;
    pop @CombAlways::always_comb_block;
    return $orig_line_no;

}

1;