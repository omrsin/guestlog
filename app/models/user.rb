# encoding: utf-8

class User < ActiveRecord::Base
  attr_accessible :email, :first_name, :is_active, :is_admin, :last_name, :password, :phone, :username
  
  has_many :visits
  
  VALID_NAME_REGEX = /^[a-zA-ZáÁéÉíÍóÓúÚüÜñÑ]*$/i
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  VALID_USERNAME_REGEX = /^[a-zA-Z\d]*$/i
  
  validates :username, presence: true,
  										 uniqueness: true,
  										 format: { with: VALID_USERNAME_REGEX },
  										 length: { maximum: 15 } 
  validates :password, presence: true
  validates :first_name, presence: true, format: { with: VALID_NAME_REGEX }, length: { maximum: 20 }
  validates :last_name, presence: true, format: { with: VALID_NAME_REGEX }, length: { maximum: 20 }
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, length: { maximum: 30 }  
  validates :phone, numericality: true, length: { maximum: 15 }
  
  before_save { |user| user.username = username.downcase }
  before_save :create_remember_token
  
  def authenticate(pass)
  	is_active? && password == pass 
  end
  
  def create_remember_token
		self.remember_token = SecureRandom.urlsafe_base64  	
  end
end
