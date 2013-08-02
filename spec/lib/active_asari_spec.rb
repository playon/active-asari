require 'spec_helper'

describe 'active_record' do

  it 'should call asari index with the correct parameters' do
    TestModel.should_receive(:asari_index).with('test-model', [:name, :amount, :last_updated]) 
    TestModel.send(:active_asari_index, 'TestModel')
  end 

  context 'models' do
    it 'should add new records to cloud search' do
      asari_instance = double 'asari instance'
      asari_instance.should_receive(:update_item).with(1, {:name => 'test', :amount => 2, :last_updated => nil})
      asari_instance.should_receive(:add_item).with(1, {:name => 'test', :amount => 2, :last_updated => ''})
      orig_asari_instance = TestModel.class_variable_get :@@asari_instance
      TestModel.class_variable_set(:@@asari_instance, asari_instance)
      CreateTestModel.up 
      model = TestModel.create :name => 'test', :amount => 2
      model.save
      TestModel.class_variable_set(:@@asari_instance, orig_asari_instance) 
    end


    after do 
      CreateTestModel.down
    end
  end

  context 'migrations' do

  end
end
