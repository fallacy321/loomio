class TranslationsController < BaseController
  skip_before_filter :authenticate_user!, only: :translate
  before_filter :load_translation, only: :translate
  
  def translate  
    model = params[:model].to_s.downcase
    render :template => "#{model.pluralize}/#{model}_translations"
  end
  
  private
  
  def load_translation
    instance = Translatable.get_instance params[:model], params[:id]
    @translation = instance.translate if instance.present?
  end

end