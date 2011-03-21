gem_name = File.basename(__FILE__, ".gemspec")

Gem::Specification.new do |s|
  s.name        =  gem_name
  s.version     = "0.1.0"
  s.summary     = "Split a number of data in pages and iterate through them, keeping track in a log file"
  s.author      = "Eric Fer"
  s.email       = "eric.fer@gmail.com"
  s.homepage    = "https://github.com/ericfer/#{gem_name}"
  s.files       = Dir["**/*.{md,rb,gemspec}"] - Dir["spec/**/*.rb"]
  s.rubyforge_project = gem_name
  s.add_development_dependency "rspec"
  s.add_development_dependency "mocha"  
end