require File.expand_path('../lib/twym/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ['Kuniaki IGARASHI']
  gem.email         = ['igaiga@gmail.com']
  gem.description   = 'Timer with Your Messages'
  gem.summary       = 'Timer for lightning talks'
  gem.homepage      = 'https://github.com/igaiga/TwYM'

  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = 'twym'
  gem.require_paths = ['lib']
  gem.version       = TwYM::VERSION

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
end
