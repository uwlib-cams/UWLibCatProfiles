<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"    xmlns:pro="http://www.w3.org/2005/xpath-functions" version="3.0">
  <!--  This transform requires 2 inputs
        1) WAU.profile.RDA.xml (stored in a variable) > see note below
        2) fuseki data (use as input in oxygen transformation scenario)
        -->
  <!-- Don't yet understand the use attr of xsl:key -->
  <xsl:key name="rda" match="pro:array[@key = 'propertyTemplates']/pro:map" use="tokenize(pro:string[@key = 'propertyURI'], '/')[last()]"/>
  <!-- For var $profile, why not use the json profile via `document(json-to-xml(https...))``?
      Would the processor have to convert json to json-in-xml every time the var appears below? -->
  <xsl:variable name="profile" select="document('https://raw.githubusercontent.com/CECSpecialistI/UWLibCatProfiles/master/xml/WAU.profile.RDA.xml')"/>
  <xsl:template match="/">
    <html>
      <xsl:apply-templates select="rdf:RDF"/>
    </html>
  </xsl:template>
  <xsl:template match="rdf:RDF">
    <head/>
    <body>
      <!-- **grouping here** -->
      <xsl:for-each-group select="rdf:Description" group-by="@rdf:about">
        <h3>
          <font color="red">Thing being described: </font>
          <xsl:value-of select="current-grouping-key()"/>
        </h3>
        <xsl:for-each select="current-group()/*">
          <p>
            <i>
              <xsl:choose>
                <!-- fn:key
                      I don't understand what the last argument is/does in the key function arguments below
                        is this the 'top' argument?
                      note use of fn:local-name -->
                <xsl:when test="key('rda', local-name(.), $profile)">
                  <xsl:value-of select="key('rda', local-name(.), $profile)/pro:string[@key = 'propertyLabel']"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="local-name(.)"/>
                </xsl:otherwise>
              </xsl:choose>
            </i>
            <xsl:text>: </xsl:text>
            <xsl:choose>
              <!-- IRIs should be hyperlinks -->
              <xsl:when test="@rdf:resource">
                <xsl:value-of select="@rdf:resource"/>
              </xsl:when>
              <!-- Some way to make the bnode values even just a little shorter in the output? -->
              <xsl:when test="@rdf:nodeID">
                <xsl:value-of select="@rdf:nodeID"/>
              </xsl:when>
              <xsl:otherwise>
                <!-- I think that this would be where literals come through. We want to get lang tags. -->
                <xsl:value-of select="."/>
              </xsl:otherwise>
            </xsl:choose>
          </p>
        </xsl:for-each>
        <br/>
      </xsl:for-each-group>
      <!-- Okay, need to collect these nodes in the above grouping
            Lots to think about for grouping -->
      <xsl:for-each-group select="rdf:Description" group-by="@rdf:nodeID">
        <h2>Thing being described: <xsl:value-of select="current-grouping-key()"/>
      </h2>
      <xsl:for-each select="current-group()/*">
        <p>
          <i>
            <xsl:value-of select="local-name(.)"/>
          </i>
          <xsl:text>: </xsl:text>
          <xsl:choose>
            <xsl:when test="@rdf:resource">
              <xsl:value-of select="@rdf:resource"/>
            </xsl:when>
            <xsl:when test="@rdf:nodeID">
              <xsl:value-of select="@rdf:nodeID"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="."/>
            </xsl:otherwise>
          </xsl:choose>
        </p>
      </xsl:for-each>
      <br/>
    </xsl:for-each-group>
  </body>
</xsl:template>
</xsl:stylesheet>
