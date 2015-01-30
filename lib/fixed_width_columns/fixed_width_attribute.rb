require 'aduki'

class FixedWidthColumns
  class FixedWidthAttribute
    include Aduki::Initializer
    attr_writer :align, :padding
    attr_accessor :name, :length, :text

    def align   ; (@align || :right).to_sym ; end
    def padding ; @padding || ' '           ; end

    def format value, override={ }
      my_length  = override[:length]  || self.length  || value.length
      my_align   = override[:align]   || self.align
      my_padding = override[:padding] || self.padding

      str = value.to_s[0...my_length]
      case my_align
      when :left
        str.ljust my_length, my_padding
      when :right
        str.rjust my_length, my_padding
      end
    end

    def string_for thing
      format(self.text || thing.send(name))
    end
  end
end
