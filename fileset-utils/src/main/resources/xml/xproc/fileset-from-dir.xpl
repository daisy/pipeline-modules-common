<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step version="1.0" type="px:fileset-from-dir" xmlns:p="http://www.w3.org/ns/xproc"
  xmlns:px="http://www.daisy.org/ns/pipeline/xproc">

  <p:output port="result"/>
  <p:option name="path" required="true"/>
  <p:option name="recursive" select="'true'"/>
  <p:option name="include-filter"/>
  <p:option name="exclude-filter"/>

  <p:import href="http://www.daisy.org/pipeline/modules/file-utils/library.xpl"/>
  <p:import href="fileset-from-dir-list.xpl"/>

  <p:choose>
    <p:when
      test="p:value-available('include-filter')
        and p:value-available('exclude-filter')">
      <px:directory-list>
        <p:with-option name="path" select="$path"/>
        <p:with-option name="depth" select="if($recursive='true') then -1 else 0"/>
        <p:with-option name="include-filter" select="$include-filter"/>
        <p:with-option name="exclude-filter" select="$exclude-filter"/>
      </px:directory-list>
    </p:when>
    <p:when test="p:value-available('include-filter')">
      <px:directory-list>
        <p:with-option name="path" select="$path"/>
        <p:with-option name="depth" select="if($recursive='true') then -1 else 0"/>
        <p:with-option name="include-filter" select="$include-filter"/>
      </px:directory-list>
    </p:when>
    <p:when test="p:value-available('exclude-filter')">
      <px:directory-list>
        <p:with-option name="path" select="$path"/>
        <p:with-option name="depth" select="if($recursive='true') then -1 else 0"/>
        <p:with-option name="exclude-filter" select="$exclude-filter"/>
      </px:directory-list>
    </p:when>
    <p:otherwise>
      <px:directory-list>
        <p:with-option name="path" select="$path"/>
        <p:with-option name="depth" select="if($recursive='true') then -1 else 0"/>
      </px:directory-list>
    </p:otherwise>
  </p:choose>

  <px:fileset-from-dir-list/>

</p:declare-step>
