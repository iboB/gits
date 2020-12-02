require_relative '../lib/gits'
require 'yaml'
require 'test/unit'

class TestDepSpec < Test::Unit::TestCase
  DS = Gits::DepSpec

  def nfu(url); DS.name_from_url(url); end
  def test_name_from_url
    assert_equal 'repo', nfu('ssh://user@host.xz:123/path/to/repo.git/')
    assert_equal 'repo', nfu('git://host.xz/path/to/repo.git')
    assert_equal 'cool-repo', nfu('git@host.xz:cool-repo.git')
    assert_equal 'repo33', nfu('file:///path/to/repo33.git')
    assert_equal 'local-repo', nfu('../local-repo/.git')

    assert_nil nfu('asdf')
    assert_nil nfu('/random.git/stuff')
  end

  def test_from_string
    DS.new('https://github.com/git/hub.git').tap do |ds|
      assert_equal 'hub', ds.name
      assert_equal 'https://github.com/git/hub.git', ds.url
      assert_equal :unknown, ds.type
      assert_nil ds.ver_rules
    end

    assert_raise(Gits::Error.new "cannot infer spec name from 'asdf'") do
      DS.new('asdf')
    end
  end

  def test_repo_from_hash
    DS.new(repo: 'git://host.xz/path/to/repo.git').tap do |ds|
      assert_equal 'repo', ds.name
      assert_equal 'git://host.xz/path/to/repo.git', ds.url
      assert_equal :repo, ds.type
      assert_nil ds.ver_rules
    end
  end

  def test_package_from_hash
    DS.new(package: 'ssh://host.xz:user/package.git').tap do |ds|
      assert_equal 'package', ds.name
      assert_equal 'ssh://host.xz:user/package.git', ds.url
      assert_equal :package, ds.type
      assert_nil ds.ver_rules
    end

    DS.new(package: 'foo.git', version: '> 1.2, < 2').tap do |ds|
      assert_equal 'foo', ds.name
      assert_equal 'foo.git', ds.url
      assert_equal :package, ds.type
      assert_equal 2, ds.ver_rules.rules.length
    end

    DS.new('package' => 'foo.git', 'version' => 'v > 1.2, < 2').tap do |ds|
      assert_equal 'foo', ds.name
      assert_equal 'foo.git', ds.url
      assert_equal :package, ds.type
      assert_equal 2, ds.ver_rules.rules.length
    end

    assert_raise(Gits::Error.new "bad version rules 'xxx' for package 'pkg'") do
      DS.new(package: './pkg/.git', version: 'xxx')
    end
  end

  def test_from_error
    assert_raise(Gits::Error.new "cannot initialize spec from Integer") do
      DS.new(8)
    end
    assert_raise(Gits::Error.new "missing 'package' or 'repo' identifier for '{}'") do
      DS.new({})
    end
  end

  def test_specs_from_hash
    src = <<~YAML
      deps:
        - https://github.com/someuser/foo.git
        - https://github.com/other/bar.git
        - git@github.com:alice/testlib.git
      dev-deps:
        - zzz.git
    YAML
    hash = YAML.load src
    DS.specs_from_hash(hash, :noroot).tap do |specs|
      assert_equal 3, specs.length
      assert_equal 'https://github.com/someuser/foo.git', specs['foo'].url
      specs.each do |k, s|
        assert_equal :unknown, s.type
      end
    end

    src = <<~YAML
      deps:
        - /home/bb/zzz/.git
        - package: https://github.com/someuser/foo.git
          version: v > 1.2.0, < 2
        - repo: https://github.com/other/bar.git
        - package: git@github.com:alice/testlib.git
          version: ~> 3.0.0
      dev-deps:
        - package: baz.git
    YAML
    hash = YAML.load src
    DS.specs_from_hash(hash, :root).tap do  |specs|
      assert_equal 5, specs.length
      assert_equal '/home/bb/zzz/.git', specs['zzz'].url
      assert_equal :unknown, specs['zzz'].type
      assert_equal :package, specs['foo'].type
      assert_not_nil specs['foo'].ver_rules
      assert_equal :repo, specs['bar'].type
      assert_equal :package, specs['testlib'].type
      assert_not_nil specs['testlib'].ver_rules
      assert_equal :package, specs['baz'].type
      assert_nil specs['baz'].ver_rules
    end
  end
end
