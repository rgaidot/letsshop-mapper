module LetsShopMapper
  module Model
    module Suggest
      class Suggest
        attr_reader :items
        attr_reader :xml

        def initialize(suggest = nil)
          @items = []
          parse(suggest) if suggest
        end
        
        def parse(suggest)
          @xml = Nokogiri::XML(suggest)
          if @xml.at('suggest')
            @xml.xpath('suggest/item').each do |c|
              @items << Item::new(c)
            end
          else
            raise LetsShopMapper::Error::UnknownFeedTypeException::new
          end
        end
        
        def to_s(localtime = true)
          s = 'dddd'
          @items.each { |i| s += i.to_s(localtime) }
        end
      end
    end
  end
end