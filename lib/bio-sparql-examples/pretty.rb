module BioSparql

  module Pretty

    def Pretty::print h, separator="\t"
      h.each{ |k,v| Kernel.print v.to_s,separator }
    end

    def Pretty::println h, separator="\t"
      Pretty::print h,separator
      Kernel.print "\n"
    end


  end

end
