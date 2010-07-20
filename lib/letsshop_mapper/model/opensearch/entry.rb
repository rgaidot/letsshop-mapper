module LetsShopMapper
  module Model
    module OpenSearch
      class Entry
        attr_reader :id
        attr_reader :link
        attr_reader :title
        attr_reader :description
        attr_reader :price
        attr_reader :currency
        attr_reader :discount
        attr_reader :older_price
        attr_reader :thumb
        attr_reader :supplier
        attr_reader :facets

        attr_reader :feed
        attr_reader :xml

        def initialize(entry = nil, feed = nil)
          @feed = feed
          @xml = entry
          @id, @link, @title, @description, @price, @thumb, @supplier = nil
          @facets = []
          parse(entry) if entry
        end

        # parse entry
        def parse(entry)
          @id = entry.elements["id"].text
          if (e = entry.elements['link'])
            @link = e.attribute('href').value
          end
          if (e = entry.elements['title']) && e.text
            @title = e.text
          end
          if (e = entry.elements['description']) && e.text
            @description = e.text
          end
          if (e = entry.elements['letsshop/thumb'])
            @thumb = e.text
          end
          if (e = entry.elements['letsshop/price']) && e.text
            @price = e.text
            @currency = e.attributes.get_attribute("currency").value
            @discount = e.attributes.get_attribute("discount").value
            @older = e.attributes.get_attribute("older").value
          end
          entry.each_element('Query') do |f|
            if !f.attributes.get_attribute("title").value.index("supplier:").nil?
              @supplier =  f.attributes.get_attribute("title").value.gsub("supplier:","")
            end
          end
          entry.each_element('Query') do |e|
             @facets << Base::Facet::new(e, self)
          end
        end

        def get_facets_by(scope)
          results = []
          @facets.each { |f| 
            if f.type == scope 
              then results << f end }
          return results
        end

        def to_s(localtime = true)
          s  = ''
          s += "Id: #{@id}\n"
          s += "Link: #{@link}\n"
          s += "Title: #{@title}\n"
          s += "Description: #{@description}\n"
          s += "Thumbnail: #{@thumb}\n"
          s += "Price: #{@price} #{@currency}\n"
          s += "Discount: #{@older} (#{@discount})\n"
          s += "Supplier: #{@supplier}\n"
          s += "----------------------------------\n"
          @facets.each { |i| s += i.to_s(localtime) }
          s += "\n"
        end
      end
    end
  end
end

