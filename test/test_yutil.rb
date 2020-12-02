require_relative '../lib/gits'
require 'test/unit'

include Gits

class TestYUtil < Test::Unit::TestCase
  def test_parse
    src = <<~YAML
      deps:
        - https://github.com/someuser/foo.git
        - https://github.com/other/bar.git
        - git@github.com:alice/testlib.git
    YAML
    YUtil.parse(src) do |h|
      assert_equal Hash, h.class
    end
  end
end
