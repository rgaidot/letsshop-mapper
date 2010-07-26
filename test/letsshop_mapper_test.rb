require 'test_helper'

FIXTURESDIR = "test/fixtures"

module LetsShopMapper
  module Test
    class LetsShopMapperTest < ::Test::Unit::TestCase
      def test_search_parse_file
        Dir.foreach(FIXTURESDIR) do |f|
          next if f !~ /letsshop*.xml$/
          puts "Checking #{f}"
          str = File::read(FIXTURESDIR + '/' + f)
          lshopFeed = LetsShopMapper::Model::OpenSearch::Feed::new(str)
          assert_equal "Search: ", lshopFeed.title
          assert_equal "http://letsshop.dev.happun.com/search/82842d494583280b940b208664f34014", lshopFeed.link
          assert_equal "Search: ", lshopFeed.title
          assert_equal "0", lshopFeed.startindex
          assert_equal "2", lshopFeed.itemsperpage
          assert_equal "228903", lshopFeed.totalresults
          f = lshopFeed.get_facets_by("universe")
          assert_equal "mode", f[0].title
          assert_equal "universe", f[0].type
          assert_equal "subset", f[0].role
          assert_equal "225709", f[0].nhits
          assert_equal "b67ab565e1e0f2661e08845111a2106f", lshopFeed.entries[0].id
          assert_equal "6e0512b7f44299b3e1acb38939cf7d3e", lshopFeed.entries[1].id
          assert_equal "Flirt - Collier en or 750 jaune et diamants", lshopFeed.entries[0].title
          assert_equal "Fauteuil style Louis Philippe en cuir reptile noir", lshopFeed.entries[1].title
          assert_equal "18900.0", lshopFeed.entries[0].price
          assert_equal "15800.0", lshopFeed.entries[1].price
          f = lshopFeed.entries[0].get_facets_by("universe")
          assert_equal "mode", f[0].title
          assert_equal "universe", f[0].type
          assert_equal "subset", f[0].role
          assert_equal "universe:mode", f[0].filter.str_value
          assert_equal false, f[0].selected
        end
      end
      def test_search_with_query
        lshop = LetsShopMapper::Connection::Base::new("letsshop.dev.happun.com", "82842d494583280b940b208664f34014")
        lshop.find({:q => "robe", :start => 10, :nhits => 5})
        assert_equal "UTF-8", lshop.feed.encoding
        assert_equal "Search: robe", lshop.feed.title
        assert_equal "10", lshop.feed.startindex
        assert_equal "5", lshop.feed.itemsperpage
        assert_equal "http://letsshop.dev.happun.com/search/82842d494583280b940b208664f34014", lshop.feed.link
        f =  lshop.feed.entries[0].get_facets_by("universe")
        assert_equal "mode", f[0].title
        assert_equal "subset", f[0].role
        f =  lshop.feed.entries[0].get_facets_by("gender")
        assert_equal "femme", f[0].title
      end
      def test_search_with_query_and_yml
        config = YAML.load_file('test/letsshop.yml')['development']
        lshop = LetsShopMapper::Connection::Base::new(config["server"], config["key"])
        lshop.find({:q => "jeans"})
        f =  lshop.feed.entries[0].get_facets_by("universe")
        assert_equal "mode", f[0].title
        lshop.find({:q => "robe noir"})
        f =  lshop.feed.entries[0].get_facets_by("universe")
        assert_equal "mode", f[0].title
        assert_equal "UTF-8", lshop.feed.encoding
        assert_equal "Search: robe  AND noir", lshop.feed.title
        assert_equal "0", lshop.feed.startindex
      end
      def test_search_facets_with_query
        config = YAML.load_file('test/letsshop.yml')['development']
        lshop = LetsShopMapper::Connection::Base::new(config["server"], config["key"])
        lshop.find({:q => "robe"})
        f = lshop.feed.get_facets_by("category")
        assert_equal "robe", f[0].title
        assert_equal "robe courte", f[1].title
      end
      def test_search_by_category
        lshop = LetsShopMapper::Connection::Base::new("letsshop.dev.happun.com", "82842d494583280b940b208664f34014")
        lshop.find({:c => "68446949-6-39989294", :start => 0, :nhits => 2})
        assert_equal "UTF-8", lshop.feed.encoding
        assert_equal "Search: ", lshop.feed.title
        assert_equal "http://letsshop.dev.happun.com/search/82842d494583280b940b208664f34014", lshop.feed.link
        f =  lshop.feed.entries[0].get_facets_by("category")
        assert_equal "chaussure", f[0].title
        assert_equal "subset", f[0].role
        f =  lshop.feed.entries[0].get_facets_by("universe")
        assert_equal "mode", f[0].title
      end
      def test_search_by_category_with_query
        lshop = LetsShopMapper::Connection::Base::new("letsshop.dev.happun.com", "82842d494583280b940b208664f34014")
        lshop.find({:c => "68446949-6-39989294", :q => "escarpin noir",:start => 0, :nhits => 2})
        assert_equal "UTF-8", lshop.feed.encoding
        assert_equal "Search: escarpin  AND noir", lshop.feed.title
        assert_equal "http://letsshop.dev.happun.com/search/82842d494583280b940b208664f34014", lshop.feed.link
        f =  lshop.feed.entries[0].get_facets_by("category")
        assert_equal "chaussure", f[0].title
        assert_equal "subset", f[0].role
        f =  lshop.feed.entries[0].get_facets_by("universe")
        assert_equal "mode", f[0].title
      end
      def test_tree_parse_file
        Dir.foreach(FIXTURESDIR) do |f|
          next if f !~ /tree*.xml$/
          puts "Checking #{f}"
          str = File::read(FIXTURESDIR + '/' + f)
          lshopTree = LetsShopMapper::Model::Tree::Tree::new(str)
          assert_equal "Femme", lshopTree.categories.children[0].children[0].name
          assert_equal "2", lshopTree.categories.children[0].children[0].id.split('-')[1]
          assert_equal "Enfant", lshopTree.categories.children[0].children[2].name
          assert_equal "4", lshopTree.categories.children[0].children[2].id.split('-')[1]
          assert_equal "Manteaux", lshopTree.categories.children[0].children[2].children[5].name
          assert_equal "4084", lshopTree.categories.children[0].children[2].children[5].id.split('-')[1]
          assert_equal "Accessoires", lshopTree.categories.children[0].children[0].children[4].name
          assert_equal "11", lshopTree.categories.children[0].children[0].children[4].id.split('-')[1]
        end
      end
      def test_tree
        config = YAML.load_file('test/letsshop.yml')['development']
        lshop = LetsShopMapper::Connection::Base::new(config["server"], config["key"])
        lshop.get_tree("68446949-6-39989294")
        assert_equal "Escarpins", lshop.tree.categories.children[0].name
        assert_equal "52", lshop.tree.categories.children[0].id.split('-')[1]
        assert_equal "Sandales", lshop.tree.categories.children[1].name
        assert_equal "53", lshop.tree.categories.children[1].id.split('-')[1]
        lshop.get_tree(lshop.tree.categories.children[1].id)
        assert_equal "Sandales a talon", lshop.tree.categories.children[1].name
        assert_equal "3605", lshop.tree.categories.children[1].id.split('-')[1]
      end
      def test_search_special_character
        lshop = LetsShopMapper::Connection::Base::new("letsshop.dev.happun.com", "82842d494583280b940b208664f34014")
        lshop.find({:q => "levi's", :f => "refine:'universe:mode',refine:'gender:enfant',refine:'brand:levi's'", :start => 0, :nhits => 5})
        assert_equal "UTF-8", lshop.feed.encoding
        ff =  lshop.feed.get_facets_by("brand")
        assert_equal true, lshop.feed.facets[0].selected
        f =  lshop.feed.entries[0].get_facets_by("brand")
        assert_equal "levi's", f[0].title
        lshop.find({:f => "refine:'brand:levi's'", :start => 0, :nhits => 5})
        f =  lshop.feed.entries[0].get_facets_by("brand")
        assert_equal "levi's", f[0].title
      end
      def test_search_product
        lshop = LetsShopMapper::Connection::Base::new("letsshop.dev.happun.com", "82842d494583280b940b208664f34014")
        lshop.find({:producs => "b67ab565e1e0f2661e08845111a2106f"})
        assert_equal "UTF-8", lshop.feed.encoding
        assert_equal "b67ab565e1e0f2661e08845111a2106f", lshop.feed.entries[0].id
        assert_equal "Flirt - Collier en or 750 jaune et diamants", lshop.feed.entries[0].title
      end
      def test_tree_filters
        Dir.foreach(FIXTURESDIR) do |f|
          next if f !~ /tree*.xml$/
          puts "Checking #{f}"
          str = File::read(FIXTURESDIR + '/' + f)
          lshopTree = LetsShopMapper::Model::Tree::Tree::new(str)
          assert_equal "Femme", lshopTree.categories.children[0].children[0].name
          assert_equal "2", lshopTree.categories.children[0].children[0].id.split('-')[1]
          assert_equal "gender", lshopTree.categories.children[0].children[0].filters[0].key
          assert_equal "femme", lshopTree.categories.children[0].children[0].filters[0].value
        end
      end
    end
  end
end