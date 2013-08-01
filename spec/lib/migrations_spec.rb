require 'spec_helper'
require 'lib/migrations_spec_data'
include MigrationsSpecData

describe 'migrations' do

  let(:migrations) {ActiveAsari::Migrations.new}

  before :each do
      
  end

  context 'index_field' do
    it 'should add a literal index to the domain' do
      expected_index_field_request = {:domain_name => 'beavis', :index_field => 
        {:index_field_name => 'band_name', :index_field_type => 'literal', :literal_options =>
          {:search_enabled => false, :result_enabled => true}}}
      migrations.connection.should_receive(:create_index_field).with(expected_index_field_request).and_return CREATE_LITERAL_INDEX_RESPONSE     
      migrations.create_index_field('beavis', 'band_name' => { 'index_field_type' => 'literal', 'search_enabled' => 'false'})
      
    end

    it 'should add a text index to the domain' do
      expected_index_field_request = {:domain_name => 'beavis', :index_field => 
        {:index_field_name => 'band_name', :index_field_type => 'literal', :literal_options =>
          {:search_enabled => false, :result_enabled => true}}}
      
      
    end
  end

  context 'domain' do

    it 'should create a domain if one doesnt exist' do
      migrations.connection.should_receive(:create_domain).with({:domain_name => 'beavis'}).and_return CREATE_DOMAIN_RESPONSE    
      migrations.create_domain 'beavis'
    end

  end

end
