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
        attr_reader :facets
        attr_reader :xml
        attr_reader :encoding

        def initialize(str = nil)
          @title, @link, @encoding = nil
          @entries = []
          @facets = []
          parse(str) if str
        end

        def parse(str)
          @xml = Nokogiri::XML(str)
          @encoding = @xml.encoding
          if @xml.at('/xmlns:feed')
            @title = @xml.at('/xmlns:feed/xmlns:title').text
            @link = @xml.at('/xmlns:feed/xmlns:link')['href']
            @startindex =  @xml.at('/xmlns:feed/xmlns:startIndex').text
            @itemsperpage =  @xml.at('/xmlns:feed/xmlns:itemsPerPage').text
            @totalresults =  @xml.at('/xmlns:feed/xmlns:totalResults').text
            # Facets
            @xml.xpath('/xmlns:feed/xmlns:Query[@role="subset"]').each do |f|
               @facets << Base::Facet::new(f)
            end
            # Entries
            @xml.xpath('/xmlns:feed/xmlns:entry').each do |e|
               @entries << Entry::new(e)
            end
          else
            raise LetsShopMapper::Error::UnknownFeedTypeException::new
          end
        end
        
        def get_facets_by(scope)
          results = []
          @facets.each { |f| if f.type == scope then results << f end }
          return results
        end
        
        def to_s(localtime = true)
          s  = ''
          s += "Encoding: #{@encoding}\n"
          s += "Title: #{@title}\n"
          s += "Link: #{@link}\n"
          s += "Entries:\n"
          @entries.each { |i| s += i.to_s(localtime) }
          s += "Facets\n"
          @facets.each { |i| s += i.to_s(localtime) }
          s += "\n"
        end
      end
    end
  end
end

