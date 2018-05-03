require 'aduki'

module FixedWidthColumns
  class Library < Aduki::Initializable
    attr_accessor :config_root
    aduki_initialize :export_configs, Hash

    def export_config_for klass, name
      export_configs_for(klass).detect { |cfg| cfg.name == name }
    end

    def export_configs_for klass
      klass = klass.class_name if klass.is_a? Class
      export_configs[klass] ||= load_export_configs_for klass
    end

    def load_export_configs_for klass
      path = File.join config_root, "#{klass}.yml"
      return [] unless File.exists?(path)
      cfgs = YAML::load File.read path
      cfgs.map { |k,v| FixedWidthColumns::Config.new v.merge("target" => klass, "name" => k) }
    end
  end
end
