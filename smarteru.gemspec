$LOAD_PATH.push File.expand_path('../lib', __FILE__)

require 'smarteru/version'

Gem::Specification.new do |s|
  s.authors     = ['Sasha Shamne', 'EyecueLab']
  s.name        = 'smarteru'
  s.version     = Smarteru::VERSION
  s.email       = ['alexander.shamne@gmail.com']
  s.description = 'Ruby wrapper for Smarteru API'
  s.summary     = 'Allows access to a Smarteru API operations http://help.smarteru.com/'

  s.files = Dir['{lib}/**/*'] + ['MIT-LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['test/**/*']
  s.require_paths = ['lib']

  s.add_dependency('rest-client', '>= 1.7')
  s.add_dependency('libxml-ruby', '>= 2.8')
  s.add_dependency('xmlhasher', '>= 0.0.6')

  s.add_development_dependency('rdoc')
  s.add_development_dependency('rake', '>= 0.9.3')
  s.add_development_dependency('webmock', '>= 1.8.0')
end
