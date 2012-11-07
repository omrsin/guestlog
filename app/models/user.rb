# encoding: utf-8

class User < ActiveRecord::Base
  attr_accessible :email, :first_name, :is_active, :is_admin, :last_name, :password, :phone, :username
  
  has_many :visits
  
  VALID_NAME_REGEX = /^[a-zA-ZáÁéÉíÍóÓúÚüÜñÑ]*$/i
  
  validates :username, presence: true,
  										 uniqueness: true
  validates :password, presence: true
  validates :first_name, presence: true, format: { with: VALID_NAME_REGEX }
  validates :last_name, presence: true, format: { with: VALID_NAME_REGEX }
  validates :email, presence: true  
  
  before_save { |user| user.username = username.downcase }
  before_save :create_remember_token
  
  def authenticate(pass)
  	is_active? && password == pass 
  end
  
  def create_remember_token
		self.remember_token = SecureRandom.urlsafe_base64  	
  end
end
