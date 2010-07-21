# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{letsshop-mapper}
  s.version = "0.3.0beta"

  s.required_rubygems_version = Gem::Requirement.new("> 1.3.1") if s.respond_to? :required_rubygems_version=
  s.authors = ["happun"]
  s.date = %q{2010-07-21}
  s.description = %q{Let's Shop Mapper is a Ruby library that allows to search and parse on Let's Shop Service.}
  s.email = %q{dev@happun.com}
  s.extra_rdoc_files = ["README.rdoc", "LICENSE"]
  s.files = ["README.rdoc", "LICENSE", "Rakefile", "lib/", "lib/letsshop_mapper.rb", "lib/letsshop_mapper", "lib/letsshop_mapper/version.rb", "lib/letsshop_mapper/model", "lib/letsshop_mapper/model/tree", "lib/letsshop_mapper/model/tree/tree.rb", "lib/letsshop_mapper/model/opensearch", "lib/letsshop_mapper/model/opensearch/feed.rb", "lib/letsshop_mapper/model/opensearch/entry.rb", "lib/letsshop_mapper/model/base", "lib/letsshop_mapper/model/base/filter.rb", "lib/letsshop_mapper/model/base/facet.rb", "lib/letsshop_mapper/model/base/category.rb", "lib/letsshop_mapper/exceptions.rb", "lib/letsshop_mapper/connection.rb", "test/", "test/test_helper.rb", "test/letsshop_mapper_test.rb", "test/letsshop.yml", "test/fixtures"]
  s.homepage = %q{http://github.com/rgaidot/letsshop-mapper}
  s.rdoc_options = ["--all --diagram --inline-source --line-numbers", "README.rdoc"]
  s.require_paths = ["lib"]
  s.requirements = ["none"]
  s.rubyforge_project = %q{letsshop-mapper}
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Let's Shop Mapper is a Ruby library that allows to search and parse on Let's Shop Service}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
