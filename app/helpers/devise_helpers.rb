module DeviseHelpers
  def devise_sign_up_page?
    result = (controller_name == 'registrations' && action_name.in?(['new', 'create'])) && !user_signed_in?
    Rails.logger.debug "Devise SignUp Page Check: #{result}"
    result
  end

  def devise_login_page?
    result = (controller_name == 'sessions' && action_name.in?(['new', 'create'])) && !user_signed_in?
    Rails.logger.debug "Devise LoginPage Check: #{result}"
    result
  end
end
