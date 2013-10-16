module BioSparql
  module GWP
    module Overlap
      SPARQL_ENDPOINT = "http://localhost:8000/sparql/?soft-limit=-1"
      # SPARQL_ENDPOINT = "http://localhost:8000/sparql/"

      def Overlap::query_clusters

        sparql = SPARQL::Client.new(SPARQL_ENDPOINT, { "soft-limit" => "-1", :method => 'get' })

        query =<<QTEXT
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
prefix dc: <http://purl.org/dc/elements/1.1/>
prefix hgnc: <http://identifiers.org/hgnc.symbol/>
prefix doi: <http://dx.doi.org/>
prefix : <http://biobeat.org/rdf/ns#> 


SELECT ?species ?source ?hspecies ?hsource ?cluster ?hgene WHERE # ?cluster ?fam WHERE 
{
      ?fam :clusterid ?cluster ;
        :is_pos_sel ?is_pos ;
        :species ?species ;
        :source ?source .
      ?seq a :blast_match ; 
        :cluster ?cluster ;
        :homolog_species ?hspecies ;
        :homolog_source ?hsource ;
        rdf:label ?gene ;
        :homolog_gene "Minc_Contig9_302" ;
        :homolog_gene ?hgene .

    FILTER (CONTAINS(?species,"Mi") && CONTAINS(?hspecies,"Mi") && CONTAINS(?source,"CDS") && CONTAINS(?hsource,"DNA") ) .
}
QTEXT
        result = sparql.query(query)
        result.each_solution do | res |
          p res[:cluster].to_s
        end
      end
    end
  end
end

