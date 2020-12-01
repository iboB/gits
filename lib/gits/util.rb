require 'yaml'

module Gits
  module Util
    extend self

    def name_from_url(url)
      return nil if url !~ /([^\/:]+)\/?.git\/?$/
      $1
    end
  end
end
