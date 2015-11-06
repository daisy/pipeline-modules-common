<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step version="1.0" name="convert-xpath-links" type="px:convert-xpath-links"
    xmlns:p="http://www.w3.org/ns/xproc" 
    xmlns:c="http://www.w3.org/ns/xproc-step"
    xmlns:px="http://www.daisy.org/ns/pipeline/xproc"
    xmlns:pxi="http://www.daisy.org/ns/pipeline/xproc/internal"
    xmlns:xhtml="http://www.w3.org/1999/xhtml" 
    xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
    xmlns:d="http://www.daisy.org/ns/pipeline/data" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    exclude-inline-prefixes="#all">

    <p:documentation xmlns="http://www.w3.org/1999/xhtml">
        <h1 px:role="name">Convert XPath links</h1>
        <p px:role="desc">Given a document validation report, convert the XPath locations to a URL
            like file://document.xml#ID, using the nearest ID.</p>
    </p:documentation>

    <!-- ***************************************************** -->
    <!-- INPUT, OUTPUT and OPTIONS -->
    <!-- ***************************************************** -->

    <p:input port="source" primary="true">
        <p:documentation xmlns="http://www.w3.org/1999/xhtml">
            <h1 px:role="name">source</h1>
            <p px:role="desc">A validation report
                (https://code.google.com/p/daisy-pipeline/wiki/ValidationReportXML).</p>
        </p:documentation>
    </p:input>
    <p:output port="result" primary="true">
        <p:documentation xmlns="http://www.w3.org/1999/xhtml">
            <h1 px:role="name">result</h1>
            <p px:role="desc">A validation report
                (https://code.google.com/p/daisy-pipeline/wiki/ValidationReportXML), with
                XPath-style links supplemented by ID links.</p>
        </p:documentation>
    </p:output>

    <!-- load the document that the error report refers to -->
    
    <p:load name="load-document">
        <p:with-option 
            name="href" 
            select="//d:document-path/text()"/> 
    </p:load>
    
    
    <!-- create a skeleton xslt -->
    <p:identity name="xslt-base">
        <p:input port="source">
            <p:inline>
                <xsl:stylesheet xmlns="http://www.daisy.org/z3986/2005/dtbook/"
                    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                    xmlns:dc="http://purl.org/dc/terms/" xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                    xmlns:d="http://www.daisy.org/ns/pipeline/data"
                    xpath-default-namespace="http://www.daisy.org/z3986/2005/dtbook/" version="2.0">

                    <xsl:output method="xml" indent="yes"/>

                    <xsl:template match="node() | @*" id="copy-node">
                        <xsl:copy>
                            <xsl:apply-templates select="node() | @*"/>
                        </xsl:copy>
                    </xsl:template>

                </xsl:stylesheet>
            </p:inline>
        </p:input>
    </p:identity>

    
    <!-- for each failed-assert and successful-report element, create xslt templates that add an attribute to that element.
        the attribute will be called @id-link and it will contain a link in the form of document.xml#ID 
        it will point to the same element or nearest ancestor as the current svrl @location attribute
    -->

    <!-- for each svrl:failed-assert | svrl:successful-report -->

    <p:for-each name="for-each-svrl-error">
        <p:output port="result"></p:output>
        <!-- TODO we want to look at all elements, not just one; but when we iterate over all elements, the "port produces many documents" -->
        <p:iteration-source select="//svrl:failed-assert[1]"> 
            <p:pipe port="source" step="convert-xpath-links"/>
        </p:iteration-source>
        <p:variable name="location-xpath" select="*/@location">
            <p:pipe port="current" step="for-each-svrl-error"/>
        </p:variable>
        
        <p:variable name="doc-path" select="//d:document-path/text()">
            <p:pipe port="source" step="convert-xpath-links"/>
        </p:variable>
        
        
        <p:insert match="//xsl:template[@id='copy-node']" position="before">

            <p:input port="source">
                <p:pipe port="result" step="xslt-base"/>
            </p:input>

            <p:input port="insertion">

                <p:inline>
                    <xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                        xmlns:dc="http://purl.org/dc/terms/"
                        xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                        xmlns:d="http://www.daisy.org/ns/pipeline/data" match="@@">

                        <xsl:copy>
                            <xsl:attribute name="id-link">@@</xsl:attribute>
                            <xsl:apply-templates select="node() | @*"/>
                        </xsl:copy>
                    </xsl:template>
                </p:inline>
            </p:input>



        </p:insert>
        
       <!-- TODO this step, when working, should replace the text of xsl-attribute with "file:/path/document#ID"-->
        <!-- right now, we're just attempting to get the ID part working and we can add the rest of the stuff later -->
        <!-- the replacement isn't generating anything though -->
        <p:string-replace match="//xsl:attribute[@name='id-link' and text()='@@']/text()">
            <p:with-option name="replace" select="concat($location-xpath,'/ancestor-or-self::*[@id][1]/@id')">
                <p:pipe port="result" step="load-document"/>
            </p:with-option>
        </p:string-replace>
        
        <p:string-replace match="//xsl:template[@match='@@']/@match">
            <p:with-option name="replace" select="concat('&quot;', $location-xpath, '&quot;')"/>
        </p:string-replace>
        
   </p:for-each>

</p:declare-step>
