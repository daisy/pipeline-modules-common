<xsl:stylesheet xmlns="http://www.daisy.org/z3986/2005/dtbook/" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:dc="http://purl.org/dc/terms/" 
    xmlns:svrl="http://purl.oclc.org/dsdl/svrl"  
    xmlns:d="http://www.daisy.org/ns/pipeline/data"
    xpath-default-namespace="http://www.daisy.org/z3986/2005/dtbook/" version="2.0">
    
    <xsl:output method="xml" indent="yes"/>
    
    
    <xsl:template match="/">
        <xsl:variable name="failed-asserts" select="collection()/d:document-validation-report//svrl:failed-assert"/>
        <xsl:for-each-group select="$failed-asserts" group-by="@location">
            <xsl:apply-templates select="current()"/>
        </xsl:for-each-group>   
        
        <xsl:variable name="successful-reports" select="collection()/d:document-validation-report//svrl:successful-report"/>
        <xsl:for-each-group select="$successful-reports" group-by="@location">
            <xsl:apply-templates select="current()"/>
        </xsl:for-each-group>   
        
    </xsl:template>
    
    <xsl:template match="svrl:failed-assert/@location | svrl:successful-report/@location">
        
        <xsl:variable name="xpath" select="."/>
        <xsl:variable name="docelem" select="collection()/$xpath"/>
        <xsl:variable name="nearest-id" select="$docelem/ancestor::*[@id][1]/@id"/>
        <xsl:variable name="docpath" select="collection()/d:document-validation-report/d:document-info/d:document-path/text()"/>
        <xsl:attribute name="location">
            <xsl:value-of select="concat($docpath, '#', $nearest-id)"/>
        </xsl:attribute>
    </xsl:template>
    
    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>