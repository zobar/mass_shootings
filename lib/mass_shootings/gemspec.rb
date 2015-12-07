require 'mass_shootings/version'

module MassShootings
  class << self
    #
    # Gemspec for `mass_shootings`. This is only used by the gemspec and the
    # Rakefile, and must be required separately.
    # @return [Gem::Specification]
    #
    def gemspec
      @gemspec ||= Gem::Specification.new do |gem|
        gem.authors  = 'David P Kleinschmidt'
        gem.email    = 'david@kleinschmidt.name'
        gem.homepage = 'http://github.com/zobar/mass_shootings'
        gem.license  = 'MIT'
        gem.name     = 'mass_shootings'
        gem.summary  = 'Mass shootings as a service'
        gem.version  = VERSION

        gem.files = Dir['*.md', '{lib,spec}/**/*.rb']

        gem.add_dependency 'activemodel', '~> 4.2'
        gem.add_dependency 'nokogiri',    '~> 1.6'

        gem.add_development_dependency 'coveralls', '~> 0.8'
        gem.add_development_dependency 'minitest',  '~> 5.8'
        gem.add_development_dependency 'mocha',     '~> 1.1'
        gem.add_development_dependency 'rake',      '~> 10.4'
        gem.add_development_dependency 'yard',      '~> 0.8'
      end
    end
  end
end
