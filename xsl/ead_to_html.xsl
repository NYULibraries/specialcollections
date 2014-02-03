<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:ead="urn:isbn:1-931666-22-9"
    xmlns:ns2="http://www.w3.org/1999/xlink">

    <!-- <xsl:strip-space elements="*"/> -->
    <xsl:output indent="yes" method="html"/>
    <!-- <xsl:include href="/Users/adamw/Projects/Rails/blacklight-app/current/blacklight-app/xsl/lookupLists.xsl"/> -->

    <!-- Creates the html partial of the finding aid -->
    <xsl:template match="/">

      <!-- Summary tab -->
      <div class="tab-pane active" id="summary">
        <legend>General Information</legend>
        <dl id="geninfo" class="dl-horizontal">
          <dt>Title:</dt>
          <dd><span itemprop="name"><xsl:apply-templates select="//ead:archdesc/ead:did/ead:unittitle"/></span></dd>
          <dt>Dates:</dt>
          <dd><xsl:apply-templates select="//ead:archdesc/ead:did/ead:unitdate"/></dd>
          <dt>Extent:</dt>
          <dd><xsl:apply-templates select="//ead:archdesc/ead:did/ead:physdesc/ead:extent"/></dd>
          <dt>Language:</dt>
          <dd><xsl:apply-templates select="//ead:archdesc/ead:did/ead:langmaterial"/></dd>
          <dt>Processing Information:</dt>
          <dd><xsl:apply-templates select="//ead:archdesc/ead:processinfo/ead:p"/></dd>
          <dt>Preferred Citation:</dt>
          <dd><xsl:apply-templates select="//ead:archdesc/ead:prefercite/ead:p"/></dd>
        </dl>

        <!-- Other sections of archdesc are displayed in paragraph format -->
        <legend>Collection Overview</legend>
        <p><span itemprop="description"><xsl:apply-templates select="//ead:archdesc/ead:did/ead:abstract"/></span></p>
      </div>

      <!-- Description tab -->
      <div class="tab-pane" id="description">
        <div id="bioghist">
          <xsl:apply-templates select="//ead:archdesc/ead:bioghist"/>
        </div>
        <xsl:apply-templates select="//ead:archdesc/ead:bibliography"/>
        <xsl:apply-templates select="//ead:archdesc/ead:accruals"/>
        <xsl:apply-templates select="//ead:archdesc/ead:separatedmaterial"/>
        <xsl:apply-templates select="//ead:archdesc/ead:originalsloc"/>
        <xsl:apply-templates select="//ead:archdesc/ead:relatedmaterial"/>
        <xsl:apply-templates select="//ead:archdesc/ead:custodhist"/>
      </div>

      <!-- Restrictions tab -->
      <div class="tab-pane" id="restrictions">
        <legend>Restrictions</legend>
        <h5>Use</h5>
        <xsl:apply-templates select="//ead:archdesc/ead:userestrict/ead:p"/>
        <h5>Access</h5>
        <xsl:apply-templates select="//ead:archdesc/ead:accessrestrict/ead:p"/>
      </div>
               
    </xsl:template>
    <!-- End of the html page -->

    <!--
      Templates start here. Those that affect the display and formating of nodes over
      the the entire document come first, followed by those that pertain to nodes
      within specific sections of the document.
    -->

    <!-- EAD headings -->
    <xsl:template match="ead:head">
      <xsl:choose>
        <xsl:when test="parent::ead:chronlist"><h5><xsl:apply-templates/></h5></xsl:when>
        <xsl:when test="parent::ead:list"><h5><xsl:apply-templates/></h5></xsl:when>
        <xsl:when test="ancestor::ead:c"><h5><xsl:apply-templates/></h5></xsl:when>
        <xsl:otherwise><legend><xsl:apply-templates/></legend></xsl:otherwise>
      </xsl:choose>
    </xsl:template>

    <!-- EAD navigation links -->
    <xsl:template match="ead:head" mode="navlinks">
      <xsl:variable name="id" select="local-name(parent::*)"/>
      <a href="#{$id}"><xsl:apply-templates/></a>
    </xsl:template>


    <!-- EAD paragraphs -->
    <xsl:template match="ead:p">
      <p><xsl:apply-templates/></p>
    </xsl:template>

    <!-- EAD dates: Contenate multiple unitdate fields together -->
    <xsl:template match="ead:unitdate">
      <span class="unitdate">
        <xsl:choose>
          <xsl:when test="@type='inclusive'">Inclusive, <xsl:apply-templates/><xsl:if test="following-sibling::ead:unitdate != ''">; </xsl:if></xsl:when>
          <xsl:when test="@type='bulk'"><xsl:apply-templates/><xsl:if test="following-sibling::ead:unitdate != ''">; </xsl:if></xsl:when>
          <xsl:otherwise><xsl:apply-templates/></xsl:otherwise>
        </xsl:choose>
      </span>
    </xsl:template>

    <!-- Component nodes -->
    <xsl:template match="ead:c">
      <xsl:variable name="id" select="@id"/>
      <xsl:variable name="depth" select="count(ancestor::ead:c) + 1"/>
      <div id="{$id}" class="component_part clearfix c0{$depth}">

        <!-- Each field in the component gets formatted here -->
        <h3><xsl:apply-templates select="ead:did/ead:unittitle"/><xsl:if test="ead:did/ead:unittitle != '' and ead:did/ead:unitdate">, </xsl:if><xsl:apply-templates select="ead:did/ead:unitdate"/></h3>
        <dl class="dl-horizontal">

          <!-- container field -->
          <xsl:apply-templates select="ead:did/ead:container"/>

          <!-- language field -->
          <xsl:for-each select="ead:did/ead:langmaterial">
            <xsl:choose>
              <xsl:when test="not(child::ead:language)">
                <dt>Language:</dt>
                <dd><xsl:apply-templates select="."/></dd>
              </xsl:when>
            </xsl:choose>
          </xsl:for-each>

          <!-- physical description field -->
          <xsl:for-each select="ead:did/ead:physdesc">
            <xsl:choose>
              <xsl:when test="child::ead:dimensions">
                <dt>Dimensions:</dt>
                <dd><xsl:apply-templates select="child::ead:dimensions"/></dd>
              </xsl:when>
              <xsl:otherwise>
                <dt>Physical Description:</dt>
                <dd><xsl:apply-templates select="."/></dd>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:for-each>
        </dl>

        <!-- other fields outside of <did> -->
        <xsl:apply-templates select="ead:scopecontent" />
        <xsl:apply-templates select="ead:accessrestrict" />
        <xsl:apply-templates select="ead:odd" />
        <xsl:apply-templates select="ead:separatedmaterial" />
        <xsl:apply-templates select="ead:originalsloc" />

        <!-- pass along any child component for further processing -->
        <xsl:apply-templates select="ead:c"/>
      </div>

    </xsl:template>

    <!--
    <xsl:template match="ead:c/ead:did/ead:unittitle">
      <h3><xsl:apply-templates/></h3>
    </xsl:template>
    -->

    <xsl:template match="ead:container">
      <xsl:variable name="id" select="@id"/>
      <xsl:if test="@id !=''">
        <dt>Location:</dt>
        <dd>
          <xsl:value-of select="@type" />: <xsl:value-of select="self::ead:container" />
          <xsl:if test="following-sibling::ead:container">, </xsl:if>
          <xsl:for-each select="following-sibling::ead:container[@parent=$id]">
            <xsl:value-of select="@type" />: <xsl:value-of select="self::ead:container" />
            <xsl:if test="not(position() = last())">, </xsl:if>
          </xsl:for-each>
          (<xsl:value-of select="@label" />)
        </dd>
      </xsl:if>
    </xsl:template>



    <!-- Puts a space between multiple nodes -->
    <xsl:template match="ead:extent">
      <xsl:apply-templates/>
      <xsl:text>&#160;</xsl:text>
    </xsl:template>

    <!-- bioghist bits... -->
    <xsl:template match="ead:chronlist">
      <dl class="dl-horizontal"><xsl:apply-templates/></dl>
    </xsl:template>

    <xsl:template match="ead:chronitem/ead:date">
      <dt><xsl:apply-templates/></dt>
    </xsl:template>

    <xsl:template match="ead:chronitem/ead:event">
      <dd><xsl:apply-templates/></dd>
    </xsl:template>

    <xsl:template match="ead:chronitem/ead:eventgrp">
      <dd><ul><xsl:apply-templates/></ul></dd>
    </xsl:template>

    <xsl:template match="ead:chronitem/ead:eventgrp/ead:event">
      <li><xsl:apply-templates/></li>
    </xsl:template>

    <xsl:template match="ead:list/ead:item">
      <p class="bibliography"><xsl:apply-templates/></p>
    </xsl:template>

    <!-- for source lists that are separate -->
    <xsl:template match="ead:bibref">
      <p><xsl:apply-templates/></p>
    </xsl:template>

    <!-- Subject headings -->
    <xsl:template match="ead:controlaccess/ead:persname">
      <xsl:variable name="value" select="self::ead:persname"/>
      <span><a href="RAILS_RELATIVE_URL_ROOT/catalog?f[name_facet][]={$value}"><xsl:apply-templates/></a></span>
    </xsl:template>
    <xsl:template match="ead:controlaccess/ead:corpname">
      <xsl:variable name="value" select="self::ead:corpname"/>
      <span><a href="RAILS_RELATIVE_URL_ROOT/catalog?f[name_facet][]={$value}"><xsl:apply-templates/></a></span>
    </xsl:template>
    <xsl:template match="ead:controlaccess/ead:genreform">
      <xsl:variable name="value" select="self::ead:genreform"/>
      <span><a href="RAILS_RELATIVE_URL_ROOT/catalog?f[genre_facet][]={$value}"><xsl:apply-templates/></a></span>
    </xsl:template>
    <xsl:template match="ead:controlaccess/ead:subject">
      <xsl:variable name="value" select="self::ead:subject"/>
      <span><a href="RAILS_RELATIVE_URL_ROOT/catalog?f[subject_facet][]={$value}"><xsl:apply-templates/></a></span>
    </xsl:template>

    <!-- empty template to skip unitdate since it's dealt with in unittitle
    <xsl:template match="//ead:c/ead:did/ead:unitdate"/>
    -->
    <!-- supress all accession numbers -->
    <!--
    <xsl:template match="//ead:c/ead:odd">
      <xsl:choose>
        <xsl:when test="contains(., 'Museum Accession Number')"> </xsl:when>
        <xsl:otherwise> <xsl:apply-templates/> </xsl:otherwise>
      </xsl:choose>
    </xsl:template>
    -->
    <!-- supress nodes marked as internal -->
    <xsl:template match="*[@audience='internal']"/>

    <!-- General templates for formatting html -->

    <!-- Translate ead text formatting into html -->
    <xsl:template match="*[@render = 'bold'] | *[@altrender = 'bold'] ">
        <xsl:if test="preceding-sibling::*"> &#160;</xsl:if><strong><xsl:apply-templates/></strong>
    </xsl:template>
    <xsl:template match="*[@render = 'bolddoublequote'] | *[@altrender = 'bolddoublequote']">
        <xsl:if test="preceding-sibling::*"> &#160;</xsl:if><strong>"<xsl:apply-templates/>"</strong>
    </xsl:template>
    <xsl:template match="*[@render = 'boldsinglequote'] | *[@altrender = 'boldsinglequote']">
        <xsl:if test="preceding-sibling::*"> &#160;</xsl:if><strong>'<xsl:apply-templates/>'</strong>
    </xsl:template>
    <xsl:template match="*[@render = 'bolditalic'] | *[@altrender = 'bolditalic']">
        <xsl:if test="preceding-sibling::*"> &#160;</xsl:if><strong><em><xsl:apply-templates/></em></strong>
    </xsl:template>
    <xsl:template match="*[@render = 'boldsmcaps'] | *[@altrender = 'boldsmcaps']">
        <xsl:if test="preceding-sibling::*"> &#160;</xsl:if><strong><span class="smcaps"><xsl:apply-templates/></span></strong>
    </xsl:template>
    <xsl:template match="*[@render = 'boldunderline'] | *[@altrender = 'boldunderline']">
        <xsl:if test="preceding-sibling::*"> &#160;</xsl:if><strong><span class="underline"><xsl:apply-templates/></span></strong>
    </xsl:template>
    <xsl:template match="*[@render = 'doublequote'] | *[@altrender = 'doublequote']">
        <xsl:if test="preceding-sibling::*"> &#160;</xsl:if>"<xsl:apply-templates/>"
    </xsl:template>
    <xsl:template match="*[@render = 'italic'] | *[@altrender = 'italic']">
        <xsl:if test="preceding-sibling::*"> &#160;</xsl:if><em><xsl:apply-templates/></em>
    </xsl:template>
    <xsl:template match="*[@render = 'singlequote'] | *[@altrender = 'singlequote']">
        <xsl:if test="preceding-sibling::*"> &#160;</xsl:if>'<xsl:apply-templates/>'
    </xsl:template>
    <xsl:template match="*[@render = 'smcaps'] | *[@altrender = 'smcaps']">
        <xsl:if test="preceding-sibling::*"> &#160;</xsl:if><span class="smcaps"><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="*[@render = 'sub'] | *[@altrender = 'sub']">
        <xsl:if test="preceding-sibling::*"> &#160;</xsl:if><sub><xsl:apply-templates/></sub>
    </xsl:template>
    <xsl:template match="*[@render = 'super'] | *[@altrender = 'super']">
        <xsl:if test="preceding-sibling::*"> &#160;</xsl:if><sup><xsl:apply-templates/></sup>
    </xsl:template>
    <xsl:template match="*[@render = 'underline'] | *[@altrender = 'underline']">
        <xsl:if test="preceding-sibling::*"> &#160;</xsl:if><span class="underline"><xsl:apply-templates/></span>
    </xsl:template>

    <!-- Random things... -->
    <xsl:template match="text()[not(string-length(normalize-space()))]"/>

    <xsl:template match="text()[string-length(normalize-space()) > 0]">
      <xsl:value-of select="translate(.,'&#xA;&#xD;', '  ')"/>
    </xsl:template>

    <xsl:template name="print-step">
      <xsl:text>/</xsl:text>
      <xsl:value-of select="name()"/>
      <xsl:text>[</xsl:text>
      <xsl:value-of select="1+count(preceding-sibling::*)"/>
      <xsl:text>]</xsl:text>
    </xsl:template>

</xsl:stylesheet>
