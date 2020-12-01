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

    refute pc(PV['1.2.3'], PV['1.2.3.0'])
    refute pc(PV['1.2.3'], PV['1.2.4'])
    refute pc(PV['1.3.0'], PV['1.2.2'])
    refute pc(PV['2.0.0'], PV['1.2'])
    refute pc(PV['1.1.3'], PV['1.2'])

    assert pc(PV['1.2.3a'], PV['1.2.3a'])
    assert pc(PV['1.2.3a'], PV['1.2.3'])
    assert pc(PV['1.2.3b'], PV['1.2.3a'])
    refute pc(PV['1.2.3a'], PV['1.2.4'])
    refute pc(PV['1.2.3a'], PV['1.2.3b'])
  end

  def test_match_rule
    PV::MatchRule.from_string('= 1.2.3').tap do |mr|
      assert_equal :eq, mr.op
      assert_equal PV['1.2.3'], mr.ver
      assert_equal '= 1.2.3', mr.to_s
      assert mr.match? PV['1.2.3']
      refute mr.match? PV['1.2.4']
      refute mr.match? PV['1.2.2']
    end

    PV::MatchRule.from_string('< 1.2.3b').tap do |mr|
      assert_equal :lt, mr.op
      assert_equal PV['1.2.3b'], mr.ver
      assert_equal '< 1.2.3b', mr.to_s
      assert mr.match? PV['1.2.3']
      assert mr.match? PV['1.1.1.0']
      assert mr.match? PV['1.2.3a']
      refute mr.match? PV['1.2.3b']
      refute mr.match? PV['1.2.3c']
    end

    PV::MatchRule.from_string('> 1.05b').tap do |mr|
      assert_equal :gt, mr.op
      assert_equal PV['1.05b'], mr.ver
      assert_equal '> 1.5b', mr.to_s
      assert mr.match? PV['1.05c']
      assert mr.match? PV['1.06']
      assert mr.match? PV['2.00']
      refute mr.match? PV['1.05b']
      refute mr.match? PV['1.05a']
      refute mr.match? PV['1.00']
    end

    PV::MatchRule.from_string('<= 1.5.4').tap do |mr|
      assert_equal :lte, mr.op
      assert_equal PV['1.5.4'], mr.ver
      assert_equal '<= 1.5.4', mr.to_s
      assert mr.match? PV['1.5.4']
      assert mr.match? PV['1.5.3']
      refute mr.match? PV['1.5.5']
    end

    PV::MatchRule.from_string('>= 1.5.4').tap do |mr|
      assert_equal :gte, mr.op
      assert_equal PV['1.5.4'], mr.ver
      assert_equal '>= 1.5.4', mr.to_s
      assert mr.match? PV['1.5.4']
      assert mr.match? PV['1.5.5']
      assert mr.match? PV['1.6.3']
      refute mr.match? PV['1.5.3']
    end

    PV::MatchRule.from_string('~> 1.5.4').tap do |mr|
      assert_equal :pc, mr.op
      assert_equal PV['1.5.4'], mr.ver
      assert_equal '~> 1.5.4', mr.to_s
      assert mr.match? PV['1.5.4']
      assert mr.match? PV['1.5.5']
      refute mr.match? PV['1.5.3']
      refute mr.match? PV['1.6.0']
    end

    assert_nil PV::MatchRule.from_string('> xxx')
    assert_nil PV::MatchRule.from_string('> 1 2')
    assert_nil PV::MatchRule.from_string('<> 1.2.4')
  end

  def test_match_rules
    PV::MatchRulePack.from_string('').tap do |mr|
      assert_empty mr.rules
      assert mr.match? PV['0.0.1']
      assert mr.match? PV['5.5']
    end

    PV::MatchRulePack.from_string('~> 1.2.3').tap do |mr|
      assert_equal 1, mr.rules.length
      assert_equal :pc, mr.rules.first.op
      assert_equal PV['1.2.3'], mr.rules.first.ver
      assert_equal '~> 1.2.3', mr.to_s
      assert mr.match? PV['1.2.3']
      assert mr.match? PV['1.2.4']
      refute mr.match? PV['1.3.0']
      refute mr.match? PV['1.2.2']
    end

    PV::MatchRulePack.from_string('>= 1.2.3, < 2').tap do |mr|
      assert_equal 2, mr.rules.length
      assert_equal :gte, mr.rules.first.op
      assert_equal PV['1.2.3'], mr.rules.first.ver
      assert_equal :lt, mr.rules.last.op
      assert_equal PV['2'], mr.rules.last.ver
      assert_equal '>= 1.2.3, < 2', mr.to_s
      assert mr.match? PV['1.2.3']
      assert mr.match? PV['1.2.4']
      assert mr.match? PV['1.4.4']
      refute mr.match? PV['1.2.2']
      refute mr.match? PV['2.0.0']
    end

    assert_nil PV::MatchRulePack.from_string('> xxx')
    assert_nil PV::MatchRulePack.from_string('<> 1.2.4')
    assert_nil PV::MatchRulePack.from_string('>= 1.2.3 < 2')
  end
end
