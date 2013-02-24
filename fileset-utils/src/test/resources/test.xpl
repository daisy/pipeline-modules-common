<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" xmlns:px="http://www.daisy.org/ns/pipeline/xproc" xmlns:pxi="http://www.daisy.org/ns/pipeline/xproc/internal" xmlns:c="http://www.w3.org/ns/xproc-step" version="1.0"
    xmlns:cx="http://xmlcalabash.com/ns/extensions" xmlns:d="http://www.daisy.org/ns/pipeline/data" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:catalog="urn:oasis:names:tc:entity:xmlns:xml:catalog" exclude-inline-prefixes="#all">

    <p:output port="result" sequence="true">
        <p:pipe port="result" step="result"/>
    </p:output>

    <p:import href="http://www.daisy.org/pipeline/modules/validation-utils/validation-utils-library.xpl"/>

    <p:import href="test-fileset-add-entry.xpl"/>
    <p:import href="test-fileset-add-ref.xpl"/>
    <p:import href="test-fileset-copy.xpl"/>
    <p:import href="test-fileset-create.xpl"/>
    <p:import href="test-fileset-diff.xpl"/>
    <p:import href="test-fileset-from-dir-list.xpl"/>
    <p:import href="test-fileset-from-dir.xpl"/>
    <p:import href="test-fileset-intersect.xpl"/>
    <p:import href="test-fileset-join.xpl"/>

    <pxi:test-fileset-add-entry name="test-fileset-add-entry"/>
    <pxi:test-fileset-add-ref name="test-fileset-add-ref"/>
    <pxi:test-fileset-copy name="test-fileset-copy"/>
    <pxi:test-fileset-create name="test-fileset-create"/>
    <pxi:test-fileset-diff name="test-fileset-diff"/>
    <pxi:test-fileset-from-dir-list name="test-fileset-from-dir-list"/>
    <pxi:test-fileset-from-dir name="test-fileset-from-dir"/>
    <pxi:test-fileset-intersect name="test-fileset-intersect"/>
    <pxi:test-fileset-join name="test-fileset-join"/>

    <p:for-each name="test">
        <p:output port="result">
            <p:pipe port="result" step="test.result"/>
        </p:output>
        <p:iteration-source>
            <p:pipe step="test-fileset-add-entry" port="result"/>
            <p:pipe step="test-fileset-add-ref" port="result"/>
            <p:pipe step="test-fileset-copy" port="result"/>
            <p:pipe step="test-fileset-create" port="result"/>
            <p:pipe step="test-fileset-diff" port="result"/>
            <p:pipe step="test-fileset-from-dir-list" port="result"/>
            <p:pipe step="test-fileset-from-dir" port="result"/>
            <p:pipe step="test-fileset-intersect" port="result"/>
            <p:pipe step="test-fileset-join" port="result"/>
        </p:iteration-source>
        <p:variable name="script-uri" select="/*/@script-uri"/>
        <p:variable name="test-group-name" select="/*/@name"/>
        <p:delete match="/*/c:result[.='true']"/>
        <p:viewport match="/*/c:result" name="test.viewport">
            <p:in-scope-names name="test.viewport.vars"/>
            <p:template>
                <p:input port="source">
                    <p:pipe step="test.viewport" port="current"/>
                </p:input>
                <p:input port="template">
                    <p:inline>
                        <d:error>
                            <d:desc>{string(//@name)} {if (.='false') then 'failed' else .}</d:desc>
                            <!--<d:file>{$script-uri}</d:file>-->
                            <d:location href="{$script-uri}#{/*/@name}"/>
                        </d:error>
                    </p:inline>
                </p:input>
                <p:input port="parameters">
                    <p:pipe step="test.viewport.vars" port="result"/>
                </p:input>
            </p:template>
            <p:wrap match="/*" wrapper="d:errors"/>
            <p:wrap match="/*" wrapper="d:report"/>
            <p:add-attribute match="/*" attribute-name="type" attribute-value="filecheck"/>
        </p:viewport>
        <p:rename match="/*" new-name="d:reports"/>
        <p:wrap match="/*" wrapper="d:document-validation-report"/>
        <p:insert match="/*" position="first-child">
            <p:input port="insertion">
                <p:pipe step="test.document-info" port="result"/>
            </p:input>
        </p:insert>
        <p:identity name="test.result"/>

        <p:in-scope-names name="test.vars"/>
        <p:template name="test.document-info">
            <p:input port="source">
                <p:pipe port="current" step="test"/>
            </p:input>
            <p:input port="template">
                <p:inline>
                    <d:document-info>
                        <d:document-name>{string(/*/@name)}</d:document-name>
                        <d:document-type>XProc Unit Test</d:document-type>
                        <d:document-path>{$script-uri}</d:document-path>
                    </d:document-info>
                </p:inline>
            </p:input>
            <p:input port="parameters">
                <p:pipe step="test.vars" port="result"/>
            </p:input>
        </p:template>
    </p:for-each>

    <px:validation-report-to-html name="result"/>
    <p:store href="file:/tmp/report.html"/>

</p:declare-step>
