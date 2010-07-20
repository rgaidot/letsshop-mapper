module LetsShopMapper
  module Model
    module Base
      class Facet
        attr_reader :title
        attr_reader :type
        attr_reader :filter
        attr_reader :role
        attr_reader :selected

        attr_reader :feed
        attr_reader :xml

        def initialize(facet = nil, feed = nil)
          @feed = feed
          @xml = facet
          @title, @type, @filter, @role, @selected = nil
          @selected = false
          parse(facet) if facet
        end

        def parse(facet)
          @title = facet.attributes.get_attribute("title").value.split(":")[1]
          @type = facet.attributes.get_attribute("title").value.split(":")[0]   
          @filter = Filter::new(facet.attributes.get_attribute("searchTerms"))
          @role = facet.attributes.get_attribute("role").value
        end

        def to_s(localtime = true)
          s  = ''
          s += "Title: #{@title}\n"
          s += "Type: #{@type}\n"
          s += "Filter: #{@filter}\n"
          s += "Role: #{@role}\n"
          s += "Selected: #{@selected}\n"
          s += "\n"
        end
      end
    end
  end
end

