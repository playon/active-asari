module ActiveAsari
  module ActiveRecord

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def env_test?
        (ENV['RAILS_ENV'] != 'test' and ENV['RACK_ENV'] != 'test')
      end

      def active_asari_index(class_name)
        asari_index ActiveAsari.asari_domain_name(class_name), ACTIVE_ASARI_CONFIG[class_name].symbolize_keys.keys if !env_test?
      end
    end
  end
end
