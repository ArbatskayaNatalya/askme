class ApplicationController < ActionController::Base
  around_action :switch_locale
  protect_from_forgery with: :exception
  helper_method :current_user

  private

  def switch_locale(&action)
    locale = params[:locale] || I18n.default_locale
    I18n.with_locale locale, &action
  end


  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def reject_user
    redirect_to root_path, alert: 'У вас недостаточно прав для совершения данного действия!'
  end
end
