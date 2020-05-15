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
    <xsl:output method="html" version="5"/>
    <xsl:key name="rdaProKey" match="xpf:array[@key = 'propertyTemplates']/xpf:map"
        use="xpf:string[@key = 'propertyURI']"/>
    <!-- I still want to try using the JSON profile
        Try:
        fn:json-to-xml
        => to chain functions -->
    <xsl:variable name="rdaPro"
        select="document('https://raw.githubusercontent.com/CECSpecialistI/UWLibCatProfiles/master/xml/WAU.profile.RDA.xml')"/>
    <xsl:template match="/">
        <!-- New thing here; outputting HTML5 and not XHTML -->
        <html xmlns="http://www.w3.org/1999/xhtml" version="5">
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
        />
    </xsl:template>
    <xsl:template
        match="rdf:Description[rdf:type[@rdf:resource = 'http://rdaregistry.info/Elements/c/C10001']]">
        <h1>
            <xsl:text>RDA WORK &gt; </xsl:text>
            <!-- TO TO 2020-05-14:
                Fix fn:key
                ...currently returning "rdf:Description" (?)
                Using [position() = 1] because if I don't, error message says that
                sequence of more than one item is not allowed as first arg of fn:document-uri -->
            <xsl:if test="rdaw:P10223/node()">
                <xsl:choose>
                    <xsl:when
                        test="key('rdaProKey', document-uri(rdaw:P10223[position() = 1]), $rdaPro)">
                        <xsl:value-of
                            select="key('rdaProKey', document-uri(rdaw:P10223[position() = 1]), $rdaPro)/xpf:string[@key = 'propertyLabel']"
                        />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="name(.)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
            <xsl:text> &gt; </xsl:text>
            <!-- Ok this is returning prefTitle value, so now need to output lang tag -->
            <xsl:value-of select="rdaw:P10223"/>
        </h1>
        <!-- Up next is cycle through all props at the Work level,
            then jump down to the Expression level and cycle through, 
            then M and I,
            and at some point bnodes,
            and at some point resources with labels, etc. which were used in the WEMI -->
    </xsl:template>
</xsl:stylesheet>
