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

        result = sparql.query(<<QUERY

SELECT ?species ?source ?hspecies ?hsource ?cluster ?gene ?hcluster ?hgene ?hpos ?hdescr WHERE
{
      # Find all clusters under pos. sel.
      ?fam :clusterid ?cluster ;
        :is_pos_sel true ;
        :species ?species ;
        :source ?source .

      # Match all gene sequences
      ?seq a :blast_match ; 
        :cluster ?cluster ;
        :homolog_species ?hspecies ;
        # rdf:label ?gene ;
        # :homolog_gene "Minc_Contig9_302" ;
        :homolog_gene ?hgene .
      OPTIONAL { ?seq :descr ?hdescr } .

      FILTER (?species = "Mi" ) . # for testing

      # Optional fields
      OPTIONAL { ?seq :homolog_cluster ?hcluster .
                 ?hcluster :is_pos_sel ?hpos } .

      # #{combine_sources} 
      # #{is_pos_sel}
      #{options[:filter]} .
} 

QUERY
).each { | rec | Pretty::println rec }
      end
    end
  end
end

