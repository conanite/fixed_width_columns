require 'aduki'

module FixedWidthColumns
  class FixedWidthAttribute
    include Aduki::Initializer
    attr_writer :align, :padding
    attr_accessor :name, :length, :text, :date_format

    def align   ; (@align || :right).to_sym ; end
    def padding ; @padding || ' '           ; end

    def format_date value
      return value unless value.is_a? Date
      return value.to_s unless date_format
      value.strftime date_format
    end

    def format value, override={ }
      my_length  = override[:length]  || self.length  || value.length
      my_align   = override[:align]   || self.align
      my_padding = override[:padding] || self.padding

      str = format_date value

      str = str.to_s[0...my_length]
      case my_align
      when :left
        str.ljust my_length, my_padding
      when :right
        str.rjust my_length, my_padding
      end
    end

    def get_attribute_value obj, segment
      segment = segment.gsub(/-/, '_').to_sym
      if obj.is_a? Hash
        obj[segment]
      else
        obj.send segment
      end
    end

    def lookup obj, str
      segments = (str.to_s || "").split "."
      segment = segments.shift
      while !((segment == nil) || (segment.strip == '') ||(obj == nil))
        begin
          obj = get_attribute_value obj, segment
        rescue Exception => e
          raise "looking up #{str.inspect} ;\n    can't lookup #{segment}\n    on #{obj.inspect}, \n    got #{e.message.inspect}"
        end
        segment = segments.shift
      end
      obj
    end

    def string_for thing
      format(self.text || lookup(thing, name))
    end
  end
end
