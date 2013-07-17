class TestModel < ActiveRecord::Base
  include Asari::ActiveRecord
  include ActiveAsari::ActiveRecord
  active_asari_index 'TestModel'
end
