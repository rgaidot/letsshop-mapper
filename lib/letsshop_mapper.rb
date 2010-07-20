require 'rubygems'
require 'tempfile'
require 'rexml/document'

module LetsShopMapper
  autoload :Version, "letsshop_mapper/version"
  autoload :Connection, "letsshop_mapper/connection"
  autoload :Error, "letsshop_mapper/exceptions"
  module Model
    module Base
      autoload :Facet, "letsshop_mapper/model/base/facet"
      autoload :Category, "letsshop_mapper/model/base/category"
      autoload :Filter, "letsshop_mapper/model/base/filter"
    end
    module OpenSearch
      autoload :Feed, "letsshop_mapper/model/opensearch/feed"
      autoload :Entry, "letsshop_mapper/model/opensearch/entry"
    end
    module Tree
      autoload :Tree, "letsshop_mapper/model/Tree/tree"
    end
  end
end
