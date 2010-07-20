require 'uri'
require 'net/http'

module LetsShopMapper
  module Connection
    class Base
      attr_reader :server
      attr_reader :key
      attr_reader :response
      attr_reader :xml
      attr_reader :q
      attr_reader :feed
      
      def initialize(server = nil, key = nil)
        @server = server
        @key = key
        @uri = "http://#{@server}/search/#{@key}"
      end
      def connect_and_get()
        begin
          @response = Net::HTTP.get_response(URI.parse(@uri))
          @xml = @response.body
        rescue Exception
          raise LetsShopMapper::RequestBaseSearchException::new
        end
      end
      def find(q = "")
        begin
          @response = Net::HTTP.get_response(URI.parse("#{@uri}/?q=#{q}"))
          @feed = LetsShopMapper::Model::OpenSearch::Feed::new(@response.body)
        rescue Exception
          raise LetsShopMapper::RequestBaseSearchException::new
        end
      end
    end
  end
end