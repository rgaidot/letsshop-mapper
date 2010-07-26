include REXML
module LetsShopMapper
  module Model
    module Base
      class Category
        attr_accessor :id
        attr_accessor :name
        attr_reader :children
        attr_reader :filters

        def initialize()
          @id, @name = nil
          @children = []
          @filters = []
        end
        def recurse(category, par = nil)
          category.each_child_element do |child|
            if child.name == "category"
              chl = add_category(child)
              par.children << chl
            elsif child.name == "filter"
              par.filters << Filter::new(child.attributes.get_attribute("value"))
            end
            recurse(child, chl)
          end
        end
        def add_category(category)
          c = Category::new
          c.name = category.elements['name'].text
          c.id = category.elements['name'].attributes.get_attribute("id").value
          return c
        end
        def to_map
          {@name => @children.empty? ? nil : @children.map {|child| child.to_map}}
        end
        def to_s(localtime = true)
          self.to_map.to_yaml
        end
      end
    end
  end
end