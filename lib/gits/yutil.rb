require 'yaml'

module Gits
  module YUtil
    extend self

    def parse_specs(yml)
      h = YAML.load(yml)
      deps = h['deps']
      raise Error.new "deps must be an array" if deps.class != Array
      deps.map do |val|
        DepSpec.new val
      end
    end

    def parse_specs_file(fname)
      parse_specs File.read fname
    end
  end
end
