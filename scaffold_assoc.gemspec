$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "scaffold_assoc/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "scaffold_assoc"
  s.version     = ScaffoldAssoc::VERSION
  s.authors     = ["Rafael Nowrotek"]
  s.email       = ["mail@benignware.com"]
  s.homepage    = "https://github.com/benignware/"
  s.summary     = "Nested scaffolding with rails 4"
  s.description = "Nested scaffolding with rails 4"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.0.2"

  s.add_development_dependency "sqlite3"
end
