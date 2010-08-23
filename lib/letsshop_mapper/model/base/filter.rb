module LetsShopMapper
  module Model
    module Base
      class Filter
        attr_reader :key
        attr_reader :value
        attr_reader :str_value

        def initialize(filtr = nil)
          @key, @value, @str_value = nil
          @position = 0
          @depend = false
          parse(filtr) if filtr
        end

        def parse(filtr)
          @str_value = filtr
          @key = filtr.split(":")[0]
          @value = filtr.split(":")[1]
        end

        def to_s(localtime = true)
          s  = ''
          s += "Key: #{@key}\n"
          s += "Value: #{@value}\n"
          s += "Filter: #{@str_value}\n"
          s += "\n"
        end
      end
    end
  end
end