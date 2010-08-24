module LetsShopMapper
  module Model
    module Suggest
      class Item
        attr_reader :text
        attr_reader :type
        attr_reader :nhits
        attr_reader :filter

        def initialize(item = nil)
          @text, @type, @nhits, @filter = nil
          parse(item) if item
        end
        
        def parse(item)
          @text = item.at('text').text
          @type = item.at('text')['type']
          @nhits = item.at('nhits').text
          @filter = Base::Filter::new(item.at('filter')['value'])
        end
        
        def to_s(localtime = true)
          s  = ''
          s += "Text: #{@text}\n"
          s += "Type: #{@type}\n"
          s += "NHits: #{@nhits}\n"
          s += "Filter: \n#{@filter}\n"
        end
      end
    end
  end
end