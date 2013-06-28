<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step type="px:fileset-in-memory-update" name="main" xmlns:p="http://www.w3.org/ns/xproc" xmlns:c="http://www.w3.org/ns/xproc-step" version="1.0" xmlns:px="http://www.daisy.org/ns/pipeline/xproc">
    <p:input port="insertion" sequence="true" primary="true"/>
    <p:input port="source" sequence="true"/>
    <p:output port="result" sequence="true"/>
    
    <p:for-each name="for-each">
        <p:iteration-source>
            <p:pipe port="source" step="main"/>
        </p:iteration-source>
        <p:variable name="source-base" select="base-uri(/*)"/>
        <p:split-sequence initial-only="true">
            <p:with-option name="test" select="concat(&quot;base-uri(/*)='&quot;,$source-base,&quot;'&quot;)"/>
            <p:input port="source">
                <p:pipe port="insertion" step="main"/>
            </p:input>
        </p:split-sequence>
        <p:identity name="insertion"/>
        <p:count/>
        <p:choose>
            <p:when test="not(/*='0')">
                <p:identity>
                    <p:input port="source">
                        <p:pipe port="result" step="insertion"/>
                    </p:input>
                </p:identity>
            </p:when>
            <p:otherwise>
                <p:identity>
                    <p:input port="source">
                        <p:pipe port="current" step="for-each"/>
                    </p:input>
                </p:identity>
            </p:otherwise>
        </p:choose>
    </p:for-each>
    
</p:declare-step>
