module LetsShopMapper
  module Model
    module OpenSearch
      class Feed
        attr_reader :title 
        attr_reader :link 
        attr_reader :entries
        attr_reader :startindex
        attr_reader :itemsperpage
        attr_reader :totalresults

        attr_reader :xml
        attr_reader :encoding

        def initialize(str = nil)
          @title, @link, @encoding = nil
          @entries = []
          parse(str) if str
        end

        def parse(str)
          doc = REXML::Document.new(str)
          @xml = doc.root
          @encoding = doc.encoding
          if doc.root.elements['/feed']
            if (e = doc.root.elements['/feed/title']) && e.text
              @title = e.text
            end
            if (e = doc.root.elements['/feed/link'])
              @link = e.attribute('href').value
            end
            if (e = doc.root.elements['/feed/startIndex']) && e.text
              @startindex = e.text
            end
            if (e = doc.root.elements['/feed/itemsPerPage']) && e.text
              @itemsperpage = e.text
            end
            if (e = doc.root.elements['/feed/totalResults']) && e.text
              @totalresults = e.text
            end
            # Entries
            doc.root.each_element('/feed/entry') do |e|
               @entries << Entry::new(e, self)
            end
          else
            raise LetsShopMapper::UnknownFeedTypeException::new
          end
        end

        def to_s(localtime = true)
          s  = ''
          s += "Encoding: #{@encoding}\n"
          s += "Title: #{@title}\n"
          s += "Link: #{@link}\n"
          s += "\n"
          @entries.each { |i| s += i.to_s(localtime) }
          s
        end
      end
    end
  end
end

