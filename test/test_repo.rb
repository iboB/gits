require_relative '../lib/gits'
require 'test/unit'

class TestRepo < Test::Unit::TestCase
  Repo = Gits::Repo

  def test_basic
    Repo.new('name', 'url', 'sha').tap do |r|
      assert_equal 'name', r.name
      assert_equal 'url', r.url
      assert_equal 'sha', r.sha
    end
  end

  def test_from_hash
    Repo.from_hash('name', url: 'url', sha: 'sha').tap do |r|
      assert_equal 'name', r.name
      assert_equal 'url', r.url
      assert_equal 'sha', r.sha
    end
  end
end
