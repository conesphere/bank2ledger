<?xml version="1.0"?>

<xsl:stylesheet version="1.0" xmlns:pb="urn:iso:std:iso:20022:tech:xsd:camt.052.001.03" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="text" omit-xml-declaration="yes" indent="yes"/>
<xsl:param name="prefix" select="''"/>

<xsl:template match="/">
<xsl:for-each select="pb:document/pb:BkToCstmrAcctRpt/pb:Rpt/pb:Ntry">
<xsl:value-of select="concat(substring(pb:BookgDt/pb:Dt,1,4),'/',substring(pb:BookgDt/pb:Dt,6,2),'/',substring(pb:BookgDt/pb:Dt,9,2))"/><xsl:value-of select="' '"/><xsl:if test="pb:NtryDtls/pb:TxDtls/pb:RltdPties/pb:Cdtr/pb:Nm = ''"><xsl:value-of select="pb:NtryDtls/pb:TxDtls/pb:RltdPties/pb:Dbtr/pb:Nm"/></xsl:if><xsl:value-of select="pb:NtryDtls/pb:TxDtls/pb:RltdPties/pb:Cdtr/pb:Nm"/>
<xsl:for-each select="pb:NtryDtls/pb:TxDtls/pb:RmtInf/pb:Ustrd">
    ; <xsl:value-of select="."/>
</xsl:for-each>
    ; amnt: € <xsl:if test="pb:CdtDbtInd/text() = 'DBIT'">-</xsl:if><xsl:value-of select="pb:Amt"/>
    Assets:Bank:Postbank<xsl:value-of select="concat(' ', /pb:document/pb:BkToCstmrAcctRpt/pb:Rpt/pb:Acct/pb:Id/pb:IBAN/text())"/>   € <xsl:if test="pb:CdtDbtInd/text() = 'DBIT'">-</xsl:if><xsl:value-of select="pb:Amt"/>   
    Equity:Checking
</xsl:for-each>
</xsl:template>

</xsl:stylesheet> 
