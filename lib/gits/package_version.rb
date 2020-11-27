module Gits
  class PackageVersion
    def initialize(ar, suffix = '')
      @ar = ar
      @suffix = suffix
    end

    attr_reader :ar, :suffix

    def self.[](str)
      return nil if str.empty?
      return nil if str[0].to_i.to_s != str[0] # must start with number

      ar = str.split('.')
      return nil if ar[-1] !~ /^(\d+)(.*)/

      ar[-1] = $1
      suffix = $2

      ar.map! { |v|
        return nil if v !~ /^\d+$/
        v.to_i
      }
      PackageVersion.new(ar, suffix)
    end

    def self.from_tag(tag)
      return nil if tag.empty?
      tag = tag[1..-1] if tag[0] == 'v'
      PackageVersion[tag]
    end

    def to_s
      @ar.join('.') + @suffix
    end
  end
end
