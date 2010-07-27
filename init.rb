require 'letsshop_mapper'
letsshop_config = "#{RAILS_ROOT}/config/letsshop.yml"
LSHOP = LetsShopMapper::Connection::Base::new(letsshop_config["server"], letsshop_config["key"])