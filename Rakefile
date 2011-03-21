begin
  require 'rspec/core/rake_task'

  desc "Run specs"
  RSpec::Core::RakeTask.new do |t|
    t.rspec_opts = %w(-fs --color)
  end
rescue LoadError
  task :spec do
    abort "Run `rake spec:deps` to be able to run the specs"
  end

  namespace :spec do
    desc "Ensure spec dependencies are installed"
    task :deps do
      sh "gem list rspec | (grep 'rspec (2.0' 1> /dev/null) || gem install rspec --no-ri --no-rdoc"
    end
  end
end

gem_name = File.basename(Dir["*.gemspec"].first, ".gemspec")

desc "Build the gem, removing old ones"
task :build do
  # gem_name = 'rakesupport'
  gem_files = Dir['*.gem']
  commands = []
  commands << ["rm #{ gem_files.join(' ') }"] unless gem_files.empty?
  commands << ["gem build #{gem_name}.gemspec"]
  sh commands.join(" && ")
end

desc "Build and install the gem"
task :install => :build do
  # gem_name = 'rakesupport'
  gem_file = Dir['*.gem'].first
  if gem_file.nil?
    puts "There is no gem file to install"
  else
    sh "gem uninstall --ignore-dependencies #{gem_name}; gem install #{gem_file}"
  end
end

task :default => :spec
