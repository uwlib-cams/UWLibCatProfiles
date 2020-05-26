<?xml version="1.0" encoding="UTF-8"?>
<!-- NOTES:
    https://hackmd.io/@ries07/r1W0h6coI
    -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    exclude-result-prefixes="xs math"
    version="3.0">
    <xsl:param name="source"/>
    <xsl:template match="/">
        <!-- Now trying messing with var names: Perhaps spaces in filenames prevented output?
            So far changed dvdVideo from the original naming pattern -->
        <xsl:for-each
            select="('dvdVideo', 'eBook', 'etd', 'graphic', 'eGraphic', 'map', 'eMap', 'monograph', 'serial', 'eSerial', 'soundRecording')">
            <xsl:variable name="format" select="."/>
            <!-- I believe that the source-node option is the sticking point
                Using the var alone returns error that this is an atomic value.
                So far I've tried:
                    * Quotes/no quotes in oXygen scenario param setting
                        Currently using ''
                    * Wrapping $source in doc()
                        This is the closest I've come to success I believe, error here says I/O error reported by XML parser processing file.
                        Tried to solve this changing .rdf file extension to .xml but no luck
                    * Now trying using fn:doc (w/namespace) plus filename as string (moving filename to current folder -->
            <xsl:variable name="html-transform">
                
                <xsl:sequence
                    select="
                    let $t := transform(
                    map {
                    'stylesheet-location': 'rdfxml-to-html5-core.xsl',
                    'source-node': doc('2020-05-14.rdf'),
                    'stylesheet-params': map{QName('https://github.com/briesenberg07/bmrLIS/', 'formatTitle'): $format}
                    })
                    return $t?output"
                />
            </xsl:variable>
            <xsl:result-document href="../html/review{$formatTitle}.html">
                <xsl:sequence select="$html-transform"/>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
