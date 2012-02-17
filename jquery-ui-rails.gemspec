# -*- encoding: utf-8 -*-
require File.expand_path('../lib/jquery/ui/rails/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = "jquery-ui-rails"
  s.version     = Jquery::Ui::Rails::VERSION
  s.authors     = ["Jo Liss"]
  s.email       = ["joliss42@gmail.com"]
  s.homepage    = "https://github.com/joliss/jquery-ui-rails"
  s.summary     = "jQuery UI packaged for the Rails asset pipeline"
  s.description = "jQuery UI JavaScript, CSS, and image files packaged for the Rails 3.1+ asset pipeline"

  s.required_rubygems_version = ">= 1.3.6"

  s.add_dependency "railties", ">= 3.1.0"
  s.add_dependency "jquery-rails"

  s.add_development_dependency "execjs", "~> 1.0"

  s.files        = `git ls-files`.split("\n").reject { |f| f =~ /^testapp|^jquery-ui/ } + \
                   Dir.glob("vendor/**/*") + \
                   Dir.glob('jquery-ui/*LICENSE.txt') + ['jquery-ui/version.txt']
  s.executables  = `git ls-files`.split("\n").select { |f| f =~ /^bin/ }
  s.require_path = 'lib'
end
