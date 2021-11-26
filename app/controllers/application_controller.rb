class ApplicationController < ActionController::Base
  around_action :switch_locale
  protect_from_forgery with: :exception
  helper_method :current_user

  private

  def switch_locale(&action)
    locale = locale_from_url || locale_from_header || I18n.default_locale
    I18n.with_locale locale, &action
  end

  def locale_from_url
    locale = params[:locale]
    return locale if I18n.available_locales.map(&:to_s).include?(locale)
  end

  def locale_from_header
    I18n.locale = http_accept_language.compatible_language_from(I18n.available_locales)
  end

  def default_url_options
    { locale: I18n.locale }
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def reject_user
    redirect_to root_path, alert: 'У вас недостаточно прав для совершения данного действия!'
  end
end
