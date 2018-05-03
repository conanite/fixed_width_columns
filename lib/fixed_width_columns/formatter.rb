require 'aduki'

module FixedWidthColumns
  class Formatter < Aduki::Initializable
    aduki columns: FixedWidthColumns::FixedWidthAttribute

    def headers
      columns.map { |col| col.format(col.name.to_s, :padding => ' ') }.join
    end

    def format thing
      columns.map { |col| col.string_for thing }.join
    end
  end
end
