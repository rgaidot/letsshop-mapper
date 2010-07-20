module LetsShopMapper
  module Model
    module Base
      class Category
        attr_reader :id
        attr_reader :name
        attr_reader :filters

        attr_reader :xml

        def initialize(category = nil)
          @xml = category
          @id, @name = nil
          @filters = [] 
          parse(category) if category
        end

        def parse(category)
        end
      end
    end
  end
end