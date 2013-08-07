module ActiveAsari
  module ActiveRecord

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def active_asari_index(class_name)
        asari_index ActiveAsari.asari_domain_name(class_name), ACTIVE_ASARI_CONFIG[class_name].symbolize_keys.keys if (ENV['RAILS_ENV'] != 'test' and ENV['RACK_ENV'] != 'test')
      end
    end
  end
end
