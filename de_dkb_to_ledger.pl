#!/usr/bin/env perl
use Text::CSV::Encoded;
use utf8;
binmode(STDOUT, ":utf8");
my $csv=Text::CSV::Encoded->new({
	binary=>1,
	encoding_in=>"iso-8859-1",
	encoding_out=>"utf8",
	sep_char=>";",
	allow_whitespace=>1,
	quote_char=>'"',
});

my $mode="head";
my $iban="undetected";
my $out="";

while(<STDIN>){
	chomp; 
	$csv->parse($_); 
	my @c=$csv->fields();
	if ( $mode eq "head" ) {
		if ( $c[0] =~ /^Kontonummer/ ) {
			$iban=$c[1];
			$iban =~ s/^(\w\w\d+)\s.*/$1/gex;
			#print $iban."\n";
		} elsif ( $c[0] =~ /^Buchungstag/ ) {
			$mode="buchung";
		}
	} elsif ( $mode eq "buchung" ) {
		my ( $day, $valuta, $btext, $auftraggeber, $zweck, $kontonummer, $blz, $betrag, $glaeubiger, $mandref, $kref ) = @c; 
		$day=substr($day,6,4)."/".substr($day,3,2)."/".substr($day,0,2); 
		my @comments; 
		if ( $kontonummer ) { push(@comments, $kontonummer); }
		if ( $mandref ) { push(@comments, $mandref); }
		if ( $kref ) { push(@comments, $kref); }
		$zweck=~s/\s\s\s\s\s+/<br \/>/g;
		@comments=(@comments, split("<br />", $zweck)); 
		$betrag=~s/\.//g;
		$betrag=~s/,/./g;
		if ( ! $auftraggeber ) { $auftraggeber=$btext }
		$out="$day $auftraggeber \n".
			"    ; ".join("\n    ; ", @comments)."\n".
			"    Assets:Bank:DKB $iban    € $betrag\n".
			"    Equity:Checking\n".
			$out;
	} 
}
print $out;
