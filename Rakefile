require 'rake/testtask'

task :default => :test

Rake::TestTask.new(:test) do |test|
    test.libs << "test"
    test.pattern = "test/**/test_*.rb"
    test.verbose = true
end
