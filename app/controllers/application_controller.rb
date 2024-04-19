class ApplicationController < ActionController::Base
  # include CurrentUserExtensions
  include Pagy::Backend

  before_action :authenticate_user!
end
