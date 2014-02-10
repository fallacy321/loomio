class TranslationsController < ApplicationController
 
  def translate  
    model = params[:model].to_s.downcase
    @translation = model.humanize.constantize.get_instance(params[:id]).translate
    render :template => "#{model.pluralize}/#{model}_translations"
  end
  
end