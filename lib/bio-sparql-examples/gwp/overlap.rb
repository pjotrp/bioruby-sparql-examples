require 'bio-sparql-examples/gwp/db'

module BioSparql
  module GWP
    module Overlap

      def Overlap::query_clusters

        sparql = DB.new()

        result = sparql.query(<<QUERY

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
QUERY
)
        result.each_solution do | res |
          p res[:cluster].to_s
        end
      end
    end
  end
end

