class ApplicationController < ActionController::Base
  include Pundit::Authorization
  
  protect_from_forgery with: :exception
  
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])
  end

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end

  def record_not_found
    flash[:alert] = "The requested resource was not found."
    redirect_to(request.referrer || root_path)
  end
end