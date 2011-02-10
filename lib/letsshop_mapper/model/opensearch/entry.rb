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
        attr_reader :delivery_times
        attr_reader :product_condition

        def initialize(entry = nil)
          @id, @link, @title, @description, @price, @thumb, @supplier, @delivery_times, @product_condition = nil
          @facets = []
          parse(entry) if entry
        end

        def parse(entry)
          @id = entry.at('id').text
          @link = entry.at('link')['href']
          @title = entry.at('title').text
          @description = entry.at('description').text
          @thumb =entry.at('letsshop/thumb').text
          @price = entry.at('letsshop/price').text
          @currency = entry.at('letsshop/price')['currency']
          @discount = entry.at('letsshop/price')['discount']
          @older_price = entry.at('letsshop/price')['older']
          @delivery_times = entry.at('letsshop/delivery_times').text
          @product_condition = entry.at('letsshop/product_condition').text
          
          entry.children.search('Query').each do |f|
            @facets << Base::Facet::new(f)
            if !f['title'].index("supplier:").nil?
              @supplier = f['title'].gsub("supplier:","")
            end
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
          s += "Delivery times: #{@delivery_times}\n"
          s += "Product condition: #{@product_condition}\n"
          s += "Thumbnail: #{@thumb}\n"
          s += "Price: #{@price} #{@currency}\n"
          s += "Discount: #{@older_price} (#{@discount})\n"
          s += "Supplier: #{@supplier}\n"
          s += "----------------------------------\n"
          @facets.each { |i| s += i.to_s(localtime) }
          s += "\n"
        end
      end
    end
  end
end

