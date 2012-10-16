# -*- encoding: utf-8 -*-
require File.expand_path('../lib/photozou/version', __FILE__)

Gem::Specification.new do |gem|
  gem.add_development_dependency 'rspec'

  gem.authors       = ["Yuta Okazaki"]
  gem.email         = ["yt.okzk@gmail.com"]
  gem.description   = %q{A Ruby wrapper for Photozou API}
  gem.summary       = %q{Photozou API on Ruby}
  gem.homepage      = "https://github.com/yt-okzk/photozou"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "photozou"
  gem.require_paths = ["lib"]
  gem.version       = Photozou::VERSION
end
