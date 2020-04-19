#requires rapper
#requires saxon
#requires sinFuseki-2-html.xsl (in scripts directory of Github repo CECSpecialist/UWLibCatProfiles)

#directions
#    1. enter path to fuseki below
#    2. enter path tp saxon jar file below
#    3. enter path to 

#enter path to fuseki below below, in $fus
fus=http://localhost:8008/fuseki0
#enter path to saxon jar file below, in $sax
sax=/Applications/SaxonHE9-9-1-5J
#enter path to sinFuseki-2-html.xsl, in $xsl
xsl=https://raw.githubusercontent.com/CECSpecialistI/UWLibCatProfiles/master/scripts
#xsl=/Users/theodore/Desktop/ld4p2/profiles/uwprofiles-14/UWLibCatProfiles/scripts

file=fuseki-html-$(date +"%F").html

#below is the little baby script
rapper -i turtle -o rdfxml $fus/sinopiaExport20200329 | java -jar $sax/saxon9he.jar -s:- -xsl:$xsl/sinFuseki-2-html.xsl > ./$file