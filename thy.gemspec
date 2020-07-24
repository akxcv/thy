# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = 'thy'
  spec.version       = '0.1.4'
  spec.authors       = ['Alexander Komarov <ak@akxcv.com>']
  spec.email         = ['ak@akxcv.com']

  spec.summary       = 'A minimal, strict runtime type system'
  spec.description   = '@see summary'
  spec.homepage      = 'https://github.com/akxcv/thy'
  spec.license       = 'MIT'

  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 12.3'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'armitage-rubocop'
  spec.add_development_dependency 'pry'
end
