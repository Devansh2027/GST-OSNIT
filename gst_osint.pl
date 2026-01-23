use strict;
use warnings;
use LWP::UserAgent;
use JSON;

# ------------------ CONSTANTS ------------------
my %STATE = (
    '01'=>'Jammu and Kashmir','02'=>'Himachal Pradesh','03'=>'Punjab',
    '04'=>'Chandigarh','05'=>'Uttarakhand','06'=>'Haryana','07'=>'Delhi',
    '08'=>'Rajasthan','09'=>'Uttar Pradesh','10'=>'Bihar','11'=>'Sikkim',
    '12'=>'Arunachal Pradesh','13'=>'Nagaland','14'=>'Manipur',
    '15'=>'Mizoram','16'=>'Tripura','17'=>'Meghalaya','18'=>'Assam',
    '19'=>'West Bengal','20'=>'Jharkhand','21'=>'Odisha',
    '22'=>'Chhattisgarh','23'=>'Madhya Pradesh','24'=>'Gujarat',
    '25'=>'Daman and Diu','26'=>'Dadra and Nagar Haveli',
    '27'=>'Maharashtra','28'=>'Andhra Pradesh','29'=>'Karnataka',
    '30'=>'Goa','31'=>'Lakshadweep','32'=>'Kerala','33'=>'Tamil Nadu',
    '34'=>'Puducherry','35'=>'Andaman and Nicobar Islands',
    '36'=>'Telangana','37'=>'Andhra Pradesh (New)','38'=>'Ladakh'
);

# ------------------ UTILITIES ------------------
sub print_modes {
    print <<'TXT';

GSTIN VERIFICATION MODES
--------------------------------------
1) OFFLINE  - Format, PAN, State, Checksum
2) ONLINE   - Offline + GST database lookup
--------------------------------------
TXT
}

sub extract_parts {
    my ($gstin) = @_;
    return (
        substr($gstin,0,2),
        substr($gstin,2,10)
    );
}

# ------------------ GSTIN VALIDATION ------------------
sub valid_gstin {
    my ($gstin) = @_;
    return 0 unless $gstin =~ /^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z][1-9A-Z]Z[0-9A-Z]$/;

    my @c = split //, $gstin;
    my $chk = pop @c;
    my ($f,$sum) = (2,0);

    for my $x (reverse @c) {
        my $v = ($x =~ /\d/) ? $x : ord($x)-55;
        my $p = $v*$f;
        $sum += int($p/36)+($p%36);
        $f = $f==2 ? 1 : 2;
    }

    my $cs = (36-($sum%36))%36;
    return (($cs<10?$cs:chr($cs+55)) eq $chk);
}

# ------------------ ONLINE API ------------------
sub fetch_online {
    my ($gstin) = @_;

    my $ua = LWP::UserAgent->new(
        timeout => 20,
        agent   => 'Mozilla/5.0'
    );

    my $url = "https://tools.signalx.ai/apps/gst-verification/gstin-overview/$gstin";
    my $res = $ua->get($url);

    die "API Error: " . $res->status_line . "\n"
        unless $res->is_success;

    return decode_json($res->decoded_content);
}

# ------------------ MAIN ------------------
print_modes();
print "Select Mode (1/2): ";
chomp(my $mode = <STDIN>);
die "Invalid mode\n" unless $mode =~ /^[12]$/;

print "Enter GSTIN: ";
chomp(my $gstin = uc <STDIN>);
die "Invalid GSTIN\n" unless valid_gstin($gstin);

if ($mode == 1) {
my ($state_code,$pan) = extract_parts($gstin);
my $state_name = $STATE{$state_code} // 'Unknown';

print "\nOFFLINE VERIFICATION PASSED\n";
print "GSTIN      : $gstin\n";
print "PAN        : $pan\n";
print "State      : $state_name ($state_code)\n";
}
if ($mode == 2) {
    print "\nFetching ONLINE details...\n";
    my $d = fetch_online($gstin);

    print <<TXT;

ONLINE VERIFICATION RESULT
--------------------------------------
GSTIN              : $d->{gstin}
Legal Name         : $d->{legal_business_name}
Trade Name         : $d->{trade_name}
GST Status         : $d->{gstin_uin_status}
Taxpayer Type      : $d->{taxpayer_type}
Business Type      : $d->{constitution_of_business}
Registration Date  : @{[ $d->{effective_date_of_reg} =~ s/T.*//r ]}
TXT

    print "\nJURISDICTION DETAILS\n";
    print "State Jurisdiction   : $d->{state_jurisdiction_ward}\n";
    print "Central Jurisdiction : $d->{central_jurisdiction_ward}\n";

    # -------- Goods & Services (limited) --------
    print "\nGOODS & SERVICES (HSN SUMMARY)\n";
    my $i = 0;
    for my $g (@{$d->{goods_and_services_list}}) {
        last if ++$i > 5;
        print "HSN $g->{hsn_code} : $g->{goods_services_desc}\n";
    }
    print "(Showing first 5 items)\n"
        if @{$d->{goods_and_services_list}} > 5;

    # -------- Filing summary (latest per type) --------
    print "\nRETURN FILING SUMMARY\n";
    print "---------------------------------------------------------------\n";
    print sprintf(
        "%-8s | %-14s | %-10s | %-12s\n",
        "Return", "Financial Year", "Tax Period", "Filing Date"
    );
    print "---------------------------------------------------------------\n";

    my %latest;
    for my $f (@{$d->{filings}}) {
        next unless $f->{date_of_filing};
        my $t = $f->{filing_type};
        $latest{$t} = $f
            if !$latest{$t} || $f->{date_of_filing} gt $latest{$t}{date_of_filing};
    }

    for my $k (sort keys %latest) {
        my $fd = $latest{$k}{date_of_filing};
        $fd =~ s/T.*//;

        print sprintf(
            "%-8s | %-14s | %-10s | %-12s\n",
            $k,
            $latest{$k}{financial_year},
            $latest{$k}{tax_period},
            $fd
        );
    }
}
print "\nVerification Completed Successfully \n";
