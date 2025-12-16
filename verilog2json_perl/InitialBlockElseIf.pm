package InitialBlockElseIf;

use strict;
use warnings;
use utf8;
sub initial_block_elseif {
    my ($line1,$line_no) = @_;
    my $expect_end =0;
    my $orig_line_no = $line_no;
    my $end_occurred = 0;

    $line1 =~ s/if//;
    $line1 =~ s/\s*//g;
    while ($line1 =~ /^$/) {
        $line_no = $line_no+1;
        if ($line_no > $VerilogParser::max_line) {
            die "Max line reached at InitialBlockIf::initial_block_elseif";
        }
        $line1 .= $VerilogParser::verilog_file[$line_no];
        chomp($line1);
        $line1 =~ s/\s*//g;
    }
    my $conditional_expr;
    my $conditional_expr1;
    if ($line1 =~ /\(([\w=!<>\?\|:&\+\-\*\/%^!~\(\)]+)\)/) {
        $conditional_expr1 = $1;
        $conditional_expr = CheckExprInitialBlock::आद्याङ्गपरिक्षाप्रकटम्($conditional_expr1);
    } else {
        die "Error from InitialBlockIf::initial_block_elseif no proper expression";
    }
    
    $line1 =~ s/\($conditional_expr1\)//;
    
    while ($line1 =~ /^$/) {
        $line_no = $line_no+1;
        if ($line_no > $VerilogParser::max_line) {
            die "Max line reached at InitialBlockIf::initial_block_elseif";
        }
        $line1 .= $VerilogParser::verilog_file[$line_no];
        chomp($line1);
        $line1 =~ s/\s*//g;        
    }

    #$JsonOutput::module_json{$VerilogParser::module_name}{"${always_count}_सदाङ्ग"}{${if_count}_यद्यङ्ग"}{"प्रकारः"} = "यद्यङ्ग";
    #push @InitialBlock::initial_block_arr, $InitialBlockIf::initial_if_count;
    #push @InitialBlock::initial_block_arr, "_";
    pop @InitialBlock::initial_block_arr;
    $InitialBlockIf::initial_if_count = pop @InitialBlock::initial_block_arr;
    $InitialBlockIf::initial_if_count = $InitialBlockIf::initial_if_count+1;
    push @InitialBlock::initial_block_arr,$InitialBlockIf::initial_if_count;
    push @InitialBlock::initial_block_arr,"#";
    my $json_var = $JsonOutput::module_json{$VerilogParser::module_name};
    my $arr_cnt = @InitialBlock::initial_block_arr;
    my $arr_trk=0;
    my $statement_type;
    my $statement_count;
    my $json_statement;
    while ($arr_trk < $arr_cnt) {
        $statement_type = $InitialBlock::initial_block_arr[$arr_trk+1];
        $statement_count = $InitialBlock::initial_block_arr[$arr_trk];
        $arr_trk= $arr_trk+2;
        
        
        if ($statement_type eq "!") {
            $json_statement = ${statement_count}."_आद्यारम्भाङ्गम्";
            $json_var->{$json_statement} //= {};
            $json_var = $json_var->{$json_statement};
        } elsif ($statement_type eq "-") {
            $json_statement = ${statement_count}."_विलम्बाङ्गम्";
            $json_var->{$json_statement} //= {};
            $json_var = $json_var->{$json_statement};
        } elsif ($statement_type eq "_") {
            $json_statement = ${statement_count}."_यद्यङ्गम्";
            $json_var->{$json_statement} //= {};
            $json_var = $json_var->{$json_statement};
        } elsif ($statement_type eq "#") {
            $json_statement = ${statement_count}."_अन्यथायद्यङ्गम्";
            $json_var->{$json_statement} //= {};
            $json_var = $json_var->{$json_statement};
        } elsif ($statement_type eq "&") {
            $json_statement = ${statement_count}."_अन्यथाङ्गम्";
            $json_var->{$json_statement} //= {};
            $json_var = $json_var->{$json_statement};                
        }
    }

    $json_var->{"प्रकारः"} = "अन्यथायद्यङ्गम्";
    $json_var->{"शर्तिः"} = $conditional_expr;
    $json_var->{"क्रमः"} = $VerilogParser::statement_order;
    $VerilogParser::statement_order = $VerilogParser::statement_order+1;
    if ($line1 =~ /^begin/) {
        $expect_end = 1;
        $line1 =~ s/begin//;
    }
    while (1) {
        while ($line1 =~ /^$/) {
            $line_no = $line_no+1;
            if ($line_no > $VerilogParser::max_line) {
                die "Max line reached at InitialBlockIf::initial_block_elseif";
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
        } elsif ($line1 =~ /^#(\d+)/) {
            my $delay_val = $1;
            my $last_val = pop @InitialBlock::initial_block_arr;
            if ($last_val eq '-') {
                pop @InitialBlock::initial_block_arr;
            } else {
                push @InitialBlock::initial_block_arr, $last_val;
            }
            push @InitialBlock::initial_block_arr, $InitialBlock::delay_val_cnt;
            push @InitialBlock::initial_block_arr, "-";
            my $stt = ${InitialBlock::delay_val_cnt}."_विलम्बाङ्गम्";
            $json_var->{$stt} //= {}; 
            $json_var = $json_var->{$stt} ;
            $json_var->{"क्रमः"} = $VerilogParser::statement_order;
            $VerilogParser::statement_order = $VerilogParser::statement_order+1;
            $InitialBlock::delay_val_cnt = $InitialBlock::delay_val_cnt+1;
            $json_var->{"प्रकारः"} = "विलम्बाङ्गम्";
            $json_var->{"विलम्बः"} = $delay_val;
            $line1 =~ s/\#${delay_val}//;
        } elsif ($line1 =~ /^if/) { #Check for IF loop
    

            $line_no = InitialBlockIf::initial_block_if ($line1, $line_no);
            $line1 = "";
            if ($expect_end == 0) {
                $end_occurred = 1;
            }
    
        } elsif ($line1 =~ /([a-zA-Z_]+)=/) { #Check for Statement
            my $var_name = $1;
            chomp($line1);
            my $statement;
            my @statement_temp = CheckExpr::create_postfix($line1);
            my @calc_stack =();
            my %operand1;
            my %operand2;
            for (my $temp =0; $temp < scalar @statement_temp; $temp = $temp+1) {
                #$statement .= $statement_temp[$temp]." ";
                if ( CheckExpr::is_operator($statement_temp[$temp])) {
                    if ($statement_temp[$temp] eq "=") {
                        if ($temp+1 != scalar @statement_temp) {
                            die "Ill-formed expression from initial block at line $line_no";
                        }
                        $operand2{"val"} = pop @calc_stack;
                        $operand1{"val"} = pop @calc_stack;
                        
                        if ($operand1{"val"} =~ /[a-zA-Z_][A-Za-z_0-9]*/ ) {
                            if ($JsonOutput::module_json{$VerilogParser::module_name}{$operand1{"val"}}{"निश्चितवर्गः"} eq "स्मृतिसम्पन्नम्") {
                                $operand1{"type"} = "स्मृतिसम्पन्नम्";
                                if  ($JsonOutput::module_json{$VerilogParser::module_name}{$operand1{"val"}}{"प्रकारः"} eq "तारः" ) {

                                } else {
                                    die " from always initial_if this case needs to be handled";
                                    $operand1{"val"} = "*".$operand1{"val"};
                                }
                                
                            } else {
                                die "From initial block, handle other data types";
                            }
                        }
                        
                        if ($operand2{"val"} =~ /'/) {
                            die " From initial block, update afterwards";
                        } elsif ($operand2{"val"} =~ /\d+/) {
                            if ( ($operand2{"val"} =~ /0/ || $operand2{"val"} =~ /1/) && $operand1{"type"} eq "स्मृतिसम्पन्नम्") {
                                $statement = $operand1{"val"}."=\'".$operand2{"val"}."\';";
                            } elsif ($operand1{"type"} == "स्मृतिसम्पन्नम्") {
                                #Handle for multi-bit
                            }
                        }
                    }
                } else {
                    push @calc_stack,$statement_temp[$temp];
                }
            }
            my $stt = ${VerilogParser::statement_line}."_वाक्यम्";
            $json_var->{$stt} //= {};
            $json_var->{$stt}->{"प्रकारः"} = "वाक्यम्";
            $json_var->{$stt}->{"वाक्यम्"} = $statement;
            $json_var->{$stt}->{"क्रमः"} = $VerilogParser::statement_order;
            $VerilogParser::statement_order = $VerilogParser::statement_order+1;
            $line1 = "";
            #$VerilogParser::statement_line = $VerilogParser::statement_line+1;
            if ($expect_end == 0) {
                $end_occurred = 1;
            }
        } elsif ($line1 =~ /^\$/){
            
            if ($expect_end == 0) {
                $end_occurred = 1;
            }
            if ($line1 =~ /;/) {
                $line1 =~ s/;//;
                
            } else {
                print "Semicolon missing at end of system tasks";
            }
            if ($line1 =~ /\$finish/) {
                my $stt = ${VerilogParser::statement_line}."_वाक्यम्";
                $json_var->{$stt} //= {};
                $json_var->{$stt}->{"प्रकारः"} = "समापनम्";
                $json_var->{$stt}->{"क्रमः"} = $VerilogParser::statement_order;
                $VerilogParser::statement_order = $VerilogParser::statement_order+1;
                $line_no = $line_no+1;
                $line1 =~ s/\$finish//;
                
                $VerilogParser::statement_line = $VerilogParser::statement_line+1;
            }         

        } elsif ($line1 =~ /endmodule|always/) {
            die "Missing end at $line_no with line $line1";
        } else {
            die "Error occured $line1";
        }
        if ($end_occurred == 1) {
            last;
       }
       
    }    
    return $line_no;
}


1;