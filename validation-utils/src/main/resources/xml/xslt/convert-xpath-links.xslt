<xsl:stylesheet xmlns="http://www.daisy.org/z3986/2005/dtbook/" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:dc="http://purl.org/dc/terms/" 
    xmlns:svrl="http://purl.oclc.org/dsdl/svrl"  
    xmlns:d="http://www.daisy.org/ns/pipeline/data"
    xpath-default-namespace="http://www.daisy.org/z3986/2005/dtbook/" version="2.0">
    
    <xsl:output method="xml" indent="yes"/>
    
    
    <!--  | //svrl:successful-report/@location"> -->
    
    <!-- 
        
        /*:package[namespace-uri()='http://openebook.org/namespaces/oeb-package/1.0/'][1]/*:metadata[namespace-uri()='http://openebook.org/namespaces/oeb-package/1.0/'][1]/*:x-metadata[namespace-uri()='http://openebook.org/namespaces/oeb-package/1.0/'][1] 
    -->
    <xsl:template 
        match="//svrl:failed-assert">
        <!-- 
            [@location = '/*:package[namespace-uri()=&quot;http://openebook.org/namespaces/oeb-package/1.0/&quot;][1]/*:metadata[namespace-uri()=&quot;http://openebook.org/namespaces/oeb-package/1.0/&quot;][1]/*:x-metadata[namespace-uri()=&quot;http://openebook.org/namespaces/oeb-package/1.0/&quot;][1]']">
        -->
        <xsl:copy>
            <xsl:attribute name="temp">PLACEHOLDER</xsl:attribute>
            <xsl:apply-templates select="node() | @*"/>
            
        </xsl:copy>
        
    </xsl:template>
    
    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>