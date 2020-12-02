module Gits
  # The version of a package
  # Suports comparisons including the ruby pessimistic compare (~>)
  # A version is numbers separated by dots + an optional string at the end
  # 1.2.3, 1.2.3.4.5.3, 1.2.3a
  # This is a standalone class with no deps which can be safely removed from the gem
  class PackageVer
    def initialize(ar, suffix = '')
      @ar = ar
      @suffix = suffix
    end

    attr_reader :ar, :suffix

    # construct from string
    def self.[](str)
      return nil if str.empty?
      return nil if str[0].to_i.to_s != str[0] # must start with number

      ar = str.split('.')
      return nil if ar[-1] !~ /^(\d+)(.*)/ # match optional string suffix

      ar[-1] = $1
      suffix = $2

      ar.map! { |v|
        return nil if v !~ /^\d+$/ # error if not a number
        v.to_i
      }
      PackageVer.new(ar, suffix)
    end

    # construct from git repo tag (same as from string but 'v' is allowed as an optional prefix)
    def self.from_tag(tag)
      return nil if tag.empty?
      tag = tag[1..-1] if tag[0] == 'v' # escape 'v' if any
      PackageVer[tag]
    end

    def to_s
      @ar.join('.') + @suffix
    end

    include Comparable
    def <=>(other)
      # allow partial compares
      @ar.zip(other.ar).each do |a, b|
        return 1 if b == nil
        r = (a <=> b)
        return r if r.nonzero?
      end

      return -1 if other.ar.length > @ar.length

      # check suffix if everything else is equal
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

    # A match rule contains a rule for a version to match
    # It's a comparsion with another (potentially partial) version
    class MatchRule
      Sym2Op = {eq: '=', gt: '>', lt: '<', gte: '>=', lte: '<=', pc: '~>' }
      Op2Sym = Sym2Op.map { |k, v| [v, k] }.to_h

      def initialize(op_str, ver_str)
        @ver = PackageVer[ver_str]
        @op = Op2Sym[op_str]
      end

      attr :op, :ver

      # '<op> <ver>'
      # '< 1.1.2', '~> 1.2.3', '= 1.2.3'
      def self.from_string(str)
        elems = str.split(' ')
        return nil if elems.length != 2

        ret = MatchRule.new(*elems)
        ret.op && ret.ver && ret
      end

      def to_s
        "#{Sym2Op[@op]} #{ver}"
      end

      def match?(version)
        send(@op, version)
      end

      def eq(v); return v == @ver; end
      def gt(v); return v > @ver; end
      def lt(v); return v < @ver; end
      def gte(v); return v >= @ver; end
      def lte(v); return v <= @ver; end
      def pc(v); return v.pessimistic_compare(@ver); end
    end

    # A collection of match rules
    class MatchRulePack
      def initialize
        @rules = []
      end

      attr :rules

      # rules separated by comma
      def self.from_string(str)
        ret = MatchRulePack.new
        str.split(',').each do |rule_str|
          rule = MatchRule.from_string rule_str
          return nil if !rule
          ret.rules << rule
        end
        ret
      end

      def to_s
        @rules.join(', ')
      end

      # match if the vesion matches all underlying rules
      def match?(version)
        @rules.reduce(true) do |res, rule|
          break false if !rule.match? version
          true
        end
      end
    end
  end
end
