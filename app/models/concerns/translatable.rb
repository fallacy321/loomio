module Translatable
  extend ActiveSupport::Concern
  
  included do
    before_update :clear_translations
    has_many :translations, as: :translatable
  end
  
  def self.get_instance(model, id)
    model = model.to_s.humanize.constantize
    if model == Discussion 
      model.published.find_by_key! id
    else                        
      model.find id
    end
  end

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