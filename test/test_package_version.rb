require_relative '../lib/gits/package_version.rb'
require 'test/unit'



class TestPackageVersion < Test::Unit::TestCase
  PV = Gits::PackageVersion

  def test_basic
    v = PV.new [1, 2, 3], 'xxx'
    assert_equal [1, 2, 3], v.ar
    assert_equal 'xxx', v.suffix
    assert_equal '1.2.3xxx', v.to_s

    v = PV.new [3, 13, 22]
    assert_equal [3, 13, 22], v.ar
    assert_empty v.suffix
    assert_equal '3.13.22', v.to_s
  end

  def test_from_string
    assert_equal '1.2.3', PV['1.2.3'].to_s
    assert_equal '1.2c', PV['1.02c'].to_s
    assert_equal '1.2.4.5-rc', PV['1.2.4.5-rc'].to_s
    assert_equal '1b', PV['1b'].to_s


    assert_nil PV['']
    assert_nil PV['xxx']
    assert_nil PV['1.x.3']
  end

  def vft(uri); PV.from_tag(uri); end
  def test_from_tag
    assert_nil vft('')
    assert_nil vft('v')

    assert_equal '5', vft('v5').to_s
    assert_equal '1.2.3', vft('1.2.3').to_s
    assert_equal '5.20.3rc2', vft('v5.20.03rc2').to_s
  end
end