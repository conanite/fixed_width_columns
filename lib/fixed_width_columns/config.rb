require 'aduki'

module FixedWidthColumns
  class Config < Aduki::Initializable
    attr_accessor :name, :target, :label
    aduki formatter: FixedWidthColumns::Formatter
    aduki preprocessors: FixedWidthColumns::PreProcessor

    def to_text items, header=nil
      pre_process(items).inject(headers? header) { |ll, i| ll << formatter.format(i) }.join "\n"
    end

    @@export_configs = { }
    def headers?                    header ; header ? [formatter.headers] : []                                ; end
    def pre_process                  items ; (preprocessors || []).inject(items) { |list, pp| pp.apply list } ; end
  end
end
