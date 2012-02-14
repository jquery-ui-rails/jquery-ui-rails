require 'rubygems'
require 'execjs'

DEPENDENCY_HASH = ExecJS.eval(File.read('dependencies.js'))
VERSION = File.read("jquery-ui/version.txt").strip
LANGUAGE_REGEX = /-[-a-zA-Z]+(?=\.js\z)/

def get_js_dependencies(basename)
  if basename.match LANGUAGE_REGEX
    # Depend on main module for i18n files
    [basename.sub(LANGUAGE_REGEX, '')]
  else
    DEPENDENCY_HASH[basename.sub(/\Ajquery\./, '')]
      .reject { |dep| dep == 'theme' } # cannot use 'theme' (CSS) pseudo-dep
      .map { |dep| "jquery.#{dep}" }
  end
end

desc "Generate the JavaScript assets"
task :javascripts do
  target_dir = "vendor/assets/javascripts"
  FileUtils.mkdir_p target_dir
  Dir.glob("jquery-ui/ui/**/*.js").each do |path|
    basename = File.basename(path)
    dependencies = get_js_dependencies(basename)
    fail "Missing dependency info for #{basename}" if dependencies.nil?
    File.open("#{target_dir}/#{basename}", "w") do |out|
      # puts "#{basename} => #{dependencies.inspect}"
      out.write("//= require jquery\n")
      dependencies.each do |dep|
        fail "#{basename}: missing #{dep}" unless File.exist? "jquery-ui/ui/#{dep}"
        out.write("//= require #{dep.sub /\.js\z/, ''}\n")
      end
      out.write("\n") unless dependencies.empty?
      source_code = File.read(path).gsub('@VERSION', VERSION)
      out.write(source_code)
    end
  end
  File.open("#{target_dir}/jquery-ui.js", "w") do |out|
    Dir.glob("jquery-ui/ui/*.js").sort.each do |path|
      out.write("//= require #{File.basename path}\n")
    end
  end
end

desc "Generate the CSS assets"
task :stylesheets do
  target_dir = "vendor/assets/stylesheets"
  FileUtils.mkdir_p target_dir
  Dir.glob("jquery-ui/themes/base/*.css").each do |path|
    basename = File.basename(path)
    File.open("#{target_dir}/#{basename}", "w") do |out|
      source_code = File.read(path)
        .gsub('@VERSION', VERSION)
        .gsub(/^@import (.*)$/) { |s|
          m = s.match(/^@import (url\()?"(?<url>[-_.a-zA-Z]+)"\)?;/) \
            or fail "Cannot parse import: #{s}"
          "/*\n *= require #{m['url']}\n */"
        }
        .gsub(/^( \*= require .*)\n \*\/(\n+)\/\*\n(?= \*= require )/, '\1\2') # be cute: collapse requires
        .gsub(/url\(images\/([-_.a-zA-Z0-9]+)\)/, 'url(<%= image_path("jquery-ui/\1") %>)')
      out.write(source_code)
    end
  end
end

desc "Generate the image assets"
task :images do
  target_dir = "vendor/assets/images/jquery-ui"
  FileUtils.mkdir_p target_dir
  FileUtils.cp(Dir.glob("jquery-ui/themes/base/images/*.png"), target_dir)
end

desc "Generate everything (default)"
task :all => [:javascripts, :stylesheets, :images]

task :default => :all
