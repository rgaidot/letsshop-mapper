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
          doc = REXML::Document.new(str)
          @xml = doc.root
          if doc.root.elements['/categories']
            doc.root.each_element('/categories/category') do |c|
              @categories = Base::Category::new
              @categories.recurse(c, @categories)
            end
          elsif doc.root.elements['/category']
            doc.root.each_element('/category') do |c|
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