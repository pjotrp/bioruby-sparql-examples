require 'bio-sparql-examples/gwp/db'

module BioSparql
  module GWP
    module Homologs

      # Uses :is_pos_sel, :nr, :species
      def Homologs::query options = {:is_pos_sel => false , :filter => "FILTER (?species!=?hspecies)" }
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

        homologs = if options[:species]
                     """
                         ?seq :homolog_cluster ?hcluster .
                         ?seq :homolog_source ?hsource .
                     """
                   elsif options[:nr]
                     """
                         MINUS { ?seq :homolog_cluster ?hcluster } .
                     """
                   else
                     ""
                   end


        result = sparql.query(<<QUERY

        SELECT ?species ?source ?cluster ?hgene WHERE {
              ?fam :clusterid ?cluster ;
                :is_pos_sel ?is_pos ;
                :species ?species ;
                :source ?source .
              ?seq a :blast_match ; 
                :cluster ?cluster ;
                :homolog_species ?hspecies ;
                :homolog_gene ?hgene .
              #{homologs}
              #{options[:filter]} .
        } 
QUERY
)
        count = {}
        all = {}
        group_clusters = {}
        result.each_solution do | res |
          id = [:species,:source].map{ |id| res[id] }.join("\t")
          logger.debug [:species,:source,:cluster,:hgene].map { |id| res[id] }.join("\t")
          # Count all hits against id
          count[id] ||= 0
          count[id] += 1
          # Count all hits with a unique cluster
          group_clusters[id] ||= {}
          cluster = res[:cluster].to_s
          group_clusters[id][cluster] ||= 0
          group_clusters[id][cluster] += 1
          # Simplify output and store the last record
          h = res.to_hash
          h.delete(:cluster)
          h.delete(:hgene)
          all[id] ||= h
        end
        all.each do |id,rec|
          total = group_clusters[id].keys.size
          Pretty::print rec
          print total,"\t",count[id],"\n"
        end
      end
    end
  end
end

