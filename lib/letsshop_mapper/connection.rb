require 'uri'
require "cgi"
require 'net/http'

module LetsShopMapper
  module Connection
    class Base
      attr_reader :server
      attr_reader :key
      attr_reader :response

      attr_reader :feed
      attr_reader :tree
      
      def initialize(server = nil, key = nil)
        @server = server
        @key = key
      end
      def connect_and_get()
        uri = "http://#{@server}/search/#{@key}"
        begin
          @response = Net::HTTP.get_response(URI.parse(uri))
          @feed = @response.body
        rescue Exception
          raise LetsShopMapper::RequestBaseSearchException::new
        end
      end
      def find(conditions = {})
        uri = "http://#{@server}/search/#{@key}"
        query = "?"
        query << "q=#{CGI.escape(conditions[:q])}" if conditions[:q] != nil
        query << "&start=#{conditions[:start]}" if conditions[:start] != nil
        query << "&nhits=#{conditions[:nhits]}" if conditions[:nhits] != nil
        query << "&f=#{CGI.escape(conditions[:f].gsub(/\047/,"\""))}" if conditions[:f] != nil
        query << "&c=#{CGI.escape(conditions[:c])}" if conditions[:c] != nil
        query << "&sort=#{CGI.escape(conditions[:sort])}" if conditions[:sort] != nil
        begin
          @response = Net::HTTP.get_response(URI.parse("#{uri}/#{query}"))
          @feed = LetsShopMapper::Model::OpenSearch::Feed::new(@response.body)
        rescue Exception
          raise LetsShopMapper::Error::RequestBaseSearchException::new
        end
      end
      def get_tree(category = nil)
        uri = "http://#{@server}/tree/#{@key}"
        id = "#{category}" if category != nil
        begin
          @response = Net::HTTP.get_response(URI.parse("#{uri}/#{id}"))
          @tree = LetsShopMapper::Model::Tree::Tree::new(@response.body)
        rescue Exception
          raise LetsShopMapper::Error::RequestBaseSearchException::new
        end
      end
    end
  end
end