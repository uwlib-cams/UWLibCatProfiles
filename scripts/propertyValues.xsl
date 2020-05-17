<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" exclude-result-prefixes="xs math"
    version="3.0">

    <!-- Keys -->
    <xsl:key name="rdaW" match="rdf:Description" use="tokenize(@rdf:about, '/')[last()]"/>
    <xsl:key name="uwRdaExt" match="rdf:Description" use="tokenize(@rdf:about, '#')[last()]"/>
    <!-- Key variables -->
    <xsl:variable name="rdaWXml"
        select="document('https://raw.githubusercontent.com/RDARegistry/RDA-Vocabularies/master/xml/Elements/w.xml')"/>
    <xsl:variable name="uwRdaExtXml"
        select="document('https://www.lib.washington.edu/static/public/cams/data/localResources/rdaApplicationProfileExtension-1-0-1.rdf')"/>

    <xsl:template name="resourceValue">
        <xsl:param name="resource"/>
        <li>
            <xsl:choose>
                <xsl:when test="key('rdaW', local-name(.), $rdaWXml)">
                    <a href="{key('rdaW', local-name(.), $rdaWXml)/@rdf:about}">
                        <xsl:value-of
                            select="key('rdaW', local-name(.), $rdaWXml)/rdfs:label[@xml:lang = 'en']"
                        />
                    </a>
                    <strong>
                        <xsl:text>  |  </xsl:text>
                    </strong>
                    <!-- Get any associated rdfs:label values for hot text, to do this 
                        Call template resourceLabel here and below once it works -->
                    <a href="{@rdf:resource}">
                        <xsl:value-of select="@rdf:resource"/>
                    </a>
                </xsl:when>
                <xsl:when test="key('uwRdaExt', local-name(.), $uwRdaExtXml)">
                    <a href="{key('uwRdaExt', local-name(.), $uwRdaExtXml)/@rdf:about}">
                        <xsl:value-of
                            select="key('uwRdaExt', local-name(.), $uwRdaExtXml)/rdfs:label[@xml:lang = 'en']"
                        />
                    </a>
                    <strong>
                        <xsl:text>  |  </xsl:text>
                    </strong>
                    <!-- resourceLabel -->
                    <a href="{@rdf:resource}">
                        <xsl:value-of select="@rdf:resource"/>
                    </a>
                </xsl:when>
                <xsl:otherwise>
                    <a href=".">
                        <xsl:value-of select="local-name(.)"/>
                    </a>
                    <strong>
                        <xsl:text>  |  </xsl:text>
                    </strong>
                    <!-- resourceLabel -->
                    <a href="{@rdf:resource}">
                        <xsl:value-of select="@rdf:resource"/>
                    </a>
                </xsl:otherwise>
            </xsl:choose>
        </li>
    </xsl:template>
    <!-- TO DO: resourceLabel
    <xsl:template name="resourceLabel">
        <xsl:param name="resource"/>
        <xsl:choose>
            **THE QUESTION IS:
                HOW TO FIND IF MY @RDF:RESOURCE VALUE MATCHES A @RDF:DESCRIPTION @RDF:ABOUT VALUE IN THE OVERALL DOCUMENT??**
            <xsl:when test=""></xsl:when>
        </xsl:choose>
    </xsl:template> -->
    <xsl:template name="literalValue">
        <xsl:param name="literal"/>
        <li>
            <xsl:text>TEST LITERAL VALUE HERE</xsl:text>
        </li>
    </xsl:template>
</xsl:stylesheet>
