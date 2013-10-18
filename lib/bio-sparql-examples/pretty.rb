module BioSparql

  module Pretty

    def Pretty::print h, separator="\t"
      h.each{ |k,v| Kernel.print v.to_s,separator }
    end

  end

end
