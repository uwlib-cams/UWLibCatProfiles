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
    <!-- New thing here; outputting HTML5 and not XHTML -->
    <xsl:output method="html" version="5"/>
    <xsl:key name="rdaProKey" match="xpf:array[@key = 'propertyTemplates']/xpf:map"
        use="tokenize(xpf:string[@key = 'propertyURI'], '/')[last()]"/>
    <!-- I still want to try using the JSON profile
        Try:
        fn:json-to-xml
        => to chain functions -->
    <xsl:variable name="rdaPro"
        select="document('https://raw.githubusercontent.com/CECSpecialistI/UWLibCatProfiles/master/xml/WAU.profile.RDA.xml')"/>
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
        <!-- This + the below xsl:template element essentially act like a for-each correct? -->
        <xsl:apply-templates
            select="rdf:Description[rdf:type[@rdf:resource = 'http://rdaregistry.info/Elements/c/C10001']]"
            mode="wemiTop"/>
    </xsl:template>
    <xsl:template
        match="rdf:Description[rdf:type[@rdf:resource = 'http://rdaregistry.info/Elements/c/C10001']]"
        mode="wemiTop">
        <h1>
            <xsl:text>RDA WORK: </xsl:text>
            <xsl:value-of select="rdaw:P10331"/>
        </h1>
        <ul>
            <xsl:apply-templates
                select="rdf:Description[rdf:type[@rdf:resource = 'http://rdaregistry.info/Elements/c/C10001']]"
                mode="wProps"/>
        </ul>
    </xsl:template>
    <xsl:template
        match="rdf:Description[rdf:type[@rdf:resource = 'http://rdaregistry.info/Elements/c/C10001']]"
        mode="wProps">
        <!-- First, properties with IRI values -->
        <!-- Why for-each-group?
            Because I need to account for repeatable props; this will allow me to count group members and output multiple/single values accordingly
            Is there a better way? -->
        <!-- *Attempting* to group by elements with rdf:resource attrs with the same name -->
        <xsl:for-each-group select="*[@rdf:resource]" group-by="*[@rdf:resource]">
            <xsl:for-each select="current-group()">
                <li>
                    <xsl:text>TEST: PROP(s) WITH IRI VAL HERE</xsl:text>
                </li>
                <!-- Attempting to work with non-repeating props
                    but am I using count correctly here?
                <xsl:if test="count(current-group()) = 1">
                    <li>
                        <xsl:choose>
                            <xsl:when
                                test="key('rdaProKey', local-name(.), $rdaPro)">
                                <xsl:value-of
                                    select="key('rdaProKey', local-name(.), $rdaPro)/xpf:string[@key = 'propertyLabel']"
                                />
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="local-name(.)"/>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:text>: </xsl:text>
                        <xsl:value-of select="."/>
                        output lang tag or datatype here
                    </li>
                </xsl:if> -->
            </xsl:for-each>
        </xsl:for-each-group>
    </xsl:template>
</xsl:stylesheet>
