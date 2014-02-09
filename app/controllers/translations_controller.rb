class TranslationsController < BaseController
  skip_before_filter :authenticate_user!, only: :translate
  before_filter :load_translation, only: :translate
  
  def translate  
    render :template => "#{params[:model].to_s.downcase.pluralize}/#{params[:model].to_s.downcase}_translations"
  end
  
  def load_translation
    model = params[:model].to_s.humanize.constantize
    instance = if model == Discussion then model.published.find_by_key! params[:id]
               else                        model.find(params[:id]) end
    @translation = instance.translate if instance.present?
  end

end