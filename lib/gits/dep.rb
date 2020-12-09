module Gits
  # a materialized dep
  class Dep
    def initialize(name, url)
      @name = name
      @url = url
    end

    attr :name, :url
  end
end
