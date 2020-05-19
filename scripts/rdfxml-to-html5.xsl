<?xml version="1.0" encoding="UTF-8"?>
<!-- *CURRENTLY MUST CONFIRM MATCHING NAMESPACES IN SOURCE DATA BEFORE EACH TRANSFORM*
    TO DO:
        How can I reassign namespaces when serializing so I don't have to manually edit source XML? -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:rdam="http://rdaregistry.info/Elements/m/"
    xmlns:uwexpw="http://uw.edu/adaptationProperties/p/w/"
    xmlns:rdau="http://rdaregistry.info/Elements/u/" xmlns:sinvoc="http://sinopia.io/vocabulary/"
    xmlns:rdaw="http://rdaregistry.info/Elements/w/"
    xmlns:rdae="http://rdaregistry.info/Elements/e/"
    xmlns:uwrdaex="https://doi.org/10.6069/uwlib.55.d.4#"
    xmlns:rdai="http://rdaregistry.info/Elements/i/"
    xmlns:bf="http://id.loc.gov/ontologies/bibframe/"
    xmlns:madsrdf="http://www.loc.gov/mads/rdf/v1#" xmlns:bflc="http://id.loc.gov/ontologies/bflc/"
    xmlns:rdamdt="http://rdaregistry.info/Elements/m/datatype/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:skos="http://www.w3.org/2004/02/skos/core#"
    xmlns:xpf="http://www.w3.org/2005/xpath-functions" exclude-result-prefixes="xs math"
    version="3.0">
    <!-- Output HTML5 -->
    <xsl:output method="html" version="5"/>
    <!-- Include external stylesheets and templates -->
    <xsl:include href="props_values.xsl"/>
    <!-- Params -->
    <xsl:param name="format"/>
    <xsl:param name="formatTemplate"/>
    <!-- Vars -->
    <xsl:variable name="break">
        <strong>
            <xsl:text>  |  </xsl:text>
        </strong>
    </xsl:variable>
    <!-- TO DO:
        *Currently using xsl:result-doc + oXygen scenario params
        to output separate docs
        BUT this is a serious pain when input docs change-->
    <xsl:template match="/">
        <xsl:result-document href="../html/Sinopia{$format}.html">
            <html xmlns="http://www.w3.org/1999/xhtml">
                <head>
                    <title>
                        <xsl:text>Review </xsl:text>
                        <xsl:value-of select="$format"/>
                    </title>
                    <link href="htmlData.css" rel="stylesheet" type="text/css"/>
                </head>
                <body>
                    <xsl:apply-templates select="rdf:RDF"/>
                </body>
            </html>
        </xsl:result-document>
    </xsl:template>
    <xsl:template match="rdf:RDF">
        <xsl:apply-templates
            select="rdf:Description[rdf:type[@rdf:resource = 'http://rdaregistry.info/Elements/c/C10001']][sinvoc:hasResourceTemplate = $formatTemplate]"
            mode="wemiTop"/>
    </xsl:template>
    <xsl:template
        match="rdf:Description[rdf:type[@rdf:resource = 'http://rdaregistry.info/Elements/c/C10001']]"
        mode="wemiTop">
        <xsl:choose>
            <!-- This seems a clumsy way to do this but we don't want certain sets -->
            <xsl:when test="rdaw:P10331[text() != '' and text() != 'test' and text() != 'void']">

                <h1>
                    <span class="descSet">
                        <xsl:text>Description Set: </xsl:text>
                        <xsl:value-of select="rdaw:P10331"/>
                    </span>
                </h1>
                <xsl:apply-templates select="." mode="wProps"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template
        match="rdf:Description[rdf:type[@rdf:resource = 'http://rdaregistry.info/Elements/c/C10001']]"
        mode="wProps">
        <xsl:param name="wIri" select="@rdf:about"/>
        <h2>
            <span class="work">
                <xsl:text>Statements on the  </xsl:text>
                <a href="http://rdaregistry.info/Elements/c/C10001">
                    <xsl:text>RDA Work</xsl:text>
                </a>
                <xsl:text> Resource</xsl:text>
            </span>
        </h2>
        <!-- ul to ul code block identical for W, E, M, and I
            *So probably could further improve code to avoid repetition -->
        <ul>
            <xsl:for-each select="*[@rdf:resource]">
                <li>
                    <xsl:call-template name="property">
                        <xsl:with-param name="p" select="."/>
                    </xsl:call-template>
                    <xsl:value-of select="$break"/>
                    <!-- BIG QUESTION / TO DO:
                        Get any associated rdfs:label values for hot text, to do this 
                        [Call template resourceLabel here and below?] -->
                    <xsl:call-template name="val_resource">
                        <xsl:with-param name="r" select="@rdf:resource"/>
                    </xsl:call-template>
                </li>
            </xsl:for-each>
            <xsl:for-each select="*[not(@rdf:resource | @rdf:nodeID)]">
                <li>
                    <xsl:call-template name="property">
                        <xsl:with-param name="p" select="."/>
                    </xsl:call-template>
                    <xsl:value-of select="$break"/>
                    <xsl:call-template name="val_literal">
                        <xsl:with-param name="l" select="."/>
                    </xsl:call-template>
                </li>
            </xsl:for-each>
            <!-- TO DO:
                Output bnodes here and/or in named template-->
        </ul>
        <xsl:apply-templates
            select="../rdf:Description[rdf:type[@rdf:resource = 'http://rdaregistry.info/Elements/c/C10006']][rdae:P20231/@rdf:resource = $wIri]"
            mode="eProps"> </xsl:apply-templates>
    </xsl:template>
    <!-- Why does this work? Line 129 is the innovation.
        "You don't need the second predicate in the called template, it wouldn't make sense." -TG -->
    <xsl:template
        match="rdf:Description[rdf:type[@rdf:resource = 'http://rdaregistry.info/Elements/c/C10006']]"
        mode="eProps">
        <xsl:param name="eIri" select="@rdf:about"/>
        <!-- TO DO:
            Connect or otherwise make apparent multiple EM(I) sets per W -->
        <h2>
            <span class="expression">
                <xsl:text>Statements on an </xsl:text>
                <a href="http://rdaregistry.info/Elements/c/C10006">
                    <xsl:text>RDA Expression</xsl:text>
                </a>
                <xsl:text> Resource</xsl:text>
            </span>
        </h2>
        <!-- ul to ul code block identical for W, E, M, and I -->
        <ul>
            <xsl:for-each select="*[@rdf:resource]">
                <li>
                    <xsl:call-template name="property">
                        <xsl:with-param name="p" select="."/>
                    </xsl:call-template>
                    <xsl:value-of select="$break"/>
                    <!-- BIG QUESTION / TO DO:
                        Get any associated rdfs:label values for hot text, to do this 
                        [Call template resourceLabel here and below?] -->
                    <xsl:call-template name="val_resource">
                        <xsl:with-param name="r" select="@rdf:resource"/>
                    </xsl:call-template>
                </li>
            </xsl:for-each>
            <xsl:for-each select="*[not(@rdf:resource | @rdf:nodeID)]">
                <li>
                    <xsl:call-template name="property">
                        <xsl:with-param name="p" select="."/>
                    </xsl:call-template>
                    <xsl:value-of select="$break"/>
                    <xsl:call-template name="val_literal">
                        <xsl:with-param name="l" select="."/>
                    </xsl:call-template>
                </li>
            </xsl:for-each>
            <!-- TO DO:
                Output bnodes here and/or in named template-->
        </ul>
        <xsl:apply-templates
            select="../rdf:Description[rdf:type[@rdf:resource = 'http://rdaregistry.info/Elements/c/C10007']][rdam:P30139/@rdf:resource = $eIri]"
            mode="mProps"/>
    </xsl:template>
    <!-- What if I didn't add the predicate for rdf:type? Seems redundant -->
    <xsl:template
        match="rdf:Description[rdf:type[@rdf:resource = 'http://rdaregistry.info/Elements/c/C10007']]"
        mode="mProps">
        <xsl:param name="mIri" select="@rdf:about"/>
        <h2>
            <span class="manifestation">
                <xsl:text>Statements on an </xsl:text>
                <a href="http://rdaregistry.info/Elements/c/C10007">
                    <xsl:text>RDA Manifestation</xsl:text>
                </a>
                <xsl:text> Resource</xsl:text>
            </span>
        </h2>
        <!-- ul to ul code block identical for W, E, M, and I -->
        <ul>
            <xsl:for-each select="*[@rdf:resource]">
                <li>
                    <xsl:call-template name="property">
                        <xsl:with-param name="p" select="."/>
                    </xsl:call-template>
                    <xsl:value-of select="$break"/>
                    <!-- BIG QUESTION / TO DO:
                        Get any associated rdfs:label values for hot text, to do this 
                        [Call template resourceLabel here and below?] -->
                    <xsl:call-template name="val_resource">
                        <xsl:with-param name="r" select="@rdf:resource"/>
                    </xsl:call-template>
                </li>
            </xsl:for-each>
            <xsl:for-each select="*[not(@rdf:resource | @rdf:nodeID)]">
                <li>
                    <xsl:call-template name="property">
                        <xsl:with-param name="p" select="."/>
                    </xsl:call-template>
                    <xsl:value-of select="$break"/>
                    <xsl:call-template name="val_literal">
                        <xsl:with-param name="l" select="."/>
                    </xsl:call-template>
                </li>
            </xsl:for-each>
            <!-- TO DO:
                Output bnodes here and/or in named template-->
        </ul>
        <xsl:apply-templates
            select="../rdf:Description[rdf:type[@rdf:resource = 'http://rdaregistry.info/Elements/c/C10003']][rdai:P40049/@rdf:resource = $mIri]"
            mode="iProps"/>
    </xsl:template>
    <xsl:template
        match="rdf:Description[rdf:type[@rdf:resource = 'http://rdaregistry.info/Elements/c/C10003']]"
        mode="iProps">
        <h2>
            <span class="item">
                <xsl:text>Statements on an </xsl:text>
                <a href="http://rdaregistry.info/Elements/c/C10003">
                    <xsl:text>RDA Item</xsl:text>
                </a>
                <xsl:text> Resource</xsl:text>
            </span>
        </h2>
        <!-- ul to ul code block identical for W, E, M, and I -->
        <ul>
            <xsl:for-each select="*[@rdf:resource]">
                <li>
                    <xsl:call-template name="property">
                        <xsl:with-param name="p" select="."/>
                    </xsl:call-template>
                    <xsl:value-of select="$break"/>
                    <!-- BIG QUESTION / TO DO:
                        Get any associated rdfs:label values for hot text, to do this 
                        [Call template resourceLabel here and below?] -->
                    <xsl:call-template name="val_resource">
                        <xsl:with-param name="r" select="@rdf:resource"/>
                    </xsl:call-template>
                </li>
            </xsl:for-each>
            <xsl:for-each select="*[not(@rdf:resource | @rdf:nodeID)]">
                <li>
                    <xsl:call-template name="property">
                        <xsl:with-param name="p" select="."/>
                    </xsl:call-template>
                    <xsl:value-of select="$break"/>
                    <xsl:call-template name="val_literal">
                        <xsl:with-param name="l" select="."/>
                    </xsl:call-template>
                </li>
            </xsl:for-each>
            <!-- TO DO:
                Output bnodes here and/or in named template-->
        </ul>
    </xsl:template>
</xsl:stylesheet>
