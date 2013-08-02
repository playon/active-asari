module ActiveAsari

  def self.amazon_safe_domain_name(domain)
    domain.underscore.sub /_/, '-' 
  end

  module ActiveRecord

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def active_asari_index(class_name)
        asari_index ActiveAsari.amazon_safe_domain_name(class_name), ACTIVE_ASARI_CONFIG[class_name].symbolize_keys.keys 
      end
    end
  end
end
