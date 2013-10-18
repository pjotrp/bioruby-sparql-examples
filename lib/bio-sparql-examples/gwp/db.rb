module BioSparql
  module GWP
    module DB
      SPARQL_ENDPOINT = "http://localhost:8000/sparql/?soft-limit=-1"

      NS =<<NAMESPACE
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
prefix dc: <http://purl.org/dc/elements/1.1/>
prefix hgnc: <http://identifiers.org/hgnc.symbol/>
prefix doi: <http://dx.doi.org/>
prefix : <http://biobeat.org/rdf/ns#> 
NAMESPACE

    end
  end
end
