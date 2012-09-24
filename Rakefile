require 'json'
require 'bundler/gem_tasks'

DEPENDENCY_HASH = JSON.load(File.read('dependencies.js'))
# Fix dependencies. https://github.com/joliss/jquery-ui-rails/issues/1#issuecomment-8512917
DEPENDENCY_HASH['ui.dialog.js'].concat ['ui.draggable.js', 'ui.resizable.js']

LANGUAGE_REGEX = /-[-a-zA-Z]+(?=\.js\z)/

def version
  JSON.load(File.read('jquery-ui/package.json'))['version']
end

task :submodule do
  sh 'git submodule update --init' unless File.exist?('jquery-ui/README.md')
end

def get_js_dependencies(basename)
  if basename.match LANGUAGE_REGEX
    # This is an i18n file. We used to depend on the main module for i18n
    # files, but this slows down asset precompilation.
    # https://github.com/joliss/jquery-ui-rails/issues/9
    []
  else
    dependencies = DEPENDENCY_HASH[basename.sub(/\Ajquery\./, '')]
    if dependencies.nil?
      puts "Warning: No dependencies found for #{basename}"
      dependencies = []
    end
    dependencies = dependencies
      .reject { |dep| dep == 'theme' } # 'theme' pseudo-dependency handled by CSS
      .map { |dep| "jquery.#{dep}" }
    # Make sure we do not package assets with broken dependencies
    dependencies.each do |dep|
      fail "#{basename}: missing #{dep}" unless File.exist? "jquery-ui/ui/#{dep}"
    end
    dependencies
  end
end

def remove_js_extension(path)
  path.chomp(".js")
end

def protect_copyright_notice(source_code)
  # YUI does not minify comments starting with "/*!"
  # The i18n files start with non-copyright comments, so we require a newline
  # to avoid protecting those
  source_code.gsub!(/\A\s*\/\*\r?\n/, "/*!\n")
end

desc "Remove the vendor directory"
task :clean do
  rm_rf 'vendor'
end

desc "Generate the JavaScript assets"
task :javascripts => :submodule do
  target_dir = "vendor/assets/javascripts"
  mkdir_p target_dir
  Rake.rake_output_message 'Generating javascripts'
  Dir.glob("jquery-ui/ui/**/*.js").each do |path|
    basename = File.basename(path)
    dep_modules = get_js_dependencies(basename).map(&method(:remove_js_extension))
    dep_modules << 'jquery' if basename == 'jquery.ui.core.js'
    File.open("#{target_dir}/#{basename}", "w") do |out|
      dep_modules.each do |mod|
        out.write("//= require #{mod}\n")
      end
      out.write("\n") unless dep_modules.empty?
      source_code = File.read(path)
      source_code.gsub!('@VERSION', version)
      protect_copyright_notice(source_code)
      out.write(source_code)
    end
  end
  File.open("#{target_dir}/jquery.effects.all.js", "w") do |out|
    Dir.glob("jquery-ui/ui/jquery.effects.*.js").sort.each do |path|
      asset_name = remove_js_extension(File.basename(path))
      out.write("//= require #{asset_name}\n")
    end
  end
  File.open("#{target_dir}/jquery.ui.all.js", "w") do |out|
    Dir.glob("jquery-ui/ui/*.js").sort.each do |path|
      asset_name = remove_js_extension(File.basename(path))
      out.write("//= require #{asset_name}\n")
    end
  end
end

desc "Generate the CSS assets"
task :stylesheets => :submodule do
  target_dir = "vendor/assets/stylesheets"
  mkdir_p target_dir
  Rake.rake_output_message 'Generating stylesheets'
  Dir.glob("jquery-ui/themes/base/*.css").each do |path|
    basename = File.basename(path)
    source_code = File.read(path)
    source_code.gsub!('@VERSION', version)
    protect_copyright_notice(source_code)
    extra_dependencies = []
    extra_dependencies << 'jquery.ui.core' unless basename =~ /\.(all|base|core)\./
    # Is "theme" listed among the dependencies for the matching JS file?
    unless basename =~ /\.(all|base|core|theme)\./
      dependencies = DEPENDENCY_HASH[basename.sub(/\Ajquery\./, '').sub(/\.css/, '.js')]
      if dependencies.nil?
        puts "Warning: No matching JavaScript dependencies found for #{basename}"
      else
        extra_dependencies << 'jquery.ui.theme' if dependencies.include? 'theme'
      end
    end
    extra_dependencies.reverse.each do |dep|
      # Add after first comment block
      source_code = source_code.sub(/\A((.*?\*\/\n)?)/m, "\\1/*\n *= require #{dep}\n */\n")
    end
    # Use "require" instead of @import
    source_code.gsub!(/^@import (.*)$/) { |s|
      m = s.match(/^@import (url\()?"(?<module>[-_.a-zA-Z]+)\.css"\)?;/) \
        or fail "Cannot parse import: #{s}"
      "/*\n *= require #{m['module']}\n */"
    }
    # Be cute: collapse multiple require comment blocks into one
    source_code.gsub!(/^( \*= require .*)\n \*\/(\n+)\/\*\n(?= \*= require )/, '\1\2')
    # Replace hard-coded image URLs with asset path helpers
    source_code.gsub!(/url\(images\/([-_.a-zA-Z0-9]+)\)/, 'url(<%= image_path("jquery-ui/\1") %>)')
    File.open("#{target_dir}/#{basename}.erb", "w") do |out|
      out.write(source_code)
    end
  end
end

desc "Generate the image assets"
task :images => :submodule do
  target_dir = "vendor/assets/images/jquery-ui"
  mkdir_p target_dir
  Rake.rake_output_message 'Copying images'
  FileUtils.cp(Dir.glob("jquery-ui/themes/base/images/*.png"), target_dir)
end

desc "Clean and then generate everything (default)"
task :assets => [:clean, :javascripts, :stylesheets, :images]

task :build => :assets

task :default => :assets
