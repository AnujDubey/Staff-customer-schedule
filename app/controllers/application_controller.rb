class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_filter :configure_permitted_parameters, if: :devise_controller?

  # Overriding the method of devise gem to change the path.
  def after_sign_in_path_for(resource)
    if resource[:role_id] == 2
      if resource[:sign_in_count] >= 1
         staffs_profile_users_path
      else
         staffs_signup_users_path
     end
    else
      if resource[:role_id] == 1
        profile_admins_path
      else
        profile_users_path
      end
    end
  end
  
  protected

    # Permission of Parameters
    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) << :firstname
      devise_parameter_sanitizer.for(:sign_up) << :lastname
      devise_parameter_sanitizer.for(:account_update) { |u| 
        u.permit(:password, :password_confirmation, :current_password) 
      }
    end

end