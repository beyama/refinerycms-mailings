Gem::Specification.new do |s|
  s.platform          = Gem::Platform::RUBY
  s.name              = 'refinerycms-mailings'
  s.version           = '0.1.0'
  s.description       = 'Ruby on Rails Mailings engine for Refinery CMS'
  s.date              = '2011-04-05'
  s.summary           = 'Mailings engine for Refinery CMS'
  s.require_paths     = %w(lib)
  s.files             = Dir['lib/**/*', 'config/**/*', 'app/**/*']
  
  s.add_dependency    'liquid',  '>= 2.2.2'
  s.add_dependency    'delayed_job',  '>= 2.1.4'
  s.add_dependency    'nokogiri',  '>= 1.4.4'
  s.add_dependency    'guid'
end
