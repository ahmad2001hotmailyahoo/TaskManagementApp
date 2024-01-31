class ApplicationController < ActionController::Base
    before_action :configure_permitted_parameters, if: :devise_controller?
    protect_from_forgery with: :exception
    include Pundit::Authorization

    # def authenticate_admin_user! #use predefined method name
    #   redirect_to '/' and return if user_signed_in? && !current_user.is_admin? 
    #   authenticate_user! 
    # end 
    # def current_admin_user #use predefined method name
    #   return nil if user_signed_in? && !current_user.is_admin? 
    #   current_user 
    # end 

    # def after_sign_in_path_for(resource)
    #   root_path # your path
    # end

    protected
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:full_name,:date_of_birth, :gender])
      devise_parameter_sanitizer.permit(:account_update, keys: [:full_name, :date_of_birth, :gender])
    end
  end
  