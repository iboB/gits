module Gits
  # a materialized Package
  class Package < Dep
    def initialize(name, url, tag, dep_specs)
      super(name, url)
    end

    attr :tag, :dep_specs

    def self.from_hash(name, hash)
    end
  end
end
