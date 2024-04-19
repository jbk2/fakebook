module CurrentUserExtensions
  extend ActiveSupport::Concern

  included do
    alias_method :devise_current_user, :current_user

    # Override the current_user method to include the profile_photo
    def current_user
      if devise_current_user
        @cached_current_user ||= User.includes(:profile_photo_attachment).find(devise_current_user.id)
      end
    end
  end
end
