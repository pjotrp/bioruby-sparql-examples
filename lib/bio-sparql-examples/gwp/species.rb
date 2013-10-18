require 'bio-sparql-examples/gwp/db'

module BioSparql
  module GWP
    module Species
      include GWP::DB

      def Species::query

        sparql = SPARQL::Client.new(SPARQL_ENDPOINT, { "soft-limit" => "-1", :method => 'get' })

        query =<<QTEXT

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
        result = sparql.query(NS+query)
        result.each_solution do | res |
          p res[:cluster].to_s
        end
      end
    end
  end
end

