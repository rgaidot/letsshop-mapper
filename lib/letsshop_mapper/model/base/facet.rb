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
        attr_reader :xml

        def initialize(facet = nil)
          @xml = facet
          @title, @type, @filter, @role, @selected, @nhits = nil
          @selected = false
          parse(facet) if facet
        end

        def parse(facet)
          @title = facet['title'].split(":")[1]
          @type = facet['title'].split(":")[0]
          @filter = Filter::new(facet['title'])
          @role = facet['role']
          if facet['nhits']
            @nhits = facet['nhits']
          end
          if facet['selected']
            @selected = LetsShopMapper.Boolean(facet['selected'])
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

