module LetsShopMapper
  module Model
    module Base
      class Facet
        attr_reader :title
        attr_reader :type
        attr_reader :filter
        attr_reader :role
        attr_reader :selected
        attr_reader :nhits

        attr_reader :feed
        attr_reader :xml

        def initialize(facet = nil, feed = nil)
          @feed = feed
          @xml = facet
          @title, @type, @filter, @role, @selected, @nhits = nil
          @selected = false
          parse(facet) if facet
        end

        def parse(facet)
          @title = facet.attributes.get_attribute("title").value.split(":")[1]
          @type = facet.attributes.get_attribute("title").value.split(":")[0]   
          @filter = Filter::new(facet.attributes.get_attribute("title"))
          @role = facet.attributes.get_attribute("role").value
          if facet.attributes.get_attribute("nhits")
            @nhits = facet.attributes.get_attribute("nhits").value
          end
          if facet.attributes.get_attribute("selected")
            @selected = LetsShopMapper.Boolean(facet.attributes.get_attribute("selected").value)
          end
        end

        def to_s(localtime = true)
          s  = ''
          s += "Title: #{@title}\n"
          s += "Type: #{@type}\n"
          s += "Filter: #{@filter.str_value}\n"
          s += "Role: #{@role}\n"
          s += "Selected: #{@selected}\n"
          s += "nhits: #{@nhits}\n"
          s += "\n"
        end
      end
    end
  end
end

