package ModulePort;
use strict;
use warnings;
use utf8;

sub get_ports;
sub populate_port;
sub populate_port_direction;
sub populate_port_varga;
sub populate_wire;
sub populate_reg;
sub populate_interconnect;
our $port_ordering=0;

sub get_ports {
    my ($line_no) = @_;
    my $line1 = $VerilogParser::verilog_file[$line_no];
    while ($line1 !~ /;/) {
        chomp($line1);
        $line_no++;
        if ($line_no > $VerilogParser::max_line) {
            die "Max line reached at ModulePort.pm";
        }
        $line1 .= $VerilogParser::verilog_file[$line_no];
        
    }
    chomp ($line1);
    $line1 =~ /\((.*)\);/;
    my $port_list = $1;
    my @port_array = split (/,/,$port_list);
    foreach my $port (@port_array) {
        populate_port($port);
    }
    return $line_no;
}

sub populate_port {
    my ($port_inst) = @_;
    my $port_direction;
    $port_inst =~ /([A-Za-z][A-Za-z0-9_]*)$/;
    my $port_name = $1;
    $JsonOutput::module_json{$VerilogParser::module_name}{$port_name}{"प्रकारः"} = "";
    $JsonOutput::module_json{$VerilogParser::module_name}{$port_name}{"दिशा"} = "";
    $JsonOutput::module_json{$VerilogParser::module_name}{$port_name}{"निश्चितवर्गः"} = "";
    $JsonOutput::module_json{$VerilogParser::module_name}{$port_name}{"वर्गः"} = "";
    $JsonOutput::module_json{$VerilogParser::module_name}{$port_name}{"क्रमः"} = $port_ordering;
    $JsonOutput::module_json{$VerilogParser::module_name}{$port_name}{"द्वारम्"} = "सत्यम्";
    $JsonOutput::module_json{$VerilogParser::module_name}{$port_name}{"अवगाढता"} = 0;
    #$JsonOutput::module_json{$VerilogParser::module_name}{$port_name}{"आद्यसूचकः"} = 0;
    #$JsonOutput::module_json{$VerilogParser::module_name}{$port_name}{"अन्त्यसूचकः"} =0;
    $port_ordering++;
    $port_inst =~ s/$port_name//;
    if ($port_inst !~ /^\s*$/) {
        populate_port_direction($port_name, $port_inst);

    }
    
}
sub populate_port_afterwards {
    my ($line_no) = @_;
    my $line1 = $VerilogParser::verilog_file[$line_no];
    while ($line1 !~ /;/) {
        chomp($line1);
        $line_no++;
        if ($line_no > $VerilogParser::max_line) {
            die "Max line reached at ModulePort.pm";
        }
        $line1 .= $VerilogParser::verilog_file[$line_no];
        
    }
    chomp($line1);
    $line1 =~ s/;//;
    my $port_direction;
    $line1 =~ /([A-Za-z][A-Za-z0-9_]*)$/;
    my $port_name = $1;
    $line1 =~ s/$port_name//;
    if ($JsonOutput::module_json{$VerilogParser::module_name}{$port_name}{"द्वारम्"} eq "सत्यम्") {
        if ($line1 !~ /^\s*$/) {
            populate_port_direction($port_name, $line1);
        }
    } else {
        die "$port_name not declared";
    }
    return $line_no;
    
}

sub populate_port_direction {
    my ($port_name,$port_direction) = @_;
    my $matched_port_direction;
    if ($port_direction =~ /input/ ) {
        if ($JsonOutput::module_json{$VerilogParser::module_name}{$port_name}{"दिशा"} eq "") {
            $JsonOutput::module_json{$VerilogParser::module_name}{$port_name}{"दिशा"} = "प्रवेशः";
            $JsonOutput::module_json{$VerilogParser::module_name}{$port_name}{"अवस्थिघटकस्य प्रवेशः"} = [];
            $matched_port_direction = "input";
        } else {
            die "Redeclaration of direction for port $port_name";
        }
    } elsif ($port_direction =~ /output/ ) {
        if ($JsonOutput::module_json{$VerilogParser::module_name}{$port_name}{"दिशा"} eq "") {
            $JsonOutput::module_json{$VerilogParser::module_name}{$port_name}{"दिशा"} = "निर्गमः";
            $JsonOutput::module_json{$VerilogParser::module_name}{$port_name}{"अवस्थित-घटकस्य निर्गमः"} = [];
            $matched_port_direction = "output";
        } else {
            die "Redeclaration of direction for port $port_name";
        }
    } elsif ($port_direction =~ /inout/ ) {
        if ($JsonOutput::module_json{$VerilogParser::module_name}{$port_name}{"दिशा"} eq "") {
            $JsonOutput::module_json{$VerilogParser::module_name}{$port_name}{"दिशा"} = "प्रवेशनिर्गमः";
            $JsonOutput::module_json{$VerilogParser::module_name}{$port_name}{"अवस्थिघटकस्य प्रवेशः"} = [];
            $JsonOutput::module_json{$VerilogParser::module_name}{$port_name}{"अवस्थित-घटकस्य निर्गमः"} = [];
            $matched_port_direction = "inout";
        } else {
            die "Redeclaration of direction for port $port_name";
        }
    } else {
        die "Error in port direction (populate_port_direction)";
    }
    $port_direction =~ s/$matched_port_direction//;
    if ($port_direction !~ /^\s*$/ ) {
        populate_port_varga($port_name,$port_direction);
    }
}

sub populate_port_varga {
    my ($port_name,$port_desc) = @_;
    my $matched_port_varga;
    if ($JsonOutput::module_json{$VerilogParser::module_name}{$port_name}{"प्रकारः"} eq "") {
        if ($port_desc =~ /wire/ ) {
            $JsonOutput::module_json{$VerilogParser::module_name}{$port_name}{"प्रकारः"} = "तारः";
            $JsonOutput::module_json{$VerilogParser::module_name}{$port_name}{"निश्चितवर्गः"} = "स्मृतिरहितम्";
            $port_desc =~ s/wire//;
        } elsif ($port_desc =~ /reg/ ) {
            $JsonOutput::module_json{$VerilogParser::module_name}{$port_name}{"प्रकारः"} = "तारः";
            $JsonOutput::module_json{$VerilogParser::module_name}{$port_name}{"निश्चितवर्गः"} = "स्मृतिसम्पन्नम्";
            $port_desc =~ s/reg//;
        } else {
            die "Port description $port_desc error";
        }
    } else {
        die "Attempt to redeclare same wire $port_name in ModulePort";
    }
    while ($port_desc =~ /^\s*\[/) {
        if ($port_desc =~ /\[\s*(\d*):(\d*)\s*\]/) {
            $JsonOutput::module_json{$VerilogParser::module_name}{$port_name}{"अवगाढता"}++;
            my $अस्थायि = $JsonOutput::module_json{$VerilogParser::module_name}{$port_name}{"अवगाढता"};
            $JsonOutput::module_json{$VerilogParser::module_name}{$port_name}{$अस्थायि."_आद्यसूचकः"} = $2;
            $JsonOutput::module_json{$VerilogParser::module_name}{$port_name}{$अस्थायि."_अन्त्यसूचकः"} =$1;
            $port_desc =~ s/\[//;
            $port_desc =~ s/\]//;
            $port_desc =~ s/://;
            $port_desc =~ s/$JsonOutput::module_json{$VerilogParser::module_name}{$port_name}{$अस्थायि."_अन्त्यसूचकः"}//;
            $port_desc =~ s/$JsonOutput::module_json{$VerilogParser::module_name}{$port_name}{$अस्थायि."_आद्यसूचकः"}//;

        } else {
            die "Error in port declaration $port_name";
        }

    }
    if ($port_desc !~ /^\s*$/) {
        die "Unknown bareword $port_desc in ModulePort::populate_port_varga";
    }

}

sub populate_interconnect {
    my ($line_no) = @_;
    my $line1 = $VerilogParser::verilog_file[$line_no];
    while ($line1 !~ /;/) {
        chomp($line1);
        $line_no++;
        if ($line_no > $VerilogParser::max_line) {
            die "Max line reached at ModulePort.pm";
        }
        $line1 .= $VerilogParser::verilog_file[$line_no];
        
    }
    chomp($line1);
    $line1 =~ s/;//;
    $line1 =~ /([A-Za-z][A-Za-z0-9_]*)$/;
    my $port_name = $1;
    $line1 =~ s/$port_name//;
    if (exists $JsonOutput::module_json{$VerilogParser::module_name}{$port_name}) {
        if ($JsonOutput::module_json{$VerilogParser::module_name}{$port_name}{"द्वारम्"} eq "सत्यम्") {
            populate_port_varga($port_name,$line1);
        } else {
            die "Redeclaration of $port_name";
        }

    } else {
        $JsonOutput::module_json{$VerilogParser::module_name}{$port_name}{"प्रकारः"} = "";
        $JsonOutput::module_json{$VerilogParser::module_name}{$port_name}{"दिशा"} = "";
        $JsonOutput::module_json{$VerilogParser::module_name}{$port_name}{"निश्चितवर्गः"} = "";
        $JsonOutput::module_json{$VerilogParser::module_name}{$port_name}{"वर्गः"} = "";
        $JsonOutput::module_json{$VerilogParser::module_name}{$port_name}{"क्रमः"} = 0;
        $JsonOutput::module_json{$VerilogParser::module_name}{$port_name}{"द्वारम्"} = "असत्यम्";
        $JsonOutput::module_json{$VerilogParser::module_name}{$port_name}{"अवगाढता"} = 0;

        populate_port_varga($port_name,$line1);
    }
    return $line_no;
}
sub populate_reg {
    my ($line_no) = @_;
    my $line1 = $VerilogParser::verilog_file[$line_no];
    while ($line1 !~ /;/) {
        chomp($line1);
        $line_no++;
        if ($line_no > $VerilogParser::max_line) {
            die "Max line reached at ModulePort.pm";
        }
        $line1 .= $VerilogParser::verilog_file[$line_no];
        
    }
    chomp($line1);
    $line1 =~ s/;//;
    my $first_width =0;
    my $last_width = 0;
    $line1 =~ s/\s*reg//;
    $line1 =~ s/\s//g;
    if ($line1 =~ /\[(\d+):(\d+)\]/) {
       $last_width = $1;
       $first_width = $2;
       $line1 =~ s/${last_width}:${first_width}//;
    }
    $line1 =~ s/;$//;
    my @wires = split(/,/, $line1);
    for (my $i = 0; $i < scalar @wires; $i=$i+1) {
        $JsonOutput::module_json{$VerilogParser::module_name}{$wires[$i]}{"प्रकारः"} = "तारः";
        $JsonOutput::module_json{$VerilogParser::module_name}{$wires[$i]}{"निश्चितवर्गः"} = "स्मृतिसम्पन्नम्";
    }

    return $line_no;

}

sub populate_wire {
    my ($line_no) = @_;
    my $line1 = $VerilogParser::verilog_file[$line_no];
    while ($line1 !~ /;/) {
        chomp($line1);
        $line_no++;
        if ($line_no > $VerilogParser::max_line) {
            die "Max line reached at ModulePort.pm";
        }
        $line1 .= $VerilogParser::verilog_file[$line_no];
        
    }
    chomp($line1);
    $line1 =~ s/;//;
    my $first_width =0;
    my $last_width = 0;
    $line1 =~ s/\s*wire//;
    $line1 =~ s/\s//g;
    if ($line1 =~ /\[(\d+):(\d+)\]/) {
       $last_width = $1;
       $first_width = $2;
       $line1 =~ s/${last_width}:${first_width}//;
    }
    $line1 =~ s/;$//;
    my @wires = split(/,/, $line1);
    for (my $i = 0; $i < scalar @wires; $i=$i+1) {
        $JsonOutput::module_json{$VerilogParser::module_name}{$wires[$i]}{"प्रकारः"} = "तारः";
        $JsonOutput::module_json{$VerilogParser::module_name}{$wires[$i]}{"निश्चितवर्गः"} = "स्मृतिरहितम्";
    }

    return $line_no;

}

1;
