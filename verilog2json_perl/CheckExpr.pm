package CheckExpr;

use strict;
use warnings;
use utf8;


sub check_conditional_expr;
sub create_postfix;
sub is_operator;
sub validate_operand;


our %precedence = (
        '~'  => 11, '!' => 11,
        '*'  => 10, '/' => 10, '%' => 10,
        '+'  => 9, '-'  => 9,
        '<<' => 8, '>>' => 8,
        '<'  => 7, '<=' => 7, '>' => 7, '>=' => 7,
        '==' => 6, '!=' => 6,
        '&'  => 5,
        '^'  => 4,
        '|'  => 3,
        '&&' => 2,
        '||' => 1,
        '=' => 0, '+=' =>0, '-=' =>0,
        '?:' => -1,    # ternary operator (lowest)
    );
    # Associativity (default left)
    our %assoc = (
        '~'  => 'right',
        '!'  => 'right',
        '?:' => 'right',
        '='  => 'right',
        '+=' => 'right',
        '-=' => 'right'
    );

sub check_conditional_expr {
    my ($conditional_expr) = @_;
    my @statement_temp = create_postfix($conditional_expr);
    my @calc_stack =();
    my %operand1;
    my %operand2;

    my $statement="";
    my $first_operand;
    my $second_operand;
    for (my $temp =0; $temp < scalar @statement_temp; $temp = $temp+1) {
        if (is_operator($statement_temp[$temp])) {
            $operand1{"val"} = pop @calc_stack;
            $operand2{"val"} = pop @calc_stack;
            $first_operand = validate_operand($operand1{"val"});
            $second_operand = validate_operand($operand2{"val"});

            if ($statement_temp[$temp] eq "==") {
                $statement = "तार्किकसमतापरीक्षणम्(".$first_operand.",".$second_operand.")";
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

sub create_postfix {
    my ($expr) = @_;
    my $i;
    my $j;
    my @stack;
    my @output;
    # Operator precedence (higher number = higher precedence)

    $expr =~ s/;//g;
    my @tokens = $expr =~ /([A-Za-z_]\w*|\d*\'[bodh][a-fA-F0-9]+|\d+|==|!=|<=|>=|=|<<|>>|\?|:|&&|\|\||[+\-*\/%<>&|^!~()?:])/g;
    my $stack_length=-1;
    foreach $i (@tokens) {
   
           
        if ($i eq '(') {
            push @stack,$i;
            $stack_length +=1;
        } elsif ($i eq ')') {
            $j = pop @stack;
            $stack_length -= 1;
            if ($j eq '(') {
                die "Error from create_postfix: Brackets empty";
            }
            while ($j ne '(') {
                push @output,$j;
                if (!@stack) {
                    die "Error from create_postfix: No start brackets found";
                }
                $j = pop @stack;
                $stack_length -= 1;
            }
        }  elsif (is_operator($i)) {
            if ($stack_length == -1) {
                push @stack, $i;
                $stack_length += 1;
            } elsif ($precedence{$stack[$stack_length]} > $precedence{$i}) {
                push @output, $i;
            } else {
                push @stack, $i;
                $stack_length += 1;
            }
        } else {
            push @output, $i;
        }
    }
    while (@stack) {
        push @output, pop @stack;
    }
    #foreach my $i (@output) {
    #    print "$i \n";
    #}
    return @output;
}

sub is_operator {
    my ($tok) = @_;
    return exists $precedence{$tok};
}

sub validate_operand {
    my ($operand) = @_;
    my $return_operand;            
    if ($operand =~ /[a-zA-Z_{][A-Za-z_0-9}\[\],:]*/ ) {
        if  ($JsonOutput::module_json{$VerilogParser::module_name}{$operand}{"प्रकारः"} eq "तारः" ) {
            $return_operand = "std::string(1,this->".$operand.".getVal())"; 
        } else {
            die "Bareword $operand found in conditional expression";
        }
    } elsif ($operand =~ /'/) {
        die " From initial block, update afterwards";
    } elsif ($operand =~ /\d+/) {
        if ($operand =~ /0/ || $operand =~ /1/) {
            $return_operand = "\"".$operand."\"";
        } else {
            die " From initial block, update afterwards";
            #Handle for multi-bit
        }
    }
    return $return_operand;
}



1;