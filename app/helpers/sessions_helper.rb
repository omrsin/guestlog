# encoding: utf-8

module SessionsHelper
	def sign_in(user)
    cookies[:remember_token] = {value: user.remember_token,
    														expires: 1.day.from_now.in_time_zone('Caracas').beginning_of_day}
    self.current_user= user
  end
  
  def current_user=(user)
  	@current_user = user
  end
  	
  def current_user
  	@current_user ||= User.find_by_remember_token(cookies[:remember_token])
  end
  
  def signed_in?
  	!current_user.nil?
  end
  
  def sign_out
  	self.current_user = nil
    cookies.delete(:remember_token)
  end
  
  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.url
  end

  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_url, notice: "Por favor inicie sesión."
    end
  end
end
