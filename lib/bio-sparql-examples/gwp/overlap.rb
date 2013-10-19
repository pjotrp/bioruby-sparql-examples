require 'bio-sparql-examples/gwp/db'

module BioSparql
  module GWP
    module Overlap

      def Overlap::query options = {:filter => "FILTER (?species!=?hspecies || ?source!=?hsource)" }

        sparql = DB.new()

        result = sparql.query(<<QUERY

SELECT ?species ?source ?hspecies ?hsource ?cluster ?hcluster WHERE
{
      ?fam :clusterid ?cluster ;
        :is_pos_sel ?is_pos ;
        :species ?species ;
        :source ?source .
      ?seq a :blast_match ; 
        :cluster ?cluster ;
        :homolog_species ?hspecies ;
        rdf:label ?gene ;
        # :homolog_gene "Minc_Contig9_302" ;
        :homolog_gene ?hgene .
      OPTIONAL { ?seq :homolog_source ?hsource } .
      ?seq :homolog_cluster ?hcluster .
      ?hcluster :is_pos_sel true .
 
        #{options[:filter]} .
}

QUERY
)
        count = {}
        all = {}
        group_clusters = {}
        result.each_solution do | res |
          id = [:species,:source,:hspecies,:hsource].map{ |id| res[id] }.join("\t")
          puts [:species,:source,:hspecies,:hsource,:cluster,:hcluster].map { |id| res[id] }.join("\t")
          count[id] ||= 0
          count[id] += 1
          group_clusters[id] ||= {}
          cluster = res[:cluster].to_s
          group_clusters[id][cluster] ||= 0
          group_clusters[id][cluster] += 1
          h = res.to_hash
          h.delete(:cluster)
          all[id] ||= h
        end
        all.each do |id,rec|
          total = group_clusters[id].keys.size
          Pretty::print rec
          print total,"\t",count[id],"\n"
        end
        # Default filter
        # Mi  CDS Mi  DNA 1762 includes all variants
      end
    end
  end
end

