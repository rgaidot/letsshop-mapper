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
      def test_search_jupe
        # initialize
        lshop = LetsShopMapper::Connection::Base::new("letsshop.dev.happun.com", "82842d494583280b940b208664f34014")
        lshop.find("jupe")
        assert_equal "UTF-8", lshop.feed.encoding
        assert_equal "Search: jupe", lshop.feed.title
        assert_equal "0", lshop.feed.startindex
        assert_equal "http://letsshop.dev.happun.com/search/82842d494583280b940b208664f34014", lshop.feed.link
        f =  lshop.feed.entries[0].get_facets_by("universe")
        assert_equal "mode", f[0].title
        assert_equal "subset", f[0].role
      end
      def test_search_robe
        lshop = LetsShopMapper::Connection::Base::new("letsshop.dev.happun.com", "82842d494583280b940b208664f34014")
        lshop.find("robe")
        assert_equal "UTF-8", lshop.feed.encoding
        assert_equal "Search: robe", lshop.feed.title
        assert_equal "0", lshop.feed.startindex
        assert_equal "http://letsshop.dev.happun.com/search/82842d494583280b940b208664f34014", lshop.feed.link
        f =  lshop.feed.entries[0].get_facets_by("universe")
        assert_equal "mode", f[0].title
        assert_equal "subset", f[0].role
        f =  lshop.feed.entries[0].get_facets_by("gender")
        assert_equal "fille", f[0].title
        assert_equal "enfant", f[1].title
      end
    end
  end
end