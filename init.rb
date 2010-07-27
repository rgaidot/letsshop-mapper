require 'letsshop_mapper'
letsshop_config = YAML.load_file("#{RAILS_ROOT}/config/letsshop.yml")[Rails.env]
LSHOP = LetsShopMapper::Connection::Base::new(letsshop_config["server"], letsshop_config["key"])