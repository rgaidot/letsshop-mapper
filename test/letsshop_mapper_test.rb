require 'test_helper'

FIXTURESDIR = "test/fixtures"

module LetsShopMapper
  module Test
    class LetsShopMapperTest < ::Test::Unit::TestCase
      def test_parse_file
        Dir.foreach(FIXTURESDIR) do |f|
          next if f !~ /.xml$/
          puts "Checking #{f}"
          str = File::read(FIXTURESDIR + '/' + f)
          lshopFeed = LetsShopMapper::Model::OpenSearch::Feed::new(str)

          # test lshop
          assert_equal "Search: ", lshopFeed.title
          assert_equal "http://letsshop.dev.happun.com/search/82842d494583280b940b208664f34014", lshopFeed.link
          assert_equal "Search: ", lshopFeed.title
          assert_equal "0", lshopFeed.startindex
          assert_equal "2", lshopFeed.itemsperpage
          assert_equal "228903", lshopFeed.totalresults

          # test entry
          assert_equal "b67ab565e1e0f2661e08845111a2106f", lshopFeed.entries[0].id
          assert_equal "6e0512b7f44299b3e1acb38939cf7d3e", lshopFeed.entries[1].id
          assert_equal "Flirt - Collier en or 750 jaune et diamants", lshopFeed.entries[0].title
          assert_equal "Fauteuil style Louis Philippe en cuir reptile noir", lshopFeed.entries[1].title
          assert_equal "18900.0", lshopFeed.entries[0].price
          assert_equal "15800.0", lshopFeed.entries[1].price

          # test facet
          f =  lshopFeed.entries[0].get_facets_by("universe")
          assert_equal "mode", f[0].title
          assert_equal "universe", f[0].type
          assert_equal "subset", f[0].role
          assert_equal "refine:'universe:mode'", f[0].filter.str_value
          assert_equal false, f[0].selected
        end
      end
      def test_search
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
      def test_example_search_with_yml
        # initializers
        config = YAML.load_file('test/letsshop.yml')['development']
        lshop = LetsShopMapper::Connection::Base::new(config["server"], config["key"])
        # 1) search 
        lshop.find({:q => "jeans"})
        f =  lshop.feed.entries[0].get_facets_by("universe")
        assert_equal "mode", f[0].title
        # 2) search
        lshop.find({:q => "robe noir"})
        f =  lshop.feed.entries[0].get_facets_by("universe")
        assert_equal "mode", f[0].title
        assert_equal "UTF-8", lshop.feed.encoding
        assert_equal "Search: robe  AND noir", lshop.feed.title
        assert_equal "0", lshop.feed.startindex
      end
      def test_facets_feed
        config = YAML.load_file('test/letsshop.yml')['development']
        lshop = LetsShopMapper::Connection::Base::new(config["server"], config["key"])
        lshop.find({:q => "robe"})
        f = lshop.feed.get_facets_by("category")
        assert_equal "robe", f[0].title
        assert_equal "robe courte", f[1].title
      end
      def test_example
        lshop = LetsShopMapper::Connection::Base::new("letsshop.dev.happun.com", "82842d494583280b940b208664f34014")
        lshop.find({:q => "robe", :start => 10, :nhits => 5, :f => "refine:'universe:mode',refine:'gender:femme'"})
        lshop.feed.entries.each { |e| 
          puts "Id: #{e.id}\n"
          puts "Link: #{e.link}\n"
          puts "Title: #{e.title}\n"
          puts "Description: #{e.description}\n"
          puts "Thumbnail: #{e.thumb}\n"
          puts "Price: #{e.price}\n"
          puts "Supplier: #{e.supplier}\n"
          puts "------"
          puts "facets"
          puts "------"
          e.facets.each { |f|
            puts "Title: #{f.title}\n"
            puts "Type: #{f.type}\n"
            puts "Filter: #{f.filter.str_value}\n"
            puts "Role: #{f.role}\n"
            puts "Selected: #{f.selected}\n"
          }
          puts "-----------------------"
        }
      end
      def test_category
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
        puts lshop.feed
      end
      def test_category_find
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
        puts lshop.feed
      end
    end
  end
end