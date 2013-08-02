module ActiveAsari

  def self.amazon_safe_domain_name(domain)
    domain.underscore.sub /_/, '-' 
  end

  def self.aws_client
    AWS::CloudSearch::Client.new
  end

  def self.asari_domain_name(domain)
    amazon_domain = amazon_safe_domain_name domain
    domain_data = aws_client.describe_domains[:domain_status_list].select { |domain_data|  
      domain_data[:domain_name] == amazon_domain}
    domain_data.first[:search_service][:endpoint].split('.').first[7..-1]
  end

  module ActiveRecord

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def active_asari_index(class_name)
        asari_index ActiveAsari.asari_domain_name(class_name), ACTIVE_ASARI_CONFIG[class_name].symbolize_keys.keys 
      end
    end
  end
end
