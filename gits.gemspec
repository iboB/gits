require_relative "lib/gits/version"

Gem::Specification.new do |s|
  s.name = 'gits'
  s.version = Gits::VERSION
  s.date = '2020-11-25'
  s.license = 'MIT'
  s.authors = ['Borislav Stanimirov']
  s.email = 'b.stanimirov@abv.bg'
  s.homepage = 'https://github.com/iboB/gits'
  s.summary = "A dev-oriented project-local package manager"
  s.description = <<~DESC
    A dev-oriented project-local package manager. An alternative to git submodules.
  DESC

  s.add_runtime_dependency 'git', '~> 1.7'

  s.files = Dir['lib/**/*'] + Dir['bin/*'] + ['LICENSE', 'README.md']
  s.executables = ['gits']
end
