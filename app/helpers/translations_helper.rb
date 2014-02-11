module TranslationsHelper
  
  def show_translation_links?(model)
    model.language != I18n.locale.to_s
  end
  
  def translate_link(model, id, css='')
    link_to t(:translate_this_string, language: current_language), translate_path(model: model, id: id), method: :post, remote: true, class: "translate-link #{css}", id: "translate-#{model}-#{id}" 
  end
  
  def get_translation(translation, field, show_error = true)
    field = field.to_s
    message = if valid_translation? translation, field 
                translation[field]
              elsif show_error                         
                t(:failed_translation)
              else                                          
                '' 
              end
    escape_javascript(message).html_safe
  end
  
  private
  
  def valid_translation?(translation, field)
    translation.present? && translation[field].present?
  end
  
end
