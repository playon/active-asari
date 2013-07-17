class ActiveAsari
  module ActiveRecord

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def active_asari_index(class_name)
        asari_index ACTIVE_ASARI_SEARCH_DOMAIN, ACTIVE_ASARI_CONFIG[class_name].symbolize_keys.keys 
      end
    end
  end
end
