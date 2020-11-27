# require 'yaml'

# src = File.read 'gits.yml'
# data = YAML.load(src)

# p data

require 'git'

p Git.ls_remote('https://github.com/iboB/dynamix.git')
