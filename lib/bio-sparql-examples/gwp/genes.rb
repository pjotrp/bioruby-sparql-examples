require 'bio-sparql-examples/gwp/db'

module BioSparql
  module GWP
    module Genes

      # For every species list source, cluster and named source and homolog
      # genes. This is very similar to Overlap but I did not want to mix
      # anymore functionality in there
      def Genes::query options = {:is_pos_sel => true, :filter => "FILTER (?species!=?hspecies || ?source!=?hsource)" }
        logger = Bio::Log::LoggerPlus['bio-sparql-examples']

        sparql = DB.new()

        is_pos_sel = if options[:is_pos_sel] 
          """
      OPTIONAL { ?seq :homolog_source ?hsource } .
      ?seq :homolog_cluster ?hcluster .
      ?hcluster :is_pos_sel true .
          """
        else
          ""
        end

        combine_sources = if options[:combine_sources]
                            ""
                          else
                            "?fam :source ?source ."
                          end

        filter2 = "FILTER (?species = \"Mi\")"
        result = sparql.query(<<QUERY

SELECT ?species ?source ?hspecies ?hsource ?gene ?hcluster ?hgene ?hpos ?hdescr WHERE
{
      ?fam :clusterid ?cluster ;
        :is_pos_sel true ;
        :species ?species .
      # #{is_pos_sel}
      ?seq a :blast_match ; 
        :cluster ?cluster ;
        :homolog_species ?hspecies ;
        rdf:label ?gene ;
        # :homolog_gene "Minc_Contig9_302" ;
        :homolog_gene ?hgene ;
        :descr ?hdescr .
      # OPTIONAL {?seq :homolog_cluster ?hcluster } .
      # ?seq :homolog_cluster ?hcluster .
      # ?hcluster :is_pos_sel true .

      #{combine_sources} 
      # #{options[:filter]} .
      # #{filter2 } .
} LIMIT 100

QUERY
).each { | rec | Pretty::println rec }
      end
    end
  end
end

