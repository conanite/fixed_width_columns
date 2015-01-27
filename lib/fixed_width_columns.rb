require 'aduki'
require "fixed_width_columns/version"
require "fixed_width_columns/fixed_width_attribute"

class FixedWidthColumns
  include Aduki::Initializer
  include Aduki::Initializer
  attr_accessor :columns
  aduki columns: FixedWidthAttribute

  def headers
    columns.map { |col| col.format(col.name.to_s, :padding => ' ') }.join
  end

  def format thing
    columns.map { |col| col.string_for thing }.join
  end
end
