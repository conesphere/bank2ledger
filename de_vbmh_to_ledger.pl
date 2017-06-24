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

while(<STDIN>){
	while ($_ !~ /\r\n$/) {
		$_.=<STDIN>;
	}
	s/\r\n$//g;
	$csv->parse($_); 
	my @c=$csv->fields();
	if ( $mode eq "head" ) {
		if ( $c[0] =~ /^Konto:/ ) {
			$iban=$c[1];
			$iban =~ s/^(\d+)\s.*/$1/gex; # not needed neccessarily but its safer
			#print $iban."\n";
		} elsif ( $c[0] =~ /^Buchungstag/ ) {
			$mode="buchung";
		}
	} elsif ( $mode eq "buchung" ) {
		# end processing on first empty line found
		if ( $#c == 0 ) { $mode="end"; next; }
		my ( $day, $valuta, $auftraggeber, $empfaenger, $kontonummer, $ibands, $blz, $bic, $zweck, $referenz, $waehrung, $betrag, $sh ) = @c; 
		$day=substr($day,6,4)."/".substr($day,3,2)."/".substr($day,0,2); 
		my @comments; 
		if ( $kontonummer ) { push(@comments, $kontonummer); }
		if ( $referenz ) { push(@comments, $referemz); }
		$zweck=~s/\n+/<br \/>/gs;
		@comments=(@comments, split("<br />", $zweck)); 
		$betrag=~s/\.//g;
		$betrag=~s/,/./g;
		if ( $sh eq "S" ) { $betrag="-".$betrag; }
		if ( ! $empfaenger ) { $empfaenger=$auftraggeber; }
		if ( ! $empfaenger ) { $empfaenger=$referenz; }
		if ( ! $empfaenger ) { $empfaenger=$comments[0]; }
		print "$day $empfaenger\n";
		print "\t; ".join("\n\t; ", @comments)."\n";
		print "\tAssets:Bank:vbmh $iban    € $betrag\n";
		print "\tEquity:Checking\n";
	} 
}
