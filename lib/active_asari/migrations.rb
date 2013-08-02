module ActiveAsari
  class Migrations

    attr_accessor :connection

    def initialize 
      self.connection = AWS::CloudSearch::Client.new
    end

    def migrate_all
      ACTIVE_ASARI_CONFIG.keys.each do |domain|
        amazon_domain = domain.underscore.sub /_/, '-' 
        migrate_domain amazon_domain
      end
    end

    def migrate_domain(domain)
      create_domain domain
      ACTIVE_ASARI_CONFIG[domain].each do |field|
        create_index_field domain, field.first => field.last
      end
    end

    def create_index_field(domain, field)
      index_field_name = field.keys.first
      index_field_type = field[index_field_name]['index_field_type']
      search_enabled = (field[index_field_name]['search_enabled'] and (field[index_field_name]['search_enabled'].downcase.strip == 'true'))

      request = {:domain_name => domain, :index_field => {:index_field_name => index_field_name,
      :index_field_type => index_field_type}}
      case index_field_type 
      when 'literal'
        request[:index_field][:literal_options] = {:search_enabled => search_enabled, :result_enabled => true}
      when 'text'
        request[:index_field][:text_options] = {:result_enabled => true}
      end
      connection.define_index_field request
    end

    def create_domain(domain)
      connection.create_domain :domain_name => domain        
    end
  end
end
