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
      attr_reader :suggest
      
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
        query << "&products=#{conditions[:products]}" if conditions[:products] != nil
        query << "&start=#{conditions[:start]}" if conditions[:start] != nil
        query << "&nhits=#{conditions[:nhits]}" if conditions[:nhits] != nil
        if conditions[:f] != nil
          refine = ""
          refine_splited = conditions[:f].split(',')
          refine_splited.each do |f|
            refine << f.gsub(/(refine:||refine:\()+(\047)(.+)(\047)/, '\1"\3"').gsub(/(\047) (OR||AND) (\047)/, '" \2 "')
            refine << "," unless f == refine_splited.last
          end
          query << "&f=#{CGI.escape(refine)}"
        end
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
      
      def do_suggest(word = nil)
        uri = "http://#{@server}/suggest/#{@key}"
        begin
          @response = Net::HTTP.get_response(URI.parse("#{uri}/?q=#{word}"))
          @suggest = LetsShopMapper::Model::Suggest::Suggest::new(@response.body)
        rescue Exception
          raise LetsShopMapper::Error::RequestBaseSearchException::new
        end
      end
    end
  end
end