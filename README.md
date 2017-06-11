# bank2ledger
a collection of scripts to convert a downloaded transaction log  of several Banks to ledger-cli format

## dl_postbank_to_ledger.xslt

This converts German Postbank xml files:

Usage: xsltproc dl_postbank_to_ledger.xslt infile.xml > outfile.ledger

## dl_dkb_to_ledger.pl

This converts CSV as it comes from DKB Online Banking

Usage: dl_dkb_to_ledger.pl < infile.csv > outfile.ledger

## dl_consors_to_ledger.pl

This converts CSV as it comes from Consors Online Banking

Usage: dl_consors_to_ledger.pl < infile.csv > outfile.ledger


