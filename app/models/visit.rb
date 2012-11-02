class Visit < ActiveRecord::Base
	require 'base64'
	
	attr_accessor :image_code 
	
  attr_accessible :contact, :image, :image_code
  
  mount_uploader :image, ImageUploader
  
  belongs_to :user
  belongs_to :guest
  
  validates :user_id, presence: true
  validates :guest_id, presence: true
  validates :image, presence: true
end
