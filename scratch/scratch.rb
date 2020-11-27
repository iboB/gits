# require 'yaml'

# src = File.read 'gits.yml'
# data = YAML.load(src)

# p data

# require 'git'

# tags = Git.ls_remote('https://github.com/iboB/dynamix.git')['tags'].keys.filter { |k|
#   k !~ /\{\}$/
# }

# p tags

require_relative '../lib/gits/package_version'

p Gits::PackageVersion.from_tag('v1.02.32rc2')
