<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/2005/xpath-functions" 
    xmlns:j="http://www.w3.org/2005/xpath-functions" exclude-result-prefixes="j" version="3.0">
    <xsl:output indent="yes"/>
    <xsl:strip-space elements="*"/>
    <xsl:template match="/">
        <j:map xmlns="http://www.w3.org/2005/xpath-functions">
            <xsl:apply-templates select="j:map/j:map[@key = 'Profile']"/>
        </j:map>
    </xsl:template>
    <xsl:template match="j:map[@key = 'Profile']">
        <j:map key="Profile">
            <j:string key="author">Crystal Clements (cec23@uw.edu)</j:string>
            <j:string key="date">2019-05-14</j:string>
            <j:string key="description">RDA profile for describing monographs</j:string>
            <j:string key="id">profile:monograph</j:string>
            <j:string key="title">WAU profile RDA monograph</j:string>
            <j:string key="schema"
                >https://ld4p.github.io/sinopia/schemas/0.1.0/profile.json</j:string>
            <j:array key="resourceTemplates">
                <xsl:apply-templates select="j:array[@key = 'resourceTemplates']"/>
            </j:array>
        </j:map>
    </xsl:template>
    <xsl:template match="j:array[@key = 'resourceTemplates']">
        <xsl:for-each select="j:map">
            <j:map>
                <j:string key="id">
                    <xsl:value-of select="concat(j:string[@key = 'id'], ':monograph')"/>
                </j:string>
                <j:string key="resourceURI">
                    <xsl:value-of select="j:string[@key = 'resourceURI']"/>
                </j:string>
                <j:string key="resourceLabel">
                    <xsl:value-of
                        select="concat(normalize-space(j:string[@key = 'resourceLabel']), ' for monographs')"
                    />
                </j:string>
                <j:string key="author">
                    <xsl:value-of select="normalize-space(j:string[@key = 'author'])"/>
                </j:string>
                <j:string key="date">
                    <xsl:value-of select="j:string[@key = 'date']"/>
                </j:string>
                <j:string key="schema">
                    <xsl:value-of select="j:string[@key = 'schema']"/>
                </j:string>
                <j:array key="propertyTemplates">
                    <xsl:apply-templates select="j:array[@key = 'propertyTemplates']"/>
                </j:array>
            </j:map>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="j:array[@key = 'propertyTemplates']">
        <xsl:for-each select="j:map">
            <xsl:if test="j:array[@key = 'usedInProfile']/j:string = 'monograph'">
                <j:map>
                    <j:string key="propertyLabel">
                        <xsl:value-of select="normalize-space(j:string[@key = 'propertyLabel'])"/>
                    </j:string>
                    <j:string key="propertyURI">
                        <xsl:value-of select="j:string[@key = 'propertyURI']"/>
                    </j:string>
                    <j:string key="mandatory">
                        <xsl:value-of select="j:string[@key = 'mandatory']"/>
                    </j:string>
                    <j:string key="repeatable">
                        <xsl:value-of select="j:string[@key = 'repeatable']"/>
                    </j:string>
                    <j:string key="type">
                        <xsl:value-of select="j:string[@key = 'type']"/>
                    </j:string>
                    <j:string key="remark">
                        <xsl:value-of select="j:string[@key = 'remark']"/>
                    </j:string>
                    <xsl:if test="j:map[@key='valueConstraint']/descendant::text()">
                    <j:map key="valueConstraint">
                        <xsl:apply-templates select="j:map[@key = 'valueConstraint']"/>
                    </j:map>
                    </xsl:if>
                </j:map>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="j:map[@key = 'valueConstraint']">
        <xsl:if test="j:array[@key='valueTemplateRefs']/descendant::text()">
            <xsl:copy-of select="j:array[@key='valueTemplateRefs']"></xsl:copy-of>
        </xsl:if>
        <xsl:if test="j:array[@key = 'useValuesFrom']/descendant::text()">
            <xsl:copy-of select="j:array[@key = 'useValuesFrom']"></xsl:copy-of>
        </xsl:if>
        <xsl:if test="j:map[@key='valueDataType']/descendant::text()">
            <xsl:copy-of select="j:map[@key='valueDataType']"/>
        </xsl:if>
        <xsl:if test="j:array[@key='defaults']/descendant::text()">
            <xsl:copy-of select="j:array[@key='defaults']"></xsl:copy-of>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>
