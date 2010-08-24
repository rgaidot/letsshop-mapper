require 'rubygems'
require 'tempfile'
require 'nokogiri'

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
      autoload :Tree, "letsshop_mapper/model/tree/tree"
    end
    module Suggest
      autoload :Suggest, "letsshop_mapper/model/suggest/suggest"
      autoload :Item, "letsshop_mapper/model/suggest/item"
    end
  end
  def self.Boolean(string)
    return true if string == true || string =~ /^true$/i
    return false if string == false || string.nil? || string =~ /^false$/i
    raise ArgumentError.new("invalid value for Boolean: \"#{string}\"")
  end
end
