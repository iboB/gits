module Gits
  # a materialized repo
  class Repo < Dep
    def initialize(name, url, sha)
      super(name, url)
      @sha = sha
    end

    attr :sha

    def self.from_hash(name, hash)
      # symbolize keys
      hash.transform_keys!(&:to_sym)

      url = hash[:url]
      raise Error.new "repo #{name} missing url" unless url
      sha = hash[:sha]
      raise Error.new "repo #{name} missing commit sha" unless sha
      return Repo.new(name, url, sha)
    end
  end
end
