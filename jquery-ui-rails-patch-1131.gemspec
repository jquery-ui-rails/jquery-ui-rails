# -*- encoding: utf-8 -*-
require File.expand_path('../lib/jquery/ui/rails/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = "jquery-ui-rails-patch-1131"
  s.version     = Jquery::Ui::Rails::VERSION
  s.authors     = ["Pedro Bini", "Zubin Tiku", "Dan McCormick"]
  s.email     = ["pedro.bini@constructor.io", "zubin@constructor.io", "dan@constructor.io"]
  s.homepage    = "https://github.com/Constructor-io/jquery-ui-rails"
  s.summary     = "jQuery UI packaged for the Rails asset pipeline, updated for 1.13.1"
  s.description = "jQuery UI's JavaScript, CSS, and image files packaged for the Rails 3.1+ asset pipeline. Supports jquery-ui , updated for 1.13.1"
  s.license     = "MIT"

  s.required_rubygems_version = ">= 1.3.6"

  s.add_dependency "railties", ">= 3.2.16"

  s.add_development_dependency "json", "~> 2.0"

  s.files        = `git ls-files`.split("\n").reject { |f| f =~ /^testapp|^jquery-ui-patch-1131/ }
  s.executables  = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_path = 'lib'
end
