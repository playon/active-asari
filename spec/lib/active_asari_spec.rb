require 'spec_helper'

describe 'active_record' do

  it 'should add new records to cloud search' do
    asari_instance = double 'asari instance'
    asari_instance.should_receive(:update_item).with(1, {:name => 'test', :amount => 2})
    asari_instance.should_receive(:add_item).with(1, {:name => 'test', :amount => 2})
    TestModel.class_variable_set(:@@asari_instance, asari_instance)
    CreateTestModel.up 
    model = TestModel.create :name => 'test', :amount => 2
    model.save
  end

  after do 
    CreateTestModel.down
  end
end
