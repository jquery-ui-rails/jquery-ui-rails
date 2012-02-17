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
      .reject { |dep| dep == 'theme' } # 'theme' pseudo-dependency handled by CSS
      .map { |dep| "jquery.#{dep}" }
  end
end

desc "Remove the vendor directory"
task :clean do
  FileUtils.rm_rf 'vendor'
  # We could do rm(Dir.glob('vendor/**/*.*') - `git ls-files vendor`.split("\n"))
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
      out.write("//= require #{File.basename(path).sub(/\.js\z/, '')}\n")
    end
  end
end

desc "Generate the CSS assets"
task :stylesheets do
  target_dir = "vendor/assets/stylesheets"
  FileUtils.mkdir_p target_dir
  Dir.glob("jquery-ui/themes/base/*.css").each do |path|
    basename = File.basename(path)
    source_code = File.read(path)
      .gsub('@VERSION', VERSION)
    extra_dependencies = []
    # Does the matching JS file require the theme?
    unless basename =~ /\.(all|base|core|theme)\./
      dependencies = DEPENDENCY_HASH[basename.sub(/\Ajquery\./, '').sub(/\.css/, '.js')]
      fail "No matching JavaScript found in dependencies for #{basename}" unless dependencies
      extra_dependencies << 'jquery.ui.theme' if dependencies.include? 'theme'
    end
    extra_dependencies << 'jquery.ui.core' unless basename =~ /\.(all|base|core)\./
    extra_dependencies.each do |dep|
      source_code = source_code.sub(/\A((.*?\*\/\n)?)/m, "\\1/*\n *= require #{dep}\n */\n")
    end
    source_code = source_code
      .gsub(/^@import (.*)$/) { |s|
        m = s.match(/^@import (url\()?"(?<module>[-_.a-zA-Z]+)\.css"\)?;/) \
          or fail "Cannot parse import: #{s}"
        "/*\n *= require #{m['module']}\n */"
      }
      .gsub(/^( \*= require .*)\n \*\/(\n+)\/\*\n(?= \*= require )/, '\1\2') # be cute: collapse requires
      .gsub(/url\(images\/([-_.a-zA-Z0-9]+)\)/, 'url(<%= image_path("jquery-ui/\1") %>)')
    File.open("#{target_dir}/#{basename}.erb", "w") do |out|
      out.write(source_code)
    end
  end
  FileUtils.cp("#{target_dir}/jquery.ui.all.css.erb", "#{target_dir}/jquery-ui.css.erb")
end

desc "Generate the image assets"
task :images do
  target_dir = "vendor/assets/images/jquery-ui"
  FileUtils.mkdir_p target_dir
  FileUtils.cp(Dir.glob("jquery-ui/themes/base/images/*.png"), target_dir)
end

desc "Clean and then generate everything (default)"
task :all => [:clean, :javascripts, :stylesheets, :images]

task :default => :all
