$LOAD_PATH.unshift __dir__ # For use/testing when no gem is installed

module Gits
  autoload :VERSION, "gits/version"
  autoload :Error, "gits/error"
  autoload :CLI, "gits/cli"
end
