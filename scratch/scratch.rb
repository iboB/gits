$LOAD_PATH.unshift File.expand_path("../lib", __dir__) # For use/testing when no gem is installed
require 'gits'

# src = File.read 'gits.yml'

# src = <<~YAML
# deps:
#   - https://github.com/someuser/foo.git
#   - https://github.com/other/bar.git
#   - git@github.com:alice/testlib.git
# YAML

# p Gits::Util::parse_spec(src)

p Gits::PackageVer::MatchRulePack.from_string '> 1.2, < 2'
