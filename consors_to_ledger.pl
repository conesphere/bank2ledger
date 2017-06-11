#!/usr/bin/env perl
use Text::CSV::Encoded;
use utf8;
binmode(STDOUT, ":utf8");
my $csv=Text::CSV::Encoded->new({
	binary=>1,
	encoding_in=>"utf8",
	encoding_out=>"utf8",
	sep_char=>";",
	allow_whitespace=>1,
	quote_char=>'"',
});

my $indent="    "; 
my $mode="head";

while(<STDIN>){
	chomp; 
	$csv->parse($_); 
	my @c=$csv->fields();
	if ( $mode eq "head" ) {
		if ( $c[0] =~ /^Buchung/ ) {
			$mode="buchung";
		}
	} elsif ( $mode eq "buchung" ) {
		my ( $day, $valuta, $auftraggeber, $kontonummer, $blz, $btext, $zweck, $betrag) = @c; 
		$day=substr($day,6,4)."/".substr($day,3,2)."/".substr($day,0,2); 
		$auftraggeber=~s/\s+$//g; 
		my @comments; 
		if ( $btext ) { push(@comments, $btext); }
		if ( $zweck ) { push(@comments, $zweck); }
		$betrag=~s/\.//g;
		$betrag=~s/,/./g;
		push(@comments, "amnt: € $betrag");
		if ( ! $auftraggeber ) { $auftraggeber=$btext }
		print "$day $auftraggeber \n";
		print "$indent; ".join("\n$indent; ", @comments)."\n";
		print "${indent}Assets:Bank:DKB $kontonummer    € $betrag\n";
		print "${indent}Equity:Checking\n";
	} 
}
