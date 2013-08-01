require 'active_record'
require 'rspec'
require 'factory_girl'
require 'rspec/autorun'
db_config = YAML.load_file(File.expand_path(File.dirname(__FILE__)) + '/database.yml')
ActiveRecord::Base.establish_connection db_config['test']

ActiveRecord::Base.connection

ACTIVE_ASARI_CONFIG = YAML.load_file(File.expand_path(File.dirname(__FILE__)) + '/active_asari.yml')
ACTIVE_ASARI_SEARCH_DOMAIN = 'my_great_domain'
Dir[File.dirname(__FILE__) + "/../lib/active_asari/*.rb"].each {|file| require file }
require 'active_asari'
require 'active_asari/active_record'
require 'asari'
require 'aws'
require 'model/test_model'
require 'model/create_test_model'

