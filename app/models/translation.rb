class Translation < ActiveRecord::Base
  LANGUAGES = {"English" => "en",
               "български" => "bg",
               "Català" => "ca",
               "Deutsch" => "de",
               "Español" => "es",
               "ελληνικά" => "el",
               "Français" => "fr",
               "Indonesian" => "id",
               "magyar" => "hu",
               "Nederlands" => "nl",
               "Português (Brasil)" => "pt",
               "română" => "ro",
               "Tiếng Việt" => "vi"}
  EXPERIMENTAL_LANGUAGES = {"Italiano" => "it",
                            "čeština" => "cs",
                            'Irish (Ireland)' => 'ga'}

  belongs_to :translatable, polymorphic: true
  
  scope :to_language, ->(language) { where(language: language) }

  validates_presence_of :translatable, :translatable_field, :language
  
  before_save :null_translation_if_invalid
  
  def null_translation_if_invalid
    self.translation = nil if self.translation == self.translatable.send(self.translatable_field) || self.translation.blank?
  end
  
  def as_json
    { "#{translatable_field}" => "#{translation}", id: translatable_id }
  end
  
  def self.language(locale)
    LANGUAGES.key(locale)
  end

  def self.locales
    LANGUAGES.values
  end

  def self.experimental_locales
    EXPERIMENTAL_LANGUAGES.values
  end

  def self.language_link_attributes(language)
    { href: "?&locale=#{language[1]}"  ,
      title: "#{I18n.t(:change_language, language: language[0])}",
      text: "#{language[0]}" }
  end
  
end