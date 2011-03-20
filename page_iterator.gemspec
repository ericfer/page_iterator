gem_name = Dir["*.gemspec"].first.match(/\A(\w*).gemspec\z/).captures.first

Gem::Specification.new do |s|
  s.name        =  gem_name
  s.version     = "0.1.0"
  s.summary     = "A library to split a number of data in pages and iterate through them, keeping track in log"
  s.author      = "Eric Fer"
  s.email       = "eric.fer@gmail.com"
  s.homepage    = "https://github.com/ericfer/#{gem_name}"
  s.add_development_dependency "rspec"
  s.add_development_dependency "mocha"  
  s.rubyforge_project         = gem_name
  s.files       = Dir["{lib/**/*.rb,README.rdoc,Rakefile,*.gemspec}"]
end