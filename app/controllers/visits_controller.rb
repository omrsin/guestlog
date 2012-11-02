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
		@visits = current_user.visits
	end
	
	private
	
	def create_image
		unless @visit.image_code == ''
			File.open("#{Rails.root}/public/snapshot_temp.png", 'wb') do |f|
		    f.write(Base64.decode64(@visit.image_code))
		  end
		  @visit.image_code = ''
		  @visit.image = File.open("#{Rails.root}/public/snapshot_temp.png")
		end
  end
end
