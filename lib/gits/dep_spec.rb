module Gits
  class DepSpec
    attr_accessor :name, :url, :type

    def initialize(val)
      if val.class == String
        init_from_string val
      elsif val.class == Hash
        init_from_hash val
      else
        raise Error.new "cannot initialize spec from #{val.class}"
      end
    end

    def self.name_from_url(url)
      return nil if url !~ /([^\/:]+)\/?.git\/?$/
      $1
    end

    def init_from_url(url)
      @name = DepSpec.name_from_url str
      raise "cannot infer spec name from #{str}" if !@name
      @url = str
    end

    def init_from_string(str)
      init_from_url str
      @type = :unknown
    end

    def init_from_hash(hash)
      package_url = hash[:package]
      repo_url = hash[:repo]
      if package_url
        init_from_url package_url
        @type = :package
      elsif repo_url
        init_from_url repo_url
        @type = :repo
      else
        raise "missing 'package' or 'repo' identifier for #{hash}"
      end
    end
  end
end
