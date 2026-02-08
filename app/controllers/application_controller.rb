# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up,
                                      keys: %i[type name phone company_name company_address prefecture skills bio
                                               years_of_experience])
    devise_parameter_sanitizer.permit(:account_update,
                                      keys: %i[name phone company_name company_address prefecture skills bio
                                               years_of_experience])
  end
end
