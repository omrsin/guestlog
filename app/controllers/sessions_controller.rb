# encoding: utf-8

class SessionsController < ApplicationController

	def new
		
	end
	
	def create
		user = User.find_by_username(params[:session][:username].downcase)
		if user && user.authenticate(params[:session][:password])
    	sign_in user
	   	redirect_back_or root_url
    else
    	if user && user.active
      	flash.now[:error] = 'Combinación Inválida!'
      else 
      	if user && !user.active
      		flash.now[:error] = 'Usuario desactivado'
      	else
      		flash.now[:error] = 'Combinación Inválida!'
      	end
      end
      render 'new'      
    end
	end
	
	def destroy
		sign_out
    redirect_to signin_url
	end

end
