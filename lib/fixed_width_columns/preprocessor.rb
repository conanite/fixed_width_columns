require 'aduki'

module FixedWidthColumns
  class PreProcessor < Aduki::Initializable
    attr_accessor :filter, :transform, :library

    def filter_sym            ; (@filter || "true").to_sym                                  ; end
    def do_filter items       ; items.select &(FixedWidthColumns::FILTERS[filter_sym])      ; end
    def maybe_transform items ; @transform ? do_transform(items) : items                    ; end
    def do_transform items    ; FixedWidthColumns::TRANSFORMS[@transform.to_sym].call items ; end
    def apply items           ; maybe_transform do_filter items                             ; end
    def to_s                  ; "filter:#{@filter};transform:#{@transform}"                 ; end

  end
end
