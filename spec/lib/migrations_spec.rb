require 'spec_helper'
require 'lib/migrations_spec_data'
include MigrationsSpecData

describe 'migrations' do

  let(:migrations) {ActiveAsari::Migrations.new}

  before :each do
      
  end

  context 'index_field' do
    it 'should add a literal index to the domain' do
      expected_index_field_request = {:domain_name => 'beavis-butthead', :index_field => 
        {:index_field_name => 'band_name', :index_field_type => 'literal', :literal_options =>
          {:search_enabled => false, :result_enabled => true}}}
      migrations.connection.should_receive(:define_index_field).with(expected_index_field_request).and_return CREATE_LITERAL_INDEX_RESPONSE     
      migrations.create_index_field('BeavisButthead', 'band_name' => { 'index_field_type' => 'literal', 'search_enabled' => false})
    end

    it 'should add a text index to the domain' do
      expected_index_field_request = {:domain_name => 'beavis', :index_field => 
        {:index_field_name => 'tv_location', :index_field_type => 'text', :text_options =>
          {:result_enabled => true}}}
      migrations.connection.should_receive(:define_index_field).with(expected_index_field_request).and_return CREATE_TEXT_INDEX_RESPONSE 
      migrations.create_index_field('beavis', 'tv_location' => { 'index_field_type' => 'text'})
    end

    it 'should add a uint index to the domain' do
      expected_index_field_request = {:domain_name => 'beavis', :index_field => 
        {:index_field_name => 'num_tvs', :index_field_type => 'uint'}}
      migrations.connection.should_receive(:define_index_field).with(expected_index_field_request).and_return CREATE_UINT_INDEX_RESPONSE 
      migrations.create_index_field('beavis', 'num_tvs' => { 'index_field_type' => 'uint'})
    end
  end

  context 'domain' do

    it 'should create a domain if one doesnt exist' do
      migrations.connection.should_receive(:create_domain).with({:domain_name => 'beavis-butthead'}).and_return CREATE_DOMAIN_RESPONSE    
      migrations.create_domain 'BeavisButthead'
    end

    it 'should create indexes for all items in the domain and create the domain' do
      migrations.should_receive(:create_domain).once.with 'TestModel'
      migrations.should_receive(:create_index_field).once.with('TestModel', 
                                                               'name' => { 'index_field_type' => 'text', 
                                                                 'search_enabled' => true})
      migrations.should_receive(:create_index_field).once.with('TestModel', 
                                                               'amount' => { 'index_field_type' => 'uint', 
                                                                 'search_enabled' => true})
      migrations.should_receive(:create_index_field).once.with('TestModel', 
                                                               'last_updated' => { 'index_field_type' => 'uint', 
                                                                 'search_enabled' => false})

      migrations.migrate_domain 'TestModel'
    end
  end

  context 'migrate_all' do
    it 'should migrate all of the domains' do
      migrations.should_receive(:migrate_domain).once.with 'TestModel'
      migrations.should_receive(:migrate_domain).once.with 'HoneyBadger'
      migrations.migrate_all
    end
  end

end
