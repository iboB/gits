require_relative '../lib/gits/util.rb'
require 'test/unit'

include Gits

class TestUtil < Test::Unit::TestCase

  def nfu(url); Util.name_from_url(url); end
  def test_name_from_url
    assert_equal 'repo', nfu('ssh://user@host.xz:123/path/to/repo.git/')
    assert_equal 'repo', nfu('git://host.xz/path/to/repo.git')
    assert_equal 'cool-repo', nfu('git@host.xz:cool-repo.git')
    assert_equal 'repo33', nfu('file:///path/to/repo33.git')
    assert_equal 'local-repo', nfu('../local-repo/.git')

    assert_nil nfu('asdf')
    assert_nil nfu('/random.git/stuff')
  end
end
