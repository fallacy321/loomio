module Translatable
  module Model
    
    def self.included(base)
      base.send :extend, ClassMethods
    end
    
    module ClassMethods
      def has_translations(fields = [], options = {})
        define_singleton_method :translatable_fields, -> { (fields.kind_of? Array) ? fields : [fields] }
        define_singleton_method :get_instance, ->(id) { send options[:load_via] || :find, id }
        send :include, InstanceMethods
        send :before_update, :clear_translations
        send :has_many, :translations, as: :translatable
      end
    end
    
    module InstanceMethods
      def translate(from_lang = author.primary_language, to_lang = I18n.locale.to_s)
        return {} if translator.nil? || to_lang.blank? || from_lang.blank? || from_lang == to_lang
        current_translations = self.translations.to_language(to_lang)
        
        self.class.translatable_fields.each do |field|
          if current_translations.where(translatable_field: field).empty?
            translated = translator.translate(self.send(field), 
                                              from: from_lang, 
                                              to: to_lang)
            translation = Translation.new(    translatable: self,
                                              translatable_field: field,
                                              translation: translated,
                                              language: to_lang)
            current_translations.push(translation) if translation.save
          end
        end
        
        current_translations.as_json.reduce({}, :merge)
      end
      
      protected
      
      def clear_translations
        self.translations.each do |translation|
          translation.destroy if self.send("#{translation.translatable_field}_changed?")
        end
      end
      
      private
      
      def translator
        @translator ||= BingTranslator.new get_env_or_fake('BING_TRANSLATE_APPID'), get_env_or_fake('BING_TRANSLATE_SECRET') rescue nil
      end
    
      def get_env_or_fake(key)
        ENV[key] || ''
      end
    end
  end
end

ActiveSupport.on_load(:active_record) do
  include Translatable::Model
end