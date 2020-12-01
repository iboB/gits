$LOAD_PATH.unshift __dir__ # For use/testing when no gem is installed

module Gits
  autoload :VERSION, "gits/version"
  autoload :Error, "gits/error"
  autoload :PackageVer, "gits/package_ver"
  autoload :DepSpec, "gits/dep_spec"

  autoload :Util, "gits/util"

  module CLI
    autoload :Runner, "gits/cli/runner"
  end
end
