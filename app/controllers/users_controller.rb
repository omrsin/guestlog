# encoding: utf-8

class UsersController < ApplicationController
	before_filter :signed_in_user
	before_filter :is_admin_user

  def new
  	@user = User.new
  end

  def create
  	@user = User.new(params[:user])
  	@user.is_active = true
  	
  	if @user.save
 			flash[:success] = "Se ha registrado un nuevo usuario"
    	redirect_to users_path
    else
    	render 'new'  	
  	end
  end

  def index
  	@users = User.page(params[:page]).per_page(10)
  end
  
  def edit
  	@user = User.find(params[:id])
  end
  
  def update
  	@user = User.find(params[:id])
  
  	params[:user].delete(:password) if params[:user][:password] == ''
  
  	if @user.update_attributes(params[:user])
 			flash[:success] = "Se ha actualizado el usuario"
    	redirect_to users_path
    else
    	render 'edit' 	
  	end
  end
  
  def show
  	@user = User.find(params[:id])
  	@user.is_active = true
  	if @user.save
  		flash[:success] = "Usuario activado"
  		redirect_to users_url
  	else
  		flash[:error] = "Ha ocurrido un error, el usuario no ha podido ser activado"
  	end
  end
  
  def destroy
  	@user = User.find(params[:id])
  	@user.is_active = false
  	if @user.save
  		flash[:success] = "Usuario desactivado"
  		redirect_to users_url
  	else
  		flash[:error] = "Ha ocurrido un error, el usuario no ha podido ser desactivado"
  	end
  end
end
