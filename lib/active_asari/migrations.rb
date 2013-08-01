module ActiveAsari
  class Migrations

    attr_accessor :connection

    def initialize 
      self.connection = AWS::CloudSearch::Client.new
    end

    def migrate_all
    end

    def migrate_domain(domain)
            #ACTIVE_ASARI_CONFIG[class_name].symbolize_keys.each do |index|

      #end
    end

    def create_index_field(domain, field)
      index_field_name = field.keys.first
      index_field_type = field[index_field_name]['index_field_type']
      search_enabled = (field[index_field_name]['search_enabled'].downcase.strip == 'true')
      request = {:domain_name => domain, :index_field => {:index_field_name => index_field_name,
      :index_field_type => index_field_type, :literal_options => {:search_enabled => search_enabled, :result_enabled => true}}}
      connection.create_index_field request
    end

    def create_domain(domain)
      connection.create_domain :domain_name => domain        
    end
  end
end
