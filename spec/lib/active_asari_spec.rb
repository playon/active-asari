require 'lib/active_asari_spec_data'
include ActiveAsariSpecData
require 'spec_helper'

describe 'active_record' do

  context 'asari index' do 
    it 'should call asari index with the correct parameters' do
      TestModel.should_receive(:asari_index).with('test-test-model-7yopqryvjnumbe547ha7xhmjwi', [:name, :amount, :last_updated, :bee_larvae_type])
      ENV['RACK_ENV'] = 'development' 
      ActiveAsari.should_receive(:asari_domain_name).and_return 'test-test-model-7yopqryvjnumbe547ha7xhmjwi'
      TestModel.send(:active_asari_index, 'TestModel')
    end 
  end

  context 'models' do
    it 'should add new records to cloud search' do
      asari_instance = double 'asari instance'
      asari_instance.should_receive(:update_item).with(1, {:name => 'test', :amount => 2, :last_updated => nil, :bee_larvae_type => nil})
      asari_instance.should_receive(:add_item).with(1, {:name => 'test', :amount => 2, :last_updated => '', :bee_larvae_type => ''})
      TestModel.class_variable_set(:@@asari_when, nil)
      TestModel.class_variable_set(:@@asari_fields, [:name, :amount, :last_updated, :bee_larvae_type])
      TestModel.class_variable_set(:@@asari_instance, asari_instance)
      CreateTestModel.up 
      model = TestModel.create :name => 'test', :amount => 2
      model.save
    end


    after do 
      CreateTestModel.down
    end
  end

  context 'asari_domain_name' do
    it 'should get the correct domain name' do
      aws_client = double 'AWS Client'
      aws_client.should_receive(:describe_domains).and_return DESCRIBE_DOMAINS_RESPONSE 
      ActiveAsari.should_receive(:aws_client).and_return aws_client
      ActiveAsari.asari_domain_name('lance-event').should eq 'test-lance-event-7yopqryvjnumbe547ha7xhmjwi'
    end
  end

  context 'search' do
    it 'should search for all available fields for a item' do
      ActiveAsari.should_receive(:asari_domain_name).with('TestModel').and_return('test-model-666')
      asari = double('Asari')
      asari.should_receive(:search).with('foo', :return_fields => [:name, :amount, :last_updated, :bee_larvae_type]).and_return(
        {'33' => {'name' => ['beavis'], 'amount' => ['22'], 'last_updated' => ['4543457887875']}}) 
        Asari.should_receive(:new).with('test-model-666').and_return asari
        ActiveAsari.active_asari_search 'TestModel', 'foo'
    end
  end
end
