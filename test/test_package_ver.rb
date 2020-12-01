require_relative '../lib/gits/package_ver.rb'
require 'test/unit'



class TestPackageVer < Test::Unit::TestCase
  PV = Gits::PackageVer

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

  def test_compare
    assert_equal PV['1.2.3'], PV['1.2.3']
    assert_equal PV['1.2.3a'], PV['1.2.3a']

    assert_compare PV['1.2.3'], '<=', PV['1.2.3']
    assert_compare PV['1.2.3a'], '>=', PV['1.2.3a']

    assert_compare PV['2'], '<', PV['4']
    assert_compare PV['3'], '>', PV['1']

    assert_compare PV['1.2'], '<', PV['1.4']
    assert_compare PV['1.3'], '>', PV['1.1']

    assert_compare PV['1.2.3'], '<', PV['1.2.4']
    assert_compare PV['1.2.4'], '>', PV['1.2.3']

    assert_compare PV['1.2.3a'], '<', PV['1.2.3b']
    assert_compare PV['1.2.4rc3'], '>', PV['1.2.4rc2']

    assert_compare PV['1.2.3'], '<', PV['1.2.3a']
    assert_compare PV['1.2'], '<', PV['1.2.0']
    assert_compare PV['1'], '<', PV['1.2.0']
    assert_compare PV['1.2.3'], '>', PV['1']
    assert_compare PV['1.2.3'], '>', PV['1.1']
    assert_compare PV['1.2.3b'], '>', PV['1.2.3']
  end

  def pc(a, b); a.pessimistic_compare(b); end
  def test_pessimistic_compare
    assert pc(PV['1.2.3'], PV['1.2.3'])
    assert pc(PV['1.2.4'], PV['1.2.3'])
    assert pc(PV['1.2.3'], PV['1.2'])
    assert pc(PV['1.3.3'], PV['1.2'])
    assert pc(PV['1.2.3'], PV['1'])
    assert pc(PV['2.2.3'], PV['1'])
    assert pc(PV['1.3'], PV['1.2'])

    assert !pc(PV['1.2.3'], PV['1.2.3.0'])
    assert !pc(PV['1.2.3'], PV['1.2.4'])
    assert !pc(PV['1.3.0'], PV['1.2.2'])
    assert !pc(PV['2.0.0'], PV['1.2'])
    assert !pc(PV['1.1.3'], PV['1.2'])

    assert pc(PV['1.2.3a'], PV['1.2.3a'])
    assert pc(PV['1.2.3a'], PV['1.2.3'])
    assert !pc(PV['1.2.3a'], PV['1.2.4'])
    assert !pc(PV['1.2.3a'], PV['1.2.3b'])
    assert pc(PV['1.2.3b'], PV['1.2.3a'])
  end
end