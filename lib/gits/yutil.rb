require 'yaml'

module Gits
  module YUtil
    extend self

    def parse(yml)
      yield YAML.load yml
    end

    def parse_file(fname)
      parse_specs(File.read fname) { |hash| yield hash }
    end
  end
end
