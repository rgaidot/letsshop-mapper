module LetsShopMapper
  class Error < StandardError; end
  class UnknownFeedTypeException < Error; end
  class RequestBaseSearchException < Error; end
end