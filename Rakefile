require 'rubygems'
require 'bundler/setup'
Bundler.require(:development)

require 'fileutils'
require './lib/signatory'

# Hoe.plugin :newgem
# Hoe.plugin :website
# Hoe.plugin :cucumberfeatures

# Generate all the Rake tasks
# Run 'rake -T' to see list of generated tasks (from gem root directory)
$hoe = Hoe.spec 'signatory' do
  self.developer 'Ryan Garver', 'ragarver@gmail.com'
  self.post_install_message = 'PostInstall.txt' # TODO remove if post-install message not required
  self.rubyforge_name       = self.name # TODO this is default value
  self.extra_deps           = [['activeresource','>= 3.0.0']]
  self.extra_dev_deps       = [['webmock', '~>1.35']]
end

#require 'newgem/tasks'
Dir['tasks/**/*.rake'].each { |t| load t }

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new do |t|
  t.rspec_opts = ['--colour', '--format', 'progress']
end

# TODO - want other tests/tasks run by default? Add them to the list
#remove_task :default
task :default => :spec
