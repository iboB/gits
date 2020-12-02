require_relative '../lib/gits'
require 'test/unit'

include Gits

class TestYUtil < Test::Unit::TestCase
  def test_parse_specs
    src = <<~YAML
      deps:
        - https://github.com/someuser/foo.git
        - https://github.com/other/bar.git
        - git@github.com:alice/testlib.git
    YAML

    YUtil.parse_specs(src).tap do |specs|
      assert_equal 3, specs.length
    end
  end
end
