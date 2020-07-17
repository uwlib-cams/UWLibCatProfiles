from datetime import date
import os
import rdflib
from rdflib import *

# pull RDFXML files from trellis, put them into local folder
if not os.path.exists('export_xml'):# creates xml directory
    print('Generating directories')
    os.makedirs('export_xml')

# initialize a graph, load in UW trellis repo, and extract record URIs
print("...\nRetrieving graph URIs", flush=True)
graph = Graph()
LDP = Namespace('http://www.w3.org/ns/ldp#')
rdac = Namespace('http://rdaregistry.info/Elements/c/')
rdf = Namespace('http://www.w3.org/1999/02/22-rdf-syntax-ns#')
graph.bind('LDP', LDP)
graph.bind('rdac', rdac)
graph.bind('rdf', rdf)
graph.load('https://trellis.sinopia.io/repository/washington', format='turtle')
URIS = [] # list for record uris
for o in graph.objects(subject=None,predicate=LDP.contains):#records are described in the parent repo using ldp.contains
    URIS.append(o)

# lists for RDA entities
workList = []
expressionList = []
manifestationList = []
itemList = []

print(f"...\nLocating works")
for uri in URIS:
    fileGraph = Graph()
    fileGraph.load(uri,format='turtle')
    for work in fileGraph.subjects(RDF.type, rdac.C10001): # looks for records typed as an RDA work
        workList.append(work) # adds to work list

print(f"...\nLocating expressions")
for uri in URIS:
    fileGraph = Graph()
    fileGraph.load(uri,format='turtle')
    for expression in fileGraph.subjects(RDF.type, rdac.C10006): # looks for records typed as an RDA expression
        expressionList.append(expression) # adds to expression list

print(f"...\nLocating manifestations")
for uri in URIS:
    fileGraph = Graph()
    fileGraph.load(uri,format='turtle')
    for manifestation in fileGraph.subjects(RDF.type, rdac.C10007): # looks for records typed as an RDA manifestation
        manifestationList.append(manifestation) # adds to manifestation list

print(f"...\nLocating items")
for uri in URIS:
    fileGraph = Graph()
    fileGraph.load(uri,format='turtle')
    for item in fileGraph.subjects(RDF.type, rdac.C10003): # looks for records typed as an RDA item
        itemList.append(item) # adds to item list

today = date.today()
currentDate = f"{today.year}_{today.month}_{today.day}"

if len(workList) == 0:
    print("No works found.")

elif len(workList) >= 1:
    if not os.path.exists(f'{currentDate}'):
        os.system(f'mkdir {currentDate}')

    if not os.path.exists(f'{currentDate}/work'):
        print("...\nCreating work directory")
        os.system(f'mkdir {currentDate}/work')

    for work in workList:
        workGraph = Graph()
        workGraph.load(work, format='turtle') # load records from work list into a new graph
        label = work.split('/')[-1] # selects just the identifier
        workGraph.serialize(destination=f'{currentDate}/work/' + label + '.xml', format="xml") # serializes in xml

if len(expressionList) == 0:
    print("No expressions found.")

elif len(expressionList) >= 1:
    if not os.path.exists(f'{currentDate}/expression'):
        print("...\nCreating expression directory")
        os.system(f'mkdir {currentDate}/expression')

    for expression in expressionList:
        expressionGraph = Graph()
        expressionGraph.load(expression, format='turtle')
        label = expression.split('/')[-1]
        expressionGraph.serialize(destination=f'{currentDate}/expression/' + label + '.xml', format="xml")

if len(manifestationList) == 0:
    print("No manifestations found.")

elif len(manifestationList) >= 1:
    if not os.path.exists(f'{currentDate}/manifestation'):
        print("...\nCreating manifestation directory")
        os.system(f'mkdir {currentDate}/manifestation')

    for manifestation in manifestationList:
        manifestationGraph = Graph()
        manifestationGraph.load(manifestation, format='turtle')
        label = manifestation.split('/')[-1]
        manifestationGraph.serialize(destination=f'{currentDate}/manifestation/' + label + '.xml', format="xml")

if len(itemList) == 0:
    print("No items found.")

elif len(itemList) >= 1:
    if not os.path.exists(f'{currentDate}/item'):
        print("...\nCreating item directory")
        os.system(f'mkdir {currentDate}/item')

    for item in itemList:
        itemGraph = Graph()
        itemGraph.load(item, format='turtle')
        label = item.split('/')[-1]
        itemGraph.serialize(destination=f'{currentDate}/item/' + label + '.xml', format="xml")

print("Finished.")
