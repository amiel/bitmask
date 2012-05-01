# -*- encoding: utf-8 -*-
require File.expand_path('../lib/bitmask/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Amiel Martin"]
  gem.email         = ["amiel@carnesmedia.com"]
  gem.description   = %q{Represents a set of boolean values as an Integer}
  gem.summary       = <<-SUMMARY
    Bitmask represents a set of boolean values as an Integer using bitwise arithmetic.

    This allows, for example, for a set of boolean settings to be stored in one
    integer column in a database.
  SUMMARY
  gem.homepage      = "https://github.com/amiel/bitmask"

  gem.files         = `git ls-files`.split($\)
  gem.test_files    = gem.files.grep(%r{^(test)/})
  gem.name          = "bitmask"
  gem.require_paths = ["lib"]
  gem.version       = Bitmask::VERSION
end
