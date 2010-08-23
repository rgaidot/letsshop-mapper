module LetsShopMapper
  module Model
    module Tree
      class Tree
        attr_reader :categories
        attr_reader :xml

        def initialize(str = nil)
          parse(str) if str
        end
        
        def parse(str)
          @xml = Nokogiri::XML(str)
          if @xml.at('/categories')
            @xml.xpath('/categories/category').each do |c|
              @categories = Base::Category::new
              @categories.recurse(c, @categories)
            end
          elsif @xml.at('/category')
            @xml.xpath('/category').each do |c|
              @categories = Base::Category::new
              @categories.recurse(c, @categories)
            end            
          else
            raise LetsShopMapper::Error::UnknownFeedTypeException::new
          end
        end
        
        def to_s(localtime = true)
          s = @categories.to_s(localtime)
        end
      end
    end
  end
end