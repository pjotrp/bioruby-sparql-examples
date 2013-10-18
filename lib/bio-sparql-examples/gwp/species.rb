require 'bio-sparql-examples/gwp/db'

module BioSparql
  module GWP
    module Species

      def Species::query

        sparql = DB.new()

        result = sparql.query(<<QUERY

SELECT DISTINCT ?species ?source  WHERE 
{
      ?fam :species ?species ;
        :source ?source .
}

QUERY
)
        result.each_solution do | res |
          print res[:species],"\t",res[:source],"\n"
        end
      end
    end
  end
end

