require 'aduki'

module FixedWidthColumns
  FILTERS = { }
  TRANSFORMS = { }

  def self.transformer name, proc ; TRANSFORMS[name] = proc ; end
  def self.filter      name, proc ; FILTERS[name] = proc    ; end
end

require "fixed_width_columns/version"
require "fixed_width_columns/library"
require "fixed_width_columns/fixed_width_attribute"
require "fixed_width_columns/formatter"
require "fixed_width_columns/preprocessor"
require "fixed_width_columns/config"
