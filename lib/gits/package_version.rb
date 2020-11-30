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

    include Comparable
    def <=>(other)
      @ar.zip(other.ar).each do |a, b|
        return 1 if b == nil
        r = (a <=> b)
        return r if r.nonzero?
      end

      return -1 if other.ar.length > @ar.length

      @suffix <=> other.suffix
    end

    # self ~> other
    def pessimistic_compare(other)
      return false if @ar.length < other.ar.length # compare with longer query? too pessimistic. always false

      cmp = @ar.zip(other.ar).drop_while { |a, b| a == b } # drop equal elements from fromt
      cmp.select! { |a, b| b } # drop elements with b nil (since other may be shorter)
      return @suffix >= other.suffix if cmp.empty? # compare suffixes if everything else is equal
      return false if !other.suffix.empty? # pessimisting if other has suffix
      return false if cmp.length > 1 # pessimistic, only last is relevant

      # compare last elements
      a, b = cmp[0]
      a >= b
    end
  end
end
