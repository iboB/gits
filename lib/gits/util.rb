module Gits
  module Util
    extend self

    def name_from_uri(uri)
      return nil if uri !~  /([^\/:]+)\/?.git\/?$/
      $1
    end
  end
end
