# Some notes on XSL scripts
- Generating format-specific profiles from the UW RDA profile (validate format-specific profiles with Sinopia, not UW, schema)
   - jsonxml2monographs.xsl
   - jsonxml2dvdVideo.xsl
   - jsonxml2etd.xsl
- json2xml.xsl / xml2json.xsl: 
   - For use in workflow to create format-specific profiles
   - UW RDA profile converted to XML for generation of format-specific profile(s)
   - Format-specific profile(s) output from XSLT must be converted to JSON for use in Sinopia environment
   - Conversion using `json-to-xml` and `xml-to-json` functions defined in the [XQuery, XPath, and XSLT Functions and Operators Namespace Document](https://www.w3.org/2005/xpath-functions/)

