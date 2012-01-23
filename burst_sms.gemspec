# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "burst_sms/version"

Gem::Specification.new do |s|
  s.name        = "burst_sms"
  s.version     = BurstSms::VERSION
  s.authors     = ["David Barlow"]
  s.email       = ["david@madeindata.com"]
  s.homepage    = ""
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "burst_sms"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  
  s.add_dependency "unhappymapper"
  s.add_dependency "httparty"
  
  s.add_development_dependency "rspec", "~> 2.6"
  s.add_development_dependency "webmock", "~> 1.7.10"
  # s.add_development_dependency 'bundler', '>= 1.0.14'
  s.add_development_dependency 'rake'
  
end
