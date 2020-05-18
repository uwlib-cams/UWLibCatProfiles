<?xml version="1.0" encoding="UTF-8"?>
<!-- TO-DO:
    The rdfLib namespaces are junk
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
    <!-- TO DO:
        Output to separate format docs based on sinvoc:hasResourceTemplate -->
    <xsl:template match="/">
        <html xmlns="http://www.w3.org/1999/xhtml">
            <head>
                <title>TEST</title>
                <link href="htmlData.css" rel="stylesheet" type="text/css"/>
            </head>
            <body>
                <xsl:apply-templates select="rdf:RDF"/>
            </body>
        </html>
    </xsl:template>
    <xsl:template match="rdf:RDF">
        <xsl:apply-templates
            select="rdf:Description[rdf:type[@rdf:resource = 'http://rdaregistry.info/Elements/c/C10001']]"
            mode="wemiTop"/>
    </xsl:template>
    <xsl:template
        match="rdf:Description[rdf:type[@rdf:resource = 'http://rdaregistry.info/Elements/c/C10001']]"
        mode="wemiTop">
        <xsl:choose>
            <!-- This seems a clumsy way to do this but we don't want certain sets -->
            <xsl:when test="rdaw:P10331[text() != '' and text() != 'test' and text() != 'void']">
                <h1>
                    <xsl:text>Description Set: </xsl:text>
                    <xsl:value-of select="rdaw:P10331"/>
                </h1>
                <xsl:apply-templates select="." mode="wProps"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template
        match="rdf:Description[rdf:type[@rdf:resource = 'http://rdaregistry.info/Elements/c/C10001']]"
        mode="wProps">
        <h2>
            <xsl:text>Statements on the  </xsl:text>
            <a href="http://rdaregistry.info/Elements/c/C10001">
                <xsl:text>RDA Work</xsl:text>
            </a>
            <xsl:text> Resource</xsl:text>
        </h2>
        <ul>
            <xsl:for-each select="*[@rdf:resource]">
                <li>
                    <xsl:call-template name="property">
                        <xsl:with-param name="p" select="."/>
                    </xsl:call-template>
                    <strong>
                        <xsl:text>  |  </xsl:text>
                    </strong>
                    <!-- BIG QUESTION / TO DO:
                        Get any associated rdfs:label values for hot text, to do this 
                        [Call template resourceLabel here and below?] -->
                    <a href="{@rdf:resource}">
                        <xsl:value-of select="@rdf:resource"/>
                    </a>
                </li>
            </xsl:for-each>
            <!-- Excluding sinvoc:hasResourceTemplate doesn't seem to be working here -->
            <xsl:for-each
                select="*[not(sinvoc:hasResourceTemplate)][not(@rdf:resource | @rdf:nodeID)]">
                <li>
                    <xsl:call-template name="property">
                        <xsl:with-param name="p" select="."/>
                    </xsl:call-template>
                    <strong>
                        <xsl:text>  |  </xsl:text>
                    </strong>
                    <xsl:value-of select="."/>
                    <xsl:choose>
                        <!-- QUESTION:
                            Are their ever empty xml:lang attributes? If so this needs changing -->
                        <xsl:when test=".[@xml:lang]">
                            <!-- QUESTION:
                                Here and elsewhere using strong, em tags; better to use CSS?
                                Is em tag html5 compliant? Etc. -->
                            <strong>
                                <xsl:text>  |  </xsl:text>
                            </strong>
                            <em>
                                <xsl:text>Language tag value: "</xsl:text>
                                <xsl:value-of select="@xml:lang"/>
                                <xsl:text>"</xsl:text>
                            </em>
                        </xsl:when>
                        <xsl:otherwise>
                            <strong>
                                <xsl:text>  |  </xsl:text>
                            </strong>
                            <em>
                                <xsl:text>No language tag</xsl:text>
                            </em>
                        </xsl:otherwise>
                    </xsl:choose>
                </li>
            </xsl:for-each>
            <!-- TO DO:
                Output bnodes here and/or in named template-->
        </ul>
        <!-- BIG QUESTION + TO DO:
            Get to the E (and so, later, get to the M and I -->
        <xsl:apply-templates
            select="rdf:Description[rdf:type[@rdf:resource = 'http://rdaregistry.info/Elements/c/C10006']]"
            mode="eProps">
            <!-- This param won't give me the correct @about value because it is getting it's context from the apply-templates > select above
                But how to pass our work IRI (@about) to the next template? -->
            <xsl:with-param name="wIri" select="@rdf:about"/>
        </xsl:apply-templates>
    </xsl:template>
    <!-- SEE BIG QUESTION ABOVE -->
    <xsl:template
        match="rdf:Description[rdf:type[@rdf:resource = 'http://rdaregistry.info/Elements/c/C10006']]"
        mode="eProps">
        <xsl:param name="wIri"/>
        <xsl:for-each select=".[rdae:P20231/@rdf:resource = $wIri]">
            <h2>
                <xsl:text>Statements on the  </xsl:text>
                <a href="http://rdaregistry.info/Elements/c/C10006">
                    <xsl:text>RDA Expression</xsl:text>
                </a>
                <xsl:text> Resource</xsl:text>
            </h2>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
