# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "burstsms/version"

Gem::Specification.new do |s|
  s.name        = "burstsms"
  s.version     = BurstSms::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["David Barlow"]
  s.email       = ["david@madeindata.com"]
  s.homepage    = "https://github.com/madeindata/Burst-Sms"
  s.summary     = %q{Ruby Interface for the Burst SMS gateway}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  
  s.add_dependency "unhappymapper", "~> 0.5.0"
  s.add_dependency "httparty"
  
  s.add_development_dependency "rspec", "~> 2.6"
  s.add_development_dependency "webmock", "~> 1.9.0"
  s.add_development_dependency 'rake'
  
end
