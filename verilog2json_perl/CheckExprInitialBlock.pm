package CheckExprInitialBlock;
use strict;
use warnings;
use utf8;


sub आद्याङ्गपरिक्षाप्रकटम्;
sub आद्याङ्गवाक्यम्;
sub आद्यारम्भाङ्गोपाधानम्;

sub आद्याङ्गपरिक्षाप्रकटम् {
    my ($conditional_expr) = @_;
    my @statement_temp = CheckExpr::create_postfix($conditional_expr);
    my @calc_stack =();
    my %operand1;
    my %operand2;
    
    my $statement="";
    my $first_operand ;
    my $second_operand;
    for (my $temp =0; $temp < scalar @statement_temp; $temp = $temp+1) {
        if (CheckExpr::is_operator($statement_temp[$temp])) {
            $operand1{"val"} = pop @calc_stack;
            $operand2{"val"} = pop @calc_stack;
            $first_operand = CheckExpr::validate_operand($operand1{"val"});
            $second_operand = CheckExpr::validate_operand($operand2{"val"});
            if ($statement_temp[$temp] eq "==") {
                $statement = "आद्यारम्भाङ्गम्_तार्किकसमतापरीक्षणम्(".$first_operand.",".$second_operand.")";
            } elsif ($statement_temp[$temp] eq "<") {
                $statement = "आद्यारम्भाङ्गम्_तार्किककनिष्ठात्परीक्षणम्(".$first_operand.",".$second_operand.")";
            } elsif ($statement_temp[$temp] eq ">") {
                $statement = "आद्यारम्भाङ्गम्_तार्किकज्यायान्परीक्षणम्(".$first_operand.",".$second_operand.")";
            } elsif ($statement_temp[$temp] eq "<=") {
                $statement = "आद्यारम्भाङ्गम्_तार्किककनिष्ठसमपरीक्षणम्(".$first_operand.",".$second_operand.")";
            } elsif ($statement_temp[$temp] eq ">=") {
                $statement = "आद्यारम्भाङ्गम्_तार्किकज्यायान्समपरीक्षणम्(".$first_operand.",".$second_operand.")";
            } elsif ($statement_temp[$temp] eq "=") {
                $statement = $first_operand."=".$second_operand;
            } else {
                die ("didnot handled the operator $statement_temp[$temp]");
            }

        } else {
            push @calc_stack,$statement_temp[$temp];
        }
    }
    return $statement;
}

sub आद्याङ्गवाक्यम् {
    my (@statement_temp) = @_;
    my %first_operand;
    my %second_operand;
    my %operand1;
    my %operand2;
    my @गणनापुटः = ();
    my @परिमाणपुटः = ();
    for (my $temp =0; $temp < scalar @statement_temp; $temp = $temp+1) {
        if (CheckExpr::is_operator($statement_temp[$temp])) {
            if ($statement_temp[$temp] eq "+") {
                $operand1{"val"} = pop @गणनापुटः;
                $operand2{"val"} = pop @गणनापुटः;
                $operand1{"len"} = pop @परिमाणपुटः;
                $operand2{"len"} = pop @परिमाणपुटः;

                if ($operand1{"len"} == 0) {
                    %first_operand = आद्यारम्भाङ्गोपाधानम्($operand1{"val"});
                }
                if ($operand2{"len"} == 0) {
                    %second_operand = आद्यारम्भाङ्गोपाधानम्($operand2{"val"});
                }
                if ($first_operand{"परिमाणम्"} != $second_operand{"परिमाणम्"}) {
                    die "Operands length not same";
                }
                $first_operand{"मूल्यम्"}        =~ s/,/+/g;
                $first_operand{"मूल्यम्"}        =~ s/std::string\(1/std::string(1,/g;
                $second_operand{"मूल्यम्"}   =~ s/,/+/g;
                $second_operand{"मूल्यम्"}   =~ s/std::string\(1/std::string(1,/g;

                push  @गणनापुटः,"आद्यारम्भाङ्गम्_द्विबिन्दुयोजनम् ($first_operand{\"मूल्यम्\"}, $second_operand{\"मूल्यम्\"})";

                push @परिमाणपुटः,$first_operand{"परिमाणम्"};
                
                
            } elsif ($statement_temp[$temp] eq "=") {

                $operand1{"val"} = pop @गणनापुटः;
                $operand2{"val"} = pop @गणनापुटः;
                
                $operand1{"len"} = pop @परिमाणपुटः;
                $operand2{"len"} = pop @परिमाणपुटः;

                if ($operand1{"len"} == 0) {
                    %first_operand = आद्यारम्भाङ्गोपाधानम्($operand1{"val"});
                } else {
                    $first_operand{"मूल्यम्"} = $operand1{"val"};
                    $first_operand{"परिमाणम्"} = $operand1{"len"};
                }
                if ($operand2{"len"} == 0) {
                    %second_operand = आद्यारम्भाङ्गोपाधानम्_नियोजनम् ($operand2{"val"});
                } else {
                    die "Assign statement on non variable\n";

                }
                if ($first_operand{"परिमाणम्"} != $second_operand{"परिमाणम्"}) {
                    die "Operands length not same";
                }
                push  @गणनापुटः,"आद्यारम्भाङ्गम्_द्विनियोजनम् ($second_operand{\"मूल्यम्\"}, $first_operand{\"मूल्यम्\"} )";
                push @परिमाणपुटः,$first_operand{"परिमाणम्"};

            }
        
        } else {
            
            push @गणनापुटः,$statement_temp[$temp];
            push @परिमाणपुटः,0;

        }
    }
    if (scalar @गणनापुटः ==1) {
        return $गणनापुटः[0].";";
    } else {
        die "Mal-formed statement in aadyangavaakyam";
    }
}

sub आद्यारम्भाङ्गोपाधानम् {
    my ($उपाधानम्) = @_;
    my $अस्थायि;
    my %कूटाङ्कः = (
        स्थिरम् => 0,
        परिमाणम् => 0,
        मूल्यम् => "",
        वर्णः_वा => "असत्यम्"
    );
    my @सरणिः = ();
    my @सरणिः_अस्थायि = ();
    while ($उपाधानम् !~ /^\s*$/) {
        if ($उपाधानम्  =~ /^\s*[A-Za-z]/) {
            if ($उपाधानम्  =~ /^\s*([A-Za-z][A-Za-z0-9_]*)/) {
                $अस्थायि = $1;
                
                my @कनिष्ठम् = ();
                my @ज्येष्ठम् = ();
                
                if (exists $JsonOutput::module_json{$VerilogParser::module_name}{$अस्थायि}) {
                    $उपाधानम्  =~  s/$अस्थायि//;

                    my $अवगाढता = $JsonOutput::module_json{$VerilogParser::module_name}{$अस्थायि}{"अवगाढता"};
                    my $अवगाढता_अस्थायि =0;
                    my $high1;
                    my $low1;
                    while ( $उपाधानम्  =~ /^\s*\[/ ) {
                        if ( $उपाधानम्  =~ /^\s*\[(\d+):(\d+)\]/ ) {
                            $high1 = $1;
                            $low1 = $2;
                            push @ज्येष्ठम्, $high1;
                            push @कनिष्ठम्, $low1;
                            $उपाधानम्  =~ s/\[$high1:$low1\]//;
                        } elsif  ( $उपाधानम्  =~ /^\s*\[(\d+)\]/ ) {
                            $high1 = $1;
                            
                            push @ज्येष्ठम्, $high1;
                            push @कनिष्ठम्, $high1;
                            $उपाधानम्  =~ s/\[$high1\]//;
                        } else {
                            die "Error in CheckExprInitialBlock with array";
                        }
                    }
                    my $i;
                    my $j;
                    while ($अवगाढता_अस्थायि < $अवगाढता) {
                        $अवगाढता_अस्थायि++;
                        if ($अवगाढता_अस्थायि == 1) {
                            if ($#ज्येष्ठम् >= $अवगाढता_अस्थायि) {
                                $i = $ज्येष्ठम्[$अवगाढता_अस्थायि-1];
                                while ($i <= $कनिष्ठम्[$अवगाढता_अस्थायि-1]) {
                                    push @सरणिः, $अस्थायि."[".$i."]";
                                    $i++;
                                }
                            } else {
                                $i = $JsonOutput::module_json{$VerilogParser::module_name}{$अस्थायि}{$अवगाढता_अस्थायि."_आद्यसूचकः"};
                                while ($i <=$JsonOutput::module_json{$VerilogParser::module_name}{$अस्थायि}{$अवगाढता_अस्थायि."_अन्त्यसूचकः"}) {
                                    push @सरणिः, $अस्थायि."[".$i."]";
                                    $i++;
                                }
                            }

                            
                        } else {
                            if ($#ज्येष्ठम् >= $अवगाढता_अस्थायि) {

                                for ($i = $ज्येष्ठम्[$अवगाढता_अस्थायि-1];
                                $i <=$कनिष्ठम्[$अवगाढता_अस्थायि-1]; $i++) {
                                    
                                    foreach my $j (@सरणिः_अस्थायि) {
                                        push @सरणिः, $j."[".$i."]";
                                    }
    
                                }

                            } else {
                                for ( $i = $JsonOutput::module_json{$VerilogParser::module_name}{$अस्थायि}{$अवगाढता_अस्थायि."_आद्यसूचकः"};
                                $i <=$JsonOutput::module_json{$VerilogParser::module_name}{$अस्थायि}{$अवगाढता_अस्थायि."_अन्त्यसूचकः"}; $i++) {
                                    
                                    foreach my $j (@सरणिः_अस्थायि) {
                                        push @सरणिः, $j."[".$i."]";
                                    }
    
                                }
                            }
                        }
                        foreach my $i (@सरणिः) {
                            push @सरणिः_अस्थायि, "std::string(1".$i.".getVal())";
                        }
                        @सरणिः = ();
                    }


                
                }else {
                    die "Error from identifying the variable $अस्थायि ";
                }
            }
            @सरणिः = @सरणिः_अस्थायि;
            my $परिमाणम् = 0;
            foreach my $i (@सरणिः) {
                $परिमाणम्++;
            }
            $कूटाङ्कः{"स्थिरम्"} = 1;
            $कूटाङ्कः{"मूल्यम्"} = join(",", @सरणिः);
            $कूटाङ्कः{"वर्णः_वा"} = "सत्यम्";
            $कूटाङ्कः{"परिमाणम्"} = $परिमाणम्;
        } elsif ($उपाधानम्  =~ /^\s*'([ohdb])\s*([0-9_A-Fa-f]+)/ ) {
            my $j= $1;
            my $k = $2;
            print "$j $k\n";
            $उपाधानम्  =~ s/\s*'${j}\s*$k//;
            if ($j eq "b") {
                $कूटाङ्कः{"स्थिरम्"} = 1;
                if ($k =~ /^[01_]+$/) {

                    $कूटाङ्कः{"मूल्यम्"} = $k;
                    $कूटाङ्कः{"वर्णः_वा"} = "असत्यम्";

                } else {
                    die "Unknown characters in binary in $उपाधानम्";
                }
            } elsif ($j eq "d") {
                if ($k =~ /^\d+$/) {
                    $कूटाङ्कः{"मूल्यम्"} = "\"".sprintf("%032b", $k)."\"";
                    $कूटाङ्कः{"वर्णः_वा"} = "असत्यम्";
                    $कूटाङ्कः{"स्थिरम्"} = 1;

                } else {
                    die "Unknown characters in decimal in $उपाधानम्";
                }

            } elsif ($j eq "o") {
                if ($k =~ /^[0-7_]+$/) {
                    $कूटाङ्कः{"स्थिरम्"} = 1;
                    $कूटाङ्कः{"मूल्यम्"} = sprintf("%032b", oct($k));
                    $कूटाङ्कः{"वर्णः_वा"} = "असत्यम्";
                } else {
                    die "Unknown characters in octal in $उपाधानम्";
                }



            } elsif ($j eq "h") {
                if ($k =~ /^[\dA-Fa-f_]+$/) {
                    $कूटाङ्कः{"स्थिरम्"} = 1;
                    $कूटाङ्कः{"मूल्यम्"} = sprintf "%032b", hex $k;
                    $कूटाङ्कः{"वर्णः_वा"} = "असत्यम्";
                } else {
                    die "Unknown characters in decimal in $उपाधानम्";
                }
                $कूटाङ्कः{"स्थिरम्"} = 1;
                $कूटाङ्कः{"मूल्यम्"} = sprintf "%032b", hex $k;
                $कूटाङ्कः{"वर्णः_वा"} = "असत्यम्";
            }
            $कूटाङ्कः{"परिमाणम्"} = 32;
        } elsif ($उपाधानम्  =~ /^\s*(\d+)\s*'([ohdb])\s*([0-9_A-Fa-f]+)/ ) {
            my $i=$1;
            my $j= $2;
            my $k = $3;
            $उपाधानम्  =~ s/${i}\s*'${j}\s*$k//;
            if ($j eq "b") {
                $कूटाङ्कः{"स्थिरम्"} = 1;
                if ($k =~ /^[01_]+$/) {
                    if (length($k) == $i) {
                        $कूटाङ्कः{"मूल्यम्"} = $k;
                        $कूटाङ्कः{"वर्णः_वा"} = "असत्यम्";
                    } else {
                        die "No of bits in binary is wrong in $उपाधानम्";
                    }
                } else {
                    die "Unknown characters in binary in $उपाधानम्";
                }
            } elsif ($j eq "d") {
                if ($k =~ /^\d+$/) {
                    $कूटाङ्कः{"मूल्यम्"} = "\"".sprintf("%0${i}b", $k)."\"";
                    $कूटाङ्कः{"वर्णः_वा"} = "असत्यम्";
                    $कूटाङ्कः{"स्थिरम्"} = 1;

                } else {
                    die "Unknown characters in decimal in $उपाधानम्";
                }

            } elsif ($j eq "o") {
                if ($k =~ /^[0-7_]+$/) {
                    $कूटाङ्कः{"स्थिरम्"} = 1;
                    $कूटाङ्कः{"मूल्यम्"} = sprintf("%0${i}b", oct($k));
                    $कूटाङ्कः{"वर्णः_वा"} = "असत्यम्";
                } else {
                    die "Unknown characters in octal in $उपाधानम्";
                }



            } elsif ($j eq "h") {
                if ($k =~ /^[\dA-Fa-f_]+$/) {
                    $कूटाङ्कः{"स्थिरम्"} = 1;
                    $कूटाङ्कः{"मूल्यम्"} = sprintf "%0${i}b", hex $k;
                    $कूटाङ्कः{"वर्णः_वा"} = "असत्यम्";
                } else {
                    die "Unknown characters in decimal in $उपाधानम्";
                }
                $कूटाङ्कः{"स्थिरम्"} = 1;
                $कूटाङ्कः{"मूल्यम्"} = sprintf "%0${i}b", hex $k;
                $कूटाङ्कः{"वर्णः_वा"} = "असत्यम्";
            }
            $कूटाङ्कः{"परिमाणम्"} = $i;
             
        } elsif  ($उपाधानम्  =~ /^(\d+)/ ) {
            my $k = $1;
            $उपाधानम्  =~ s/$k//;
            $कूटाङ्कः{"मूल्यम्"} = sprintf("%032b", $k);
            $कूटाङ्कः{"वर्णः_वा"} = "असत्यम्";
            $कूटाङ्कः{"स्थिरम्"} = 1;
            $कूटाङ्कः{"परिमाणम्"} = 32;
        } else {
            die "Unknown bareword $उपाधानम्\n "
        }

    }
    return %कूटाङ्कः;
    

}



sub आद्यारम्भाङ्गोपाधानम्_नियोजनम् {
    my ($उपाधानम्) = @_;
    my $अस्थायि;
    my %कूटाङ्कः = (
        स्थिरम् => 0,
        परिमाणम् => 0,
        मूल्यम् => "",
        वर्णः_वा => "असत्यम्"
    );
    my @सरणिः = ();
    my @सरणिः_अस्थायि = ();
    my $वर्धनम्=0;
    while ($उपाधानम् !~ /^\s*$/) {
        if ($उपाधानम्  =~ /^\s*[A-Za-z]/) {
            if ($उपाधानम्  =~ /^\s*([A-Za-z][A-Za-z0-9_]*)/) {
                $अस्थायि = $1;
                
                my @कनिष्ठम् = ();
                my @ज्येष्ठम् = ();
                
                if (exists $JsonOutput::module_json{$VerilogParser::module_name}{$अस्थायि}) {
                    $उपाधानम्  =~  s/$अस्थायि//;

                    my $अवगाढता = $JsonOutput::module_json{$VerilogParser::module_name}{$अस्थायि}{"अवगाढता"};
                    my $अवगाढता_अस्थायि =0;
                    my $high1;
                    my $low1;
                    while ( $उपाधानम्  =~ /^\s*\[/ ) {
                        if ( $उपाधानम्  =~ /^\s*\[(\d+):(\d+)\]/ ) {
                            $high1 = $1;
                            $low1 = $2;
                            push @ज्येष्ठम्, $high1;
                            push @कनिष्ठम्, $low1;
                            $उपाधानम्  =~ s/\[$high1:$low1\]//;
                        } elsif  ( $उपाधानम्  =~ /^\s*\[(\d+)\]/ ) {
                            $high1 = $1;
                            
                            push @ज्येष्ठम्, $high1;
                            push @कनिष्ठम्, $high1;
                            $उपाधानम्  =~ s/\[$high1\]//;
                        } else {
                            die "Error in CheckExprInitialBlock with array";
                        }
                        $अवगाढता_अस्थायि++;
                    }
                    
                    while ($अवगाढता_अस्थायि < $अवगाढता) {
                        $वर्धनम् = $JsonOutput::module_json{$VerilogParser::module_name}{$अस्थायि}{"अवगाढता"}+1;
                        push @ज्येष्ठम्, $JsonOutput::module_json{$VerilogParser::module_name}{$अस्थायि}{$वर्धनम्."_आद्यसूचकः"};
                        push @कनिष्ठम्, $JsonOutput::module_json{$VerilogParser::module_name}{$अस्थायि}{$वर्धनम्."_अन्त्यसूचकः"};
                        $अवगाढता_अस्थायि++;
                    }
                    my $i;
                    my $j;
                    $अवगाढता_अस्थायि =0;
                    while ($अवगाढता_अस्थायि < $अवगाढता) {
                        $अवगाढता_अस्थायि++;
                        if ($अवगाढता_अस्थायि == 1) {
                            if ($#ज्येष्ठम् >= $अवगाढता_अस्थायि) {
                                $i = $ज्येष्ठम्[$अवगाढता_अस्थायि-1];
                                while ($i <= $कनिष्ठम्[$अवगाढता_अस्थायि-1]) {
                                    push @सरणिः, $अस्थायि."[".$i."]";
                                    $i++;
                                }
                            } else {
                                $i = $JsonOutput::module_json{$VerilogParser::module_name}{$अस्थायि}{$अवगाढता_अस्थायि."_आद्यसूचकः"};
                                while ($i <=$JsonOutput::module_json{$VerilogParser::module_name}{$अस्थायि}{$अवगाढता_अस्थायि."_अन्त्यसूचकः"}) {
                                    push @सरणिः, $अस्थायि."[".$i."]";
                                    $i++;
                                }
                            }

                            
                        } else {
                            if ($#ज्येष्ठम् >= $अवगाढता_अस्थायि) {

                                for ($i = $ज्येष्ठम्[$अवगाढता_अस्थायि-1];
                                $i <=$कनिष्ठम्[$अवगाढता_अस्थायि-1]; $i++) {
                                    
                                    foreach my $j (@सरणिः_अस्थायि) {
                                        push @सरणिः, $j."[".$i."]";
                                    }
    
                                }

                            } else {
                                for ( $i = $JsonOutput::module_json{$VerilogParser::module_name}{$अस्थायि}{$अवगाढता_अस्थायि."_आद्यसूचकः"};
                                $i <=$JsonOutput::module_json{$VerilogParser::module_name}{$अस्थायि}{$अवगाढता_अस्थायि."_अन्त्यसूचकः"}; $i++) {
                                    
                                    foreach my $j (@सरणिः_अस्थायि) {
                                        push @सरणिः, $j."[".$i."]";
                                    }
    
                                }
                            }
                        }
                        foreach my $i (@सरणिः) {
                            push @सरणिः_अस्थायि, "&".$VerilogParser::module_name."::".$i;
                        }
                        @सरणिः = ();
                    }


                
                }else {
                    die "Error from identifying the variable $अस्थायि ";
                }
            }
            @सरणिः = @सरणिः_अस्थायि;
            my $परिमाणम् = 0;
            foreach my $i (@सरणिः) {
                $परिमाणम्++;
            }
            $कूटाङ्कः{"स्थिरम्"} = 1;
            $कूटाङ्कः{"मूल्यम्"} = "{".join(",", @सरणिः)."}";
            $कूटाङ्कः{"वर्णः_वा"} = "सत्यम्";
            $कूटाङ्कः{"परिमाणम्"} = $परिमाणम्;
        } else {
            die "Unknown bareword $उपाधानम् in आद्यारम्भाङ्गोपाधानम्_नियोजनम् \n "
        }

    }
    return %कूटाङ्कः;
    

}


sub आद्यारम्भाङ्गोपाधानम्_निर्गमः {
    my ($उपाधानम्) = @_;
    my $अस्थायि;
    my %कूटाङ्कः = (
        स्थिरम् => 0,
        परिमाणम् => 0,
        मूल्यम् => "",
        वर्णः_वा => "असत्यम्"
    );
    my @सरणिः = ();
    my @सरणिः_अस्थायि = ();
    while ($उपाधानम् !~ /^\s*$/) {
        if ($उपाधानम्  =~ /^\s*[A-Za-z]/) {
            if ($उपाधानम्  =~ /^\s*([A-Za-z][A-Za-z0-9_]*)/) {
                $अस्थायि = $1;
                
                my @कनिष्ठम् = ();
                my @ज्येष्ठम् = ();
                
                if (exists $JsonOutput::module_json{$VerilogParser::module_name}{$अस्थायि}) {
                    $उपाधानम्  =~  s/$अस्थायि//;

                    my $अवगाढता = $JsonOutput::module_json{$VerilogParser::module_name}{$अस्थायि}{"अवगाढता"};
                    my $अवगाढता_अस्थायि =0;
                    my $high1;
                    my $low1;
                    while ( $उपाधानम्  =~ /^\s*\[/ ) {
                        if ( $उपाधानम्  =~ /^\s*\[(\d+):(\d+)\]/ ) {
                            $high1 = $1;
                            $low1 = $2;
                            push @ज्येष्ठम्, $high1;
                            push @कनिष्ठम्, $low1;
                            $उपाधानम्  =~ s/\[$high1:$low1\]//;
                        } elsif  ( $उपाधानम्  =~ /^\s*\[(\d+)\]/ ) {
                            $high1 = $1;
                            
                            push @ज्येष्ठम्, $high1;
                            push @कनिष्ठम्, $high1;
                            $उपाधानम्  =~ s/\[$high1\]//;
                        } else {
                            die "Error in CheckExprInitialBlock with array";
                        }
                    }
                    my $i;
                    my $j;
                    while ($अवगाढता_अस्थायि < $अवगाढता) {
                        $अवगाढता_अस्थायि++;
                        if ($अवगाढता_अस्थायि == 1) {
                            if ($#ज्येष्ठम् >= $अवगाढता_अस्थायि) {
                                $i = $ज्येष्ठम्[$अवगाढता_अस्थायि-1];
                                while ($i <= $कनिष्ठम्[$अवगाढता_अस्थायि-1]) {
                                    push @सरणिः, $अस्थायि."[".$i."]";
                                    $i++;
                                }
                            } else {
                                $i = $JsonOutput::module_json{$VerilogParser::module_name}{$अस्थायि}{$अवगाढता_अस्थायि."_आद्यसूचकः"};
                                while ($i <=$JsonOutput::module_json{$VerilogParser::module_name}{$अस्थायि}{$अवगाढता_अस्थायि."_अन्त्यसूचकः"}) {
                                    push @सरणिः, $अस्थायि."[".$i."]";
                                    $i++;
                                }
                            }

                            
                        } else {
                            if ($#ज्येष्ठम् >= $अवगाढता_अस्थायि) {

                                for ($i = $ज्येष्ठम्[$अवगाढता_अस्थायि-1];
                                $i <=$कनिष्ठम्[$अवगाढता_अस्थायि-1]; $i++) {
                                    
                                    foreach my $j (@सरणिः_अस्थायि) {
                                        push @सरणिः, $j."[".$i."]";
                                    }
    
                                }

                            } else {
                                for ( $i = $JsonOutput::module_json{$VerilogParser::module_name}{$अस्थायि}{$अवगाढता_अस्थायि."_आद्यसूचकः"};
                                $i <=$JsonOutput::module_json{$VerilogParser::module_name}{$अस्थायि}{$अवगाढता_अस्थायि."_अन्त्यसूचकः"}; $i++) {
                                    
                                    foreach my $j (@सरणिः_अस्थायि) {
                                        push @सरणिः, $j."[".$i."]";
                                    }
    
                                }
                            }
                        }
                        foreach my $i (@सरणिः) {
                            push @सरणिः_अस्थायि, "std::string(1".$i.".getVal())";
                        }
                        @सरणिः = ();
                    }


                
                }else {
                    die "Error from identifying the variable $अस्थायि ";
                }
            }
            @सरणिः = @सरणिः_अस्थायि;
            my $परिमाणम् = 0;
            foreach my $i (@सरणिः) {
                $परिमाणम्++;
            }
            $कूटाङ्कः{"स्थिरम्"} = 1;
            $कूटाङ्कः{"मूल्यम्"} = join(",", @सरणिः);
            $कूटाङ्कः{"वर्णः_वा"} = "सत्यम्";
            $कूटाङ्कः{"परिमाणम्"} = $परिमाणम्;
        } else {
            die "Unknown bareword $उपाधानम्\n "
        }

    }
    return %कूटाङ्कः;
    

}




sub दशमाननिर्गमः {
    my ($conditional_expr) = @_;
    my @statement_temp = CheckExpr::create_postfix($conditional_expr);
    my %print_operand;
    if (scalar @statement_temp > 1) {
        die "More than one variable in \$display";
    }
    %print_operand = आद्यारम्भाङ्गोपाधानम्_निर्गमः($statement_temp[0]);
    $print_operand{"मूल्यम्"} =~ s/,/+/g;
    $print_operand{"मूल्यम्"} =~ s/std::string\(1/std::string(1,/g;
    return "दशमिकपरिवर्तकः(" . $print_operand{"मूल्यम्"} .")";



}
1;
