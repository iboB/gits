module Gits
  # a pack of "materialized" deps
  # their type is known and they have concrete versions or commit sha-s
  class DepPack
    def initialize
      @deps = {}
    end

    def self.from_hash(hash)
      @deps = hash.map { |name, hash| # essentially this is a transform_values but we need the key as well
        # determine whether it's a repo or package
        next Repo.from_hash(name, val) if val['sha']
        next Package.from_hash(name, val) if val['tag']
        raise Error.new "Malformed dep #{name}"
      }.map { |dep|
        [dep.name, dep]
      }.to_h
    end
  end
end
