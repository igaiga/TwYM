require File.expand_path('../lib/twym/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ['Kuniaki IGARASHI']
  gem.email         = ['igaiga@gmail.com']
  gem.description   = 'Timer with Your Messages'
  gem.summary       = 'Timer for lightning talks'
  gem.homepage      = 'https://github.com/igaiga/TwYM'

  gem.files         = `git ls-files`.split("\n")
  gem.executables   = `git ls-files -- bin/*`.split("\n").map{|name| File.basename name }
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = 'twym'
  gem.require_paths = ['lib']
  gem.version       = TwYM::VERSION

  gem.add_dependency 'json'
  gem.add_dependency 'oauth'
  gem.add_dependency 'simple_oauth'
  gem.add_dependency 'excon'

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
end
