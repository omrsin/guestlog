# encoding: utf-8

class VisitsController < ApplicationController
	before_filter :signed_in_user

	def new
		@visit = Visit.new
	end

	def create
		@visit = Visit.new(params[:visit])
		@guest = Guest.find_by_id_document(params[:guest][:id_document])
		
		if @guest.nil?
  		@guest = Guest.new(params[:guest])
  		@guest.save
		end
			
  	@visit.guest = @guest
  	@visit.user = current_user
  	
		create_image
		
  	if @visit.save
    	flash[:success] = "Se ha registrado la visita"
    	redirect_to root_path
    else
    	render 'new'
    end
	end
	
	def index
		@visit_from = params[:visit_from] || DateTime.current.beginning_of_day
		@visit_to 	 = params[:visit_to] || DateTime.current.end_of_day
		validate_dates
		@visits = current_user.visits.
							where(created_at: @visit_from..@visit_to).
							order("created_at DESC").
							page(params[:page]).per_page(10)
	end
	
	def show
		@visit = Visit.find(params[:id])
	end
	
	private
	
	def create_image
		unless @visit.image_code == ''
			File.open("#{Rails.root}/public/visit_#{@visit.id}.png", 'wb') do |f|
		    f.write(Base64.decode64(@visit.image_code))
		  end
		  @visit.image_code = ''
		  @visit.image = File.open("#{Rails.root}/public/visit_#{@visit.id}.png")
		end
  end
  
  def validate_dates
  	if @visit_from == '' && @visit_to == ''
  		@visit_from = DateTime.current.beginning_of_day
  		@visit_to = DateTime.current.end_of_day
  	elsif (@visit_from=='' && @visit_to!='') || (@visit_from!='' && @visit_to=='')
  		flash.now[:error] = 'Combinación de fechas inválida'
  		@visit_from = DateTime.current.beginning_of_day
  		@visit_to = DateTime.current.end_of_day
  	else
  		@visit_from = @visit_from.to_date.to_time_in_current_zone.beginning_of_day
  		@visit_to = @visit_to.to_date.to_time_in_current_zone.end_of_day
		end
  end
  
end
