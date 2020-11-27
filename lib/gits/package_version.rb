module Gits
  class PackageVersion
    def initialize(semver, tag)
      @semver = semver
      @tag = tag
    end

    def self.from_tag(tag)
      return nil if tag !~ /v?(\d+)(.+)/
      sv = [$1.to_i] + $2.split('.').filter_map { |v|
        next if v.empty?
        return nil if v !~ /^\d+$/
        v.to_i
      }
      PackageVersion.new sv, tag
    end
  end
end
