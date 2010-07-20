require 'rubygems'
require 'rake'
require 'rake/rdoctask'
require 'rake/testtask'
require 'rake/gempackagetask'
require 'find'

require File.expand_path('../lib/letsshop_mapper/version', __FILE__)

PKGNAME = 'letsshop-mapper'
PKGVERSION = LetsShopMapper::Version

PKGFILES = [ 'README.rdoc', 'LICENSE', 'Rakefile' ]
Find.find('lib/', 'test/') do |f|
  if FileTest.directory?(f) and f =~ /\.svn/
    Find.prune
  else
    PKGFILES << f
  end
end

PKGFILES.reject! { |f| f =~ /^test\/(fixtures|.*_output)\// }

desc 'Default: run unit tests'
task :default => [:test]

desc 'Create gemspec file'
task :gemspec do
  spec = Gem::Specification.new do |s|
    s.platform = Gem::Platform::RUBY
    s.author = 'happun'
    s.email = 'dev@happun.com'
    s.homepage = 'http://github.com/rgaidot/letsshop-mapper'
    s.summary = "Let's Shop Mapper is a Ruby library that allows to search and parse on Let's Shop Service"
    s.name = PKGNAME
    s.version = PKGVERSION
    s.requirements << 'none'
    s.require_path = 'lib'
    s.has_rdoc = true
    s.extra_rdoc_files = ['README.rdoc', 'LICENSE']
    s.rdoc_options << '--all --diagram --inline-source --line-numbers' << 'README.rdoc'
    s.files = PKGFILES
    s.description = "Let's Shop Mapper is a Ruby library that allows to search and parse on Let's Shop Service."
  end
  File.open("#{spec.name}.gemspec", "w") do |f|
    f.write spec.to_ruby
  end
end

desc 'Builds the gem'
task :install => :gemspec do
  system "gem build letsshop-mapper.gemspec"
end

desc 'Clean Up'
task :clean do |t|
  FileUtils.rm_rf "doc"
  FileUtils.rm_rf "pkg"
end

desc 'Generate documentation for the letsshop_mapper plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = "doc"
  rdoc.title    = "Let's Shop Mapper"
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

desc 'Package letsshop_mapper plugin.'
Rake::PackageTask.new(PKGNAME, PKGVERSION) do |p| 
  p.need_tar = true
  p.need_zip = true
  p.package_files = PKGFILES
end

desc 'Test the letsshop_mapper plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end