$LOAD_PATH.unshift __dir__ # For use/testing when no gem is installed

module Gits
  autoload :VERSION, "gits/version"
  autoload :Error, "gits/error"
  autoload :PackageVer, "gits/package_ver"
  autoload :DepSpec, "gits/dep_spec"

  autoload :Dep, "gits/dep"
  autoload :Repo, "gits/repo"
  autoload :Package, "gits/package"
  autoload :DepPack, "gits/dep_pack"

  autoload :YUtil, "gits/yutil"

  module CLI
    autoload :Runner, "gits/cli/runner"
  end
end
